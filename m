From: akpm@osdl.org
Subject: + high-res-timers-core-hrtimers-add-state-tracking-fix-fix.patch added to -mm tree
Date: Tue, 19 Dec 2006 13:31:25 -0800
Message-ID: <200612192131.kBJLVPxM011435@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37433 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933013AbWLSVbg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Dec 2006 16:31:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de


The patch titled
     high-res timers: core, do itimer rearming in process context, fix
has been added to the -mm tree.  Its filename is
     high-res-timers-core-hrtimers-add-state-tracking-fix-fix.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: high-res timers: core, do itimer rearming in process context, fix
From: Ingo Molnar <mingo@elte.hu>

Restart itimers when they are not queued.  (a non-queued hrtimer might be
callback-pending - but in that case we already missed the rearming so the
SIGALRM branch has to rearm.)

This fixes a threaded itimers stress-test hang.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/hrtimer.h |    9 +++++++++
 kernel/hrtimer.c        |    9 ---------
 kernel/signal.c         |    2 +-
 3 files changed, 10 insertions(+), 10 deletions(-)

diff -puN include/linux/hrtimer.h~high-res-timers-core-hrtimers-add-state-tracking-fix-fix include/linux/hrtimer.h
--- a/include/linux/hrtimer.h~high-res-timers-core-hrtimers-add-state-tracking-fix-fix
+++ a/include/linux/hrtimer.h
@@ -276,6 +276,15 @@ static inline int hrtimer_active(const s
 	return timer->state != HRTIMER_STATE_INACTIVE;
 }
 
+/*
+ * Helper function to check, whether the timer is on one of the queues
+ */
+static inline int hrtimer_is_queued(struct hrtimer *timer)
+{
+	return timer->state &
+		(HRTIMER_STATE_ENQUEUED | HRTIMER_STATE_PENDING);
+}
+
 /* Forward a hrtimer so it expires after now: */
 extern unsigned long
 hrtimer_forward(struct hrtimer *timer, ktime_t now, ktime_t interval);
diff -puN kernel/hrtimer.c~high-res-timers-core-hrtimers-add-state-tracking-fix-fix kernel/hrtimer.c
--- a/kernel/hrtimer.c~high-res-timers-core-hrtimers-add-state-tracking-fix-fix
+++ a/kernel/hrtimer.c
@@ -151,15 +151,6 @@ static void hrtimer_get_softirq_time(str
 }
 
 /*
- * Helper function to check, whether the timer is on one of the queues
- */
-static inline int hrtimer_is_queued(struct hrtimer *timer)
-{
-	return timer->state &
-		(HRTIMER_STATE_ENQUEUED | HRTIMER_STATE_PENDING);
-}
-
-/*
  * Helper function to check, whether the timer is running the callback
  * function
  */
diff -puN kernel/signal.c~high-res-timers-core-hrtimers-add-state-tracking-fix-fix kernel/signal.c
--- a/kernel/signal.c~high-res-timers-core-hrtimers-add-state-tracking-fix-fix
+++ a/kernel/signal.c
@@ -475,7 +475,7 @@ int dequeue_signal(struct task_struct *t
 		if (unlikely(signr == SIGALRM)) {
 			struct hrtimer *tmr = &tsk->signal->real_timer;
 
-			if (!hrtimer_active(tmr) &&
+			if (!hrtimer_is_queued(tmr) &&
 			    tsk->signal->it_real_incr.tv64 != 0) {
 				hrtimer_forward(tmr, hrtimer_cb_get_time(tmr),
 						tsk->signal->it_real_incr);
_

Patches currently in -mm which might be from mingo@elte.hu are

conditionally-check-expected_preempt_count-in-__resched_legal.patch
sched-remove-__cpuinitdata-anotation-to-cpu_isolated_map.patch
genirq-fix-irq-flow-handler-uninstall.patch
lock-debugging-fix-debug_locks_warn_on-debug_locks_silent.patch
acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi.patch
revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
convert-i386-pda-code-to-use-%fs.patch
genapic-optimize-fix-apic-mode-setup-2.patch
genapic-always-use-physical-delivery-mode-on-8-cpus.patch
genapic-remove-es7000-workaround.patch
genapic-remove-clustered-apic-mode.patch
genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
schedule_on_each_cpu-use-preempt_disable.patch
lockdep-also-check-for-freed-locks-in-kmem_cache_free.patch
lockdep-more-unlock-on-error-fixes.patch
lockdep-more-unlock-on-error-fixes-fix.patch
lockdep-add-graph-depth-information-to-proc-lockdep.patch
gtod-uninline-jiffiesh.patch
gtod-fix-multiple-conversion-bugs-in-msecs_to_jiffies.patch
gtod-fix-timeout-overflow.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
dynticks-uninline-irq_enter.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-clean-up-locking.patch
hrtimers-add-state-tracking.patch
hrtimers-clean-up-callback-tracking.patch
hrtimers-move-and-add-documentation.patch
acpi-include-fix.patch
acpi-keep-track-of-timer-broadcast.patch
acpi-add-state-propagation-for-dynamic-broadcasting.patch
acpi-cleanups-allow-early-access-to-pmtimer.patch
i386-apic-clean-up-the-apic-code.patch
clockevents-core.patch
clockevents-i386-drivers.patch
clockevents-i386-hpet-driver.patch
i386-apic-rework-and-fix-local-apic-calibration.patch
high-res-timers-core.patch
high-res-timers-core-do-itimer-rearming-in-process-context.patch
high-res-timers-core-hrtimers-add-state-tracking-fix.patch
high-res-timers-core-hrtimers-add-state-tracking-fix-fix.patch
high-res-timers-allow-tsc-clocksource-if-pmtimer-present.patch
dynticks-core.patch
dynticks-add-nohz-stats-to-proc-stat.patch
dynticks-i386-support-idle-handler-callbacks.patch
dynticks-i386-prepare-nmi-watchdog.patch
high-res-timers-dynticks-i386-support-enable-in-kconfig.patch
debugging-feature-add-proc-timer_stat.patch
debugging-feature-proc-timer_list.patch
debugging-feature-sysrq-q-to-print-timers.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
sched-improve-efficiency-of-sched_fork.patch
sched-improve-efficiency-of-sched_fork-tidy.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
sched-cleanup-remove-task_t-convert-to-struct-task_struct-prefetch.patch
detect-atomic-counter-underflows.patch
debug-shared-irqs.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
vdso-print-fatal-signals.patch
vdso-improve-print_fatal_signals-support-by-adding-memory-maps.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
lockdep-show-held-locks-when-showing-a-stackdump-fix.patch
lockdep-show-held-locks-when-showing-a-stackdump-fix-2.patch
kmap_atomic-debugging.patch

