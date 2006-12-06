From: akpm@osdl.org
Subject: - x86_64-check-vector-in-setup_ioapic_dest-to-verify-if-need-setup_io_apic_irq.patch removed from -mm tree
Date: Wed, 06 Dec 2006 14:24:13 -0800
Message-ID: <200612062224.kB6MOD5n018598@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48695 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937751AbWLFW1w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 6 Dec 2006 17:27:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghai.lu@amd.com, ak@suse.de, ebiederm@xmission.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     x86_64: check vector in setup_ioapic_dest to verify if need setup_IO_APIC_irq
has been removed from the -mm tree.  Its filename was
     x86_64-check-vector-in-setup_ioapic_dest-to-verify-if-need-setup_io_apic_irq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: check vector in setup_ioapic_dest to verify if need setup_IO_APIC_irq
From: "Yinghai Lu" <yinghai.lu@amd.com>

setup_IO_APIC_irqs could fail to get vector for some device when you have too
many devices, because at that time only boot cpu is online.  So check vector
for irq in setup_ioapic_dest and call setup_IO_APIC_irq to make sure IO-APIC
irq-routing table is initialized.

Also seperate setup_IO_APIC_irq from setup_IO_APIC_irqs.

Signed-off-by: Yinghai Lu <yinghai.lu@amd.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/kernel/io_apic.c |  104 +++++++++++++++++++--------------
 1 files changed, 61 insertions(+), 43 deletions(-)

diff -puN arch/x86_64/kernel/io_apic.c~x86_64-check-vector-in-setup_ioapic_dest-to-verify-if-need-setup_io_apic_irq arch/x86_64/kernel/io_apic.c
--- a/arch/x86_64/kernel/io_apic.c~x86_64-check-vector-in-setup_ioapic_dest-to-verify-if-need-setup_io_apic_irq
+++ a/arch/x86_64/kernel/io_apic.c
@@ -789,27 +789,65 @@ static void ioapic_register_intr(int irq
 					      handle_edge_irq, "edge");
 	}
 }
-
-static void __init setup_IO_APIC_irqs(void)
+static void __init setup_IO_APIC_irq(int apic, int pin, int idx, int irq)
 {
 	struct IO_APIC_route_entry entry;
-	int apic, pin, idx, irq, first_notcon = 1, vector;
+	int vector;
 	unsigned long flags;
 
-	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
 
-	for (apic = 0; apic < nr_ioapics; apic++) {
-	for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
+	/*
+	 * add it to the IO-APIC irq-routing table:
+	 */
+	memset(&entry,0,sizeof(entry));
 
-		/*
-		 * add it to the IO-APIC irq-routing table:
-		 */
-		memset(&entry,0,sizeof(entry));
+	entry.delivery_mode = INT_DELIVERY_MODE;
+	entry.dest_mode = INT_DEST_MODE;
+	entry.mask = 0;				/* enable IRQ */
+	entry.dest.logical.logical_dest = cpu_mask_to_apicid(TARGET_CPUS);
+
+	entry.trigger = irq_trigger(idx);
+	entry.polarity = irq_polarity(idx);
 
-		entry.delivery_mode = INT_DELIVERY_MODE;
-		entry.dest_mode = INT_DEST_MODE;
-		entry.mask = 0;				/* enable IRQ */
+	if (irq_trigger(idx)) {
+		entry.trigger = 1;
+		entry.mask = 1;
 		entry.dest.logical.logical_dest = cpu_mask_to_apicid(TARGET_CPUS);
+	}
+
+	if (!apic && !IO_APIC_IRQ(irq))
+		return;
+
+	if (IO_APIC_IRQ(irq)) {
+		cpumask_t mask;
+		vector = assign_irq_vector(irq, TARGET_CPUS, &mask);
+		if (vector < 0)
+			return;
+
+		entry.dest.logical.logical_dest = cpu_mask_to_apicid(mask);
+		entry.vector = vector;
+
+		ioapic_register_intr(irq, vector, IOAPIC_AUTO);
+		if (!apic && (irq < 16))
+			disable_8259A_irq(irq);
+	}
+
+	ioapic_write_entry(apic, pin, entry);
+
+	spin_lock_irqsave(&ioapic_lock, flags);
+	set_native_irq_info(irq, TARGET_CPUS);
+	spin_unlock_irqrestore(&ioapic_lock, flags);
+
+}
+
+static void __init setup_IO_APIC_irqs(void)
+{
+	int apic, pin, idx, irq, first_notcon = 1;
+
+	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
+
+	for (apic = 0; apic < nr_ioapics; apic++) {
+	for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
 
 		idx = find_irq_entry(apic,pin,mp_INT);
 		if (idx == -1) {
@@ -821,39 +859,11 @@ static void __init setup_IO_APIC_irqs(vo
 			continue;
 		}
 
-		entry.trigger = irq_trigger(idx);
-		entry.polarity = irq_polarity(idx);
-
-		if (irq_trigger(idx)) {
-			entry.trigger = 1;
-			entry.mask = 1;
-			entry.dest.logical.logical_dest = cpu_mask_to_apicid(TARGET_CPUS);
-		}
-
 		irq = pin_2_irq(idx, apic, pin);
 		add_pin_to_irq(irq, apic, pin);
 
-		if (!apic && !IO_APIC_IRQ(irq))
-			continue;
+		setup_IO_APIC_irq(apic, pin, idx, irq);
 
-		if (IO_APIC_IRQ(irq)) {
-			cpumask_t mask;
-			vector = assign_irq_vector(irq, TARGET_CPUS, &mask);
-			if (vector < 0)
-				continue;
-
-			entry.dest.logical.logical_dest = cpu_mask_to_apicid(mask);
-			entry.vector = vector;
-
-			ioapic_register_intr(irq, vector, IOAPIC_AUTO);
-			if (!apic && (irq < 16))
-				disable_8259A_irq(irq);
-		}
-		ioapic_write_entry(apic, pin, entry);
-
-		spin_lock_irqsave(&ioapic_lock, flags);
-		set_native_irq_info(irq, TARGET_CPUS);
-		spin_unlock_irqrestore(&ioapic_lock, flags);
 	}
 	}
 
@@ -2139,7 +2149,15 @@ void __init setup_ioapic_dest(void)
 			if (irq_entry == -1)
 				continue;
 			irq = pin_2_irq(irq_entry, ioapic, pin);
-			set_ioapic_affinity_irq(irq, TARGET_CPUS);
+
+			/* setup_IO_APIC_irqs could fail to get vector for some device
+			 * when you have too many devices, because at that time only boot
+			 * cpu is online.
+			 */
+			if(!irq_vector[irq])
+				setup_IO_APIC_irq(ioapic, pin, irq_entry, irq);
+			else
+				set_ioapic_affinity_irq(irq, TARGET_CPUS);
 		}
 
 	}
_

Patches currently in -mm which might be from yinghai.lu@amd.com are

pci-check-szhi-when-sz-is-0-when-64-bit-iomem-bigger-than-4g.patch

