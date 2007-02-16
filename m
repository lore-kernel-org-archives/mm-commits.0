From: akpm@linux-foundation.org
Subject: - acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi.patch removed from -mm tree
Date: Fri, 16 Feb 2007 00:02:43 -0800
Message-ID: <200702160802.l1G82hn7023955@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58832 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423408AbXBPIEM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 03:04:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, ak@suse.de, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     ACPI, i686, x86_64: fix laptop bootup hang in init_acpi()
has been removed from the -mm tree.  Its filename was
     acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/nmi.c          |   28 ++++++++++++++++++++++++++++
 arch/x86_64/kernel/nmi.c        |   27 +++++++++++++++++++++++++++
 drivers/acpi/namespace/nsinit.c |    9 +++++++++
 include/linux/nmi.h             |    9 ++++++++-
 4 files changed, 72 insertions(+), 1 deletion(-)

diff -puN arch/i386/kernel/nmi.c~acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi arch/i386/kernel/nmi.c
--- a/arch/i386/kernel/nmi.c~acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi
+++ a/arch/i386/kernel/nmi.c
@@ -369,6 +369,34 @@ void enable_timer_nmi_watchdog(void)
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
@@ -360,6 +360,33 @@ void enable_timer_nmi_watchdog(void)
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
@@ -534,7 +535,15 @@ acpi_ns_init_one_device(acpi_handle obj_
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
git-acpi.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch.patch
spin_lock_irq-enable-interrupts-while-spinning-x86_64-implementation.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
simplify-the-stacktrace-code.patch
lockdep-debug_locks-check-after-check_chain_key.patch
add-irq-flag-to-disable-balancing-for-an-interrupt.patch
add-a-functions-to-handle-interrupt-affinity-setting.patch
add-a-functions-to-handle-interrupt-affinity-setting-alpha-fix.patch
hz-free-ntp.patch
uninline-jiffiesh-functions.patch
fix-multiple-conversion-bugs-in-msecs_to_jiffies.patch
fix-timeout-overflow-with-jiffies.patch
gtod-persistent-clock-support.patch
i386-use-gtod-persistent-clock-support.patch
i386-remove-useless-code-in-tscc.patch
simplify-the-registration-of-clocksources.patch
x86-rewrite-smp-tsc-sync-code.patch
clocksource-replace-is_continuous-by-a-flag-field.patch
clocksource-replace-is_continuous-by-a-flag-field-fix.patch
clocksource-fixup-is_continous-changes-on-arm.patch
clocksource-fixup-is_continous-changes-on-avr32.patch
clocksource-fixup-is_continous-changes-on-s390.patch
clocksource-fixup-is_continous-changes-on-mips.patch
clocksource-remove-the-update-callback.patch
clocksource-add-verification-watchdog-helper.patch
mark-tsc-on-geodelx-reliable.patch
uninline-irq_enter.patch
fix-cascade-lookup-of-next_timer_interrupt.patch
extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-namespace-and-enum-cleanup-vs-git-input.patch
hrtimers-cleanup-locking.patch
hrtimers-add-state-tracking.patch
hrtimers-clean-up-callback-tracking.patch
hrtimers-move-and-add-documentation.patch
acpi-fix-missing-include-for-up.patch
acpi-keep-track-of-timer-broadcasting.patch
allow-early-access-to-the-power-management-timer.patch
i386-apic-clean-up-the-apic-code.patch
clockevents-add-core-functionality.patch
tick-management-core-functionality.patch
tick-management-broadcast-functionality.patch
tick-management-dyntick--highres-functionality.patch
clockevents-i383-drivers.patch
i386-rework-local-apic-timer-calibration.patch
i386-prepare-for-dyntick.patch
i386-prepare-nmi-watchdog-for-dynticks.patch
i386-enable-dynticks-in-kconfig.patch
hrtimers-add-high-resolution-timer-support.patch
hrtimers-prevent-possible-itimer-dos.patch
add-debugging-feature-proc-timer_stat.patch
add-debugging-feature-proc-timer_stat-cleanup.patch
add-debugging-feature-proc-timer_list.patch
add-sysrq-q-to-print-timer_list-debug-info.patch
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
time-x86_64-hpet-fixup-clocksource-changes.patch
time-x86_64-tsc-fixup-clocksource-changes.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
posix-timers-rcu-optimization-for-clock_gettime.patch
posix-timers-rcu-optimization-for-clock_gettime-fix.patch
genirq-do-not-mask-interrupts-by-default.patch
genirq-remove-irq_disabled.patch
small-irq-management-simplification.patch
schedule_on_each_cpu-use-preempt_disable.patch
workqueue-kill-run_scheduled_work.patch
workqueue-dont-save-interrupts-in-run_workqueue.patch
workqueue-make-cancel_rearming_delayed_workqueue-work-on-idle-dwork.patch
workqueue-introduce-cpu_singlethread_map.patch
workqueue-introduce-workqueue_struct-singlethread.patch
workqueue-make-init_workqueues-__init.patch
fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine.patch
fsaio-rename-__lock_page-to-lock_page_blocking.patch
fsaio-interfaces-to-initialize-and-to-test-a-wait-bit-key.patch
fsaio-add-a-default-io-wait-bit-field-in-task-struct.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio.patch
fsaio-enable-asynchronous-wait-page-and-lock-page.patch
fsaio-filesystem-aio-read.patch
fsaio-aio-o_sync-filesystem-write.patch
aio-is-unlikely.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
sched-cleanup-remove-task_t-convert-to-struct-task_struct-prefetch.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-3.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
vdso-print-fatal-signals.patch
vdso-improve-print_fatal_signals-support-by-adding-memory-maps.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
lockdep-show-held-locks-when-showing-a-stackdump-fix.patch
lockdep-show-held-locks-when-showing-a-stackdump-fix-2.patch
kmap_atomic-debugging.patch
