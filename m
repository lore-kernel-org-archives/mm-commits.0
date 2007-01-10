From: akpm@osdl.org
Subject: - genapic-optimize-fix-apic-mode-setup-2.patch removed from -mm tree
Date: Wed, 10 Jan 2007 15:02:09 -0800
Message-ID: <200701102302.l0AN29HG010715@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33234 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965236AbXAJXDE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jan 2007 18:03:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, ak@suse.de, ebiederm@xmission.com, shaohua.li@intel.com, suresh.b.siddha@intel.com, mm-commits@vger.kernel.org


The patch titled
     genapic: optimize & fix APIC mode setup
has been removed from the -mm tree.  Its filename was
     genapic-optimize-fix-apic-mode-setup-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: genapic: optimize & fix APIC mode setup
From: Ingo Molnar <mingo@elte.hu>

Fix a couple of inconsistencies/problems I found while reviewing the x86_64
genapic code (when I was chasing mysterious eth0 timeouts that would only
trigger if CPU_HOTPLUG is enabled):

 - AMD systems defaulted to the slower flat-physical mode instead
   of the flat-logical mode. The only restriction on AMD systems
   is that they should not use clustered APIC mode.

 - removed the CPU hotplug hacks, switching the default for small
   systems back from phys-flat to logical-flat. The switching to logical
   flat mode on small systems fixed sporadic ethernet driver timeouts i
   was getting on a dual-core Athlon64 system:

    NETDEV WATCHDOG: eth0: transmit timed out
    eth0: Transmit timeout, status 0c 0005 c07f media 80.
    eth0: Tx queue start entry 32  dirty entry 28.
    eth0:  Tx descriptor 0 is 0008a04a. (queue head)
    eth0:  Tx descriptor 1 is 0008a04a.
    eth0:  Tx descriptor 2 is 0008a04a.
    eth0:  Tx descriptor 3 is 0008a04a.
    eth0: link up, 100Mbps, full-duplex, lpa 0xC5E1

 - The use of '<= 8' was a bug by itself (the valid APIC ids
   for logical flat mode go from 0 to 7, not 0 to 8). The new logic
   is to use logical flat mode on both AMD and Intel systems, and
   to only switch to physical mode when logical mode cannot be used.
   If CPU hotplug is racy wrt. APIC shutdown then CPU hotplug needs
   fixing, not the whole IRQ system be made inconsistent and slowed
   down.

 - minor cleanups: simplified some code constructs

build & booted on a couple of AMD and Intel SMP systems.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "Li, Shaohua" <shaohua.li@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/kernel/genapic.c |   39 ++++++++++++---------------------
 1 files changed, 15 insertions(+), 24 deletions(-)

diff -puN arch/x86_64/kernel/genapic.c~genapic-optimize-fix-apic-mode-setup-2 arch/x86_64/kernel/genapic.c
--- a/arch/x86_64/kernel/genapic.c~genapic-optimize-fix-apic-mode-setup-2
+++ a/arch/x86_64/kernel/genapic.c
@@ -32,21 +32,20 @@ extern struct genapic apic_cluster;
 extern struct genapic apic_flat;
 extern struct genapic apic_physflat;
 
-struct genapic *genapic = &apic_flat;
-
+struct genapic __read_mostly *genapic = &apic_flat;
 
 /*
  * Check the APIC IDs in bios_cpu_apicid and choose the APIC mode.
  */
 void __init clustered_apic_check(void)
 {
-	long i;
+	int i;
 	u8 clusters, max_cluster;
 	u8 id;
 	u8 cluster_cnt[NUM_APIC_CLUSTERS];
 	int max_apic = 0;
 
-#if defined(CONFIG_ACPI)
+#ifdef CONFIG_ACPI
 	/*
 	 * Some x86_64 machines use physical APIC mode regardless of how many
 	 * procs/clusters are present (x86_64 ES7000 is an example).
@@ -68,20 +67,17 @@ void __init clustered_apic_check(void)
 		cluster_cnt[APIC_CLUSTERID(id)]++;
 	}
 
-	/* Don't use clustered mode on AMD platforms. */
+	/*
+	 * Don't use clustered mode on AMD platforms, default
+	 * to flat logical mode.
+	 */
  	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD) {
-		genapic = &apic_physflat;
-#ifndef CONFIG_HOTPLUG_CPU
-		/* In the CPU hotplug case we cannot use broadcast mode
-		   because that opens a race when a CPU is removed.
-		   Stay at physflat mode in this case.
-		   It is bad to do this unconditionally though. Once
-		   we have ACPI platform support for CPU hotplug
-		   we should detect hotplug capablity from ACPI tables and
-		   only do this when really needed. -AK */
-		if (max_apic <= 8)
-			genapic = &apic_flat;
-#endif
+		/*
+		 * Switch to physical flat mode if more than 8 APICs
+		 * (In the case of 8 CPUs APIC ID goes from 0 to 7):
+		 */
+		if (max_apic >= 8)
+			genapic = &apic_physflat;
  		goto print;
  	}
 
@@ -103,14 +99,9 @@ void __init clustered_apic_check(void)
 	 * (We don't use lowest priority delivery + HW APIC IRQ steering, so
 	 * can ignore the clustered logical case and go straight to physical.)
 	 */
-	if (clusters <= 1 && max_cluster <= 8 && cluster_cnt[0] == max_cluster) {
-#ifdef CONFIG_HOTPLUG_CPU
-		/* Don't use APIC shortcuts in CPU hotplug to avoid races */
-		genapic = &apic_physflat;
-#else
+	if (clusters <= 1 && max_cluster <= 8 && cluster_cnt[0] == max_cluster)
 		genapic = &apic_flat;
-#endif
-	} else
+	else
 		genapic = &apic_cluster;
 
 print:
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
