From: akpm@osdl.org
Subject: + char-mxser_new-fix-twice-resource-releasing.patch added to -mm tree
Date: Tue, 02 Jan 2007 13:11:26 -0800
Message-ID: <200701022111.l02LBQ03029795@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:60866 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754957AbXABVLl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 16:11:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, osv@javad.com


The patch titled
     Char: mxser_new, fix twice resource releasing
has been added to the -mm tree.  Its filename is
     char-mxser_new-fix-twice-resource-releasing.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: mxser_new, fix twice resource releasing
From: Jiri Slaby <jirislaby@gmail.com>

Because brd->info is not NULLed, resources are released twice.  NULL it in
pci_remove function.  Also take care of retval and releasing in pci_probe --
mxser_initbrd alreasy releases resource, do not do it again in fail path in
probe function.

Cc: Sergei Organov <osv@javad.com>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/mxser_new.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/char/mxser_new.c~char-mxser_new-fix-twice-resource-releasing drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~char-mxser_new-fix-twice-resource-releasing
+++ a/drivers/char/mxser_new.c
@@ -2403,9 +2403,8 @@ static int __devinit mxser_initbrd(struc
 			brd->info->name, brd->irq);
 		/* We hold resources, we need to release them. */
 		mxser_release_res(brd, pdev, 0);
-		return retval;
 	}
-	return 0;
+	return retval;
 }
 
 static int __init mxser_get_ISA_conf(int cap, struct mxser_board *brd)
@@ -2590,8 +2589,9 @@ static int __devinit mxser_probe(struct 
 	}
 
 	/* mxser_initbrd will hook ISR. */
-	if (mxser_initbrd(brd, pdev) < 0)
-		goto err_relvec;
+	retval = mxser_initbrd(brd, pdev);
+	if (retval)
+		goto err_null;
 
 	for (i = 0; i < brd->info->nports; i++)
 		tty_register_device(mxvar_sdriver, brd->idx + i, &pdev->dev);
@@ -2599,10 +2599,9 @@ static int __devinit mxser_probe(struct 
 	pci_set_drvdata(pdev, brd);
 
 	return 0;
-err_relvec:
-	pci_release_region(pdev, 3);
 err_relio:
 	pci_release_region(pdev, 2);
+err_null:
 	brd->info = NULL;
 err:
 	return retval;
@@ -2620,6 +2619,7 @@ static void __devexit mxser_remove(struc
 		tty_unregister_device(mxvar_sdriver, brd->idx + i);
 
 	mxser_release_res(brd, pdev, 1);
+	brd->info = NULL;
 }
 
 static struct pci_driver mxser_driver = {
_

Patches currently in -mm which might be from jirislaby@gmail.com are

git-input.patch
char-tty-delete-wake_up_interruptible-after-tty_wakeup.patch
char-isicom-remove-tty_hangwakeup-bottomhalves.patch
mxser-remove-ambiguous-redefinition-of-init_work.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
char-isicom-fix-locking-in-isr.patch
char-isicom-augment-card_reset.patch
char-isicom-check-card-state-in-isr.patch
char-isicom-support-higher-rates.patch
char-isicom-correct-probing-removing.patch
char-tty_wakeup-cleanup.patch
char-mxser_new-mark-init-functions.patch
char-mxser_new-remove-useless-spinlock.patch
char-serial167-cleanup.patch
char-n_r3964-cleanup.patch
char-mxser_new-remove-unused-stuff.patch
char-mxser-obsolete-old-nonexperimental-new.patch
char-mxser_new-remove-tty_wakeup-bottomhalf.patch
char-mxser_new-clean-request_irq-call.patch
doc-isicom-remove-reserved-ioctl-number.patch
char-mxser_new-alter-locking-in-isr.patch
char-mxser_new-header-file-cleanup.patch
char-mxser_new-less-loops-in-isr.patch
char-mxser_new-fix-twice-resource-releasing.patch
shrink_slab-handle-bad-shrinkers.patch
