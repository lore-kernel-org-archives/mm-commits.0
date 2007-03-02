From: akpm@linux-foundation.org
Subject: - sched-fix-smt-scheduler-bug.patch removed from -mm tree
Date: Thu, 01 Mar 2007 21:07:14 -0800
Message-ID: <200703020507.l2257EXS000862@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42389 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422760AbXCBFH3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 00:07:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, michal.k.k.piotrowski@gmail.com, nickpiggin@yahoo.com.au, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     sched: fix SMT scheduler bug
has been removed from the -mm tree.  Its filename was
     sched-fix-smt-scheduler-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sched: fix SMT scheduler bug
From: Ingo Molnar <mingo@elte.hu>

The SMT scheduler incorrectly skips kernel threads even if they are
runnable (but they are preempted by a higher-prio user-space task which got
SMT-delayed by an even higher-priority task running on a sibling CPU).

Fix this for now by only doing the SMT-nice optimization if the
to-be-delayed task is the only runnable task.  (This should cover most of
the real-life cases anyway.)

This bug has been in the SMT scheduler since 2.6.17 or so, but has only
been noticed now by the active check in the dynticks code.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sched.c~sched-fix-smt-scheduler-bug kernel/sched.c
--- a/kernel/sched.c~sched-fix-smt-scheduler-bug
+++ a/kernel/sched.c
@@ -3547,7 +3547,7 @@ need_resched_nonpreemptible:
 		}
 	}
 	next->sleep_type = SLEEP_NORMAL;
-	if (dependent_sleeper(cpu, rq, next))
+	if (rq->nr_running == 1 && dependent_sleeper(cpu, rq, next))
 		next = rq->idle;
 switch_tasks:
 	if (next == rq->idle)
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
sched-remove-smt-nice.patch
git-kvm.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch.patch
spin_lock_irq-enable-interrupts-while-spinning-x86_64-implementation.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation.patch
log-reason-why-tsc-was-marked-unstable.patch
clocksource-init-adjustments-fix-bug-7426.patch
fully-honor-vdso_enabled.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
simplify-the-stacktrace-code.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
softlockup-trivial-s-99-max_rt_prio.patch
timer-run-calc_load-halfway-through-each-round_jiffies.patch
schedule_on_each_cpu-use-preempt_disable.patch
workqueue-kill-run_scheduled_work.patch
workqueue-dont-save-interrupts-in-run_workqueue.patch
workqueue-make-cancel_rearming_delayed_workqueue-work-on-idle-dwork.patch
workqueue-introduce-cpu_singlethread_map.patch
workqueue-introduce-workqueue_struct-singlethread.patch
workqueue-make-init_workqueues-__init.patch
fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine.patch
fsaio-rename-__lock_page-to-lock_page_blocking.patch
fsaio-interfaces-to-initialize-and-to-test-a-wait-bit-key.patch
fsaio-add-a-default-io-wait-bit-field-in-task-struct.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio.patch
fsaio-enable-asynchronous-wait-page-and-lock-page.patch
fsaio-filesystem-aio-read.patch
fsaio-aio-o_sync-filesystem-write.patch
aio-is-unlikely.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
speedup-divides-by-cpu_power-in-scheduler.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
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
