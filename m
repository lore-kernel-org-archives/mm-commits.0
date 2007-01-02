From: akpm@osdl.org
Subject: + char-mxser_new-do-not-put-pdev.patch added to -mm tree
Date: Tue, 02 Jan 2007 13:50:48 -0800
Message-ID: <200701022150.l02LomRM030938@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35781 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753646AbXABVu4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 16:50:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: mxser_new, do not put pdev
has been added to the -mm tree.  Its filename is
     char-mxser_new-do-not-put-pdev.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: mxser_new, do not put pdev
From: Jiri Slaby <jirislaby@gmail.com>

We don't call pci_dev_get, so do not call pci_dev_put in the pci release
function.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/mxser_new.c |    1 -
 1 files changed, 1 deletion(-)

diff -puN drivers/char/mxser_new.c~char-mxser_new-do-not-put-pdev drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~char-mxser_new-do-not-put-pdev
+++ a/drivers/char/mxser_new.c
@@ -2348,7 +2348,6 @@ static void mxser_release_res(struct mxs
 #ifdef CONFIG_PCI
 		pci_release_region(pdev, 2);
 		pci_release_region(pdev, 3);
-		pci_dev_put(pdev);
 #endif
 	} else {
 		release_region(brd->ports[0].ioaddr, 8 * brd->info->nports);
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
char-mxser_new-do-not-put-pdev.patch
shrink_slab-handle-bad-shrinkers.patch
