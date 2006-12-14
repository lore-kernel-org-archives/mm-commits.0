From: akpm@osdl.org
Subject: - lockdep-print-irq-trace-info-on-asserts.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:09:51 -0800
Message-ID: <200612140609.kBE69pcv001990@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52154 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915AbWLNGKK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:10:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     lockdep: print irq-trace info on asserts
has been removed from the -mm tree.  Its filename was
     lockdep-print-irq-trace-info-on-asserts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lockdep: print irq-trace info on asserts
From: Ingo Molnar <mingo@elte.hu>

When we print an assert due to scheduling-in-atomic bugs, and if lockdep
is enabled, then the IRQ tracing information of lockdep can be printed
to pinpoint the code location that disabled interrupts. This saved me
quite a bit of debugging time in cases where the backtrace did not
identify the irq-disabling site well enough.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/lockdep.h |   16 +++++++++++++---
 kernel/lockdep.c        |    6 +-----
 kernel/sched.c          |    4 ++++
 3 files changed, 18 insertions(+), 8 deletions(-)

diff -puN include/linux/lockdep.h~lockdep-print-irq-trace-info-on-asserts include/linux/lockdep.h
--- a/include/linux/lockdep.h~lockdep-print-irq-trace-info-on-asserts
+++ a/include/linux/lockdep.h
@@ -281,15 +281,25 @@ struct lock_class_key { };
 #if defined(CONFIG_TRACE_IRQFLAGS) && defined(CONFIG_GENERIC_HARDIRQS)
 extern void early_init_irq_lock_class(void);
 #else
-# define early_init_irq_lock_class()		do { } while (0)
+static inline void early_init_irq_lock_class(void)
+{
+}
 #endif
 
 #ifdef CONFIG_TRACE_IRQFLAGS
 extern void early_boot_irqs_off(void);
 extern void early_boot_irqs_on(void);
+extern void print_irqtrace_events(struct task_struct *curr);
 #else
-# define early_boot_irqs_off()			do { } while (0)
-# define early_boot_irqs_on()			do { } while (0)
+static inline void early_boot_irqs_off(void)
+{
+}
+static inline void early_boot_irqs_on(void)
+{
+}
+static inline void print_irqtrace_events(struct task_struct *curr)
+{
+}
 #endif
 
 /*
diff -puN kernel/lockdep.c~lockdep-print-irq-trace-info-on-asserts kernel/lockdep.c
--- a/kernel/lockdep.c~lockdep-print-irq-trace-info-on-asserts
+++ a/kernel/lockdep.c
@@ -1447,7 +1447,7 @@ check_usage_backwards(struct task_struct
 	return print_irq_inversion_bug(curr, backwards_match, this, 0, irqclass);
 }
 
-static inline void print_irqtrace_events(struct task_struct *curr)
+void print_irqtrace_events(struct task_struct *curr)
 {
 	printk("irq event stamp: %u\n", curr->irq_events);
 	printk("hardirqs last  enabled at (%u): ", curr->hardirq_enable_event);
@@ -1460,10 +1460,6 @@ static inline void print_irqtrace_events
 	print_ip_sym(curr->softirq_disable_ip);
 }
 
-#else
-static inline void print_irqtrace_events(struct task_struct *curr)
-{
-}
 #endif
 
 static int
diff -puN kernel/sched.c~lockdep-print-irq-trace-info-on-asserts kernel/sched.c
--- a/kernel/sched.c~lockdep-print-irq-trace-info-on-asserts
+++ a/kernel/sched.c
@@ -3429,6 +3429,8 @@ asmlinkage void __sched schedule(void)
 			"%s/0x%08x/%d\n",
 			current->comm, preempt_count(), current->pid);
 		debug_show_held_locks(current);
+		if (irqs_disabled())
+			print_irqtrace_events(current);
 		dump_stack();
 	}
 	profile_hit(SCHED_PROFILING, __builtin_return_address(0));
@@ -6977,6 +6979,8 @@ void __might_sleep(char *file, int line)
 		printk("in_atomic():%d, irqs_disabled():%d\n",
 			in_atomic(), irqs_disabled());
 		debug_show_held_locks(current);
+		if (irqs_disabled())
+			print_irqtrace_events(current);
 		dump_stack();
 	}
 #endif
_

Patches currently in -mm which might be from mingo@elte.hu are

conditionally-check-expected_preempt_count-in-__resched_legal.patch
acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi.patch
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
introduce-time_data-a-new-structure-to-hold-jiffies-xtime.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
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
high-res-timers-allow-tsc-clocksource-if-pmtimer-present.patch
dynticks-core.patch
dynticks-add-nohz-stats-to-proc-stat.patch
dynticks-i386-support-idle-handler-callbacks.patch
dynticks-i386-prepare-nmi-watchdog.patch
high-res-timers-dynticks-i386-support-enable-in-kconfig.patch
debugging-feature-add-proc-timer_stat.patch
debugging-feature-proc-timer_list.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
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

