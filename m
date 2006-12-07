From: akpm@osdl.org
Subject: + acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi.patch added to -mm tree
Date: Wed, 06 Dec 2006 21:32:07 -0800
Message-ID: <200612070532.kB75W7hK031544@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50546 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968816AbWLGFcu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 00:32:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, ak@suse.de, lenb@kernel.org


The patch titled
     ACPI, i686, x86_64: fix laptop bootup hang in init_acpi()
has been added to the -mm tree.  Its filename is
     acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ACPI, i686, x86_64: fix laptop bootup hang in init_acpi()
From: Ingo Molnar <mingo@elte.hu>

During kernel bootup, a new T60 laptop (CoreDuo, 32-bit) hangs about
10%-20% of the time in acpi_init():

 Calling initcall 0xc055ce1a: topology_init+0x0/0x2f()
 Calling initcall 0xc055d75e: mtrr_init_finialize+0x0/0x2c()
 Calling initcall 0xc05664f3: param_sysfs_init+0x0/0x175()
 Calling initcall 0xc014cb65: pm_sysrq_init+0x0/0x17()
 Calling initcall 0xc0569f99: init_bio+0x0/0xf4()
 Calling initcall 0xc056b865: genhd_device_init+0x0/0x50()
 Calling initcall 0xc056c4bd: fbmem_init+0x0/0x87()
 Calling initcall 0xc056dd74: acpi_init+0x0/0x1ee()

It's a hard hang that not even an NMI could punch through!  Frustratingly,
adding printks or function tracing to the ACPI code made the hangs go away
...

After some time an additional detail emerged: disabling the NMI watchdog
made these occasional hangs go away.

So i spent the better part of today trying to debug this and trying out
various theories when i finally found the likely reason for the hang: if
acpi_ns_initialize_devices() executes an _INI AML method and an NMI
happens to hit that AML execution in the wrong moment, the machine would
hang.  (my theory is that this must be some sort of chipset setup method
doing stores to chipset mmio registers?)

Unfortunately given the characteristics of the hang it was sheer
impossible to figure out which of the numerous AML methods is impacted
by this problem.

As a workaround i wrote an interface to disable chipset-based NMIs while
executing _INI sections - and indeed this fixed the hang.  I did a
boot-loop of 100 separate reboots and none hung - while without the patch
it would hang every 5-10 attempts.  Out of caution i did not touch the
nmi_watchdog=2 case (it's not related to the chipset anyway and didnt
hang).

I implemented this for both x86_64 and i686, tested the i686 laptop both
with nmi_watchdog=1 [which triggered the hangs] and nmi_watchdog=2, and
tested an Athlon64 box with the 64-bit kernel as well. Everything builds
and works with the patch applied.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/nmi.c          |   28 ++++++++++++++++++++++++++++
 arch/x86_64/kernel/nmi.c        |   27 +++++++++++++++++++++++++++
 drivers/acpi/namespace/nsinit.c |    9 +++++++++
 include/linux/nmi.h             |    9 ++++++++-
 4 files changed, 72 insertions(+), 1 deletion(-)

diff -puN arch/i386/kernel/nmi.c~acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi arch/i386/kernel/nmi.c
--- a/arch/i386/kernel/nmi.c~acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi
+++ a/arch/i386/kernel/nmi.c
@@ -375,6 +375,34 @@ void enable_timer_nmi_watchdog(void)
 	}
 }
 
+static void __acpi_nmi_disable(void *__unused)
+{
+	apic_write_around(APIC_LVT0, APIC_DM_NMI | APIC_LVT_MASKED);
+}
+
+/*
+ * Disable timer based NMIs on all CPUs:
+ */
+void acpi_nmi_disable(void)
+{
+	if (atomic_read(&nmi_active) && nmi_watchdog == NMI_IO_APIC)
+		on_each_cpu(__acpi_nmi_disable, NULL, 0, 1);
+}
+
+static void __acpi_nmi_enable(void *__unused)
+{
+	apic_write_around(APIC_LVT0, APIC_DM_NMI);
+}
+
+/*
+ * Enable timer based NMIs on all CPUs:
+ */
+void acpi_nmi_enable(void)
+{
+	if (atomic_read(&nmi_active) && nmi_watchdog == NMI_IO_APIC)
+		on_each_cpu(__acpi_nmi_enable, NULL, 0, 1);
+}
+
 #ifdef CONFIG_PM
 
 static int nmi_pm_active; /* nmi_active before suspend */
diff -puN arch/x86_64/kernel/nmi.c~acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi arch/x86_64/kernel/nmi.c
--- a/arch/x86_64/kernel/nmi.c~acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi
+++ a/arch/x86_64/kernel/nmi.c
@@ -362,6 +362,33 @@ void enable_timer_nmi_watchdog(void)
 	}
 }
 
+static void __acpi_nmi_disable(void *__unused)
+{
+	apic_write(APIC_LVT0, APIC_DM_NMI | APIC_LVT_MASKED);
+}
+
+/*
+ * Disable timer based NMIs on all CPUs:
+ */
+void acpi_nmi_disable(void)
+{
+	if (atomic_read(&nmi_active) && nmi_watchdog == NMI_IO_APIC)
+		on_each_cpu(__acpi_nmi_disable, NULL, 0, 1);
+}
+
+static void __acpi_nmi_enable(void *__unused)
+{
+	apic_write(APIC_LVT0, APIC_DM_NMI);
+}
+
+/*
+ * Enable timer based NMIs on all CPUs:
+ */
+void acpi_nmi_enable(void)
+{
+	if (atomic_read(&nmi_active) && nmi_watchdog == NMI_IO_APIC)
+		on_each_cpu(__acpi_nmi_enable, NULL, 0, 1);
+}
 #ifdef CONFIG_PM
 
 static int nmi_pm_active; /* nmi_active before suspend */
diff -puN drivers/acpi/namespace/nsinit.c~acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi drivers/acpi/namespace/nsinit.c
--- a/drivers/acpi/namespace/nsinit.c~acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi
+++ a/drivers/acpi/namespace/nsinit.c
@@ -45,6 +45,7 @@
 #include <acpi/acnamesp.h>
 #include <acpi/acdispat.h>
 #include <acpi/acinterp.h>
+#include <linux/nmi.h>
 
 #define _COMPONENT          ACPI_NAMESPACE
 ACPI_MODULE_NAME("nsinit")
@@ -537,7 +538,15 @@ acpi_ns_init_one_device(acpi_handle obj_
 	info->parameter_type = ACPI_PARAM_ARGS;
 	info->flags = ACPI_IGNORE_RETURN_VALUE;
 
+	/*
+	 * Some hardware relies on this being executed as atomically
+	 * as possible (without an NMI being received in the middle of
+	 * this) - so disable NMIs and initialize the device:
+	 */
+	acpi_nmi_disable();
 	status = acpi_ns_evaluate(info);
+	acpi_nmi_enable();
+
 	if (ACPI_SUCCESS(status)) {
 		walk_info->num_INI++;
 
diff -puN include/linux/nmi.h~acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi include/linux/nmi.h
--- a/include/linux/nmi.h~acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi
+++ a/include/linux/nmi.h
@@ -17,8 +17,15 @@
 #ifdef ARCH_HAS_NMI_WATCHDOG
 #include <asm/nmi.h>
 extern void touch_nmi_watchdog(void);
+extern void acpi_nmi_disable(void);
+extern void acpi_nmi_enable(void);
 #else
-# define touch_nmi_watchdog() touch_softlockup_watchdog()
+static inline void touch_nmi_watchdog(void)
+{
+	touch_softlockup_watchdog();
+}
+static inline void acpi_nmi_disable(void) { }
+static inline void acpi_nmi_enable(void) { }
 #endif
 
 #ifndef trigger_all_cpu_backtrace
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

