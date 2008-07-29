From: akpm@linux-foundation.org
Subject: - x86-pci-replace-dbg-with-pr_debug.patch removed from -mm tree
Date: Mon, 28 Jul 2008 22:32:14 -0700
Message-ID: <200807290532.m6T5WEjE016436@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41791 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752852AbYG2FdJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 01:33:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, akpm@linux-foundation.org, jbarnes@virtuousgeek.org, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86 PCI: replace DBG() with pr_debug()
has been removed from the -mm tree.  Its filename was
     x86-pci-replace-dbg-with-pr_debug.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86 PCI: replace DBG() with pr_debug()
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

The remaining uses of DBG() are not specific to a device, so I converted
them to pr_debug() and removed DBG() from arch/x86/pci/pci.h.

DBG() requires source-code modification to enable, so pr_debug(), which
requires compilation with "DEBUG" defined, seems roughly equivalent.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
DESC
x86-pci-replace-dbg-with-pr_debug-fix
EDESC

Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
DESC
x86-pci-replace-dbg-with-pr_debug-fix-2
EDESC

Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/pci/direct.c |    2 -
 arch/x86/pci/fixup.c  |    3 +-
 arch/x86/pci/i386.c   |    6 ++--
 arch/x86/pci/irq.c    |   57 ++++++++++++++++++----------------------
 arch/x86/pci/legacy.c |    5 ++-
 arch/x86/pci/pcbios.c |   16 ++++++-----
 arch/x86/pci/pci.h    |    8 -----
 7 files changed, 45 insertions(+), 52 deletions(-)

diff -puN arch/x86/pci/direct.c~x86-pci-replace-dbg-with-pr_debug arch/x86/pci/direct.c
--- a/arch/x86/pci/direct.c~x86-pci-replace-dbg-with-pr_debug
+++ a/arch/x86/pci/direct.c
@@ -213,7 +213,7 @@ static int __init pci_sanity_check(struc
 			return 1;
 	}
 
-	DBG(KERN_WARNING "PCI: Sanity check failed\n");
+	pr_warning("PCI: Sanity check failed\n");
 	return 0;
 }
 
diff -puN arch/x86/pci/i386.c~x86-pci-replace-dbg-with-pr_debug arch/x86/pci/i386.c
--- a/arch/x86/pci/i386.c~x86-pci-replace-dbg-with-pr_debug
+++ a/arch/x86/pci/i386.c
@@ -166,7 +166,7 @@ static void __init pcibios_allocate_reso
 			else
 				disabled = !(command & PCI_COMMAND_MEMORY);
 			if (pass == disabled) {
-				DBG("PCI: Resource %08lx-%08lx "
+				pr_warning("PCI: Resource %08lx-%08lx "
 				    "(f=%lx, d=%d, p=%d)\n",
 				    r->start, r->end, r->flags, disabled, pass);
 				pr = pci_find_parent_resource(dev, r);
@@ -187,7 +187,7 @@ static void __init pcibios_allocate_reso
 				/* Turn the ROM off, leave the resource region,
 				 * but keep it unregistered. */
 				u32 reg;
-				DBG("PCI: Switching off ROM of %s\n",
+				pr_warning("PCI: Switching off ROM of %s\n",
 					pci_name(dev));
 				r->flags &= ~IORESOURCE_ROM_ENABLE;
 				pci_read_config_dword(dev,
@@ -229,7 +229,7 @@ static int __init pcibios_assign_resourc
 
 void __init pcibios_resource_survey(void)
 {
-	DBG("PCI: Allocating resources\n");
+	pr_debug("PCI: Allocating resources\n");
 	pcibios_allocate_bus_resources(&pci_root_buses);
 	pcibios_allocate_resources(0);
 	pcibios_allocate_resources(1);
diff -puN arch/x86/pci/irq.c~x86-pci-replace-dbg-with-pr_debug arch/x86/pci/irq.c
--- a/arch/x86/pci/irq.c~x86-pci-replace-dbg-with-pr_debug
+++ a/arch/x86/pci/irq.c
@@ -78,8 +78,7 @@ static inline struct irq_routing_table *
 	for (i = 0; i < rt->size; i++)
 		sum += addr[i];
 	if (!sum) {
-		DBG(KERN_DEBUG "PCI: Interrupt Routing Table found at 0x%p\n",
-			rt);
+		pr_debug("PCI: Interrupt Routing Table found at 0x%p\n", rt);
 		return rt;
 	}
 	return NULL;
@@ -126,15 +125,13 @@ static void __init pirq_peer_trick(void)
 	memset(busmap, 0, sizeof(busmap));
 	for (i = 0; i < (rt->size - sizeof(struct irq_routing_table)) / sizeof(struct irq_info); i++) {
 		e = &rt->slots[i];
-#ifdef DEBUG
-		{
-			int j;
-			DBG(KERN_DEBUG "%02x:%02x slot=%02x", e->bus, e->devfn/8, e->slot);
-			for (j = 0; j < 4; j++)
-				DBG(" %d:%02x/%04x", j, e->irq[j].link, e->irq[j].bitmap);
-			DBG("\n");
-		}
-#endif
+		pr_debug("%02x:%02x slot=%02x "
+			 "0:%02x/%04x 1:%02x/%04x 2:%02x/%04x 3:%02x/%04x\n",
+			 e->bus, e->devfn/8, e->slot,
+			 e->irq[0].link, e->irq[0].bitmap,
+			 e->irq[1].link, e->irq[1].bitmap,
+			 e->irq[2].link, e->irq[2].bitmap,
+			 e->irq[3].link, e->irq[3].bitmap);
 		busmap[e->bus] = 1;
 	}
 	for (i = 1; i < 256; i++) {
@@ -167,7 +164,7 @@ void eisa_set_level_irq(unsigned int irq
 	printk(KERN_DEBUG "PCI: setting IRQ %u as level-triggered\n", irq);
 	val = inb(port);
 	if (!(val & mask)) {
-		DBG(KERN_DEBUG " -> edge");
+		pr_debug(" -> edge");
 		outb(val | mask, port);
 	}
 }
@@ -820,13 +817,13 @@ static void __init pirq_find_router(stru
 	r->get = NULL;
 	r->set = NULL;
 
-	DBG(KERN_DEBUG "PCI: Attempting to find IRQ router for %04x:%04x\n",
-	    rt->rtr_vendor, rt->rtr_device);
+	pr_debug("PCI: Attempting to find IRQ router for [%04x/%04x]\n",
+		 rt->rtr_vendor, rt->rtr_device);
 
 	pirq_router_dev = pci_get_bus_and_slot(rt->rtr_bus, rt->rtr_devfn);
 	if (!pirq_router_dev) {
-		DBG(KERN_DEBUG "PCI: Interrupt router not found at "
-			"%02x:%02x\n", rt->rtr_bus, rt->rtr_devfn);
+		pr_debug("PCI: IRQ router not found at %02x:%02x\n",
+			 rt->rtr_bus, rt->rtr_devfn);
 		return;
 	}
 
@@ -877,7 +874,7 @@ static int pcibios_lookup_irq(struct pci
 	/* Find IRQ pin */
 	pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
 	if (!pin) {
-		DBG(KERN_DEBUG " -> no interrupt pin\n");
+		pr_debug(KERN_DEBUG " -> no interrupt pin\n");
 		return 0;
 	}
 	pin = pin - 1;
@@ -887,19 +884,19 @@ static int pcibios_lookup_irq(struct pci
 	if (!pirq_table)
 		return 0;
 
-	DBG(KERN_DEBUG "IRQ for %s[%c]", pci_name(dev), 'A' + pin);
+	pr_debug(KERN_DEBUG "IRQ for %s[%c]", pci_name(dev), 'A' + pin);
 	info = pirq_get_info(dev);
 	if (!info) {
-		DBG(" -> not found in routing table\n" KERN_DEBUG);
+		pr_debug(" -> not found in routing table\n" KERN_DEBUG);
 		return 0;
 	}
 	pirq = info->irq[pin].link;
 	mask = info->irq[pin].bitmap;
 	if (!pirq) {
-		DBG(" -> not routed\n" KERN_DEBUG);
+		pr_debug(" -> not routed\n" KERN_DEBUG);
 		return 0;
 	}
-	DBG(" -> PIRQ %02x, mask %04x, excl %04x", pirq, mask,
+	pr_debug(" -> PIRQ %02x, mask %04x, excl %04x", pirq, mask,
 		pirq_table->exclusive_irqs);
 	mask &= pcibios_irq_mask;
 
@@ -944,31 +941,31 @@ static int pcibios_lookup_irq(struct pci
 				newirq = i;
 		}
 	}
-	DBG(" -> newirq=%d", newirq);
+	pr_debug(" -> newirq=%d", newirq);
 
 	/* Check if it is hardcoded */
 	if ((pirq & 0xf0) == 0xf0) {
 		irq = pirq & 0xf;
-		DBG(" -> hardcoded IRQ %d\n", irq);
+		pr_debug(" -> hardcoded IRQ %d\n", irq);
 		msg = "Hardcoded";
 	} else if (r->get && (irq = r->get(pirq_router_dev, dev, pirq)) && \
 	((!(pci_probe & PCI_USE_PIRQ_MASK)) || ((1 << irq) & mask))) {
-		DBG(" -> got IRQ %d\n", irq);
+		pr_debug(" -> got IRQ %d\n", irq);
 		msg = "Found";
 		eisa_set_level_irq(irq);
 	} else if (newirq && r->set &&
 		(dev->class >> 8) != PCI_CLASS_DISPLAY_VGA) {
-		DBG(" -> assigning IRQ %d", newirq);
+		pr_debug(" -> assigning IRQ %d", newirq);
 		if (r->set(pirq_router_dev, dev, pirq, newirq)) {
 			eisa_set_level_irq(newirq);
-			DBG(" ... OK\n");
+			pr_debug(" ... OK\n");
 			msg = "Assigned";
 			irq = newirq;
 		}
 	}
 
 	if (!irq) {
-		DBG(" ... failed\n");
+		pr_debug(" ... failed\n");
 		if (newirq && mask == (1 << newirq)) {
 			msg = "Guessed";
 			irq = newirq;
@@ -1017,7 +1014,7 @@ static void __init pcibios_fixup_irqs(vo
 	struct pci_dev *dev = NULL;
 	u8 pin;
 
-	DBG(KERN_DEBUG "PCI: IRQ fixup\n");
+	pr_debug("PCI: IRQ fixup\n");
 	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
 		/*
 		 * If the BIOS has set an out of range IRQ number, just
@@ -1025,7 +1022,7 @@ static void __init pcibios_fixup_irqs(vo
 		 * already in use.
 		 */
 		if (dev->irq >= 16) {
-			DBG(KERN_DEBUG "%s: ignoring bogus IRQ %d\n",
+			pr_debug(KERN_DEBUG "%s: ignoring bogus IRQ %d\n",
 				pci_name(dev), dev->irq);
 			dev->irq = 0;
 		}
@@ -1142,7 +1139,7 @@ static struct dmi_system_id __initdata p
 
 int __init pcibios_irq_init(void)
 {
-	DBG(KERN_DEBUG "PCI: IRQ init\n");
+	pr_debug("PCI: IRQ init\n");
 
 	if (pcibios_enable_irq || raw_pci_ops == NULL)
 		return 0;
diff -puN arch/x86/pci/legacy.c~x86-pci-replace-dbg-with-pr_debug arch/x86/pci/legacy.c
--- a/arch/x86/pci/legacy.c~x86-pci-replace-dbg-with-pr_debug
+++ a/arch/x86/pci/legacy.c
@@ -16,7 +16,7 @@ static void __devinit pcibios_fixup_peer
 
 	if (pcibios_last_bus <= 0 || pcibios_last_bus >= 0xff)
 		return;
-	DBG("PCI: Peer bridge fixup\n");
+	pr_debug("PCI: Peer bridge fixup\n");
 
 	for (n=0; n <= pcibios_last_bus; n++) {
 		u32 l;
@@ -26,7 +26,8 @@ static void __devinit pcibios_fixup_peer
 		for (devfn = 0; devfn < 256; devfn += 8) {
 			if (!raw_pci_read(0, n, devfn, PCI_VENDOR_ID, 2, &l) &&
 			    l != 0x0000 && l != 0xffff) {
-				DBG("Found device at %02x:%02x [%04x]\n", n, devfn, l);
+				pr_debug("%02x:%02x found device "
+					 "[vendor %04x]\n", n, devfn, l);
 				printk(KERN_INFO "PCI: Discovered peer bus %02x\n", n);
 				pci_scan_bus_on_node(n, &pci_root_ops, node);
 				break;
diff -puN arch/x86/pci/pcbios.c~x86-pci-replace-dbg-with-pr_debug arch/x86/pci/pcbios.c
--- a/arch/x86/pci/pcbios.c~x86-pci-replace-dbg-with-pr_debug
+++ a/arch/x86/pci/pcbios.c
@@ -132,8 +132,9 @@ static int __devinit check_pcibios(void)
 		minor_ver = ebx & 0xff;
 		if (pcibios_last_bus < 0)
 			pcibios_last_bus = ecx & 0xff;
-		DBG("PCI: BIOS probe returned s=%02x hw=%02x ver=%02x.%02x l=%02x\n",
-			status, hw_mech, major_ver, minor_ver, pcibios_last_bus);
+		pr_debug("PCI: BIOS probe returned s=%02x hw=%02x "
+			 "ver=%02x.%02x l=%02x\n", status, hw_mech, major_ver,
+			 minor_ver, pcibios_last_bus);
 		if (status || signature != PCI_SIGNATURE) {
 			printk (KERN_ERR "PCI: BIOS BUG #%x[%08x] found\n",
 				status, signature);
@@ -322,15 +323,16 @@ static struct pci_raw_ops * __devinit pc
 				check->fields.revision, check);
 			continue;
 		}
-		DBG("PCI: BIOS32 Service Directory structure at 0x%p\n", check);
+		pr_debug("PCI: BIOS32 Service Directory structure at 0x%p\n",
+			 check);
 		if (check->fields.entry >= 0x100000) {
 			printk("PCI: BIOS32 entry (0x%p) in high memory, "
 					"cannot use.\n", check);
 			return NULL;
 		} else {
 			unsigned long bios32_entry = check->fields.entry;
-			DBG("PCI: BIOS32 Service Directory entry at 0x%lx\n",
-					bios32_entry);
+			pr_debug("PCI: BIOS32 Service Directory entry at "
+				 "0x%lx\n", bios32_entry);
 			bios32_indirect.address = bios32_entry + PAGE_OFFSET;
 			if (check_pcibios())
 				return &pci_bios_access;
@@ -367,7 +369,7 @@ struct irq_routing_table * pcibios_get_i
 	opt.size = PAGE_SIZE;
 	opt.segment = __KERNEL_DS;
 
-	DBG("PCI: Fetching IRQ routing table... ");
+	pr_debug("PCI: Fetching IRQ routing table...\n");
 	__asm__("push %%es\n\t"
 		"push %%ds\n\t"
 		"pop  %%es\n\t"
@@ -385,7 +387,7 @@ struct irq_routing_table * pcibios_get_i
 		  "S" (&pci_indirect),
 		  "m" (opt)
 		: "memory");
-	DBG("OK  ret=%d, size=%d, map=%x\n", ret, opt.size, map);
+	pr_debug("OK  ret=%d, size=%d, map=%x\n", ret, opt.size, map);
 	if (ret & 0xff00)
 		printk(KERN_ERR "PCI: Error %02x when fetching IRQ routing table.\n", (ret >> 8) & 0xff);
 	else if (opt.size) {
diff -puN arch/x86/pci/pci.h~x86-pci-replace-dbg-with-pr_debug arch/x86/pci/pci.h
--- a/arch/x86/pci/pci.h~x86-pci-replace-dbg-with-pr_debug
+++ a/arch/x86/pci/pci.h
@@ -4,14 +4,6 @@
  *	(c) 1999 Martin Mares <mj@ucw.cz>
  */
 
-#undef DEBUG
-
-#ifdef DEBUG
-#define DBG(x...) printk(x)
-#else
-#define DBG(x...)
-#endif
