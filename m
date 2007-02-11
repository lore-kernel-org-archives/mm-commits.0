From: akpm@linux-foundation.org
Subject: - char-mxser_new-fix-twice-resource-releasing.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:52:04 -0800
Message-ID: <200702112252.l1BMq4kB015984@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60218 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932768AbXBKWwK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:52:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, osv@javad.com, mm-commits@vger.kernel.org


The patch titled
     Char: mxser_new, fix twice resource releasing
has been removed from the -mm tree.  Its filename was
     char-mxser_new-fix-twice-resource-releasing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: mxser_new, fix twice resource releasing
From: Jiri Slaby <jirislaby@gmail.com>

Because brd->info is not NULLed, resources are released twice.  NULL it in
pci_remove function.  Also take care of retval and releasing in pci_probe --
mxser_initbrd alreasy releases resource, do not do it again in fail path in
probe function.

Cc: Sergei Organov <osv@javad.com>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser_new.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

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
