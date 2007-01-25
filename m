From: akpm@osdl.org
Subject: + add-a-functions-to-handle-interrupt-affinity-setting.patch added to -mm tree
Date: Wed, 24 Jan 2007 22:35:39 -0800
Message-ID: <200701250635.l0P6ZdGM008259@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50429 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965573AbXAYGhy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 01:37:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, johnstul@us.ibm.com, mingo@elte.hu, zippel@linux-m68k.org


The patch titled
     Add a functions to handle interrupt affinity setting
has been added to the -mm tree.  Its filename is
     add-a-functions-to-handle-interrupt-affinity-setting.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add a functions to handle interrupt affinity setting
From: Thomas Gleixner <tglx@linutronix.de>

Provide funtions to:
 - check, whether an interrupt can set the affinity
 - pin the interrupt to a given cpu

Necessary for the ability to setup clocksources more flexible (e.g.  use the
different HPET channels per CPU)

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/irq.h |   20 +++++++++++++++-----
 kernel/irq/manage.c |   40 ++++++++++++++++++++++++++++++++++++++++
 kernel/irq/proc.c   |   22 +---------------------
 3 files changed, 56 insertions(+), 26 deletions(-)

diff -puN include/linux/irq.h~add-a-functions-to-handle-interrupt-affinity-setting include/linux/irq.h
--- a/include/linux/irq.h~add-a-functions-to-handle-interrupt-affinity-setting
+++ a/include/linux/irq.h
@@ -70,11 +70,6 @@ typedef	void fastcall (*irq_flow_handler
 # define IRQ_NO_BALANCING_MASK	IRQ_NO_BALANCING
 #endif
 
-static inline int irq_balancing_disabled(unsigned int irq)
-{
-	return irq_desc[irq].status & IRQ_NO_BALANCING_MASK;
-}
-
 struct proc_dir_entry;
 
 /**
@@ -241,11 +236,21 @@ static inline void set_pending_irq(unsig
 
 #endif /* CONFIG_GENERIC_PENDING_IRQ */
 
+extern int irq_set_affinity(unsigned int irq, cpumask_t cpumask);
+extern int irq_can_set_affinity(unsigned int irq);
+
 #else /* CONFIG_SMP */
 
 #define move_native_irq(x)
 #define move_masked_irq(x)
 
+static inline int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
+{
+	return -EINVAL;
+}
+
+static inline int irq_can_set_affinity(unsigned int irq) { return 0; }
+
 #endif /* CONFIG_SMP */
 
 #ifdef CONFIG_IRQBALANCE
@@ -267,6 +272,11 @@ static inline int select_smp_affinity(un
 
 extern int no_irq_affinity;
 
+static inline int irq_balancing_disabled(unsigned int irq)
+{
+	return irq_desc[irq].status & IRQ_NO_BALANCING_MASK;
+}
+
 /* Handle irq action chains: */
 extern int handle_IRQ_event(unsigned int irq, struct irqaction *action);
 
diff -puN kernel/irq/manage.c~add-a-functions-to-handle-interrupt-affinity-setting kernel/irq/manage.c
--- a/kernel/irq/manage.c~add-a-functions-to-handle-interrupt-affinity-setting
+++ a/kernel/irq/manage.c
@@ -38,6 +38,46 @@ void synchronize_irq(unsigned int irq)
 }
 EXPORT_SYMBOL(synchronize_irq);
 
+/**
+ *	irq_can_set_affinity - Check if the affinity of a given irq can be set
+ *	@irq:		Interrupt to check
+ *
+ */
+int irq_can_set_affinity(unsigned int irq)
+{
+	struct irq_desc *desc = irq_desc + irq;
+
+	if (CHECK_IRQ_PER_CPU(desc->status) || !desc->chip ||
+	    !desc->chip->set_affinity)
+		return 0;
+
+	return 1;
+}
+
+/**
+ *	irq_set_affinity - Set the irq affinity of a given irq
+ *	@irq:		Interrupt to set affinity
+ *	@cpumask:	cpumask
+ *
+ */
+int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
+{
+	struct irq_desc *desc = irq_desc + irq;
+
+	if (!desc->chip->set_affinity)
+		return -EINVAL;
+
+	set_balance_irq_affinity(irq, cpumask);
+
+#ifdef CONFIG_GENERIC_PENDING_IRQ
+	set_pending_irq(irq, cpumask);
+#else
+	irq_desc[irq]->affinity = cpumask;
+	irq_desc[irq]->chip->set_affinity(irq, cpumask);
+#endif
+	return 0;
+}
+
 #endif
 
 /**
diff -puN kernel/irq/proc.c~add-a-functions-to-handle-interrupt-affinity-setting kernel/irq/proc.c
--- a/kernel/irq/proc.c~add-a-functions-to-handle-interrupt-affinity-setting
+++ a/kernel/irq/proc.c
@@ -16,26 +16,6 @@ static struct proc_dir_entry *root_irq_d
 
 #ifdef CONFIG_SMP
 
-#ifdef CONFIG_GENERIC_PENDING_IRQ
-void proc_set_irq_affinity(unsigned int irq, cpumask_t mask_val)
-{
-	set_balance_irq_affinity(irq, mask_val);
-
-	/*
-	 * Save these away for later use. Re-progam when the
-	 * interrupt is pending
-	 */
-	set_pending_irq(irq, mask_val);
-}
-#else
-void proc_set_irq_affinity(unsigned int irq, cpumask_t mask_val)
-{
-	set_balance_irq_affinity(irq, mask_val);
-	irq_desc[irq].affinity = mask_val;
-	irq_desc[irq].chip->set_affinity(irq, mask_val);
-}
-#endif
-
 static int irq_affinity_read_proc(char *page, char **start, off_t off,
 				  int count, int *eof, void *data)
 {
@@ -73,7 +53,7 @@ static int irq_affinity_write_proc(struc
 		   code to set default SMP affinity. */
 		return select_smp_affinity(irq) ? -EINVAL : full_count;
 
-	proc_set_irq_affinity(irq, new_value);
+	irq_set_affinity(irq, new_value);
 
 	return full_count;
 }
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-block.patch
use-cycle_t-instead-of-u64-in-struct-time_interpolator.patch
proc-remove-useless-and-buggy-nlink-settings.patch
add-irq-flag-to-disable-balancing-for-an-interrupt.patch
add-a-functions-to-handle-interrupt-affinity-setting.patch
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
clocksource-add-verification-watchdog-helper-fix.patch
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
time-x86_64-re-enable-vsyscall-support-for-x86_64.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
make-good_sigevent-non-static.patch
aio-completion-signal-notification.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2.patch
scheduled-removal-of-sa_xxx-interrupt-flags.patch
