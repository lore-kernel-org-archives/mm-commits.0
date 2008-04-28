From: akpm@linux-foundation.org
Subject: - rtc-avoid-legacy-drivers-with-generic-framework.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:50:05 -0700
Message-ID: <200804282150.m3SLo5hE017444@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45823 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934282AbYD1Vu2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:50:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     rtc: avoid legacy drivers with generic framework
has been removed from the -mm tree.  Its filename was
     rtc-avoid-legacy-drivers-with-generic-framework.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: avoid legacy drivers with generic framework
From: David Brownell <david-b@pacbell.net>

Kconfig tweaks to help reduce RTC configuration bugs, by avoiding
legacy RTC drivers when the generic RTC framework is enabled:

 - If rtc-cmos is selected, disable the legacy rtc driver;

 - When using generic RTC on x86, enable rtc-cmos by default;

 - In the old "chardev RTC" section of Kconfig, add a comment
   warning people off these (seven) legacy RTC drivers when
   the generic framework is in use.

People can still use the legacy drivers if they want (or need) to.

This doesn't fix the broken dependencies for the legacy "CMOS" RTC driver. 
Ideally it would be a full list of platforms where it works, not a partial
list of ones where it won't.  Or better yet, it would depend on a
"HAVE_CMOS_RTC" flag defined by various platforms ...  surely there's a
Kconfig style guideline lurking there.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/Kconfig |   11 ++++++++++-
 drivers/rtc/Kconfig  |    5 +----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff -puN drivers/char/Kconfig~rtc-avoid-legacy-drivers-with-generic-framework drivers/char/Kconfig
--- a/drivers/char/Kconfig~rtc-avoid-legacy-drivers-with-generic-framework
+++ a/drivers/char/Kconfig
@@ -732,9 +732,16 @@ config NVRAM
 	  To compile this driver as a module, choose M here: the
 	  module will be called nvram.
 
+#
+# These legacy RTC drivers just cause too many conflicts with the generic
+# RTC framework ... let's not even try to coexist any more.
+#
+if RTC_LIB=n
+
 config RTC
 	tristate "Enhanced Real Time Clock Support"
-	depends on !PPC && !PARISC && !IA64 && !M68K && !SPARC && !FRV && !ARM && !SUPERH && !S390 && !AVR32
+	depends on !PPC && !PARISC && !IA64 && !M68K && !SPARC && !FRV \
+			&& !ARM && !SUPERH && !S390 && !AVR32
 	---help---
 	  If you say Y here and create a character special file /dev/rtc with
 	  major number 10 and minor number 135 using mknod ("man mknod"), you
@@ -840,6 +847,8 @@ config DS1302
 	  will get access to the real time clock (or hardware clock) built
 	  into your computer.
 
+endif # RTC_LIB
+
 config COBALT_LCD
 	bool "Support for Cobalt LCD"
 	depends on MIPS_COBALT
diff -puN drivers/rtc/Kconfig~rtc-avoid-legacy-drivers-with-generic-framework drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-avoid-legacy-drivers-with-generic-framework
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
@@ -304,6 +300,7 @@ comment "Platform RTC drivers"
 config RTC_DRV_CMOS
 	tristate "PC-style 'CMOS'"
 	depends on X86 || ALPHA || ARM || M32R || ATARI || PPC || MIPS
+	default y if X86
 	help
 	  Say "yes" here to get direct support for the real time clock
 	  found in every PC or ACPI-based system, and some other boards.
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
rtc-rtc-rs5c372-smbus-conversion-support.patch
rtc-rtc-rs5c732-add-support-for-ricoh-r2025s-d-rtc.patch
git-acpi.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
git-mmc.patch
jffs2-summary-allocation-dont-use-vmalloc.patch
fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout.patch
remove-duplicated-unlikely-in-is_err.patch

