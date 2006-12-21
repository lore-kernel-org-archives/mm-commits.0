From: akpm@osdl.org
Subject: - x86_64-fix-boot-time-hang-in-detect_calgary.patch removed from -mm tree
Date: Thu, 21 Dec 2006 12:10:06 -0800
Message-ID: <200612212010.kBLKA6Ug003531@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36625 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423084AbWLUULO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 15:11:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, ak@suse.de, muli@il.ibm.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     x86_64: fix boot time hang in detect_calgary()
has been removed from the -mm tree.  Its filename was
     x86_64-fix-boot-time-hang-in-detect_calgary.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: fix boot time hang in detect_calgary()
From: Ingo Molnar <mingo@elte.hu>

If CONFIG_CALGARY_IOMMU is built into the kernel via
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT, or is enabled via the
iommu=calgary boot option, then the detect_calgary() function runs to
detect the presence of a Calgary IOMMU.

detect_calgary() first searches the BIOS EBDA area for a "rio_table_hdr"
BIOS table.  It has this parsing algorithm for the EBDA:

	while (offset) {
		...
		/* The next offset is stored in the 1st word. 0 means no more */
 		offset = *((unsigned short *)(ptr + offset));
	}

Got that?  Lets repeat it slowly: we've got a BIOS-supplied data structure,
plus Linux kernel code that will only break out of an infinite parsing loop
once the BIOS gives a zero offset.  Ok?

Translation: what an excellent opportunity for BIOS writers to lock up the
Linux boot process in an utterly hard to debug place!  Indeed the BIOS
jumped on that opportunity on my box, which has the following EBDA chaining
layout:

  384, 65282, 65535, 65535, 65535, 65535, 65535, 65535 ...

see the pattern?  So my, definitely non-Calgary system happily locks up in
detect_calgary()!

The patch fixes the boot hang by trusting the BIOS-supplied data structure
a bit less: the parser always has to make forward progress, and if it
doesnt, we break out of the loop and i get the expected kernel message:

  Calgary: Unable to locate Rio Grande Table in EBDA - bailing!

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/kernel/pci-calgary.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN arch/x86_64/kernel/pci-calgary.c~x86_64-fix-boot-time-hang-in-detect_calgary arch/x86_64/kernel/pci-calgary.c
--- a/arch/x86_64/kernel/pci-calgary.c~x86_64-fix-boot-time-hang-in-detect_calgary
+++ a/arch/x86_64/kernel/pci-calgary.c
@@ -1052,7 +1052,7 @@ void __init detect_calgary(void)
 	void *tbl;
 	int calgary_found = 0;
 	unsigned long ptr;
-	int offset;
+	unsigned int offset, prev_offset;
 	int ret;
 
 	/*
@@ -1071,15 +1071,20 @@ void __init detect_calgary(void)
 	ptr = (unsigned long)phys_to_virt(get_bios_ebda());
 
 	rio_table_hdr = NULL;
+	prev_offset = 0;
 	offset = 0x180;
-	while (offset) {
+	/*
+	 * The next offset is stored in the 1st word.
+	 * Only parse up until the offset increases:
+	 */
+	while (offset > prev_offset) {
 		/* The block id is stored in the 2nd word */
 		if (*((unsigned short *)(ptr + offset + 2)) == 0x4752){
 			/* set the pointer past the offset & block id */
 			rio_table_hdr = (struct rio_table_hdr *)(ptr + offset + 4);
 			break;
 		}
-		/* The next offset is stored in the 1st word. 0 means no more */
+		prev_offset = offset;
 		offset = *((unsigned short *)(ptr + offset));
 	}
 	if (!rio_table_hdr) {
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
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
debugging-feature-sysrq-q-to-print-timers.patch
generic-vsyscall-gtod-support-for-generic_time.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
time-x86_64-hpet_address-cleanup.patch
time-x86_64-split-x86_64-kernel-timec-up.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-convert-x86_64-to-use-generic_time.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
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

