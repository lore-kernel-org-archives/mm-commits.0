From: akpm@linux-foundation.org
Subject: + make-sysrq-t-show-all-tasks-again.patch added to -mm tree
Date: Wed, 25 Apr 2007 16:59:39 -0700
Message-ID: <200704252359.l3PNxdxW016312@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41163 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751934AbXDYX7v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 19:59:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu


The patch titled
     make SysRq-T show all tasks again
has been added to the -mm tree.  Its filename is
     make-sysrq-t-show-all-tasks-again.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: make SysRq-T show all tasks again
From: Ingo Molnar <mingo@elte.hu>

show_state() (SysRq-T) developed the buggy habbit of not showing
TASK_RUNNING tasks.  This was due to the mistaken belief that state_filter
== -1 would be a pass-through filter - while in reality it did not let
TASK_RUNNING == 0 p->state values through.

Fix this by restoring the original '!state_filter means all tasks'
special-case i had in the original version.  Test-built and test-booted on
i686, SysRq-T now works as intended.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    4 ++--
 kernel/sched.c        |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/sched.h~make-sysrq-t-show-all-tasks-again include/linux/sched.h
--- a/include/linux/sched.h~make-sysrq-t-show-all-tasks-again
+++ a/include/linux/sched.h
@@ -196,13 +196,13 @@ extern void init_idle(struct task_struct
 extern cpumask_t nohz_cpu_mask;
 
 /*
- * Only dump TASK_* tasks. (-1 for all tasks)
+ * Only dump TASK_* tasks. (0 for all tasks)
  */
 extern void show_state_filter(unsigned long state_filter);
 
 static inline void show_state(void)
 {
-	show_state_filter(-1);
+	show_state_filter(0);
 }
 
 extern void show_regs(struct pt_regs *);
diff -puN kernel/sched.c~make-sysrq-t-show-all-tasks-again kernel/sched.c
--- a/kernel/sched.c~make-sysrq-t-show-all-tasks-again
+++ a/kernel/sched.c
@@ -4746,7 +4746,7 @@ void show_state_filter(unsigned long sta
 		 * console might take alot of time:
 		 */
 		touch_nmi_watchdog();
-		if (p->state & state_filter)
+		if (!state_filter || (p->state & state_filter))
 			show_task(p);
 	} while_each_thread(g, p);
 
_

Patches currently in -mm which might be from mingo@elte.hu are

make-sysrq-t-show-all-tasks-again.patch
git-ieee1394.patch
git-kvm.patch
forcedeth-improve-napi-logic.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch.patch
spin_lock_irq-enable-interrupts-while-spinning-x86_64-implementation.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation.patch
i386-tsc-remove-xtime_locking-around-cpufreq-notifier.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
simplify-the-stacktrace-code.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
softlockup-trivial-s-99-max_rt_prio.patch
optimize-timespec_trunc.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
kernel-irq-procc-unprotected-iteration-over-the-irq-action-list-in-name_unique.patch
add-support-for-deferrable-timers-respun.patch
add-support-for-deferrable-timers-respun-tidy.patch
add-support-for-deferrable-timers-respun-fix.patch
irq-check-for-percpu-flag-only-when-adding-first-irqaction.patch
move-timekeeping-code-to-timekeepingc.patch
move-timekeeping-code-to-timekeepingc-fix.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
ignore-stolen-time-in-the-softlockup-watchdog-fix.patch
add-touch_all_softlockup_watchdogs.patch
enhance-initcall_debug-measure-latency.patch
enhance-initcall_debug-measure-latency-fix.patch
simplify-kallsyms_lookup.patch
deprecate-sa_xxx-interrupt-flags-v2.patch
lockdep-treats-down_write_trylock-like-regular-down_write.patch
pad-irq_desc-to-internode-cacheline-size.patch
pad-irq_desc-to-internode-cacheline-size-fix.patch
highres-dyntick-prevent-xtime-lock-contention.patch
lockdep-lookup_chain_cache-comment-errata.patch
introduce-a-handy-list_first_entry-macro-v2.patch
document-spin_lock_unlocked-rw_lock_unlocked-deprecation.patch
document-spin_lock_unlocked-rw_lock_unlocked-deprecation-fix.patch
clean-up-mutex_trylock-noise.patch
the-scheduled-einval-for-invalid-timevals-in-setitimer.patch
lockdep-removed-unused-ip-argument-in-mark_lock-mark_held_locks.patch
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
sched-optimize-siblings-status-check-logic-in-wake_idle.patch
sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array-update.patch
sched-align-rq-to-cacheline-boundary.patch
sched-dont-renice-kernel-threads.patch
sched-remove-sleepavg-from-proc.patch
revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
sched-implement-staircase-deadline-cpu-scheduler.patch
sched-implement-staircase-deadline-cpu-scheduler-misc-fixes.patch
sched-implement-staircase-deadline-cpu-scheduler-avoid-redundant-reschedule-in-set_user_nice.patch
sched-implement-staircase-deadline-cpu-scheduler-tweak.patch
sched-remove-noninteractive-flag.patch
sched-document-sd-cpu-scheduler.patch
sched-consolidate-sched_clock-drift-adjustments.patch
sched-consolidate-sched_clock-drift-adjustments-fix.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
declare-struct-ktime.patch
futex-priority-based-wakeup.patch
make-futex_wait-use-an-hrtimer-for-timeout.patch
make-futex_wait-use-an-hrtimer-for-timeout-fix.patch
make-futex_wait-use-an-hrtimer-for-timeout-fix-2.patch
futex_requeue_pi-optimization.patch
add-irqf_irqpoll-flag-common-code.patch
add-irqf_irqpoll-flag-on-x86_64.patch
add-irqf_irqpoll-flag-on-i386.patch
add-irqf_irqpoll-flag-on-ia64.patch
add-irqf_irqpoll-flag-on-sh.patch
add-irqf_irqpoll-flag-on-arm.patch
timer_stats-slimmed-down-using-statistics-infrastucture.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-convert-to-the-kthread-api.patch
vdso-print-fatal-signals.patch
vdso-improve-print_fatal_signals-support-by-adding-memory-maps.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
kmap_atomic-debugging.patch
random-warning-squishes.patch
