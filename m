From: akpm@osdl.org
Subject: - char-sx-use-eisa-probing.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:09:08 -0800
Message-ID: <200612082009.kB8K98o6002666@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58508 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946096AbWLHUJS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:09:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, R.E.Wolff@BitWizard.nl, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: sx, use eisa probing
has been removed from the -mm tree.  Its filename was
     char-sx-use-eisa-probing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: sx, use eisa probing
From: Jiri Slaby <jirislaby@gmail.com>

Instead of finding eisa directly, use eisa probing.

Cc: <R.E.Wolff@BitWizard.nl>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/sx.c |  164 +++++++++++++++++++++++++++++++-------------
 1 file changed, 117 insertions(+), 47 deletions(-)

diff -puN drivers/char/sx.c~char-sx-use-eisa-probing drivers/char/sx.c
--- a/drivers/char/sx.c~char-sx-use-eisa-probing
+++ a/drivers/char/sx.c
@@ -214,6 +214,7 @@
 #include <linux/fcntl.h>
 #include <linux/major.h>
 #include <linux/delay.h>
+#include <linux/eisa.h>
 #include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/init.h>
@@ -2345,6 +2346,17 @@ static int sx_init_portstructs (int nboa
 	return 0;
 }
 
+static unsigned int sx_find_free_board(void)
+{
+	unsigned int i;
+
+        for (i = 0; i < SX_NBOARDS; i++)
+		if (!(boards[i].flags & SX_BOARD_PRESENT))
+			break;
+
+	return i;
+}
+
 static void __exit sx_release_drivers(void)
 {
 	func_enter();
@@ -2353,6 +2365,97 @@ static void __exit sx_release_drivers(vo
 	func_exit();
 }
 
+static void __devexit sx_remove_card(struct sx_board *board)
+{
+	if (board->flags & SX_BOARD_INITIALIZED) {
+		/* The board should stop messing with us. (actually I mean the
+		   interrupt) */
+		sx_reset(board);
+		if ((board->irq) && (board->flags & SX_IRQ_ALLOCATED))
+			free_irq(board->irq, board);
+
+		/* It is safe/allowed to del_timer a non-active timer */
+		del_timer(&board->timer);
+		iounmap(board->base);
+
+		board->flags &= ~(SX_BOARD_INITIALIZED|SX_BOARD_PRESENT);
+	}
+}
+
+#ifdef CONFIG_EISA
+
+static int __devinit sx_eisa_probe(struct device *dev)
+{
+	struct eisa_device *edev = to_eisa_device(dev);
+	struct sx_board *board;
+	unsigned long eisa_slot = edev->base_addr;
+	unsigned int i;
+	int retval = -EIO;
+
+	i = sx_find_free_board();
+
+	if (i == SX_NBOARDS)
+		goto err;
+
+	dev_info(dev, "XIO : Signature found in EISA slot %lu, "
+			"Product %d Rev %d (REPORT THIS TO LKLM)\n",
+			eisa_slot >> 12,
+			inb(eisa_slot + EISA_VENDOR_ID_OFFSET + 2),
+			inb(eisa_slot + EISA_VENDOR_ID_OFFSET + 3));
+
+	board = &boards[i];
+	board->eisa_base = eisa_slot;
+	board->flags &= ~SX_BOARD_TYPE;
+	board->flags |= SI_EISA_BOARD;
+
+	board->hw_base = ((inb(eisa_slot + 0xc01) << 8) +
+			inb(eisa_slot + 0xc00)) << 16;
+	board->base2 =
+	board->base = ioremap(board->hw_base, SI2_EISA_WINDOW_LEN);
+
+	sx_dprintk(SX_DEBUG_PROBE, "IO hw_base address: %lx\n", board->hw_base);
+	sx_dprintk(SX_DEBUG_PROBE, "base: %p\n", board->base);
+	board->irq = inb(eisa_slot + 0xc02) >> 4;
+	sx_dprintk(SX_DEBUG_PROBE, "IRQ: %d\n", board->irq);
+
+	if (!probe_si(board))
+		goto err_unmap;
+
+	dev_set_drvdata(dev, board);
+
+	return 0;
+err_unmap:
+	iounmap(board->base);
+err:
+	return retval;
+}
+
+static int __devexit sx_eisa_remove(struct device *dev)
+{
+	struct sx_board *board = dev_get_drvdata(dev);
+
+	sx_remove_card(board);
+
+	return 0;
+}
+
+static struct eisa_device_id sx_eisa_tbl[] = {
+	{ "SLX" },
+	{ "" }
+};
+MODULE_DEVICE_TABLE(eisa, sx_eisa_tbl);
+
+static struct eisa_driver sx_eisadriver = {
+	.id_table = sx_eisa_tbl,
+	.driver = {
+		.name = "sx",
+		.probe = sx_eisa_probe,
+		.remove = __devexit_p(sx_eisa_remove),
+	}
+};
+
+#endif
+
  /******************************************************** 
  * Setting bit 17 in the CNTRL register of the PLX 9050  * 
  * chip forces a retry on writes while a read is pending.*
@@ -2391,9 +2494,7 @@ static int __devinit sx_pci_probe(struct
 	unsigned int i;
 	int retval = -EIO;
 
-	for (i = 0; i < SX_NBOARDS; i++)
-		if (!(boards[i].flags & SX_BOARD_PRESENT))
-			break;
+	i = sx_find_free_board();
 
 	if (i == SX_NBOARDS)
 		goto err;
@@ -2449,19 +2550,7 @@ static void __devexit sx_pci_remove(stru
 {
 	struct sx_board *board = pci_get_drvdata(pdev);
 
-	if (board->flags & SX_BOARD_INITIALIZED) {
-		/* The board should stop messing with us. (actually I mean the
-		   interrupt) */
-		sx_reset(board);
-		if ((board->irq) && (board->flags & SX_IRQ_ALLOCATED))
-			free_irq(board->irq, board);
-
-		/* It is safe/allowed to del_timer a non-active timer */
-		del_timer(&board->timer);
-		iounmap(board->base);
-
-		board->flags &= ~(SX_BOARD_INITIALIZED|SX_BOARD_PRESENT);
-	}
+	sx_remove_card(board);
 }
 
 /* Specialix has a whole bunch of cards with 0x2000 as the device ID. They say
@@ -2484,9 +2573,11 @@ static struct pci_driver sx_pcidriver = 
 
 static int __init sx_init(void) 
 {
+#ifdef CONFIG_EISA
+	int retval1;
+#endif
 	int retval, i;
 	int found = 0;
-	int eisa_slot;
 	struct sx_board *board;
 
 	func_enter();
@@ -2549,42 +2640,18 @@ static int __init sx_init(void) 
 			iounmap (board->base);
 		}
 	}
-
-        sx_dprintk(SX_DEBUG_PROBE, "Probing for EISA cards\n");
-        for(eisa_slot=0x1000; eisa_slot<0x10000; eisa_slot+=0x1000)
-        {
-                if((inb(eisa_slot+0xc80)==0x4d) &&
-                   (inb(eisa_slot+0xc81)==0x98))
-                {
-			sx_dprintk(SX_DEBUG_PROBE, "%s : Signature found in EISA slot %d, Product %d Rev %d\n",
-			                        "XIO", (eisa_slot>>12), inb(eisa_slot+0xc82), inb(eisa_slot+0xc83));
-
-			board = &boards[found];
-			board->eisa_base = eisa_slot;
-			board->flags &= ~SX_BOARD_TYPE;
-			board->flags |= SI_EISA_BOARD;
-
-			board->hw_base = (((inb(0xc01+eisa_slot) << 8) + inb(0xc00+eisa_slot)) << 16);
-			board->base2 =
-			board->base = ioremap(board->hw_base, SI2_EISA_WINDOW_LEN);
-
-			sx_dprintk(SX_DEBUG_PROBE, "IO hw_base address: %lx\n", board->hw_base);
-			sx_dprintk(SX_DEBUG_PROBE, "base: %p\n", board->base);
-			board->irq = inb(board->eisa_base+0xc02)>>4; 
-			sx_dprintk(SX_DEBUG_PROBE, "IRQ: %d\n", board->irq);
-			
-			probe_si(board);
-
-			found++;
-		}
-	}
-
+#ifdef CONFIG_EISA
+	retval1 = eisa_driver_register(&sx_eisadriver);
+#endif
 	retval = pci_register_driver(&sx_pcidriver);
 
 	if (found) {
 		printk (KERN_INFO "sx: total of %d boards detected.\n", found);
 		retval = 0;
 	} else if (retval) {
+#ifdef CONFIG_EISA
+		if (retval1)
+#endif
 		misc_deregister(&sx_fw_device);
 	}
 
@@ -2599,6 +2666,9 @@ static void __exit sx_exit (void)
 	struct sx_board *board;
 
 	func_enter();
+#ifdef CONFIG_EISA
+	eisa_driver_unregister(&sx_eisadriver);
+#endif
 	pci_unregister_driver(&sx_pcidriver);
 	for (i = 0; i < SX_NBOARDS; i++) {
 		board = &boards[i];
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-sx-use-eisa-probing.patch
char-sx-ifdef-isa-code.patch
char-sx-lock-boards-struct.patch
char-sx-remove-duplicite-code.patch
char-sx-whitespace-cleanup.patch
char-sx-simplify-timer-logic.patch
char-sx-fix-return-in-module-init.patch
char-sx-use-pci_iomap.patch
char-sx-request-regions.patch
char-stallion-convert-to-pci-probing.patch
char-stallion-prints-cleanup.patch
char-stallion-implement-fail-paths.patch
char-stallion-correct-__init-macros.patch
char-stallion-functions-cleanup.patch
char-stallion-fix-fail-paths.patch
char-stallion-brd-struct-locking.patch
char-stallion-remove-syntactic-sugar.patch
char-stallion-variables-cleanup.patch
char-stallion-use-dynamic-dev.patch
char-istallion-convert-to-pci-probing.patch
char-istallion-remove-the-mess.patch
char-istallion-eliminate-typedefs.patch
char-istallion-variables-cleanup.patch
char-istallion-ifdef-eisa-code.patch
char-istallion-brdnr-locking.patch
char-istallion-free-only-isa.patch
char-istallion-correct-fail-paths.patch
char-istallion-fix-enabling.patch
char-istallion-move-init-and-exit-code.patch
char-istallion-change-init-sequence.patch
char-istallion-dynamic-tty-device.patch
char-istallion-use-mod_timer.patch
char-cyclades-save-indent-levels.patch
char-cyclades-lindent-the-code.patch
char-cyclades-cleanup.patch
char-cyclades-fix-warnings.patch

