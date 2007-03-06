From: akpm@linux-foundation.org
Subject: - sched-cleanup-remove-task_t-convert-to-struct-task_struct-prefetch.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:22:02 -0800
Message-ID: <200703060122.l261MCR2007551@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45042 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933777AbXCFBW0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:22:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     sched: cleanup, remove task_t, convert to struct task_struct (swap_prefetch)
has been removed from the -mm tree.  Its filename was
     sched-cleanup-remove-task_t-convert-to-struct-task_struct-prefetch.patch

This patch was dropped because it was folded into mm-implement-swap-prefetching.patch

------------------------------------------------------
Subject: sched: cleanup, remove task_t, convert to struct task_struct (swap_prefetch)
From: Ingo Molnar <mingo@elte.hu>

cleanup: remove task_t and convert all the uses to struct task_struct. I
introduced it for the scheduler anno and it was a mistake.

Conversion was mostly scripted, the result was reviewed and all
secondary whitespace and style impact (if any) was fixed up by hand.

Depends on the "sched: clean up fallout of recent changes" patch. Goes
to the tail of the scheduler queue.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/swap_prefetch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/swap_prefetch.c~sched-cleanup-remove-task_t-convert-to-struct-task_struct-prefetch mm/swap_prefetch.c
--- a/mm/swap_prefetch.c~sched-cleanup-remove-task_t-convert-to-struct-task_struct-prefetch
+++ a/mm/swap_prefetch.c
@@ -48,7 +48,7 @@ static struct swapped_root swapped = {
 	.swap_tree	= RADIX_TREE_INIT(GFP_ATOMIC),
 };
 
-static task_t *kprefetchd_task;
+static struct task_struct *kprefetchd_task;
 
 /*
  * We check to see no part of the vm is busy. If it is this will interrupt
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
bugfix-dont-use-the-tsc-in-sched_clock-if-unstable.patch
cleanup-unify-tsc_unstable-and-tsc_disable.patch
possible-bugfix-make-dmi_mark_tsc_unstable-call-mark_tsc_unstable.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch.patch
spin_lock_irq-enable-interrupts-while-spinning-x86_64-implementation.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation.patch
log-reason-why-tsc-was-marked-unstable.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
simplify-the-stacktrace-code.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
softlockup-trivial-s-99-max_rt_prio.patch
optimize-timespec_trunc.patch
schedule_on_each_cpu-use-preempt_disable.patch
workqueue-kill-run_scheduled_work.patch
workqueue-dont-save-interrupts-in-run_workqueue.patch
workqueue-make-cancel_rearming_delayed_workqueue-work-on-idle-dwork.patch
workqueue-introduce-cpu_singlethread_map.patch
workqueue-introduce-workqueue_struct-singlethread.patch
workqueue-make-init_workqueues-__init.patch
aio-is-unlikely.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
speedup-divides-by-cpu_power-in-scheduler.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
sched-cleanup-remove-task_t-convert-to-struct-task_struct-prefetch.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-3.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
vdso-print-fatal-signals.patch
vdso-improve-print_fatal_signals-support-by-adding-memory-maps.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
lockdep-show-held-locks-when-showing-a-stackdump-fix.patch
lockdep-show-held-locks-when-showing-a-stackdump-fix-2.patch
kmap_atomic-debugging.patch
