From: akpm@linux-foundation.org
Subject: + rtc-bcd-codeshrink.patch added to -mm tree
Date: Wed, 02 Jul 2008 01:45:07 -0700
Message-ID: <200807020845.m628j7Gx007907@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35628 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752228AbYGBIqX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 04:46:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, a.zummo@towertech.it, bunk@kernel.org, dbrownell@users.sourceforge.net


The patch titled
     rtc: BCD codeshrink
has been added to the -mm tree.  Its filename is
     rtc-bcd-codeshrink.patch

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
Subject: rtc: BCD codeshrink
From: David Brownell <david-b@pacbell.net>

This updates <linux/bcd.h> to define the key routines as constant
functions, which the macros will then call.  Newer code can now call
bcd2bin() instead of SCREAMING BCD2BIN() TO THE FOUR WINDS.

This lets each driver shrink their codespace by using N function calls to
a single (global) copy of those routines, instead of N inlined copies of
these functions per driver.

These routines aren't used in speed-critical code.  Almost all callers are
in the RTC framework.  Typical per-driver savings is near 300 bytes.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Adrian Bunk <bunk@kernel.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bcd.h |    9 +++++++--
 lib/Makefile        |    2 +-
 lib/bcd.c           |   14 ++++++++++++++
 3 files changed, 22 insertions(+), 3 deletions(-)

diff -puN include/linux/bcd.h~rtc-bcd-codeshrink include/linux/bcd.h
--- a/include/linux/bcd.h~rtc-bcd-codeshrink
+++ a/include/linux/bcd.h
@@ -10,8 +10,13 @@
 #ifndef _BCD_H
 #define _BCD_H
 
-#define BCD2BIN(val)	(((val) & 0x0f) + ((val)>>4)*10)
-#define BIN2BCD(val)	((((val)/10)<<4) + (val)%10)
+#include <linux/compiler.h>
+
+unsigned bcd2bin(unsigned char val) __attribute_const__;
+unsigned char bin2bcd(unsigned val) __attribute_const__;
+
+#define BCD2BIN(val)	bcd2bin(val)
+#define BIN2BCD(val)	bin2bcd(val)
 
 /* backwards compat */
 #define BCD_TO_BIN(val) ((val)=BCD2BIN(val))
diff -puN lib/Makefile~rtc-bcd-codeshrink lib/Makefile
--- a/lib/Makefile~rtc-bcd-codeshrink
+++ a/lib/Makefile
@@ -22,7 +22,7 @@ lib-$(CONFIG_SMP) += cpumask.o
 
 lib-y	+= kobject.o kref.o klist.o
 
-obj-y += div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
+obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
diff -puN /dev/null lib/bcd.c
--- /dev/null
+++ a/lib/bcd.c
@@ -0,0 +1,14 @@
+#include <linux/bcd.h>
+#include <linux/module.h>
+
+unsigned bcd2bin(unsigned char val)
+{
+	return (val & 0x0f) + (val >> 4) * 10;
+}
+EXPORT_SYMBOL(bcd2bin);
+
+unsigned char bin2bcd(unsigned val)
+{
+	return ((val / 10) << 4) + val % 10;
+}
+EXPORT_SYMBOL(bin2bcd);
_

Patches currently in -mm which might be from david-b@pacbell.net are

rtc_read_alarm-handles-wraparound.patch
gpio-pca953x-i2c-handles-max7310-too.patch
linux-next.patch
ntp-let-update_persistent_clock-sleep.patch
jffs2-summary-allocation-dont-use-vmalloc.patch
atmel_nand-speedup-via-readwritesbw.patch
asic3-gpiolib-support.patch
asic3-remove-children-platform-data.patch
asic3-new-gpio-configuration-code.patch
sm501-add-gpiolib-support.patch
sm501-gpio-dynamic-registration-for-pci-devices.patch
sm501-gpio-i2c-support.patch
rtc-rtc-rs5c372-smbus-conversion-support.patch
rtc-rtc-rs5c732-add-support-for-ricoh-r2025s-d-rtc.patch
rtc-m41t80-sort-header-inclusions-for-readability.patch
rtc-m41t80-use-pr_info-as-appropriate.patch
rtc-remove-bkl-for-ioctl.patch
rtc-add-support-for-st-m41t94-spi-rtc.patch
rtc-ds1305-ds1306-driver.patch
rtc-bcd-codeshrink.patch
gpio-gpio-driver-for-max7301-spi-gpio-expander.patch
gpio-gpio-driver-for-max7301-spi-gpio-expander-checkpatch-fixes.patch
gpio-sysfs-interface-updated-update.patch
gpio-mcp23s08-handles-multiple-chips-per-chipselect.patch
gpio-add-bt8xxgpio-driver.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-fix.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-cleanup.patch

