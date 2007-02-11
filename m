From: akpm@linux-foundation.org
Subject: - char-mxser_new-lock-count-and-flags.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:52:12 -0800
Message-ID: <200702112252.l1BMqCHe015996@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60231 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932786AbXBKWwP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:52:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, osv@javad.com, mm-commits@vger.kernel.org


The patch titled
     Char: mxser_new, lock count and flags
has been removed from the -mm tree.  Its filename was
     char-mxser_new-lock-count-and-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: mxser_new, lock count and flags
From: Jiri Slaby <jirislaby@gmail.com>

Both open count and INITIALIZED flag should be changed under lock.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: <osv@javad.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser_new.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/char/mxser_new.c~char-mxser_new-lock-count-and-flags drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~char-mxser_new-lock-count-and-flags
+++ a/drivers/char/mxser_new.c
@@ -853,9 +853,9 @@ static int mxser_startup(struct mxser_po
 	 * and set the speed of the serial port
 	 */
 	mxser_change_speed(info, NULL);
+	info->flags |= ASYNC_INITIALIZED;
 	spin_unlock_irqrestore(&info->slock, flags);
 
-	info->flags |= ASYNC_INITIALIZED;
 	return 0;
 }
 
@@ -925,6 +925,7 @@ static void mxser_shutdown(struct mxser_
 static int mxser_open(struct tty_struct *tty, struct file *filp)
 {
 	struct mxser_port *info;
+	unsigned long flags;
 	int retval, line;
 
 	line = tty->index;
@@ -941,7 +942,9 @@ static int mxser_open(struct tty_struct 
 	/*
 	 * Start up serial port
 	 */
+	spin_lock_irqsave(&info->slock, flags);
 	info->count++;
+	spin_unlock_irqrestore(&info->slock, flags);
 	retval = mxser_startup(info);
 	if (retval)
 		return retval;
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
