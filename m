From: akpm@linux-foundation.org
Subject: - rtc-bcd-codeshrink.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:30:11 -0700
Message-ID: <200807242330.m6ONUB1q011471@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34746 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756780AbYGXXah (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:30:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, a.zummo@towertech.it, bunk@kernel.org, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     rtc: BCD codeshrink
has been removed from the -mm tree.  Its filename was
     rtc-bcd-codeshrink.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -18,7 +18,7 @@ lib-$(CONFIG_SMP) += cpumask.o
 
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

origin.patch
linux-next.patch
ntp-let-update_persistent_clock-sleep.patch
jffs2-summary-allocation-dont-use-vmalloc.patch
sm501-add-gpiolib-support.patch
sm501-gpio-dynamic-registration-for-pci-devices.patch
sm501-gpio-i2c-support.patch
rtc-rtc-rs5c372-smbus-conversion-support.patch
rtc-rtc-rs5c732-add-support-for-ricoh-r2025s-d-rtc.patch
gpio-sysfs-interface-updated-update.patch
gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support.patch
gpio-mcp23s08-handles-multiple-chips-per-chipselect.patch
gpio-add-bt8xxgpio-driver.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-fix.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-cleanup.patch
gpiolib-allow-user-selection.patch
gpiolib-allow-user-selection-update.patch
spi-add-spi-over-gpio-driver.patch
spi-add-spi-over-gpio-driver-v3.patch
mmc-add-gpio-based-mmc-sd-driver.patch
mmc-add-gpio-based-mmc-sd-driver-v3.patch
mmc-add-gpio-based-mmc-sd-driver-v3-fix-for-configfs-api-change.patch
mmc-add-gpio-based-mmc-sd-driver-add-documentation-abi-testing-configfs-gpiommc.patch
mmc-add-gpio-based-mmc-sd-driver-add-locking.patch

