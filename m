From: akpm@linux-foundation.org
Subject: - x86_64-add-ioapic-nmi-support-fix-3.patch removed from -mm tree
Date: Mon, 09 Jul 2007 12:32:37 -0700
Message-ID: <200707091932.l69JWba3004526@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47077 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754493AbXGITco (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 15:32:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jpk@sgi.com, mm-commits@vger.kernel.org


The patch titled
     x86_64-add-ioapic-nmi-support-fix-3
has been removed from the -mm tree.  Its filename was
     x86_64-add-ioapic-nmi-support-fix-3.patch

This patch was dropped because it was folded into x86_64-add-ioapic-nmi-support.patch

------------------------------------------------------
Subject: x86_64-add-ioapic-nmi-support-fix-3
From: John Keller <jpk@sgi.com>

Place all the IOACPI NMI support code under CONFIG_ACPI
to clear up build errors with certain configs.

Signed-off-by: John Keller <jpk@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/io_apic.c |   77 +++++++++++++++++----------------
 1 files changed, 40 insertions(+), 37 deletions(-)

diff -puN arch/x86_64/kernel/io_apic.c~x86_64-add-ioapic-nmi-support-fix-3 arch/x86_64/kernel/io_apic.c
--- a/arch/x86_64/kernel/io_apic.c~x86_64-add-ioapic-nmi-support-fix-3
+++ a/arch/x86_64/kernel/io_apic.c
@@ -75,6 +75,10 @@ struct irq_cfg irq_cfg[NR_IRQS] __read_m
 	[15] = { .domain = CPU_MASK_ALL, .vector = IRQ15_VECTOR, },
 };
 
+#ifdef CONFIG_ACPI
+static void setup_ioapic_nmi_irq(int ioapic, int pin,
+				 struct IO_APIC_route_entry *entry);
+#endif
 static int assign_irq_vector(int irq, cpumask_t mask);
 
 #define __apicdebuginit  __init
@@ -1167,9 +1171,6 @@ void __apicdebuginit print_PIC(void)
 
 #endif  /*  0  */
 
-static void setup_ioapic_nmi_irq(int ioapic, int pin,
-				 struct IO_APIC_route_entry *entry);
-
 static void __init enable_IO_APIC(void)
 {
 	union IO_APIC_reg_01 reg_01;
@@ -1210,8 +1211,10 @@ static void __init enable_IO_APIC(void)
 				continue;
 			}
 
+#ifdef CONFIG_ACPI
 			if (entry.delivery_mode == dest_NMI)
 				setup_ioapic_nmi_irq(apic, pin, &entry);
+#endif
 		}
 	}
 
@@ -1585,40 +1588,6 @@ static void setup_nmi (void)
 	printk(" done.\n");
 }
 
-#define disable_nmi_ioapic      mask_IO_APIC_irq
-#define enable_nmi_ioapic       unmask_IO_APIC_irq
-
-static struct irq_chip nmi_ioapic_chip __read_mostly = {
-	.name		= "IO-APIC NMI",
-	.enable		= enable_nmi_ioapic,
-	.disable	= disable_nmi_ioapic,
-	.mask		= mask_IO_APIC_irq,
-	.unmask		= unmask_IO_APIC_irq,
-};
-
-void __init setup_ioapic_nmi_irq(int apic, int pin,
-				 struct IO_APIC_route_entry *entry)
-{
-	int irq;
-
-	entry->dest_mode = INT_DEST_MODE;
-	entry->dest = cpu_mask_to_apicid(TARGET_CPUS);
-	ioapic_write_entry(apic, pin, *entry);
-
-	irq = mp_apic_pin_to_gsi(apic, pin);
-
-	/* Setup pin_2_irq[irq] entry */
-	add_pin_to_irq(irq, apic, pin);
-
-	irq_desc[irq].status = IRQ_NOREQUEST | IRQ_NO_BALANCING;
-	if (!entry->mask) {
-		irq_desc[irq].status &= ~IRQ_DISABLED;
-		irq_desc[irq].depth = 0;
-	}
-
-	set_irq_chip(irq, &nmi_ioapic_chip);
-}
-
 /*
  * This looks a bit hackish but it's about the only one way of sending
  * a few INTA cycles to 8259As and any associated glue logic.  ICR does
@@ -2225,6 +2194,40 @@ void __init io_apic_set_nmi_src_irq(int 
 	ioapic_write_entry(ioapic, pin, entry);
 }
 
+#define disable_nmi_ioapic      mask_IO_APIC_irq
+#define enable_nmi_ioapic       unmask_IO_APIC_irq
+
+static struct irq_chip nmi_ioapic_chip __read_mostly = {
+	.name		= "IO-APIC NMI",
+	.enable		= enable_nmi_ioapic,
+	.disable	= disable_nmi_ioapic,
+	.mask		= mask_IO_APIC_irq,
+	.unmask		= unmask_IO_APIC_irq,
+};
+
+void __init setup_ioapic_nmi_irq(int apic, int pin,
+				 struct IO_APIC_route_entry *entry)
+{
+	int irq;
+
+	entry->dest_mode = INT_DEST_MODE;
+	entry->dest = cpu_mask_to_apicid(TARGET_CPUS);
+	ioapic_write_entry(apic, pin, *entry);
+
+	irq = mp_apic_pin_to_gsi(apic, pin);
+
+	/* Setup pin_2_irq[irq] entry */
+	add_pin_to_irq(irq, apic, pin);
+
+	irq_desc[irq].status = IRQ_NOREQUEST | IRQ_NO_BALANCING;
+	if (!entry->mask) {
+		irq_desc[irq].status &= ~IRQ_DISABLED;
+		irq_desc[irq].depth = 0;
+	}
+
+	set_irq_chip(irq, &nmi_ioapic_chip);
+}
+
 #endif /* CONFIG_ACPI */
 
 
_

Patches currently in -mm which might be from jpk@sgi.com are

sn-correct-rom-resource-length-for-bios-copy.patch
x86_64-add-ioapic-nmi-support.patch
x86_64-add-ioapic-nmi-support-fix-3.patch
