From: akpm@linux-foundation.org
Subject: - tty-remove-unused-var-real_tty-in-n_tty_ioctl.patch removed from -mm tree
Date: Mon, 23 Jun 2008 14:04:16 -0700
Message-ID: <200806232104.m5NL4GkV016264@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54584 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759365AbYFWVEp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jun 2008 17:04:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gustavo@las.ic.unicamp.br, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     tty: remove unused var real_tty in n_tty_ioctl()
has been removed from the -mm tree.  Its filename was
     tty-remove-unused-var-real_tty-in-n_tty_ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tty: remove unused var real_tty in n_tty_ioctl()
From: Gustavo Fernando Padovan <gustavo@las.ic.unicamp.br>

'struct tty_struct *real_tty' is not used in this function, so remove it.

Signed-off-by: Gustavo Fernando Padovan <gustavo@las.ic.unicamp.br>
Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_ioctl.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN drivers/char/tty_ioctl.c~tty-remove-unused-var-real_tty-in-n_tty_ioctl drivers/char/tty_ioctl.c
--- a/drivers/char/tty_ioctl.c~tty-remove-unused-var-real_tty-in-n_tty_ioctl
+++ a/drivers/char/tty_ioctl.c
@@ -981,16 +981,9 @@ EXPORT_SYMBOL_GPL(tty_perform_flush);
 int n_tty_ioctl(struct tty_struct *tty, struct file *file,
 		       unsigned int cmd, unsigned long arg)
 {
-	struct tty_struct *real_tty;
 	unsigned long flags;
 	int retval;
 
-	if (tty->driver->type == TTY_DRIVER_TYPE_PTY &&
-	    tty->driver->subtype == PTY_TYPE_MASTER)
-		real_tty = tty->link;
-	else
-		real_tty = tty;
