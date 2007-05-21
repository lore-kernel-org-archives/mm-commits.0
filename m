From: akpm@linux-foundation.org
Subject: + char-isicom-proper-variables-types.patch added to -mm tree
Date: Sun, 20 May 2007 21:19:53 -0700
Message-ID: <200705210419.l4L4JqXF002218@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59100 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754297AbXEUEVO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 00:21:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: isicom, proper variables types
has been added to the -mm tree.  Its filename is
     char-isicom-proper-variables-types.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: isicom, proper variables types
From: Jiri Slaby <jirislaby@gmail.com>

irq is int, base is unsigned long

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/isicom.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff -puN drivers/char/isicom.c~char-isicom-proper-variables-types drivers/char/isicom.c
--- a/drivers/char/isicom.c~char-isicom-proper-variables-types
+++ a/drivers/char/isicom.c
@@ -184,7 +184,7 @@ static signed char linuxb_to_isib[] = {
 
 struct	isi_board {
 	unsigned long		base;
-	unsigned char		irq;
+	int			irq;
 	unsigned char		port_count;
 	unsigned short		status;
 	unsigned short		port_status; /* each bit for each port */
@@ -224,7 +224,7 @@ static struct isi_port  isi_ports[PORT_C
  *	it wants to talk.
  */
 
-static inline int WaitTillCardIsFree(u16 base)
+static inline int WaitTillCardIsFree(unsigned long base)
 {
 	unsigned int count = 0;
 	unsigned int a = in_atomic(); /* do we run under spinlock? */
@@ -396,9 +396,9 @@ static inline int __isicom_paranoia_chec
 
 static void isicom_tx(unsigned long _data)
 {
-	unsigned long flags;
+	unsigned long flags, base;
 	unsigned int retries;
-	short count = (BOARD_COUNT-1), card, base;
+	short count = (BOARD_COUNT-1), card;
 	short txcount, wrd, residue, word_count, cnt;
 	struct isi_port *port;
 	struct tty_struct *tty;
@@ -1730,17 +1730,13 @@ static unsigned int card_count;
 static int __devinit isicom_probe(struct pci_dev *pdev,
 	const struct pci_device_id *ent)
 {
-	unsigned int ioaddr, signature, index;
+	unsigned int signature, index;
 	int retval = -EPERM;
-	u8 pciirq;
 	struct isi_board *board = NULL;
 
 	if (card_count >= BOARD_COUNT)
 		goto err;
 
-	ioaddr = pci_resource_start(pdev, 3);
-	/* i.e at offset 0x1c in the PCI configuration register space. */
-	pciirq = pdev->irq;
 	dev_info(&pdev->dev, "ISI PCI Card(Device ID 0x%x)\n", ent->device);
 
 	/* allot the first empty slot in the array */
@@ -1751,8 +1747,8 @@ static int __devinit isicom_probe(struct
 		}
 
 	board->index = index;
-	board->base = ioaddr;
-	board->irq = pciirq;
+	board->base = pci_resource_start(pdev, 3);
+	board->irq = pdev->irq;
 	card_count++;
 
 	pci_set_drvdata(pdev, board);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
char-cyclades-fix-deadlock.patch
misc-phantom-move-to-unlocked_ioctl.patch
misc-misc-phantom-move-to-unlocked_ioctl-fix.patch
misc-phantom-take-care-of-pci-posting.patch
char-cyclades-add-firmware-loading.patch
char-cyclades-fix-sparse-warning.patch
char-isicom-cleanup-locking.patch
char-isicom-del_timer-at-exit.patch
char-isicom-proper-variables-types.patch
shrink_slab-handle-bad-shrinkers.patch
