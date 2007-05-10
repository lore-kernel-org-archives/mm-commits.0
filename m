From: akpm@linux-foundation.org
Subject: + use-menuconfig-objects-ii-rtc.patch added to -mm tree
Date: Wed, 09 May 2007 23:17:54 -0700
Message-ID: <200705100617.l4A6Hs5f013857@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51939 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755243AbXEJGSU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 02:18:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@linux01.gwdg.de, a.zummo@towertech.it, david-b@pacbell.net, jengelh@gmx.de


The patch titled
     Use menuconfig objects II - RTC
has been added to the -mm tree.  Its filename is
     use-menuconfig-objects-ii-rtc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use menuconfig objects II - RTC
From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Change Kconfig objects from "menu, config" into "menuconfig" so
that the user can disable the whole feature without having to
enter the menu first.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig |   67 ++++++++++++++++--------------------------
 1 file changed, 27 insertions(+), 40 deletions(-)

diff -puN drivers/rtc/Kconfig~use-menuconfig-objects-ii-rtc drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~use-menuconfig-objects-ii-rtc
+++ a/drivers/rtc/Kconfig
@@ -2,13 +2,11 @@
 # RTC class/drivers configuration
 #
 
-menu "Real Time Clock"
-
 config RTC_LIB
 	tristate
 
-config RTC_CLASS
-	tristate "RTC class"
+menuconfig RTC_CLASS
+	tristate "Real Time Clock class"
 	depends on EXPERIMENTAL
 	default n
 	select RTC_LIB
@@ -20,6 +18,8 @@ config RTC_CLASS
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-class.
 
+if RTC_CLASS
+
 config RTC_HCTOSYS
 	bool "Set system time from RTC on startup and resume"
 	depends on RTC_CLASS = y
@@ -55,11 +55,10 @@ config RTC_DEBUG
 	  and individual RTC drivers.
 
 comment "RTC interfaces"
-	depends on RTC_CLASS
 
 config RTC_INTF_SYSFS
 	boolean "sysfs"
-	depends on RTC_CLASS && SYSFS
+	depends on SYSFS
 	default RTC_CLASS
 	help
 	  Say yes here if you want to use your RTCs using sysfs interfaces,
@@ -70,7 +69,7 @@ config RTC_INTF_SYSFS
 
 config RTC_INTF_PROC
 	boolean "proc"
-	depends on RTC_CLASS && PROC_FS
+	depends on PROC_FS
 	default RTC_CLASS
 	help
 	  Say yes here if you want to use your first RTC through the proc
@@ -82,7 +81,6 @@ config RTC_INTF_PROC
 
 config RTC_INTF_DEV
 	boolean "dev"
-	depends on RTC_CLASS
 	default RTC_CLASS
 	help
 	  Say yes here if you want to use your RTCs using the /dev
@@ -104,7 +102,6 @@ config RTC_INTF_DEV_UIE_EMUL
 
 config RTC_DRV_TEST
 	tristate "Test driver/device"
-	depends on RTC_CLASS
 	help
 	  If you say yes here you get support for the
 	  RTC test driver. It's a software RTC which can be
@@ -118,11 +115,10 @@ config RTC_DRV_TEST
 	  will be called rtc-test.
 
 comment "I2C RTC drivers"
-	depends on RTC_CLASS
 
 config RTC_DRV_DS1307
 	tristate "Dallas/Maxim DS1307/37/38/39/40, ST M41T00"
-	depends on RTC_CLASS && I2C
+	depends on I2C
 	help
 	  If you say yes here you get support for various compatible RTC
 	  chips (often with battery backup) connected with I2C.  This driver
@@ -140,7 +136,7 @@ config RTC_DRV_DS1307
 
 config RTC_DRV_DS1672
 	tristate "Dallas/Maxim DS1672"
-	depends on RTC_CLASS && I2C
+	depends on I2C
 	help
 	  If you say yes here you get support for the
 	  Dallas/Maxim DS1672 timekeeping chip.
@@ -150,7 +146,7 @@ config RTC_DRV_DS1672
 
 config RTC_DRV_MAX6900
 	tristate "Maxim 6900"
-	depends on RTC_CLASS && I2C
+	depends on I2C
 	help
 	  If you say yes here you will get support for the
 	  Maxim MAX6900 I2C RTC chip.
@@ -160,7 +156,7 @@ config RTC_DRV_MAX6900
 
 config RTC_DRV_RS5C372
 	tristate "Ricoh RS5C372A/B"
-	depends on RTC_CLASS && I2C
+	depends on I2C
 	help
 	  If you say yes here you get support for the
 	  Ricoh RS5C372A and RS5C372B RTC chips.
@@ -170,7 +166,7 @@ config RTC_DRV_RS5C372
 
 config RTC_DRV_ISL1208
 	tristate "Intersil 1208"
-	depends on RTC_CLASS && I2C
+	depends on I2C
 	help
 	  If you say yes here you get support for the
 	  Intersil 1208 RTC chip.
@@ -180,7 +176,7 @@ config RTC_DRV_ISL1208
 
 config RTC_DRV_X1205
 	tristate "Xicor/Intersil X1205"
-	depends on RTC_CLASS && I2C
+	depends on I2C
 	help
 	  If you say yes here you get support for the
 	  Xicor/Intersil X1205 RTC chip.
@@ -190,7 +186,7 @@ config RTC_DRV_X1205
 
 config RTC_DRV_PCF8563
 	tristate "Philips PCF8563/Epson RTC8564"
-	depends on RTC_CLASS && I2C
+	depends on I2C
 	help
 	  If you say yes here you get support for the
 	  Philips PCF8563 RTC chip. The Epson RTC8564
@@ -201,7 +197,7 @@ config RTC_DRV_PCF8563
 
 config RTC_DRV_PCF8583
 	tristate "Philips PCF8583"
-	depends on RTC_CLASS && I2C
+	depends on I2C
 	help
 	  If you say yes here you get support for the Philips PCF8583
 	  RTC chip found on Acorn RiscPCs. This driver supports the
@@ -213,11 +209,10 @@ config RTC_DRV_PCF8583
 	  will be called rtc-pcf8583.
 
 comment "SPI RTC drivers"
-	depends on RTC_CLASS
 
 config RTC_DRV_RS5C348
 	tristate "Ricoh RS5C348A/B"
-	depends on RTC_CLASS && SPI
+	depends on SPI
 	help
 	  If you say yes here you get support for the
 	  Ricoh RS5C348A and RS5C348B RTC chips.
@@ -227,7 +222,7 @@ config RTC_DRV_RS5C348
 
 config RTC_DRV_MAX6902
 	tristate "Maxim 6902"
-	depends on RTC_CLASS && SPI
+	depends on SPI
 	help
 	  If you say yes here you will get support for the
 	  Maxim MAX6902 SPI RTC chip.
@@ -236,7 +231,6 @@ config RTC_DRV_MAX6902
 	  will be called rtc-max6902.
 
 comment "Platform RTC drivers"
-	depends on RTC_CLASS
 
 # this 'CMOS' RTC driver is arch dependent because <asm-generic/rtc.h>
 # requires <asm/mc146818rtc.h> defining CMOS_READ/CMOS_WRITE, and a
@@ -244,8 +238,7 @@ comment "Platform RTC drivers"
 
 config RTC_DRV_CMOS
 	tristate "PC-style 'CMOS'"
-	depends on RTC_CLASS && (X86 || ALPHA || ARM26 || ARM \
-		|| M32R || ATARI || POWERPC)
+	depends on X86 || ALPHA || ARM26 || ARM || M32R || ATARI || POWERPC
 	help
 	  Say "yes" here to get direct support for the real time clock
 	  found in every PC or ACPI-based system, and some other boards.
@@ -263,7 +256,6 @@ config RTC_DRV_CMOS
 
 config RTC_DRV_DS1553
 	tristate "Dallas DS1553"
-	depends on RTC_CLASS
 	help
 	  If you say yes here you get support for the
 	  Dallas DS1553 timekeeping chip.
@@ -273,7 +265,6 @@ config RTC_DRV_DS1553
 
 config RTC_DRV_DS1742
 	tristate "Dallas DS1742/1743"
-	depends on RTC_CLASS
 	help
 	  If you say yes here you get support for the
 	  Dallas DS1742/1743 timekeeping chip.
@@ -283,7 +274,6 @@ config RTC_DRV_DS1742
 
 config RTC_DRV_M48T86
 	tristate "ST M48T86/Dallas DS12887"
-	depends on RTC_CLASS
 	help
 	  If you say Y here you will get support for the
 	  ST M48T86 and Dallas DS12887 RTC chips.
@@ -293,7 +283,6 @@ config RTC_DRV_M48T86
 
 config RTC_DRV_V3020
 	tristate "EM Microelectronic V3020"
-	depends on RTC_CLASS
 	help
 	  If you say yes here you will get support for the
 	  EM Microelectronic v3020 RTC chip.
@@ -302,19 +291,17 @@ config RTC_DRV_V3020
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
@@ -330,7 +317,7 @@ config RTC_DRV_S3C
 
 config RTC_DRV_EP93XX
 	tristate "Cirrus Logic EP93XX"
-	depends on RTC_CLASS && ARCH_EP93XX
+	depends on ARCH_EP93XX
 	help
 	  If you say yes here you get support for the
 	  RTC embedded in the Cirrus Logic EP93XX processors.
@@ -340,7 +327,7 @@ config RTC_DRV_EP93XX
 
 config RTC_DRV_SA1100
 	tristate "SA11x0/PXA2xx"
-	depends on RTC_CLASS && (ARCH_SA1100 || ARCH_PXA)
+	depends on ARCH_SA1100 || ARCH_PXA
 	help
 	  If you say Y here you will get access to the real time clock
 	  built into your SA11x0 or PXA2xx CPU.
@@ -350,7 +337,7 @@ config RTC_DRV_SA1100
 
 config RTC_DRV_SH
 	tristate "SuperH On-Chip RTC"
-	depends on RTC_CLASS && SUPERH
+	depends on SUPERH
 	help
 	  Say Y here to enable support for the on-chip RTC found in
 	  most SuperH processors.
@@ -360,7 +347,7 @@ config RTC_DRV_SH
 
 config RTC_DRV_VR41XX
 	tristate "NEC VR41XX"
-	depends on RTC_CLASS && CPU_VR41XX
+	depends on CPU_VR41XX
 	help
 	  If you say Y here you will get access to the real time clock
 	  built into your NEC VR41XX CPU.
@@ -370,7 +357,7 @@ config RTC_DRV_VR41XX
 
 config RTC_DRV_PL031
 	tristate "ARM AMBA PL031 RTC"
-	depends on RTC_CLASS && ARM_AMBA
+	depends on ARM_AMBA
 	help
 	  If you say Y here you will get access to ARM AMBA
 	  PrimeCell PL031 RTC found on certain ARM SOCs.
@@ -380,13 +367,13 @@ config RTC_DRV_PL031
 
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
@@ -400,4 +387,4 @@ config RTC_DRV_RS5C313
 	help
 	  If you say yes here you get support for the Ricoh RS5C313 RTC chips.
 
-endmenu
+endif # RTC_CLASS
_

Patches currently in -mm which might be from jengelh@linux01.gwdg.de are

origin.patch
use-menuconfig-objects-acpi.patch
use-menuconfig-objects-ii-sound.patch
git-dvb.patch
use-menuconfig-objects-ii-ieee1394.patch
use-menuconfig-objects-ii-infiniband.patch
use-menuconfig-objects-ii-kvm-virt.patch
use-menuconfig-objects-ii-led.patch
use-menuconfig-objects-libata.patch
use-menuconfig-objects-ide.patch
use-menuconfig-objects-phy.patch
use-menuconfig-objects-netdev.patch
use-menuconfig-objects-ii-netdev-general100mbit.patch
use-menuconfig-objects-ii-netdev-atm.patch
use-menuconfig-objects-ii-netdev-pcmcia.patch
use-menuconfig-objects-ii-netdev-wan.patch
use-menuconfig-objects-dccp.patch
use-menuconfig-objects-ipvs.patch
use-menuconfig-objects-sctp.patch
use-menuconfig-objects-tipc.patch
use-menuconfig-objects-arcnet.patch
use-menuconfig-objects-toeknring.patch
use-menuconfig-objects-pcmcia.patch
use-menuconfig-objects-ii-fusion.patch
use-menuconfig-objects-ii-scsi.patch
use-menuconfig-objects-oldcd.patch
use-menuconfig-objects-block-layer.patch
use-menuconfig-objects-ib-block.patch
use-menuconfig-objects-ii-block-devices.patch
use-menuconfig-objects-ii-usb.patch
git-watchdog.patch
use-menuconfig-objects-crypto.patch
use-menuconfig-objects-ii-auxdisplay.patch
use-menuconfig-objects-ii-edac.patch
use-menuconfig-objects-ii-ipmi.patch
use-menuconfig-objects-ii-misc-strange-dev.patch
use-menuconfig-objects-ii-module-menu.patch
use-menuconfig-objects-ii-oprofile.patch
use-menuconfig-objects-ii-rtc.patch
use-menuconfig-objects-ii-telephony.patch
use-menuconfig-objects-ii-tpm.patch
use-menuconfig-objects-connector.patch
use-menuconfig-objects-crypto-hw.patch
use-menuconfig-objects-i2o.patch
use-menuconfig-objects-parport.patch
use-menuconfig-objects-pnp.patch
use-menuconfig-objects-w1.patch
use-menuconfig-objects-ii-isdn.patch
use-menuconfig-objects-ii-md.patch
