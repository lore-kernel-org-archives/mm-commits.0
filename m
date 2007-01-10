From: akpm@osdl.org
Subject: - genapic-remove-clustered-apic-mode.patch removed from -mm tree
Date: Wed, 10 Jan 2007 15:02:18 -0800
Message-ID: <200701102302.l0AN2IQZ010724@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33214 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965237AbXAJXDB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jan 2007 18:03:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, ak@suse.de, ebiederm@xmission.com, shaohua.li@intel.com, suresh.b.siddha@intel.com, mm-commits@vger.kernel.org


The patch titled
     genapic: remove clustered APIC mode
has been removed from the -mm tree.  Its filename was
     genapic-remove-clustered-apic-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: genapic: remove clustered APIC mode
From: Ingo Molnar <mingo@elte.hu>

Remove now unused clustered APIC mode code.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "Li, Shaohua" <shaohua.li@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/kernel/Makefile          |    3 
 arch/x86_64/kernel/genapic_cluster.c |  137 -------------------------
 2 files changed, 1 insertion(+), 139 deletions(-)

diff -puN arch/x86_64/kernel/Makefile~genapic-remove-clustered-apic-mode arch/x86_64/kernel/Makefile
--- a/arch/x86_64/kernel/Makefile~genapic-remove-clustered-apic-mode
+++ a/arch/x86_64/kernel/Makefile
@@ -21,8 +21,7 @@ obj-$(CONFIG_MICROCODE)		+= microcode.o
 obj-$(CONFIG_X86_CPUID)		+= cpuid.o
 obj-$(CONFIG_SMP)		+= smp.o smpboot.o trampoline.o
 obj-y				+= apic.o  nmi.o
-obj-y				+= io_apic.o mpparse.o \
-		genapic.o genapic_cluster.o genapic_flat.o
+obj-y				+= io_apic.o mpparse.o genapic.o genapic_flat.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump.o
 obj-$(CONFIG_PM)		+= suspend.o
diff -puN arch/x86_64/kernel/genapic_cluster.c~genapic-remove-clustered-apic-mode /dev/null
--- a/arch/x86_64/kernel/genapic_cluster.c
+++ /dev/null
@@ -1,137 +0,0 @@
-/*
- * Copyright 2004 James Cleverdon, IBM.
- * Subject to the GNU Public License, v.2
- *
- * Clustered APIC subarch code.  Up to 255 CPUs, physical delivery.
- * (A more realistic maximum is around 230 CPUs.)
- *
- * Hacked for x86-64 by James Cleverdon from i386 architecture code by
- * Martin Bligh, Andi Kleen, James Bottomley, John Stultz, and
- * James Cleverdon.
- */
-#include <linux/threads.h>
-#include <linux/cpumask.h>
-#include <linux/string.h>
-#include <linux/kernel.h>
-#include <linux/ctype.h>
-#include <linux/init.h>
-#include <asm/smp.h>
-#include <asm/ipi.h>
-
-
-/*
- * Set up the logical destination ID.
- *
- * Intel recommends to set DFR, LDR and TPR before enabling
- * an APIC.  See e.g. "AP-388 82489DX User's Manual" (Intel
- * document number 292116).  So here it goes...
- */
-static void cluster_init_apic_ldr(void)
-{
-	unsigned long val, id;
-	long i, count;
-	u8 lid;
-	u8 my_id = hard_smp_processor_id();
-	u8 my_cluster = APIC_CLUSTER(my_id);
-
-	/* Create logical APIC IDs by counting CPUs already in cluster. */
-	for (count = 0, i = NR_CPUS; --i >= 0; ) {
-		lid = x86_cpu_to_log_apicid[i];
-		if (lid != BAD_APICID && APIC_CLUSTER(lid) == my_cluster)
-			++count;
-	}
-	/*
-	 * We only have a 4 wide bitmap in cluster mode.  There's no way
-	 * to get above 60 CPUs and still give each one it's own bit.
-	 * But, we're using physical IRQ delivery, so we don't care.
-	 * Use bit 3 for the 4th through Nth CPU in each cluster.
-	 */
-	if (count >= XAPIC_DEST_CPUS_SHIFT)
-		count = 3;
-	id = my_cluster | (1UL << count);
-	x86_cpu_to_log_apicid[smp_processor_id()] = id;
-	apic_write(APIC_DFR, APIC_DFR_CLUSTER);
-	val = apic_read(APIC_LDR) & ~APIC_LDR_MASK;
-	val |= SET_APIC_LOGICAL_ID(id);
-	apic_write(APIC_LDR, val);
-}
-
-/* Start with all IRQs pointing to boot CPU.  IRQ balancing will shift them. */
-
-static cpumask_t cluster_target_cpus(void)
-{
-	return cpumask_of_cpu(0);
-}
-
-static cpumask_t cluster_vector_allocation_domain(int cpu)
-{
-	cpumask_t domain = CPU_MASK_NONE;
-	cpu_set(cpu, domain);
-	return domain;
-}
-
-static void cluster_send_IPI_mask(cpumask_t mask, int vector)
-{
-	send_IPI_mask_sequence(mask, vector);
-}
-
-static void cluster_send_IPI_allbutself(int vector)
-{
-	cpumask_t mask = cpu_online_map;
-
-	cpu_clear(smp_processor_id(), mask);
-
-	if (!cpus_empty(mask))
-		cluster_send_IPI_mask(mask, vector);
-}
-
-static void cluster_send_IPI_all(int vector)
-{
-	cluster_send_IPI_mask(cpu_online_map, vector);
-}
-
-static int cluster_apic_id_registered(void)
-{
-	return 1;
-}
-
-static unsigned int cluster_cpu_mask_to_apicid(cpumask_t cpumask)
-{
-	int cpu;
-
-	/*
-	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
-	 * May as well be the first.
-	 */
-	cpu = first_cpu(cpumask);
-	if ((unsigned)cpu < NR_CPUS)
-		return x86_cpu_to_apicid[cpu];
-	else
-		return BAD_APICID;
-}
-
-/* cpuid returns the value latched in the HW at reset, not the APIC ID
- * register's value.  For any box whose BIOS changes APIC IDs, like
- * clustered APIC systems, we must use hard_smp_processor_id.
- *
- * See Intel's IA-32 SW Dev's Manual Vol2 under CPUID.
- */
-static unsigned int phys_pkg_id(int index_msb)
-{
-	return hard_smp_processor_id() >> index_msb;
-}
-
-struct genapic apic_cluster = {
-	.name = "clustered",
-	.int_delivery_mode = dest_Fixed,
-	.int_dest_mode = (APIC_DEST_PHYSICAL != 0),
-	.target_cpus = cluster_target_cpus,
-	.vector_allocation_domain = cluster_vector_allocation_domain,
-	.apic_id_registered = cluster_apic_id_registered,
-	.init_apic_ldr = cluster_init_apic_ldr,
-	.send_IPI_all = cluster_send_IPI_all,
-	.send_IPI_allbutself = cluster_send_IPI_allbutself,
-	.send_IPI_mask = cluster_send_IPI_mask,
-	.cpu_mask_to_apicid = cluster_cpu_mask_to_apicid,
-	.phys_pkg_id = phys_pkg_id,
-};
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
