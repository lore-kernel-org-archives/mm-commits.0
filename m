From: akpm@osdl.org
Subject: - sched-improve-sched_clock-on-i686.patch removed from -mm tree
Date: Wed, 10 Jan 2007 15:03:33 -0800
Message-ID: <200701102303.l0AN3X4U010832@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33492 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965278AbXAJXEF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jan 2007 18:04:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     sched: improve sched_clock() on i686
has been removed from the -mm tree.  Its filename was
     sched-improve-sched_clock-on-i686.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sched: improve sched_clock() on i686
From: Ingo Molnar <mingo@elte.hu>

Clean up sched_clock() on i686: it will use the TSC if available and falls
back to jiffies only if the user asked for it to be disabled via notsc or
the CPU calibration code didnt figure out the right cpu_khz.

This generally makes the scheduler timestamps more finegrained, on all
hardware.  (the current scheduler is pretty resistant against asynchronous
sched_clock() values on different CPUs, it will allow at most up to a jiffy
of jitter.)

Also simplify sched_clock()'s check for TSC availability: propagate the
desire and ability to use the TSC into the tsc_disable flag, previously
this flag only indicated whether the notsc option was passed.  This makes
the rare low-res sched_clock() codepath a single branch off a read-mostly
flag.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/tsc.c  |   22 ++++++++++++++--------
 include/asm-i386/bugs.h |    2 +-
 2 files changed, 15 insertions(+), 9 deletions(-)

diff -puN arch/i386/kernel/tsc.c~sched-improve-sched_clock-on-i686 arch/i386/kernel/tsc.c
--- a/arch/i386/kernel/tsc.c~sched-improve-sched_clock-on-i686
+++ a/arch/i386/kernel/tsc.c
@@ -112,13 +112,10 @@ unsigned long long sched_clock(void)
 		return (*custom_sched_clock)();
 
 	/*
-	 * in the NUMA case we dont use the TSC as they are not
-	 * synchronized across all CPUs.
+	 * Fall back to jiffies if there's no TSC available:
 	 */
-#ifndef CONFIG_NUMA
-	if (!cpu_khz || check_tsc_unstable())
-#endif
-		/* no locking but a rare wrong value is not a big deal */
+	if (unlikely(tsc_disable))
+		/* No locking but a rare wrong value is not a big deal: */
 		return (jiffies_64 - INITIAL_JIFFIES) * (1000000000 / HZ);
 
 	/* read the Time Stamp Counter: */
@@ -198,13 +195,13 @@ EXPORT_SYMBOL(recalibrate_cpu_khz);
 void __init tsc_init(void)
 {
 	if (!cpu_has_tsc || tsc_disable)
-		return;
+		goto out_no_tsc;
 
 	cpu_khz = calculate_cpu_khz();
 	tsc_khz = cpu_khz;
 
 	if (!cpu_khz)
-		return;
+		goto out_no_tsc;
 
 	printk("Detected %lu.%03lu MHz processor.\n",
 				(unsigned long)cpu_khz / 1000,
@@ -212,6 +209,15 @@ void __init tsc_init(void)
 
 	set_cyc2ns_scale(cpu_khz);
 	use_tsc_delay();
+	return;
+
+out_no_tsc:
+	/*
+	 * Set the tsc_disable flag if there's no TSC support, this
+	 * makes it a fast flag for the kernel to see whether it
+	 * should be using the TSC.
+	 */
+	tsc_disable = 1;
 }
 
 #ifdef CONFIG_CPU_FREQ
diff -puN include/asm-i386/bugs.h~sched-improve-sched_clock-on-i686 include/asm-i386/bugs.h
--- a/include/asm-i386/bugs.h~sched-improve-sched_clock-on-i686
+++ a/include/asm-i386/bugs.h
@@ -160,7 +160,7 @@ static void __init check_config(void)
  * If we configured ourselves for a TSC, we'd better have one!
  */
 #ifdef CONFIG_X86_TSC
-	if (!cpu_has_tsc)
+	if (!cpu_has_tsc && !tsc_disable)
 		panic("Kernel compiled for Pentium+, requires TSC feature!");
 #endif
 
_

Patches currently in -mm which might be from mingo@elte.hu are

sched-tasks-cannot-run-on-cpus-onlined-after-boot.patch
i386-sched_clock-using-init-data-tsc_disable-fix.patch
make-noirqdebug_setup-function-non-init-to-fix-modpost-warning.patch
kvm-add-vm-exit-profiling.patch
kvm-add-vm-exit-profiling-fix.patch
revert-bd_mount_mutex-back-to-a-semaphore.patch
use-correct-macros-in-raid-code-not-raw-asm.patch
use-correct-macros-in-raid-code-not-raw-asm-include.patch
acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi.patch
fix-for-crash-in-adummy_init.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch.patch
spin_lock_irq-enable-interrupts-while-spinning-x86_64-implementation.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation-fix.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation-fix-fix.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
lockdep-also-check-for-freed-locks-in-kmem_cache_free.patch
lockdep-more-unlock-on-error-fixes.patch
lockdep-more-unlock-on-error-fixes-fix.patch
lockdep-add-graph-depth-information-to-proc-lockdep.patch
consolidate-default-sched_clock.patch
use-cycle_t-instead-of-u64-in-struct-time_interpolator.patch
proc-remove-useless-and-buggy-nlink-settings.patch
simplify-the-stacktrace-code.patch
gtod-uninline-jiffiesh.patch
gtod-fix-multiple-conversion-bugs-in-msecs_to_jiffies.patch
gtod-fix-timeout-overflow.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
dynticks-uninline-irq_enter.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-namespace-and-enum-cleanup-vs-git-input.patch
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
clockevents-i386-drivers-high-res-timers-fix-apic-event-broadcasting-code.patch
clockevents-i386-hpet-driver.patch
i386-apic-rework-and-fix-local-apic-calibration.patch
high-res-timers-core.patch
high-res-timers-core-do-itimer-rearming-in-process-context.patch
high-res-timers-core-do-itimer-rearming-in-process-context-fix2.patch
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
debugging-feature-proc-timer_list-warning-fix.patch
debugging-feature-sysrq-q-to-print-timers.patch
generic-vsyscall-gtod-support-for-generic_time.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
time-x86_64-hpet_address-cleanup.patch
revert-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-split-x86_64-kernel-timec-up.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-fix.patch
reapply-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-convert-x86_64-to-use-generic_time.patch
time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
schedule_on_each_cpu-use-preempt_disable.patch
aio-is-unlikely.patch
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
