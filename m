From: akpm@linux-foundation.org
Subject: + use-menuconfig-objects-rtc.patch added to -mm tree
Date: Mon, 23 Jul 2007 15:40:03 -0700
Message-ID: <200707232240.l6NMe315015763@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33570 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752893AbXGWWkf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 18:40:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@computergmbh.de, a.zummo@towertech.it, david-b@pacbell.net, jengelh@gmx.de


The patch titled
     Use menuconfig objects: RTC
has been added to the -mm tree.  Its filename is
     use-menuconfig-objects-rtc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use menuconfig objects: RTC
From: Jan Engelhardt <jengelh@computergmbh.de>

Change Kconfig objects from "menu, config" into "menuconfig" so that the
user can disable the whole feature without having to enter the menu first.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig |   79 +++++++++++++++++-------------------------
 1 files changed, 32 insertions(+), 47 deletions(-)

diff -puN drivers/rtc/Kconfig~use-menuconfig-objects-rtc drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~use-menuconfig-objects-rtc
+++ a/drivers/rtc/Kconfig
@@ -2,15 +2,13 @@
 # RTC class/drivers configuration
 #
 
-menu "Real Time Clock"
-	depends on !S390
-
 config RTC_LIB
 	tristate
 
-config RTC_CLASS
-	tristate "RTC class"
+menuconfig RTC_CLASS
+	tristate "Real Time Clock"
 	default n
+	depends on !S390
 	select RTC_LIB
 	help
 	  Generic RTC class support. If you say yes here, you will
@@ -20,6 +18,8 @@ config RTC_CLASS
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-class.
 
+if RTC_CLASS
+
 config RTC_HCTOSYS
 	bool "Set system time from RTC on startup and resume"
 	depends on RTC_CLASS = y
@@ -58,11 +58,10 @@ config RTC_DEBUG
 	  and individual RTC drivers.
 
 comment "RTC interfaces"
-	depends on RTC_CLASS
 
 config RTC_INTF_SYSFS
 	boolean "/sys/class/rtc/rtcN (sysfs)"
-	depends on RTC_CLASS && SYSFS
+	depends on SYSFS
 	default RTC_CLASS
 	help
 	  Say yes here if you want to use your RTCs using sysfs interfaces,
@@ -73,7 +72,7 @@ config RTC_INTF_SYSFS
 
 config RTC_INTF_PROC
 	boolean "/proc/driver/rtc (procfs for rtc0)"
-	depends on RTC_CLASS && PROC_FS
+	depends on PROC_FS
 	default RTC_CLASS
 	help
 	  Say yes here if you want to use your first RTC through the proc
@@ -85,7 +84,6 @@ config RTC_INTF_PROC
 
 config RTC_INTF_DEV
 	boolean "/dev/rtcN (character devices)"
-	depends on RTC_CLASS
 	default RTC_CLASS
 	help
 	  Say yes here if you want to use your RTCs using the /dev
@@ -107,7 +105,6 @@ config RTC_INTF_DEV_UIE_EMUL
 
 config RTC_DRV_TEST
 	tristate "Test driver/device"
-	depends on RTC_CLASS
 	help
 	  If you say yes here you get support for the
 	  RTC test driver. It's a software RTC which can be
@@ -121,11 +118,12 @@ config RTC_DRV_TEST
 	  will be called rtc-test.
 
 comment "I2C RTC drivers"
-	depends on RTC_CLASS && I2C
+	depends on I2C
+
+if I2C
 
 config RTC_DRV_DS1307
 	tristate "Dallas/Maxim DS1307/37/38/39/40, ST M41T00"
-	depends on RTC_CLASS && I2C
 	help
 	  If you say yes here you get support for various compatible RTC
 	  chips (often with battery backup) connected with I2C.  This driver
@@ -143,7 +141,6 @@ config RTC_DRV_DS1307
 
 config RTC_DRV_DS1672
 	tristate "Dallas/Maxim DS1672"
-	depends on RTC_CLASS && I2C
 	help
 	  If you say yes here you get support for the
 	  Dallas/Maxim DS1672 timekeeping chip.
@@ -153,7 +150,6 @@ config RTC_DRV_DS1672
 
 config RTC_DRV_MAX6900
 	tristate "Maxim 6900"
-	depends on RTC_CLASS && I2C
 	help
 	  If you say yes here you will get support for the
 	  Maxim MAX6900 I2C RTC chip.
@@ -163,7 +159,6 @@ config RTC_DRV_MAX6900
 
 config RTC_DRV_RS5C372
 	tristate "Ricoh RS5C372A/B, RV5C386, RV5C387A"
-	depends on RTC_CLASS && I2C
 	help
 	  If you say yes here you get support for the
 	  Ricoh RS5C372A, RS5C372B, RV5C386, and RV5C387A RTC chips.
@@ -173,7 +168,6 @@ config RTC_DRV_RS5C372
 
 config RTC_DRV_ISL1208
 	tristate "Intersil 1208"
-	depends on RTC_CLASS && I2C
 	help
 	  If you say yes here you get support for the
 	  Intersil 1208 RTC chip.
@@ -183,7 +177,6 @@ config RTC_DRV_ISL1208
 
 config RTC_DRV_X1205
 	tristate "Xicor/Intersil X1205"
-	depends on RTC_CLASS && I2C
 	help
 	  If you say yes here you get support for the
 	  Xicor/Intersil X1205 RTC chip.
@@ -193,7 +186,6 @@ config RTC_DRV_X1205
 
 config RTC_DRV_PCF8563
 	tristate "Philips PCF8563/Epson RTC8564"
-	depends on RTC_CLASS && I2C
 	help
 	  If you say yes here you get support for the
 	  Philips PCF8563 RTC chip. The Epson RTC8564
@@ -204,7 +196,6 @@ config RTC_DRV_PCF8563
 
 config RTC_DRV_PCF8583
 	tristate "Philips PCF8583"
-	depends on RTC_CLASS && I2C
 	help
 	  If you say yes here you get support for the Philips PCF8583
 	  RTC chip found on Acorn RiscPCs. This driver supports the
@@ -217,7 +208,6 @@ config RTC_DRV_PCF8583
 
 config RTC_DRV_M41T80
 	tristate "ST M41T80 series RTC"
-	depends on RTC_CLASS && I2C
 	help
 	  If you say Y here you will get support for the
 	  ST M41T80 RTC chips series. Currently following chips are
@@ -236,19 +226,21 @@ config RTC_DRV_M41T80_WDT
 
 config RTC_DRV_TWL92330
 	boolean "TI TWL92330/Menelaus"
-	depends on RTC_CLASS && I2C && MENELAUS
+	depends on MENELAUS
 	help
 	  If you say yes here you get support for the RTC on the
 	  TWL92330 "Menelaus" power mangement chip, used with OMAP2
 	  platforms.  The support is integrated with the rest of
 	  the Menelaus driver; it's not separate module.
 
+endif # I2C
+
 comment "SPI RTC drivers"
-	depends on RTC_CLASS && SPI_MASTER
+
+if SPI_MASTER
 
 config RTC_DRV_RS5C348
 	tristate "Ricoh RS5C348A/B"
-	depends on RTC_CLASS && SPI_MASTER
 	help
 	  If you say yes here you get support for the
 	  Ricoh RS5C348A and RS5C348B RTC chips.
@@ -258,7 +250,6 @@ config RTC_DRV_RS5C348
 
 config RTC_DRV_MAX6902
 	tristate "Maxim 6902"
-	depends on RTC_CLASS && SPI_MASTER
 	help
 	  If you say yes here you will get support for the
 	  Maxim MAX6902 SPI RTC chip.
@@ -266,8 +257,9 @@ config RTC_DRV_MAX6902
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-max6902.
 
+endif # SPI_MASTER
+
 comment "Platform RTC drivers"
-	depends on RTC_CLASS
 
 # this 'CMOS' RTC driver is arch dependent because <asm-generic/rtc.h>
 # requires <asm/mc146818rtc.h> defining CMOS_READ/CMOS_WRITE, and a
@@ -275,8 +267,8 @@ comment "Platform RTC drivers"
 
 config RTC_DRV_CMOS
 	tristate "PC-style 'CMOS'"
-	depends on RTC_CLASS && (X86 || ALPHA || ARM26 || ARM \
-		|| M32R || ATARI || PPC || MIPS)
+	depends on X86 || ALPHA || ARM26 || ARM || \
+		M32R || ATARI || PPC || MIPS
 	help
 	  Say "yes" here to get direct support for the real time clock
 	  found in every PC or ACPI-based system, and some other boards.
@@ -294,13 +286,12 @@ config RTC_DRV_CMOS
 
 config RTC_DRV_DS1216
 	tristate "Dallas DS1216"
-	depends on RTC_CLASS && SNI_RM
+	depends on SNI_RM
 	help
 	  If you say yes here you get support for the Dallas DS1216 RTC chips.
 
 config RTC_DRV_DS1553
 	tristate "Dallas DS1553"
-	depends on RTC_CLASS
 	help
 	  If you say yes here you get support for the
 	  Dallas DS1553 timekeeping chip.
@@ -320,7 +311,6 @@ config RTC_DRV_STK17TA8
 
 config RTC_DRV_DS1742
 	tristate "Dallas DS1742/1743"
-	depends on RTC_CLASS
 	help
 	  If you say yes here you get support for the
 	  Dallas DS1742/1743 timekeeping chip.
@@ -330,7 +320,6 @@ config RTC_DRV_DS1742
 
 config RTC_DRV_M48T86
 	tristate "ST M48T86/Dallas DS12887"
-	depends on RTC_CLASS
 	help
 	  If you say Y here you will get support for the
 	  ST M48T86 and Dallas DS12887 RTC chips.
@@ -340,7 +329,6 @@ config RTC_DRV_M48T86
 
 config RTC_DRV_M48T59
 	tristate "ST M48T59"
-	depends on RTC_CLASS
 	help
 	  If you say Y here you will get support for the
 	  ST M48T59 RTC chip.
@@ -350,7 +338,6 @@ config RTC_DRV_M48T59
 
 config RTC_DRV_V3020
 	tristate "EM Microelectronic V3020"
-	depends on RTC_CLASS
 	help
 	  If you say yes here you will get support for the
 	  EM Microelectronic v3020 RTC chip.
@@ -359,19 +346,17 @@ config RTC_DRV_V3020
 	  will be called rtc-v3020.
 
 comment "on-CPU RTC drivers"
-	depends on RTC_CLASS
 
 config RTC_DRV_OMAP
 	tristate "TI OMAP1"
-	depends on RTC_CLASS && ( \
-		ARCH_OMAP15XX || ARCH_OMAP16XX || ARCH_OMAP730 )
+	depends on ARCH_OMAP15XX || ARCH_OMAP16XX || ARCH_OMAP730
 	help
 	  Say "yes" here to support the real time clock on TI OMAP1 chips.
 	  This driver can also be built as a module called rtc-omap.
 
 config RTC_DRV_S3C
 	tristate "Samsung S3C series SoC RTC"
-	depends on RTC_CLASS && ARCH_S3C2410
+	depends on ARCH_S3C2410
 	help
 	  RTC (Realtime Clock) driver for the clock inbuilt into the
 	  Samsung S3C24XX series of SoCs. This can provide periodic
@@ -387,7 +372,7 @@ config RTC_DRV_S3C
 
 config RTC_DRV_EP93XX
 	tristate "Cirrus Logic EP93XX"
-	depends on RTC_CLASS && ARCH_EP93XX
+	depends on ARCH_EP93XX
 	help
 	  If you say yes here you get support for the
 	  RTC embedded in the Cirrus Logic EP93XX processors.
@@ -397,7 +382,7 @@ config RTC_DRV_EP93XX
 
 config RTC_DRV_SA1100
 	tristate "SA11x0/PXA2xx"
-	depends on RTC_CLASS && (ARCH_SA1100 || ARCH_PXA)
+	depends on ARCH_SA1100 || ARCH_PXA
 	help
 	  If you say Y here you will get access to the real time clock
 	  built into your SA11x0 or PXA2xx CPU.
@@ -407,7 +392,7 @@ config RTC_DRV_SA1100
 
 config RTC_DRV_SH
 	tristate "SuperH On-Chip RTC"
-	depends on RTC_CLASS && SUPERH && (CPU_SH3 || CPU_SH4)
+	depends on RTC_CLASS && (CPU_SH3 || CPU_SH4)
 	help
 	  Say Y here to enable support for the on-chip RTC found in
 	  most SuperH processors.
@@ -417,7 +402,7 @@ config RTC_DRV_SH
 
 config RTC_DRV_VR41XX
 	tristate "NEC VR41XX"
-	depends on RTC_CLASS && CPU_VR41XX
+	depends on CPU_VR41XX
 	help
 	  If you say Y here you will get access to the real time clock
 	  built into your NEC VR41XX CPU.
@@ -427,7 +412,7 @@ config RTC_DRV_VR41XX
 
 config RTC_DRV_PL031
 	tristate "ARM AMBA PL031 RTC"
-	depends on RTC_CLASS && ARM_AMBA
+	depends on ARM_AMBA
 	help
 	  If you say Y here you will get access to ARM AMBA
 	  PrimeCell PL031 RTC found on certain ARM SOCs.
@@ -437,20 +422,20 @@ config RTC_DRV_PL031
 
 config RTC_DRV_AT32AP700X
 	tristate "AT32AP700X series RTC"
-	depends on RTC_CLASS && PLATFORM_AT32AP
+	depends on PLATFORM_AT32AP
 	help
 	  Driver for the internal RTC (Realtime Clock) on Atmel AVR32
 	  AT32AP700x family processors.
 
 config RTC_DRV_AT91RM9200
 	tristate "AT91RM9200"
-	depends on RTC_CLASS && ARCH_AT91RM9200
+	depends on ARCH_AT91RM9200
 	help
 	  Driver for the Atmel AT91RM9200's internal RTC (Realtime Clock).
 
 config RTC_DRV_BFIN
 	tristate "Blackfin On-Chip RTC"
-	depends on RTC_CLASS && BFIN
+	depends on BFIN
 	help
 	  If you say yes here you will get support for the
 	  Blackfin On-Chip Real Time Clock.
@@ -460,8 +445,8 @@ config RTC_DRV_BFIN
 
 config RTC_DRV_RS5C313
 	tristate "Ricoh RS5C313"
-	depends on RTC_CLASS && SH_LANDISK
+	depends on SH_LANDISK
 	help
 	  If you say yes here you get support for the Ricoh RS5C313 RTC chips.
 
-endmenu
+endif # RTC_CLASS
_

Patches currently in -mm which might be from jengelh@computergmbh.de are

use-menuconfig-objects-rtc.patch
intel-iommu-iommu-gfx-workaround-kconfig-fix.patch
intel-iommu-iommu-floppy-workaround-kconfig-fix.patch
