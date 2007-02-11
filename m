From: akpm@linux-foundation.org
Subject: - char-isicom-augment-card_reset.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:50:39 -0800
Message-ID: <200702112250.l1BModlM015873@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60029 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932737AbXBKWul (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:50:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: isicom, augment card_reset
has been removed from the -mm tree.  Its filename was
     char-isicom-augment-card_reset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: isicom, augment card_reset
From: Jiri Slaby <jirislaby@gmail.com>

isicom, augment card_reset

- add 0xee to signatures
- change long delays to sleeps
- make one sleep shorter not to wait 3s
- portcount == 16 is also correct

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/isicom.c |   39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff -puN drivers/char/isicom.c~char-isicom-augment-card_reset drivers/char/isicom.c
--- a/drivers/char/isicom.c~char-isicom-augment-card_reset
+++ a/drivers/char/isicom.c
@@ -1510,7 +1510,7 @@ static int __devinit reset_card(struct p
 {
 	struct isi_board *board = pci_get_drvdata(pdev);
 	unsigned long base = board->base;
-	unsigned int portcount = 0;
+	unsigned int sig, portcount = 0;
 	int retval = 0;
 
 	dev_dbg(&pdev->dev, "ISILoad:Resetting Card%d at 0x%lx\n", card + 1,
@@ -1518,27 +1518,35 @@ static int __devinit reset_card(struct p
 
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
@@ -1546,16 +1554,13 @@ static int __devinit reset_card(struct p
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
