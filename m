From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-mtd.patch removed from -mm tree
Date: Sat, 21 Apr 2007 21:12:26 -0700
Message-ID: <200704220412.l3M4CQtt019290@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47982 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964862AbXDVEMq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 22 Apr 2007 00:12:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@linux01.gwdg.de, dwmw2@infradead.org, jengelh@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Use menuconfig objects: MTD
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-mtd.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
Subject: Use menuconfig objects: MTD
=46rom: Jan Engelhardt <jengelh@linux01.gwdg.de>

Use menuconfigs instead of menus, so the whole menu can be disabled at =
once
instead of going through all options.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/Kconfig         |   30 ++++++++------------
 drivers/mtd/chips/Kconfig   |   12 ++------
 drivers/mtd/devices/Kconfig |   18 ++++--------
 drivers/mtd/maps/Kconfig    |    8 ++---
 drivers/mtd/nand/Kconfig    |   49 +++++++++++++++-------------------
 drivers/mtd/onenand/Kconfig |   13 +++------
 6 files changed, 52 insertions(+), 78 deletions(-)

diff -puN drivers/mtd/Kconfig~use-menuconfig-objects-mtd drivers/mtd/Kc=
onfig
--- a/drivers/mtd/Kconfig~use-menuconfig-objects-mtd
+++ a/drivers/mtd/Kconfig
@@ -1,8 +1,6 @@
 # $Id: Kconfig,v 1.11 2005/11/07 11:14:19 gleixner Exp $
=20
-menu "Memory Technology Devices (MTD)"
-
-config MTD
+menuconfig MTD
 	tristate "Memory Technology Device (MTD) support"
 	help
 	  Memory Technology Devices are flash, RAM and similar chips, often
@@ -13,9 +11,10 @@ config MTD
 	  them. It will also allow you to select individual drivers for
 	  particular hardware and users of MTD devices. If unsure, say N.
=20
+if MTD
+
 config MTD_DEBUG
 	bool "Debugging"
-	depends on MTD
 	help
 	  This turns on low-level debugging for the entire MTD sub-system.
 	  Normally, you should say 'N'.
@@ -29,7 +28,6 @@ config MTD_DEBUG_VERBOSE
=20
 config MTD_CONCAT
 	tristate "MTD concatenating support"
-	depends on MTD
 	help
 	  Support for concatenating several MTD devices into a single
 	  (virtual) one. This allows you to have -for example- a JFFS(2)
@@ -38,7 +36,6 @@ config MTD_CONCAT
=20
 config MTD_PARTITIONS
 	bool "MTD partitioning support"
-	depends on MTD
 	help
 	  If you have a device which needs to divide its flash chip(s) up
 	  into multiple 'partitions', each of which appears to the user as
@@ -153,11 +150,9 @@ config MTD_AFS_PARTS
 	  'armflash' map driver (CONFIG_MTD_ARMFLASH) does this, for example.
=20
 comment "User Modules And Translation Layers"
-	depends on MTD
=20
 config MTD_CHAR
 	tristate "Direct char device access to MTD devices"
-	depends on MTD
 	help
 	  This provides a character device for each MTD device present in
 	  the system, allowing the user to read and write directly to the
@@ -166,12 +161,12 @@ config MTD_CHAR
=20
 config MTD_BLKDEVS
 	tristate "Common interface to block layer for MTD 'translation layers=
'"
-	depends on MTD && BLOCK
+	depends on BLOCK
 	default n
=20
 config MTD_BLOCK
 	tristate "Caching block device access to MTD devices"
-	depends on MTD && BLOCK
+	depends on BLOCK
 	select MTD_BLKDEVS
 	---help---
 	  Although most flash chips have an erase size too large to be useful
@@ -194,7 +189,7 @@ config MTD_BLOCK
=20
 config MTD_BLOCK_RO
 	tristate "Readonly block device access to MTD devices"
-	depends on MTD_BLOCK!=3Dy && MTD && BLOCK
+	depends on MTD_BLOCK!=3Dy && BLOCK
 	select MTD_BLKDEVS
 	help
 	  This allows you to mount read-only file systems (such as cramfs)
@@ -206,7 +201,7 @@ config MTD_BLOCK_RO
=20
 config FTL
 	tristate "FTL (Flash Translation Layer) support"
-	depends on MTD && BLOCK
+	depends on BLOCK
 	select MTD_BLKDEVS
 	---help---
 	  This provides support for the original Flash Translation Layer whic=
h
@@ -223,7 +218,7 @@ config FTL
=20
 config NFTL
 	tristate "NFTL (NAND Flash Translation Layer) support"
-	depends on MTD && BLOCK
+	depends on BLOCK
 	select MTD_BLKDEVS
 	---help---
 	  This provides support for the NAND Flash Translation Layer which is
@@ -247,7 +242,7 @@ config NFTL_RW
=20
 config INFTL
 	tristate "INFTL (Inverse NAND Flash Translation Layer) support"
-	depends on MTD && BLOCK
+	depends on BLOCK
 	select MTD_BLKDEVS
 	---help---
 	  This provides support for the Inverse NAND Flash Translation
@@ -265,7 +260,7 @@ config INFTL
=20
 config RFD_FTL
         tristate "Resident Flash Disk (Flash Translation Layer) suppor=
t"
-	depends on MTD && BLOCK
+	depends on BLOCK
 	select MTD_BLKDEVS
 	---help---
 	  This provides support for the flash translation layer known
@@ -276,7 +271,7 @@ config RFD_FTL
=20
 config SSFDC
 	tristate "NAND SSFDC (SmartMedia) read only translation layer"
-	depends on MTD && BLOCK
+	depends on BLOCK
 	select MTD_BLKDEVS
 	help
 	  This enables read only access to SmartMedia formatted NAND
@@ -294,5 +289,4 @@ source "drivers/mtd/onenand/Kconfig"
=20
 source "drivers/mtd/ubi/Kconfig"
=20
-endmenu
-
+endif # MTD
diff -puN drivers/mtd/chips/Kconfig~use-menuconfig-objects-mtd drivers/=
mtd/chips/Kconfig
--- a/drivers/mtd/chips/Kconfig~use-menuconfig-objects-mtd
+++ a/drivers/mtd/chips/Kconfig
@@ -6,7 +6,6 @@ menu "RAM/ROM/Flash chip drivers"
=20
 config MTD_CFI
 	tristate "Detect flash chips by Common Flash Interface (CFI) probe"
-	depends on MTD
 	select MTD_GEN_PROBE
 	help
 	  The Common Flash Interface specification was developed by Intel,
@@ -18,7 +17,6 @@ config MTD_CFI
=20
 config MTD_JEDECPROBE
 	tristate "Detect non-CFI AMD/JEDEC-compatible flash chips"
-	depends on MTD
 	select MTD_GEN_PROBE
 	help
 	  This option enables JEDEC-style probing of flash chips which are no=
t
@@ -213,21 +211,18 @@ config MTD_CFI_UTIL
=20
 config MTD_RAM
 	tristate "Support for RAM chips in bus mapping"
-	depends on MTD
 	help
 	  This option enables basic support for RAM chips accessed through
 	  a bus mapping driver.
=20
 config MTD_ROM
 	tristate "Support for ROM chips in bus mapping"
-	depends on MTD
 	help
 	  This option enables basic support for ROM chips accessed through
 	  a bus mapping driver.
=20
 config MTD_ABSENT
 	tristate "Support for absent chips in bus mapping"
-	depends on MTD
 	help
 	  This option enables support for a dummy probing driver used to
 	  allocated placeholder MTD devices on systems that have socketed
@@ -237,7 +232,6 @@ config MTD_ABSENT
 	  with this driver will return -ENODEV upon access.
=20
 config MTD_OBSOLETE_CHIPS
-	depends on MTD
 	bool "Older (theoretically obsoleted now) drivers for non-CFI chips"
 	help
 	  This option does not enable any code directly, but will allow you t=
o
@@ -250,7 +244,7 @@ config MTD_OBSOLETE_CHIPS
=20
 config MTD_AMDSTD
 	tristate "AMD compatible flash chip support (non-CFI)"
-	depends on MTD && MTD_OBSOLETE_CHIPS && BROKEN
+	depends on MTD_OBSOLETE_CHIPS && BROKEN
 	help
 	  This option enables support for flash chips using AMD-compatible
 	  commands, including some which are not CFI-compatible and hence
@@ -260,7 +254,7 @@ config MTD_AMDSTD
=20
 config MTD_SHARP
 	tristate "pre-CFI Sharp chip support"
-	depends on MTD && MTD_OBSOLETE_CHIPS
+	depends on MTD_OBSOLETE_CHIPS
 	help
 	  This option enables support for flash chips using Sharp-compatible
 	  commands, including some which are not CFI-compatible and hence
@@ -268,7 +262,7 @@ config MTD_SHARP
=20
 config MTD_JEDEC
 	tristate "JEDEC device support"
-	depends on MTD && MTD_OBSOLETE_CHIPS && BROKEN
+	depends on MTD_OBSOLETE_CHIPS && BROKEN
 	help
 	  Enable older JEDEC flash interface devices for self
 	  programming flash.  It is commonly used in older AMD chips.  It is
diff -puN drivers/mtd/devices/Kconfig~use-menuconfig-objects-mtd driver=
s/mtd/devices/Kconfig
--- a/drivers/mtd/devices/Kconfig~use-menuconfig-objects-mtd
+++ a/drivers/mtd/devices/Kconfig
@@ -6,7 +6,7 @@ menu "Self-contained MTD device drivers"
=20
 config MTD_PMC551
 	tristate "Ramix PMC551 PCI Mezzanine RAM card support"
-	depends on MTD && PCI
+	depends on PCI
 	---help---
 	  This provides a MTD device driver for the Ramix PMC551 RAM PCI card
 	  from Ramix Inc. <http://www.ramix.com/products/memory/pmc551.html>.
@@ -40,7 +40,7 @@ config MTD_PMC551_DEBUG
=20
 config MTD_MS02NV
 	tristate "DEC MS02-NV NVRAM module support"
-	depends on MTD && MACH_DECSTATION
+	depends on MACH_DECSTATION
 	help
 	  This is an MTD driver for the DEC's MS02-NV (54-20948-01) battery
 	  backed-up NVRAM module.  The module was originally meant as an NFS
@@ -54,7 +54,7 @@ config MTD_MS02NV
=20
 config MTD_DATAFLASH
 	tristate "Support for AT45xxx DataFlash"
-	depends on MTD && SPI_MASTER && EXPERIMENTAL
+	depends on SPI_MASTER && EXPERIMENTAL
 	help
 	  This enables access to AT45xxx DataFlash chips, using SPI.
 	  Sometimes DataFlash chips are packaged inside MMC-format
@@ -62,7 +62,7 @@ config MTD_DATAFLASH
=20
 config MTD_M25P80
 	tristate "Support for M25 SPI Flash"
-	depends on MTD && SPI_MASTER && EXPERIMENTAL
+	depends on SPI_MASTER && EXPERIMENTAL
 	help
 	  This enables access to ST M25P80 and similar SPI flash chips,
 	  used for program and data storage.  Set up your spi devices
@@ -70,7 +70,6 @@ config MTD_M25P80
=20
 config MTD_SLRAM
 	tristate "Uncached system RAM"
-	depends on MTD
 	help
 	  If your CPU cannot cache all of the physical memory in your machine=
,
 	  you can still use it for storage or swap by using this driver to
@@ -78,7 +77,6 @@ config MTD_SLRAM
=20
 config MTD_PHRAM
 	tristate "Physical system RAM"
-	depends on MTD
 	help
 	  This is a re-implementation of the slram driver above.
=20
@@ -88,7 +86,7 @@ config MTD_PHRAM
=20
 config MTD_LART
 	tristate "28F160xx flash driver for LART"
-	depends on SA1100_LART && MTD
+	depends on SA1100_LART
 	help
 	  This enables the flash driver for LART. Please note that you do
 	  not need any mapping/chip driver for LART. This one does it all
@@ -96,7 +94,6 @@ config MTD_LART
=20
 config MTD_MTDRAM
 	tristate "Test driver using RAM"
-	depends on MTD
 	help
 	  This enables a test MTD device driver which uses vmalloc() to
 	  provide storage.  You probably want to say 'N' unless you're
@@ -136,7 +133,7 @@ config MTDRAM_ABS_POS
=20
 config MTD_BLOCK2MTD
 	tristate "MTD using block device"
-	depends on MTD && BLOCK
+	depends on BLOCK
 	help
 	  This driver allows a block device to appear as an MTD. It would
 	  generally be used in the following cases:
@@ -150,7 +147,6 @@ comment "Disk-On-Chip Device Drivers"
=20
 config MTD_DOC2000
 	tristate "M-Systems Disk-On-Chip 2000 and Millennium (DEPRECATED)"
-	depends on MTD
 	select MTD_DOCPROBE
 	select MTD_NAND_IDS
 	---help---
@@ -173,7 +169,6 @@ config MTD_DOC2000
=20
 config MTD_DOC2001
 	tristate "M-Systems Disk-On-Chip Millennium-only alternative driver (=
DEPRECATED)"
-	depends on MTD
 	select MTD_DOCPROBE
 	select MTD_NAND_IDS
 	---help---
@@ -195,7 +190,6 @@ config MTD_DOC2001
=20
 config MTD_DOC2001PLUS
 	tristate "M-Systems Disk-On-Chip Millennium Plus"
-	depends on MTD
 	select MTD_DOCPROBE
 	select MTD_NAND_IDS
 	---help---
diff -puN drivers/mtd/maps/Kconfig~use-menuconfig-objects-mtd drivers/m=
td/maps/Kconfig
--- a/drivers/mtd/maps/Kconfig~use-menuconfig-objects-mtd
+++ a/drivers/mtd/maps/Kconfig
@@ -6,7 +6,6 @@ menu "Mapping drivers for chip access"
=20
 config MTD_COMPLEX_MAPPINGS
 	bool "Support non-linear mappings of flash chips"
-	depends on MTD
 	help
 	  This causes the chip drivers to allow for complicated
 	  paged mappings of flash chips.
@@ -550,7 +549,7 @@ config MTD_OMAP_NOR
 # This needs CFI or JEDEC, depending on the cards found.
 config MTD_PCI
 	tristate "PCI MTD driver"
-	depends on MTD && PCI && MTD_COMPLEX_MAPPINGS
+	depends on PCI && MTD_COMPLEX_MAPPINGS
 	help
 	  Mapping for accessing flash devices on add-in cards like the Intel =
XScale
 	  IQ80310 card, and the Intel EBSA285 card in blank ROM programming m=
ode
@@ -560,7 +559,7 @@ config MTD_PCI
=20
 config MTD_PCMCIA
 	tristate "PCMCIA MTD driver"
-	depends on MTD && PCMCIA && MTD_COMPLEX_MAPPINGS && BROKEN
+	depends on PCMCIA && MTD_COMPLEX_MAPPINGS && BROKEN
 	help
 	  Map driver for accessing PCMCIA linear flash memory cards. These
 	  cards are usually around 4-16MiB in size. This does not include
@@ -624,13 +623,12 @@ config MTD_BAST_MAXSIZE
=20
 config MTD_SHARP_SL
 	bool "ROM mapped on Sharp SL Series"
-	depends on MTD && ARCH_PXA
+	depends on ARCH_PXA
 	help
 	  This enables access to the flash chip on the Sharp SL Series of PDA=
s.
=20
 config MTD_PLATRAM
 	tristate "Map driver for platform device RAM (mtd-ram)"
-	depends on MTD
 	select MTD_RAM
 	help
 	  Map driver for RAM areas described via the platform device
diff -puN drivers/mtd/nand/Kconfig~use-menuconfig-objects-mtd drivers/m=
td/nand/Kconfig
--- a/drivers/mtd/nand/Kconfig~use-menuconfig-objects-mtd
+++ a/drivers/mtd/nand/Kconfig
@@ -1,10 +1,7 @@
 # drivers/mtd/nand/Kconfig
 # $Id: Kconfig,v 1.35 2005/11/07 11:14:30 gleixner Exp $
=20
-menu "NAND Flash Device Drivers"
-	depends on MTD!=3Dn
-
-config MTD_NAND
+menuconfig MTD_NAND
 	tristate "NAND Device Support"
 	depends on MTD
 	select MTD_NAND_IDS
@@ -13,9 +10,10 @@ config MTD_NAND
 	  devices. For further information see
 	  <http://www.linux-mtd.infradead.org/doc/nand.html>.
=20
+if MTD_NAND
+
 config MTD_NAND_VERIFY_WRITE
 	bool "Verify NAND page writes"
-	depends on MTD_NAND
 	help
 	  This adds an extra check when data is written to the flash. The
 	  NAND flash device internally checks only bits transitioning
@@ -25,7 +23,6 @@ config MTD_NAND_VERIFY_WRITE
=20
 config MTD_NAND_ECC_SMC
 	bool "NAND ECC Smart Media byte order"
-	depends on MTD_NAND
 	default n
 	help
 	  Software ECC according to the Smart Media Specification.
@@ -33,45 +30,45 @@ config MTD_NAND_ECC_SMC
=20
 config MTD_NAND_AUTCPU12
 	tristate "SmartMediaCard on autronix autcpu12 board"
-	depends on MTD_NAND && ARCH_AUTCPU12
+	depends on ARCH_AUTCPU12
 	help
 	  This enables the driver for the autronix autcpu12 board to
 	  access the SmartMediaCard.
=20
 config MTD_NAND_EDB7312
 	tristate "Support for Cirrus Logic EBD7312 evaluation board"
-	depends on MTD_NAND && ARCH_EDB7312
+	depends on ARCH_EDB7312
 	help
 	  This enables the driver for the Cirrus Logic EBD7312 evaluation
 	  board to access the onboard NAND Flash.
=20
 config MTD_NAND_H1900
 	tristate "iPAQ H1900 flash"
-	depends on MTD_NAND && ARCH_PXA && MTD_PARTITIONS
+	depends on ARCH_PXA && MTD_PARTITIONS
 	help
 	  This enables the driver for the iPAQ h1900 flash.
=20
 config MTD_NAND_SPIA
 	tristate "NAND Flash device on SPIA board"
-	depends on ARCH_P720T && MTD_NAND
+	depends on ARCH_P720T
 	help
 	  If you had to ask, you don't have one. Say 'N'.
=20
 config MTD_NAND_AMS_DELTA
 	tristate "NAND Flash device on Amstrad E3"
-	depends on MACH_AMS_DELTA && MTD_NAND
+	depends on MACH_AMS_DELTA
 	help
 	  Support for NAND flash on Amstrad E3 (Delta).
=20
 config MTD_NAND_TOTO
 	tristate "NAND Flash device on TOTO board"
-	depends on ARCH_OMAP && MTD_NAND && BROKEN
+	depends on ARCH_OMAP && BROKEN
 	help
 	  Support for NAND flash on Texas Instruments Toto platform.
=20
 config MTD_NAND_TS7250
 	tristate "NAND Flash device on TS-7250 board"
-	depends on MACH_TS72XX && MTD_NAND
+	depends on MACH_TS72XX
 	help
 	  Support for NAND flash on Technologic Systems TS-7250 platform.
=20
@@ -80,14 +77,14 @@ config MTD_NAND_IDS
=20
 config MTD_NAND_AU1550
 	tristate "Au1550/1200 NAND support"
-	depends on (SOC_AU1200 || SOC_AU1550) && MTD_NAND
+	depends on SOC_AU1200 || SOC_AU1550
 	help
 	  This enables the driver for the NAND flash controller on the
 	  AMD/Alchemy 1550 SOC.
=20
 config MTD_NAND_RTC_FROM4
 	tristate "Renesas Flash ROM 4-slot interface board (FROM_BOARD4)"
-	depends on MTD_NAND && SH_SOLUTION_ENGINE
+	depends on SH_SOLUTION_ENGINE
 	select REED_SOLOMON
 	select REED_SOLOMON_DEC8
 	select BITREVERSE
@@ -97,13 +94,13 @@ config MTD_NAND_RTC_FROM4
=20
 config MTD_NAND_PPCHAMELEONEVB
 	tristate "NAND Flash device on PPChameleonEVB board"
-	depends on PPCHAMELEONEVB && MTD_NAND && BROKEN
+	depends on PPCHAMELEONEVB && BROKEN
 	help
 	  This enables the NAND flash driver on the PPChameleon EVB Board.
=20
 config MTD_NAND_S3C2410
 	tristate "NAND Flash support for S3C2410/S3C2440 SoC"
-	depends on ARCH_S3C2410 && MTD_NAND
+	depends on ARCH_S3C2410
 	help
 	  This enables the NAND flash controller on the S3C2410 and S3C2440
 	  SoCs
@@ -128,7 +125,7 @@ config MTD_NAND_S3C2410_HWECC
=20
 config MTD_NAND_NDFC
 	tristate "NDFC NanD Flash Controller"
-	depends on MTD_NAND && 44x
+	depends on 44x
 	select MTD_NAND_ECC_SMC
 	help
 	 NDFC Nand Flash Controllers are integrated in EP44x SoCs
@@ -145,7 +142,7 @@ config MTD_NAND_S3C2410_CLKSTOP
=20
 config MTD_NAND_DISKONCHIP
 	tristate "DiskOnChip 2000, Millennium and Millennium Plus (NAND reimp=
lementation) (EXPERIMENTAL)"
-	depends on MTD_NAND && EXPERIMENTAL
+	depends on EXPERIMENTAL
 	select REED_SOLOMON
 	select REED_SOLOMON_DEC16
 	help
@@ -215,11 +212,11 @@ config MTD_NAND_DISKONCHIP_BBTWRITE
=20
 config MTD_NAND_SHARPSL
 	tristate "Support for NAND Flash on Sharp SL Series (C7xx + others)"
-	depends on MTD_NAND && ARCH_PXA
+	depends on ARCH_PXA
=20
 config MTD_NAND_BASLER_EXCITE
 	tristate  "Support for NAND Flash on Basler eXcite"
-	depends on MTD_NAND && BASLER_EXCITE
+	depends on BASLER_EXCITE
 	help
           This enables the driver for the NAND flash device found on t=
he
           Basler eXcite Smart Camera. If built as a module, the driver
@@ -227,14 +224,14 @@ config MTD_NAND_BASLER_EXCITE
=20
 config MTD_NAND_CAFE
        tristate "NAND support for OLPC CAF=C3=89 chip"
-       depends on MTD_NAND && PCI
+       depends on PCI
        help
 	 Use NAND flash attached to the CAF=C3=89 chip designed for the $100
 	 laptop.
=20
 config MTD_NAND_CS553X
 	tristate "NAND support for CS5535/CS5536 (AMD Geode companion chip)"
-	depends on MTD_NAND && X86_32 && (X86_PC || X86_GENERICARCH)
+	depends on X86_32 && (X86_PC || X86_GENERICARCH)
 	help
 	  The CS553x companion chips for the AMD Geode processor
 	  include NAND flash controllers with built-in hardware ECC
@@ -247,16 +244,16 @@ config MTD_NAND_CS553X
=20
 config MTD_NAND_AT91
 	bool "Support for NAND Flash / SmartMedia on AT91"
-	depends on MTD_NAND && ARCH_AT91
+	depends on ARCH_AT91
 	help
 	  Enables support for NAND Flash / Smart Media Card interface
 	  on Atmel AT91 processors.
=20
 config MTD_NAND_NANDSIM
 	tristate "Support for NAND Flash Simulator"
-	depends on MTD_NAND && MTD_PARTITIONS
+	depends on MTD_PARTITIONS
 	help
 	  The simulator may simulate various NAND flash chips for the
 	  MTD nand layer.
=20
-endmenu
+endif # MTD_NAND
diff -puN drivers/mtd/onenand/Kconfig~use-menuconfig-objects-mtd driver=
s/mtd/onenand/Kconfig
--- a/drivers/mtd/onenand/Kconfig~use-menuconfig-objects-mtd
+++ a/drivers/mtd/onenand/Kconfig
@@ -2,10 +2,7 @@
 # linux/drivers/mtd/onenand/Kconfig
 #
=20
-menu "OneNAND Flash Device Drivers"
-	depends on MTD !=3D n
-
-config MTD_ONENAND
+menuconfig MTD_ONENAND
 	tristate "OneNAND Device Support"
 	depends on MTD
 	help
@@ -13,9 +10,10 @@ config MTD_ONENAND
 	  devices. For further information see
 	  <http://www.samsung.com/Products/Semiconductor/Flash/OneNAND_TM/ind=
ex.htm>.
=20
+if MTD_ONENAND
+
 config MTD_ONENAND_VERIFY_WRITE
 	bool "Verify OneNAND page writes"
-	depends on MTD_ONENAND
 	help
 	  This adds an extra check when data is written to the flash. The
 	  OneNAND flash device internally checks only bits transitioning
@@ -25,13 +23,12 @@ config MTD_ONENAND_VERIFY_WRITE
=20
 config MTD_ONENAND_GENERIC
 	tristate "OneNAND Flash device via platform device driver"
-	depends on MTD_ONENAND && ARM
+	depends on ARM
 	help
 	  Support for OneNAND flash via platform device driver.
=20
 config MTD_ONENAND_OTP
 	bool "OneNAND OTP Support"
-	depends on MTD_ONENAND
 	help
 	  One Block of the NAND Flash Array memory is reserved as
 	  a One-Time Programmable Block memory area.
@@ -43,4 +40,4 @@ config MTD_ONENAND_OTP
=20
 	  OTP block is fully-guaranteed to be a valid block.
=20
-endmenu
+endif # MTD_ONENAND
_

Patches currently in -mm which might be from jengelh@linux01.gwdg.de ar=
e

git-kbuild.patch
git-mtd.patch
remove-artificial-software-max_loop-limit.patch
fix-kevents-childs-priority-greediness.patch
console-utf-8-fixes.patch
vt-allow-for-the-palette-to-be-exposed-and-changed-via-sysfs.patch
vt-add-color-support-to-the-underline-and-italic-attributes.patch
vt-expose-system-wide-utf-8-default-setting-via-sysfs.patch
use-menuconfig-objects-acpi.patch
use-menuconfig-objects-libata.patch
use-menuconfig-objects-block-layer.patch
use-menuconfig-objects-connector.patch
use-menuconfig-objects-crypto.patch
use-menuconfig-objects-crypto-hw.patch
use-menuconfig-objects-dccp.patch
use-menuconfig-objects-i2o.patch
use-menuconfig-objects-ide.patch
use-menuconfig-objects-ipvs.patch
use-menuconfig-objects-sctp.patch
use-menuconfig-objects-tipc.patch
use-menuconfig-objects-arcnet.patch
use-menuconfig-objects-phy.patch
use-menuconfig-objects-toeknring.patch
use-menuconfig-objects-netdev.patch
use-menuconfig-objects-oldcd.patch
use-menuconfig-objects-parport.patch
use-menuconfig-objects-pcmcia.patch
use-menuconfig-objects-pnp.patch
use-menuconfig-objects-w1.patch
