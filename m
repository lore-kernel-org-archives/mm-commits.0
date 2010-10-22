From: akpm@linux-foundation.org
Subject: + percpu_counters-inline-the-percpu_counter_add_batch-fastpath-fix.patch added to -mm tree
Date: Thu, 21 Oct 2010 22:13:09 -0700
Message-ID: <201010220512.o9M5CpKC027845@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60032 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752646Ab0JVFMx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Oct 2010 01:12:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, cl@linux-foundation.org, eric.dumazet@gmail.com


The patch titled
     percpu_counters-inline-the-percpu_counter_add_batch-fastpath-fix
has been added to the -mm tree.  Its filename is
     percpu_counters-inline-the-percpu_counter_add_batch-fastpath-fix.patch

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
Subject: percpu_counters-inline-the-percpu_counter_add_batch-fastpath-fix
From: Andrew Morton <akpm@linux-foundation.org>

fix 32-bit overflows.  Make things worse.

Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu_counter.h |    9 +++++----
 lib/percpu_counter.c           |    8 +++++---
 2 files changed, 10 insertions(+), 7 deletions(-)

diff -puN include/linux/percpu_counter.h~percpu_counters-inline-the-percpu_counter_add_batch-fastpath-fix include/linux/percpu_counter.h
--- a/include/linux/percpu_counter.h~percpu_counters-inline-the-percpu_counter_add_batch-fastpath-fix
+++ a/include/linux/percpu_counter.h
@@ -43,7 +43,7 @@ void percpu_counter_destroy(struct percp
 void percpu_counter_set(struct percpu_counter *fbc, s64 amount);
 s64 __percpu_counter_sum(struct percpu_counter *fbc);
 int percpu_counter_compare(struct percpu_counter *fbc, s64 rhs);
-void percpu_counter_handle_overflow(struct percpu_counter *fbc);
+void percpu_counter_handle_overflow(struct percpu_counter *fbc, s64 amount);
 
 static __always_inline void percpu_counter_add_batch(struct percpu_counter *fbc,
 						s64 amount, long batch)
@@ -52,9 +52,10 @@ static __always_inline void percpu_count
 
 	preempt_disable();
 	pcounter = this_cpu_ptr(fbc->counters);
-	*pcounter += amount;
-	if (unlikely(abs(*pcounter) >= batch))
-		percpu_counter_handle_overflow(fbc);
+	if (unlikely(abs(amount + *pcounter) >= batch))
+		percpu_counter_handle_overflow(fbc, amount);
+	else
+		*pcounter += amount;
 	preempt_enable();
 }
 
diff -puN lib/percpu_counter.c~percpu_counters-inline-the-percpu_counter_add_batch-fastpath-fix lib/percpu_counter.c
--- a/lib/percpu_counter.c~percpu_counters-inline-the-percpu_counter_add_batch-fastpath-fix
+++ a/lib/percpu_counter.c
@@ -72,11 +72,13 @@ EXPORT_SYMBOL(percpu_counter_set);
 /*
  * Handle overflow of the current cpu's ->count.  Premption is disabled.
  */
-void percpu_counter_handle_overflow(struct percpu_counter *fbc)
+void percpu_counter_handle_overflow(struct percpu_counter *fbc, s64 amount)
 {
+	long *pcounter = this_cpu_ptr(fbc->counters);
+
 	spin_lock(&fbc->lock);
-	fbc->count += this_cpu_read(*fbc->counters);
-	this_cpu_write(*fbc->counters, 0);
+	fbc->count += *pcounter + amount;
+	*pcounter = 0;
 	spin_unlock(&fbc->lock);
 }
 EXPORT_SYMBOL(percpu_counter_handle_overflow);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

typesh-move-misplaced-comment.patch
kfifo-disable-__kfifo_must_check_helper.patch
linux-next.patch
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
serial8250-ratelimit-too-much-work-error.patch
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

