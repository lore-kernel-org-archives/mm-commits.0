From: akpm@linux-foundation.org
Subject: + char-cyclades-use-pci_iomap-unmap.patch added to -mm tree
Date: Thu, 19 Apr 2007 21:53:57 -0700
Message-ID: <200704200453.l3K4rv02007141@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52094 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161128AbXDTEyA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 00:54:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: cyclades, use pci_iomap/unmap
has been added to the -mm tree.  Its filename is
     char-cyclades-use-pci_iomap-unmap.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: cyclades, use pci_iomap/unmap
From: Jiri Slaby <jirislaby@gmail.com>

fork remove code for pci -- move it to separate, new, function and don't care
about pci in the former.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |   42 ++++++++++++++++++++++++++++----------
 1 file changed, 32 insertions(+), 10 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-use-pci_iomap-unmap drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-use-pci_iomap-unmap
+++ a/drivers/char/cyclades.c
@@ -4775,6 +4775,7 @@ static int __devinit cy_init_Ze(unsigned
 	cy_card[j].first_line = cy_next_channel;
 	cy_card[j].num_chips = -1;
 	cy_card[j].pdev = pdev;
+	pci_set_drvdata(pdev, &cy_card[j]);
 
 	/* print message */
 #ifdef CONFIG_CYZ_INTR
@@ -4889,8 +4890,8 @@ static int __init cy_detect_pci(void)
 				continue;
 			}
 #endif
-			cy_pci_addr0 = ioremap(cy_pci_phys0, CyPCI_Yctl);
-			cy_pci_addr2 = ioremap(cy_pci_phys2, CyPCI_Ywin);
+			cy_pci_addr0 = pci_iomap(pdev, 0, CyPCI_Yctl);
+			cy_pci_addr2 = pci_iomap(pdev, 2, CyPCI_Ywin);
 
 #ifdef CY_PCI_DEBUG
 			printk("Cyclom-Y/PCI: relocate winaddr=0x%lx "
@@ -4948,6 +4949,7 @@ static int __init cy_detect_pci(void)
 			cy_card[j].first_line = cy_next_channel;
 			cy_card[j].num_chips = cy_pci_nchan / 4;
 			cy_card[j].pdev = pdev;
+			pci_set_drvdata(pdev, &cy_card[j]);
 
 			/* enable interrupts in the PCI interface */
 			plx_ver = readb(cy_pci_addr2 + CyPLX_VER) & 0x0f;
@@ -5006,7 +5008,7 @@ static int __init cy_detect_pci(void)
 				"ctladdr=0x%lx\n",
 				(ulong) cy_pci_phys2, (ulong) cy_pci_phys0);
 #endif
-			cy_pci_addr0 = ioremap(cy_pci_phys0, CyPCI_Zctl);
+			cy_pci_addr0 = pci_iomap(pdev, 0, CyPCI_Zctl);
 
 			/* Disable interrupts on the PLX before resetting it */
 			cy_writew(cy_pci_addr0 + 0x68,
@@ -5040,8 +5042,7 @@ static int __init cy_detect_pci(void)
 			}
 
 			if (mailbox == ZE_V1) {
-				cy_pci_addr2 = ioremap(cy_pci_phys2,
-						CyPCI_Ze_win);
+				cy_pci_addr2 = pci_iomap(pdev, 2, CyPCI_Ze_win);
 				if (ZeIndex == NR_CARDS) {
 					printk("Cyclades-Ze/PCI found at "
 						"0x%lx but no more cards can "
@@ -5061,7 +5062,7 @@ static int __init cy_detect_pci(void)
 				i--;
 				continue;
 			} else {
-				cy_pci_addr2 = ioremap(cy_pci_phys2,CyPCI_Zwin);
+				cy_pci_addr2 = pci_iomap(pdev, 2, CyPCI_Zwin);
 			}
 
 #ifdef CY_PCI_DEBUG
@@ -5145,6 +5146,7 @@ static int __init cy_detect_pci(void)
 			cy_card[j].first_line = cy_next_channel;
 			cy_card[j].num_chips = -1;
 			cy_card[j].pdev = pdev;
+			pci_set_drvdata(pdev, &cy_card[j]);
 
 			/* print message */
 #ifdef CONFIG_CYZ_INTR
@@ -5198,6 +5200,26 @@ static int __init cy_detect_pci(void)
 #endif				/* ifdef CONFIG_PCI */
 }				/* cy_detect_pci */
 
+static void __devexit cy_pci_release(struct pci_dev *pdev)
+{
+#ifdef CONFIG_PCI
+	struct cyclades_card *cinfo = pci_get_drvdata(pdev);
+
+	pci_iounmap(pdev, cinfo->base_addr);
+	if (cinfo->ctl_addr)
+		pci_iounmap(pdev, cinfo->ctl_addr);
+	if (cinfo->irq
+#ifndef CONFIG_CYZ_INTR
+		&& cinfo->num_chips != -1 /* not a Z card */
+#endif /* CONFIG_CYZ_INTR */
+		)
+		free_irq(cinfo->irq, cinfo);
+	pci_release_regions(pdev);
+
+	cinfo->base_addr = NULL;
+#endif
+}
+
 /*
  * This routine prints out the appropriate serial driver version number
  * and identifies which options were configured into this driver.
@@ -5546,6 +5568,10 @@ static void __exit cy_cleanup_module(voi
 
 	for (i = 0; i < NR_CARDS; i++) {
 		if (cy_card[i].base_addr) {
+			if (cy_card[i].pdev) {
+				cy_pci_release(cy_card[i].pdev);
+				continue;
+			}
 			iounmap(cy_card[i].base_addr);
 			if (cy_card[i].ctl_addr)
 				iounmap(cy_card[i].ctl_addr);
@@ -5555,10 +5581,6 @@ static void __exit cy_cleanup_module(voi
 #endif /* CONFIG_CYZ_INTR */
 				)
 				free_irq(cy_card[i].irq, &cy_card[i]);
-#ifdef CONFIG_PCI
-			if (cy_card[i].pdev)
-				pci_release_regions(cy_card[i].pdev);
-#endif
 		}
 	}
 } /* cy_cleanup_module */
_

Patches currently in -mm which might be from jirislaby@gmail.com are

acpi-asus_acpi-support-f2je-model.patch
char-rocket-add-module_device_table.patch
char-cs5535_gpio-add-module_device_table.patch
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
shrink_slab-handle-bad-shrinkers.patch
