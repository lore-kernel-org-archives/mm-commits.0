From: akpm@linux-foundation.org
Subject: [merged] rtc-kconfig-remove-unnecessary-dependencies.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:16:57 -0700
Message-ID: <20121005201657.9EF8F100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:36995 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566Ab2JEUQ6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:16:58 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so94002qae.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:16:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbyravarasu@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: kconfig: remove unnecessary dependencies.
has been removed from the -mm tree.  Its filename was
     rtc-kconfig-remove-unnecessary-dependencies.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: rtc: kconfig: remove unnecessary dependencies.

Remove "depends on RTC_CLASS = y" for multiple Kconfig definitions, as all
of them are already placed under "if RTC_CLASS".

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig |   26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff -puN drivers/rtc/Kconfig~rtc-kconfig-remove-unnecessary-dependencies drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-kconfig-remove-unnecessary-dependencies
+++ a/drivers/rtc/Kconfig
@@ -19,7 +19,6 @@ if RTC_CLASS
 
 config RTC_HCTOSYS
 	bool "Set system time from RTC on startup and resume"
-	depends on RTC_CLASS = y
 	default y
 	help
 	  If you say yes here, the system time (wall clock) will be set using
@@ -51,7 +50,6 @@ config RTC_HCTOSYS_DEVICE
 
 config RTC_DEBUG
 	bool "RTC debug support"
-	depends on RTC_CLASS = y
 	help
 	  Say yes here to enable debugging support in the RTC framework
 	  and individual RTC drivers.
@@ -61,7 +59,6 @@ comment "RTC interfaces"
 config RTC_INTF_SYSFS
 	boolean "/sys/class/rtc/rtcN (sysfs)"
 	depends on SYSFS
-	default RTC_CLASS
 	help
 	  Say yes here if you want to use your RTCs using sysfs interfaces,
 	  /sys/class/rtc/rtc0 through /sys/.../rtcN.
@@ -71,7 +68,6 @@ config RTC_INTF_SYSFS
 config RTC_INTF_PROC
 	boolean "/proc/driver/rtc (procfs for rtcN)"
 	depends on PROC_FS
-	default RTC_CLASS
 	help
 	  Say yes here if you want to use your system clock RTC through
 	  the proc interface, /proc/driver/rtc.
@@ -83,7 +79,6 @@ config RTC_INTF_PROC
 
 config RTC_INTF_DEV
 	boolean "/dev/rtcN (character devices)"
-	default RTC_CLASS
 	help
 	  Say yes here if you want to use your RTCs using the /dev
 	  interfaces, which "udev" sets up as /dev/rtc0 through
@@ -129,7 +124,7 @@ if I2C
 
 config RTC_DRV_88PM860X
 	tristate "Marvell 88PM860x"
-	depends on RTC_CLASS && I2C && MFD_88PM860X
+	depends on I2C && MFD_88PM860X
 	help
 	  If you say yes here you get support for RTC function in Marvell
 	  88PM860x chips.
@@ -139,7 +134,7 @@ config RTC_DRV_88PM860X
 
 config RTC_DRV_88PM80X
 	tristate "Marvell 88PM80x"
-	depends on RTC_CLASS && I2C && MFD_88PM800
+	depends on I2C && MFD_88PM800
 	help
 	  If you say yes here you get support for RTC function in Marvell
 	  88PM80x chips.
@@ -167,7 +162,7 @@ config RTC_DRV_DS1307
 
 config RTC_DRV_DS1374
 	tristate "Dallas/Maxim DS1374"
-	depends on RTC_CLASS && I2C
+	depends on I2C
 	help
 	  If you say yes here you get support for Dallas Semiconductor
 	  DS1374 real-time clock chips. If an interrupt is associated
@@ -187,7 +182,7 @@ config RTC_DRV_DS1672
 
 config RTC_DRV_DS3232
 	tristate "Dallas/Maxim DS3232"
-	depends on RTC_CLASS && I2C
+	depends on I2C
 	help
 	  If you say yes here you get support for Dallas Semiconductor
 	  DS3232 real-time clock chips. If an interrupt is associated
@@ -337,7 +332,7 @@ config RTC_DRV_TWL92330
 
 config RTC_DRV_TWL4030
 	tristate "TI TWL4030/TWL5030/TWL6030/TPS659x0"
-	depends on RTC_CLASS && TWL4030_CORE
+	depends on TWL4030_CORE
 	help
 	  If you say yes here you get support for the RTC on the
 	  TWL4030/TWL5030/TWL6030 family chips, used mostly with OMAP3 platforms.
@@ -560,7 +555,6 @@ config RTC_DRV_DS1302
 
 config RTC_DRV_DS1511
 	tristate "Dallas DS1511"
-	depends on RTC_CLASS
 	help
 	  If you say yes here you get support for the
 	  Dallas DS1511 timekeeping/watchdog chip.
@@ -605,7 +599,6 @@ config RTC_DRV_EFI
 
 config RTC_DRV_STK17TA8
 	tristate "Simtek STK17TA8"
-	depends on RTC_CLASS
 	help
 	  If you say yes here you get support for the
 	  Simtek STK17TA8 timekeeping chip.
@@ -742,7 +735,7 @@ config RTC_DRV_AB8500
 
 config RTC_DRV_NUC900
 	tristate "NUC910/NUC920 RTC driver"
-	depends on RTC_CLASS && ARCH_W90X900
+	depends on ARCH_W90X900
 	help
 	  If you say yes here you get support for the RTC subsystem of the
 	  NUC910/NUC920 used in embedded systems.
@@ -762,7 +755,6 @@ config RTC_DRV_DAVINCI
 config RTC_DRV_IMXDI
 	tristate "Freescale IMX DryIce Real Time Clock"
 	depends on SOC_IMX25
-	depends on RTC_CLASS
 	help
 	   Support for Freescale IMX DryIce RTC
 
@@ -822,7 +814,7 @@ config RTC_DRV_SA1100
 
 config RTC_DRV_SH
 	tristate "SuperH On-Chip RTC"
-	depends on RTC_CLASS && SUPERH && HAVE_CLK
+	depends on SUPERH && HAVE_CLK
 	help
 	  Say Y here to enable support for the on-chip RTC found in
 	  most SuperH processors.
@@ -1054,7 +1046,6 @@ config RTC_DRV_MPC5121
 
 config RTC_DRV_JZ4740
 	tristate "Ingenic JZ4740 SoC"
-	depends on RTC_CLASS
 	depends on MACH_JZ4740
 	help
 	  If you say yes here you get support for the Ingenic JZ4740 SoC RTC
@@ -1084,7 +1075,7 @@ config RTC_DRV_PM8XXX
 
 config RTC_DRV_TEGRA
 	tristate "NVIDIA Tegra Internal RTC driver"
-	depends on RTC_CLASS && ARCH_TEGRA
+	depends on ARCH_TEGRA
 	help
 	  If you say yes here you get support for the
 	  Tegra 200 series internal RTC module.
@@ -1121,7 +1112,6 @@ config RTC_DRV_LOONGSON1
 config RTC_DRV_MXC
 	tristate "Freescale MXC Real Time Clock"
 	depends on ARCH_MXC
-	depends on RTC_CLASS
 	help
 	   If you say yes here you get support for the Freescale MXC
 	   RTC module.
_

Patches currently in -mm which might be from vbyravarasu@nvidia.com are

origin.patch
linux-next.patch

