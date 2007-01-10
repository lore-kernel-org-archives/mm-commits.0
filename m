From: akpm@osdl.org
Subject: - genapic-remove-es7000-workaround.patch removed from -mm tree
Date: Wed, 10 Jan 2007 15:02:15 -0800
Message-ID: <200701102302.l0AN2Ffh010721@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33170 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965226AbXAJXCw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jan 2007 18:02:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, ak@suse.de, ebiederm@xmission.com, shaohua.li@intel.com, suresh.b.siddha@intel.com, mm-commits@vger.kernel.org


The patch titled
     genapic: remove ES7000 workaround
has been removed from the -mm tree.  Its filename was
     genapic-remove-es7000-workaround.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: genapic: remove ES7000 workaround
From: Ingo Molnar <mingo@elte.hu>

Remove ES7000 workaround.  Although not spelled out clearly, it is likely that
the real bug was that clustered APIC mode does not work on those systems.  So
if the CPU count is low then these systems can use logical delivery mode just
as much.  The quirk forced physical APIC mode under all circumstances.

(patch needs testing on at least one of those systems with a CPU
count of 8 or lower.)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "Li, Shaohua" <shaohua.li@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/kernel/genapic.c |   11 +----------
 1 files changed, 1 insertion(+), 10 deletions(-)

diff -puN arch/x86_64/kernel/genapic.c~genapic-remove-es7000-workaround arch/x86_64/kernel/genapic.c
--- a/arch/x86_64/kernel/genapic.c~genapic-remove-es7000-workaround
+++ a/arch/x86_64/kernel/genapic.c
@@ -40,17 +40,9 @@ void __init clustered_apic_check(void)
 	unsigned int i, max_apic = 0;
 	u8 id;
 
-#ifdef CONFIG_ACPI
 	/*
-	 * Quirk: some x86_64 machines can only use physical APIC mode
-	 * regardless of how many processors are present (x86_64 ES7000
-	 * is an example).
+	 * Determine the maximum APIC ID in use:
 	 */
-	if (acpi_fadt.revision > FADT2_REVISION_ID &&
-			acpi_fadt.force_apic_physical_destination_mode)
-		goto force_physflat;
-#endif
-
 	for (i = 0; i < NR_CPUS; i++) {
 		id = bios_cpu_apicid[i];
 		if (id == BAD_APICID)
@@ -62,7 +54,6 @@ void __init clustered_apic_check(void)
 	if (max_apic < 8)
 		genapic = &apic_flat;
 	else
-force_physflat:
 		genapic = &apic_physflat;
 
 	printk(KERN_INFO "Setting APIC routing to %s\n", genapic->name);
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
