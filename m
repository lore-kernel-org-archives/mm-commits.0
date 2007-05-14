From: akpm@linux-foundation.org
Subject: + prevent-an-o_ndelay-writer-from-blocking-when-a-tty-write-is-blocked-by.patch added to -mm tree
Date: Mon, 14 May 2007 12:47:53 -0700
Message-ID: <200705141947.l4EJlrrf024595@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51651 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757400AbXENTsT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 May 2007 15:48:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com, djohnson+linux-kernel@sw.starentnetworks.com, torvalds@linux-foundation.org


The patch titled
     Prevent an O_NDELAY writer from blocking when a tty write is blocked by
has been added to the -mm tree.  Its filename is
     prevent-an-o_ndelay-writer-from-blocking-when-a-tty-write-is-blocked-by.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Prevent an O_NDELAY writer from blocking when a tty write is blocked by
From: Alan Cox <alan@redhat.com>

Without this a tty write could block if a previous blocking tty write was
in progress on the same tty and blocked by a line discipline or hardware
event.  Originally found and reported by Dave Johnson.

Signed-off-by: Alan Cox <alan@redhat.com>
Acked-by: Dave Johnson <djohnson+linux-kernel@sw.starentnetworks.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/n_hdlc.c    |    9 ++++----
 drivers/char/n_tty.c     |    3 +-
 drivers/char/tty_io.c    |   40 +++++++++++++++++++++++++------------
 drivers/char/tty_ioctl.c |    4 +--
 include/linux/tty.h      |    6 +++++
 5 files changed, 43 insertions(+), 19 deletions(-)

diff -puN drivers/char/n_hdlc.c~prevent-an-o_ndelay-writer-from-blocking-when-a-tty-write-is-blocked-by drivers/char/n_hdlc.c
--- a/drivers/char/n_hdlc.c~prevent-an-o_ndelay-writer-from-blocking-when-a-tty-write-is-blocked-by
+++ a/drivers/char/n_hdlc.c
@@ -780,13 +780,14 @@ static unsigned int n_hdlc_tty_poll(stru
 		poll_wait(filp, &tty->write_wait, wait);
 
 		/* set bits for operations that won't block */
-		if(n_hdlc->rx_buf_list.head)
+		if (n_hdlc->rx_buf_list.head)
 			mask |= POLLIN | POLLRDNORM;	/* readable */
 		if (test_bit(TTY_OTHER_CLOSED, &tty->flags))
 			mask |= POLLHUP;
-		if(tty_hung_up_p(filp))
+		if (tty_hung_up_p(filp))
 			mask |= POLLHUP;
-		if(n_hdlc->tx_free_buf_list.head)
+		if (!tty_is_writelocked(tty) &&
+				n_hdlc->tx_free_buf_list.head)
 			mask |= POLLOUT | POLLWRNORM;	/* writable */
 	}
 	return mask;
@@ -861,7 +862,7 @@ static void n_hdlc_buf_put(struct n_hdlc
 	spin_lock_irqsave(&list->spinlock,flags);
 	
 	buf->link=NULL;
-	if(list->tail)
+	if (list->tail)
 		list->tail->link = buf;
 	else
 		list->head = buf;
diff -puN drivers/char/n_tty.c~prevent-an-o_ndelay-writer-from-blocking-when-a-tty-write-is-blocked-by drivers/char/n_tty.c
--- a/drivers/char/n_tty.c~prevent-an-o_ndelay-writer-from-blocking-when-a-tty-write-is-blocked-by
+++ a/drivers/char/n_tty.c
@@ -1537,7 +1537,8 @@ static unsigned int normal_poll(struct t
 		else
 			tty->minimum_to_wake = 1;
 	}
-	if (tty->driver->chars_in_buffer(tty) < WAKEUP_CHARS &&
+	if (!tty_is_writelocked(tty) &&
+			tty->driver->chars_in_buffer(tty) < WAKEUP_CHARS &&
 			tty->driver->write_room(tty) > 0)
 		mask |= POLLOUT | POLLWRNORM;
 	return mask;
diff -puN drivers/char/tty_io.c~prevent-an-o_ndelay-writer-from-blocking-when-a-tty-write-is-blocked-by drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~prevent-an-o_ndelay-writer-from-blocking-when-a-tty-write-is-blocked-by
+++ a/drivers/char/tty_io.c
@@ -1719,6 +1719,23 @@ static ssize_t tty_read(struct file * fi
 	return i;
 }
 
+void tty_write_unlock(struct tty_struct *tty)
+{
+	mutex_unlock(&tty->atomic_write_lock);
+	wake_up_interruptible(&tty->write_wait);
+}
+
+int tty_write_lock(struct tty_struct *tty, int ndelay)
+{
+	if (!mutex_trylock(&tty->atomic_write_lock)) {
+		if (ndelay)
+			return -EAGAIN;
+		if (mutex_lock_interruptible(&tty->atomic_write_lock))
+			return -ERESTARTSYS;
+	}
+	return 0;
+}
+
 /*
  * Split writes up in sane blocksizes to avoid
  * denial-of-service type attacks
@@ -1730,13 +1747,12 @@ static inline ssize_t do_tty_write(
 	const char __user *buf,
 	size_t count)
 {
-	ssize_t ret = 0, written = 0;
+	ssize_t ret, written = 0;
 	unsigned int chunk;
 	
-	/* FIXME: O_NDELAY ... */
-	if (mutex_lock_interruptible(&tty->atomic_write_lock)) {
-		return -ERESTARTSYS;
-	}
+	ret = tty_write_lock(tty, file->f_flags & O_NDELAY);
+	if (ret < 0)
+		return ret;
 
 	/*
 	 * We chunk up writes into a temporary buffer. This
@@ -1769,8 +1785,8 @@ static inline ssize_t do_tty_write(
 
 		buf = kmalloc(chunk, GFP_KERNEL);
 		if (!buf) {
-			mutex_unlock(&tty->atomic_write_lock);
-			return -ENOMEM;
+			ret = -ENOMEM;
+			goto out;
 		}
 		kfree(tty->write_buf);
 		tty->write_cnt = chunk;
@@ -1805,7 +1821,8 @@ static inline ssize_t do_tty_write(
 		inode->i_mtime = current_fs_time(inode->i_sb);
 		ret = written;
 	}
-	mutex_unlock(&tty->atomic_write_lock);
+out:
+	tty_write_unlock(tty);
 	return ret;
 }
 
@@ -3156,14 +3173,13 @@ static int tiocsetd(struct tty_struct *t
 
 static int send_break(struct tty_struct *tty, unsigned int duration)
 {
-	if (mutex_lock_interruptible(&tty->atomic_write_lock))
+	if (tty_write_lock(tty, 0) < 0)
 		return -EINTR;
 	tty->driver->break_ctl(tty, -1);
-	if (!signal_pending(current)) {
+	if (!signal_pending(current))
 		msleep_interruptible(duration);
-	}
 	tty->driver->break_ctl(tty, 0);
-	mutex_unlock(&tty->atomic_write_lock);
+	tty_write_unlock(tty);
 	if (signal_pending(current))
 		return -EINTR;
 	return 0;
diff -puN drivers/char/tty_ioctl.c~prevent-an-o_ndelay-writer-from-blocking-when-a-tty-write-is-blocked-by drivers/char/tty_ioctl.c
--- a/drivers/char/tty_ioctl.c~prevent-an-o_ndelay-writer-from-blocking-when-a-tty-write-is-blocked-by
+++ a/drivers/char/tty_ioctl.c
@@ -667,7 +667,7 @@ static int send_prio_char(struct tty_str
 		return 0;
 	}
 
-	if (mutex_lock_interruptible(&tty->atomic_write_lock))
+	if (tty_write_lock(tty, 0) < 0)
 		return -ERESTARTSYS;
 
 	if (was_stopped)
@@ -675,7 +675,7 @@ static int send_prio_char(struct tty_str
 	tty->driver->write(tty, &ch, 1);
 	if (was_stopped)
 		stop_tty(tty);
-	mutex_unlock(&tty->atomic_write_lock);
+	tty_write_unlock(tty);
 	return 0;
 }
 
diff -puN include/linux/tty.h~prevent-an-o_ndelay-writer-from-blocking-when-a-tty-write-is-blocked-by include/linux/tty.h
--- a/include/linux/tty.h~prevent-an-o_ndelay-writer-from-blocking-when-a-tty-write-is-blocked-by
+++ a/include/linux/tty.h
@@ -338,6 +338,12 @@ extern struct tty_struct *get_current_tt
 
 extern struct mutex tty_mutex;
 
+extern void tty_write_unlock(struct tty_struct *tty);
+extern int tty_write_lock(struct tty_struct *tty, int ndelay);
+#define tty_is_writelocked(tty)  (mutex_is_locked(&tty->atomic_write_lock))
+
+
+
 /* n_tty.c */
 extern struct tty_ldisc tty_ldisc_N_TTY;
 
_

Patches currently in -mm which might be from alan@redhat.com are

libata-acpi-add-infrastructure-for-drivers-to-use.patch
pata_acpi-restore-driver.patch
pata_ali-more-work.patch
sl82c105-switch-to-ref-counting-api.patch
watchdog-documentation.patch
prevent-an-o_ndelay-writer-from-blocking-when-a-tty-write-is-blocked-by.patch
revoke-special-mmap-handling.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
