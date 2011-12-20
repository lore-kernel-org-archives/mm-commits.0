From: akpm@linux-foundation.org
Subject: [folded] leds-add-driver-for-tca6507-led-controller-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 20 Dec 2011 14:21:44 -0800
Message-ID: <20111220222144.73E711E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:37818 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180Ab1LTWVp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Dec 2011 17:21:45 -0500
Received: by mail-gy0-f202.google.com with SMTP id r15so636515ghr.1
        for <mm-commits@vger.kernel.org>; Tue, 20 Dec 2011 14:21:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, neilb@suse.de, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: leds-add-driver-for-tca6507-led-controller-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     leds-add-driver-for-tca6507-led-controller-checkpatch-fixes.patch

This patch was dropped because it was folded into leds-add-driver-for-tca6507-led-controller.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: leds-add-driver-for-tca6507-led-controller-checkpatch-fixes

Cc: NeilBrown <neilb@suse.de>

WARNING: please write a paragraph that describes the config symbol fully
#31: FILE: drivers/leds/Kconfig:394:
+	help

WARNING: line over 80 characters
#69: FILE: drivers/leds/leds-tca6507.c:16:
+ * each 8msec that the led is 'on'.  The levels are named MASTER, BANK0 and BANK1.

WARNING: line over 80 characters
#71: FILE: drivers/leds/leds-tca6507.c:18:
+ * There are two different blink rates that can be programmed, each with separate

WARNING: line over 80 characters
#75: FILE: drivers/leds/leds-tca6507.c:22:
+ * This drivers does not support double-blink so 'second-off' always matches 'off'.

WARNING: line over 80 characters
#93: FILE: drivers/leds/leds-tca6507.c:40:
+ * brightness is used.  As 'full' is always available, the worst case would be to

WARNING: line over 80 characters
#97: FILE: drivers/leds/leds-tca6507.c:44:
+ * Each bank (BANK0 and BANK1) have two usage counts - Leds using the brightness and

WARNING: line over 80 characters
#102: FILE: drivers/leds/leds-tca6507.c:49:
+ * there is a flag saying if it was explicitly requested or defaulted.  Similarly

WARNING: line over 80 characters
#103: FILE: drivers/leds/leds-tca6507.c:50:
+ * the banks know if each time was explicit or a default.  Defaults are permitted

ERROR: open brace '{' following function declarations go on the next line
#170: FILE: drivers/leds/leds-tca6507.c:117:
+static inline int TO_LEVEL(int brightness) {

ERROR: open brace '{' following function declarations go on the next line
#174: FILE: drivers/leds/leds-tca6507.c:121:
+static inline int TO_BRIGHT(int level) {

WARNING: line over 80 characters
#203: FILE: drivers/leds/leds-tca6507.c:150:
+		int			blink;	/* 1 if we are hardware-blinking */

WARNING: line over 80 characters
#222: FILE: drivers/leds/leds-tca6507.c:169:
+	 * the first pair so there is more change-time visible (i.e. it is softer).

ERROR: space required before the open parenthesis '('
#300: FILE: drivers/leds/leds-tca6507.c:247:
+	switch(bank) {

total: 3 errors, 10 warnings, 732 lines checked

./patches/leds-add-driver-for-tca6507-led-controller.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: NeilBrown <neilb@suse.de>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-tca6507.c |   75 +++++++++++++++++++---------------
 1 file changed, 42 insertions(+), 33 deletions(-)

diff -puN drivers/leds/leds-tca6507.c~leds-add-driver-for-tca6507-led-controller-checkpatch-fixes drivers/leds/leds-tca6507.c
--- a/drivers/leds/leds-tca6507.c~leds-add-driver-for-tca6507-led-controller-checkpatch-fixes
+++ a/drivers/leds/leds-tca6507.c
@@ -13,13 +13,16 @@
  *
  * Apart from OFF and ON there are three programmable brightness levels which
  * can be programmed from 0 to 15 and indicate how many 500usec intervals in
- * each 8msec that the led is 'on'.  The levels are named MASTER, BANK0 and BANK1.
+ * each 8msec that the led is 'on'.  The levels are named MASTER, BANK0 and
+ * BANK1.
  *
- * There are two different blink rates that can be programmed, each with separate
- * time for rise, on, fall, off and second-off.  Thus if 3 or more different
- * non-trivial rates are required, software must be used for the extra rates.
- * The two different blink rates must align with the two levels BANK0 and BANK1.
- * This drivers does not support double-blink so 'second-off' always matches 'off'.
+ * There are two different blink rates that can be programmed, each with
+ * separate time for rise, on, fall, off and second-off.  Thus if 3 or more
+ * different non-trivial rates are required, software must be used for the extra
+ * rates. The two different blink rates must align with the two levels BANK0 and
+ * BANK1.
+ * This driver does not support double-blink so 'second-off' always matches
+ * 'off'.
  *
  * Only 16 different times can be programmed is a roughly logarithmic scale from
  * 64ms to 16320ms.   Times that cannot be closely matched with these must be
@@ -35,20 +38,20 @@
  * either same blink rates, or some don't blink.
  * When a led changes, it relinquishes access and tries again, so it might
  * lose access to hardware blink.
- * If a blink engine cannot be allocated, software blink is used.
- * If the desired brightness cannot be allocated, the closest available non-zero
- * brightness is used.  As 'full' is always available, the worst case would be to
- * have two different blink rates at '1', with Max at '2', then other leds will
- * have to choose between '2' and '16'.  Hopefully this is not likely.
+ * If a blink engine cannot be allocated, software blink is used.  If the
+ * desired brightness cannot be allocated, the closest available non-zero
+ * brightness is used.  As 'full' is always available, the worst case would be
+ * to have two different blink rates at '1', with Max at '2', then other leds
+ * will have to choose between '2' and '16'.  Hopefully this is not likely.
  *
- * Each bank (BANK0 and BANK1) have two usage counts - Leds using the brightness and
- * Leds using the blink.  It can only be reprogrammed when appropriate counter
- * is zero.  The MASTER level has as single usage count.
+ * Each bank (BANK0 and BANK1) have two usage counts - Leds using the brightness
+ * and leds using the blink.  It can only be reprogrammed when appropriate
+ * counter is zero.  The MASTER level has as single usage count.
  *
  * Each Led has programmable 'on' and 'off' time as milliseconds.  With each
- * there is a flag saying if it was explicitly requested or defaulted.  Similarly
- * the banks know if each time was explicit or a default.  Defaults are permitted
- * to be changed freely - they are not recognised when matching.
+ * there is a flag saying if it was explicitly requested or defaulted.
+ * Similarly the banks know if each time was explicit or a default.  Defaults
+ * are permitted to be changed freely - they are not recognised when matching.
  *
  *
  * An led-tca6507 device must be provided with platform data.  This data
@@ -114,11 +117,14 @@ static int time_codes[TIMECODES] = {
 };
 
 /* Convert an led.brightness level (0..255) to a TCA6507 level (0..15) */
-static inline int TO_LEVEL(int brightness) {
+static inline int TO_LEVEL(int brightness)
+{
 	return brightness >> 4;
 }
+
 /* ...and convert back */
-static inline int TO_BRIGHT(int level) {
+static inline int TO_BRIGHT(int level)
+{
 	if (level)
 		return (level << 4) | 0xf;
 	return 0;
@@ -162,11 +168,13 @@ MODULE_DEVICE_TABLE(i2c, tca6507);
 
 static int choose_times(int msec, int *c1p, int *c2p)
 {
-	/* Chose two timecodes which add to 'msec' as near as possible.
+	/*
+	 * Choose two timecodes which add to 'msec' as near as possible.
 	 * The first returned should be the larger.
 	 * If cannot get within 1/8, fail.
 	 * If two possibilities are equally good (e.g. 512+0, 256+256), choose
-	 * the first pair so there is more change-time visible (i.e. it is softer).
+	 * the first pair so there is more change-time visible (i.e. it is
+	 * softer).
 	 */
 	int c1, c2;
 	int tmax = msec * 9 / 8;
@@ -210,16 +218,16 @@ static int choose_times(int msec, int *c
  */
 static void set_select(struct tca6507_chip *tca, int led, int val)
 {
-	int mask = (1<<led);
+	int mask = (1 << led);
 	int bit;
 
 	for (bit = 0; bit < 3; bit++) {
 		int n = tca->reg_file[bit] & ~mask;
-		if (val & (1<<bit))
+		if (val & (1 << bit))
 			n |= mask;
 		if (tca->reg_file[bit] != n) {
 			tca->reg_file[bit] = n;
-			tca->reg_set |= (1<<bit);
+			tca->reg_set |= (1 << bit);
 		}
 	}
 }
@@ -244,7 +252,7 @@ static void set_code(struct tca6507_chip
 /* Update brightness level. */
 static void set_level(struct tca6507_chip *tca, int bank, int level)
 {
-	switch(bank) {
+	switch (bank) {
 	case BANK0:
 	case BANK1:
 		set_code(tca, TCA6507_MAX_INTENSITY, bank, level);
@@ -313,9 +321,7 @@ static void led_release(struct tca6507_l
 
 static int led_prepare(struct tca6507_led *led)
 {
-	/* Assign this led to a bank. configuring that
-	 * bank if necessary.
-	 */
+	/* Assign this led to a bank. configuring that bank if necessary */
 	int level = TO_LEVEL(led->led_cdev.brightness);
 	struct tca6507_chip *tca = led->chip;
 	int c1, c2;
@@ -330,7 +336,8 @@ static int led_prepare(struct tca6507_le
 	}
 
 	if (led->ontime == 0 || led->offtime == 0) {
-		/* Just set the brightness, choosing first usable bank.
+		/*
+		 * Just set the brightness, choosing first usable bank.
 		 * If none perfect, choose best.
 		 * Count backwards so we check MASTER bank first
 		 * to avoid wasting a timer.
@@ -458,8 +465,9 @@ static int led_assign(struct tca6507_led
 	led_release(led);
 	err = led_prepare(led);
 	if (err) {
-		/* Can only fail on timer setup.  In that
-		 * case need to re-establish as steady level.
+		/*
+		 * Can only fail on timer setup.  In that case we need to
+		 * re-establish as steady level.
 		 */
 		led->ontime = 0;
 		led->offtime = 0;
@@ -526,8 +534,9 @@ static void tca6507_gpio_set_value(struc
 	struct tca6507_chip *tca = container_of(gc, struct tca6507_chip, gpio);
 
 	spin_lock(&tca->lock);
-	/* 'OFF' is floating high, and 'ON' is pulled down, so it has
-	 * the inverse sense of 'val'.
+	/*
+	 * 'OFF' is floating high, and 'ON' is pulled down, so it has the
+	 * inverse sense of 'val'.
 	 */
 	set_select(tca, tca->gpio_map[offset],
 		   val ? TCA6507_LS_LED_OFF : TCA6507_LS_LED_ON);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs-fix.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-fix.patch
drivers-platform-x86-sony-laptopc-fix-scancodes-checkpatch-fixes.patch
drivers-platform-x86-sony-laptopc-fix-scancodes-v2-checkpatch-fixes.patch
slub-document-setting-min-order-with-debug_guardpage_minorder-0-checkpatch-fixes.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix.patch
mm-more-intensive-memory-corruption-debug-fix.patch
mm-exclude-reserved-pages-from-dirtyable-memory-fix.patch
mm-simplify-find_vma_prev-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
leds-add-driver-for-tca6507-led-controller.patch
checkpatch-improve-memset-and-min-max-with-cast-checking-fix.patch
checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line-checkpatch-fixes.patch
drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc-fix.patch
drivers-rtc-rtc-mxcc-make-alarm-work-fix.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-checkpatch-fixes.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-v3-checkpatch-fixes.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient-fix.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix.patch
memcg-simplify-lru-handling-by-new-rule-fix.patch
procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch
kexec-remove-kmsg_dump_kexec.patch
panic-dont-print-redundant-backtraces-on-oops-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
selftests-new-very-basic-kernel-selftests-directory.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix.patch
fixed-use-of-rounddown_pow_of_two-in-ramoops.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

