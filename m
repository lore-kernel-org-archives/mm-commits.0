From: akpm@linux-foundation.org
Subject: + tty-remove-unused-var-real_tty-in-n_tty_ioctl.patch added to -mm tree
Date: Mon, 02 Jun 2008 17:06:14 -0700
Message-ID: <200806030006.m5306EJs006750@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38787 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752596AbYFCAGm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Jun 2008 20:06:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gustavo@las.ic.unicamp.br, alan@redhat.com


The patch titled
     tty: remove unused var real_tty in n_tty_ioctl()
has been added to the -mm tree.  Its filename is
     tty-remove-unused-var-real_tty-in-n_tty_ioctl.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
