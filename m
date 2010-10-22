From: akpm@linux-foundation.org
Subject: + percpu_counters-inline-the-percpu_counter_add_batch-fastpath.patch added to -mm tree
Date: Thu, 21 Oct 2010 18:56:21 -0700
Message-ID: <201010220156.o9M1u24E017211@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44989 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751513Ab0JVB4E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Oct 2010 21:56:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, cl@linux-foundation.org, eric.dumazet@gmail.com


The patch titled
     percpu_counters: inline the percpu_counter_add_batch() fastpath
has been added to the -mm tree.  Its filename is
     percpu_counters-inline-the-percpu_counter_add_batch-fastpath.patch

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
Subject: percpu_counters: inline the percpu_counter_add_batch() fastpath
From: Andrew Morton <akpm@linux-foundation.org>

Inline the fastpath code and uninline the uncommon path where the batching
value has overflowed.

Am not sure that I like this.

Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu_counter.h |   19 +++++++++++++++++--
 lib/percpu_counter.c           |   27 +++++++++------------------
 2 files changed, 26 insertions(+), 20 deletions(-)

diff -puN include/linux/percpu_counter.h~percpu_counters-inline-the-percpu_counter_add_batch-fastpath include/linux/percpu_counter.h
--- a/include/linux/percpu_counter.h~percpu_counters-inline-the-percpu_counter_add_batch-fastpath
+++ a/include/linux/percpu_counter.h
@@ -8,6 +8,7 @@
  *	64*8 (512) bytes + sizeof(struct percpu_counter)
  */
 
+#include <linux/kernel.h>
 #include <linux/spinlock.h>
 #include <linux/smp.h>
 #include <linux/list.h>
@@ -40,11 +41,25 @@ int __percpu_counter_init(struct percpu_
 
 void percpu_counter_destroy(struct percpu_counter *fbc);
 void percpu_counter_set(struct percpu_counter *fbc, s64 amount);
-void percpu_counter_add_batch(struct percpu_counter *fbc, s64 amount, long batch);
 s64 __percpu_counter_sum(struct percpu_counter *fbc);
 int percpu_counter_compare(struct percpu_counter *fbc, s64 rhs);
+void percpu_counter_handle_overflow(struct percpu_counter *fbc);
 
-static inline void percpu_counter_add(struct percpu_counter *fbc, s64 amount)
+static __always_inline void percpu_counter_add_batch(struct percpu_counter *fbc,
+						s64 amount, long batch)
+{
+	long *pcounter;
+
+	preempt_disable();
+	pcounter = this_cpu_ptr(fbc->counters);
+	*pcounter += amount;
+	if (unlikely(abs(*pcounter) >= batch))
+		percpu_counter_handle_overflow(fbc);
+	preempt_enable();
+}
+
+static __always_inline void percpu_counter_add(struct percpu_counter *fbc,
+						s64 amount)
 {
 	percpu_counter_add_batch(fbc, amount, percpu_counter_batch);
 }
diff -puN lib/percpu_counter.c~percpu_counters-inline-the-percpu_counter_add_batch-fastpath lib/percpu_counter.c
--- a/lib/percpu_counter.c~percpu_counters-inline-the-percpu_counter_add_batch-fastpath
+++ a/lib/percpu_counter.c
@@ -69,26 +69,17 @@ void percpu_counter_set(struct percpu_co
 }
 EXPORT_SYMBOL(percpu_counter_set);
 
-void
-percpu_counter_add_batch(struct percpu_counter *fbc, s64 amount, long batch)
+/*
+ * Handle overflow of the current cpu's ->count.  Premption is disabled.
+ */
+void percpu_counter_handle_overflow(struct percpu_counter *fbc)
 {
-	s64 count;
-	long *pcount;
-
-	preempt_disable();
-	pcount = this_cpu_ptr(fbc->counters);
-	count = *pcount + amount;
-	if (count >= batch || count <= -batch) {
-		spin_lock(&fbc->lock);
-		fbc->count += count;
-		*pcount = 0;
-		spin_unlock(&fbc->lock);
-	} else {
-		*pcount = count;
-	}
-	preempt_enable();
+	spin_lock(&fbc->lock);
+	fbc->count += this_cpu_read(*fbc->counters);
+	this_cpu_write(*fbc->counters, 0);
+	spin_unlock(&fbc->lock);
 }
-EXPORT_SYMBOL(percpu_counter_add_batch);
+EXPORT_SYMBOL(percpu_counter_handle_overflow);
 
 /*
  * Add up all the per-cpu counts, return the result.  This is a more accurate
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

