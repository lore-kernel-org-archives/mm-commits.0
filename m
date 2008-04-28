From: akpm@linux-foundation.org
Subject: - rtc-avoid-legacy-drivers-with-generic-framework-update.patch removed from -mm tree
Date: Sun, 27 Apr 2008 23:44:25 -0700
Message-ID: <200804280644.m3S6iPwa012298@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39133 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756826AbYD1Gox (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 02:44:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     rtc-avoid-legacy-drivers-with-generic-framework update
has been removed from the -mm tree.  Its filename was
     rtc-avoid-legacy-drivers-with-generic-framework-update.patch

This patch was dropped because it was folded into rtc-avoid-legacy-drivers-with-generic-framework.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-avoid-legacy-drivers-with-generic-framework update
From: David Brownell <david-b@pacbell.net>

This is a harsher fix for the problems of trying to make legacy
RTCs coexist with the generic RTC framework:  Just Don't Do It.

The legacy drivers are not geared towards coexistence; they
never had a reason to try.  So rather than accumulating more
and more special cases, and gently nudging users away from the
old code, make it be an either/or choice.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/Kconfig |   12 ++++++++----
 drivers/rtc/Kconfig  |    4 ----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/char/Kconfig~rtc-avoid-legacy-drivers-with-generic-framework-update drivers/char/Kconfig
--- a/drivers/char/Kconfig~rtc-avoid-legacy-drivers-with-generic-framework-update
+++ a/drivers/char/Kconfig
@@ -713,14 +713,16 @@ config NVRAM
 	  To compile this driver as a module, choose M here: the
 	  module will be called nvram.
 
-comment "Avoid any legacy RTC drivers you may see here"
-	depends on RTC_LIB
+#
+# These legacy RTC drivers just cause too many conflicts with the generic
+# RTC framework ... let's not even try to coexist any more.
+#
+if RTC_LIB=n
 
 config RTC
 	tristate "Enhanced Real Time Clock Support"
 	depends on !PPC && !PARISC && !IA64 && !M68K && !SPARC && !FRV \
-			&& !ARM && !SUPERH && !S390 && !AVR32 \
-			&& RTC_DRV_CMOS=n
+			&& !ARM && !SUPERH && !S390 && !AVR32
 	---help---
 	  If you say Y here and create a character special file /dev/rtc with
 	  major number 10 and minor number 135 using mknod ("man mknod"), you
@@ -826,6 +828,8 @@ config DS1302
 	  will get access to the real time clock (or hardware clock) built
 	  into your computer.
 
+endif # RTC_LIB
+
 config COBALT_LCD
 	bool "Support for Cobalt LCD"
 	depends on MIPS_COBALT
diff -puN drivers/rtc/Kconfig~rtc-avoid-legacy-drivers-with-generic-framework-update drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-avoid-legacy-drivers-with-generic-framework-update
+++ a/drivers/rtc/Kconfig
@@ -20,10 +20,6 @@ menuconfig RTC_CLASS
 
 if RTC_CLASS
 
-if GEN_RTC || RTC
-comment "Conflicting RTC option has been selected, check GEN_RTC and RTC"
-endif
-
 config RTC_HCTOSYS
 	bool "Set system time from RTC on startup and resume"
 	depends on RTC_CLASS = y
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
rtc-avoid-legacy-drivers-with-generic-framework.patch
rtc-avoid-legacy-drivers-with-generic-framework-update.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-pcf8563-add-device-ids-table.patch
rtc-x1205-new-style-conversion.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
rtc-silence-section-mismatch-warning-in-rtc-test.patch
make-ds1511_rtc_readset_time-static.patch
kerneldoc-for-linux-clkh.patch
kerneldoc-for-linux-clkh-fix.patch
rtc-rtc-rs5c372-fix-up-null-name-in-transfer-error-path.patch
drivers-char-rtcc-use-time_before-time_before_eq-etc.patch
rtc-replace-remaining-__function__-occurrences.patch
spi-pxa2xx_spi-sparse-fixes.patch
atmel_spi-support-zero-length-transfer.patch
gpiochip_reserve-fix-2.patch

