COMMENT=	OpenBSD installer images for the asahi-installer

V=		7.4
DISTNAME=	asahi-installer-images-${V}

SITES.ftp=	http://ftp.openbsd.org/pub/OpenBSD/${V}/arm64/
SITES.fw=	http://firmware.openbsd.org/firmware/${V}/

DISTFILES.ftp=	BOOTAA64.EFI \
		bsd.rd 
DISTFILES.fw=	apple-boot-firmware-1.1.tgz

EXTRACT_ONLY=	apple-boot-firmware-1.1.tgz

CATEGORIES=	sysutils
MAINTAINER=	Tobias Heider <tobhe@openbsd.org>

# MIT
PERMIT_PACKAGE=	Yes
BUILD_DEPENDS+=	archivers/zip
NO_TEST=	Yes

do-build:
	# Create apple-boot only zip
	mkdir -p ${WRKSRC}/esp/m1n1
	cp ${WRKDIR}/firmware/apple-boot.bin ${WRKSRC}/esp/m1n1/boot.bin
	cd ${WRKSRC} && zip -1 -r apple-boot-${V}.zip esp

	# OpenBSD installer zip
	mkdir -p ${WRKSRC}/esp/efi/boot
	cp ${FULLDISTDIR}/BOOTAA64.EFI ${WRKSRC}/esp/efi/boot/bootaa64.efi
	echo "bootaa64.efi" > ${WRKSRC}/esp/efi/boot/startup.nsh
	cp ${FULLDISTDIR}/bsd.rd ${WRKSRC}/esp/bsd
	cd ${WRKSRC} && zip -1 -r openbsd-${V}.zip esp

do-install:
	${INSTALL_DATA_DIR} ${PREFIX}/share/asahi-installer-images
	cp ${WRKSRC}/*.zip ${PREFIX}/share/asahi-installer-images

.include <bsd.port.mk>
