From: akpm@osdl.org
Subject: - char-isicom-remove-isa-code.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:08:37 -0800
Message-ID: <200612082008.kB8K8blm002621@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58286 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946236AbWLHUIt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:08:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Char: isicom, remove isa code
has been removed from the -mm tree.  Its filename was
     char-isicom-remove-isa-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: isicom, remove isa code
From: Jiri Slaby <jirislaby@gmail.com>

ISA is not supported by this driver, remove parts, that take care of this.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/isicom.c |   91 +++++++++-------------------------------
 1 file changed, 21 insertions(+), 70 deletions(-)

diff -puN drivers/char/isicom.c~char-isicom-remove-isa-code drivers/char/isicom.c
--- a/drivers/char/isicom.c~char-isicom-remove-isa-code
+++ a/drivers/char/isicom.c
@@ -193,7 +193,6 @@ struct	isi_board {
 	unsigned short		shift_count;
 	struct isi_port		* ports;
 	signed char		count;
-	unsigned char		isa;
 	spinlock_t		card_lock; /* Card wide lock 11/5/00 -sameer */
 	unsigned long		flags;
 };
@@ -562,14 +561,12 @@ static irqreturn_t isicom_interrupt(int 
 	base = card->base;
 	spin_lock(&card->card_lock);
 
-	if (card->isa == NO) {
-		/*
-		 * disable any interrupts from the PCI card and lower the
-		 * interrupt line
-		 */
-		outw(0x8000, base+0x04);
-		ClearInterrupt(base);
-	}
+	/*
+	 * disable any interrupts from the PCI card and lower the
+	 * interrupt line
+	 */
+	outw(0x8000, base+0x04);
+	ClearInterrupt(base);
 
 	inw(base);		/* get the dummy word out */
 	header = inw(base);
@@ -579,19 +576,13 @@ static irqreturn_t isicom_interrupt(int 
 	if (channel + 1 > card->port_count) {
 		printk(KERN_WARNING "ISICOM: isicom_interrupt(0x%lx): "
 			"%d(channel) > port_count.\n", base, channel+1);
-		if (card->isa)
-			ClearInterrupt(base);
-		else
-			outw(0x0000, base+0x04); /* enable interrupts */
+		outw(0x0000, base+0x04); /* enable interrupts */
 		spin_unlock(&card->card_lock);
 		return IRQ_HANDLED;
 	}
 	port = card->ports + channel;
 	if (!(port->flags & ASYNC_INITIALIZED)) {
-		if (card->isa)
-			ClearInterrupt(base);
-		else
-			outw(0x0000, base+0x04); /* enable interrupts */
+		outw(0x0000, base+0x04); /* enable interrupts */
 		return IRQ_HANDLED;
 	}
 
@@ -604,10 +595,7 @@ static irqreturn_t isicom_interrupt(int 
 		}
 		if (byte_count & 0x01)
 			inw(base);
-		if (card->isa == YES)
-			ClearInterrupt(base);
-		else
-			outw(0x0000, base+0x04); /* enable interrupts */
+		outw(0x0000, base+0x04); /* enable interrupts */
 		spin_unlock(&card->card_lock);
 		return IRQ_HANDLED;
 	}
@@ -708,10 +696,7 @@ static irqreturn_t isicom_interrupt(int 
 		}
 		tty_flip_buffer_push(tty);
 	}
-	if (card->isa == YES)
-		ClearInterrupt(base);
-	else
-		outw(0x0000, base+0x04); /* enable interrupts */
+	outw(0x0000, base+0x04); /* enable interrupts */
 
 	return IRQ_HANDLED;
 }
@@ -1561,36 +1546,23 @@ static int __devinit reset_card(struct p
 
 	*signature = inw(base + 0x4) & 0xff;
 
-	if (board->isa == YES) {
-		if (!(inw(base + 0xe) & 0x1) || (inw(base + 0x2))) {
-			dev_dbg(&pdev->dev, "base+0x2=0x%lx, base+0xe=0x%lx\n",
-				inw(base + 0x2), inw(base + 0xe));
-			dev_err(&pdev->dev, "ISILoad:ISA Card%d reset failure "
-				"(Possible bad I/O Port Address 0x%lx).\n",
-				card + 1, base);
-			retval = -EIO;
-			goto end;
-		}
-	} else {
-		portcount = inw(base + 0x2);
-		if (!(inw(base + 0xe) & 0x1) || ((portcount != 0) &&
-				(portcount != 4) && (portcount != 8))) {
-			dev_dbg(&pdev->dev, "base+0x2=0x%lx, base+0xe=0x%lx\n",
-				inw(base + 0x2), inw(base + 0xe));
-			dev_err(&pdev->dev, "ISILoad:PCI Card%d reset failure "
-				"(Possible bad I/O Port Address 0x%lx).\n",
-				card + 1, base);
-			retval = -EIO;
-			goto end;
-		}
+	portcount = inw(base + 0x2);
+	if (!(inw(base + 0xe) & 0x1) || ((portcount != 0) &&
+			(portcount != 4) && (portcount != 8))) {
+		dev_dbg(&pdev->dev, "base+0x2=0x%lx, base+0xe=0x%lx\n",
+			inw(base + 0x2), inw(base + 0xe));
+		dev_err(&pdev->dev, "ISILoad:PCI Card%d reset failure "
+			"(Possible bad I/O Port Address 0x%lx).\n",
+			card + 1, base);
+		retval = -EIO;
+		goto end;
 	}
 
 	switch (*signature) {
 	case 0xa5:
 	case 0xbb:
 	case 0xdd:
-		board->port_count = (board->isa == NO && portcount == 4) ? 4 :
-			8;
+		board->port_count = (portcount == 4) ? 4 : 8;
 		board->shift_count = 12;
 		break;
 	case 0xcc:
@@ -1784,8 +1756,6 @@ end:
 /*
  *	Insmod can set static symbols so keep these static
  */
-static int io[4];
-static int irq[4];
 static int card;
 
 static int __devinit isicom_probe(struct pci_dev *pdev,
@@ -1813,7 +1783,6 @@ static int __devinit isicom_probe(struct
 
 	board->base = ioaddr;
 	board->irq = pciirq;
-	board->isa = NO;
 	card++;
 
 	pci_set_drvdata(pdev, board);
@@ -1888,20 +1857,6 @@ static int __init isicom_init(void)
  		}
 		isi_card[idx].base = 0;
 		isi_card[idx].irq = 0;
-
-		if (!io[idx])
-			continue;
-
-		if (irq[idx] == 2 || irq[idx] == 3 || irq[idx] == 4	||
-				irq[idx] == 5	|| irq[idx] == 7	||
-				irq[idx] == 10	|| irq[idx] == 11	||
-				irq[idx] == 12	|| irq[idx] == 15) {
-			printk(KERN_ERR "ISICOM: ISA not supported yet.\n");
-			retval = -EINVAL;
-			goto error;
-		} else
-			printk(KERN_ERR "ISICOM: Irq %d unsupported. "
-				"Disabling Card%d...\n", irq[idx], idx + 1);
 	}
 
 	/* tty driver structure initialization */
@@ -1971,7 +1926,3 @@ module_exit(isicom_exit);
 MODULE_AUTHOR("MultiTech");
 MODULE_DESCRIPTION("Driver for the ISI series of cards by MultiTech");
 MODULE_LICENSE("GPL");
-module_param_array(io, int, NULL, 0);
-MODULE_PARM_DESC(io, "I/O ports for the cards");
-module_param_array(irq, int, NULL, 0);
-MODULE_PARM_DESC(irq, "Interrupts for the cards");
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-isicom-remove-isa-code.patch
char-isicom-remove-unneeded-memset.patch
char-isicom-move-to-tty_register_device.patch
char-isicom-use-pci_request_region.patch
char-isicom-check-kmalloc-retval.patch
char-isicom-use-completion.patch
char-isicom-simplify-timer.patch
char-isicom-remove-cvs-stuff.patch
char-isicom-fix-tty-index-check.patch
char-sx-convert-to-pci-probing.patch
char-sx-use-kcalloc.patch
char-sx-mark-functions-as-devinit.patch
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

