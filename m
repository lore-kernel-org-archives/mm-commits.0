From: akpm@osdl.org
Subject: + genirq-remove-irq_disabled.patch added to -mm tree
Date: Tue, 30 Jan 2007 16:20:20 -0800
Message-ID: <200701310020.l0V0KKwI002062@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58298 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbXAaAUn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 19:20:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de


The patch titled
     genirq: remove IRQ_DISABLED
has been added to the -mm tree.  Its filename is
     genirq-remove-irq_disabled.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: genirq: remove IRQ_DISABLED
From: Ingo Molnar <mingo@elte.hu>

Now that disable_irq() defaults to delayed-disable semantics, the IRQ_DISABLED
flag is not needed anymore.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/arm/kernel/irq.c                 |    3 +--
 arch/i386/kernel/io_apic.c            |    4 +---
 arch/powerpc/platforms/powermac/pic.c |    2 --
 arch/x86_64/kernel/io_apic.c          |    4 +---
 include/linux/irq.h                   |    7 +++----
 5 files changed, 6 insertions(+), 14 deletions(-)

diff -puN arch/arm/kernel/irq.c~genirq-remove-irq_disabled arch/arm/kernel/irq.c
--- a/arch/arm/kernel/irq.c~genirq-remove-irq_disabled
+++ a/arch/arm/kernel/irq.c
@@ -159,8 +159,7 @@ void __init init_IRQ(void)
 	int irq;
 
 	for (irq = 0; irq < NR_IRQS; irq++)
-		irq_desc[irq].status |= IRQ_NOREQUEST | IRQ_DELAYED_DISABLE |
-			IRQ_NOPROBE;
+		irq_desc[irq].status |= IRQ_NOREQUEST | IRQ_NOPROBE;
 
 #ifdef CONFIG_SMP
 	bad_irq_desc.affinity = CPU_MASK_ALL;
diff -puN arch/i386/kernel/io_apic.c~genirq-remove-irq_disabled arch/i386/kernel/io_apic.c
--- a/arch/i386/kernel/io_apic.c~genirq-remove-irq_disabled
+++ a/arch/i386/kernel/io_apic.c
@@ -1281,11 +1281,9 @@ static void ioapic_register_intr(int irq
 			trigger == IOAPIC_LEVEL)
 		set_irq_chip_and_handler_name(irq, &ioapic_chip,
 					 handle_fasteoi_irq, "fasteoi");
-	else {
-		irq_desc[irq].status |= IRQ_DELAYED_DISABLE;
+	else
 		set_irq_chip_and_handler_name(irq, &ioapic_chip,
 					 handle_edge_irq, "edge");
-	}
 	set_intr_gate(vector, interrupt[irq]);
 }
 
diff -puN arch/powerpc/platforms/powermac/pic.c~genirq-remove-irq_disabled arch/powerpc/platforms/powermac/pic.c
--- a/arch/powerpc/platforms/powermac/pic.c~genirq-remove-irq_disabled
+++ a/arch/powerpc/platforms/powermac/pic.c
@@ -305,8 +305,6 @@ static int pmac_pic_host_map(struct irq_
 	level = !!(level_mask[hw >> 5] & (1UL << (hw & 0x1f)));
 	if (level)
 		desc->status |= IRQ_LEVEL;
-	else
-		desc->status |= IRQ_DELAYED_DISABLE;
 	set_irq_chip_and_handler(virq, &pmac_pic, level ?
 				 handle_level_irq : handle_edge_irq);
 	return 0;
diff -puN arch/x86_64/kernel/io_apic.c~genirq-remove-irq_disabled arch/x86_64/kernel/io_apic.c
--- a/arch/x86_64/kernel/io_apic.c~genirq-remove-irq_disabled
+++ a/arch/x86_64/kernel/io_apic.c
@@ -810,11 +810,9 @@ static void ioapic_register_intr(int irq
 			trigger == IOAPIC_LEVEL)
 		set_irq_chip_and_handler_name(irq, &ioapic_chip,
 					      handle_fasteoi_irq, "fasteoi");
-	else {
-		irq_desc[irq].status |= IRQ_DELAYED_DISABLE;
+	else
 		set_irq_chip_and_handler_name(irq, &ioapic_chip,
 					      handle_edge_irq, "edge");
-	}
 }
 static void __init setup_IO_APIC_irq(int apic, int pin, int idx, int irq)
 {
diff -puN include/linux/irq.h~genirq-remove-irq_disabled include/linux/irq.h
--- a/include/linux/irq.h~genirq-remove-irq_disabled
+++ a/include/linux/irq.h
@@ -57,10 +57,9 @@ typedef	void fastcall (*irq_flow_handler
 #define IRQ_NOPROBE		0x00020000	/* IRQ is not valid for probing */
 #define IRQ_NOREQUEST		0x00040000	/* IRQ cannot be requested */
 #define IRQ_NOAUTOEN		0x00080000	/* IRQ will not be enabled on request irq */
-#define IRQ_DELAYED_DISABLE	0x00100000	/* IRQ disable (masking) happens delayed. */
-#define IRQ_WAKEUP		0x00200000	/* IRQ triggers system wakeup */
-#define IRQ_MOVE_PENDING	0x00400000	/* need to re-target IRQ destination */
-#define IRQ_NO_BALANCING	0x00800000	/* IRQ is excluded from balancing */
+#define IRQ_WAKEUP		0x00100000	/* IRQ triggers system wakeup */
+#define IRQ_MOVE_PENDING	0x00200000	/* need to re-target IRQ destination */
+#define IRQ_NO_BALANCING	0x00400000	/* IRQ is excluded from balancing */
 
 #ifdef CONFIG_IRQ_PER_CPU
 # define CHECK_IRQ_PER_CPU(var) ((var) & IRQ_PER_CPU)
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
add-install_special_mapping.patch
i386-vdso-use-install_special_mapping.patch
x86_64-ia32-vdso-use-install_special_mapping.patch
powerpc-vdso-use-install_special_mapping.patch
use-correct-macros-in-raid-code-not-raw-asm.patch
use-correct-macros-in-raid-code-not-raw-asm-include.patch
acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi.patch
fix-for-crash-in-adummy_init.patch
bugfixes-pci-devices-get-assigned-redundant-irqs.patch
fix-x86_64-mm-convert-i386-pda-code-to-use-%fs.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch.patch
spin_lock_irq-enable-interrupts-while-spinning-x86_64-implementation.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation-fix.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation-fix-fix.patch
i386-kwatch-kernel-watchpoints-using-cpu-debug-registers.patch
i386-kwatch-kernel-watchpoints-using-cpu-debug-registers-fix.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
lockdep-also-check-for-freed-locks-in-kmem_cache_free.patch
lockdep-more-unlock-on-error-fixes.patch
lockdep-more-unlock-on-error-fixes-fix.patch
lockdep-add-graph-depth-information-to-proc-lockdep.patch
consolidate-default-sched_clock.patch
use-cycle_t-instead-of-u64-in-struct-time_interpolator.patch
proc-remove-useless-and-buggy-nlink-settings.patch
simplify-the-stacktrace-code.patch
audit-fix-audit_filter_user_rules-initialization-bug.patch
remove-references-to-obsolete-kernel-config-option-debug_rwsems.patch
order-of-lockdep-off-on-in-vprintk-should-be-changed.patch
minimize-lockdep_on-off-side-effect.patch
fix-apparent-typo-config_lockdep_debug.patch
highmem-catch-illegal-nesting.patch
fix-sparse-annotation-of-spin-unlock-macros-in-one-case.patch
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
genirq-do-not-mask-interrupts-by-default.patch
genirq-remove-irq_disabled.patch
schedule_on_each_cpu-use-preempt_disable.patch
fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine.patch
fsaio-rename-__lock_page-to-lock_page_blocking.patch
fsaio-interfaces-to-initialize-and-to-test-a-wait-bit-key.patch
fsaio-add-a-default-io-wait-bit-field-in-task-struct.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio.patch
fsaio-enable-asynchronous-wait-page-and-lock-page.patch
fsaio-filesystem-aio-read.patch
fsaio-aio-o_sync-filesystem-write.patch
aio-is-unlikely.patch
sched-avoid-div-in-rebalance_tick.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
sched-cleanup-remove-task_t-convert-to-struct-task_struct-prefetch.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2.patch
scheduled-removal-of-sa_xxx-interrupt-flags.patch
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
