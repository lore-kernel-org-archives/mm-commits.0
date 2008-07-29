From: akpm@linux-foundation.org
Subject: + x86-pci-use-dev_printk-when-possible.patch added to -mm tree
Date: Mon, 28 Jul 2008 22:33:44 -0700
Message-ID: <200807290533.m6T5Xi0d016462@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59368 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753162AbYG2FfH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 01:35:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86 PCI: use dev_printk when possible
has been added to the -mm tree.  Its filename is
     x86-pci-use-dev_printk-when-possible.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86 PCI: use dev_printk when possible
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Convert printks to use dev_printk().

I converted DBG() to dev_dbg().  This DBG() is from arch/x86/pci/pci.h
and requires source-code modification to enable, so dev_dbg() seems
roughly equivalent.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/pci/fixup.c    |    3 -
 arch/x86/pci/i386.c     |   26 +++------
 arch/x86/pci/irq.c      |  106 +++++++++++++++++---------------------
 arch/x86/pci/numaq_32.c |    5 +
 4 files changed, 64 insertions(+), 76 deletions(-)

diff -puN arch/x86/pci/fixup.c~x86-pci-use-dev_printk-when-possible arch/x86/pci/fixup.c
--- a/arch/x86/pci/fixup.c~x86-pci-use-dev_printk-when-possible
+++ a/arch/x86/pci/fixup.c
@@ -23,7 +23,8 @@ static void __devinit pci_fixup_i450nx(s
 		pci_read_config_byte(d, reg++, &busno);
 		pci_read_config_byte(d, reg++, &suba);
 		pci_read_config_byte(d, reg++, &subb);
-		DBG("i450NX PXB %d: %02x/%02x/%02x\n", pxb, busno, suba, subb);
+		dev_dbg(&d->dev, "i450NX PXB %d: %02x/%02x/%02x\n", pxb, busno,
+			suba, subb);
 		if (busno)
 			pci_scan_bus_with_sysdata(busno);	/* Bus A */
 		if (suba < subb)
diff -puN arch/x86/pci/i386.c~x86-pci-use-dev_printk-when-possible arch/x86/pci/i386.c
--- a/arch/x86/pci/i386.c~x86-pci-use-dev_printk-when-possible
+++ a/arch/x86/pci/i386.c
@@ -128,10 +128,8 @@ static void __init pcibios_allocate_bus_
 				pr = pci_find_parent_resource(dev, r);
 				if (!r->start || !pr ||
 				    request_resource(pr, r) < 0) {
-					printk(KERN_ERR "PCI: Cannot allocate "
-						"resource region %d "
-						"of bridge %s\n",
-						idx, pci_name(dev));
+					dev_err(&dev->dev, "BAR %d: can't "
+						"allocate resource\n", idx);
 					/*
 					 * Something is wrong with the region.
 					 * Invalidate the resource to prevent
@@ -166,15 +164,15 @@ static void __init pcibios_allocate_reso
 			else
 				disabled = !(command & PCI_COMMAND_MEMORY);
 			if (pass == disabled) {
-				DBG("PCI: Resource %08lx-%08lx "
-				    "(f=%lx, d=%d, p=%d)\n",
-				    r->start, r->end, r->flags, disabled, pass);
+				dev_dbg(&dev->dev, "resource %#08llx-%#08llx "
+					"(f=%lx, d=%d, p=%d)\n",
+					(unsigned long long) r->start,
+					(unsigned long long) r->end,
+					r->flags, disabled, pass);
 				pr = pci_find_parent_resource(dev, r);
 				if (!pr || request_resource(pr, r) < 0) {
-					printk(KERN_ERR "PCI: Cannot allocate "
-						"resource region %d "
-						"of device %s\n",
-						idx, pci_name(dev));
+					dev_err(&dev->dev, "BAR %d: can't "
+						"allocate resource\n", idx);
 					/* We'll assign a new address later */
 					r->end -= r->start;
 					r->start = 0;
@@ -187,8 +185,7 @@ static void __init pcibios_allocate_reso
 				/* Turn the ROM off, leave the resource region,
 				 * but keep it unregistered. */
 				u32 reg;
-				DBG("PCI: Switching off ROM of %s\n",
-					pci_name(dev));
+				dev_dbg(&dev->dev, "disabling ROM\n");
 				r->flags &= ~IORESOURCE_ROM_ENABLE;
 				pci_read_config_dword(dev,
 						dev->rom_base_reg, &reg);
@@ -257,8 +254,7 @@ void pcibios_set_master(struct pci_dev *
 		lat = pcibios_max_latency;
 	else
 		return;
-	printk(KERN_DEBUG "PCI: Setting latency timer of device %s to %d\n",
-		pci_name(dev), lat);
+	dev_printk(KERN_DEBUG, &dev->dev, "setting latency timer to %d\n", lat);
 	pci_write_config_byte(dev, PCI_LATENCY_TIMER, lat);
 }
 
diff -puN arch/x86/pci/irq.c~x86-pci-use-dev_printk-when-possible arch/x86/pci/irq.c
--- a/arch/x86/pci/irq.c~x86-pci-use-dev_printk-when-possible
+++ a/arch/x86/pci/irq.c
@@ -436,7 +436,7 @@ static int pirq_vlsi_get(struct pci_dev 
 {
 	WARN_ON_ONCE(pirq >= 9);
 	if (pirq > 8) {
-		printk(KERN_INFO "VLSI router pirq escape (%d)\n", pirq);
+		dev_info(&dev->dev, "VLSI router PIRQ escape (%d)\n", pirq);
 		return 0;
 	}
 	return read_config_nybble(router, 0x74, pirq-1);
@@ -446,7 +446,7 @@ static int pirq_vlsi_set(struct pci_dev 
 {
 	WARN_ON_ONCE(pirq >= 9);
 	if (pirq > 8) {
-		printk(KERN_INFO "VLSI router pirq escape (%d)\n", pirq);
+		dev_info(&dev->dev, "VLSI router PIRQ escape (%d)\n", pirq);
 		return 0;
 	}
 	write_config_nybble(router, 0x74, pirq-1, irq);
@@ -492,15 +492,17 @@ static int pirq_amd756_get(struct pci_de
 	irq = 0;
 	if (pirq <= 4)
 		irq = read_config_nybble(router, 0x56, pirq - 1);
-	printk(KERN_INFO "AMD756: dev %04x:%04x, router pirq : %d get irq : %2d\n",
-		dev->vendor, dev->device, pirq, irq);
+	dev_info(&dev->dev,
+		 "AMD756: dev [%04x/%04x], router PIRQ %d get IRQ %d\n",
+		 dev->vendor, dev->device, pirq, irq);
 	return irq;
 }
 
 static int pirq_amd756_set(struct pci_dev *router, struct pci_dev *dev, int pirq, int irq)
 {
-	printk(KERN_INFO "AMD756: dev %04x:%04x, router pirq : %d SET irq : %2d\n",
-		dev->vendor, dev->device, pirq, irq);
+	dev_info(&dev->dev,
+		 "AMD756: dev [%04x/%04x], router PIRQ %d set IRQ %d\n",
+		 dev->vendor, dev->device, pirq, irq);
 	if (pirq <= 4)
 		write_config_nybble(router, 0x56, pirq - 1, irq);
 	return 1;
@@ -730,7 +732,6 @@ static __init int ali_router_probe(struc
 	switch (device) {
 	case PCI_DEVICE_ID_AL_M1533:
 	case PCI_DEVICE_ID_AL_M1563:
-		printk(KERN_DEBUG "PCI: Using ALI IRQ Router\n");
 		r->name = "ALI";
 		r->get = pirq_ali_get;
 		r->set = pirq_ali_set;
@@ -840,11 +841,9 @@ static void __init pirq_find_router(stru
 			h->probe(r, pirq_router_dev, pirq_router_dev->device))
 			break;
 	}
-	printk(KERN_INFO "PCI: Using IRQ router %s [%04x/%04x] at %s\n",
-		pirq_router.name,
-		pirq_router_dev->vendor,
-		pirq_router_dev->device,
-		pci_name(pirq_router_dev));
+	dev_info(&pirq_router_dev->dev, "%s IRQ router [%04x/%04x]\n",
+		 pirq_router.name,
+		 pirq_router_dev->vendor, pirq_router_dev->device);
 
 	/* The device remains referenced for the kernel lifetime */
 }
@@ -877,7 +876,7 @@ static int pcibios_lookup_irq(struct pci
 	/* Find IRQ pin */
 	pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
 	if (!pin) {
-		DBG(KERN_DEBUG " -> no interrupt pin\n");
+		dev_dbg(&dev->dev, "no interrupt pin\n");
 		return 0;
 	}
 	pin = pin - 1;
@@ -887,20 +886,20 @@ static int pcibios_lookup_irq(struct pci
 	if (!pirq_table)
 		return 0;
 
-	DBG(KERN_DEBUG "IRQ for %s[%c]", pci_name(dev), 'A' + pin);
 	info = pirq_get_info(dev);
 	if (!info) {
-		DBG(" -> not found in routing table\n" KERN_DEBUG);
+		dev_dbg(&dev->dev, "PCI INT %c not found in routing table\n",
+			'A' + pin);
 		return 0;
 	}
 	pirq = info->irq[pin].link;
 	mask = info->irq[pin].bitmap;
 	if (!pirq) {
-		DBG(" -> not routed\n" KERN_DEBUG);
+		dev_dbg(&dev->dev, "PCI INT %c not routed\n", 'A' + pin);
 		return 0;
 	}
-	DBG(" -> PIRQ %02x, mask %04x, excl %04x", pirq, mask,
-		pirq_table->exclusive_irqs);
+	dev_dbg(&dev->dev, "PCI INT %c -> PIRQ %02x, mask %04x, excl %04x",
+		'A' + pin, pirq, mask, pirq_table->exclusive_irqs);
 	mask &= pcibios_irq_mask;
 
 	/* Work around broken HP Pavilion Notebooks which assign USB to
@@ -930,10 +929,8 @@ static int pcibios_lookup_irq(struct pci
 		if (pci_probe & PCI_USE_PIRQ_MASK)
 			newirq = 0;
 		else
-			printk("\n" KERN_WARNING
-				"PCI: IRQ %i for device %s doesn't match PIRQ mask - try pci=usepirqmask\n"
-				KERN_DEBUG, newirq,
-				pci_name(dev));
+			dev_warn(&dev->dev, "IRQ %d doesn't match PIRQ mask "
+				 "%#x; try pci=usepirqmask\n", newirq, mask);
 	}
 	if (!newirq && assign) {
 		for (i = 0; i < 16; i++) {
@@ -944,39 +941,35 @@ static int pcibios_lookup_irq(struct pci
 				newirq = i;
 		}
 	}
-	DBG(" -> newirq=%d", newirq);
+	dev_dbg(&dev->dev, "PCI INT %c -> newirq %d", 'A' + pin, newirq);
 
 	/* Check if it is hardcoded */
 	if ((pirq & 0xf0) == 0xf0) {
 		irq = pirq & 0xf;
-		DBG(" -> hardcoded IRQ %d\n", irq);
-		msg = "Hardcoded";
+		msg = "hardcoded";
 	} else if (r->get && (irq = r->get(pirq_router_dev, dev, pirq)) && \
 	((!(pci_probe & PCI_USE_PIRQ_MASK)) || ((1 << irq) & mask))) {
-		DBG(" -> got IRQ %d\n", irq);
-		msg = "Found";
+		msg = "found";
 		eisa_set_level_irq(irq);
 	} else if (newirq && r->set &&
 		(dev->class >> 8) != PCI_CLASS_DISPLAY_VGA) {
-		DBG(" -> assigning IRQ %d", newirq);
 		if (r->set(pirq_router_dev, dev, pirq, newirq)) {
 			eisa_set_level_irq(newirq);
-			DBG(" ... OK\n");
-			msg = "Assigned";
+			msg = "assigned";
 			irq = newirq;
 		}
 	}
 
 	if (!irq) {
-		DBG(" ... failed\n");
 		if (newirq && mask == (1 << newirq)) {
-			msg = "Guessed";
+			msg = "guessed";
 			irq = newirq;
-		} else
+		} else {
+			dev_dbg(&dev->dev, "can't route interrupt\n");
 			return 0;
+		}
 	}
-	printk(KERN_INFO "PCI: %s IRQ %d for device %s\n", msg, irq,
-		pci_name(dev));
+	dev_info(&dev->dev, "%s PCI INT %c -> IRQ %d\n", msg, 'A' + pin, irq);
 
 	/* Update IRQ for all devices with the same pirq value */
 	while ((dev2 = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev2)) != NULL) {
@@ -996,17 +989,17 @@ static int pcibios_lookup_irq(struct pci
 			(!(pci_probe & PCI_USE_PIRQ_MASK) || \
 			((1 << dev2->irq) & mask))) {
 #ifndef CONFIG_PCI_MSI
-				printk(KERN_INFO "IRQ routing conflict for %s, have irq %d, want irq %d\n",
-				       pci_name(dev2), dev2->irq, irq);
+				dev_info(&dev2->dev, "IRQ routing conflict: "
+					 "have IRQ %d, want IRQ %d\n",
+					 dev2->irq, irq);
 #endif
 				continue;
 			}
 			dev2->irq = irq;
 			pirq_penalty[irq]++;
 			if (dev != dev2)
-				printk(KERN_INFO
-					"PCI: Sharing IRQ %d with %s\n",
-					irq, pci_name(dev2));
+				dev_info(&dev->dev, "sharing IRQ %d with %s\n",
+					 irq, pci_name(dev2));
 		}
 	}
 	return 1;
@@ -1025,8 +1018,7 @@ static void __init pcibios_fixup_irqs(vo
 		 * already in use.
 		 */
 		if (dev->irq >= 16) {
-			DBG(KERN_DEBUG "%s: ignoring bogus IRQ %d\n",
-				pci_name(dev), dev->irq);
+			dev_dbg(&dev->dev, "ignoring bogus IRQ %d\n", dev->irq);
 			dev->irq = 0;
 		}
 		/*
@@ -1070,12 +1062,12 @@ static void __init pcibios_fixup_irqs(vo
 					irq = IO_APIC_get_PCI_irq_vector(bridge->bus->number,
 							PCI_SLOT(bridge->devfn), pin);
 					if (irq >= 0)
-						printk(KERN_WARNING "PCI: using PPB %s[%c] to get irq %d\n",
-							pci_name(bridge), 'A' + pin, irq);
+						dev_warn(&dev->dev, "using bridge %s INT %c to get IRQ %d\n",
+							 pci_name(bridge),
+							 'A' + pin, irq);
 				}
 				if (irq >= 0) {
-					printk(KERN_INFO "PCI->APIC IRQ transform: %s[%c] -> IRQ %d\n",
-						pci_name(dev), 'A' + pin, irq);
+					dev_info(&dev->dev, "PCI->APIC IRQ transform: INT %c -> IRQ %d\n", 'A' + pin, irq);
 					dev->irq = irq;
 				}
 			}
@@ -1231,25 +1223,24 @@ static int pirq_enable_irq(struct pci_de
 				irq = IO_APIC_get_PCI_irq_vector(bridge->bus->number,
 						PCI_SLOT(bridge->devfn), pin);
 				if (irq >= 0)
-					printk(KERN_WARNING
-						"PCI: using PPB %s[%c] to get irq %d\n",
-						pci_name(bridge),
-						'A' + pin, irq);
+					dev_warn(&dev->dev, "using bridge %s "
+						 "INT %c to get IRQ %d\n",
+						 pci_name(bridge), 'A' + pin,
+						 irq);
 				dev = bridge;
 			}
 			dev = temp_dev;
 			if (irq >= 0) {
-				printk(KERN_INFO
-					"PCI->APIC IRQ transform: %s[%c] -> IRQ %d\n",
-					pci_name(dev), 'A' + pin, irq);
+				dev_info(&dev->dev, "PCI->APIC IRQ transform: "
+					 "INT %c -> IRQ %d\n", 'A' + pin, irq);
 				dev->irq = irq;
 				return 0;
 			} else
-				msg = " Probably buggy MP table.";
+				msg = "; probably buggy MP table";
 		} else if (pci_probe & PCI_BIOS_IRQ_SCAN)
 			msg = "";
 		else
-			msg = " Please try using pci=biosirq.";
+			msg = "; please try using pci=biosirq";
 
 		/*
 		 * With IDE legacy devices the IRQ lookup failure is not
@@ -1259,9 +1250,8 @@ static int pirq_enable_irq(struct pci_de
 				!(dev->class & 0x5))
 			return 0;
 
-		printk(KERN_WARNING
-			"PCI: No IRQ known for interrupt pin %c of device %s.%s\n",
-			'A' + pin, pci_name(dev), msg);
+		dev_warn(&dev->dev, "can't find IRQ for PCI INT %c%s\n",
+			 'A' + pin, msg);
 	}
 	return 0;
 }
diff -puN arch/x86/pci/numaq_32.c~x86-pci-use-dev_printk-when-possible arch/x86/pci/numaq_32.c
--- a/arch/x86/pci/numaq_32.c~x86-pci-use-dev_printk-when-possible
+++ a/arch/x86/pci/numaq_32.c
@@ -131,13 +131,14 @@ static void __devinit pci_fixup_i450nx(s
 	u8 busno, suba, subb;
 	int quad = BUS2QUAD(d->bus->number);
 
-	printk("PCI: Searching for i450NX host bridges on %s\n", pci_name(d));
+	dev_info(&d->dev, "searching for i450NX host bridges\n");
 	reg = 0xd0;
 	for(pxb=0; pxb<2; pxb++) {
 		pci_read_config_byte(d, reg++, &busno);
 		pci_read_config_byte(d, reg++, &suba);
 		pci_read_config_byte(d, reg++, &subb);
-		DBG("i450NX PXB %d: %02x/%02x/%02x\n", pxb, busno, suba, subb);
+		dev_dbg(&d->dev, "i450NX PXB %d: %02x/%02x/%02x\n",
+			pxb, busno, suba, subb);
 		if (busno) {
 			/* Bus A */
 			pci_scan_bus_with_sysdata(QUADLOCAL2BUS(quad, busno));
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

origin.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
x86-pci-use-dev_printk-when-possible.patch

