From: akpm@osdl.org
Subject: - genapic-always-use-physical-delivery-mode-on-8-cpus.patch removed from -mm tree
Date: Wed, 10 Jan 2007 15:02:12 -0800
Message-ID: <200701102302.l0AN2C1q010718@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33203 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965231AbXAJXDA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jan 2007 18:03:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, ak@suse.de, ebiederm@xmission.com, shaohua.li@intel.com, suresh.b.siddha@intel.com, mm-commits@vger.kernel.org


The patch titled
     genapic: always use physical delivery mode on > 8 CPUs
has been removed from the -mm tree.  Its filename was
     genapic-always-use-physical-delivery-mode-on-8-cpus.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: genapic: always use physical delivery mode on > 8 CPUs
From: Ingo Molnar <mingo@elte.hu>

Remove clustered APIC mode.  There's little point in the use of clustered APIC
mode, broadcasting is limited to within the cluster only, and chipsets have
bugs in this area as well.  So default to physical APIC mode when the CPU
count is large, and default to logical APIC mode when the CPU count is 8 or
smaller.

(this patch only removes the use of genapic_cluster and cleans up the
resulting genapic.c file - removal of all remaining traces of clustered
mode will be done by another patch.)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "Li, Shaohua" <shaohua.li@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/kernel/genapic.c |   72 +++++++--------------------------
 include/asm-x86_64/genapic.h |    4 +
 2 files changed, 19 insertions(+), 57 deletions(-)

diff -puN arch/x86_64/kernel/genapic.c~genapic-always-use-physical-delivery-mode-on-8-cpus arch/x86_64/kernel/genapic.c
--- a/arch/x86_64/kernel/genapic.c~genapic-always-use-physical-delivery-mode-on-8-cpus
+++ a/arch/x86_64/kernel/genapic.c
@@ -11,26 +11,24 @@
 #include <linux/threads.h>
 #include <linux/cpumask.h>
 #include <linux/string.h>
+#include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/ctype.h>
 #include <linux/init.h>
-#include <linux/module.h>
 
 #include <asm/smp.h>
 #include <asm/ipi.h>
 
-#if defined(CONFIG_ACPI)
+#ifdef CONFIG_ACPI
 #include <acpi/acpi_bus.h>
 #endif
 
 /* which logical CPU number maps to which CPU (physical APIC ID) */
-u8 x86_cpu_to_apicid[NR_CPUS] __read_mostly = { [0 ... NR_CPUS-1] = BAD_APICID };
+u8 x86_cpu_to_apicid[NR_CPUS] __read_mostly
+					= { [0 ... NR_CPUS-1] = BAD_APICID };
 EXPORT_SYMBOL(x86_cpu_to_apicid);
-u8 x86_cpu_to_log_apicid[NR_CPUS] = { [0 ... NR_CPUS-1] = BAD_APICID };
 
-extern struct genapic apic_cluster;
-extern struct genapic apic_flat;
-extern struct genapic apic_physflat;
+u8 x86_cpu_to_log_apicid[NR_CPUS]	= { [0 ... NR_CPUS-1] = BAD_APICID };
 
 struct genapic __read_mostly *genapic = &apic_flat;
 
@@ -39,76 +37,38 @@ struct genapic __read_mostly *genapic = 
  */
 void __init clustered_apic_check(void)
 {
-	int i;
-	u8 clusters, max_cluster;
+	unsigned int i, max_apic = 0;
 	u8 id;
-	u8 cluster_cnt[NUM_APIC_CLUSTERS];
-	int max_apic = 0;
 
 #ifdef CONFIG_ACPI
 	/*
-	 * Some x86_64 machines use physical APIC mode regardless of how many
-	 * procs/clusters are present (x86_64 ES7000 is an example).
+	 * Quirk: some x86_64 machines can only use physical APIC mode
+	 * regardless of how many processors are present (x86_64 ES7000
+	 * is an example).
 	 */
-	if (acpi_fadt.revision > FADT2_REVISION_ID)
-		if (acpi_fadt.force_apic_physical_destination_mode) {
-			genapic = &apic_cluster;
-			goto print;
-		}
+	if (acpi_fadt.revision > FADT2_REVISION_ID &&
+			acpi_fadt.force_apic_physical_destination_mode)
+		goto force_physflat;
 #endif
 
-	memset(cluster_cnt, 0, sizeof(cluster_cnt));
 	for (i = 0; i < NR_CPUS; i++) {
 		id = bios_cpu_apicid[i];
 		if (id == BAD_APICID)
 			continue;
 		if (id > max_apic)
 			max_apic = id;
-		cluster_cnt[APIC_CLUSTERID(id)]++;
 	}
 
-	/*
-	 * Don't use clustered mode on AMD platforms, default
-	 * to flat logical mode.
-	 */
- 	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD) {
-		/*
-		 * Switch to physical flat mode if more than 8 APICs
-		 * (In the case of 8 CPUs APIC ID goes from 0 to 7):
-		 */
-		if (max_apic >= 8)
-			genapic = &apic_physflat;
- 		goto print;
- 	}
-
-	clusters = 0;
-	max_cluster = 0;
-
-	for (i = 0; i < NUM_APIC_CLUSTERS; i++) {
-		if (cluster_cnt[i] > 0) {
-			++clusters;
-			if (cluster_cnt[i] > max_cluster)
-				max_cluster = cluster_cnt[i];
-		}
-	}
-
-	/*
-	 * If we have clusters <= 1 and CPUs <= 8 in cluster 0, then flat mode,
-	 * else if max_cluster <= 4 and cluster_cnt[15] == 0, clustered logical
-	 * else physical mode.
-	 * (We don't use lowest priority delivery + HW APIC IRQ steering, so
-	 * can ignore the clustered logical case and go straight to physical.)
-	 */
-	if (clusters <= 1 && max_cluster <= 8 && cluster_cnt[0] == max_cluster)
+	if (max_apic < 8)
 		genapic = &apic_flat;
 	else
-		genapic = &apic_cluster;
+force_physflat:
+		genapic = &apic_physflat;
 
-print:
 	printk(KERN_INFO "Setting APIC routing to %s\n", genapic->name);
 }
 
-/* Same for both flat and clustered. */
+/* Same for both flat and physical. */
 
 void send_IPI_self(int vector)
 {
diff -puN include/asm-x86_64/genapic.h~genapic-always-use-physical-delivery-mode-on-8-cpus include/asm-x86_64/genapic.h
--- a/include/asm-x86_64/genapic.h~genapic-always-use-physical-delivery-mode-on-8-cpus
+++ a/include/asm-x86_64/genapic.h
@@ -29,7 +29,9 @@ struct genapic {
 	unsigned int (*phys_pkg_id)(int index_msb);
 };
 
-
 extern struct genapic *genapic;
 
+extern struct genapic apic_flat;
+extern struct genapic apic_physflat;
+
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
