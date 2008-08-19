From: akpm@linux-foundation.org
Subject: - char-cyclades-remove-bogus-iomap.patch removed from -mm tree
Date: Tue, 19 Aug 2008 15:40:28 -0700
Message-ID: <200808192240.m7JMeSQ2010651@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41834 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751684AbYHSWkl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Aug 2008 18:40:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, R.E.Wolff@BitWizard.nl, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: cyclades, remove bogus iomap
has been removed from the -mm tree.  Its filename was
     char-cyclades-remove-bogus-iomap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: cyclades, remove bogus iomap
From: Jiri Slaby <jirislaby@gmail.com>

readl/writel are not expected to accept iomap return value. Replace
bogus mapping by standard ioremap.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: <R.E.Wolff@BitWizard.nl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-remove-bogus-iomap drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-remove-bogus-iomap
+++ a/drivers/char/cyclades.c
@@ -4993,12 +4993,14 @@ static int __devinit cy_pci_probe(struct
 			device_id == PCI_DEVICE_ID_CYCLOM_Y_Hi) {
 		card_name = "Cyclom-Y";
 
-		addr0 = pci_iomap(pdev, 0, CyPCI_Yctl);
+		addr0 = ioremap_nocache(pci_resource_start(pdev, 0),
+				CyPCI_Yctl);
 		if (addr0 == NULL) {
 			dev_err(&pdev->dev, "can't remap ctl region\n");
 			goto err_reg;
 		}
-		addr2 = pci_iomap(pdev, 2, CyPCI_Ywin);
+		addr2 = ioremap_nocache(pci_resource_start(pdev, 2),
+				CyPCI_Ywin);
 		if (addr2 == NULL) {
 			dev_err(&pdev->dev, "can't remap base region\n");
 			goto err_unmap;
@@ -5013,7 +5015,8 @@ static int __devinit cy_pci_probe(struct
 	} else if (device_id == PCI_DEVICE_ID_CYCLOM_Z_Hi) {
 		struct RUNTIME_9060 __iomem *ctl_addr;
 
-		ctl_addr = addr0 = pci_iomap(pdev, 0, CyPCI_Zctl);
+		ctl_addr = addr0 = ioremap_nocache(pci_resource_start(pdev, 0),
+				CyPCI_Zctl);
 		if (addr0 == NULL) {
 			dev_err(&pdev->dev, "can't remap ctl region\n");
 			goto err_reg;
@@ -5026,8 +5029,8 @@ static int __devinit cy_pci_probe(struct
 
 		mailbox = (u32)readl(&ctl_addr->mail_box_0);
 
-		addr2 = pci_iomap(pdev, 2, mailbox == ZE_V1 ?
-				CyPCI_Ze_win : CyPCI_Zwin);
+		addr2 = ioremap_nocache(pci_resource_start(pdev, 2),
+				mailbox == ZE_V1 ? CyPCI_Ze_win : CyPCI_Zwin);
 		if (addr2 == NULL) {
 			dev_err(&pdev->dev, "can't remap base region\n");
 			goto err_unmap;
@@ -5159,9 +5162,9 @@ err_null:
 	cy_card[card_no].base_addr = NULL;
 	free_irq(irq, &cy_card[card_no]);
 err_unmap:
-	pci_iounmap(pdev, addr0);
+	iounmap(addr0);
 	if (addr2)
-		pci_iounmap(pdev, addr2);
+		iounmap(addr2);
 err_reg:
 	pci_release_regions(pdev);
 err_dis:
@@ -5186,9 +5189,9 @@ static void __devexit cy_pci_remove(stru
 		cy_writew(cinfo->ctl_addr + 0x68,
 				readw(cinfo->ctl_addr + 0x68) & ~0x0900);
 
-	pci_iounmap(pdev, cinfo->base_addr);
+	iounmap(cinfo->base_addr);
 	if (cinfo->ctl_addr)
-		pci_iounmap(pdev, cinfo->ctl_addr);
+		iounmap(cinfo->ctl_addr);
 	if (cinfo->irq
 #ifndef CONFIG_CYZ_INTR
 		&& !IS_CYC_Z(*cinfo)
_

Patches currently in -mm which might be from jirislaby@gmail.com are

linux-next.patch
ath5k-unify-resets.patch
char-sx-remove-bogus-iomap.patch
mm-owner-fix-race-between-swap-and-exit-fix.patch
viafb-viafbdevc-viafbdevh.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
ip2-avoid-add_timer-with-pending-timer.patch
char-ds1286-eliminate-busy-waiting.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

