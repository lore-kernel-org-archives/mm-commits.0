From: akpm@linux-foundation.org
Subject: - x86-pci-use-dev_printk-when-possible-2.patch removed from -mm tree
Date: Fri, 18 Jul 2008 16:03:23 -0700
Message-ID: <200807182303.m6IN3OPa003285@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50375 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753935AbYGRXDs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jul 2008 19:03:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, jbarnes@virtuousgeek.org, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86 PCI: use dev_printk when possible
has been removed from the -mm tree.  Its filename was
     x86-pci-use-dev_printk-when-possible-2.patch

This patch was dropped because inappropriately-timed linux-next changes wrecked it

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86 PCI: use dev_printk when possible
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Convert printks to use dev_printk().

I converted DBG() to dev_dbg().  This DBG() is from arch/x86/pci/pci.h and
requires source-code modification to enable, so dev_dbg() seems roughly
equivalent.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/pci/irq.c |   89 +++++++++++++++++++------------------------
 1 file changed, 40 insertions(+), 49 deletions(-)

diff -puN arch/x86/pci/irq.c~x86-pci-use-dev_printk-when-possible-2 arch/x86/pci/irq.c
--- a/arch/x86/pci/irq.c~x86-pci-use-dev_printk-when-possible-2
+++ a/arch/x86/pci/irq.c
@@ -918,20 +918,20 @@ static int pcibios_lookup_irq(struct pci
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
@@ -961,10 +961,8 @@ static int pcibios_lookup_irq(struct pci
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
@@ -975,39 +973,35 @@ static int pcibios_lookup_irq(struct pci
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
@@ -1027,18 +1021,17 @@ static int pcibios_lookup_irq(struct pci
 			(!(pci_probe & PCI_USE_PIRQ_MASK) || \
 			((1 << dev2->irq) & mask))) {
 #ifndef CONFIG_PCI_MSI
-				printk(KERN_INFO
-					"IRQ routing conflict for %s, have irq %d, want irq %d\n",
-					pci_name(dev2), dev2->irq, irq);
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
@@ -1057,8 +1050,7 @@ static void __init pcibios_fixup_irqs(vo
 		 * already in use.
 		 */
 		if (dev->irq >= 16) {
-			DBG(KERN_DEBUG "%s: ignoring bogus IRQ %d\n",
-				pci_name(dev), dev->irq);
+			dev_dbg(&dev->dev, "ignoring bogus IRQ %d\n", dev->irq);
 			dev->irq = 0;
 		}
 		/*
@@ -1104,15 +1096,16 @@ static void __init pcibios_fixup_irqs(vo
 							PCI_SLOT(bridge->devfn),
 							pin);
 					if (irq >= 0)
-						printk(KERN_WARNING
-							"PCI: using PPB %s[%c] to get irq %d\n",
-							pci_name(bridge),
-							'A' + pin, irq);
+						dev_warn(&dev->dev, "using "
+							 "bridge %s INT %c to "
+							 "get IRQ %d\n",
+							 pci_name(bridge),
+							 'A' + pin, irq);
 				}
 				if (irq >= 0) {
-					printk(KERN_INFO
-						"PCI->APIC IRQ transform: %s[%c] -> IRQ %d\n",
-						pci_name(dev), 'A' + pin, irq);
+					dev_info(&dev->dev, "PCI->APIC IRQ "
+						 "transform: INT %c -> "
+						 "IRQ %d\n", 'A' + pin, irq);
 					dev->irq = irq;
 				}
 			}
@@ -1272,25 +1265,24 @@ static int pirq_enable_irq(struct pci_de
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
@@ -1300,9 +1292,8 @@ static int pirq_enable_irq(struct pci_de
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
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

origin.patch
git-acpi.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
x86-pci-use-dev_printk-when-possible-2.patch
x86-pci-replace-dbg-with-pr_debug.patch
pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards.patch
isa-set-24-bit-dma_mask-for-isa-devices.patch
pnp-have-quirk_system_pci_resources-include-io-resources.patch
pnpacpi-fix-pnpacpi_parse_irq_options-test-against-pnp_irq_nr.patch
pnp-fix-the-fcpnp_driver-declaration-to-only-exist-if-config_pnp=y.patch
make-pnp_add_card_id-static.patch

