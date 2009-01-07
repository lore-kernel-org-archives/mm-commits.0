From: akpm@linux-foundation.org
Subject: - rtc-kconfig-cleanup.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:19:07 -0800
Message-ID: <200901072219.n07MJ7ee018482@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52650 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932306AbZAGWhh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:37:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc: kconfig cleanup
has been removed from the -mm tree.  Its filename was
     rtc-kconfig-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: kconfig cleanup
From: Alessandro Zummo <a.zummo@towertech.it>

Remove double spaces and adds some suggestions.  It also fixes the
descriptions of options that are no more available as modules.

Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig |   52 +++++++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff -puN drivers/rtc/Kconfig~rtc-kconfig-cleanup drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-kconfig-cleanup
+++ a/drivers/rtc/Kconfig
@@ -35,8 +35,8 @@ config RTC_HCTOSYS_DEVICE
 	default "rtc0"
 	help
 	  The RTC device that will be used to (re)initialize the system
-	  clock, usually rtc0.  Initialization is done when the system
-	  starts up, and when it resumes from a low power state.  This
+	  clock, usually rtc0. Initialization is done when the system
+	  starts up, and when it resumes from a low power state. This
 	  device should record time in UTC, since the kernel won't do
 	  timezone correction.
 
@@ -44,7 +44,7 @@ config RTC_HCTOSYS_DEVICE
 	  functions run, so it must usually be statically linked.
 
 	  This clock should be battery-backed, so that it reads the correct
-	  time when the system boots from a power-off state.  Otherwise, your
+	  time when the system boots from a power-off state. Otherwise, your
 	  system will need an external clock source (like an NTP server).
 
 	  If the clock you specify here is not battery backed, it may still
@@ -69,8 +69,7 @@ config RTC_INTF_SYSFS
 	  Say yes here if you want to use your RTCs using sysfs interfaces,
 	  /sys/class/rtc/rtc0 through /sys/.../rtcN.
 
-	  This driver can also be built as a module. If so, the module
-	  will be called rtc-sysfs.
+	  If unsure, say Y.
 
 config RTC_INTF_PROC
 	boolean "/proc/driver/rtc (procfs for rtc0)"
@@ -78,11 +77,10 @@ config RTC_INTF_PROC
 	default RTC_CLASS
 	help
 	  Say yes here if you want to use your first RTC through the proc
-	  interface, /proc/driver/rtc.  Other RTCs will not be available
+	  interface, /proc/driver/rtc. Other RTCs will not be available
 	  through that API.
 
-	  This driver can also be built as a module. If so, the module
-	  will be called rtc-proc.
+	  If unsure, say Y.
 
 config RTC_INTF_DEV
 	boolean "/dev/rtcN (character devices)"
@@ -90,12 +88,14 @@ config RTC_INTF_DEV
 	help
 	  Say yes here if you want to use your RTCs using the /dev
 	  interfaces, which "udev" sets up as /dev/rtc0 through
-	  /dev/rtcN.  You may want to set up a symbolic link so one
-	  of these can be accessed as /dev/rtc, which is a name
-	  expected by "hwclock" and some other programs.
+	  /dev/rtcN.
 
-	  This driver can also be built as a module. If so, the module
-	  will be called rtc-dev.
+	  You may want to set up a symbolic link so one of these
+	  can be accessed as /dev/rtc, which is a name
+	  expected by "hwclock" and some other programs. Recent
+	  versions of "udev" are known to set up the symlink for you.
+
+	  If unsure, say Y.
 
 config RTC_INTF_DEV_UIE_EMUL
 	bool "RTC UIE emulation on dev interface"
@@ -132,14 +132,14 @@ config RTC_DRV_DS1307
 	tristate "Dallas/Maxim DS1307/37/38/39/40, ST M41T00"
 	help
 	  If you say yes here you get support for various compatible RTC
-	  chips (often with battery backup) connected with I2C.  This driver
+	  chips (often with battery backup) connected with I2C. This driver
 	  should handle DS1307, DS1337, DS1338, DS1339, DS1340, ST M41T00,
-	  and probably other chips.  In some cases the RTC must already
+	  and probably other chips. In some cases the RTC must already
 	  have been initialized (by manufacturing or a bootloader).
 
 	  The first seven registers on these chips hold an RTC, and other
 	  registers may add features such as NVRAM, a trickle charger for
-	  the RTC/NVRAM backup power, and alarms.  NVRAM is visible in
+	  the RTC/NVRAM backup power, and alarms. NVRAM is visible in
 	  sysfs, but other chip features may not be available.
 
 	  This driver can also be built as a module. If so, the module
@@ -150,10 +150,10 @@ config RTC_DRV_DS1374
 	depends on RTC_CLASS && I2C
 	help
 	  If you say yes here you get support for Dallas Semiconductor
-	  DS1374 real-time clock chips.  If an interrupt is associated
+	  DS1374 real-time clock chips. If an interrupt is associated
 	  with the device, the alarm functionality is supported.
 
-	  This driver can also be built as a module.  If so, the module
+	  This driver can also be built as a module. If so, the module
 	  will be called rtc-ds1374.
 
 config RTC_DRV_DS1672
@@ -247,7 +247,7 @@ config RTC_DRV_TWL92330
 	help
 	  If you say yes here you get support for the RTC on the
 	  TWL92330 "Menelaus" power management chip, used with OMAP2
-	  platforms.  The support is integrated with the rest of
+	  platforms. The support is integrated with the rest of
 	  the Menelaus driver; it's not separate module.
 
 config RTC_DRV_TWL4030
@@ -308,7 +308,7 @@ config RTC_DRV_DS1305
 	tristate "Dallas/Maxim DS1305/DS1306"
 	help
 	  Select this driver to get support for the Dallas/Maxim DS1305
-	  and DS1306 real time clock chips.  These support a trickle
+	  and DS1306 real time clock chips. These support a trickle
 	  charger, alarms, and NVRAM in addition to the clock.
 
 	  This driver can also be built as a module. If so, the module
@@ -382,7 +382,7 @@ config RTC_DRV_CMOS
 	  or LPC bus chips, and so on.
 
 	  Your system will need to define the platform device used by
-	  this driver, otherwise it won't be accessible.  This means
+	  this driver, otherwise it won't be accessible. This means
 	  you can safely enable this driver if you don't know whether
 	  or not your board has this kind of hardware.
 
@@ -599,7 +599,7 @@ config RTC_DRV_AT91RM9200
 	depends on ARCH_AT91RM9200 || ARCH_AT91SAM9RL
 	help
 	  Driver for the internal RTC (Realtime Clock) module found on
-	  Atmel AT91RM9200's and AT91SAM9RL chips.  On SAM9RL chips
+	  Atmel AT91RM9200's and AT91SAM9RL chips. On SAM9RL chips
 	  this is powered by the backup power supply.
 
 config RTC_DRV_AT91SAM9
@@ -621,8 +621,8 @@ config RTC_DRV_AT91SAM9_RTT
 	prompt "RTT module Number" if ARCH_AT91SAM9263
 	depends on RTC_DRV_AT91SAM9
 	help
-	  More than one RTT module is available.  You can choose which
-	  one will be used as an RTC.  The default of zero is normally
+	  More than one RTT module is available. You can choose which
+	  one will be used as an RTC. The default of zero is normally
 	  OK to use, though some systems use that for non-RTC purposes.
 
 config RTC_DRV_AT91SAM9_GPBR
@@ -634,8 +634,8 @@ config RTC_DRV_AT91SAM9_GPBR
 	depends on RTC_DRV_AT91SAM9
 	help
 	  The RTC driver needs to use one of the General Purpose Backup
-	  Registers (GPBRs) as well as the RTT.  You can choose which one
-	  will be used.  The default of zero is normally OK to use, but
+	  Registers (GPBRs) as well as the RTT. You can choose which one
+	  will be used. The default of zero is normally OK to use, but
 	  on some systems other software needs to use that register.
 
 config RTC_DRV_BFIN
_

Patches currently in -mm which might be from a.zummo@towertech.it are

origin.patch
linux-next.patch
rtc-ds1307-smbus-compatibility.patch
rtc-ds1307-remove-legacy-probe-checks.patch

