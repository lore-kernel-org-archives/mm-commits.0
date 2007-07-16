From: akpm@linux-foundation.org
Subject: - prevent-an-o_ndelay-writer-from-blocking-when-a-tty-write-is-blocked-by.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:53:12 -0700
Message-ID: <200707162053.l6GKrCVP001606@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41853 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755397AbXGPVSW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:18:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, djohnson+linux-kernel@sw.starentnetworks.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Prevent an O_NDELAY writer from blocking when a tty write is blocked by the tty atomic writer mutex
has been removed from the -mm tree.  Its filename was
     prevent-an-o_ndelay-writer-from-blocking-when-a-tty-write-is-blocked-by.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Prevent an O_NDELAY writer from blocking when a tty write is blocked by the tty atomic writer mutex
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
@@ -1538,7 +1538,8 @@ static unsigned int normal_poll(struct t
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
@@ -1726,6 +1726,23 @@ static ssize_t tty_read(struct file * fi
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
@@ -1737,13 +1754,12 @@ static inline ssize_t do_tty_write(
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
@@ -1776,8 +1792,8 @@ static inline ssize_t do_tty_write(
 
 		buf = kmalloc(chunk, GFP_KERNEL);
 		if (!buf) {
-			mutex_unlock(&tty->atomic_write_lock);
-			return -ENOMEM;
+			ret = -ENOMEM;
+			goto out;
 		}
 		kfree(tty->write_buf);
 		tty->write_cnt = chunk;
@@ -1812,7 +1828,8 @@ static inline ssize_t do_tty_write(
 		inode->i_mtime = current_fs_time(inode->i_sb);
 		ret = written;
 	}
-	mutex_unlock(&tty->atomic_write_lock);
+out:
+	tty_write_unlock(tty);
 	return ret;
 }
 
@@ -3163,14 +3180,13 @@ static int tiocsetd(struct tty_struct *t
 
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

origin.patch
git-ia64.patch
pata_acpi-restore-driver.patch
iomap-sort-out-the-broken-address-reporting-caused-by-the-iomap-layer.patch
ata-use-iomap_name.patch
sata_mv-test-patch-for-hightpoint-rocketraid-1740-1742.patch
pata_ali-more-work.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
dont-optimise-away-baud-rate-changes-when-bother-is-used.patch
x86_64-geode-hw-random-number-generator-depend-on-x86_3.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
blackfin-enable-arbitary-speed-serial-setting.patch
mbcs-remove-lots-of-global-symbols.patch
char-vt-use-kzalloc.patch
char-vt-use-array_size.patch
stallion-remove-unneeded-lock_kernel.patch
revoke-special-mmap-handling.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
