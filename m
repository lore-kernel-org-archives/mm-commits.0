From: akpm@osdl.org
Subject: - genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch removed from -mm tree
Date: Wed, 10 Jan 2007 15:02:20 -0800
Message-ID: <200701102302.l0AN2KxQ010729@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33260 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965240AbXAJXDE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jan 2007 18:03:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, ak@suse.de, ebiederm@xmission.com, shaohua.li@intel.com, suresh.b.siddha@intel.com, mm-commits@vger.kernel.org


The patch titled
     genapic: default to physical mode on hotplug CPU kernels
has been removed from the -mm tree.  Its filename was
     genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: genapic: default to physical mode on hotplug CPU kernels
From: Ingo Molnar <mingo@elte.hu>

Default to physical mode on hotplug CPU kernels.  Furher simplify and clean up
the APIC initialization code.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "Li, Shaohua" <shaohua.li@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/acpi/boot.c              |    2 +-
 arch/i386/kernel/mpparse.c                |    2 +-
 arch/x86_64/kernel/genapic.c              |   20 +++-----------------
 arch/x86_64/kernel/mpparse.c              |    2 +-
 include/asm-i386/genapic.h                |    4 ++--
 include/asm-i386/mach-bigsmp/mach_apic.h  |    2 +-
 include/asm-i386/mach-default/mach_apic.h |    2 +-
 include/asm-i386/mach-es7000/mach_apic.h  |    2 +-
 include/asm-i386/mach-generic/mach_apic.h |    2 +-
 include/asm-i386/mach-numaq/mach_apic.h   |    2 +-
 include/asm-i386/mach-summit/mach_apic.h  |    2 +-
 include/asm-i386/mach-visws/mach_apic.h   |    2 +-
 include/asm-x86_64/apic.h                 |    2 +-
 13 files changed, 16 insertions(+), 30 deletions(-)

diff -puN arch/i386/kernel/acpi/boot.c~genapic-default-to-physical-mode-on-hotplug-cpu-kernels arch/i386/kernel/acpi/boot.c
--- a/arch/i386/kernel/acpi/boot.c~genapic-default-to-physical-mode-on-hotplug-cpu-kernels
+++ a/arch/i386/kernel/acpi/boot.c
@@ -931,7 +931,7 @@ static void __init acpi_process_madt(voi
 				acpi_ioapic = 1;
 
 				smp_found_config = 1;
-				clustered_apic_check();
+				setup_apic_routing();
 			}
 		}
 		if (error == -EINVAL) {
diff -puN arch/i386/kernel/mpparse.c~genapic-default-to-physical-mode-on-hotplug-cpu-kernels arch/i386/kernel/mpparse.c
--- a/arch/i386/kernel/mpparse.c~genapic-default-to-physical-mode-on-hotplug-cpu-kernels
+++ a/arch/i386/kernel/mpparse.c
@@ -477,7 +477,7 @@ static int __init smp_read_mpc(struct mp
 		}
 		++mpc_record;
 	}
-	clustered_apic_check();
+	setup_apic_routing();
 	if (!num_processors)
 		printk(KERN_ERR "SMP mptable: no processors registered!\n");
 	return num_processors;
diff -puN arch/x86_64/kernel/genapic.c~genapic-default-to-physical-mode-on-hotplug-cpu-kernels arch/x86_64/kernel/genapic.c
--- a/arch/x86_64/kernel/genapic.c~genapic-default-to-physical-mode-on-hotplug-cpu-kernels
+++ a/arch/x86_64/kernel/genapic.c
@@ -33,25 +33,11 @@ u8 x86_cpu_to_log_apicid[NR_CPUS]	= { [0
 struct genapic __read_mostly *genapic = &apic_flat;
 
 /*
- * Check the APIC IDs in bios_cpu_apicid and choose the APIC mode.
+ * Choose the APIC routing mode:
  */
-void __init clustered_apic_check(void)
+void __init setup_apic_routing(void)
 {
-	unsigned int i, max_apic = 0;
-	u8 id;
-
-	/*
-	 * Determine the maximum APIC ID in use:
-	 */
-	for (i = 0; i < NR_CPUS; i++) {
-		id = bios_cpu_apicid[i];
-		if (id == BAD_APICID)
-			continue;
-		if (id > max_apic)
-			max_apic = id;
-	}
-
-	if (max_apic < 8)
+	if (cpus_weight(cpu_possible_map) <= 8)
 		genapic = &apic_flat;
 	else
 		genapic = &apic_physflat;
diff -puN arch/x86_64/kernel/mpparse.c~genapic-default-to-physical-mode-on-hotplug-cpu-kernels arch/x86_64/kernel/mpparse.c
--- a/arch/x86_64/kernel/mpparse.c~genapic-default-to-physical-mode-on-hotplug-cpu-kernels
+++ a/arch/x86_64/kernel/mpparse.c
@@ -300,7 +300,7 @@ static int __init smp_read_mpc(struct mp
 			}
 		}
 	}
-	clustered_apic_check();
+	setup_apic_routing();
 	if (!num_processors)
 		printk(KERN_ERR "MPTABLE: no processors registered!\n");
 	return num_processors;
diff -puN include/asm-i386/genapic.h~genapic-default-to-physical-mode-on-hotplug-cpu-kernels include/asm-i386/genapic.h
--- a/include/asm-i386/genapic.h~genapic-default-to-physical-mode-on-hotplug-cpu-kernels
+++ a/include/asm-i386/genapic.h
@@ -36,7 +36,7 @@ struct genapic { 
 	void (*init_apic_ldr)(void);
 	physid_mask_t (*ioapic_phys_id_map)(physid_mask_t map);
 
-	void (*clustered_apic_check)(void);
+	void (*setup_apic_routing)(void);
 	int (*multi_timer_check)(int apic, int irq);
 	int (*apicid_to_node)(int logical_apicid); 
 	int (*cpu_to_logical_apicid)(int cpu);
@@ -99,7 +99,7 @@ struct genapic { 
 	APICFUNC(check_apicid_present) \
 	APICFUNC(init_apic_ldr) \
 	APICFUNC(ioapic_phys_id_map) \
-	APICFUNC(clustered_apic_check) \
+	APICFUNC(setup_apic_routing) \
 	APICFUNC(multi_timer_check) \
 	APICFUNC(apicid_to_node) \
 	APICFUNC(cpu_to_logical_apicid) \
diff -puN include/asm-i386/mach-bigsmp/mach_apic.h~genapic-default-to-physical-mode-on-hotplug-cpu-kernels include/asm-i386/mach-bigsmp/mach_apic.h
--- a/include/asm-i386/mach-bigsmp/mach_apic.h~genapic-default-to-physical-mode-on-hotplug-cpu-kernels
+++ a/include/asm-i386/mach-bigsmp/mach_apic.h
@@ -71,7 +71,7 @@ static inline void init_apic_ldr(void)
 	apic_write_around(APIC_LDR, val);
 }
 
-static inline void clustered_apic_check(void)
+static inline void setup_apic_routing(void)
 {
 	printk("Enabling APIC mode:  %s.  Using %d I/O APICs\n",
 		"Physflat", nr_ioapics);
diff -puN include/asm-i386/mach-default/mach_apic.h~genapic-default-to-physical-mode-on-hotplug-cpu-kernels include/asm-i386/mach-default/mach_apic.h
--- a/include/asm-i386/mach-default/mach_apic.h~genapic-default-to-physical-mode-on-hotplug-cpu-kernels
+++ a/include/asm-i386/mach-default/mach_apic.h
@@ -54,7 +54,7 @@ static inline physid_mask_t ioapic_phys_
 	return phys_map;
 }
 
-static inline void clustered_apic_check(void)
+static inline void setup_apic_routing(void)
 {
 	printk("Enabling APIC mode:  %s.  Using %d I/O APICs\n",
 					"Flat", nr_ioapics);
diff -puN include/asm-i386/mach-es7000/mach_apic.h~genapic-default-to-physical-mode-on-hotplug-cpu-kernels include/asm-i386/mach-es7000/mach_apic.h
--- a/include/asm-i386/mach-es7000/mach_apic.h~genapic-default-to-physical-mode-on-hotplug-cpu-kernels
+++ a/include/asm-i386/mach-es7000/mach_apic.h
@@ -81,7 +81,7 @@ static inline void enable_apic_mode(void
 }
 
 extern int apic_version [MAX_APICS];
-static inline void clustered_apic_check(void)
+static inline void setup_apic_routing(void)
 {
 	int apic = bios_cpu_apicid[smp_processor_id()];
 	printk("Enabling APIC mode:  %s.  Using %d I/O APICs, target cpus %lx\n",
diff -puN include/asm-i386/mach-generic/mach_apic.h~genapic-default-to-physical-mode-on-hotplug-cpu-kernels include/asm-i386/mach-generic/mach_apic.h
--- a/include/asm-i386/mach-generic/mach_apic.h~genapic-default-to-physical-mode-on-hotplug-cpu-kernels
+++ a/include/asm-i386/mach-generic/mach_apic.h
@@ -13,7 +13,7 @@
 #define apic_id_registered (genapic->apic_id_registered)
 #define init_apic_ldr (genapic->init_apic_ldr)
 #define ioapic_phys_id_map (genapic->ioapic_phys_id_map)
-#define clustered_apic_check (genapic->clustered_apic_check) 
+#define setup_apic_routing (genapic->setup_apic_routing)
 #define multi_timer_check (genapic->multi_timer_check)
 #define apicid_to_node (genapic->apicid_to_node)
 #define cpu_to_logical_apicid (genapic->cpu_to_logical_apicid) 
diff -puN include/asm-i386/mach-numaq/mach_apic.h~genapic-default-to-physical-mode-on-hotplug-cpu-kernels include/asm-i386/mach-numaq/mach_apic.h
--- a/include/asm-i386/mach-numaq/mach_apic.h~genapic-default-to-physical-mode-on-hotplug-cpu-kernels
+++ a/include/asm-i386/mach-numaq/mach_apic.h
@@ -34,7 +34,7 @@ static inline void init_apic_ldr(void)
 	/* Already done in NUMA-Q firmware */
 }
 
-static inline void clustered_apic_check(void)
+static inline void setup_apic_routing(void)
 {
 	printk("Enabling APIC mode:  %s.  Using %d I/O APICs\n",
 		"NUMA-Q", nr_ioapics);
diff -puN include/asm-i386/mach-summit/mach_apic.h~genapic-default-to-physical-mode-on-hotplug-cpu-kernels include/asm-i386/mach-summit/mach_apic.h
--- a/include/asm-i386/mach-summit/mach_apic.h~genapic-default-to-physical-mode-on-hotplug-cpu-kernels
+++ a/include/asm-i386/mach-summit/mach_apic.h
@@ -80,7 +80,7 @@ static inline int apic_id_registered(voi
 	return 1;
 }
 
-static inline void clustered_apic_check(void)
+static inline void setup_apic_routing(void)
 {
 	printk("Enabling APIC mode:  Summit.  Using %d I/O APICs\n",
 						nr_ioapics);
diff -puN include/asm-i386/mach-visws/mach_apic.h~genapic-default-to-physical-mode-on-hotplug-cpu-kernels include/asm-i386/mach-visws/mach_apic.h
--- a/include/asm-i386/mach-visws/mach_apic.h~genapic-default-to-physical-mode-on-hotplug-cpu-kernels
+++ a/include/asm-i386/mach-visws/mach_apic.h
@@ -47,7 +47,7 @@ static inline void summit_check(char *oe
 {
 }
 
-static inline void clustered_apic_check(void)
+static inline void setup_apic_routing(void)
 {
 }
 
diff -puN include/asm-x86_64/apic.h~genapic-default-to-physical-mode-on-hotplug-cpu-kernels include/asm-x86_64/apic.h
--- a/include/asm-x86_64/apic.h~genapic-default-to-physical-mode-on-hotplug-cpu-kernels
+++ a/include/asm-x86_64/apic.h
@@ -83,7 +83,7 @@ extern void setup_secondary_APIC_clock (
 extern int APIC_init_uniprocessor (void);
 extern void disable_APIC_timer(void);
 extern void enable_APIC_timer(void);
-extern void clustered_apic_check(void);
+extern void setup_apic_routing(void);
 
 extern void setup_APIC_extened_lvt(unsigned char lvt_off, unsigned char vector,
 				   unsigned char msg_type, unsigned char mask);
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
