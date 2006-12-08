From: akpm@osdl.org
Subject: - char-stallion-prints-cleanup.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:09:36 -0800
Message-ID: <200612082009.kB8K9ad9002725@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58644 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946262AbWLHUJk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:09:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: stallion, prints cleanup
has been removed from the -mm tree.  Its filename was
     char-stallion-prints-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: stallion, prints cleanup
From: Jiri Slaby <jirislaby@gmail.com>

Too many information is printed out (they may be easily obtained through
sysfs), wipe them out in probe function.  Convert rest of them to dev_
variants.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/stallion.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff -puN drivers/char/stallion.c~char-stallion-prints-cleanup drivers/char/stallion.c
--- a/drivers/char/stallion.c~char-stallion-prints-cleanup
+++ a/drivers/char/stallion.c
@@ -2421,9 +2421,6 @@ static int __devinit stl_pciprobe(struct
 	struct stlbrd *brdp;
 	unsigned int brdtype = ent->driver_data;
 
-	pr_debug("stl_initpcibrd(brdtype=%d,busnr=%x,devnr=%x)\n", brdtype,
-		pdev->bus->number, pdev->devfn);
-
 	if ((pdev->class >> 8) == PCI_CLASS_STORAGE_IDE)
 		return -ENODEV;
 
@@ -2435,21 +2432,13 @@ static int __devinit stl_pciprobe(struct
 	if ((brdp = stl_allocbrd()) == NULL)
 		return(-ENOMEM);
 	if ((brdp->brdnr = stl_getbrdnr()) < 0) {
-		printk("STALLION: too many boards found, "
+		dev_err(&pdev->dev, "too many boards found, "
 			"maximum supported %d\n", STL_MAXBRDS);
 		return(0);
 	}
 	brdp->brdtype = brdtype;
 
 /*
- *	Different Stallion boards use the BAR registers in different ways,
- *	so set up io addresses based on board type.
- */
-	pr_debug("%s(%d): BAR[]=%Lx,%Lx,%Lx,%Lx IRQ=%x\n", __FILE__, __LINE__,
-		pci_resource_start(pdev, 0), pci_resource_start(pdev, 1),
-		pci_resource_start(pdev, 2), pci_resource_start(pdev, 3), pdev->irq);
-
-/*
  *	We have all resources from the board, so let's setup the actual
  *	board structure now.
  */
@@ -2467,7 +2456,7 @@ static int __devinit stl_pciprobe(struct
 		brdp->ioaddr2 = pci_resource_start(pdev, 1);
 		break;
 	default:
-		printk("STALLION: unknown PCI board type=%d\n", brdtype);
+		dev_err(&pdev->dev, "unknown PCI board type=%u\n", brdtype);
 		break;
 	}
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

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

