From: akpm@linux-foundation.org
Subject: - char-sx-remove-bogus-iomap.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:35:24 -0700
Message-ID: <200810202035.m9KKZOFJ011143@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32884 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752372AbYJTUlF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:41:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, R.E.Wolff@BitWizard.nl, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: sx, remove bogus iomap
has been removed from the -mm tree.  Its filename was
     char-sx-remove-bogus-iomap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: sx, remove bogus iomap
From: Jiri Slaby <jirislaby@gmail.com>

readl/writel are not expected to accept iomap return value. Replace
bogus mapping by standard ioremap.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: <R.E.Wolff@BitWizard.nl>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/sx.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/char/sx.c~char-sx-remove-bogus-iomap drivers/char/sx.c
--- a/drivers/char/sx.c~char-sx-remove-bogus-iomap
+++ a/drivers/char/sx.c
@@ -2504,7 +2504,7 @@ static void __devexit sx_remove_card(str
 		del_timer(&board->timer);
 		if (pdev) {
 #ifdef CONFIG_PCI
-			pci_iounmap(pdev, board->base2);
+			iounmap(board->base2);
 			pci_release_region(pdev, IS_CF_BOARD(board) ? 3 : 2);
 #endif
 		} else {
@@ -2677,7 +2677,7 @@ static int __devinit sx_pci_probe(struct
 	}
 	board->hw_base = pci_resource_start(pdev, reg);
 	board->base2 =
-	board->base = pci_iomap(pdev, reg, WINDOW_LEN(board));
+	board->base = ioremap_nocache(board->hw_base, WINDOW_LEN(board));
 	if (!board->base) {
 		dev_err(&pdev->dev, "ioremap failed\n");
 		goto err_reg;
@@ -2703,7 +2703,7 @@ static int __devinit sx_pci_probe(struct
 
 	return 0;
 err_unmap:
-	pci_iounmap(pdev, board->base2);
+	iounmap(board->base2);
 err_reg:
 	pci_release_region(pdev, reg);
 err_flag:
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
linux-next.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

