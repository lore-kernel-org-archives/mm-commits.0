From: akpm@osdl.org
Subject: - genirq-add-chip-eoi-fastack-fasteoi.patch removed from -mm tree
Date: Fri, 15 Dec 2006 13:02:25 -0800
Message-ID: <200612152102.kBFL2PD6029687@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:44468 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964933AbWLOVCd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Dec 2006 16:02:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, benh@kernel.crashing.org, rolandd@cisco.com, mm-commits@vger.kernel.org


The patch titled
     genirq: add chip->eoi(), fastack -> fasteoi
has been removed from the -mm tree.  Its filename was
     genirq-add-chip-eoi-fastack-fasteoi.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: genirq: add chip->eoi(), fastack -> fasteoi
From: Ingo Molnar <mingo@elte.hu>


Clean up the fastack concept by turning it into fasteoi and introducing the
->eoi() method for chips.

This also allows the cleanup of an i386 EOI quirk - now the quirk is
cleanly separated from the pure ACK implementation.

The patch also enables the fasteoi handler for i386 level-triggered IO-APIC
irqs.

Tested on i386 and x86_64 with MSI on and off as well.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/io_apic.c   |   28 +++++++++++++++++++---------
 arch/x86_64/kernel/io_apic.c |    9 +++++----
 include/linux/irq.h          |    6 ++++--
 kernel/irq/chip.c            |   25 ++++++++++++-------------
 4 files changed, 40 insertions(+), 28 deletions(-)

diff -puN arch/i386/kernel/io_apic.c~genirq-add-chip-eoi-fastack-fasteoi arch/i386/kernel/io_apic.c
--- a/arch/i386/kernel/io_apic.c~genirq-add-chip-eoi-fastack-fasteoi
+++ a/arch/i386/kernel/io_apic.c
@@ -1214,7 +1214,7 @@ static void ioapic_register_intr(int irq
 	if ((trigger == IOAPIC_AUTO && IO_APIC_irq_trigger(irq)) ||
 			trigger == IOAPIC_LEVEL)
 		set_irq_chip_and_handler(idx, &ioapic_chip,
-					 handle_level_irq);
+					 handle_fasteoi_irq);
 	else
 		set_irq_chip_and_handler(idx, &ioapic_chip,
 					 handle_edge_irq);
@@ -1946,6 +1946,12 @@ static unsigned int startup_ioapic_irq(u
 	return was_pending;
 }
 
+static void ack_ioapic_irq(unsigned int irq)
+{
+	move_irq(irq);
+	ack_APIC_irq();
+}
+
 static void ack_ioapic_quirk_irq(unsigned int irq)
 {
 	unsigned long v;
@@ -1971,11 +1977,6 @@ static void ack_ioapic_quirk_irq(unsigne
  * operation to prevent an edge-triggered interrupt escaping meanwhile.
  * The idea is from Manfred Spraul.  --macro
  */
-	if (irq_desc[irq].handle_irq == handle_edge_irq) {
-		ack_APIC_irq();
-		return;
-	}
-
 	i = IO_APIC_VECTOR(irq);
 
 	v = apic_read(APIC_TMR + ((i & ~0x1f) >> 1));
@@ -1998,6 +1999,14 @@ static unsigned int startup_ioapic_vecto
 	return startup_ioapic_irq(irq);
 }
 
+static void ack_ioapic_vector(unsigned int vector)
+{
+	int irq = vector_to_irq(vector);
+
+	move_native_irq(vector);
+	ack_ioapic_irq(irq);
+}
+
 static void ack_ioapic_quirk_vector(unsigned int vector)
 {
 	int irq = vector_to_irq(vector);
@@ -2050,7 +2059,8 @@ static struct irq_chip ioapic_chip __rea
 	.startup 	= startup_ioapic_vector,
 	.mask	 	= mask_IO_APIC_vector,
 	.unmask	 	= unmask_IO_APIC_vector,
-	.ack 		= ack_ioapic_quirk_vector,
+	.ack 		= ack_ioapic_vector,
+	.eoi 		= ack_ioapic_quirk_vector,
 #ifdef CONFIG_SMP
 	.set_affinity 	= set_ioapic_affinity,
 #endif
@@ -2124,7 +2134,7 @@ static struct irq_chip lapic_chip __read
 	.name		= "local-APIC-edge",
 	.mask		= mask_lapic_irq,
 	.unmask		= unmask_lapic_irq,
-	.ack		= ack_apic,
+	.eoi		= ack_apic,
 };
 
 static void setup_nmi (void)
@@ -2305,7 +2315,7 @@ static inline void check_timer(void)
 	printk(KERN_INFO "...trying to set up timer as Virtual Wire IRQ...");
 
 	disable_8259A_irq(0);
-	set_irq_chip_and_handler(0, &lapic_chip, handle_fastack_irq);
+	set_irq_chip_and_handler(0, &lapic_chip, handle_fasteoi_irq);
 	apic_write_around(APIC_LVT0, APIC_DM_FIXED | vector);	/* Fixed mode */
 	enable_8259A_irq(0);
 
diff -puN arch/x86_64/kernel/io_apic.c~genirq-add-chip-eoi-fastack-fasteoi arch/x86_64/kernel/io_apic.c
--- a/arch/x86_64/kernel/io_apic.c~genirq-add-chip-eoi-fastack-fasteoi
+++ a/arch/x86_64/kernel/io_apic.c
@@ -885,7 +885,7 @@ static void ioapic_register_intr(int irq
 	if ((trigger == IOAPIC_AUTO && IO_APIC_irq_trigger(irq)) ||
 			trigger == IOAPIC_LEVEL)
 		set_irq_chip_and_handler(idx, &ioapic_chip,
-					 handle_fastack_irq);
+					 handle_fasteoi_irq);
 	else
 		set_irq_chip_and_handler(idx, &ioapic_chip,
 					 handle_edge_irq);
@@ -990,7 +990,7 @@ static void __init setup_ExtINT_IRQ0_pin
 	 * The timer IRQ doesn't have to know that behind the
 	 * scene we have a 8259A-master in AEOI mode ...
 	 */
-	set_irq_chip_and_handler(0, &ioapic_chip, handle_fastack_irq);
+	set_irq_chip_and_handler(0, &ioapic_chip, handle_fasteoi_irq);
 
 	/*
 	 * Add it to the IO-APIC irq-routing table:
@@ -1583,6 +1583,7 @@ static struct irq_chip ioapic_chip __rea
 	.mask	 	= mask_ioapic_vector,
 	.unmask	 	= unmask_ioapic_vector,
 	.ack 		= ack_apic,
+	.eoi 		= ack_apic,
 #ifdef CONFIG_SMP
 	.set_affinity 	= set_ioapic_affinity_vector,
 #endif
@@ -1646,7 +1647,7 @@ static struct irq_chip lapic_chip __read
 	.name		= "local-APIC-edge",
 	.mask		= mask_lapic_irq,
 	.unmask		= unmask_lapic_irq,
-	.ack		= ack_apic,
+	.eoi		= ack_apic,
 };
 
 static void setup_nmi (void)
@@ -1828,7 +1829,7 @@ static inline void check_timer(void)
 	apic_printk(APIC_VERBOSE, KERN_INFO "...trying to set up timer as Virtual Wire IRQ...");
 
 	disable_8259A_irq(0);
-	set_irq_chip_and_handler(0, &lapic_chip, handle_fastack_irq);
+	set_irq_chip_and_handler(0, &lapic_chip, handle_fasteoi_irq);
 	apic_write(APIC_LVT0, APIC_DM_FIXED | vector);	/* Fixed mode */
 	enable_8259A_irq(0);
 
diff -puN include/linux/irq.h~genirq-add-chip-eoi-fastack-fasteoi include/linux/irq.h
--- a/include/linux/irq.h~genirq-add-chip-eoi-fastack-fasteoi
+++ a/include/linux/irq.h
@@ -73,7 +73,8 @@ struct proc_dir_entry;
  * @mask:		mask an interrupt source
  * @mask_ack:		ack and mask an interrupt source
  * @unmask:		unmask an interrupt source
- * @end:		end of interrupt
+ * @eoi:		end of interrupt - chip level
+ * @end:		end of interrupt - flow level
  * @set_affinity:	set the CPU affinity on SMP machines
  * @retrigger:		resend an IRQ to the CPU
  * @set_type:		set the flow type (IRQ_TYPE_LEVEL/etc.) of an IRQ
@@ -93,6 +94,7 @@ struct irq_chip {
 	void		(*mask)(unsigned int irq);
 	void		(*mask_ack)(unsigned int irq);
 	void		(*unmask)(unsigned int irq);
+	void		(*eoi)(unsigned int irq);
 
 	void		(*end)(unsigned int irq);
 	void		(*set_affinity)(unsigned int irq, cpumask_t dest);
@@ -287,7 +289,7 @@ extern int handle_IRQ_event(unsigned int
 extern void fastcall
 handle_level_irq(unsigned int irq, struct irq_desc *desc, struct pt_regs *regs);
 extern void fastcall
-handle_fastack_irq(unsigned int irq, struct irq_desc *desc,
+handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc,
 			 struct pt_regs *regs);
 extern void fastcall
 handle_edge_irq(unsigned int irq, struct irq_desc *desc, struct pt_regs *regs);
diff -puN kernel/irq/chip.c~genirq-add-chip-eoi-fastack-fasteoi kernel/irq/chip.c
--- a/kernel/irq/chip.c~genirq-add-chip-eoi-fastack-fasteoi
+++ a/kernel/irq/chip.c
@@ -280,18 +280,18 @@ out:
 }
 
 /**
- *	handle_fastack_irq - irq handler for transparent controllers
+ *	handle_fasteoi_irq - irq handler for transparent controllers
  *	@irq:	the interrupt number
  *	@desc:	the interrupt description structure for this irq
  *	@regs:	pointer to a register structure
  *
- *	Only a single callback will be issued to the chip: an ->ack()
+ *	Only a single callback will be issued to the chip: an ->eoi()
  *	call when the interrupt has been serviced. This enables support
  *	for modern forms of interrupt handlers, which handle the flow
  *	details in hardware, transparently.
  */
 void fastcall
-handle_fastack_irq(unsigned int irq, struct irq_desc *desc,
+handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc,
 		   struct pt_regs *regs)
 {
 	unsigned int cpu = smp_processor_id();
@@ -324,10 +324,9 @@ handle_fastack_irq(unsigned int irq, str
 	spin_lock(&desc->lock);
 	desc->status &= ~IRQ_INPROGRESS;
 out:
-	if (!(desc->status & IRQ_DISABLED))
-		desc->chip->ack(irq);
-	else
+	if (unlikely(desc->status & IRQ_DISABLED))
 		desc->chip->mask(irq);
+	desc->chip->eoi(irq);
 
 	spin_unlock(&desc->lock);
 }
@@ -507,19 +506,19 @@ handle_irq_name(void fastcall (*handle)(
 					struct pt_regs *))
 {
 	if (handle == handle_level_irq)
-		return "level ";
-	if (handle == handle_fastack_irq)
-		return "level ";
+		return "level  ";
+	if (handle == handle_fasteoi_irq)
+		return "fasteoi";
 	if (handle == handle_edge_irq)
-		return "edge  ";
+		return "edge   ";
 	if (handle == handle_simple_irq)
-		return "simple";
+		return "simple ";
 #ifdef CONFIG_SMP
 	if (handle == handle_percpu_irq)
-		return "percpu";
+		return "percpu ";
 #endif
 	if (handle == handle_bad_irq)
-		return "bad   ";
+		return "bad    ";
 
 	return NULL;
 }
_

Patches currently in -mm which might be from mingo@elte.hu are

conditionally-check-expected_preempt_count-in-__resched_legal.patch
sched-remove-__cpuinitdata-anotation-to-cpu_isolated_map.patch
genirq-fix-irq-flow-handler-uninstall.patch
acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi.patch
revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
convert-i386-pda-code-to-use-%fs.patch
convert-i386-pda-code-to-use-%fs-fixes.patch
genapic-optimize-fix-apic-mode-setup-2.patch
genapic-always-use-physical-delivery-mode-on-8-cpus.patch
genapic-remove-es7000-workaround.patch
genapic-remove-clustered-apic-mode.patch
genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
schedule_on_each_cpu-use-preempt_disable.patch
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
high-res-timers-allow-tsc-clocksource-if-pmtimer-present.patch
dynticks-core.patch
dynticks-add-nohz-stats-to-proc-stat.patch
dynticks-i386-support-idle-handler-callbacks.patch
dynticks-i386-prepare-nmi-watchdog.patch
high-res-timers-dynticks-i386-support-enable-in-kconfig.patch
debugging-feature-add-proc-timer_stat.patch
debugging-feature-proc-timer_list.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
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

