From: akpm@osdl.org
Subject: + char-mxser_new-clean-request_irq-call.patch added to -mm tree
Date: Thu, 28 Dec 2006 15:22:54 -0800
Message-ID: <200612282322.kBSNMsM2015997@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:41043 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755012AbWL1XW5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Dec 2006 18:22:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: mxser_new, clean request_irq call
has been added to the -mm tree.  Its filename is
     char-mxser_new-clean-request_irq-call.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: mxser_new, clean request_irq call
From: Jiri Slaby <jirislaby@gmail.com>

We always set ASYNC_SHARE_IRQ, so do not test against this flag and request
shared irq directly.  Also remove nonsense comment.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/mxser_new.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff -puN drivers/char/mxser_new.c~char-mxser_new-clean-request_irq-call drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~char-mxser_new-clean-request_irq-call
+++ a/drivers/char/mxser_new.c
@@ -2398,13 +2398,9 @@ static int __devinit mxser_initbrd(struc
 		outb(inb(info->ioaddr + UART_IER) & 0xf0,
 			info->ioaddr + UART_IER);
 	}
-	/*
-	 * Allocate the IRQ if necessary
-	 */
-
-	retval = request_irq(brd->irq, mxser_interrupt,
-			(brd->ports[0].flags & ASYNC_SHARE_IRQ) ? IRQF_SHARED :
-			IRQF_DISABLED, "mxser", brd);
+
+	retval = request_irq(brd->irq, mxser_interrupt, IRQF_SHARED, "mxser",
+			brd);
 	if (retval) {
 		printk(KERN_ERR "Board %s: Request irq failed, IRQ (%d) may "
 			"conflict with another device.\n",
_

Patches currently in -mm which might be from jirislaby@gmail.com are

add-gitignore-file-for-relocs-in-arch-i386-fix.patch
char-mxser-fix-oops-when-removing-opened.patch
char-isicom-eliminate-spinlock-recursion.patch
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
shrink_slab-handle-bad-shrinkers.patch

