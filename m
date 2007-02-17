From: akpm@linux-foundation.org
Subject: - genirq-remove-irq_disabled.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:15:49 -0800
Message-ID: <200702170715.l1H7FnvO021666@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51077 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946436AbXBQHQE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:16:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     genirq: remove IRQ_DISABLED
has been removed from the -mm tree.  Its filename was
     genirq-remove-irq_disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: genirq: remove IRQ_DISABLED
From: Ingo Molnar <mingo@elte.hu>

Now that disable_irq() defaults to delayed-disable semantics, the IRQ_DISABLED
flag is not needed anymore.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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
git-acpi.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch.patch
spin_lock_irq-enable-interrupts-while-spinning-x86_64-implementation.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
simplify-the-stacktrace-code.patch
lockdep-debug_locks-check-after-check_chain_key.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
softlockup-trivial-s-99-max_rt_prio.patch
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
