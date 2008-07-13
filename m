From: akpm@linux-foundation.org
Subject: + x86-pci-replace-dbg-with-pr_debug.patch added to -mm tree
Date: Sat, 12 Jul 2008 23:03:01 -0700
Message-ID: <200807130603.m6D631hx007070@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41715 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751965AbYGMGDa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jul 2008 02:03:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, jbarnes@virtuousgeek.org, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86 PCI: replace DBG() with pr_debug()
has been added to the -mm tree.  Its filename is
     x86-pci-replace-dbg-with-pr_debug.patch

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/pci/direct.c |    2 +-
 arch/x86/pci/i386.c   |    2 +-
 arch/x86/pci/irq.c    |   35 +++++++++++++++--------------------
 arch/x86/pci/legacy.c |    5 +++--
 arch/x86/pci/pcbios.c |   16 +++++++++-------
 arch/x86/pci/pci.h    |    8 --------
 6 files changed, 29 insertions(+), 39 deletions(-)

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
@@ -226,7 +226,7 @@ static int __init pcibios_assign_resourc
 
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
@@ -128,17 +127,13 @@ static void __init pirq_peer_trick(void)
 	for (i = 0; i < (rt->size - sizeof(struct irq_routing_table)) /
 		sizeof(struct irq_info); i++) {
 		e = &rt->slots[i];
-#ifdef DEBUG
-		{
-			int j;
-			DBG(KERN_DEBUG "%02x:%02x slot=%02x", e->bus,
-				e->devfn/8, e->slot);
-			for (j = 0; j < 4; j++)
-				DBG(" %d:%02x/%04x", j, e->irq[j].link,
-					e->irq[j].bitmap);
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
@@ -171,7 +166,7 @@ void eisa_set_level_irq(unsigned int irq
 	printk(KERN_DEBUG "PCI: setting IRQ %u as level-triggered\n", irq);
 	val = inb(port);
 	if (!(val & mask)) {
-		DBG(KERN_DEBUG " -> edge");
+		pr_debug(" -> edge");
 		outb(val | mask, port);
 	}
 }
@@ -853,13 +848,13 @@ static void __init pirq_find_router(stru
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
 
@@ -1042,7 +1037,7 @@ static void __init pcibios_fixup_irqs(vo
 	struct pci_dev *dev = NULL;
 	u8 pin;
 
-	DBG(KERN_DEBUG "PCI: IRQ fixup\n");
+	pr_debug("PCI: IRQ fixup\n");
 	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
 		/*
 		 * If the BIOS has set an out of range IRQ number, just
@@ -1172,7 +1167,7 @@ static struct dmi_system_id __initdata p
 
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
