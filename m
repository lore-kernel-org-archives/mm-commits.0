From: akpm@linux-foundation.org
Subject: + vt-hold-console_sem-across-sysfs-operations.patch added to -mm tree
Date: Wed, 28 May 2008 15:57:31 -0700
Message-ID: <200805282257.m4SMvV3q004576@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36931 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755682AbYE1W5m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 May 2008 18:57:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, aris@ruivo.org


The patch titled
     vt: hold console_sem across sysfs operations
has been added to the -mm tree.  Its filename is
     vt-hold-console_sem-across-sysfs-operations.patch

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
Subject: vt: hold console_sem across sysfs operations
From: Jiri Slaby <jirislaby@gmail.com>

Hold console sem while creating/destroying sysfs files.  Serialisation is
so far done by BKL held in tty release_dev and chrdev_open, but no other
locks are held in open path.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Aristeu Rozanski <aris@ruivo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/vt.c~vt-hold-console_sem-across-sysfs-operations drivers/char/vt.c
--- a/drivers/char/vt.c~vt-hold-console_sem-across-sysfs-operations
+++ a/drivers/char/vt.c
@@ -2746,8 +2746,8 @@ static int con_open(struct tty_struct *t
 				tty->termios->c_iflag |= IUTF8;
 			else
 				tty->termios->c_iflag &= ~IUTF8;
-			release_console_sem();
 			vcs_make_sysfs(tty);
+			release_console_sem();
 			return ret;
 		}
 	}
@@ -2772,8 +2772,8 @@ static void con_close(struct tty_struct 
 		if (vc)
 			vc->vc_tty = NULL;
 		tty->driver_data = NULL;
-		release_console_sem();
 		vcs_remove_sysfs(tty);
+		release_console_sem();
 		mutex_unlock(&tty_mutex);
 		/*
 		 * tty_mutex is released, but we still hold BKL, so there is
_

Patches currently in -mm which might be from jirislaby@gmail.com are

linux-next.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
vt-hold-console_sem-across-sysfs-operations.patch
ip2-push-bkl-down-for-the-firmware-interface.patch
rio-push-down-the-bkl-into-the-firmware-ioctl-handler.patch
sx-push-bkl-down-into-the-firmware-ioctl-handler.patch
ppdev-wrap-ioctl-handler-in-driver-and-push-lock-down.patch
dsp56k-bkl-pushdown.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

