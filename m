From: akpm@osdl.org
Subject: + updated-add-a-framework-to-manage-clock-event-devices-pit-broadcasting-fix.patch added to -mm tree
Date: Sat, 09 Dec 2006 14:38:38 -0800
Message-ID: <200612092238.kB9MccJ2006243@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:55874 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758892AbWLIWi7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 9 Dec 2006 17:38:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, ak@suse.de, johnstul@us.ibm.com, tglx@linutronix.de, zippel@linux-m68k.org


The patch titled
     high-res timers: PIT broadcasting fix
has been added to the -mm tree.  Its filename is
     updated-add-a-framework-to-manage-clock-event-devices-pit-broadcasting-fix.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: high-res timers: PIT broadcasting fix
From: Ingo Molnar <mingo@elte.hu>

Systems that enter C3 and have to turn off the APIC we fall back to the PIT
as the clock events source which emulates a local events source.  Dynticks
exposed a bug in the broadcast/local-events emulation code: if the PIT IRQ
came earlier than the next high-res timer on an idle CPU would have needed,
then the PIT was not reprogrammed for followup irqs.

(also, clean things up a bit by splitting out the broadcast
 reprogramming logic into clockevents_reprogram_broadcast())

This bug can explain certain rare boot-time hangs on C3-capable laptops
that run with HIGH_RES_TIMERS and NO_HZ enabled.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/time/clockevents.c |   60 +++++++++++++++++++++++++-----------
 1 file changed, 42 insertions(+), 18 deletions(-)

diff -puN kernel/time/clockevents.c~updated-add-a-framework-to-manage-clock-event-devices-pit-broadcasting-fix kernel/time/clockevents.c
--- a/kernel/time/clockevents.c~updated-add-a-framework-to-manage-clock-event-devices-pit-broadcasting-fix
+++ a/kernel/time/clockevents.c
@@ -527,6 +527,32 @@ static cpumask_t local_event_broadcast;
 static void (*broadcast_function)(cpumask_t *mask);
 static void (*global_event_handler)(struct pt_regs *regs);
 
+/*
+ * Reprogram the broadcast device:
+ *
+ * Called with events_lock held and interrupts disabled.
+ */
+static void clockevents_reprogram_broadcast(void)
+{
+	struct clock_event_device *glblevt = global_eventdevice.event;
+	struct local_events *dev;
+	ktime_t expires = { .tv64 = KTIME_MAX };
+	int64_t delta;
+	int cpu;
+
+	for (cpu = first_cpu(local_event_broadcast); cpu != NR_CPUS;
+	     cpu = next_cpu(cpu, local_event_broadcast)) {
+		dev = &per_cpu(local_eventdevices, cpu);
+		if (dev->expires_next.tv64 < expires.tv64)
+			expires = dev->expires_next;
+	}
+
+	if (expires.tv64 != KTIME_MAX) {
+		delta = ktime_to_ns(ktime_sub(expires, ktime_get()));
+		do_clockevents_set_next_event(glblevt, delta);
+	}
+}
+
 /**
  * clockevents_set_broadcast - switch next event device from/to broadcast mode
  *
@@ -536,10 +562,7 @@ static void (*global_event_handler)(stru
 void clockevents_set_broadcast(struct clock_event_device *evt, int broadcast)
 {
 	struct local_events *devices = &__get_cpu_var(local_eventdevices);
-	struct clock_event_device *glblevt = global_eventdevice.event;
 	int cpu = smp_processor_id();
-	ktime_t expires = { .tv64 = KTIME_MAX };
-	int64_t delta;
 	unsigned long flags;
 
 	if (devices->nextevt != evt)
@@ -556,19 +579,7 @@ void clockevents_set_broadcast(struct cl
 		if (devices->expires_next.tv64 != KTIME_MAX)
 			clockevents_set_next_event(devices->expires_next, 1);
 	}
-
-	/* Reprogram the broadcast device */
-	for (cpu = first_cpu(local_event_broadcast); cpu != NR_CPUS;
-	     cpu = next_cpu(cpu, local_event_broadcast)) {
-		devices = &per_cpu(local_eventdevices, cpu);
-		if (devices->expires_next.tv64 < expires.tv64)
-			expires = devices->expires_next;
-	}
-
-	if (expires.tv64 != KTIME_MAX) {
-		delta = ktime_to_ns(ktime_sub(expires, ktime_get()));
-		do_clockevents_set_next_event(glblevt, delta);
-	}
+	clockevents_reprogram_broadcast();
 
 	spin_unlock_irqrestore(&events_lock, flags);
 }
@@ -635,9 +646,22 @@ static void handle_nextevt_broadcast(str
 			cpu_set(cpu, mask);
 		}
 	}
+	if (!cpus_empty(mask)) {
+		/*
+		 * Wakeup the cpus which have an expired event. The
+		 * global event is reprogrammed in the return from
+		 * idle code.
+		 */
+		broadcast_function(&mask);
+	} else {
+		/*
+		 * The global event did not expire any CPU local
+		 * events. This happens in dyntick mode, as the
+		 * maximum PIT delta is quite small.
+		 */
+		clockevents_reprogram_broadcast();
+	}
 	spin_unlock(&events_lock);
-	/* Wakeup the cpus which have an expired event */
-	broadcast_function(&mask);
 }
 
 /*
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
i386-fix-the-verify_quirk_intel_irqbalance.patch
acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi.patch
netpoll-locking-fix.patch
revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
convert-i386-pda-code-to-use-%fs.patch
convert-i386-pda-code-to-use-%fs-fixes.patch
genapic-optimize-fix-apic-mode-setup-2.patch
genapic-always-use-physical-delivery-mode-on-8-cpus.patch
genapic-remove-es7000-workaround.patch
genapic-remove-clustered-apic-mode.patch
genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
debug-add-sysrq_always_enabled-boot-option.patch
lockdep-filter-off-by-default.patch
lockdep-improve-verbose-messages.patch
lockdep-improve-lockdep_reset.patch
lockdep-clean-up-very_verbose-define.patch
lockdep-use-chain-hash-on-config_debug_lockdep-too.patch
lockdep-print-irq-trace-info-on-asserts.patch
lockdep-fix-possible-races-while-disabling-lock-debugging.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
schedc-correct-comment-for-this_rq_lock-routine.patch
sched-fix-migration-cost-estimator.patch
sched-domain-move-sched-group-allocations-to-percpu-area.patch
move_task_off_dead_cpu-should-be-called-with-disabled-ints.patch
sched-domain-increase-the-smt-busy-rebalance-interval.patch
sched-avoid-taking-rq-lock-in-wake_priority_sleeper.patch
sched-remove-staggering-of-load-balancing.patch
sched-disable-interrupts-for-locking-in-load_balance.patch
sched-extract-load-calculation-from-rebalance_tick.patch
sched-move-idle-status-calculation-into-rebalance_tick.patch
sched-use-softirq-for-load-balancing.patch
sched-call-tasklet-less-frequently.patch
sched-add-option-to-serialize-load-balancing.patch
sched-add-option-to-serialize-load-balancing-fix.patch
sched-improve-migration-accuracy.patch
sched-improve-migration-accuracy-tidy.patch
sched-decrease-number-of-load-balances.patch
sched-remove-lb_stopbalance-counter.patch
sched-optimize-activate_task-for-rt-task.patch
kernel-schedc-whitespace-cleanups.patch
kernel-schedc-whitespace-cleanups-more.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
sched-cleanup-remove-task_t-convert-to-struct-task_struct-prefetch.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
time-uninline-jiffiesh.patch
time-uninline-jiffiesh-fix.patch
time-fix-msecs_to_jiffies-bug.patch
time-fix-timeout-overflow.patch
cleanup-uninline-irq_enter-and-move-it-into-a-function.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie-remove-incorrect-warning-in-kernel-timerc.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-clean-up-locking.patch
hrtimers-clean-up-locking-fix.patch
updated-hrtimers-state-tracking.patch
updated-hrtimers-clean-up-callback-tracking.patch
updated-hrtimers-move-and-add-documentation.patch
updated-add-a-framework-to-manage-clock-event-devices.patch
updated-add-a-framework-to-manage-clock-event-devices-next_event-calculation-fix.patch
updated-add-a-framework-to-manage-clock-event-devices-pit-broadcasting-fix.patch
updated-acpi-include-apich.patch
updated-acpi-keep-track-of-timer-broadcast.patch
updated-acpi-add-state-propagation-for-dynamic-broadcasting.patch
updated-i386-cleanup-apic-code.patch
updated-i386-convert-to-clock-event-devices.patch
updated-pm_timer-allow-early-access-and-move-externs-to-a-header-file.patch
updated-i386-rework-local-apic-calibration.patch
updated-high-res-timers-core.patch
updated-high-res-timers-core-high-res-timers-do-itimer-rearming-in-process-context.patch
updated-gtod-mark-tsc-unusable-for-highres-timers.patch
high-res-timers-utilize-tsc-clocksource-again.patch
high-res-timers-utilize-tsc-clocksource-again-fix.patch
updated-dynticks-core-code.patch
updated-dynticks-core-code-fix-resume-bug.patch
updated-dyntick-add-nohz-stats-to-proc-stat.patch
updated-dynticks-i386-arch-code.patch
updated-dynticks-fix-nmi-watchdog.patch
updated-high-res-timers-dynticks-enable-i386-support.patch
updated-debugging-feature-timer-stats.patch
clockevents-core-check-for-clock-event-device-handler-being-non-null-before-calling-it.patch
round_jiffies-infrastructure.patch
round_jiffies-infrastructure-fix.patch
clocksource-add-usage-of-config_sysfs.patch
clocksource-small-cleanup-2.patch
clocksource-small-cleanup-2-fix.patch
clocksource-small-acpi_pm-cleanup.patch
kvm-amd-svm-implementation-more-i386-fixes.patch
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

