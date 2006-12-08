From: akpm@osdl.org
Subject: - char-istallion-brdnr-locking.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:10:16 -0800
Message-ID: <200612082010.kB8KAG5V002790@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58751 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946505AbWLHUKU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:10:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: istallion, brdnr locking
has been removed from the -mm tree.  Its filename was
     char-istallion-brdnr-locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: istallion, brdnr locking
From: Jiri Slaby <jirislaby@gmail.com>

Kill possible race when getting brdnr by locking.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/istallion.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN drivers/char/istallion.c~char-istallion-brdnr-locking drivers/char/istallion.c
--- a/drivers/char/istallion.c~char-istallion-brdnr-locking
+++ a/drivers/char/istallion.c
@@ -189,6 +189,7 @@ static struct asystats	stli_cdkstats;
 
 /*****************************************************************************/
 
+static DEFINE_MUTEX(stli_brdslock);
 static struct stlibrd	*stli_brds[STL_MAXBRDS];
 
 static int		stli_shared;
@@ -3677,8 +3678,6 @@ stli_donestartup:
 
 static int __devinit stli_brdinit(struct stlibrd *brdp)
 {
-	stli_brds[brdp->brdnr] = brdp;
-
 	switch (brdp->brdtype) {
 	case BRD_ECP:
 	case BRD_ECPE:
@@ -3896,6 +3895,7 @@ static int stli_findeisabrds(void)
 		outb(0x1, (iobase + 0xc84));
 		if (stli_eisamemprobe(brdp))
 			outb(0, (iobase + 0xc84));
+		stli_brds[brdp->brdnr] = brdp;
 		stli_brdinit(brdp);
 	}
 
@@ -3933,14 +3933,18 @@ static int __devinit stli_pciprobe(struc
 		retval = -ENOMEM;
 		goto err;
 	}
+	mutex_lock(&stli_brdslock);
 	brdnr = stli_getbrdnr();
-	if (brdnr < 0) { /* TODO: locking */
+	if (brdnr < 0) {
 		printk(KERN_INFO "STALLION: too many boards found, "
 			"maximum supported %d\n", STL_MAXBRDS);
+		mutex_unlock(&stli_brdslock);
 		retval = -EIO;
 		goto err_fr;
 	}
 	brdp->brdnr = (unsigned int)brdnr;
+	stli_brds[brdp->brdnr] = brdp;
+	mutex_unlock(&stli_brdslock);
 	brdp->brdtype = BRD_ECPPCI;
 /*
  *	We have all resources from the board, so lets setup the actual
@@ -3950,11 +3954,13 @@ static int __devinit stli_pciprobe(struc
 	brdp->memaddr = pci_resource_start(pdev, 2);
 	retval = stli_brdinit(brdp);
 	if (retval)
-		goto err_fr;
+		goto err_null;
 
 	pci_set_drvdata(pdev, brdp);
 
 	return 0;
+err_null:
+	stli_brds[brdp->brdnr] = NULL;
 err_fr:
 	kfree(brdp);
 err:
@@ -4026,6 +4032,7 @@ static int stli_initbrds(void)
 		brdp->brdtype = conf.brdtype;
 		brdp->iobase = conf.ioaddr1;
 		brdp->memaddr = conf.memaddr;
+		stli_brds[brdp->brdnr] = brdp;
 		stli_brdinit(brdp);
 	}
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

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

