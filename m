From: akpm@linux-foundation.org
Subject: - char-tty_ioctl-use-wait_event_interruptible_timeout.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:54:56 -0700
Message-ID: <200707162054.l6GKsu42001864@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58767 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759038AbXGPVPQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:15:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: tty_ioctl, use wait_event_interruptible_timeout
has been removed from the -mm tree.  Its filename was
     char-tty_ioctl-use-wait_event_interruptible_timeout.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: tty_ioctl, use wait_event_interruptible_timeout
From: Jiri Slaby <jirislaby@gmail.com>

tty_ioctl, use wait_event_interruptible_timeout

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_ioctl.c |   21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

diff -puN drivers/char/tty_ioctl.c~char-tty_ioctl-use-wait_event_interruptible_timeout drivers/char/tty_ioctl.c
--- a/drivers/char/tty_ioctl.c~char-tty_ioctl-use-wait_event_interruptible_timeout
+++ a/drivers/char/tty_ioctl.c
@@ -52,8 +52,6 @@
 
 void tty_wait_until_sent(struct tty_struct * tty, long timeout)
 {
-	DECLARE_WAITQUEUE(wait, current);
-
 #ifdef TTY_DEBUG_WAIT_UNTIL_SENT
 	char buf[64];
 	
@@ -61,26 +59,13 @@ void tty_wait_until_sent(struct tty_stru
 #endif
 	if (!tty->driver->chars_in_buffer)
 		return;
-	add_wait_queue(&tty->write_wait, &wait);
 	if (!timeout)
 		timeout = MAX_SCHEDULE_TIMEOUT;
-	do {
-#ifdef TTY_DEBUG_WAIT_UNTIL_SENT
-		printk(KERN_DEBUG "waiting %s...(%d)\n", tty_name(tty, buf),
-		       tty->driver->chars_in_buffer(tty));
-#endif
-		set_current_state(TASK_INTERRUPTIBLE);
-		if (signal_pending(current))
-			goto stop_waiting;
-		if (!tty->driver->chars_in_buffer(tty))
-			break;
-		timeout = schedule_timeout(timeout);
-	} while (timeout);
+	if (wait_event_interruptible_timeout(tty->write_wait,
+			!tty->driver->chars_in_buffer(tty), timeout))
+		return;
 	if (tty->driver->wait_until_sent)
 		tty->driver->wait_until_sent(tty, timeout);
-stop_waiting:
-	set_current_state(TASK_RUNNING);
-	remove_wait_queue(&tty->write_wait, &wait);
 }
 
 EXPORT_SYMBOL(tty_wait_until_sent);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
char-cyclades-add-firmware-loading.patch
char-cyclades-fix-sparse-warning.patch
char-isicom-cleanup-locking.patch
char-isicom-del_timer-at-exit.patch
char-isicom-proper-variables-types.patch
char-moxa-eliminate-busy-waiting.patch
char-specialix-remove-busy-waiting.patch
char-riscom8-eliminate-busy-loop.patch
char-vt-use-kzalloc.patch
char-vt-use-array_size.patch
char-kconfig-mxser_new-remove-experimental-comment.patch
char-stallion-remove-user-class-report-request.patch
char-istallion-initlocking-fixes-try-2.patch
stallion-remove-unneeded-lock_kernel.patch
some-kmalloc-memset-kzalloc-tree-wide.patch
shrink_slab-handle-bad-shrinkers.patch
