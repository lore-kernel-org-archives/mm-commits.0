From: akpm@osdl.org
Subject: - char-stallion-brd-struct-locking.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:09:52 -0800
Message-ID: <200612082009.kB8K9qkg002747@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58686 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946406AbWLHUJ4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:09:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: stallion, brd struct locking
has been removed from the -mm tree.  Its filename was
     char-stallion-brd-struct-locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: stallion, brd struct locking
From: Jiri Slaby <jirislaby@gmail.com>

Since assigning of stl_brds[brdnr] is racy, add locking to this critical
section.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/stallion.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff -puN drivers/char/stallion.c~char-stallion-brd-struct-locking drivers/char/stallion.c
--- a/drivers/char/stallion.c~char-stallion-brd-struct-locking
+++ a/drivers/char/stallion.c
@@ -136,6 +136,7 @@ static char		stl_unwanted[SC26198_RXFIFO
 
 /*****************************************************************************/
 
+static DEFINE_MUTEX(stl_brdslock);
 static struct stlbrd		*stl_brds[STL_MAXBRDS];
 
 /*
@@ -2303,7 +2304,6 @@ static int __devinit stl_brdinit(struct 
 		goto err;
 	}
 
-	stl_brds[brdp->brdnr] = brdp;
 	if ((brdp->state & BRD_FOUND) == 0) {
 		printk("STALLION: %s board not found, board=%d io=%x irq=%d\n",
 			stl_brdnames[brdp->brdtype], brdp->brdnr,
@@ -2329,8 +2329,6 @@ err_free:
 	release_region(brdp->ioaddr1, brdp->iosize1);
 	if (brdp->iosize2 > 0)
 		release_region(brdp->ioaddr2, brdp->iosize2);
-
-	stl_brds[brdp->brdnr] = NULL;
 err:
 	return retval;
 }
@@ -2383,12 +2381,17 @@ static int __devinit stl_pciprobe(struct
 		retval = -ENOMEM;
 		goto err;
 	}
+	mutex_lock(&stl_brdslock);
 	brdp->brdnr = stl_getbrdnr();
 	if (brdp->brdnr < 0) {
 		dev_err(&pdev->dev, "too many boards found, "
 			"maximum supported %d\n", STL_MAXBRDS);
+		mutex_unlock(&stl_brdslock);
 		goto err_fr;
 	}
+	stl_brds[brdp->brdnr] = brdp;
+	mutex_unlock(&stl_brdslock);
+
 	brdp->brdtype = brdtype;
 	brdp->state |= STL_PROBED;
 
@@ -2417,11 +2420,13 @@ static int __devinit stl_pciprobe(struct
 	brdp->irq = pdev->irq;
 	retval = stl_brdinit(brdp);
 	if (retval)
-		goto err_fr;
+		goto err_null;
 
 	pci_set_drvdata(pdev, brdp);
 
 	return 0;
+err_null:
+	stl_brds[brdp->brdnr] = NULL;
 err_fr:
 	kfree(brdp);
 err:
@@ -4735,10 +4740,13 @@ static int __init stallion_module_init(v
 		brdp->irqtype = conf.irqtype;
 		if (stl_brdinit(brdp))
 			kfree(brdp);
-		else
+		else {
+			stl_brds[brdp->brdnr] = brdp;
 			stl_nrbrds = i + 1;
+		}
 	}
 
+	/* this has to be _after_ isa finding because of locking */
 	retval = pci_register_driver(&stl_pcidriver);
 	if (retval && stl_nrbrds == 0)
 		goto err;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

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

