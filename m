From: akpm@linux-foundation.org
Subject: - x86_64-irq-handle-irqs-pending-in-irr-during-irq-migration.patch removed from -mm tree
Date: Sat, 17 Feb 2007 18:15:36 -0800
Message-ID: <200702180215.l1I2Facc008408@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55765 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993148AbXBRCQ5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 21:16:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, ak@suse.de, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     x86_64 irq: handle irqs pending in IRR during irq migration
has been removed from the -mm tree.  Its filename was
     x86_64-irq-handle-irqs-pending-in-irr-during-irq-migration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64 irq: handle irqs pending in IRR during irq migration
From: Eric W. Biederman <ebiederm@xmission.com>

When making the interrupt vectors per cpu I failed to handle a case during
irq migration.  If the same interrupt comes in while we are servicing the
irq but before we migrate it the pending bit in the local apic IRR register
will be set for that irq.

After migrating the irq to another cpu and or vector the data structures
will no longer be setup to handle this pending irq.  Then as soon as we
return from servicing the irq we just migrated we will get a nasty: "No irq
handler for vector" message.

Since we do not disable irqs for edge triggered interrupts except in the
smallest possible window during migration I cannot avoid migrating an irq
in the unlikely event that it becomes pending.  This is because by the time
the irq could no longer become pending I have already updated all of my
data structures.

Therefore this patch introduces an intermediate state that exists soley on
the cpu where we are handling the irq during migration.  The irq number is
changed to negative in the vector_irq data structure.

Once the migration operation is complete we know we will receive no more
interrupts on this vector so the irq pending state for this irq will no
longer be updated.  If the irq is not pending and we are in the
intermediate state we immediately free the vector, otherwise in we free the
vector in do_IRQ when the pending irq arrives.



It's a really rare set of circumstances that trigger it, but the possibility
of being hit is pretty widespread, anything with more than one cpu, and more
then one irq could see this.

The easiest way to trigger this is to have two level triggered irqs on two
different cpus using the same vector.  In that case if one acks it's irq while
the other irq is migrating to a different cpu 2.6.19 get completely confused
and stop handling interrupts properly.

With my previous bug fix (not to drop the ack when we are confused) the
machine will stay up, and that is obviously correct and can't affect anything
else so is probably a candidate for the stable tree.

With this fix everything just works.

I don't know how often a legitimate case of the exact same irq going off twice
in a row is, but that is a possibility as well especially with edge triggered
interrupts.

Setting up the test scenario was a pain, but by extremely limiting my choice
of vectors I was able to confirm I survived several hundred


Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Andi Kleen <ak@suse.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/io_apic.c |   56 ++++++++++++++++++++++++++++++---
 arch/x86_64/kernel/irq.c     |   19 ++++++++++-
 2 files changed, 69 insertions(+), 6 deletions(-)

diff -puN arch/x86_64/kernel/io_apic.c~x86_64-irq-handle-irqs-pending-in-irr-during-irq-migration arch/x86_64/kernel/io_apic.c
--- a/arch/x86_64/kernel/io_apic.c~x86_64-irq-handle-irqs-pending-in-irr-during-irq-migration
+++ a/arch/x86_64/kernel/io_apic.c
@@ -730,9 +730,17 @@ next:
 		/* Found one! */
 		current_vector = vector;
 		current_offset = offset;
-		for_each_cpu_mask(old_cpu, old_mask)
-			per_cpu(vector_irq, old_cpu)[old_vector] = -1;
-		for_each_cpu_mask(new_cpu, new_mask)
+		for_each_cpu_mask(old_cpu, old_mask) {
+			int free = -1;
+			/* When migrating we need to preserve the old
+			 * vector until we have processed all of the
+			 * pending irqs.
+			 */
+			if (old_cpu == smp_processor_id())
+				free = -irq;
+			per_cpu(vector_irq, old_cpu)[old_vector] = free;
+		}
+ 		for_each_cpu_mask(new_cpu, new_mask)
 			per_cpu(vector_irq, new_cpu)[vector] = irq;
 		irq_vector[irq] = vector;
 		irq_domain[irq] = domain;
@@ -1385,6 +1393,37 @@ static int ioapic_retrigger_irq(unsigned
 	return 1;
 }
 
+static unsigned apic_in_service_vector(void)
+{
+	unsigned isr, vector;
+	/* Figure out which vector we are servicing */
+	for (vector = FIRST_EXTERNAL_VECTOR; vector < FIRST_SYSTEM_VECTOR; vector += 32) {
+		isr = apic_read(APIC_ISR + ((vector/32) * 0x10));
+		if (isr)
+			break;
+	}
+	/* Find the low bits of the vector we are servicing */
+	vector += __ffs(isr);
+	return vector;
+}
+
+static void apic_handle_pending_vector(unsigned vector)
+{
+	unsigned irr;
+	int irq;
+
+	irq = __get_cpu_var(vector_irq)[vector];
+	if (irq >= 0)
+		return;
+
+	/* If the irq we are servicing has moved and is not pending
+	 * free it's vector.
+	 */
+	irr = apic_read(APIC_IRR + ((vector/32) * 0x10));
+	if (!(irr & (1 << (vector % 32))))
+		__get_cpu_var(vector_irq)[vector] = -1;
+}
+
 /*
  * Level and edge triggered IO-APIC interrupts need different handling,
  * so we use two separate IRQ descriptors. Edge triggered IRQs can be
@@ -1396,19 +1435,24 @@ static int ioapic_retrigger_irq(unsigned
 
 static void ack_apic_edge(unsigned int irq)
 {
-	move_native_irq(irq);
+	if (unlikely(irq_desc[irq].status & IRQ_MOVE_PENDING)) {
+		move_native_irq(irq);
+		apic_handle_pending_vector(apic_in_service_vector());
+	}
 	ack_APIC_irq();
 }
 
 static void ack_apic_level(unsigned int irq)
 {
 	int do_unmask_irq = 0;
+	unsigned int vector = 0;
 
 #if defined(CONFIG_GENERIC_PENDING_IRQ) || defined(CONFIG_IRQBALANCE)
 	/* If we are moving the irq we need to mask it */
 	if (unlikely(irq_desc[irq].status & IRQ_MOVE_PENDING)) {
 		do_unmask_irq = 1;
 		mask_IO_APIC_irq(irq);
+		vector = apic_in_service_vector();
 	}
 #endif
 
@@ -1420,8 +1464,10 @@ static void ack_apic_level(unsigned int 
 
 	/* Now we can move and renable the irq */
 	move_masked_irq(irq);
-	if (unlikely(do_unmask_irq))
+	if (unlikely(do_unmask_irq)) {
+		apic_handle_pending_vector(vector);
 		unmask_IO_APIC_irq(irq);
+	}
 }
 
 static struct irq_chip ioapic_chip __read_mostly = {
diff -puN arch/x86_64/kernel/irq.c~x86_64-irq-handle-irqs-pending-in-irr-during-irq-migration arch/x86_64/kernel/irq.c
--- a/arch/x86_64/kernel/irq.c~x86_64-irq-handle-irqs-pending-in-irr-during-irq-migration
+++ a/arch/x86_64/kernel/irq.c
@@ -98,6 +98,23 @@ skip:
 	return 0;
 }
 
+static inline unsigned int irq_from_vector(unsigned int vector)
+{
+	int irq;
+	irq = __get_cpu_var(vector_irq)[vector];
+
+	/* If we changed vectors during migration and we had a pending
+	 * irq, we left the irq allocated on this cpu.  Now that the
+	 * pending irq has arrived get the irq number and free this
+	 * vector.
+	 */
+	if (irq < -1) {
+		__get_cpu_var(vector_irq)[vector] = -1;
+		irq = -irq;
+	}
+	return irq;
+}
+
 /*
  * do_IRQ handles all normal device IRQ's (the special
  * SMP cross-CPU interrupts have their own specific
@@ -113,7 +130,7 @@ asmlinkage unsigned int do_IRQ(struct pt
 
 	exit_idle();
 	irq_enter();
-	irq = __get_cpu_var(vector_irq)[vector];
+	irq = irq_from_vector(vector);
 
 #ifdef CONFIG_DEBUG_STACKOVERFLOW
 	stack_overflow_check(regs);
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
powerpc-rtas-msi-support.patch
fix-i-oat-for-kexec.patch
git-v9fs.patch
i386-irq-kill-irq-compression.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
fix-rmmod-read-write-races-in-proc-entries.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
allow-access-to-proc-pid-fd-after-setuid.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
allow-access-to-proc-pid-fd-after-setuid-update.patch
allow-access-to-proc-pid-fd-after-setuid-update-2.patch
shm-make-sysv-ipc-shared-memory-use-stacked-files.patch
shm-make-sysv-ipc-shared-memory-use-stacked-files-real-fix.patch
edac-k8-driver-coding-tidy.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
sysctl-remove-insert_at_head-from-register_sysctl-fix.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
