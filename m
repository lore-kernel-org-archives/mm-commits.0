From: akpm@linux-foundation.org
Subject: - genirq-do-not-mask-interrupts-by-default.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:15:47 -0800
Message-ID: <200702170715.l1H7FlTt021662@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51065 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946473AbXBQHP4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:15:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     genirq: do not mask interrupts by default
has been removed from the -mm tree.  Its filename was
     genirq-do-not-mask-interrupts-by-default.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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
@@ -230,10 +230,6 @@ static void default_enable(unsigned int 
  */
 static void default_disable(unsigned int irq)
 {
-	struct irq_desc *desc = irq_desc + irq;
-
-	if (!(desc->status & IRQ_DELAYED_DISABLE))
-		desc->chip->mask(irq);
 }
 
 /*
@@ -298,13 +294,18 @@ handle_simple_irq(unsigned int irq, stru
 
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
 
@@ -396,11 +397,13 @@ handle_fasteoi_irq(unsigned int irq, str
 
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
