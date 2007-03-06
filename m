From: akpm@linux-foundation.org
Subject: - lockdep-show-held-locks-when-showing-a-stackdump-fix-2.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:21:50 -0800
Message-ID: <200703060221.l262LoaB009317@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47434 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965763AbXCFCVx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:21:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     lockdep: show held locks when showing a stackdump, fix #2
has been removed from the -mm tree.  Its filename was
     lockdep-show-held-locks-when-showing-a-stackdump-fix-2.patch

This patch was dropped because it was folded into lockdep-show-held-locks-when-showing-a-stackdump.patch

------------------------------------------------------
Subject: lockdep: show held locks when showing a stackdump, fix #2
From: Ingo Molnar <mingo@elte.hu>

It's not safe to dump another task's held-locks array - restrict this to
the current task only.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/lockdep.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/lockdep.c~lockdep-show-held-locks-when-showing-a-stackdump-fix-2 kernel/lockdep.c
--- a/kernel/lockdep.c~lockdep-show-held-locks-when-showing-a-stackdump-fix-2
+++ a/kernel/lockdep.c
@@ -2788,7 +2788,8 @@ EXPORT_SYMBOL_GPL(debug_show_all_locks);
 
 void debug_show_held_locks(struct task_struct *task)
 {
-	lockdep_print_held_locks(task);
+	if (task == current)
+		lockdep_print_held_locks(task);
 }
 
 EXPORT_SYMBOL_GPL(debug_show_held_locks);
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-3.patch
bugfix-dont-use-the-tsc-in-sched_clock-if-unstable.patch
cleanup-unify-tsc_unstable-and-tsc_disable.patch
possible-bugfix-make-dmi_mark_tsc_unstable-call-mark_tsc_unstable.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-4.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-5.patch
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
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
vdso-print-fatal-signals.patch
vdso-improve-print_fatal_signals-support-by-adding-memory-maps.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
lockdep-show-held-locks-when-showing-a-stackdump-fix-2.patch
kmap_atomic-debugging.patch
