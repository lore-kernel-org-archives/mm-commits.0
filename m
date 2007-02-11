From: akpm@linux-foundation.org
Subject: - char-tty-delete-wake_up_interruptible-after-tty_wakeup.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:50:11 -0800
Message-ID: <200702112250.l1BMoBSt015831@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59983 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932745AbXBKWuP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:50:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: tty, delete wake_up_interruptible after tty_wakeup
has been removed from the -mm tree.  Its filename was
     char-tty-delete-wake_up_interruptible-after-tty_wakeup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: tty, delete wake_up_interruptible after tty_wakeup
From: Jiri Slaby <jirislaby@gmail.com>

tty_wakeup calls wake_up_interruptible(&tty->write_wait) itself, it's not
needed to wake up again after tty_wakeup returns.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_io.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/char/tty_io.c~char-tty-delete-wake_up_interruptible-after-tty_wakeup drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~char-tty-delete-wake_up_interruptible-after-tty_wakeup
+++ a/drivers/char/tty_io.c
@@ -1612,7 +1612,6 @@ void start_tty(struct tty_struct *tty)
 
 	/* If we have a running line discipline it may need kicking */
 	tty_wakeup(tty);
-	wake_up_interruptible(&tty->write_wait);
 }
 
 EXPORT_SYMBOL(start_tty);
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
