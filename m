From: akpm@linux-foundation.org
Subject: - tty-bkl-pushdown-fix.patch removed from -mm tree
Date: Tue, 29 Apr 2008 23:09:23 -0700
Message-ID: <200804300609.m3U69NhY030976@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47577 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755448AbYD3GJx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:09:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     tty: BKL pushdown fix
has been removed from the -mm tree.  Its filename was
     tty-bkl-pushdown-fix.patch

This patch was dropped because it was folded into tty-bkl-pushdown.patch

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
@@ -1246,8 +1246,8 @@ static unsigned int hung_up_tty_poll(str
 	return POLLIN | POLLOUT | POLLERR | POLLHUP | POLLRDNORM | POLLWRNORM;
 }
 
-static long hung_up_tty_ioctl(struct inode *inode, struct file *file,
-			     unsigned int cmd, unsigned long arg)
+static long hung_up_tty_ioctl(struct file *file, unsigned int cmd,
+		unsigned long arg)
 {
 	return cmd == TIOCSPGRP ? -ENOTTY : -EIO;
 }
@@ -1301,7 +1301,7 @@ static const struct file_operations hung
 	.read		= hung_up_tty_read,
 	.write		= hung_up_tty_write,
 	.poll		= hung_up_tty_poll,
-	.ioctl		= hung_up_tty_ioctl,
+	.unlocked_ioctl	= hung_up_tty_ioctl,
 	.compat_ioctl	= hung_up_tty_compat_ioctl,
 	.release	= tty_release,
 };
@@ -3254,6 +3254,8 @@ static int tiocsetd(struct tty_struct *t
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
@@ -2562,7 +2562,7 @@ int tioclinux(struct tty_struct *tty, un
 			ret = sel_loadlut(p);
 			break;
 		case TIOCL_GETSHIFTSTATE:
-			
+
 	/*
 	 * Make it possible to react to Shift+Mousebutton.
 	 * Note that 'shift_state' is an undocumented
@@ -3832,7 +3832,7 @@ static int con_font_get(struct vc_data *
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
mxser-prepare-for-bkl-pushdown.patch
tty-bkl-pushdown.patch
tty-bkl-pushdown-fix.patch
tty-bkl-pushdown-fix1.patch
char-moxa-remove-static-isa-support.patch
char-moxa-cleanup-module-param-passed-isa-init.patch
char-moxa-pci-io-space-fixup.patch
char-moxa-fix-tiocg-ssoftcar-param.patch
char-moxa-add-firmware-loading.patch
char-moxa-merge-c2xx-and-c320-firmware-loading.patch
char-moxa-remove-port-port.patch
char-moxa-remove-unused-port-entries.patch
char-moxa-centralize-board-readiness.patch
char-moxa-centralize-board-readiness-warning-fix.patch
char-moxa-timer-cleanup.patch
char-moxa-ioctl-cleanup.patch
char-moxa-merge-2-poll-functions.patch
char-moxa-cleanup-rx-tx.patch
char-moxa-serialise-timer.patch
char-moxa-rework-open-close.patch
char-moxa-little-cleanup.patch
char-moxa-remove-useless-tty-functions.patch
char-moxa-introduce-moxa_is_320-macro.patch
char-moxa-notify-about-board-readiness.patch
char-moxa-update-credits.patch
char-moxa-add-firmware-loading-fix.patch
char-espc-fix-possible-double-unlock.patch
char-ip2-macros-cleanup.patch
cyclades-coding-style-review.patch
cyclades-use-ioremap_nocache-for-clarity-as-proposed.patch
char-rio-fix-cirrus-defines.patch
drivers-char-ds1286c-use-time_before-time_before_eq-etc.patch
tty-serial-lay-the-foundations-for-the-next-set-of-reworks.patch
amiserial-switch-put-char-to-return-success-fail.patch
char-switch-gs-cyclades-and-esp-to-return-int-for-put_char.patch
mxser-switch-to-put_char-being-int.patch
pcmcia-serial-to-int-put_char-method.patch
riscom-rocket-switch-to-int-put_char-method.patch
serial167-switch-to-int-put_char-method.patch
specialix-switch-to-int-put_char-method.patch
synclink-series-switch-to-int-put_char-method.patch
consoles-switch-to-int-put_char-method.patch
isicom-bring-into-coding-style.patch
isicom-bring-into-coding-style-fix.patch
tty-the-big-operations-rework-isicom-fix.patch
riscom8-coding-style.patch
epca-coding-style.patch
esp-clean-up-to-modern-coding-style.patch
isicom-fix-buffer-allocation.patch
char-serial-switch-drivers-to-ioremap_nocache.patch
mxser-convert-large-macros-to-functions.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

