From: akpm@osdl.org
Subject: + genirq-do-not-mask-interrupts-by-default.patch added to -mm tree
Date: Tue, 30 Jan 2007 16:20:18 -0800
Message-ID: <200701310020.l0V0KIc4002059@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58299 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072AbXAaAUp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 19:20:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de


The patch titled
     genirq: do not mask interrupts by default
has been added to the -mm tree.  Its filename is
     genirq-do-not-mask-interrupts-by-default.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: genirq: do not mask interrupts by default
From: Ingo Molnar <mingo@elte.hu>

Never mask interrupts immediately upon request.  Disabling interrupts in
high-performance codepaths is rare, and on the other hand this change could
recover lost edges (or even other types of lost interrupts) by conservatively
only masking interrupts after they happen.  (NOTE: with this change the
highlevel irq-disable code still soft-disables this IRQ line - and if such an
interrupt happens then the IRQ flow handler keeps the IRQ masked.)

Mark i8529A controllers as 'never loses an edge'.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/i8259.c   |    1 +
 arch/x86_64/kernel/i8259.c |    1 +
 kernel/irq/chip.c          |   17 ++++++++++-------
 3 files changed, 12 insertions(+), 7 deletions(-)

diff -puN arch/i386/kernel/i8259.c~genirq-do-not-mask-interrupts-by-default arch/i386/kernel/i8259.c
--- a/arch/i386/kernel/i8259.c~genirq-do-not-mask-interrupts-by-default
+++ a/arch/i386/kernel/i8259.c
@@ -41,6 +41,7 @@ static void mask_and_ack_8259A(unsigned 
 static struct irq_chip i8259A_chip = {
 	.name		= "XT-PIC",
 	.mask		= disable_8259A_irq,
+	.disable	= disable_8259A_irq,
 	.unmask		= enable_8259A_irq,
 	.mask_ack	= mask_and_ack_8259A,
 };
diff -puN arch/x86_64/kernel/i8259.c~genirq-do-not-mask-interrupts-by-default arch/x86_64/kernel/i8259.c
--- a/arch/x86_64/kernel/i8259.c~genirq-do-not-mask-interrupts-by-default
+++ a/arch/x86_64/kernel/i8259.c
@@ -103,6 +103,7 @@ static void mask_and_ack_8259A(unsigned 
 static struct irq_chip i8259A_chip = {
 	.name		= "XT-PIC",
 	.mask		= disable_8259A_irq,
+	.disable	= disable_8259A_irq,
 	.unmask		= enable_8259A_irq,
 	.mask_ack	= mask_and_ack_8259A,
 };
diff -puN kernel/irq/chip.c~genirq-do-not-mask-interrupts-by-default kernel/irq/chip.c
--- a/kernel/irq/chip.c~genirq-do-not-mask-interrupts-by-default
+++ a/kernel/irq/chip.c
@@ -202,10 +202,6 @@ static void default_enable(unsigned int 
  */
 static void default_disable(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc + irq;
-
-	if (!(desc->status & IRQ_DELAYED_DISABLE))
-		desc->chip->mask(irq);
 }
 
 /*
@@ -270,13 +266,18 @@ handle_simple_irq(unsigned int irq, stru
 
 	if (unlikely(desc->status & IRQ_INPROGRESS))
 		goto out_unlock;
-	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
 	kstat_cpu(cpu).irqs[irq]++;
 
 	action = desc->action;
-	if (unlikely(!action || (desc->status & IRQ_DISABLED)))
+	if (unlikely(!action || (desc->status & IRQ_DISABLED))) {
+		if (desc->chip->mask)
+			desc->chip->mask(irq);
+		desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
+		desc->status |= IRQ_PENDING;
 		goto out_unlock;
+	}
 
+	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING | IRQ_PENDING);
 	desc->status |= IRQ_INPROGRESS;
 	spin_unlock(&desc->lock);
 
@@ -368,11 +369,13 @@ handle_fasteoi_irq(unsigned int irq, str
 
 	/*
 	 * If its disabled or no action available
-	 * keep it masked and get out of here
+	 * then mask it and get out of here:
 	 */
 	action = desc->action;
 	if (unlikely(!action || (desc->status & IRQ_DISABLED))) {
 		desc->status |= IRQ_PENDING;
+		if (desc->chip->mask)
+			desc->chip->mask(irq);
 		goto out;
 	}
 
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
