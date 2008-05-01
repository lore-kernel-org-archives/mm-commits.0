From: akpm@linux-foundation.org
Subject: - char-moxa-pci-io-space-fixup.patch removed from -mm tree
Date: Thu, 01 May 2008 02:28:55 -0700
Message-ID: <200805010928.m419StYb030620@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59622 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757497AbYEAJ27 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:28:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, Oyvind.Aabling@uni-c.dk, mm-commits@vger.kernel.org


The patch titled
     Char: moxa, pci io space fixup
has been removed from the -mm tree.  Its filename was
     char-moxa-pci-io-space-fixup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: moxa, pci io space fixup
From: Jiri Slaby <jirislaby@gmail.com>

- request region before remapping pci io space
- use ioremap, iounmap istead of iomap interface, because we use
  readX/writeX for accessing this space because of isa support

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Tested-by: Oyvind Aabling <Oyvind.Aabling@uni-c.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff -puN drivers/char/moxa.c~char-moxa-pci-io-space-fixup drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-pci-io-space-fixup
+++ a/drivers/char/moxa.c
@@ -290,10 +290,17 @@ static int __devinit moxa_pci_probe(stru
 	}
 
 	board = &moxa_boards[i];
-	board->basemem = pci_iomap(pdev, 2, 0x4000);
+
+	retval = pci_request_region(pdev, 2, "moxa-base");
+	if (retval) {
+		dev_err(&pdev->dev, "can't request pci region 2\n");
+		goto err;
+	}
+
+	board->basemem = ioremap(pci_resource_start(pdev, 2), 0x4000);
 	if (board->basemem == NULL) {
 		dev_err(&pdev->dev, "can't remap io space 2\n");
-		goto err;
+		goto err_reg;
 	}
 
 	board->boardType = board_type;
@@ -315,6 +322,8 @@ static int __devinit moxa_pci_probe(stru
 	pci_set_drvdata(pdev, board);
 
 	return (0);
+err_reg:
+	pci_release_region(pdev, 2);
 err:
 	return retval;
 }
@@ -323,8 +332,9 @@ static void __devexit moxa_pci_remove(st
 {
 	struct moxa_board_conf *brd = pci_get_drvdata(pdev);
 
-	pci_iounmap(pdev, brd->basemem);
+	iounmap(brd->basemem);
 	brd->basemem = NULL;
+	pci_release_region(pdev, 2);
 }
 
 static struct pci_driver moxa_pci_driver = {
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

