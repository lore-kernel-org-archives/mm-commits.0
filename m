From: akpm@linux-foundation.org
Subject: + workqueues-s-on_stack-onstack.patch added to -mm tree
Date: Mon, 25 Oct 2010 12:57:27 -0700
Message-ID: <201010251957.o9PJvRJf013235@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33074 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757688Ab0JYT5i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Oct 2010 15:57:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, tj@kernel.org


The patch titled
     workqueues: s/ON_STACK/ONSTACK/
has been added to the -mm tree.  Its filename is
     workqueues-s-on_stack-onstack.patch

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
Subject: workqueues: s/ON_STACK/ONSTACK/
From: Andrew Morton <akpm@linux-foundation.org>

Silly though it is, completions and wait_queue_heads use foo_ONSTACK
(COMPLETION_INITIALIZER_ONSTACK, DECLARE_COMPLETION_ONSTACK,
__WAIT_QUEUE_HEAD_INIT_ONSTACK and DECLARE_WAIT_QUEUE_HEAD_ONSTACK) so I
guess workqueues should do the same thing.

s/INIT_WORK_ON_STACK/INIT_WORK_ONSTACK/
s/INIT_DELAYED_WORK_ON_STACK/INIT_DELAYED_WORK_ONSTACK/

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ./arch/x86/kernel/hpet.c          |    2 +-
 ./arch/x86/kernel/smpboot.c       |    2 +-
 ./drivers/md/dm-snap-persistent.c |    2 +-
 ./include/linux/workqueue.h       |    6 +++---
 ./kernel/workqueue.c              |    2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff -puN ./arch/x86/kernel/hpet.c~workqueues-s-on_stack-onstack ./arch/x86/kernel/hpet.c
--- a/./arch/x86/kernel/hpet.c~workqueues-s-on_stack-onstack
+++ a/./arch/x86/kernel/hpet.c
@@ -713,7 +713,7 @@ static int hpet_cpuhp_notify(struct noti
 
 	switch (action & 0xf) {
 	case CPU_ONLINE:
-		INIT_DELAYED_WORK_ON_STACK(&work.work, hpet_work);
+		INIT_DELAYED_WORK_ONSTACK(&work.work, hpet_work);
 		init_completion(&work.complete);
 		/* FIXME: add schedule_work_on() */
 		schedule_delayed_work_on(cpu, &work.work, 0);
diff -puN ./arch/x86/kernel/smpboot.c~workqueues-s-on_stack-onstack ./arch/x86/kernel/smpboot.c
--- a/./arch/x86/kernel/smpboot.c~workqueues-s-on_stack-onstack
+++ a/./arch/x86/kernel/smpboot.c
@@ -747,7 +747,7 @@ static int __cpuinit do_boot_cpu(int api
 		.done	= COMPLETION_INITIALIZER_ONSTACK(c_idle.done),
 	};
 
-	INIT_WORK_ON_STACK(&c_idle.work, do_fork_idle);
+	INIT_WORK_ONSTACK(&c_idle.work, do_fork_idle);
 
 	alternatives_smp_switch(1);
 
diff -puN ./kernel/workqueue.c~workqueues-s-on_stack-onstack ./kernel/workqueue.c
--- a/./kernel/workqueue.c~workqueues-s-on_stack-onstack
+++ a/./kernel/workqueue.c
@@ -2064,7 +2064,7 @@ static void insert_wq_barrier(struct cpu
 	 * checks and call back into the fixup functions where we
 	 * might deadlock.
 	 */
-	INIT_WORK_ON_STACK(&barr->work, wq_barrier_func);
+	INIT_WORK_ONSTACK(&barr->work, wq_barrier_func);
 	__set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(&barr->work));
 	init_completion(&barr->done);
 
diff -puN ./drivers/md/dm-snap-persistent.c~workqueues-s-on_stack-onstack ./drivers/md/dm-snap-persistent.c
--- a/./drivers/md/dm-snap-persistent.c~workqueues-s-on_stack-onstack
+++ a/./drivers/md/dm-snap-persistent.c
@@ -254,7 +254,7 @@ static int chunk_io(struct pstore *ps, v
 	 * Issue the synchronous I/O from a different thread
 	 * to avoid generic_make_request recursion.
 	 */
-	INIT_WORK_ON_STACK(&req.work, do_metadata);
+	INIT_WORK_ONSTACK(&req.work, do_metadata);
 	queue_work(ps->metadata_wq, &req.work);
 	flush_workqueue(ps->metadata_wq);
 
diff -puN ./include/linux/workqueue.h~workqueues-s-on_stack-onstack ./include/linux/workqueue.h
--- a/./include/linux/workqueue.h~workqueues-s-on_stack-onstack
+++ a/./include/linux/workqueue.h
@@ -198,7 +198,7 @@ static inline unsigned int work_static(s
 		__INIT_WORK((_work), (_func), 0);		\
 	} while (0)
 
-#define INIT_WORK_ON_STACK(_work, _func)			\
+#define INIT_WORK_ONSTACK(_work, _func)				\
 	do {							\
 		__INIT_WORK((_work), (_func), 1);		\
 	} while (0)
@@ -209,9 +209,9 @@ static inline unsigned int work_static(s
 		init_timer(&(_work)->timer);			\
 	} while (0)
 
-#define INIT_DELAYED_WORK_ON_STACK(_work, _func)		\
+#define INIT_DELAYED_WORK_ONSTACK(_work, _func)			\
 	do {							\
-		INIT_WORK_ON_STACK(&(_work)->work, (_func));	\
+		INIT_WORK_ONSTACK(&(_work)->work, (_func));	\
 		init_timer_on_stack(&(_work)->timer);		\
 	} while (0)
 
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
workqueues-s-on_stack-onstack.patch
isl29020-ambient-light-sensor-fix.patch
drivers-misc-apds9802alsc-add-runtime-pm-support-fix.patch
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

