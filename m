From: akpm@osdl.org
Subject: + x86_64-do-not-enable-the-nmi-watchdog-by-default.patch added to -mm tree
Date: Fri, 08 Dec 2006 15:06:02 -0800
Message-ID: <200612082306.kB8N62EW008343@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48655 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761245AbWLHXGW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 18:06:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, ak@suse.de, alan@lxorguk.ukuu.org.uk


The patch titled
     x86_64: do not enable the NMI watchdog by default
has been added to the -mm tree.  Its filename is
     x86_64-do-not-enable-the-nmi-watchdog-by-default.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: do not enable the NMI watchdog by default
From: Ingo Molnar <mingo@elte.hu>

Do not enable the NMI watchdog by default.  Now that we have lockdep i
cannot remember the last time it caught a real bug, but the NMI watchdog
can /cause/ problems.  Furthermore, to the typical user, an NMI watchdog
assert results in a total lockup anyway (if under X).  In that sense, all
that the NMI watchdog does is that it makes the system /less/ stable and
/less/ debuggable.

People can still enable it either after bootup via:

   echo 1 > /proc/sys/kernel/nmi

or via the nmi_watchdog=1 or nmi_watchdog=2 boot options.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/kernel/apic.c    |    1 -
 arch/x86_64/kernel/io_apic.c |    1 -
 arch/x86_64/kernel/nmi.c     |    2 +-
 arch/x86_64/kernel/smpboot.c |    1 -
 include/asm-x86_64/nmi.h     |    1 -
 5 files changed, 1 insertion(+), 5 deletions(-)

diff -puN arch/x86_64/kernel/apic.c~x86_64-do-not-enable-the-nmi-watchdog-by-default arch/x86_64/kernel/apic.c
--- a/arch/x86_64/kernel/apic.c~x86_64-do-not-enable-the-nmi-watchdog-by-default
+++ a/arch/x86_64/kernel/apic.c
@@ -427,7 +427,6 @@ void __cpuinit setup_local_APIC (void)
 			oldvalue, value);
 	}
 
-	nmi_watchdog_default();
 	setup_apic_nmi_watchdog(NULL);
 	apic_pm_activate();
 }
diff -puN arch/x86_64/kernel/io_apic.c~x86_64-do-not-enable-the-nmi-watchdog-by-default arch/x86_64/kernel/io_apic.c
--- a/arch/x86_64/kernel/io_apic.c~x86_64-do-not-enable-the-nmi-watchdog-by-default
+++ a/arch/x86_64/kernel/io_apic.c
@@ -1580,7 +1580,6 @@ static int try_apic_pin(int apic, int pi
 	 * Ok, does IRQ0 through the IOAPIC work?
 	 */
 	if (!no_timer_check && timer_irq_works()) {
-		nmi_watchdog_default();
 		if (nmi_watchdog == NMI_IO_APIC) {
 			disable_8259A_irq(0);
 			setup_nmi();
diff -puN arch/x86_64/kernel/nmi.c~x86_64-do-not-enable-the-nmi-watchdog-by-default arch/x86_64/kernel/nmi.c
--- a/arch/x86_64/kernel/nmi.c~x86_64-do-not-enable-the-nmi-watchdog-by-default
+++ a/arch/x86_64/kernel/nmi.c
@@ -183,7 +183,7 @@ static __cpuinit inline int nmi_known_cp
 }
 
 /* Run after command line and cpu_init init, but before all other checks */
-void nmi_watchdog_default(void)
+static inline void nmi_watchdog_default(void)
 {
 	if (nmi_watchdog != NMI_DEFAULT)
 		return;
diff -puN arch/x86_64/kernel/smpboot.c~x86_64-do-not-enable-the-nmi-watchdog-by-default arch/x86_64/kernel/smpboot.c
--- a/arch/x86_64/kernel/smpboot.c~x86_64-do-not-enable-the-nmi-watchdog-by-default
+++ a/arch/x86_64/kernel/smpboot.c
@@ -1081,7 +1081,6 @@ static int __init smp_sanity_check(unsig
  */
 void __init smp_prepare_cpus(unsigned int max_cpus)
 {
-	nmi_watchdog_default();
 	current_cpu_data = boot_cpu_data;
 	current_thread_info()->cpu = 0;  /* needed? */
 	set_cpu_sibling_map(0);
diff -puN include/asm-x86_64/nmi.h~x86_64-do-not-enable-the-nmi-watchdog-by-default include/asm-x86_64/nmi.h
--- a/include/asm-x86_64/nmi.h~x86_64-do-not-enable-the-nmi-watchdog-by-default
+++ a/include/asm-x86_64/nmi.h
@@ -59,7 +59,6 @@ extern void disable_timer_nmi_watchdog(v
 extern void enable_timer_nmi_watchdog(void);
 extern int nmi_watchdog_tick (struct pt_regs * regs, unsigned reason);
 
-extern void nmi_watchdog_default(void);
 extern int setup_nmi_watchdog(char *);
 
 extern atomic_t nmi_active;
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi.patch
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

