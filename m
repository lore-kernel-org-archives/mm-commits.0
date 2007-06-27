From: akpm@linux-foundation.org
Subject: + x86_64-add-ioapic-nmi-support.patch added to -mm tree
Date: Wed, 27 Jun 2007 11:15:18 -0700
Message-ID: <200706271815.l5RIFIU1028763@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39715 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754914AbXF0SP3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jun 2007 14:15:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jpk@sgi.com, ak@suse.de, ebiederm@xmission.com


The patch titled
     x86_64: add IOAPIC NMI support
has been added to the -mm tree.  Its filename is
     x86_64-add-ioapic-nmi-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: add IOAPIC NMI support
From: John Keller <jpk@sgi.com>

- Obtain the NMI IOAPIC info via an ACPI NMI SRC structure that is part
  of the MADT, and program the IOAPIC redirection register.  The NMI SRC
  struct will contain the GSI of the NMI interrupt.

- Setup irq_desc[] and irq_2_pin[] entries for the NMI interrupt irq,
  which will be used by the generic mask/unmask routines.  This will allow
  a driver to enable/disable the NMI interrupt via enable/disable_irq().

Signed-off-by: John Keller <jpk@sgi.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/acpi/boot.c |    3 -
 arch/i386/kernel/mpparse.c   |    5 ++
 arch/x86_64/kernel/io_apic.c |   78 ++++++++++++++++++++++++++++++---
 arch/x86_64/kernel/mpparse.c |   44 ++++++++++++++++++
 include/asm-i386/mpspec.h    |    1 
 include/asm-x86_64/io_apic.h |    1 
 include/asm-x86_64/mpspec.h  |    2 
 7 files changed, 127 insertions(+), 7 deletions(-)

diff -puN arch/i386/kernel/acpi/boot.c~x86_64-add-ioapic-nmi-support arch/i386/kernel/acpi/boot.c
--- a/arch/i386/kernel/acpi/boot.c~x86_64-add-ioapic-nmi-support
+++ a/arch/i386/kernel/acpi/boot.c
@@ -397,7 +397,8 @@ acpi_parse_nmi_src(struct acpi_subtable_
 
 	acpi_table_print_madt_entry(header);
 
-	/* TBD: Support nimsrc entries? */
+	mp_config_acpi_nmi_src(nmi_src->global_irq,
+			       nmi_src->inti_flags & ACPI_MADT_POLARITY_MASK);
 
 	return 0;
 }
diff -puN arch/i386/kernel/mpparse.c~x86_64-add-ioapic-nmi-support arch/i386/kernel/mpparse.c
--- a/arch/i386/kernel/mpparse.c~x86_64-add-ioapic-nmi-support
+++ a/arch/i386/kernel/mpparse.c
@@ -1040,6 +1040,11 @@ void __init mp_config_acpi_legacy_irqs (
 	}
 }
 
+void __init mp_config_acpi_nmi_src(u32 gsi, u16 polarity)
+{
+	/* TBD: Support nmi src entries? */
+}
+
 #define MAX_GSI_NUM	4096
 
 int mp_register_gsi(u32 gsi, int triggering, int polarity)
diff -puN arch/x86_64/kernel/io_apic.c~x86_64-add-ioapic-nmi-support arch/x86_64/kernel/io_apic.c
--- a/arch/x86_64/kernel/io_apic.c~x86_64-add-ioapic-nmi-support
+++ a/arch/x86_64/kernel/io_apic.c
@@ -375,9 +375,12 @@ static void clear_IO_APIC_pin(unsigned i
 {
 	struct IO_APIC_route_entry entry;
 
-	/* Check delivery_mode to be sure we're not clearing an SMI pin */
+	/* Check delivery_mode to be sure we're not clearing an SMI
+	 * or NMI pin.
+	 */
 	entry = ioapic_read_entry(apic, pin);
-	if (entry.delivery_mode == dest_SMI)
+	if ((entry.delivery_mode == dest_SMI) ||
+	    (entry.delivery_mode == dest_NMI))
 		return;
 	/*
 	 * Disable it in the IO-APIC irq-routing table:
@@ -1165,10 +1168,14 @@ void __apicdebuginit print_PIC(void)
 
 #endif  /*  0  */
 
+static void setup_ioapic_nmi_irq(int ioapic, int pin,
+				 struct IO_APIC_route_entry *entry);
+
 static void __init enable_IO_APIC(void)
 {
 	union IO_APIC_reg_01 reg_01;
 	int i8259_apic, i8259_pin;
+	int found_i8259 = 0;
 	int i, apic;
 	unsigned long flags;
 
@@ -1188,7 +1195,7 @@ static void __init enable_IO_APIC(void)
 	}
 	for(apic = 0; apic < nr_ioapics; apic++) {
 		int pin;
-		/* See if any of the pins is in ExtINT mode */
+		/* See if any of the pins are in ExtINT  or NMI mode */
 		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
 			struct IO_APIC_route_entry entry;
 			entry = ioapic_read_entry(apic, pin);
@@ -1196,14 +1203,20 @@ static void __init enable_IO_APIC(void)
 			/* If the interrupt line is enabled and in ExtInt mode
 			 * I have found the pin where the i8259 is connected.
 			 */
-			if ((entry.mask == 0) && (entry.delivery_mode == dest_ExtINT)) {
+			if (!found_i8259 && (entry.mask == 0) &&
+			    (entry.delivery_mode == dest_ExtINT)) {
 				ioapic_i8259.apic = apic;
 				ioapic_i8259.pin  = pin;
-				goto found_i8259;
+				found_i8259 = 1;
+				continue;
+			}
+
+			if (entry.delivery_mode == dest_NMI) {
+				setup_ioapic_nmi_irq(apic, pin, &entry);
 			}
 		}
 	}
- found_i8259:
+
 	/* Look to see what if the MP table has reported the ExtINT */
 	i8259_pin  = find_isa_irq_pin(0, mp_ExtINT);
 	i8259_apic = find_isa_irq_apic(0, mp_ExtINT);
@@ -1574,6 +1587,40 @@ static void setup_nmi (void)
 	printk(" done.\n");
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
 /*
  * This looks a bit hackish but it's about the only one way of sending
  * a few INTA cycles to 8259As and any associated glue logic.  ICR does
@@ -2161,6 +2208,25 @@ int io_apic_set_pci_routing (int ioapic,
 	return 0;
 }
 
+void __init io_apic_set_nmi_src_irq(int ioapic, int pin, u16 polarity)
+{
+	struct IO_APIC_route_entry entry;
+
+	entry = ioapic_read_entry(ioapic, pin);
+
+	/*
+	 * Setup the IOAPIC redirection register for NMI
+	 * The dest_mode and dest fields are setup later, as
+	 * genapic is not yet initialized.
+	 */
+	entry.delivery_mode = dest_NMI;
+	entry.mask = 1;
+	entry.polarity = (polarity == 1) ? 0 : 1;
+	entry.trigger = 0;		/* Should always be edge for NMI */
+
+	ioapic_write_entry(ioapic, pin, entry);
+}
+
 #endif /* CONFIG_ACPI */
 
 
diff -puN arch/x86_64/kernel/mpparse.c~x86_64-add-ioapic-nmi-support arch/x86_64/kernel/mpparse.c
--- a/arch/x86_64/kernel/mpparse.c~x86_64-add-ioapic-nmi-support
+++ a/arch/x86_64/kernel/mpparse.c
@@ -662,6 +662,18 @@ static u8 uniq_ioapic_id(u8 id)
 	return find_first_zero_bit(used, 256);
 }
 
+int mp_apic_pin_to_gsi(int apic, int pin)
+{
+        if (apic > nr_ioapics) {
+                 printk(KERN_ERR
+			 "ERROR: Invalid I/O APIC (%d), exceeds number"
+			 " found (%d)\n", apic, nr_ioapics);
+                return -1;
+        }
+
+        return (mp_ioapic_routing[apic].gsi_start + pin);
+}
+
 void __init mp_register_ioapic(u8 id, u32 address, u32 gsi_base)
 {
 	int idx = 0;
@@ -802,6 +814,38 @@ void __init mp_config_acpi_legacy_irqs(v
 	}
 }
 
+void __init mp_config_acpi_nmi_src(u32 gsi, u16 polarity)
+{
+	int idx, bit = 0;
+	int ioapic = -1;
+	int ioapic_pin = 0;
+
+	ioapic = mp_find_ioapic(gsi);
+	if (ioapic < 0) {
+		printk(KERN_WARNING "No IOAPIC for NMI Src GSI %u\n", gsi);
+		return;
+	}
+
+	ioapic_pin = gsi - mp_ioapic_routing[ioapic].gsi_start;
+	bit = ioapic_pin % 32;
+	idx = (ioapic_pin < 32) ? 0 : (ioapic_pin / 32);
+	if (idx > 3) {
+		printk(KERN_ERR "Invalid reference to IOAPIC pin "
+			"%d-%d\n", mp_ioapic_routing[ioapic].apic_id,
+			ioapic_pin);
+		return;
+	}
+	if ((1 << bit) & mp_ioapic_routing[ioapic].pin_programmed[idx]) {
+		printk(KERN_ERR "Pin %d-%d already programmed\n",
+			mp_ioapic_routing[ioapic].apic_id, ioapic_pin);
+		return;
+	}
+
+	mp_ioapic_routing[ioapic].pin_programmed[idx] |= (1 << bit);
+
+	io_apic_set_nmi_src_irq(ioapic, ioapic_pin, polarity);
+}
+
 int mp_register_gsi(u32 gsi, int triggering, int polarity)
 {
 	int ioapic = -1;
diff -puN include/asm-i386/mpspec.h~x86_64-add-ioapic-nmi-support include/asm-i386/mpspec.h
--- a/include/asm-i386/mpspec.h~x86_64-add-ioapic-nmi-support
+++ a/include/asm-i386/mpspec.h
@@ -31,6 +31,7 @@ extern void mp_register_ioapic (u8 id, u
 extern void mp_override_legacy_irq (u8 bus_irq, u8 polarity, u8 trigger, u32 gsi);
 extern void mp_config_acpi_legacy_irqs (void);
 extern int mp_register_gsi (u32 gsi, int edge_level, int active_high_low);
+extern void mp_config_acpi_nmi_src(u32 gsi, u16 flags);
 #endif /* CONFIG_ACPI */
 
 #define PHYSID_ARRAY_SIZE	BITS_TO_LONGS(MAX_APICS)
diff -puN include/asm-x86_64/io_apic.h~x86_64-add-ioapic-nmi-support include/asm-x86_64/io_apic.h
--- a/include/asm-x86_64/io_apic.h~x86_64-add-ioapic-nmi-support
+++ a/include/asm-x86_64/io_apic.h
@@ -119,6 +119,7 @@ extern int skip_ioapic_setup;
 extern int io_apic_get_version (int ioapic);
 extern int io_apic_get_redir_entries (int ioapic);
 extern int io_apic_set_pci_routing (int ioapic, int pin, int irq, int, int);
+extern void io_apic_set_nmi_src_irq (int ioapic, int pin, u16 polarity);
 #endif
 
 extern int sis_apic_bug; /* dummy */ 
diff -puN include/asm-x86_64/mpspec.h~x86_64-add-ioapic-nmi-support include/asm-x86_64/mpspec.h
--- a/include/asm-x86_64/mpspec.h~x86_64-add-ioapic-nmi-support
+++ a/include/asm-x86_64/mpspec.h
@@ -181,9 +181,11 @@ extern void mp_register_ioapic (u8 id, u
 extern void mp_override_legacy_irq (u8 bus_irq, u8 polarity, u8 trigger, u32 gsi);
 extern void mp_config_acpi_legacy_irqs (void);
 extern int mp_register_gsi (u32 gsi, int triggering, int polarity);
+extern void mp_config_acpi_nmi_src(u32 gsi, u16 flags);
 #endif
 
 extern int using_apic_timer;
+extern int mp_apic_pin_to_gsi(int apic, int pin);
 
 #define PHYSID_ARRAY_SIZE	BITS_TO_LONGS(MAX_APICS)
 
_

Patches currently in -mm which might be from jpk@sgi.com are

x86_64-add-ioapic-nmi-support.patch
x86_64-add-ioapic-nmi-support-fix.patch
