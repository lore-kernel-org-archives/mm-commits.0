From: akpm@linux-foundation.org
Subject: + rtc-kconfig-cleanup.patch added to -mm tree
Date: Mon, 19 Mar 2007 14:50:19 -0700
Message-ID: <200703192150.l2JLoOPF018453@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58323 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753477AbXCSVwP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Mar 2007 17:52:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.zummo@towertech.it, david-b@pacbell.net


The patch titled
     RTC Kconfig cleanup
has been added to the -mm tree.  Its filename is
     rtc-kconfig-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: RTC Kconfig cleanup
From: Alessandro Zummo <a.zummo@towertech.it>

Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig |  250 +++++++++++++++++++++---------------------
 1 files changed, 130 insertions(+), 120 deletions(-)

diff -puN drivers/rtc/Kconfig~rtc-kconfig-cleanup drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-kconfig-cleanup
+++ a/drivers/rtc/Kconfig
@@ -102,44 +102,26 @@ config RTC_INTF_DEV_UIE_EMUL
 	  driver does not expose RTC_UIE ioctls.  Those requests generate
 	  once-per-second update interrupts, used for synchronization.
 
-comment "RTC drivers"
+config RTC_DRV_TEST
+	tristate "Test driver/device"
 	depends on RTC_CLASS
-
-# this 'CMOS' RTC driver is arch dependent because <asm-generic/rtc.h>
-# requires <asm/mc146818rtc.h> defining CMOS_READ/CMOS_WRITE, and a
-# global rtc_lock ... it's not yet just another platform_device.
-
-config RTC_DRV_CMOS
-	tristate "PC-style 'CMOS' real time clock"
-	depends on RTC_CLASS && (X86 || ALPHA || ARM26 || ARM \
-		|| M32R || ATARI || POWERPC)
-	help
-	  Say "yes" here to get direct support for the real time clock
-	  found in every PC or ACPI-based system, and some other boards.
-	  Specifically the original MC146818, compatibles like those in
-	  PC south bridges, the DS12887 or M48T86, some multifunction
-	  or LPC bus chips, and so on.
-
-	  Your system will need to define the platform device used by
-	  this driver, otherwise it won't be accessible.  This means
-	  you can safely enable this driver if you don't know whether
-	  or not your board has this kind of hardware.
-
-	  This driver can also be built as a module. If so, the module
-	  will be called rtc-cmos.
-
-config RTC_DRV_X1205
-	tristate "Xicor/Intersil X1205"
-	depends on RTC_CLASS && I2C
 	help
 	  If you say yes here you get support for the
-	  Xicor/Intersil X1205 RTC chip.
+	  RTC test driver. It's a software RTC which can be
+	  used to test the RTC subsystem APIs. It gets
+	  the time from the system clock.
+	  You want this driver only if you are doing development
+	  on the RTC subsystem. Please read the source code
+	  for further details.
 
 	  This driver can also be built as a module. If so, the module
-	  will be called rtc-x1205.
+	  will be called rtc-test.
+
+comment "I2C RTC drivers"
+	depends on RTC_CLASS
 
 config RTC_DRV_DS1307
-	tristate "Dallas/Maxim DS1307 and similar I2C RTC chips"
+	tristate "Dallas/Maxim DS1307/37/38/39/40, ST M41T00"
 	depends on RTC_CLASS && I2C
 	help
 	  If you say yes here you get support for various compatible RTC
@@ -156,53 +138,55 @@ config RTC_DRV_DS1307
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-ds1307.
 
-config RTC_DRV_DS1553
-	tristate "Dallas DS1553"
-	depends on RTC_CLASS
+config RTC_DRV_DS1672
+	tristate "Dallas/Maxim DS1672"
+	depends on RTC_CLASS && I2C
 	help
 	  If you say yes here you get support for the
-	  Dallas DS1553 timekeeping chip.
+	  Dallas/Maxim DS1672 timekeeping chip.
 
 	  This driver can also be built as a module. If so, the module
-	  will be called rtc-ds1553.
+	  will be called rtc-ds1672.
 
-config RTC_DRV_ISL1208
-	tristate "Intersil 1208"
+config RTC_DRV_MAX6900
+	tristate "Maxim 6900"
 	depends on RTC_CLASS && I2C
 	help
-	  If you say yes here you get support for the
-	  Intersil 1208 RTC chip.
+	  If you say yes here you will get support for the
+	  Maxim MAX6900 I2C RTC chip.
 
 	  This driver can also be built as a module. If so, the module
-	  will be called rtc-isl1208.
+	  will be called rtc-max6900.
 
-config RTC_DRV_DS1672
-	tristate "Dallas/Maxim DS1672"
+config RTC_DRV_RS5C372
+	tristate "Ricoh RS5C372A/B"
 	depends on RTC_CLASS && I2C
 	help
 	  If you say yes here you get support for the
-	  Dallas/Maxim DS1672 timekeeping chip.
+	  Ricoh RS5C372A and RS5C372B RTC chips.
 
 	  This driver can also be built as a module. If so, the module
-	  will be called rtc-ds1672.
+	  will be called rtc-rs5c372.
 
-config RTC_DRV_DS1742
-	tristate "Dallas DS1742/1743"
-	depends on RTC_CLASS
+config RTC_DRV_ISL1208
+	tristate "Intersil 1208"
+	depends on RTC_CLASS && I2C
 	help
 	  If you say yes here you get support for the
-	  Dallas DS1742/1743 timekeeping chip.
+	  Intersil 1208 RTC chip.
 
 	  This driver can also be built as a module. If so, the module
-	  will be called rtc-ds1742.
+	  will be called rtc-isl1208.
 
-config RTC_DRV_OMAP
-	tristate "TI OMAP1"
-	depends on RTC_CLASS && ( \
-		ARCH_OMAP15XX || ARCH_OMAP16XX || ARCH_OMAP730 )
+config RTC_DRV_X1205
+	tristate "Xicor/Intersil X1205"
+	depends on RTC_CLASS && I2C
 	help
-	  Say "yes" here to support the real time clock on TI OMAP1 chips.
-	  This driver can also be built as a module called rtc-omap.
+	  If you say yes here you get support for the
+	  Xicor/Intersil X1205 RTC chip.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-x1205.
 
 config RTC_DRV_PCF8563
 	tristate "Philips PCF8563/Epson RTC8564"
@@ -217,16 +201,20 @@ config RTC_DRV_PCF8563
 
 config RTC_DRV_PCF8583
 	tristate "Philips PCF8583"
-	depends on RTC_CLASS && I2C && ARCH_RPC
+	depends on RTC_CLASS && I2C
 	help
 	  If you say yes here you get support for the Philips PCF8583
-	  RTC chip found on Acorn RiscPCs.  This driver supports the
+	  RTC chip found on Acorn RiscPCs. This driver supports the
 	  platform specific method of retrieving the current year from
-	  the RTC's SRAM.
+	  the RTC's SRAM. It will work on other platforms with the same
+	  chip, but the year will probably have to be tweaked.
 
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-pcf8583.
 
+comment "SPI RTC drivers"
+	depends on RTC_CLASS
+
 config RTC_DRV_RS5C348
 	tristate "Ricoh RS5C348A/B"
 	depends on RTC_CLASS && SPI
@@ -237,15 +225,92 @@ config RTC_DRV_RS5C348
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-rs5c348.
 
-config RTC_DRV_RS5C372
-	tristate "Ricoh RS5C372A/B"
-	depends on RTC_CLASS && I2C
+config RTC_DRV_MAX6902
+	tristate "Maxim 6902"
+	depends on RTC_CLASS && SPI
+	help
+	  If you say yes here you will get support for the
+	  Maxim MAX6902 SPI RTC chip.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-max6902.
+
+comment "Platform RTC drivers"
+	depends on RTC_CLASS
+
+# this 'CMOS' RTC driver is arch dependent because <asm-generic/rtc.h>
+# requires <asm/mc146818rtc.h> defining CMOS_READ/CMOS_WRITE, and a
+# global rtc_lock ... it's not yet just another platform_device.
+
+config RTC_DRV_CMOS
+	tristate "PC-style 'CMOS'"
+	depends on RTC_CLASS && (X86 || ALPHA || ARM26 || ARM \
+		|| M32R || ATARI || POWERPC)
+	help
+	  Say "yes" here to get direct support for the real time clock
+	  found in every PC or ACPI-based system, and some other boards.
+	  Specifically the original MC146818, compatibles like those in
+	  PC south bridges, the DS12887 or M48T86, some multifunction
+	  or LPC bus chips, and so on.
+
+	  Your system will need to define the platform device used by
+	  this driver, otherwise it won't be accessible.  This means
+	  you can safely enable this driver if you don't know whether
+	  or not your board has this kind of hardware.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-cmos.
+
+config RTC_DRV_DS1553
+	tristate "Dallas DS1553"
+	depends on RTC_CLASS
 	help
 	  If you say yes here you get support for the
-	  Ricoh RS5C372A and RS5C372B RTC chips.
+	  Dallas DS1553 timekeeping chip.
 
 	  This driver can also be built as a module. If so, the module
-	  will be called rtc-rs5c372.
+	  will be called rtc-ds1553.
+
+config RTC_DRV_DS1742
+	tristate "Dallas DS1742/1743"
+	depends on RTC_CLASS
+	help
+	  If you say yes here you get support for the
+	  Dallas DS1742/1743 timekeeping chip.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-ds1742.
+
+config RTC_DRV_M48T86
+	tristate "ST M48T86/Dallas DS12887"
+	depends on RTC_CLASS
+	help
+	  If you say Y here you will get support for the
+	  ST M48T86 and Dallas DS12887 RTC chips.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-m48t86.
+
+config RTC_DRV_V3020
+	tristate "EM Microelectronic V3020"
+	depends on RTC_CLASS
+	help
+	  If you say yes here you will get support for the
+	  EM Microelectronic v3020 RTC chip.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-v3020.
+
+comment "on-CPU RTC drivers"
+	depends on RTC_CLASS
+
+config RTC_DRV_OMAP
+	tristate "TI OMAP1"
+	depends on RTC_CLASS && ( \
+		ARCH_OMAP15XX || ARCH_OMAP16XX || ARCH_OMAP730 )
+	help
+	  Say "yes" here to support the real time clock on TI OMAP1 chips.
+	  This driver can also be built as a module called rtc-omap.
 
 config RTC_DRV_S3C
 	tristate "Samsung S3C series SoC RTC"
@@ -263,16 +328,6 @@ config RTC_DRV_S3C
 	  This driver can also be build as a module. If so, the module
 	  will be called rtc-s3c.
 
-config RTC_DRV_M48T86
-	tristate "ST M48T86/Dallas DS12887"
-	depends on RTC_CLASS
-	help
-	  If you say Y here you will get support for the
-	  ST M48T86 and Dallas DS12887 RTC chips.
-
-	  This driver can also be built as a module. If so, the module
-	  will be called rtc-m48t86.
-
 config RTC_DRV_EP93XX
 	tristate "Cirrus Logic EP93XX"
 	depends on RTC_CLASS && ARCH_EP93XX
@@ -318,7 +373,7 @@ config RTC_DRV_PL031
 	depends on RTC_CLASS && ARM_AMBA
 	help
 	  If you say Y here you will get access to ARM AMBA
-	  PrimeCell PL031 UART found on certain ARM SOCs.
+	  PrimeCell PL031 RTC found on certain ARM SOCs.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called rtc-pl031.
@@ -329,51 +384,6 @@ config RTC_DRV_AT91RM9200
 	help
 	  Driver for the Atmel AT91RM9200's internal RTC (Realtime Clock).
 
-config RTC_DRV_TEST
-	tristate "Test driver/device"
-	depends on RTC_CLASS
-	help
-	  If you say yes here you get support for the
-	  RTC test driver. It's a software RTC which can be
-	  used to test the RTC subsystem APIs. It gets
-	  the time from the system clock.
-	  You want this driver only if you are doing development
-	  on the RTC subsystem. Please read the source code
-	  for further details.
-
-	  This driver can also be built as a module. If so, the module
-	  will be called rtc-test.
-
-config RTC_DRV_MAX6900
-	tristate "Maxim 6900"
-	depends on RTC_CLASS && I2C
-	help
-	  If you say yes here you will get support for the
-	  Maxim MAX6900 I2C RTC chip.
-
-	  This driver can also be built as a module. If so, the module
-	  will be called rtc-max6900.
-
-config RTC_DRV_MAX6902
-	tristate "Maxim 6902"
-	depends on RTC_CLASS && SPI
-	help
-	  If you say yes here you will get support for the
-	  Maxim MAX6902 spi RTC chip.
-
-	  This driver can also be built as a module. If so, the module
-	  will be called rtc-max6902.
-
-config RTC_DRV_V3020
-	tristate "EM Microelectronic V3020"
-	depends on RTC_CLASS
-	help
-	  If you say yes here you will get support for the
-	  EM Microelectronic v3020 RTC chip.
-
-	  This driver can also be built as a module. If so, the module
-	  will be called rtc-v3020.
-
 config RTC_DRV_BFIN
 	tristate "Blackfin On-Chip RTC"
 	depends on RTC_CLASS && BFIN
_

Patches currently in -mm which might be from a.zummo@towertech.it are

blackfin-on-chip-rtc-controller-driver.patch
rtc-add-rtc-rs5c313-driver.patch
rtc-add-rtc-rs5c313-driver-tidy.patch
rtc-add-rtc-rs5c313-driver-is-busted.patch
rtc-add-rtc-class-driver-for-the-maxim-max6900.patch
rtc-remove-sys-class-rtc-dev.patch
rtc-rtc-interfaces-dont-use-class_device.patch
rtc-simplified-rtc-sysfs-attribute-handling.patch
rtc-simplified-proc-driver-rtc-handling.patch
rtc-remove-rest-of-class_device.patch
rtc-suspend-resume-restores-system-clock.patch
rtc-kconfig-cleanup.patch
