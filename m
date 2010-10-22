From: akpm@linux-foundation.org
Subject: + isl29020-ambient-light-sensor-fix.patch added to -mm tree
Date: Fri, 22 Oct 2010 12:53:17 -0700
Message-ID: <201010221953.o9MJrHid004165@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38087 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759090Ab0JVTxu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Oct 2010 15:53:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@linux.intel.com, arjan@linux.intel.com, hong.liu@intel.com, kalhan.trisal@intel.com


The patch titled
     isl29020-ambient-light-sensor-fix
has been added to the -mm tree.  Its filename is
     isl29020-ambient-light-sensor-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isl29020-ambient-light-sensor-fix
From: Andrew Morton <akpm@linux-foundation.org>

put PM code under #ifdef CONFIG_PM

Cc: Alan Cox <alan@linux.intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Kalhan Trisal <kalhan.trisal@intel.com>
Cc: Liu Hong <hong.liu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/isl29020.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN drivers/misc/isl29020.c~isl29020-ambient-light-sensor-fix drivers/misc/isl29020.c
--- a/drivers/misc/isl29020.c~isl29020-ambient-light-sensor-fix
+++ a/drivers/misc/isl29020.c
@@ -192,6 +192,10 @@ static struct i2c_device_id isl29020_id[
 	{ }
 };
 
+MODULE_DEVICE_TABLE(i2c, isl29020_id);
+
+#ifdef CONFIG_PM
+
 static int isl29020_runtime_suspend(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
@@ -206,17 +210,20 @@ static int isl29020_runtime_resume(struc
 	return 0;
 }
 
-MODULE_DEVICE_TABLE(i2c, isl29020_id);
-
 static const struct dev_pm_ops isl29020_pm_ops = {
 	.runtime_suspend = isl29020_runtime_suspend,
 	.runtime_resume = isl29020_runtime_resume,
 };
 
+#define ISL29020_PM_OPS (&isl29020_pm_ops)
+#else	/* CONFIG_PM */
+#define ISL29020_PM_OPS NULL
+#endif	/* CONFIG_PM */
+
 static struct i2c_driver isl29020_driver = {
 	.driver = {
 		.name = "isl29020",
-		.pm = &isl29020_pm_ops,
+		.pm = ISL29020_PM_OPS,
 	},
 	.probe = isl29020_probe,
 	.remove = isl29020_remove,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
typesh-move-misplaced-comment.patch
kfifo-disable-__kfifo_must_check_helper.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
fs-inodec-work-around-bug.patch
arch-x86-kernel-entry_64s-fix-build-with-gas-2161.patch
arch-x86-kernel-entry_32s-i386-too.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-vmap-area-cache.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
fs-notify-fanotify-fanotify_userc-fix-warnings.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-add-led-trigger-for-input-subsystem-led-events.patch
backlight-add-low-threshold-to-pwm-backlight.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
drivers-message-fusion-mptsasc-fix-warning.patch
drivers-block-aoe-aoeblkc-ratelimit-a-warning-printk.patch
vfs-allow-mnt_want_write-to-sleep.patch
mm.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix-fix.patch
oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch
oom-fix-locking-for-oom_adj-and-oom_score_adj.patch
mm-only-build-per-node-scan_unevictable-functions-when-numa-is-enabled-cleanup.patch
memory-hotplug-unify-is_removable-and-offline-detection-code-checkpatch-fixes.patch
mm-stack-based-kmap_atomic-checkpatch-fixes.patch
mm-stack-based-kmap_atomic-fix.patch
mm-retry-page-fault-when-blocking-on-disk-transfer.patch
mm-retry-page-fault-when-blocking-on-disk-transfer-update-fix.patch
rmap-make-anon_vma_free-static-fix.patch
vmstat-include-compactionh-when-config_compaction-fix.patch
fs-fs-writebackc-restore-lost-comment.patch
mm-memory_hotplugc-make-scan_lru_pages-static.patch
proc-swaps-support-polling-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
hpet-factor-timer-allocate-from-open-fix.patch
drivers-char-hpetc-fix-information-leak-to-userland-fix.patch
kernelh-add-minmax3-macros-fix.patch
include-linux-kernelh-add-__must_check-to-strict_strto.patch
isl29020-ambient-light-sensor-fix.patch
printk-declare-printk_ratelimit_state-in-ratelimith-fix.patch
vsprintfc-use-default-pointer-field-size-for-null-strings-fix.patch
scripts-get_maintainerpl-add-git-blame-rolestats-authored-lines-information.patch
idr-fix-idr_pre_get-locking-description-fix.patch
percpu_counter-rename-__percpu_counter_add-to-percpu_counter_add_batch.patch
percpu_counters-inline-the-percpu_counter_add_batch-fastpath.patch
percpu_counters-inline-the-percpu_counter_add_batch-fastpath-fix.patch
checkpatch-returning-errno-typically-should-be-negative.patch
select-rename-estimate_accuracy-to-select_estimate_accuracy.patch
vcs-add-poll-fasync-support-fix-fix.patch
rtc-rtc-s3c-fix-access-unit-from-byte-to-word-on-rtccon-checkpatch-fixes.patch
drivers-rtc-rtc-jz4740c-add-alarm-function-checkpatch-fixes.patch
gpio-add-support-for-74x164-serial-in-parallel-out-8-bit-shift-register-fix.patch
gpio-add-topcliff-pch-gpio-driver-fix.patch
drivers-gpio-langwell_gpioc-remove-semicolons-after-function-definitions.patch
cgroup_freezer-update_freezer_state-does-incorrect-state-transitions-checkpatch-fixes.patch
memcg-cpu-hotplug-aware-quick-acount_move-detection-checkpatch-fixes.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2-checkpatch-fixes.patch
proc-stat-fix-scalability-of-irq-sum-of-all-cpu-fix.patch
drivers-char-hvc_consolec-remove-unneeded-__set_current_statetask_running.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
fuse-use-release_pages.patch
pps-add-async-pps-event-handler-fix.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-fix.patch
kernel-resourcec-handle-reinsertion-of-an-already-inserted-resource.patch
ramoops-use-the-platform-data-structure-instead-of-module-params-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

