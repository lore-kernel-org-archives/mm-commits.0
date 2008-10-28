From: akpm@linux-foundation.org
Subject: - rtc-rtc-wm8350-add-support-for-wm8350-rtc-fix.patch removed from -mm tree
Date: Mon, 27 Oct 2008 23:18:48 -0700
Message-ID: <200810280618.m9S6Im3I021078@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44434 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752481AbYJ1GTg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Oct 2008 02:19:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.zummo@towertech.it, broonie@opensource.wolfsonmicro.com, david-b@pacbell.net, linux@wolfsonmicro.com, mm-commits@vger.kernel.org


The patch titled
     rtc-rtc-wm8350-add-support-for-wm8350-rtc-fix
has been removed from the -mm tree.  Its filename was
     rtc-rtc-wm8350-add-support-for-wm8350-rtc-fix.patch

This patch was dropped because it was folded into rtc-rtc-wm8350-add-support-for-wm8350-rtc.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-rtc-wm8350-add-support-for-wm8350-rtc-fix
From: Andrew Morton <akpm@linux-foundation.org>

s/schedule_timeout_interruptible/schedule_timeout_uninterruptible/ to
prevent bogus timeout when signal_pending().

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <linux@wolfsonmicro.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-wm8350.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-wm8350.c~rtc-rtc-wm8350-add-support-for-wm8350-rtc-fix drivers/rtc/rtc-wm8350.c
--- a/drivers/rtc/rtc-wm8350.c~rtc-rtc-wm8350-add-support-for-wm8350-rtc-fix
+++ a/drivers/rtc/rtc-wm8350.c
@@ -121,7 +121,7 @@ static int wm8350_rtc_settime(struct dev
 	/* Wait until confirmation of stopping */
 	do {
 		rtc_ctrl = wm8350_reg_read(wm8350, WM8350_RTC_TIME_CONTROL);
-		schedule_timeout_interruptible(msecs_to_jiffies(1));
+		schedule_timeout_uninterruptible(msecs_to_jiffies(1));
 	} while (retries-- && !(rtc_ctrl & WM8350_RTC_STS));
 
 	if (!retries) {
@@ -204,7 +204,7 @@ static int wm8350_rtc_stop_alarm(struct 
 	/* Wait until confirmation of stopping */
 	do {
 		rtc_ctrl = wm8350_reg_read(wm8350, WM8350_RTC_TIME_CONTROL);
-		schedule_timeout_interruptible(msecs_to_jiffies(1));
+		schedule_timeout_uninterruptible(msecs_to_jiffies(1));
 	} while (retries-- && !(rtc_ctrl & WM8350_RTC_ALMSTS));
 
 	if (!(rtc_ctrl & WM8350_RTC_ALMSTS))
@@ -227,7 +227,7 @@ static int wm8350_rtc_start_alarm(struct
 	/* Wait until confirmation */
 	do {
 		rtc_ctrl = wm8350_reg_read(wm8350, WM8350_RTC_TIME_CONTROL);
-		schedule_timeout_interruptible(msecs_to_jiffies(1));
+		schedule_timeout_uninterruptible(msecs_to_jiffies(1));
 	} while (retries-- && rtc_ctrl & WM8350_RTC_ALMSTS);
 
 	if (rtc_ctrl & WM8350_RTC_ALMSTS)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

epoll-avoid-double-inserts-in-case-of-efault-checkpatch-fixes.patch
freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix.patch
fs-remove-prepare_write-commit_write-fix.patch
mm-write_cache_pages-writepage-error-fix.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
linux-timexh-cleanup-for-userspace-checkpatch-fixes.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
drivers-rtc-rtc-ds1286c-is-borked.patch
drivers-rtc-rtc-m48t35c-is-borked-too.patch
drivers-net-sfc-falconc-fix-min-warnings.patch
pci-uninline-pci_ioremap_bar.patch
autofs4-collect-version-check-return-checkpatch-fixes.patch
maintainers-make-ioat-easier-to-find.patch
add-new-framebuffer-driver-for-fujitsu-mb862xx-gdcs-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
fs-truncate-blocks-outside-i_size-after-generic_file_direct_write-error-fix.patch
init-properly-placing-noinline-keyword.patch
spi_gpio-driver-cleanups.patch
rtc-rtc-wm8350-add-support-for-wm8350-rtc.patch
rtc-rtc-wm8350-add-support-for-wm8350-rtc-fix.patch
ext3-add-support-for-non-native-signed-unsigned-htree-hash-algorithms-checkpatch-fixes.patch
quota-convert-union-in-mem_dqinfo-to-a-pointer-cleanup.patch
w1-export-w1_read_8-function-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
reiser4-broke.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

