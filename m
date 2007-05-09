From: akpm@linux-foundation.org
Subject: - char-cyclades-irq-is-int.patch removed from -mm tree
Date: Tue, 08 May 2007 19:57:32 -0700
Message-ID: <200705090257.l492vWYE010204@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33107 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032796AbXEIC5f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:57:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: cyclades, irq is int
has been removed from the -mm tree.  Its filename was
     char-cyclades-irq-is-int.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: cyclades, irq is int
From: Jiri Slaby <jirislaby@gmail.com>

don't fetch it to uchar

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |   30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-irq-is-int drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-irq-is-int
+++ a/drivers/char/cyclades.c
@@ -4916,7 +4916,7 @@ static int __devinit cy_init_Ze(unsigned
 	/* set cy_card */
 	cy_card[j].base_addr = cy_pci_addr2;
 	cy_card[j].ctl_addr = cy_pci_addr0;
-	cy_card[j].irq = (int)cy_pci_irq;
+	cy_card[j].irq = cy_pci_irq;
 	cy_card[j].bus_index = 1;
 	cy_card[j].first_line = cy_next_channel;
 	cy_card[j].num_chips = -1;
@@ -4929,8 +4929,7 @@ static int __devinit cy_init_Ze(unsigned
 	if ((cy_pci_irq != 0) && (cy_pci_irq != 255))
 		printk("Cyclades-Ze/PCI #%d: 0x%lx-0x%lx, IRQ%d, ",
 			j + 1, (ulong) cy_pci_phys2,
-			(ulong) (cy_pci_phys2 + CyPCI_Ze_win - 1),
-			(int)cy_pci_irq);
+			(ulong) (cy_pci_phys2 + CyPCI_Ze_win - 1), cy_pci_irq);
 	else
 #endif				/* CONFIG_CYZ_INTR */
 		printk("Cyclades-Ze/PCI #%d: 0x%lx-0x%lx, ",
@@ -4950,7 +4949,7 @@ static int __devinit cy_pci_probe(struct
 		const struct pci_device_id *ent)
 {
 	unsigned char cyy_rev_id;
-	unsigned char cy_pci_irq;
+	int cy_pci_irq;
 	__u32 cy_pci_phys0, cy_pci_phys2, mailbox;
 	void __iomem *cy_pci_addr0, *cy_pci_addr2;
 	unsigned int device_id;
@@ -4976,8 +4975,7 @@ static int __devinit cy_pci_probe(struct
 #ifdef CY_PCI_DEBUG
 		printk("Cyclom-Y/PCI (bus=0x0%x, pci_id=0x%x, ",
 			pdev->bus->number, pdev->devfn);
-		printk("rev_id=%d) IRQ%d\n",
-			cyy_rev_id, (int)cy_pci_irq);
+		printk("rev_id=%d) IRQ%d\n", cyy_rev_id, cy_pci_irq);
 		printk("Cyclom-Y/PCI:found  winaddr=0x%lx "
 			"ctladdr=0x%lx\n",
 			(ulong)cy_pci_phys2, (ulong)cy_pci_phys0);
@@ -5003,7 +5001,7 @@ static int __devinit cy_pci_probe(struct
 			printk("Cyclom-Y/PCI (bus=0x0%x, pci_id=0x%x, ",
 				pdev->bus->number, pdev->devfn);
 			printk("rev_id=%d) IRQ%d\n",
-				cyy_rev_id, (int)cy_pci_irq);
+				cyy_rev_id, cy_pci_irq);
 			printk("Cyclom-Y/PCI:found  winaddr=0x%lx "
 				"ctladdr=0x%lx\n",
 				(ulong)cy_pci_phys2,
@@ -5065,7 +5063,7 @@ static int __devinit cy_pci_probe(struct
 		/* set cy_card */
 		cy_card[j].base_addr = cy_pci_addr2;
 		cy_card[j].ctl_addr = cy_pci_addr0;
-		cy_card[j].irq = (int)cy_pci_irq;
+		cy_card[j].irq = cy_pci_irq;
 		cy_card[j].bus_index = 1;
 		cy_card[j].first_line = cy_next_channel;
 		cy_card[j].num_chips = cy_pci_nchan / 4;
@@ -5101,8 +5099,7 @@ static int __devinit cy_pci_probe(struct
 		/* print message */
 		printk("Cyclom-Y/PCI #%d: 0x%lx-0x%lx, IRQ%d, ",
 			j + 1, (ulong)cy_pci_phys2,
-			(ulong) (cy_pci_phys2 + CyPCI_Ywin - 1),
-			(int)cy_pci_irq);
+			(ulong) (cy_pci_phys2 + CyPCI_Ywin - 1), cy_pci_irq);
 		printk("%d channels starting from port %d.\n",
 			cy_pci_nchan, cy_next_channel);
 		for (j = cy_next_channel;
@@ -5114,8 +5111,7 @@ static int __devinit cy_pci_probe(struct
 		/* print message */
 		printk("Cyclades-Z/PCI (bus=0x0%x, pci_id=0x%x, ",
 			pdev->bus->number, pdev->devfn);
-		printk("rev_id=%d) IRQ%d\n",
-			cyy_rev_id, (int)cy_pci_irq);
+		printk("rev_id=%d) IRQ%d\n", cyy_rev_id, cy_pci_irq);
 		printk("Cyclades-Z/PCI: found winaddr=0x%lx "
 			"ctladdr=0x%lx\n",
 			(ulong)cy_pci_phys2, (ulong)cy_pci_phys0);
@@ -5126,8 +5122,7 @@ static int __devinit cy_pci_probe(struct
 #ifdef CY_PCI_DEBUG
 		printk("Cyclades-Z/PCI (bus=0x0%x, pci_id=0x%x, ",
 			pdev->bus->number, pdev->devfn);
-		printk("rev_id=%d) IRQ%d\n",
-			cyy_rev_id, (int)cy_pci_irq);
+		printk("rev_id=%d) IRQ%d\n", cyy_rev_id, cy_pci_irq);
 		printk("Cyclades-Z/PCI: found winaddr=0x%lx "
 			"ctladdr=0x%lx\n",
 			(ulong) cy_pci_phys2, (ulong) cy_pci_phys0);
@@ -5144,8 +5139,7 @@ static int __devinit cy_pci_probe(struct
 		   re-write it to the PCI config. registers.
 		   This will remain here until we find a permanent
 		   fix. */
-		pci_write_config_byte(pdev, PCI_INTERRUPT_LINE,
-					cy_pci_irq);
+		pci_write_config_byte(pdev, PCI_INTERRUPT_LINE, cy_pci_irq);
 
 		mailbox = (__u32)readl(&((struct RUNTIME_9060 __iomem *)
 				cy_pci_addr0)->mail_box_0);
@@ -5249,7 +5243,7 @@ static int __devinit cy_pci_probe(struct
 		/* set cy_card */
 		cy_card[j].base_addr = cy_pci_addr2;
 		cy_card[j].ctl_addr = cy_pci_addr0;
-		cy_card[j].irq = (int)cy_pci_irq;
+		cy_card[j].irq = cy_pci_irq;
 		cy_card[j].bus_index = 1;
 		cy_card[j].first_line = cy_next_channel;
 		cy_card[j].num_chips = -1;
@@ -5263,7 +5257,7 @@ static int __devinit cy_pci_probe(struct
 			printk("Cyclades-8Zo/PCI #%d: 0x%lx-0x%lx, "
 				"IRQ%d, ", j + 1, (ulong)cy_pci_phys2,
 				(ulong) (cy_pci_phys2 + CyPCI_Zwin - 1),
-				(int)cy_pci_irq);
+				cy_pci_irq);
 		else
 #endif				/* CONFIG_CYZ_INTR */
 			printk("Cyclades-8Zo/PCI #%d: 0x%lx-0x%lx, ",
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-dvb.patch
cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
vmstat-use-our-own-timer-events-fix.patch
shrink_slab-handle-bad-shrinkers.patch
