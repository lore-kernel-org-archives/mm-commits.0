From: akpm@osdl.org
Subject: + char-isicom-augment-card_reset.patch added to -mm tree
Date: Mon, 18 Dec 2006 15:28:12 -0800
Message-ID: <200612182328.kBINSCr9016111@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58121 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754770AbWLRX2P (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Dec 2006 18:28:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: isicom, augment card_reset
has been added to the -mm tree.  Its filename is
     char-isicom-augment-card_reset.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: isicom, augment card_reset
From: Jiri Slaby <jirislaby@gmail.com>

isicom, augment card_reset

- add 0xee to signatures
- change long delays to sleeps
- make one sleep shorter not to wait 3s
- portcount == 16 is also correct

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/isicom.c |   39 ++++++++++++++++++++++-----------------
 1 files changed, 22 insertions(+), 17 deletions(-)

diff -puN drivers/char/isicom.c~char-isicom-augment-card_reset drivers/char/isicom.c
--- a/drivers/char/isicom.c~char-isicom-augment-card_reset
+++ a/drivers/char/isicom.c
@@ -1501,7 +1501,7 @@ static int __devinit reset_card(struct p
 {
 	struct isi_board *board = pci_get_drvdata(pdev);
 	unsigned long base = board->base;
-	unsigned int portcount = 0;
+	unsigned int sig, portcount = 0;
 	int retval = 0;
 
 	dev_dbg(&pdev->dev, "ISILoad:Resetting Card%d at 0x%lx\n", card + 1,
@@ -1509,27 +1509,35 @@ static int __devinit reset_card(struct p
 
 	inw(base + 0x8);
 
-	mdelay(10);
+	msleep(10);
 
 	outw(0, base + 0x8); /* Reset */
 
-	msleep(3000);
+	msleep(1000);
 
-	*signature = inw(base + 0x4) & 0xff;
+	sig = inw(base + 0x4) & 0xff;
+
+	if (sig != 0xa5 && sig != 0xbb && sig != 0xcc && sig != 0xdd &&
+			sig != 0xee) {
+		dev_warn(&pdev->dev, "ISILoad:Card%u reset failure (Possible "
+			"bad I/O Port Address 0x%lx).\n", card + 1, base);
+		dev_dbg(&pdev->dev, "Sig=0x%x\n", sig);
+		retval = -EIO;
+		goto end;
+	}
+
+	msleep(10);
 
 	portcount = inw(base + 0x2);
-	if (!(inw(base + 0xe) & 0x1) || ((portcount != 0) &&
-			(portcount != 4) && (portcount != 8))) {
-		dev_dbg(&pdev->dev, "base+0x2=0x%lx, base+0xe=0x%lx\n",
-			inw(base + 0x2), inw(base + 0xe));
-		dev_err(&pdev->dev, "ISILoad:PCI Card%d reset failure "
-			"(Possible bad I/O Port Address 0x%lx).\n",
-			card + 1, base);
+	if (!inw(base + 0xe) & 0x1 || (portcount != 0 && portcount != 4 &&
+				portcount != 8 && portcount != 16)) {
+		dev_err(&pdev->dev, "ISILoad:PCI Card%d reset failure.",
+			card + 1);
 		retval = -EIO;
 		goto end;
 	}
 
-	switch (*signature) {
+	switch (sig) {
 	case 0xa5:
 	case 0xbb:
 	case 0xdd:
@@ -1537,16 +1545,13 @@ static int __devinit reset_card(struct p
 		board->shift_count = 12;
 		break;
 	case 0xcc:
+	case 0xee:
 		board->port_count = 16;
 		board->shift_count = 11;
 		break;
-	default:
-		dev_warn(&pdev->dev, "ISILoad:Card%d reset failure (Possible "
-			"bad I/O Port Address 0x%lx).\n", card + 1, base);
-		dev_dbg(&pdev->dev, "Sig=0x%lx\n", signature);
-		retval = -EIO;
 	}
 	dev_info(&pdev->dev, "-Done\n");
+	*signature = sig;
 
 end:
 	return retval;
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
shrink_slab-handle-bad-shrinkers.patch

