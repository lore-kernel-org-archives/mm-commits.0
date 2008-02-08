From: akpm@linux-foundation.org
Subject: + tty-bkl-pushdown.patch added to -mm tree
Date: Fri, 08 Feb 2008 13:34:31 -0800
Message-ID: <200802082134.m18LYV6g014440@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34754 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750859AbYBHVhq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:37:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     tty: BKL pushdown
has been added to the -mm tree.  Its filename is
     tty-bkl-pushdown.patch

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
Subject: tty: BKL pushdown
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

- Push the BKL down into the line disciplines
- Switch the tty layer to unlocked_ioctl
- Introduce a new ctrl_lock spin lock for the control bits
- Eliminate much of the lock_kernel use in n_tty
- Prepare to (but don't yet) call the drivers with the lock dropped
  on the paths that historically held the lock

BKL now primarily protects open/close/ldisc change in the tty layer

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/n_hdlc.c    |   24 ++++++--
 drivers/char/n_r3964.c   |   16 +++++
 drivers/char/n_tty.c     |   32 +++++++++--
 drivers/char/pty.c       |    3 +
 drivers/char/tty_io.c    |  101 +++++++++++++++++++++++++------------
 drivers/char/tty_ioctl.c |    6 ++
 drivers/char/vt.c        |    4 +
 include/linux/tty.h      |    4 -
 8 files changed, 142 insertions(+), 48 deletions(-)

diff -puN drivers/char/n_hdlc.c~tty-bkl-pushdown drivers/char/n_hdlc.c
--- a/drivers/char/n_hdlc.c~tty-bkl-pushdown
+++ a/drivers/char/n_hdlc.c
@@ -578,26 +578,36 @@ static ssize_t n_hdlc_tty_read(struct tt
 		return -EFAULT;
 	}
 
+	lock_kernel();
+
 	for (;;) {
-		if (test_bit(TTY_OTHER_CLOSED, &tty->flags))
+		if (test_bit(TTY_OTHER_CLOSED, &tty->flags)) {
+			unlock_kernel();
 			return -EIO;
+		}
 
 		n_hdlc = tty2n_hdlc (tty);
 		if (!n_hdlc || n_hdlc->magic != HDLC_MAGIC ||
-			 tty != n_hdlc->tty)
+			 tty != n_hdlc->tty) {
+			unlock_kernel();
 			return 0;
+		}
 
 		rbuf = n_hdlc_buf_get(&n_hdlc->rx_buf_list);
 		if (rbuf)
 			break;
 			
 		/* no data */
-		if (file->f_flags & O_NONBLOCK)
+		if (file->f_flags & O_NONBLOCK) {
+			unlock_kernel();
 			return -EAGAIN;
+		}
 			
 		interruptible_sleep_on (&tty->read_wait);
-		if (signal_pending(current))
+		if (signal_pending(current)) {
+			unlock_kernel();
 			return -EINTR;
+		}
 	}
 		
 	if (rbuf->count > nr)
@@ -618,7 +628,7 @@ static ssize_t n_hdlc_tty_read(struct tt
 		kfree(rbuf);
 	else	
 		n_hdlc_buf_put(&n_hdlc->rx_free_buf_list,rbuf);
-	
+	unlock_kernel();
 	return ret;
 	
 }	/* end of n_hdlc_tty_read() */
@@ -661,6 +671,8 @@ static ssize_t n_hdlc_tty_write(struct t
 		count = maxframe;
 	}
 	
+	lock_kernel();
+
 	add_wait_queue(&tty->write_wait, &wait);
 	set_current_state(TASK_INTERRUPTIBLE);
 	
@@ -695,7 +707,7 @@ static ssize_t n_hdlc_tty_write(struct t
 		n_hdlc_buf_put(&n_hdlc->tx_buf_list,tbuf);
 		n_hdlc_send_frames(n_hdlc,tty);
 	}
-
+	unlock_kernel();
 	return error;
 	
 }	/* end of n_hdlc_tty_write() */
diff -puN drivers/char/n_r3964.c~tty-bkl-pushdown drivers/char/n_r3964.c
--- a/drivers/char/n_r3964.c~tty-bkl-pushdown
+++ a/drivers/char/n_r3964.c
@@ -1075,12 +1075,15 @@ static ssize_t r3964_read(struct tty_str
 
 	TRACE_L("read()");
 
+	lock_kernel();
+
 	pClient = findClient(pInfo, task_pid(current));
 	if (pClient) {
 		pMsg = remove_msg(pInfo, pClient);
 		if (pMsg == NULL) {
 			/* no messages available. */
 			if (file->f_flags & O_NONBLOCK) {
+				unlock_kernel();
 				return -EAGAIN;
 			}
 			/* block until there is a message: */
@@ -1090,8 +1093,10 @@ static ssize_t r3964_read(struct tty_str
 
 		/* If we still haven't got a message, we must have been signalled */
 
-		if (!pMsg)
+		if (!pMsg) {
+			unlock_kernel();
 			return -EINTR;
+		}
 
 		/* deliver msg to client process: */
 		theMsg.msg_id = pMsg->msg_id;
@@ -1102,12 +1107,15 @@ static ssize_t r3964_read(struct tty_str
 		kfree(pMsg);
 		TRACE_M("r3964_read - msg kfree %p", pMsg);
 
-		if (copy_to_user(buf, &theMsg, count))
+		if (copy_to_user(buf, &theMsg, count)) {
+			unlock_kernel();
 			return -EFAULT;
+		}
 
 		TRACE_PS("read - return %d", count);
 		return count;
 	}
+	unlock_kernel();
 	return -EPERM;
 }
 
@@ -1156,6 +1164,8 @@ static ssize_t r3964_write(struct tty_st
 	pHeader->locks = 0;
 	pHeader->owner = NULL;
 
+	lock_kernel();
+
 	pClient = findClient(pInfo, task_pid(current));
 	if (pClient) {
 		pHeader->owner = pClient;
@@ -1173,6 +1183,8 @@ static ssize_t r3964_write(struct tty_st
 	add_tx_queue(pInfo, pHeader);
 	trigger_transmit(pInfo);
 
+	unlock_kernel();
+
 	return 0;
 }
 
diff -puN drivers/char/n_tty.c~tty-bkl-pushdown drivers/char/n_tty.c
--- a/drivers/char/n_tty.c~tty-bkl-pushdown
+++ a/drivers/char/n_tty.c
@@ -183,22 +183,24 @@ static void reset_buffer_flags(struct tt
  *	at hangup) or when the N_TTY line discipline internally has to
  *	clean the pending queue (for example some signals).
  *
- *	FIXME: tty->ctrl_status is not spinlocked and relies on
- *	lock_kernel() still.
+ *	Locking: ctrl_lock
  */
 
 static void n_tty_flush_buffer(struct tty_struct *tty)
 {
+	unsigned long flags;
 	/* clear everything and unthrottle the driver */
 	reset_buffer_flags(tty);
 
 	if (!tty->link)
 		return;
 
+	spin_lock_irqsave(&tty->ctrl_lock, flags);
 	if (tty->link->packet) {
 		tty->ctrl_status |= TIOCPKT_FLUSHREAD;
 		wake_up_interruptible(&tty->link->read_wait);
 	}
+	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 }
 
 /**
@@ -264,7 +266,7 @@ static inline int is_continuation(unsign
  *	relevant in the world today. If you ever need them, add them here.
  *
  *	Called from both the receive and transmit sides and can be called
- *	re-entrantly. Relies on lock_kernel() still.
+ *	re-entrantly. Relies on lock_kernel() for tty->column state.
  */
 
 static int opost(unsigned char c, struct tty_struct *tty)
@@ -275,6 +277,7 @@ static int opost(unsigned char c, struct
 	if (!space)
 		return -1;
 
+	lock_kernel();
 	if (O_OPOST(tty)) {
 		switch (c) {
 		case '\n':
@@ -323,6 +326,7 @@ static int opost(unsigned char c, struct
 		}
 	}
 	tty->driver->put_char(tty, c);
+	unlock_kernel();
 	return 0;
 }
 
@@ -337,7 +341,8 @@ static int opost(unsigned char c, struct
  *	the simple cases normally found and helps to generate blocks of
  *	symbols for the console driver and thus improve performance.
  *
- *	Called from write_chan under the tty layer write lock.
+ *	Called from write_chan under the tty layer write lock. Relies
+ *	on lock_kernel for the tty->column state.
  */
 
 static ssize_t opost_block(struct tty_struct *tty,
@@ -353,6 +358,7 @@ static ssize_t opost_block(struct tty_st
 	if (nr > space)
 		nr = space;
 
+	lock_kernel();
 	for (i = 0, cp = buf; i < nr; i++, cp++) {
 		switch (*cp) {
 		case '\n':
@@ -387,6 +393,7 @@ break_out:
 	if (tty->driver->flush_chars)
 		tty->driver->flush_chars(tty);
 	i = tty->driver->write(tty, buf, i);
+	unlock_kernel();
 	return i;
 }
 
@@ -1194,6 +1201,11 @@ extern ssize_t redirected_tty_write(stru
  *	Perform job control management checks on this file/tty descriptor
  *	and if appropriate send any needed signals and return a negative
  *	error code if action should be taken.
+ *
+ *	FIXME:
+ *	Locking: None - redirected write test is safe, testing
+ *	current->signal should possibly lock current->sighand
+ *	pgrp locking ?
  */
 
 static int job_control(struct tty_struct *tty, struct file *file)
@@ -1246,6 +1258,7 @@ static ssize_t read_chan(struct tty_stru
 	ssize_t size;
 	long timeout;
 	unsigned long flags;
+	int packet;
 
 do_it_again:
 
@@ -1289,16 +1302,19 @@ do_it_again:
 		if (mutex_lock_interruptible(&tty->atomic_read_lock))
 			return -ERESTARTSYS;
 	}
+	packet = tty->packet;
 
 	add_wait_queue(&tty->read_wait, &wait);
 	while (nr) {
 		/* First test for status change. */
-		if (tty->packet && tty->link->ctrl_status) {
+		if (packet && tty->link->ctrl_status) {
 			unsigned char cs;
 			if (b != buf)
 				break;
+			spin_lock_irqsave(&tty->link->ctrl_lock, flags);
 			cs = tty->link->ctrl_status;
 			tty->link->ctrl_status = 0;
+			spin_unlock_irqrestore(&tty->link->ctrl_lock, flags);
 			if (tty_put_user(tty, cs, b++)) {
 				retval = -EFAULT;
 				b--;
@@ -1333,6 +1349,7 @@ do_it_again:
 				retval = -ERESTARTSYS;
 				break;
 			}
+			/* FIXME: does n_tty_set_room need locking ? */
 			n_tty_set_room(tty);
 			timeout = schedule_timeout(timeout);
 			continue;
@@ -1340,7 +1357,7 @@ do_it_again:
 		__set_current_state(TASK_RUNNING);
 
 		/* Deal with packet mode. */
-		if (tty->packet && b == buf) {
+		if (packet && b == buf) {
 			if (tty_put_user(tty, TIOCPKT_DATA, b++)) {
 				retval = -EFAULT;
 				b--;
@@ -1388,6 +1405,8 @@ do_it_again:
 				break;
 		} else {
 			int uncopied;
+			/* The copy function takes the read lock and handles
+			   locking internally for this case */
 			uncopied = copy_from_read_buf(tty, &b, &nr);
 			uncopied += copy_from_read_buf(tty, &b, &nr);
 			if (uncopied) {
@@ -1429,7 +1448,6 @@ do_it_again:
 		 goto do_it_again;
 
 	n_tty_set_room(tty);
-
 	return retval;
 }
 
diff -puN drivers/char/pty.c~tty-bkl-pushdown drivers/char/pty.c
--- a/drivers/char/pty.c~tty-bkl-pushdown
+++ a/drivers/char/pty.c
@@ -181,6 +181,7 @@ static int pty_set_lock(struct tty_struc
 static void pty_flush_buffer(struct tty_struct *tty)
 {
 	struct tty_struct *to = tty->link;
+	unsigned long flags;
 	
 	if (!to)
 		return;
@@ -189,8 +190,10 @@ static void pty_flush_buffer(struct tty_
 		to->ldisc.flush_buffer(to);
 	
 	if (to->packet) {
+		spin_lock_irqsave(&tty->ctrl_lock, flags);
 		tty->ctrl_status |= TIOCPKT_FLUSHWRITE;
 		wake_up_interruptible(&to->read_wait);
+		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 	}
 }
 
diff -puN drivers/char/tty_io.c~tty-bkl-pushdown drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~tty-bkl-pushdown
+++ a/drivers/char/tty_io.c
@@ -155,8 +155,7 @@ ssize_t redirected_tty_write(struct file
 static unsigned int tty_poll(struct file *, poll_table *);
 static int tty_open(struct inode *, struct file *);
 static int tty_release(struct inode *, struct file *);
-int tty_ioctl(struct inode *inode, struct file *file,
-	      unsigned int cmd, unsigned long arg);
+long tty_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 #ifdef CONFIG_COMPAT
 static long tty_compat_ioctl(struct file *file, unsigned int cmd,
 				unsigned long arg);
@@ -1166,7 +1165,7 @@ static struct tty_driver *get_tty_driver
  *	not in the foreground, send a SIGTTOU.  If the signal is blocked or
  *	ignored, go ahead and perform the operation.  (POSIX 7.2)
  *
- *	Locking: none
+ *	Locking: none - FIXME: review this
  */
 
 int tty_check_change(struct tty_struct *tty)
@@ -1208,7 +1207,7 @@ static unsigned int hung_up_tty_poll(str
 	return POLLIN | POLLOUT | POLLERR | POLLHUP | POLLRDNORM | POLLWRNORM;
 }
 
-static int hung_up_tty_ioctl(struct inode *inode, struct file *file,
+static long hung_up_tty_ioctl(struct inode *inode, struct file *file,
 			     unsigned int cmd, unsigned long arg)
 {
 	return cmd == TIOCSPGRP ? -ENOTTY : -EIO;
@@ -1225,7 +1224,7 @@ static const struct file_operations tty_
 	.read		= tty_read,
 	.write		= tty_write,
 	.poll		= tty_poll,
-	.ioctl		= tty_ioctl,
+	.unlocked_ioctl	= tty_ioctl,
 	.compat_ioctl	= tty_compat_ioctl,
 	.open		= tty_open,
 	.release	= tty_release,
@@ -1238,7 +1237,7 @@ static const struct file_operations ptmx
 	.read		= tty_read,
 	.write		= tty_write,
 	.poll		= tty_poll,
-	.ioctl		= tty_ioctl,
+	.unlocked_ioctl	= tty_ioctl,
 	.compat_ioctl	= tty_compat_ioctl,
 	.open		= ptmx_open,
 	.release	= tty_release,
@@ -1251,7 +1250,7 @@ static const struct file_operations cons
 	.read		= tty_read,
 	.write		= redirected_tty_write,
 	.poll		= tty_poll,
-	.ioctl		= tty_ioctl,
+	.unlocked_ioctl	= tty_ioctl,
 	.compat_ioctl	= tty_compat_ioctl,
 	.open		= tty_open,
 	.release	= tty_release,
@@ -1587,16 +1586,17 @@ void disassociate_ctty(int on_exit)
 	struct tty_struct *tty;
 	struct pid *tty_pgrp = NULL;
 
-	lock_kernel();
 
 	mutex_lock(&tty_mutex);
 	tty = get_current_tty();
 	if (tty) {
 		tty_pgrp = get_pid(tty->pgrp);
 		mutex_unlock(&tty_mutex);
+		lock_kernel();
 		/* XXX: here we race, there is nothing protecting tty */
 		if (on_exit && tty->driver->type != TTY_DRIVER_TYPE_PTY)
 			tty_vhangup(tty);
+		unlock_kernel();
 	} else if (on_exit) {
 		struct pid *old_pgrp;
 		spin_lock_irq(&current->sighand->siglock);
@@ -1609,7 +1609,6 @@ void disassociate_ctty(int on_exit)
 			put_pid(old_pgrp);
 		}
 		mutex_unlock(&tty_mutex);
-		unlock_kernel();
 		return;
 	}
 	if (tty_pgrp) {
@@ -1644,7 +1643,6 @@ void disassociate_ctty(int on_exit)
 	read_lock(&tasklist_lock);
 	session_clear_tty(task_session(current));
 	read_unlock(&tasklist_lock);
-	unlock_kernel();
 }
 
 /**
@@ -1654,8 +1652,10 @@ void disassociate_ctty(int on_exit)
 void no_tty(void)
 {
 	struct task_struct *tsk = current;
+	lock_kernel();
 	if (tsk->signal->leader)
 		disassociate_ctty(0);
+	unlock_kernel();
 	proc_clear_tty(tsk);
 }
 
@@ -1675,19 +1675,24 @@ void no_tty(void)
  *	but not always.
  *
  *	Locking:
- *		Broken. Relies on BKL which is unsafe here.
+ *		Uses the tty control lock internally
  */
 
 void stop_tty(struct tty_struct *tty)
 {
-	if (tty->stopped)
+	unsigned long flags;
+	spin_lock_irqsave(&tty->ctrl_lock, flags);
+	if (tty->stopped) {
+		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 		return;
+	}
 	tty->stopped = 1;
 	if (tty->link && tty->link->packet) {
 		tty->ctrl_status &= ~TIOCPKT_START;
 		tty->ctrl_status |= TIOCPKT_STOP;
 		wake_up_interruptible(&tty->link->read_wait);
 	}
+	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 	if (tty->driver->stop)
 		(tty->driver->stop)(tty);
 }
@@ -1704,19 +1709,24 @@ EXPORT_SYMBOL(stop_tty);
  *	driver start method is invoked and the line discipline woken.
  *
  *	Locking:
- *		Broken. Relies on BKL which is unsafe here.
+ *		ctrl_lock
  */
 
 void start_tty(struct tty_struct *tty)
 {
-	if (!tty->stopped || tty->flow_stopped)
+	unsigned long flags;
+	spin_lock_irqsave(&tty->ctrl_lock, flags);
+	if (!tty->stopped || tty->flow_stopped) {
+		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 		return;
+	}
 	tty->stopped = 0;
 	if (tty->link && tty->link->packet) {
 		tty->ctrl_status &= ~TIOCPKT_STOP;
 		tty->ctrl_status |= TIOCPKT_START;
 		wake_up_interruptible(&tty->link->read_wait);
 	}
+	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 	if (tty->driver->start)
 		(tty->driver->start)(tty);
 	/* If we have a running line discipline it may need kicking */
@@ -1760,13 +1770,11 @@ static ssize_t tty_read(struct file *fil
 	/* We want to wait for the line discipline to sort out in this
 	   situation */
 	ld = tty_ldisc_ref_wait(tty);
-	lock_kernel();
 	if (ld->read)
 		i = (ld->read)(tty, file, buf, count);
 	else
 		i = -EIO;
 	tty_ldisc_deref(ld);
-	unlock_kernel();
 	if (i > 0)
 		inode->i_atime = current_fs_time(inode->i_sb);
 	return i;
@@ -1854,9 +1862,7 @@ static inline ssize_t do_tty_write(
 		ret = -EFAULT;
 		if (copy_from_user(tty->write_buf, buf, size))
 			break;
-		lock_kernel();
 		ret = write(tty, file, tty->write_buf, size);
-		unlock_kernel();
 		if (ret <= 0)
 			break;
 		written += ret;
@@ -3031,10 +3037,13 @@ static int fionbio(struct file *file, in
 	if (get_user(nonblock, p))
 		return -EFAULT;
 
+	/* file->f_flags is still BKL protected in the fs layer - vomit */
+	lock_kernel();
 	if (nonblock)
 		file->f_flags |= O_NONBLOCK;
 	else
 		file->f_flags &= ~O_NONBLOCK;
+	unlock_kernel();
 	return 0;
 }
 
@@ -3123,7 +3132,7 @@ static int tiocgpgrp(struct tty_struct *
  *	Set the process group of the tty to the session passed. Only
  *	permitted where the tty session is our session.
  *
- *	Locking: None
+ *	Locking: RCU
  */
 
 static int tiocspgrp(struct tty_struct *tty, struct tty_struct *real_tty, pid_t __user *p)
@@ -3198,10 +3207,14 @@ static int tiocgsid(struct tty_struct *t
 static int tiocsetd(struct tty_struct *tty, int __user *p)
 {
 	int ldisc;
+	int ret;
 
 	if (get_user(ldisc, p))
 		return -EFAULT;
-	return tty_set_ldisc(tty, ldisc);
+
+	lock_kernel();
+	ret = tty_set_ldisc(tty, ldisc);
+	unlock_kernel();
 }
 
 /**
@@ -3219,16 +3232,21 @@ static int tiocsetd(struct tty_struct *t
 
 static int send_break(struct tty_struct *tty, unsigned int duration)
 {
+	int retval = -EINTR;
+
+	lock_kernel();
 	if (tty_write_lock(tty, 0) < 0)
-		return -EINTR;
+		goto out;
 	tty->driver->break_ctl(tty, -1);
 	if (!signal_pending(current))
 		msleep_interruptible(duration);
 	tty->driver->break_ctl(tty, 0);
 	tty_write_unlock(tty);
-	if (signal_pending(current))
-		return -EINTR;
-	return 0;
+	if (!signal_pending(current))
+		retval = 0;
+out:
+	unlock_kernel();
+	return retval;
 }
 
 /**
@@ -3248,7 +3266,9 @@ static int tty_tiocmget(struct tty_struc
 	int retval = -EINVAL;
 
 	if (tty->driver->tiocmget) {
+		lock_kernel();
 		retval = tty->driver->tiocmget(tty, file);
+		unlock_kernel();
 
 		if (retval >= 0)
 			retval = put_user(retval, p);
@@ -3298,7 +3318,9 @@ static int tty_tiocmset(struct tty_struc
 		set &= TIOCM_DTR|TIOCM_RTS|TIOCM_OUT1|TIOCM_OUT2|TIOCM_LOOP;
 		clear &= TIOCM_DTR|TIOCM_RTS|TIOCM_OUT1|TIOCM_OUT2|TIOCM_LOOP;
 
+		lock_kernel();
 		retval = tty->driver->tiocmset(tty, file, set, clear);
+		unlock_kernel();
 	}
 	return retval;
 }
@@ -3306,20 +3328,18 @@ static int tty_tiocmset(struct tty_struc
 /*
  * Split this up, as gcc can choke on it otherwise..
  */
-int tty_ioctl(struct inode *inode, struct file *file,
-	      unsigned int cmd, unsigned long arg)
+long tty_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct tty_struct *tty, *real_tty;
 	void __user *p = (void __user *)arg;
 	int retval;
 	struct tty_ldisc *ld;
+	struct inode *inode = file->f_dentry->d_inode;
 
 	tty = (struct tty_struct *)file->private_data;
 	if (tty_paranoia_check(tty, inode, "tty_ioctl"))
 		return -EINVAL;
 
-	/* CHECKME: is this safe as one end closes ? */
-
 	real_tty = tty;
 	if (tty->driver->type == TTY_DRIVER_TYPE_PTY &&
 	    tty->driver->subtype == PTY_TYPE_MASTER)
@@ -3328,13 +3348,19 @@ int tty_ioctl(struct inode *inode, struc
 	/*
 	 * Break handling by driver
 	 */
+
+	retval = -EINVAL;
+
 	if (!tty->driver->break_ctl) {
 		switch (cmd) {
 		case TIOCSBRK:
 		case TIOCCBRK:
-			if (tty->driver->ioctl)
-				return tty->driver->ioctl(tty, file, cmd, arg);
-			return -EINVAL;
+			if (tty->driver->ioctl) {
+				lock_kernel();
+				retval = tty->driver->ioctl(tty, file, cmd, arg);
+				unlock_kernel();
+			}
+			return retval;
 
 		/* These two ioctl's always return success; even if */
 		/* the driver doesn't support them. */
@@ -3342,7 +3368,9 @@ int tty_ioctl(struct inode *inode, struc
 		case TCSBRKP:
 			if (!tty->driver->ioctl)
 				return 0;
+			lock_kernel();
 			retval = tty->driver->ioctl(tty, file, cmd, arg);
+			unlock_kernel();
 			if (retval == -ENOIOCTLCMD)
 				retval = 0;
 			return retval;
@@ -3362,7 +3390,9 @@ int tty_ioctl(struct inode *inode, struc
 		if (retval)
 			return retval;
 		if (cmd != TIOCCBRK) {
+			lock_kernel();
 			tty_wait_until_sent(tty, 0);
+			unlock_kernel();
 			if (signal_pending(current))
 				return -EINTR;
 		}
@@ -3412,11 +3442,15 @@ int tty_ioctl(struct inode *inode, struc
 	 * Break handling
 	 */
 	case TIOCSBRK:	/* Turn break on, unconditionally */
+		lock_kernel();
 		tty->driver->break_ctl(tty, -1);
+		unlock_kernel();
 		return 0;
 
 	case TIOCCBRK:	/* Turn break off, unconditionally */
+		lock_kernel();
 		tty->driver->break_ctl(tty, 0);
+		unlock_kernel();
 		return 0;
 	case TCSBRK:   /* SVID version: non-zero arg --> no break */
 		/* non-zero arg means wait for all output data
@@ -3446,14 +3480,18 @@ int tty_ioctl(struct inode *inode, struc
 		break;
 	}
 	if (tty->driver->ioctl) {
+		lock_kernel();
 		retval = (tty->driver->ioctl)(tty, file, cmd, arg);
+		unlock_kernel();
 		if (retval != -ENOIOCTLCMD)
 			return retval;
 	}
 	ld = tty_ldisc_ref_wait(tty);
 	retval = -EINVAL;
 	if (ld->ioctl) {
+		lock_kernel();
 		retval = ld->ioctl(tty, file, cmd, arg);
+		unlock_kernel();
 		if (retval == -ENOIOCTLCMD)
 			retval = -EINVAL;
 	}
@@ -3731,6 +3769,7 @@ static void initialize_tty_struct(struct
 	mutex_init(&tty->atomic_read_lock);
 	mutex_init(&tty->atomic_write_lock);
 	spin_lock_init(&tty->read_lock);
+	spin_lock_init(&tty->ctrl_lock);
 	INIT_LIST_HEAD(&tty->tty_files);
 	INIT_WORK(&tty->SAK_work, do_SAK_work);
 }
diff -puN drivers/char/tty_ioctl.c~tty-bkl-pushdown drivers/char/tty_ioctl.c
--- a/drivers/char/tty_ioctl.c~tty-bkl-pushdown
+++ a/drivers/char/tty_ioctl.c
@@ -395,6 +395,7 @@ static void change_termios(struct tty_st
 	int canon_change;
 	struct ktermios old_termios = *tty->termios;
 	struct tty_ldisc *ld;
+	unsigned long flags;
 
 	/*
 	 *	Perform the actual termios internal changes under lock.
@@ -429,11 +430,13 @@ static void change_termios(struct tty_st
 				STOP_CHAR(tty) == '\023' &&
 				START_CHAR(tty) == '\021');
 		if (old_flow != new_flow) {
+			spin_lock_irqsave(&tty->ctrl_lock, flags);
 			tty->ctrl_status &= ~(TIOCPKT_DOSTOP | TIOCPKT_NOSTOP);
 			if (new_flow)
 				tty->ctrl_status |= TIOCPKT_DOSTOP;
 			else
 				tty->ctrl_status |= TIOCPKT_NOSTOP;
+			spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 			wake_up_interruptible(&tty->link->read_wait);
 		}
 	}
@@ -905,6 +908,7 @@ int n_tty_ioctl(struct tty_struct *tty, 
 		       unsigned int cmd, unsigned long arg)
 {
 	struct tty_struct *real_tty;
+	unsigned long flags;
 	int retval;
 
 	if (tty->driver->type == TTY_DRIVER_TYPE_PTY &&
@@ -963,6 +967,7 @@ int n_tty_ioctl(struct tty_struct *tty, 
 			return -ENOTTY;
 		if (get_user(pktmode, (int __user *) arg))
 			return -EFAULT;
+		spin_lock_irqsave(&tty->ctrl_lock, flags);
 		if (pktmode) {
 			if (!tty->packet) {
 				tty->packet = 1;
@@ -970,6 +975,7 @@ int n_tty_ioctl(struct tty_struct *tty, 
 			}
 		} else
 			tty->packet = 0;
+		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 		return 0;
 	}
 	default:
diff -puN drivers/char/vt.c~tty-bkl-pushdown drivers/char/vt.c
--- a/drivers/char/vt.c~tty-bkl-pushdown
+++ a/drivers/char/vt.c
@@ -2531,6 +2531,9 @@ int tioclinux(struct tty_struct *tty, un
 	if (get_user(type, p))
 		return -EFAULT;
 	ret = 0;
+
+	lock_kernel();
+
 	switch (type)
 	{
 		case TIOCL_SETSEL:
@@ -2605,6 +2608,7 @@ int tioclinux(struct tty_struct *tty, un
 			ret = -EINVAL;
 			break;
 	}
+	unlock_kernel();
 	return ret;
 }
 
diff -puN include/linux/tty.h~tty-bkl-pushdown include/linux/tty.h
--- a/include/linux/tty.h~tty-bkl-pushdown
+++ a/include/linux/tty.h
@@ -183,6 +183,7 @@ struct tty_struct {
 	int index;
 	struct tty_ldisc ldisc;
 	struct mutex termios_mutex;
+	spinlock_t ctrl_lock;
 	struct ktermios *termios, *termios_locked;
 	char name[64];
 	struct pid *pgrp;
@@ -323,8 +324,7 @@ extern void tty_ldisc_put(int);
 extern void tty_wakeup(struct tty_struct *tty);
 extern void tty_ldisc_flush(struct tty_struct *tty);
 
-extern int tty_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-		     unsigned long arg);
+extern long tty_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 extern int tty_mode_ioctl(struct tty_struct *tty, struct file *file,
 			unsigned int cmd, unsigned long arg);
 extern int tty_perform_flush(struct tty_struct *tty, unsigned long arg);
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
libata-isolate-and-rework-cable-logic.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
hci_ldisc-fix-null-pointer-deref.patch
parisc-new-termios-definitions.patch
git-sh.patch
git-watchdog.patch
tty-bkl-pushdown.patch
