From: akpm@osdl.org
Subject: - char-sx-request-regions.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:09:31 -0800
Message-ID: <200612082009.kB8K9VHL002710@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58642 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946254AbWLHUJk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:09:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: sx, request regions
has been removed from the -mm tree.  Its filename was
     char-sx-request-regions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: sx, request regions
From: Jiri Slaby <jirislaby@gmail.com>

Check regions if they are free before we touch them.  Release them in
failpaths.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/sx.c |   55 +++++++++++++++++++++++++++++++++++++++-----
 drivers/char/sx.h |    1 
 2 files changed, 50 insertions(+), 6 deletions(-)

diff -puN drivers/char/sx.c~char-sx-request-regions drivers/char/sx.c
--- a/drivers/char/sx.c~char-sx-request-regions
+++ a/drivers/char/sx.c
@@ -2497,10 +2497,13 @@ static void __devexit sx_remove_card(str
 
 		/* It is safe/allowed to del_timer a non-active timer */
 		del_timer(&board->timer);
-		if (pdev)
+		if (pdev) {
 			pci_iounmap(pdev, board->base);
-		else
+			pci_release_region(pdev, IS_CF_BOARD(board) ? 3 : 2);
+		} else {
 			iounmap(board->base);
+			release_region(board->hw_base, board->hw_len);
+		}
 
 		board->flags &= ~(SX_BOARD_INITIALIZED | SX_BOARD_PRESENT);
 	}
@@ -2538,8 +2541,17 @@ static int __devinit sx_eisa_probe(struc
 
 	board->hw_base = ((inb(eisa_slot + 0xc01) << 8) +
 			  inb(eisa_slot + 0xc00)) << 16;
+	board->hw_len = SI2_EISA_WINDOW_LEN;
+	if (!request_region(board->hw_base, board->hw_len, "sx")) {
+		dev_err(dev, "can't request region\n");
+		goto err_flag;
+	}
 	board->base2 =
 	board->base = ioremap(board->hw_base, SI2_EISA_WINDOW_LEN);
+	if (!board->base) {
+		dev_err(dev, "can't remap memory\n");
+		goto err_reg;
+	}
 
 	sx_dprintk(SX_DEBUG_PROBE, "IO hw_base address: %lx\n", board->hw_base);
 	sx_dprintk(SX_DEBUG_PROBE, "base: %p\n", board->base);
@@ -2554,6 +2566,9 @@ static int __devinit sx_eisa_probe(struc
 	return 0;
 err_unmap:
 	iounmap(board->base);
+err_reg:
+	release_region(board->hw_base, board->hw_len);
+err_flag:
 	board->flags &= ~SX_BOARD_PRESENT;
 err:
 	return retval;
@@ -2645,12 +2660,17 @@ static int __devinit sx_pci_probe(struct
 
 	/* CF boards use base address 3.... */
 	reg = IS_CF_BOARD(board) ? 3 : 2;
+	retval = pci_request_region(pdev, reg, "sx");
+	if (retval) {
+		dev_err(&pdev->dev, "can't request region\n");
+		goto err_flag;
+	}
 	board->hw_base = pci_resource_start(pdev, reg);
 	board->base2 =
 	board->base = pci_iomap(pdev, reg, WINDOW_LEN(board));
 	if (!board->base) {
 		dev_err(&pdev->dev, "ioremap failed\n");
-		goto err_flag;
+		goto err_reg;
 	}
 
 	/* Most of the stuff on the CF board is offset by 0x18000 ....  */
@@ -2674,6 +2694,8 @@ static int __devinit sx_pci_probe(struct
 	return 0;
 err_unmap:
 	pci_iounmap(pdev, board->base);
+err_reg:
+	pci_release_region(pdev, reg);
 err_flag:
 	board->flags &= ~SX_BOARD_PRESENT;
 err:
@@ -2736,8 +2758,13 @@ static int __init sx_init(void)
 	for (i = 0; i < NR_SX_ADDRS; i++) {
 		board = &boards[found];
 		board->hw_base = sx_probe_addrs[i];
+		board->hw_len = SX_WINDOW_LEN;
+		if (!request_region(board->hw_base, board->hw_len, "sx"))
+			continue;
 		board->base2 =
-		board->base = ioremap(board->hw_base, SX_WINDOW_LEN);
+		board->base = ioremap(board->hw_base, board->hw_len);
+		if (!board->base)
+			goto err_sx_reg;
 		board->flags &= ~SX_BOARD_TYPE;
 		board->flags |= SX_ISA_BOARD;
 		board->irq = sx_irqmask ? -1 : 0;
@@ -2747,14 +2774,21 @@ static int __init sx_init(void)
 			found++;
 		} else {
 			iounmap(board->base);
+err_sx_reg:
+			release_region(board->hw_base, board->hw_len);
 		}
 	}
 
 	for (i = 0; i < NR_SI_ADDRS; i++) {
 		board = &boards[found];
 		board->hw_base = si_probe_addrs[i];
+		board->hw_len = SI2_ISA_WINDOW_LEN;
+		if (!request_region(board->hw_base, board->hw_len, "sx"))
+			continue;
 		board->base2 =
-		board->base = ioremap(board->hw_base, SI2_ISA_WINDOW_LEN);
+		board->base = ioremap(board->hw_base, board->hw_len);
+		if (!board->base)
+			goto err_si_reg;
 		board->flags &= ~SX_BOARD_TYPE;
 		board->flags |= SI_ISA_BOARD;
 		board->irq = sx_irqmask ? -1 : 0;
@@ -2764,13 +2798,20 @@ static int __init sx_init(void)
 			found++;
 		} else {
 			iounmap(board->base);
+err_si_reg:
+			release_region(board->hw_base, board->hw_len);
 		}
 	}
 	for (i = 0; i < NR_SI1_ADDRS; i++) {
 		board = &boards[found];
 		board->hw_base = si1_probe_addrs[i];
+		board->hw_len = SI1_ISA_WINDOW_LEN;
+		if (!request_region(board->hw_base, board->hw_len, "sx"))
+			continue;
 		board->base2 =
-		board->base = ioremap(board->hw_base, SI1_ISA_WINDOW_LEN);
+		board->base = ioremap(board->hw_base, board->hw_len);
+		if (!board->base)
+			goto err_si1_reg;
 		board->flags &= ~SX_BOARD_TYPE;
 		board->flags |= SI1_ISA_BOARD;
 		board->irq = sx_irqmask ? -1 : 0;
@@ -2780,6 +2821,8 @@ static int __init sx_init(void)
 			found++;
 		} else {
 			iounmap(board->base);
+err_si1_reg:
+			release_region(board->hw_base, board->hw_len);
 		}
 	}
 #endif
diff -puN drivers/char/sx.h~char-sx-request-regions drivers/char/sx.h
--- a/drivers/char/sx.h~char-sx-request-regions
+++ a/drivers/char/sx.h
@@ -35,6 +35,7 @@ struct sx_board {
   void __iomem *base;
   void __iomem *base2;
   unsigned long hw_base;
+  resource_size_t hw_len;
   int eisa_base;
   int port_base; /* Number of the first port */
   struct sx_port *ports;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

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

