From: akpm@linux-foundation.org
Subject: + rtc-avoid-legacy-drivers-with-generic-framework-update.patch added to -mm tree
Date: Mon, 10 Mar 2008 12:47:38 -0700
Message-ID: <200803101947.m2AJlcxo002361@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39572 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751175AbYCJTsJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 15:48:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net


The patch titled
     rtc-avoid-legacy-drivers-with-generic-framework update
has been added to the -mm tree.  Its filename is
     rtc-avoid-legacy-drivers-with-generic-framework-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
-			&& !ARM && !SUPERH && !S390 \
-			&& RTC_DRV_CMOS=n
+			&& !ARM && !SUPERH && !S390
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

git-acpi.patch
git-arm-master.patch
git-avr32.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
usb-net-asix-does-not-really-need-10-100mbit.patch
spi-pxa2xx_spi-sparse-fixes.patch
rtc-avoid-legacy-drivers-with-generic-framework.patch
rtc-avoid-legacy-drivers-with-generic-framework-update.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
rtc-silence-section-mismatch-warning-in-rtc-test.patch
make-ds1511_rtc_readset_time-static.patch
rtc-replace-remaining-__function__-occurrences.patch
remove-duplicated-unlikely-in-is_err.patch

