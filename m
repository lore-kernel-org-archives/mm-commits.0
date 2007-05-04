From: akpm@linux-foundation.org
Subject: + char-cyclades-switch-to-pci-probing.patch added to -mm tree
Date: Thu, 03 May 2007 23:45:19 -0700
Message-ID: <200705040645.l446jJ31030859@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54666 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965692AbXEDGpY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 02:45:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: cyclades, switch to pci probing
has been added to the -mm tree.  Its filename is
     char-cyclades-switch-to-pci-probing.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
