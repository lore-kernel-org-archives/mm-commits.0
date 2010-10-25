From: akpm@linux-foundation.org
Subject: + n_hdlc-fix-read-and-write-locking.patch added to -mm tree
Date: Mon, 25 Oct 2010 13:05:14 -0700
Message-ID: <201010252005.o9PK5Et1013619@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56285 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757782Ab0JYUGB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Oct 2010 16:06:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulkf@microgate.com, alan@lxorguk.ukuu.org.uk, arnd@arndb.de, greg@kroah.com


The patch titled
     n_hdlc: fix read and write locking
has been added to the -mm tree.  Its filename is
     n_hdlc-fix-read-and-write-locking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: n_hdlc: fix read and write locking
From: Paul Fulghum <paulkf@microgate.com>

Fix locking in read and write code of n_hdlc line discipline.

2.6.36 replaced lock_kernel() with tty_lock().  The tty mutex is not
dropped automatically when the thread sleeps like the BKL.  This results
in a blocked read or write holding the tty mutex and stalling operations
by other devices that use the tty mutex.

A review of n_hdlc read and write code shows:
1. neither BKL or tty mutex are required for correct operation
2. read can block while read data is available if data is posted
   between availability check and call to interruptible_sleep_on()
3. write does not set process state to TASK_INTERRUPTIBLE
   on each pass through the processing loop which can cause
   unneeded scheduling of the thread

The unnecessary tty mutex references have been removed.

Read changed to use same code as n_tty read
for completing reads and blocking.

Write corrected to set process state to TASK_INTERRUPTIBLE on each pass
through processing loop.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/n_hdlc.c |   88 ++++++++++++++++++++--------------------
 1 file changed, 44 insertions(+), 44 deletions(-)

diff -puN drivers/char/n_hdlc.c~n_hdlc-fix-read-and-write-locking drivers/char/n_hdlc.c
--- a/drivers/char/n_hdlc.c~n_hdlc-fix-read-and-write-locking
+++ a/drivers/char/n_hdlc.c
@@ -581,8 +581,9 @@ static ssize_t n_hdlc_tty_read(struct tt
 			   __u8 __user *buf, size_t nr)
 {
 	struct n_hdlc *n_hdlc = tty2n_hdlc(tty);
-	int ret;
+	int ret = 0;
 	struct n_hdlc_buf *rbuf;
+	DECLARE_WAITQUEUE(wait, current);
 
 	if (debuglevel >= DEBUG_LEVEL_INFO)	
 		printk("%s(%d)n_hdlc_tty_read() called\n",__FILE__,__LINE__);
@@ -598,57 +599,55 @@ static ssize_t n_hdlc_tty_read(struct tt
 		return -EFAULT;
 	}
 
-	tty_lock();
+	add_wait_queue(&tty->read_wait, &wait);
 
 	for (;;) {
 		if (test_bit(TTY_OTHER_CLOSED, &tty->flags)) {
-			tty_unlock();
-			return -EIO;
+			ret = -EIO;
+			break;
 		}
+		if (tty_hung_up_p(file))
+			break;
 
-		n_hdlc = tty2n_hdlc (tty);
-		if (!n_hdlc || n_hdlc->magic != HDLC_MAGIC ||
-			 tty != n_hdlc->tty) {
-			tty_unlock();
-			return 0;
-		}
+		set_current_state(TASK_INTERRUPTIBLE);
 
 		rbuf = n_hdlc_buf_get(&n_hdlc->rx_buf_list);
-		if (rbuf)
+		if (rbuf) {
+			if (rbuf->count > nr) {
+				/* too large for caller's buffer */
+				ret = -EOVERFLOW;
+			} else {
+				if (copy_to_user(buf, rbuf->buf, rbuf->count))
+					ret = -EFAULT;
+				else
+					ret = rbuf->count;
+			}
+
+			if (n_hdlc->rx_free_buf_list.count >
+			    DEFAULT_RX_BUF_COUNT)
+				kfree(rbuf);
+			else
+				n_hdlc_buf_put(&n_hdlc->rx_free_buf_list, rbuf);
 			break;
+		}
 			
 		/* no data */
 		if (file->f_flags & O_NONBLOCK) {
-			tty_unlock();
-			return -EAGAIN;
+			ret = -EAGAIN;
+			break;
 		}
-			
-		interruptible_sleep_on (&tty->read_wait);
+
+		schedule();
+
 		if (signal_pending(current)) {
-			tty_unlock();
-			return -EINTR;
+			ret = -EINTR;
+			break;
 		}
 	}
-		
-	if (rbuf->count > nr)
-		/* frame too large for caller's buffer (discard frame) */
-		ret = -EOVERFLOW;
-	else {
-		/* Copy the data to the caller's buffer */
-		if (copy_to_user(buf, rbuf->buf, rbuf->count))
-			ret = -EFAULT;
-		else
-			ret = rbuf->count;
-	}
-	
-	/* return HDLC buffer to free list unless the free list */
-	/* count has exceeded the default value, in which case the */
-	/* buffer is freed back to the OS to conserve memory */
-	if (n_hdlc->rx_free_buf_list.count > DEFAULT_RX_BUF_COUNT)
-		kfree(rbuf);
-	else	
-		n_hdlc_buf_put(&n_hdlc->rx_free_buf_list,rbuf);
-	tty_unlock();
+
+	remove_wait_queue(&tty->read_wait, &wait);
+	set_current_state(TASK_RUNNING);
+
 	return ret;
 	
 }	/* end of n_hdlc_tty_read() */
@@ -691,14 +690,15 @@ static ssize_t n_hdlc_tty_write(struct t
 		count = maxframe;
 	}
 	
-	tty_lock();
-
 	add_wait_queue(&tty->write_wait, &wait);
-	set_current_state(TASK_INTERRUPTIBLE);
+
+	for (;;) {
+		set_current_state(TASK_INTERRUPTIBLE);
 	
-	/* Allocate transmit buffer */
-	/* sleep until transmit buffer available */		
-	while (!(tbuf = n_hdlc_buf_get(&n_hdlc->tx_free_buf_list))) {
+		tbuf = n_hdlc_buf_get(&n_hdlc->tx_free_buf_list);
+		if (tbuf)
+			break;
+
 		if (file->f_flags & O_NONBLOCK) {
 			error = -EAGAIN;
 			break;
@@ -731,7 +731,7 @@ static ssize_t n_hdlc_tty_write(struct t
 		n_hdlc_buf_put(&n_hdlc->tx_buf_list,tbuf);
 		n_hdlc_send_frames(n_hdlc,tty);
 	}
-	tty_unlock();
+
 	return error;
 	
 }	/* end of n_hdlc_tty_write() */
_

Patches currently in -mm which might be from paulkf@microgate.com are

n_hdlc-fix-read-and-write-locking.patch
synclink_gt-fix-per-device-locking.patch
drivers-char-synclink_gtc-fix-information-leak-to-userland.patch
drivers-char-synclink_gtc-add-extended-sync-feature.patch

