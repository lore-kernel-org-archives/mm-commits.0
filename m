From: akpm@osdl.org
Subject: + char-isicom-correct-probing-removing.patch added to -mm tree
Date: Mon, 18 Dec 2006 16:57:26 -0800
Message-ID: <200612190057.kBJ0vQ9D018865@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37335 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932569AbWLSA53 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Dec 2006 19:57:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: isicom, correct probing/removing
has been added to the -mm tree.  Its filename is
     char-isicom-correct-probing-removing.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: isicom, correct probing/removing
From: Jiri Slaby <jirislaby@gmail.com>

Don't forget to decrease card_count in fail paths and in remove function. 
Also null board->base in such cases to point out, that this structure is
unused and thus can be reassigned.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/isicom.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff -puN drivers/char/isicom.c~char-isicom-correct-probing-removing drivers/char/isicom.c
--- a/drivers/char/isicom.c~char-isicom-correct-probing-removing
+++ a/drivers/char/isicom.c
@@ -1747,7 +1747,7 @@ end:
 /*
  *	Insmod can set static symbols so keep these static
  */
-static int card;
+static unsigned int card_count;
 
 static int __devinit isicom_probe(struct pci_dev *pdev,
 	const struct pci_device_id *ent)
@@ -1757,7 +1757,7 @@ static int __devinit isicom_probe(struct
 	u8 pciirq;
 	struct isi_board *board = NULL;
 
-	if (card >= BOARD_COUNT)
+	if (card_count >= BOARD_COUNT)
 		goto err;
 
 	ioaddr = pci_resource_start(pdev, 3);
@@ -1775,7 +1775,7 @@ static int __devinit isicom_probe(struct
 	board->index = index;
 	board->base = ioaddr;
 	board->irq = pciirq;
-	card++;
+	card_count++;
 
 	pci_set_drvdata(pdev, board);
 
@@ -1785,7 +1785,7 @@ static int __devinit isicom_probe(struct
 			"will be disabled.\n", board->base, board->base + 15,
 			index + 1);
 		retval = -EBUSY;
-		goto err;
+		goto errdec;
  	}
 
 	retval = request_irq(board->irq, isicom_interrupt,
@@ -1814,8 +1814,10 @@ errunri:
 	free_irq(board->irq, board);
 errunrr:
 	pci_release_region(pdev, 3);
-err:
+errdec:
 	board->base = 0;
+	card_count--;
+err:
 	return retval;
 }
 
@@ -1829,6 +1831,8 @@ static void __devexit isicom_remove(stru
 
 	free_irq(board->irq, board);
 	pci_release_region(pdev, 3);
+	board->base = 0;
+	card_count--;
 }
 
 static int __init isicom_init(void)
@@ -1836,8 +1840,6 @@ static int __init isicom_init(void)
 	int retval, idx, channel;
 	struct isi_port *port;
 
-	card = 0;
-
 	for(idx = 0; idx < BOARD_COUNT; idx++) {
 		port = &isi_ports[idx * 16];
 		isi_card[idx].ports = port;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-tty-delete-wake_up_interruptible-after-tty_wakeup.patch
char-isicom-remove-tty_hangwakeup-bottomhalves.patch
mxser-remove-ambiguous-redefinition-of-init_work.patch
char-isicom-fix-locking-in-isr.patch
char-isicom-augment-card_reset.patch
char-isicom-check-card-state-in-isr.patch
char-isicom-support-higher-rates.patch
char-isicom-correct-probing-removing.patch
char-tty_wakeup-cleanup.patch
shrink_slab-handle-bad-shrinkers.patch

