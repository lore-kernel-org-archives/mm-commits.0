From: akpm@linux-foundation.org
Subject: - tty-add-throttle-unthrottle-helpers.patch removed from -mm tree
Date: Thu, 01 May 2008 02:30:58 -0700
Message-ID: <200805010930.m419UwoJ030816@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46462 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757058AbYEAJbi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:31:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, arjan@infradead.org, mm-commits@vger.kernel.org


The patch titled
     tty: add throttle/unthrottle helpers
has been removed from the -mm tree.  Its filename was
     tty-add-throttle-unthrottle-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tty: add throttle/unthrottle helpers
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Something Arjan suggested which allows us to clean up the code nicely

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/bluetooth/hci_ldisc.c |    4 +---
 drivers/char/n_tty.c          |   14 ++++----------
 drivers/char/tty_ioctl.c      |   16 ++++++++++++++++
 drivers/net/hamradio/6pack.c  |    4 +---
 drivers/net/hamradio/mkiss.c  |    4 +---
 drivers/net/ppp_async.c       |    4 +---
 drivers/net/ppp_synctty.c     |    4 +---
 include/linux/tty.h           |    2 ++
 include/linux/tty_driver.h    |    4 ++++
 9 files changed, 31 insertions(+), 25 deletions(-)

diff -puN drivers/bluetooth/hci_ldisc.c~tty-add-throttle-unthrottle-helpers drivers/bluetooth/hci_ldisc.c
--- a/drivers/bluetooth/hci_ldisc.c~tty-add-throttle-unthrottle-helpers
+++ a/drivers/bluetooth/hci_ldisc.c
@@ -370,9 +370,7 @@ static void hci_uart_tty_receive(struct 
 	hu->hdev->stat.byte_rx += count;
 	spin_unlock(&hu->rx_lock);
 
-	if (test_and_clear_bit(TTY_THROTTLED, &tty->flags) &&
-					tty->ops->unthrottle)
-		tty->ops->unthrottle(tty);
+	tty_unthrottle(tty);
 }
 
 static int hci_uart_register_dev(struct hci_uart *hu)
diff -puN drivers/char/n_tty.c~tty-add-throttle-unthrottle-helpers drivers/char/n_tty.c
--- a/drivers/char/n_tty.c~tty-add-throttle-unthrottle-helpers
+++ a/drivers/char/n_tty.c
@@ -147,10 +147,8 @@ static void put_tty_queue(unsigned char 
 
 static void check_unthrottle(struct tty_struct *tty)
 {
-	if (tty->count &&
-	    test_and_clear_bit(TTY_THROTTLED, &tty->flags) &&
-	    tty->ops->unthrottle)
-		tty->ops->unthrottle(tty);
+	if (tty->count)
+		tty_unthrottle(tty);
 }
 
 /**
@@ -982,12 +980,8 @@ static void n_tty_receive_buf(struct tty
 	 * mode.  We don't want to throttle the driver if we're in
 	 * canonical mode and don't have a newline yet!
 	 */
-	if (tty->receive_room < TTY_THRESHOLD_THROTTLE) {
-		/* check TTY_THROTTLED first so it indicates our state */
-		if (!test_and_set_bit(TTY_THROTTLED, &tty->flags) &&
-		    tty->ops->throttle)
-			tty->ops->throttle(tty);
-	}
+	if (tty->receive_room < TTY_THRESHOLD_THROTTLE)
+		tty_throttle(tty);
 }
 
 int is_ignored(int sig)
diff -puN drivers/char/tty_ioctl.c~tty-add-throttle-unthrottle-helpers drivers/char/tty_ioctl.c
--- a/drivers/char/tty_ioctl.c~tty-add-throttle-unthrottle-helpers
+++ a/drivers/char/tty_ioctl.c
@@ -67,6 +67,22 @@ void tty_driver_flush_buffer(struct tty_
 
 EXPORT_SYMBOL(tty_driver_flush_buffer);
 
+void tty_throttle(struct tty_struct *tty)
+{
+	/* check TTY_THROTTLED first so it indicates our state */
+	if (!test_and_set_bit(TTY_THROTTLED, &tty->flags) &&
+	    tty->ops->throttle)
+		tty->ops->throttle(tty);
+}
+EXPORT_SYMBOL(tty_throttle);
+
+void tty_unthrottle(struct tty_struct *tty)
+{
+	if (test_and_clear_bit(TTY_THROTTLED, &tty->flags) &&
+	    tty->ops->unthrottle)
+		tty->ops->unthrottle(tty);
+}
+EXPORT_SYMBOL(tty_unthrottle);
 
 /**
  *	tty_wait_until_sent	-	wait for I/O to finish
diff -puN drivers/net/hamradio/6pack.c~tty-add-throttle-unthrottle-helpers drivers/net/hamradio/6pack.c
--- a/drivers/net/hamradio/6pack.c~tty-add-throttle-unthrottle-helpers
+++ a/drivers/net/hamradio/6pack.c
@@ -491,9 +491,7 @@ static void sixpack_receive_buf(struct t
 	sixpack_decode(sp, buf, count1);
 
 	sp_put(sp);
-	if (test_and_clear_bit(TTY_THROTTLED, &tty->flags)
-	    && tty->ops->unthrottle)
-		tty->ops->unthrottle(tty);
+	tty_unthrottle(tty);
 }
 
 /*
diff -puN drivers/net/hamradio/mkiss.c~tty-add-throttle-unthrottle-helpers drivers/net/hamradio/mkiss.c
--- a/drivers/net/hamradio/mkiss.c~tty-add-throttle-unthrottle-helpers
+++ a/drivers/net/hamradio/mkiss.c
@@ -936,9 +936,7 @@ static void mkiss_receive_buf(struct tty
 	}
 
 	mkiss_put(ax);
-	if (test_and_clear_bit(TTY_THROTTLED, &tty->flags)
-	    && tty->ops->unthrottle)
-		tty->ops->unthrottle(tty);
+	tty_unthrottle(tty);
 }
 
 /*
diff -puN drivers/net/ppp_async.c~tty-add-throttle-unthrottle-helpers drivers/net/ppp_async.c
--- a/drivers/net/ppp_async.c~tty-add-throttle-unthrottle-helpers
+++ a/drivers/net/ppp_async.c
@@ -361,9 +361,7 @@ ppp_asynctty_receive(struct tty_struct *
 	if (!skb_queue_empty(&ap->rqueue))
 		tasklet_schedule(&ap->tsk);
 	ap_put(ap);
-	if (test_and_clear_bit(TTY_THROTTLED, &tty->flags)
-	    && tty->ops->unthrottle)
-		tty->ops->unthrottle(tty);
+	tty_unthrottle(tty);
 }
 
 static void
diff -puN drivers/net/ppp_synctty.c~tty-add-throttle-unthrottle-helpers drivers/net/ppp_synctty.c
--- a/drivers/net/ppp_synctty.c~tty-add-throttle-unthrottle-helpers
+++ a/drivers/net/ppp_synctty.c
@@ -401,9 +401,7 @@ ppp_sync_receive(struct tty_struct *tty,
 	if (!skb_queue_empty(&ap->rqueue))
 		tasklet_schedule(&ap->tsk);
 	sp_put(ap);
-	if (test_and_clear_bit(TTY_THROTTLED, &tty->flags)
-	    && tty->ops->unthrottle)
-		tty->ops->unthrottle(tty);
+	tty_unthrottle(tty);
 }
 
 static void
diff -puN include/linux/tty.h~tty-add-throttle-unthrottle-helpers include/linux/tty.h
--- a/include/linux/tty.h~tty-add-throttle-unthrottle-helpers
+++ a/include/linux/tty.h
@@ -303,6 +303,8 @@ extern int tty_put_char(struct tty_struc
 extern int tty_chars_in_buffer(struct tty_struct *tty);
 extern int tty_write_room(struct tty_struct *tty);
 extern void tty_driver_flush_buffer(struct tty_struct *tty);
+extern void tty_throttle(struct tty_struct *tty);
+extern void tty_unthrottle(struct tty_struct *tty);
 
 extern int is_current_pgrp_orphaned(void);
 extern struct pid *tty_get_pgrp(struct tty_struct *tty);
diff -puN include/linux/tty_driver.h~tty-add-throttle-unthrottle-helpers include/linux/tty_driver.h
--- a/include/linux/tty_driver.h~tty-add-throttle-unthrottle-helpers
+++ a/include/linux/tty_driver.h
@@ -100,6 +100,8 @@
  * 	This routine notifies the tty driver that input buffers for
  * 	the line discipline are close to full, and it should somehow
  * 	signal that no more characters should be sent to the tty.
+ *
+ *	Optional: Always invoke via tty_throttle();
  * 
  * void (*unthrottle)(struct tty_struct * tty);
  *
@@ -107,6 +109,8 @@
  * 	that characters can now be sent to the tty without fear of
  * 	overrunning the input buffers of the line disciplines.
  * 
+ *	Optional: Always invoke via tty_unthrottle();
+ *
  * void (*stop)(struct tty_struct *tty);
  *
  * 	This routine notifies the tty driver that it should stop
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
pata_atiixp-simplex-clear.patch
pata_atiixp-dont-disable.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
generic-irq-let-setup_irq-reenable-a-shared-irq.patch
8250-switch-8250-drivers-to-use-_nocache-ioremaps.patch
sxc-fix-printk-warnings-on-sparc32.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

