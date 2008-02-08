From: akpm@linux-foundation.org
Subject: + tty-bkl-pushdown-fix.patch added to -mm tree
Date: Fri, 08 Feb 2008 14:09:57 -0800
Message-ID: <200802082209.m18M9vqA016006@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39938 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758029AbYBHWKa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 17:10:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     tty: BKL pushdown fix
has been added to the -mm tree.  Its filename is
     tty-bkl-pushdown-fix.patch

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
Subject: tty: BKL pushdown fix
From: Jiri Slaby <jirislaby@gmail.com>

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_io.c |    8 +++++---
 drivers/char/vt.c     |    4 ++--
 2 files changed, 7 insertions(+), 5 deletions(-)

diff -puN drivers/char/tty_io.c~tty-bkl-pushdown-fix drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~tty-bkl-pushdown-fix
+++ a/drivers/char/tty_io.c
@@ -1207,8 +1207,8 @@ static unsigned int hung_up_tty_poll(str
 	return POLLIN | POLLOUT | POLLERR | POLLHUP | POLLRDNORM | POLLWRNORM;
 }
 
-static long hung_up_tty_ioctl(struct inode *inode, struct file *file,
-			     unsigned int cmd, unsigned long arg)
+static long hung_up_tty_ioctl(struct file *file, unsigned int cmd,
+		unsigned long arg)
 {
 	return cmd == TIOCSPGRP ? -ENOTTY : -EIO;
 }
@@ -1262,7 +1262,7 @@ static const struct file_operations hung
 	.read		= hung_up_tty_read,
 	.write		= hung_up_tty_write,
 	.poll		= hung_up_tty_poll,
-	.ioctl		= hung_up_tty_ioctl,
+	.unlocked_ioctl	= hung_up_tty_ioctl,
 	.compat_ioctl	= hung_up_tty_compat_ioctl,
 	.release	= tty_release,
 };
@@ -3215,6 +3215,8 @@ static int tiocsetd(struct tty_struct *t
 	lock_kernel();
 	ret = tty_set_ldisc(tty, ldisc);
 	unlock_kernel();
+
+	return ret;
 }
 
 /**
diff -puN drivers/char/vt.c~tty-bkl-pushdown-fix drivers/char/vt.c
--- a/drivers/char/vt.c~tty-bkl-pushdown-fix
+++ a/drivers/char/vt.c
@@ -2553,7 +2553,7 @@ int tioclinux(struct tty_struct *tty, un
 			ret = sel_loadlut(p);
 			break;
 		case TIOCL_GETSHIFTSTATE:
-			
+
 	/*
 	 * Make it possible to react to Shift+Mousebutton.
 	 * Note that 'shift_state' is an undocumented
@@ -3823,7 +3823,7 @@ static int con_font_get(struct vc_data *
 		goto out;
 
 	c = (font.width+7)/8 * 32 * font.charcount;
-	
+
 	if (op->data && font.charcount > op->charcount)
 		rc = -ENOSPC;
 	if (!(op->flags & KD_FONT_FLAG_OLD)) {
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-drm.patch
drm-i915-fix-oops-after-killing-x.patch
git-watchdog.patch
tty-bkl-pushdown-fix.patch
tty-bkl-pushdown-fix1.patch
mxser-convert-large-macros-to-functions.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
