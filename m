From: akpm@osdl.org
Subject: + lockdep-print-irq-trace-info-on-asserts.patch added to -mm tree
Date: Thu, 07 Dec 2006 12:32:29 -0800
Message-ID: <200612072032.kB7KWTbO024677@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36508 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163298AbWLGUce (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 15:32:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu


The patch titled
     lockdep: print irq-trace info on asserts
has been added to the -mm tree.  Its filename is
     lockdep-print-irq-trace-info-on-asserts.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1448,7 +1448,7 @@ check_usage_backwards(struct task_struct
 	return print_irq_inversion_bug(curr, backwards_match, this, 0, irqclass);
 }
 
-static inline void print_irqtrace_events(struct task_struct *curr)
+void print_irqtrace_events(struct task_struct *curr)
 {
 	printk("irq event stamp: %u\n", curr->irq_events);
 	printk("hardirqs last  enabled at (%u): ", curr->hardirq_enable_event);
@@ -1461,10 +1461,6 @@ static inline void print_irqtrace_events
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
@@ -3345,6 +3345,8 @@ asmlinkage void __sched schedule(void)
 			"%s/0x%08x/%d\n",
 			current->comm, preempt_count(), current->pid);
 		debug_show_held_locks(current);
+		if (irqs_disabled())
+			print_irqtrace_events(current);
 		dump_stack();
 	}
 	profile_hit(SCHED_PROFILING, __builtin_return_address(0));
@@ -6855,6 +6857,8 @@ void __might_sleep(char *file, int line)
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

origin.patch
add-bottom_half.h.patch
convert-pm_sem-to-a-mutex.patch
lockdep-annotate-nfs-nfsd-in-kernel-sockets.patch
sysrq-x-show-blocked-tasks.patch
lockdep-internal-locking-fixes.patch
lockdep-misc-fixes-in-lockdepc.patch
binfmt_elf-randomize-pie-binaries.patch
disable-clone_child_cleartid-for-abnormal-exit.patch
lockdep-annotate-bcsp-driver.patch
lockdep-print-current-locks-on-in_atomic-warnings.patch
lockdep-name-some-old-style-locks.patch
sleep-profiling.patch
debug-workqueue-locking-sanity.patch
retries-in-ext3_prepare_write-violate-ordering-requirements.patch
retries-in-ext4_prepare_write-violate-ordering-requirements.patch
ktime-fix-signed--unsigned-mismatch-in-ktime_to_ns.patch
kprobes-enable-booster-on-the-preemptible-kernel.patch
declare-smp_call_function_single-in-generic-code.patch
smp_call_function_single-check-that-local-interrupts-are-enabled.patch
hotplug-cpu-clean-up-hotcpu_notifier-use.patch
remove-kernel-lockdepclockdep_internal.patch
lockdep-more-chains.patch
lockdep-show-more-details-about-self-test-failures.patch
softirq-remove-bug_ons-which-can-incorrectly-trigger.patch
futex-remove-unneeded-barrier.patch
lockdep-register_lock_class-fix.patch
add-ignore_loglevel-boot-option.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
convert-i386-pda-code-to-use-%fs.patch
genapic-optimize-fix-apic-mode-setup-2.patch
genapic-always-use-physical-delivery-mode-on-8-cpus.patch
genapic-remove-es7000-workaround.patch
genapic-remove-clustered-apic-mode.patch
genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
cpei-gets-warning-at-kernel-irq-migrationc27-move_masked_irq.patch
time-re-add-verify_pmtmr_rate.patch
debug-add-sysrq_always_enabled-boot-option.patch
lockdep-filter-off-by-default.patch
lockdep-improve-verbose-messages.patch
lockdep-improve-lockdep_reset.patch
lockdep-clean-up-very_verbose-define.patch
lockdep-use-chain-hash-on-config_debug_lockdep-too.patch
lockdep-print-irq-trace-info-on-asserts.patch
remove-the-old-bd_mutex-lockdep-annotation.patch
new-bd_mutex-lockdep-annotation.patch
remove-lock_key-approach-to-managing-nested-bd_mutex-locks.patch
simplify-some-aspects-of-bd_mutex-nesting.patch
use-mutex_lock_nested-for-bd_mutex-to-avoid-lockdep-warning.patch
avoid-lockdep-warning-in-md.patch
fix-generic-warn_on-message.patch
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

