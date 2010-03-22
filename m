From: akpm@linux-foundation.org
Subject: [merged] timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch removed from -mm tree
Date: Mon, 22 Mar 2010 11:31:13 -0400
Message-ID: <201003221832.o2MIW3gs019967@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754143Ab0CVSc0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 14:32:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     timer stats: fix del_timer_sync() and try_to_del_timer_sync()
has been removed from the -mm tree.  Its filename was
     timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: timer stats: fix del_timer_sync() and try_to_del_timer_sync()
From: Andrew Morton <akpm@linux-foundation.org>

These functions forgot to run timer_stats_timer_clear_start_info().  It's
unobvious what effect this has and whether it matters much - we won't be
printing it out anyway if the timer's detached.

Untested, just an Ingo trollpatch.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/timer.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/timer.c~timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync kernel/timer.c
--- a/kernel/timer.c~timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync
+++ a/kernel/timer.c
@@ -880,6 +880,7 @@ int try_to_del_timer_sync(struct timer_l
 	if (base->running_timer == timer)
 		goto out;
 
+	timer_stats_timer_clear_start_info(timer);
 	ret = 0;
 	if (timer_pending(timer)) {
 		detach_timer(timer, 1);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-i2c-busses-i2c-xiicc-is-borked.patch
rtc-davinci-rtc-driver-checkpatch-fixes.patch
c2port-fix-device_create-return-value-check-fix.patch
drivers-acpi-use-kasprintf-fix.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix-fix2.patch
led-driver-for-the-soekris-net5501-board-checkpatch-fixes.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
3x59x-fix-pci-resource-management.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
memcg-oom-kill-disable-and-oom-status-update-checkpatch-fixes.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
bitops-remove-temporary-for_each_bit.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch

