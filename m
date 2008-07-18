From: akpm@linux-foundation.org
Subject: - x86-pci-use-dev_printk-when-possible.patch removed from -mm tree
Date: Fri, 18 Jul 2008 16:02:39 -0700
Message-ID: <200807182302.m6IN2dnh003258@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48906 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751002AbYGRXDS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jul 2008 19:03:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, jbarnes@virtuousgeek.org, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86 PCI: use dev_printk when possible
has been removed from the -mm tree.  Its filename was
     x86-pci-use-dev_printk-when-possible.patch

This patch was dropped because arch/x86/pci/numa.c went and disappeared

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

 arch/x86/pci/fixup.c |    3 ++-
 arch/x86/pci/i386.c  |   26 +++++++++++---------------
 arch/x86/pci/irq.c   |   23 ++++++++++-------------
 arch/x86/pci/numa.c  |    5 +++--
 4 files changed, 26 insertions(+), 31 deletions(-)

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
@@ -452,7 +452,7 @@ static int pirq_vlsi_get(struct pci_dev 
 {
 	WARN_ON_ONCE(pirq >= 9);
 	if (pirq > 8) {
-		printk(KERN_INFO "VLSI router pirq escape (%d)\n", pirq);
+		dev_info(&dev->dev, "VLSI router PIRQ escape (%d)\n", pirq);
 		return 0;
 	}
 	return read_config_nybble(router, 0x74, pirq-1);
@@ -463,7 +463,7 @@ pirq_vlsi_set(struct pci_dev *router, st
 {
 	WARN_ON_ONCE(pirq >= 9);
 	if (pirq > 8) {
-		printk(KERN_INFO "VLSI router pirq escape (%d)\n", pirq);
+		dev_info(&dev->dev, "VLSI router PIRQ escape (%d)\n", pirq);
 		return 0;
 	}
 	write_config_nybble(router, 0x74, pirq-1, irq);
@@ -511,8 +511,8 @@ pirq_amd756_get(struct pci_dev *router, 
 	irq = 0;
 	if (pirq <= 4)
 		irq = read_config_nybble(router, 0x56, pirq - 1);
-	printk(KERN_INFO
-		"AMD756: dev %04x:%04x, router pirq : %d get irq : %2d\n",
+	dev_info(&dev->dev,
+		"AMD756: dev [%04x/%04x], router PIRQ %d get IRQ %d\n",
 		dev->vendor, dev->device, pirq, irq);
 	return irq;
 }
@@ -520,8 +520,8 @@ pirq_amd756_get(struct pci_dev *router, 
 static int
 pirq_amd756_set(struct pci_dev *router, struct pci_dev *dev, int pirq, int irq)
 {
-	printk(KERN_INFO
-		"AMD756: dev %04x:%04x, router pirq : %d SET irq : %2d\n",
+	dev_info(&dev->dev,
+		"AMD756: dev [%04x/%04x], router PIRQ %d set IRQ %d\n",
 		dev->vendor, dev->device, pirq, irq);
 	if (pirq <= 4)
 		write_config_nybble(router, 0x56, pirq - 1, irq);
@@ -762,7 +762,6 @@ ali_router_probe(struct irq_router *r, s
 	switch (device) {
 	case PCI_DEVICE_ID_AL_M1533:
 	case PCI_DEVICE_ID_AL_M1563:
-		printk(KERN_DEBUG "PCI: Using ALI IRQ Router\n");
 		r->name = "ALI";
 		r->get = pirq_ali_get;
 		r->set = pirq_ali_set;
@@ -874,11 +873,9 @@ static void __init pirq_find_router(stru
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
@@ -911,7 +908,7 @@ static int pcibios_lookup_irq(struct pci
 	/* Find IRQ pin */
 	pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
 	if (!pin) {
-		DBG(KERN_DEBUG " -> no interrupt pin\n");
+		dev_dbg(&dev->dev, "no interrupt pin\n");
 		return 0;
 	}
 	pin = pin - 1;
diff -puN arch/x86/pci/numa.c~x86-pci-use-dev_printk-when-possible arch/x86/pci/numa.c
--- a/arch/x86/pci/numa.c~x86-pci-use-dev_printk-when-possible
+++ a/arch/x86/pci/numa.c
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
git-acpi.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
x86-pci-use-dev_printk-when-possible.patch
x86-pci-use-dev_printk-when-possible-2.patch
x86-pci-replace-dbg-with-pr_debug.patch
pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards.patch
isa-set-24-bit-dma_mask-for-isa-devices.patch
pnp-have-quirk_system_pci_resources-include-io-resources.patch
pnpacpi-fix-pnpacpi_parse_irq_options-test-against-pnp_irq_nr.patch
pnp-fix-the-fcpnp_driver-declaration-to-only-exist-if-config_pnp=y.patch
make-pnp_add_card_id-static.patch

