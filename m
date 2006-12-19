From: akpm@osdl.org
Subject: - char-isicom-fix-probe-race.patch removed from -mm tree
Date: Mon, 18 Dec 2006 16:02:11 -0800
Message-ID: <200612190002.kBJ02B6e017095@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:32811 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932377AbWLSACN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Dec 2006 19:02:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: isicom, fix probe race
has been removed from the -mm tree.  Its filename was
     char-isicom-fix-probe-race.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: Char: isicom, fix probe race
From: Jiri Slaby <jirislaby@gmail.com>

Fix two race conditions in the probe function with mutex.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/isicom.c |   28 +++++++++++++++++-----------
 1 files changed, 17 insertions(+), 11 deletions(-)

diff -puN drivers/char/isicom.c~char-isicom-fix-probe-race drivers/char/isicom.c
--- a/drivers/char/isicom.c~char-isicom-fix-probe-race
+++ a/drivers/char/isicom.c
@@ -1732,22 +1732,25 @@ end:
 /*
  *	Insmod can set static symbols so keep these static
  */
-static int card;
+static unsigned int card_count;
 
 static int __devinit isicom_probe(struct pci_dev *pdev,
-	const struct pci_device_id *ent)
+				const struct pci_device_id *ent)
 {
+	static DEFINE_MUTEX(probe_lock);
 	unsigned int ioaddr, signature, index;
 	int retval = -EPERM;
-	u8 pciirq;
 	struct isi_board *board = NULL;
 
-	if (card >= BOARD_COUNT)
+	mutex_lock(&probe_lock);
+	if (card_count >= BOARD_COUNT) {
+		mutex_unlock(&probe_lock);
 		goto err;
+	}
+	card_count++;
 
 	ioaddr = pci_resource_start(pdev, 3);
 	/* i.e at offset 0x1c in the PCI configuration register space. */
-	pciirq = pdev->irq;
 	dev_info(&pdev->dev, "ISI PCI Card(Device ID 0x%x)\n", ent->device);
 
 	/* allot the first empty slot in the array */
@@ -1759,8 +1762,9 @@ static int __devinit isicom_probe(struct
 
 	board->index = index;
 	board->base = ioaddr;
-	board->irq = pciirq;
-	card++;
+	board->irq = pdev->irq;
+
+	mutex_unlock(&probe_lock);
 
 	pci_set_drvdata(pdev, board);
 
@@ -1770,7 +1774,7 @@ static int __devinit isicom_probe(struct
 			"will be disabled.\n", board->base, board->base + 15,
 			index + 1);
 		retval = -EBUSY;
-		goto err;
+		goto err_dec;
  	}
 
 	retval = request_irq(board->irq, isicom_interrupt,
@@ -1799,8 +1803,10 @@ errunri:
 	free_irq(board->irq, board);
 errunrr:
 	pci_release_region(pdev, 3);
-err:
+err_dec:
+	card_count--;
 	board->base = 0;
+err:
 	return retval;
 }
 
@@ -1814,6 +1820,8 @@ static void __devexit isicom_remove(stru
 
 	free_irq(board->irq, board);
 	pci_release_region(pdev, 3);
+	card_count--;
+	board->base = 0;
 }
 
 static int __init isicom_init(void)
@@ -1821,8 +1829,6 @@ static int __init isicom_init(void)
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
char-isicom-fix-probe-race.patch
char-isicom-augment-card_reset.patch
char-isicom-check-card-state-in-isr.patch
char-isicom-support-higher-rates.patch
char-tty_wakeup-cleanup.patch
shrink_slab-handle-bad-shrinkers.patch

