From: akpm@osdl.org
Subject: + char-mxser_new-remove-unused-stuff.patch added to -mm tree
Date: Thu, 28 Dec 2006 15:22:48 -0800
Message-ID: <200612282322.kBSNMmA1015988@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:41035 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753770AbWL1XWw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Dec 2006 18:22:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: mxser_new, remove unused stuff
has been added to the -mm tree.  Its filename is
     char-mxser_new-remove-unused-stuff.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: mxser_new, remove unused stuff
From: Jiri Slaby <jirislaby@gmail.com>

- nobody waits on close_wait
- ASYNC_SPLIT_TERMIOS is not set by anybody, so do not test this flag
- process session and pgrp are useless information

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/mxser_new.c |   18 ------------------
 1 files changed, 18 deletions(-)

diff -puN drivers/char/mxser_new.c~char-mxser_new-remove-unused-stuff drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~char-mxser_new-remove-unused-stuff
+++ a/drivers/char/mxser_new.c
@@ -237,8 +237,6 @@ struct mxser_port {
 	long realbaud;
 	int type;		/* UART type */
 	int flags;		/* defined in tty.h */
-	long session;		/* Session of opening process */
-	long pgrp;		/* pgrp of opening process */
 
 	int x_char;		/* xon/xoff character */
 	int IER;		/* Interrupt Enable Register */
@@ -267,14 +265,12 @@ struct mxser_port {
 	int xmit_cnt;
 
 	struct ktermios normal_termios;
-	struct ktermios callout_termios;
 
 	struct mxser_mon mon_data;
 
 	spinlock_t slock;
 	struct work_struct tqueue;
 	wait_queue_head_t open_wait;
-	wait_queue_head_t close_wait;
 	wait_queue_head_t delta_msr_wait;
 };
 
@@ -936,17 +932,6 @@ static int mxser_open(struct tty_struct 
 	if (retval)
 		return retval;
 
-	if ((info->count == 1) && (info->flags & ASYNC_SPLIT_TERMIOS)) {
-		if (tty->driver->subtype == SERIAL_TYPE_NORMAL)
-			*tty->termios = info->normal_termios;
-		else
-			*tty->termios = info->callout_termios;
-		mxser_change_speed(info, NULL);
-	}
-
-	info->session = process_session(current);
-	info->pgrp = process_group(current);
-
 	/* unmark here for very high baud rate (ex. 921600 bps) used */
 	tty->low_latency = 1;
 	return 0;
@@ -1053,8 +1038,6 @@ static void mxser_close(struct tty_struc
 	}
 
 	info->flags &= ~(ASYNC_NORMAL_ACTIVE | ASYNC_CLOSING);
-	wake_up_interruptible(&info->close_wait);
-
 }
 
 static int mxser_write(struct tty_struct *tty, const unsigned char *buf, int count)
@@ -2420,7 +2403,6 @@ static int __devinit mxser_initbrd(struc
 		INIT_WORK(&info->tqueue, mxser_do_softint);
 		info->normal_termios = mxvar_sdriver->init_termios;
 		init_waitqueue_head(&info->open_wait);
-		init_waitqueue_head(&info->close_wait);
 		init_waitqueue_head(&info->delta_msr_wait);
 		memset(&info->mon_data, 0, sizeof(struct mxser_mon));
 		info->err_shadow = 0;
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

