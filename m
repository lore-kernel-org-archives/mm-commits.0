From: akpm@linux-foundation.org
Subject: + pm-boot-time-suspend-selftest-update.patch added to -mm tree
Date: Sat, 12 Jul 2008 23:27:52 -0700
Message-ID: <200807130627.m6D6RqqC007938@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36999 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752542AbYGMG2b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jul 2008 02:28:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net, mingo@elte.hu, pavel@suse.cz, rjw@sisk.pl


The patch titled
     pm-boot-time-suspend-selftest update
has been added to the -mm tree.  Its filename is
     pm-boot-time-suspend-selftest-update.patch

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
Subject: pm-boot-time-suspend-selftest update
From: David Brownell <david-b@pacbell.net>

Address some of Andrew's comments on the patch now in MMOTM with name
"pm-boot-time-suspend-selftest.patch".

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Pavel Machek <pavel@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/main.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff -puN kernel/power/main.c~pm-boot-time-suspend-selftest-update kernel/power/main.c
--- a/kernel/power/main.c~pm-boot-time-suspend-selftest-update
+++ a/kernel/power/main.c
@@ -160,10 +160,19 @@ static void suspend_test_finish(const ch
 	long nj = jiffies - suspend_test_start_time;
 	unsigned msec;
 
-	msec = jiffies_to_msecs((nj >= 0) ? nj : -nj);
+	msec = jiffies_to_msecs(abs(nj));
 	pr_info("PM: %s took %d.%03d seconds\n", label,
 			msec / 1000, msec % 1000);
-	WARN_ON_ONCE(msec > (TEST_SUSPEND_SECONDS * 1000));
+
+	/* Warning on suspend means the RTC alarm period needs to be
+	 * larger -- the system was sooo slooowwww to suspend that the
+	 * alarm (should have) fired before the system went to sleep!
+	 *
+	 * Warning on either suspend or resume also means the system
+	 * has some performance issues.  The stack dump of a WARN_ON
+	 * is more likely to get the right attention than a printk...
+	 */
+	WARN_ON(msec > (TEST_SUSPEND_SECONDS * 1000));
 }
 
 #else
@@ -583,13 +592,13 @@ core_initcall(pm_init);
 
 static void __init test_wakealarm(struct rtc_device *rtc, suspend_state_t state)
 {
-	static char		err_readtime [] __initdata =
+	static char err_readtime[] __initdata =
 		KERN_ERR "PM: can't read %s time, err %d\n";
-	static char		err_wakealarm [] __initdata =
+	static char err_wakealarm [] __initdata =
 		KERN_ERR "PM: can't set %s wakealarm, err %d\n";
-	static char		err_suspend [] __initdata =
+	static char err_suspend[] __initdata =
 		KERN_ERR "PM: suspend test failed, error %d\n";
-	static char		info_test [] __initdata =
+	static char info_test[] __initdata =
 		KERN_INFO "PM: test RTC wakeup from '%s' suspend\n";
 
 	unsigned long		now;
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
rtc-fm3130-fix-chip-naming.patch
rtc-pcf8563-add-chip-id.patch
linux-next.patch
ntp-let-update_persistent_clock-sleep.patch
jffs2-summary-allocation-dont-use-vmalloc.patch
atmel_nand-speedup-via-readwritesbw.patch
pm-boot-time-suspend-selftest-update.patch
atmel_pwm-set-up-only-one-pwm-clock-when-allocating-a-clock.patch
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
rtc-ds1305-ds1306-driver-fix.patch
rtc-bcd-codeshrink.patch
rtc-rtc-omap-footprint-shrinkage.patch
rtc-convert-the-pcf8583-driver-to-the-new-i2c-style-framework-with-device_ids.patch
rtc-marvell-soc-rtc-driver.patch
gpio-gpio-driver-for-max7301-spi-gpio-expander.patch
gpio-gpio-driver-for-max7301-spi-gpio-expander-checkpatch-fixes.patch
gpio-sysfs-interface-updated-update.patch
gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support.patch
gpio-mcp23s08-handles-multiple-chips-per-chipselect.patch
gpio-add-bt8xxgpio-driver.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-fix.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-cleanup.patch
gpiolib-allow-user-selection.patch
gpiolib-allow-user-selection-update.patch

