From: akpm@linux-foundation.org
Subject: - hrtimers-fix-reprogramming-smp-race.patch removed from -mm tree
Date: Thu, 29 Mar 2007 00:42:35 -0700
Message-ID: <200703290742.l2T7gZcX030312@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46149 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329AbXC2Hmp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 03:42:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, michal.k.k.piotrowski@gmail.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     hrtimers: fix reprogramming SMP race
has been removed from the -mm tree.  Its filename was
     hrtimers-fix-reprogramming-smp-race.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hrtimers: fix reprogramming SMP race
From: Ingo Molnar <mingo@elte.hu>

hrtimer_start() incorrectly set the 'reprogram' flag to enqueue_hrtimer(),
which should only be 1 if the hrtimer is queued to the current CPU.

Doing otherwise could result in a reprogramming of the current CPU's
clockevents device, with a timer that is not queued to it - resulting in a
bogus next expiry value.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hrtimer.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletion(-)

diff -puN kernel/hrtimer.c~hrtimers-fix-reprogramming-smp-race kernel/hrtimer.c
--- a/kernel/hrtimer.c~hrtimers-fix-reprogramming-smp-race
+++ a/kernel/hrtimer.c
@@ -814,7 +814,12 @@ hrtimer_start(struct hrtimer *timer, kti
 
 	timer_stats_hrtimer_set_start_info(timer);
 
-	enqueue_hrtimer(timer, new_base, base == new_base);
+	/*
+	 * Only allow reprogramming if the new base is on this CPU.
+	 * (it might still be on another CPU if the timer was pending)
+	 */
+	enqueue_hrtimer(timer, new_base,
+			new_base->cpu_base == &__get_cpu_var(hrtimer_bases));
 
 	unlock_hrtimer_base(timer, &flags);
 
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
git-ieee1394.patch
git-kvm.patch
forcedeth-work-around-null-skb-dereference-crash.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch.patch
spin_lock_irq-enable-interrupts-while-spinning-x86_64-implementation.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation.patch
log-reason-why-tsc-was-marked-unstable.patch
allow-per-cpu-variables-to-be-page-aligned.patch
i386-simplify-smp_call_function-by-using-common-implementation.patch
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
ignore-stolen-time-in-the-softlockup-watchdog.patch
add-touch_all_softlockup_watchdogs.patch
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
sched-dont-renice-kernel-threads.patch
sched-remove-sleepavg-from-proc.patch
sched-implement-staircase-deadline-cpu-scheduler.patch
sched-implement-staircase-deadline-cpu-scheduler-misc-fixes.patch
sched-remove-noninteractive-flag.patch
sched-document-sd-cpu-scheduler.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
declare-struct-ktime.patch
futex-priority-based-wakeup.patch
make-futex_wait-use-an-hrtimer-for-timeout.patch
make-futex_wait-use-an-hrtimer-for-timeout-fix.patch
make-futex_wait-use-an-hrtimer-for-timeout-fix-2.patch
futex_requeue_pi-optimization.patch
sys_futex64-allows-64bit-futexes.patch
sys_futex64-allows-64bit-futexes-fix.patch
sys_futex64-allows-64bit-futexes-workaround.patch
add-irqf_irqpoll-flag-common-code.patch
add-irqf_irqpoll-flag-on-x86_64.patch
add-irqf_irqpoll-flag-on-i386.patch
add-irqf_irqpoll-flag-on-ia64.patch
add-irqf_irqpoll-flag-on-sh.patch
add-irqf_irqpoll-flag-on-arm.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
vdso-print-fatal-signals.patch
vdso-improve-print_fatal_signals-support-by-adding-memory-maps.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
kmap_atomic-debugging.patch
mm-only-hrtimers-debug-patch.patch
mm-only-hrtimers-debug-patch-fix.patch
