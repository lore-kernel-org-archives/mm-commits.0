From: akpm@linux-foundation.org
Subject: + char-cyclades-irq-is-int.patch added to -mm tree
Date: Thu, 03 May 2007 23:45:27 -0700
Message-ID: <200705040645.l446jR74030871@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965706AbXEDGpc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 02:45:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: cyclades, irq is int
has been added to the -mm tree.  Its filename is
     char-cyclades-irq-is-int.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

serial-serial_core-use-pr_debug.patch
cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
char-rocket-add-module_device_table.patch
char-cs5535_gpio-add-module_device_table.patch
drivers-char-use-__set_current_state.patch
misc-add-sensable-phantom-driver.patch
misc-add-sensable-phantom-driver-v3.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
char-cyclades-remove-pause.patch
char-cyclades-cy_readx-writex-cleanup.patch
char-cyclades-timer-cleanup.patch
char-cyclades-remove-volatiles.patch
char-cyclades-remove-useless-casts.patch
char-cyclades-create-cy_init_ze.patch
char-cyclades-use-pci_iomap-unmap.patch
char-cyclades-init-ze-immediately.patch
char-cyclades-create-cy_pci_probe.patch
char-cyclades-move-card-entries-init-into-function.patch
char-cyclades-init-card-struct-immediately.patch
char-cyclades-remove-some-global-vars.patch
char-cyclades-cy_init-error-handling.patch
char-cyclades-tty_register_device-separately-for-each-device.patch
char-cyclades-clear-interrupts-before-releasing.patch
char-cyclades-allow-debug_shirq.patch
char-mxser-schedule-for-removal.patch
char-isicom-use-pr_debug.patch
char-cyclades-use-is_cyc_z-macro.patch
char-cyclades-switch-to-pci-probing.patch
char-cyclades-depends-on-pci-or-isa.patch
char-cyclades-unexport-struct-cyclades_card.patch
char-cyclades-remove-useless-fileds-from-cyclades_card.patch
char-cyclades-irq-is-int.patch
char-cyclades-printk-cleanups.patch
char-cyclades-mark-cyy_init_card-as-__devinit-not-__init.patch
char-cyclades-simplify-variables-initialization.patch
char-cyclades-get-rid-of-phys-addresses.patch
char-cyclades-make-info-card-a-pointer.patch
char-cyclades-remove-sleep_on.patch
char-cyclades-fix-blockmove.patch
char-cyclades-timers-cleanup.patch
char-cyclades-remove-unused-timestamps.patch
char-cyclades-remove-locking-macros.patch
char-cyclades-conditions-cleanup.patch
char-cyclades-fix-tty-device-unregister.patch
char-cyclades-dynamic-ports.patch
char-cyclades-probe-cleanup.patch
char-cyclades-copyright-and-version-changes.patch
shrink_slab-handle-bad-shrinkers.patch
