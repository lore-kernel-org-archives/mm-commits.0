From: akpm@linux-foundation.org
Subject: - char-cyclades-switch-to-pci-probing.patch removed from -mm tree
Date: Tue, 08 May 2007 19:57:24 -0700
Message-ID: <200705090257.l492vOZA010184@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56521 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032773AbXEIC51 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:57:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: cyclades, switch to pci probing
has been removed from the -mm tree.  Its filename was
     char-cyclades-switch-to-pci-probing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: cyclades, switch to pci probing
From: Jiri Slaby <jirislaby@gmail.com>

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |   65 +++++++++-----------------------------
 1 file changed, 17 insertions(+), 48 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-switch-to-pci-probing drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-switch-to-pci-probing
+++ a/drivers/char/cyclades.c
@@ -5297,46 +5297,9 @@ static int __devinit cy_pci_probe(struct
 
 	return 0;
 }
-#endif
-
-/*
- * ---------------------------------------------------------------------
- * cy_detect_pci() - Test PCI bus presence and Cyclom-Ye/PCI.
- * sets global variables and return the number of PCI boards found.
- * ---------------------------------------------------------------------
- */
-static int __init cy_detect_pci(void)
-{
-#ifdef CONFIG_PCI
-	struct pci_dev *pdev = NULL;
-	unsigned int i, device_id, dev_index = 0;
-
-	for (i = 0; i < NR_CARDS; i++) {
-		/* look for a Cyclades card by vendor and device id */
-		while ((device_id = cy_pci_dev_id[dev_index].device) != 0) {
-			if ((pdev = pci_get_device(PCI_VENDOR_ID_CYCLADES,
-						   device_id, pdev)) == NULL) {
-				dev_index++;	/* try next device id */
-			} else {
-				break;	/* found a board */
-			}
-		}
-
-		if (device_id == 0)
-			break;
-
-		i -= !!cy_pci_probe(pdev, &cy_pci_dev_id[dev_index]);
-	}
-
-	return i;
-#else
-	return 0;
-#endif				/* ifdef CONFIG_PCI */
-}				/* cy_detect_pci */
 
-static void __devexit cy_pci_release(struct pci_dev *pdev)
+static void __devexit cy_pci_remove(struct pci_dev *pdev)
 {
-#ifdef CONFIG_PCI
 	struct cyclades_card *cinfo = pci_get_drvdata(pdev);
 	unsigned int i;
 
@@ -5370,9 +5333,16 @@ static void __devexit cy_pci_release(str
 	for (i = cinfo->first_line; i < cinfo->first_line +
 			cinfo->nports; i++)
 		tty_unregister_device(cy_serial_driver, i);
-#endif
 }
 
+static struct pci_driver cy_pci_driver = {
+	.name = "cyclades",
+	.id_table = cy_pci_dev_id,
+	.probe = cy_pci_probe,
+	.remove = __devexit_p(cy_pci_remove)
+};
+#endif
+
 /*
  * This routine prints out the appropriate serial driver version number
  * and identifies which options were configured into this driver.
@@ -5533,13 +5503,12 @@ static int __init cy_init(void)
 	/* look for isa boards */
 	nboards = cy_detect_isa();
 
+#ifdef CONFIG_PCI
 	/* look for pci boards */
-	nboards += cy_detect_pci();
-
-	if (nboards == 0) {
-		retval = -ENODEV;
+	retval = pci_register_driver(&cy_pci_driver);
+	if (retval && !nboards)
 		goto err_unr;
-	}
+#endif
 
 	return 0;
 err_unr:
@@ -5564,12 +5533,12 @@ static void __exit cy_cleanup_module(voi
 
 	put_tty_driver(cy_serial_driver);
 
+#ifdef CONFIG_PCI
+	pci_unregister_driver(&cy_pci_driver);
+#endif
+
 	for (i = 0; i < NR_CARDS; i++) {
 		if (cy_card[i].base_addr) {
-			if (cy_card[i].pdev) {
-				cy_pci_release(cy_card[i].pdev);
-				continue;
-			}
 			/* clear interrupt */
 			cy_writeb(cy_card[i].base_addr + Cy_ClrIntr, 0);
 			iounmap(cy_card[i].base_addr);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-dvb.patch
cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
vmstat-use-our-own-timer-events-fix.patch
shrink_slab-handle-bad-shrinkers.patch
