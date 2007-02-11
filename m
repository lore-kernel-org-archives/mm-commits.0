From: akpm@linux-foundation.org
Subject: - char-isicom-correct-probing-removing.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:50:45 -0800
Message-ID: <200702112250.l1BMojUb015884@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60040 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932741AbXBKWur (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:50:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: isicom, correct probing/removing
has been removed from the -mm tree.  Its filename was
     char-isicom-correct-probing-removing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: isicom, correct probing/removing
From: Jiri Slaby <jirislaby@gmail.com>

Don't forget to decrease card_count in fail paths and in remove function. 
Also null board->base in such cases to point out, that this structure is
unused and thus can be reassigned.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/isicom.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN drivers/char/isicom.c~char-isicom-correct-probing-removing drivers/char/isicom.c
--- a/drivers/char/isicom.c~char-isicom-correct-probing-removing
+++ a/drivers/char/isicom.c
@@ -1746,7 +1746,7 @@ end:
 /*
  *	Insmod can set static symbols so keep these static
  */
-static int card;
+static unsigned int card_count;
 
 static int __devinit isicom_probe(struct pci_dev *pdev,
 	const struct pci_device_id *ent)
@@ -1756,7 +1756,7 @@ static int __devinit isicom_probe(struct
 	u8 pciirq;
 	struct isi_board *board = NULL;
 
-	if (card >= BOARD_COUNT)
+	if (card_count >= BOARD_COUNT)
 		goto err;
 
 	ioaddr = pci_resource_start(pdev, 3);
@@ -1774,7 +1774,7 @@ static int __devinit isicom_probe(struct
 	board->index = index;
 	board->base = ioaddr;
 	board->irq = pciirq;
-	card++;
+	card_count++;
 
 	pci_set_drvdata(pdev, board);
 
@@ -1784,7 +1784,7 @@ static int __devinit isicom_probe(struct
 			"will be disabled.\n", board->base, board->base + 15,
 			index + 1);
 		retval = -EBUSY;
-		goto err;
+		goto errdec;
  	}
 
 	retval = request_irq(board->irq, isicom_interrupt,
@@ -1813,8 +1813,10 @@ errunri:
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
 
@@ -1828,6 +1830,8 @@ static void __devexit isicom_remove(stru
 
 	free_irq(board->irq, board);
 	pci_release_region(pdev, 3);
+	board->base = 0;
+	card_count--;
 }
 
 static int __init isicom_init(void)
@@ -1835,8 +1839,6 @@ static int __init isicom_init(void)
 	int retval, idx, channel;
 	struct isi_port *port;
 
-	card = 0;
-
 	for(idx = 0; idx < BOARD_COUNT; idx++) {
 		port = &isi_ports[idx * 16];
 		isi_card[idx].ports = port;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
char-use-more-pci_device-macro.patch
char-cyclades-use-pci_device_id.patch
maintainers-remove-two-dead-e-mail.patch
char-specialix-isr-have-2-params.patch
char-timers-cleanup.patch
fbdev-driver-for-s3-trio-virge-update-2-fix.patch
video-fb-add-true-ref_count-atomicity.patch
video-fb-kzalloc-changes.patch
shrink_slab-handle-bad-shrinkers.patch
