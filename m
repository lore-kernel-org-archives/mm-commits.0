From: akpm@linux-foundation.org
Subject: - char-mxser_new-clean-request_irq-call.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:51:53 -0800
Message-ID: <200702112251.l1BMprJw015969@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60186 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932768AbXBKWvz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:51:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: mxser_new, clean request_irq call
has been removed from the -mm tree.  Its filename was
     char-mxser_new-clean-request_irq-call.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: mxser_new, clean request_irq call
From: Jiri Slaby <jirislaby@gmail.com>

We always set ASYNC_SHARE_IRQ, so do not test against this flag and request
shared irq directly.  Also remove nonsense comment.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser_new.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

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
