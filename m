From: akpm@linux-foundation.org
Subject: [merged] epoll-keyed-wakeups-v2-make-tty-use-keyed-wakeups.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:40:56 -0700
Message-ID: <200904011840.n31IeuET009174@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42937 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756734AbZDATgw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:36:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, alan@lxorguk.ukuu.org.uk, davem@davemloft.net, mingo@elte.hu, torvalds@linux-foundation.org, wli@movementarian.org, mm-commits@vger.kernel.org


The patch titled
     epoll keyed wakeups: make tty use keyed wakeups
has been removed from the -mm tree.  Its filename was
     epoll-keyed-wakeups-v2-make-tty-use-keyed-wakeups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: epoll keyed wakeups: make tty use keyed wakeups
From: Davide Libenzi <davidel@xmailserver.org>

Introduce keyed event wakeups inside the TTY code.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>
Cc: William Lee Irwin III <wli@movementarian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_io.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN drivers/char/tty_io.c~epoll-keyed-wakeups-v2-make-tty-use-keyed-wakeups drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~epoll-keyed-wakeups-v2-make-tty-use-keyed-wakeups
+++ a/drivers/char/tty_io.c
@@ -464,7 +464,7 @@ void tty_wakeup(struct tty_struct *tty)
 			tty_ldisc_deref(ld);
 		}
 	}
-	wake_up_interruptible(&tty->write_wait);
+	wake_up_interruptible_poll(&tty->write_wait, POLLOUT);
 }
 
 EXPORT_SYMBOL_GPL(tty_wakeup);
@@ -587,8 +587,8 @@ static void do_tty_hangup(struct work_st
 	 * FIXME: Once we trust the LDISC code better we can wait here for
 	 * ldisc completion and fix the driver call race
 	 */
-	wake_up_interruptible(&tty->write_wait);
-	wake_up_interruptible(&tty->read_wait);
+	wake_up_interruptible_poll(&tty->write_wait, POLLOUT);
+	wake_up_interruptible_poll(&tty->read_wait, POLLIN);
 	/*
 	 * Shutdown the current line discipline, and reset it to
 	 * N_TTY.
@@ -879,7 +879,7 @@ void stop_tty(struct tty_struct *tty)
 	if (tty->link && tty->link->packet) {
 		tty->ctrl_status &= ~TIOCPKT_START;
 		tty->ctrl_status |= TIOCPKT_STOP;
-		wake_up_interruptible(&tty->link->read_wait);
+		wake_up_interruptible_poll(&tty->link->read_wait, POLLIN);
 	}
 	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 	if (tty->ops->stop)
@@ -913,7 +913,7 @@ void start_tty(struct tty_struct *tty)
 	if (tty->link && tty->link->packet) {
 		tty->ctrl_status &= ~TIOCPKT_STOP;
 		tty->ctrl_status |= TIOCPKT_START;
-		wake_up_interruptible(&tty->link->read_wait);
+		wake_up_interruptible_poll(&tty->link->read_wait, POLLIN);
 	}
 	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 	if (tty->ops->start)
@@ -970,7 +970,7 @@ static ssize_t tty_read(struct file *fil
 void tty_write_unlock(struct tty_struct *tty)
 {
 	mutex_unlock(&tty->atomic_write_lock);
-	wake_up_interruptible(&tty->write_wait);
+	wake_up_interruptible_poll(&tty->write_wait, POLLOUT);
 }
 
 int tty_write_lock(struct tty_struct *tty, int ndelay)
@@ -1623,21 +1623,21 @@ void tty_release_dev(struct file *filp)
 
 		if (tty_closing) {
 			if (waitqueue_active(&tty->read_wait)) {
-				wake_up(&tty->read_wait);
+				wake_up_poll(&tty->read_wait, POLLIN);
 				do_sleep++;
 			}
 			if (waitqueue_active(&tty->write_wait)) {
-				wake_up(&tty->write_wait);
+				wake_up_poll(&tty->write_wait, POLLOUT);
 				do_sleep++;
 			}
 		}
 		if (o_tty_closing) {
 			if (waitqueue_active(&o_tty->read_wait)) {
-				wake_up(&o_tty->read_wait);
+				wake_up_poll(&o_tty->read_wait, POLLIN);
 				do_sleep++;
 			}
 			if (waitqueue_active(&o_tty->write_wait)) {
-				wake_up(&o_tty->write_wait);
+				wake_up_poll(&o_tty->write_wait, POLLOUT);
 				do_sleep++;
 			}
 		}
_

Patches currently in -mm which might be from davidel@xmailserver.org are

origin.patch
linux-next.patch

