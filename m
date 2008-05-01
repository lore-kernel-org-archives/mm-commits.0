From: akpm@linux-foundation.org
Subject: - char-moxa-rework-open-close.patch removed from -mm tree
Date: Thu, 01 May 2008 02:29:22 -0700
Message-ID: <200805010929.m419TMqH030673@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55078 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757486AbYEAJ32 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:29:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, Oyvind.Aabling@uni-c.dk, mm-commits@vger.kernel.org


The patch titled
     Char: moxa, rework open/close
has been removed from the -mm tree.  Its filename was
     char-moxa-rework-open-close.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: moxa, rework open/close
From: Jiri Slaby <jirislaby@gmail.com>

- add locking to open/close/hangup and ioctl (tiocm)
- add pci hot-un-plug support (hangup on board remove, wait for openers)
- cleanup block_till_ready
- move close code common to close/hangup into separate function to be
  able to call it from open when hangup occurs while block_till_ready
- let ldisc flush on tty layer, it will do it after we return

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Tested-by: Oyvind Aabling <Oyvind.Aabling@uni-c.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |  320 ++++++++++++++++++++----------------------
 1 file changed, 158 insertions(+), 162 deletions(-)

diff -puN drivers/char/moxa.c~char-moxa-rework-open-close drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-rework-open-close
+++ a/drivers/char/moxa.c
@@ -42,7 +42,6 @@
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/bitops.h>
-#include <linux/completion.h>
 
 #include <asm/system.h>
 #include <asm/io.h>
@@ -134,13 +133,11 @@ struct moxa_port {
 
 	int type;
 	int close_delay;
-	int count;
-	int blocked_open;
+	unsigned int count;
 	int asyncflags;
 	int cflag;
 	unsigned long statusflags;
 	wait_queue_head_t open_wait;
-	struct completion close_wait;
 
 	u8 DCDState;
 	u8 lineCtrl;
@@ -167,6 +164,7 @@ static int ttymajor = MOXAMAJOR;
 static struct mon_str moxaLog;
 static unsigned int moxaFuncTout = HZ / 2;
 static unsigned int moxaLowWaterChk;
+static DEFINE_MUTEX(moxa_openlock);
 /* Variables for insmod */
 #ifdef MODULE
 static unsigned long baseaddr[MAX_BOARDS];
@@ -209,8 +207,6 @@ static int moxa_tiocmset(struct tty_stru
 			 unsigned int set, unsigned int clear);
 static void moxa_poll(unsigned long);
 static void moxa_set_tty_param(struct tty_struct *, struct ktermios *);
-static int moxa_block_till_ready(struct tty_struct *, struct file *,
-			    struct moxa_port *);
 static void moxa_setup_empty_event(struct tty_struct *);
 static void moxa_shut_down(struct moxa_port *);
 /*
@@ -280,7 +276,7 @@ static int moxa_ioctl(struct tty_struct 
 {
 	struct moxa_port *ch = tty->driver_data;
 	void __user *argp = (void __user *)arg;
-	int status;
+	int status, ret = 0;
 
 	if (tty->index == MAX_PORTS) {
 		if (cmd != MOXA_GETDATACOUNT && cmd != MOXA_GET_IOQUEUE &&
@@ -292,17 +288,19 @@ static int moxa_ioctl(struct tty_struct 
 	switch (cmd) {
 	case MOXA_GETDATACOUNT:
 		moxaLog.tick = jiffies;
-		return copy_to_user(argp, &moxaLog, sizeof(moxaLog)) ?
-			-EFAULT : 0;
+		if (copy_to_user(argp, &moxaLog, sizeof(moxaLog)))
+			ret = -EFAULT;
+		break;
 	case MOXA_FLUSH_QUEUE:
 		MoxaPortFlushData(ch, arg);
-		return 0;
+		break;
 	case MOXA_GET_IOQUEUE: {
 		struct moxaq_str __user *argm = argp;
 		struct moxaq_str tmp;
 		struct moxa_port *p;
 		unsigned int i, j;
 
+		mutex_lock(&moxa_openlock);
 		for (i = 0; i < MAX_BOARDS; i++) {
 			p = moxa_boards[i].ports;
 			for (j = 0; j < MAX_PORTS_PER_BOARD; j++, p++, argm++) {
@@ -311,23 +309,29 @@ static int moxa_ioctl(struct tty_struct 
 					tmp.inq = MoxaPortRxQueue(p);
 					tmp.outq = MoxaPortTxQueue(p);
 				}
-				if (copy_to_user(argm, &tmp, sizeof(tmp)))
+				if (copy_to_user(argm, &tmp, sizeof(tmp))) {
+					mutex_unlock(&moxa_openlock);
 					return -EFAULT;
+				}
 			}
 		}
-		return 0;
+		mutex_unlock(&moxa_openlock);
+		break;
 	} case MOXA_GET_OQUEUE:
 		status = MoxaPortTxQueue(ch);
-		return put_user(status, (unsigned long __user *)argp);
+		ret = put_user(status, (unsigned long __user *)argp);
+		break;
 	case MOXA_GET_IQUEUE:
 		status = MoxaPortRxQueue(ch);
-		return put_user(status, (unsigned long __user *)argp);
+		ret = put_user(status, (unsigned long __user *)argp);
+		break;
 	case MOXA_GETMSTATUS: {
 		struct mxser_mstatus __user *argm = argp;
 		struct mxser_mstatus tmp;
 		struct moxa_port *p;
 		unsigned int i, j;
 
+		mutex_lock(&moxa_openlock);
 		for (i = 0; i < MAX_BOARDS; i++) {
 			p = moxa_boards[i].ports;
 			for (j = 0; j < MAX_PORTS_PER_BOARD; j++, p++, argm++) {
@@ -348,18 +352,29 @@ static int moxa_ioctl(struct tty_struct 
 				else
 					tmp.cflag = p->tty->termios->c_cflag;
 copy:
-				if (copy_to_user(argm, &tmp, sizeof(tmp)))
+				if (copy_to_user(argm, &tmp, sizeof(tmp))) {
+					mutex_unlock(&moxa_openlock);
 					return -EFAULT;
+				}
 			}
 		}
-		return 0;
+		mutex_unlock(&moxa_openlock);
+		break;
 	}
 	case TIOCGSERIAL:
-		return moxa_get_serial_info(ch, argp);
+		mutex_lock(&moxa_openlock);
+		ret = moxa_get_serial_info(ch, argp);
+		mutex_unlock(&moxa_openlock);
+		break;
 	case TIOCSSERIAL:
-		return moxa_set_serial_info(ch, argp);
+		mutex_lock(&moxa_openlock);
+		ret = moxa_set_serial_info(ch, argp);
+		mutex_unlock(&moxa_openlock);
+		break;
+	default:
+		ret = -ENOIOCTLCMD;
 	}
-	return -ENOIOCTLCMD;
+	return ret;
 }
 
 static void moxa_break_ctl(struct tty_struct *tty, int state)
@@ -817,7 +832,6 @@ static int moxa_init_board(struct moxa_b
 		p->close_delay = 5 * HZ / 10;
 		p->cflag = B9600 | CS8 | CREAD | CLOCAL | HUPCL;
 		init_waitqueue_head(&p->open_wait);
-		init_completion(&p->close_wait);
 	}
 
 	switch (brd->boardType) {
@@ -861,9 +875,29 @@ err:
 
 static void moxa_board_deinit(struct moxa_board_conf *brd)
 {
+	unsigned int a, opened;
+
+	mutex_lock(&moxa_openlock);
 	spin_lock_bh(&moxa_lock);
 	brd->ready = 0;
 	spin_unlock_bh(&moxa_lock);
+
+	/* pci hot-un-plug support */
+	for (a = 0; a < brd->numPorts; a++)
+		if (brd->ports[a].asyncflags & ASYNC_INITIALIZED)
+			tty_hangup(brd->ports[a].tty);
+	while (1) {
+		opened = 0;
+		for (a = 0; a < brd->numPorts; a++)
+			if (brd->ports[a].asyncflags & ASYNC_INITIALIZED)
+				opened++;
+		mutex_unlock(&moxa_openlock);
+		if (!opened)
+			break;
+		msleep(50);
+		mutex_lock(&moxa_openlock);
+	}
+
 	iounmap(brd->basemem);
 	brd->basemem = NULL;
 	kfree(brd->ports);
@@ -1061,6 +1095,49 @@ static void __exit moxa_exit(void)
 module_init(moxa_init);
 module_exit(moxa_exit);
 
+static void moxa_close_port(struct moxa_port *ch)
+{
+	moxa_shut_down(ch);
+	MoxaPortFlushData(ch, 2);
+	ch->asyncflags &= ~ASYNC_NORMAL_ACTIVE;
+	ch->tty->driver_data = NULL;
+	ch->tty = NULL;
+}
+
+static int moxa_block_till_ready(struct tty_struct *tty, struct file *filp,
+			    struct moxa_port *ch)
+{
+	DEFINE_WAIT(wait);
+	int retval = 0;
+	u8 dcd;
+
+	while (1) {
+		prepare_to_wait(&ch->open_wait, &wait, TASK_INTERRUPTIBLE);
+		if (tty_hung_up_p(filp)) {
+#ifdef SERIAL_DO_RESTART
+			retval = -ERESTARTSYS;
+#else
+			retval = -EAGAIN;
+#endif
+			break;
+		}
+		spin_lock_bh(&moxa_lock);
+		dcd = ch->DCDState;
+		spin_unlock_bh(&moxa_lock);
+		if (dcd)
+			break;
+
+		if (signal_pending(current)) {
+			retval = -ERESTARTSYS;
+			break;
+		}
+		schedule();
+	}
+	finish_wait(&ch->open_wait, &wait);
+
+	return retval;
+}
+
 static int moxa_open(struct tty_struct *tty, struct file *filp)
 {
 	struct moxa_board_conf *brd;
@@ -1072,9 +1149,13 @@ static int moxa_open(struct tty_struct *
 	if (port == MAX_PORTS) {
 		return capable(CAP_SYS_ADMIN) ? 0 : -EPERM;
 	}
+	if (mutex_lock_interruptible(&moxa_openlock))
+		return -ERESTARTSYS;
 	brd = &moxa_boards[port / MAX_PORTS_PER_BOARD];
-	if (!brd->ready)
+	if (!brd->ready) {
+		mutex_unlock(&moxa_openlock);
 		return -ENODEV;
+	}
 
 	ch = &brd->ports[port % MAX_PORTS_PER_BOARD];
 	ch->count++;
@@ -1085,19 +1166,24 @@ static int moxa_open(struct tty_struct *
 		moxa_set_tty_param(tty, tty->termios);
 		MoxaPortLineCtrl(ch, 1, 1);
 		MoxaPortEnable(ch);
+		MoxaSetFifo(ch, ch->type == PORT_16550A);
 		ch->asyncflags |= ASYNC_INITIALIZED;
 	}
-	retval = moxa_block_till_ready(tty, filp, ch);
+	mutex_unlock(&moxa_openlock);
 
-	moxa_unthrottle(tty);
-
-	if (ch->type == PORT_16550A) {
-		MoxaSetFifo(ch, 1);
-	} else {
-		MoxaSetFifo(ch, 0);
-	}
+	retval = 0;
+	if (!(filp->f_flags & O_NONBLOCK) && !C_CLOCAL(tty))
+		retval = moxa_block_till_ready(tty, filp, ch);
+	mutex_lock(&moxa_openlock);
+	if (retval) {
+		if (ch->count) /* 0 means already hung up... */
+			if (--ch->count == 0)
+				moxa_close_port(ch);
+	} else
+		ch->asyncflags |= ASYNC_NORMAL_ACTIVE;
+	mutex_unlock(&moxa_openlock);
 
-	return (retval);
+	return retval;
 }
 
 static void moxa_close(struct tty_struct *tty, struct file *filp)
@@ -1106,18 +1192,14 @@ static void moxa_close(struct tty_struct
 	int port;
 
 	port = tty->index;
-	if (port == MAX_PORTS) {
-		return;
-	}
-	if (tty->driver_data == NULL) {
+	if (port == MAX_PORTS || tty_hung_up_p(filp))
 		return;
-	}
-	if (tty_hung_up_p(filp)) {
-		return;
-	}
-	ch = (struct moxa_port *) tty->driver_data;
 
-	if ((tty->count == 1) && (ch->count != 1)) {
+	mutex_lock(&moxa_openlock);
+	ch = tty->driver_data;
+	if (ch == NULL)
+		goto unlock;
+	if (tty->count == 1 && ch->count != 1) {
 		printk(KERN_WARNING "moxa_close: bad serial port count; "
 			"tty->count is 1, ch->count is %d\n", ch->count);
 		ch->count = 1;
@@ -1127,33 +1209,18 @@ static void moxa_close(struct tty_struct
 			"device=%s\n", tty->name);
 		ch->count = 0;
 	}
-	if (ch->count) {
-		return;
-	}
-	ch->asyncflags |= ASYNC_CLOSING;
+	if (ch->count)
+		goto unlock;
 
 	ch->cflag = tty->termios->c_cflag;
 	if (ch->asyncflags & ASYNC_INITIALIZED) {
 		moxa_setup_empty_event(tty);
 		tty_wait_until_sent(tty, 30 * HZ);	/* 30 seconds timeout */
 	}
-	moxa_shut_down(ch);
-	MoxaPortFlushData(ch, 2);
 
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
-	tty_ldisc_flush(tty);
-			
-	tty->closing = 0;
-	ch->tty = NULL;
-	if (ch->blocked_open) {
-		if (ch->close_delay) {
-			msleep_interruptible(jiffies_to_msecs(ch->close_delay));
-		}
-		wake_up_interruptible(&ch->open_wait);
-	}
-	ch->asyncflags &= ~(ASYNC_NORMAL_ACTIVE | ASYNC_CLOSING);
-	complete_all(&ch->close_wait);
+	moxa_close_port(ch);
+unlock:
+	mutex_unlock(&moxa_openlock);
 }
 
 static int moxa_write(struct tty_struct *tty,
@@ -1249,11 +1316,15 @@ static void moxa_put_char(struct tty_str
 
 static int moxa_tiocmget(struct tty_struct *tty, struct file *file)
 {
-	struct moxa_port *ch = tty->driver_data;
+	struct moxa_port *ch;
 	int flag = 0, dtr, rts;
 
-	if (!ch)
+	mutex_lock(&moxa_openlock);
+	ch = tty->driver_data;
+	if (!ch) {
+		mutex_unlock(&moxa_openlock);
 		return -EINVAL;
+	}
 
 	MoxaPortGetLineOut(ch, &dtr, &rts);
 	if (dtr)
@@ -1267,19 +1338,24 @@ static int moxa_tiocmget(struct tty_stru
 		flag |= TIOCM_DSR;
 	if (dtr & 4)
 		flag |= TIOCM_CD;
+	mutex_unlock(&moxa_openlock);
 	return flag;
 }
 
 static int moxa_tiocmset(struct tty_struct *tty, struct file *file,
 			 unsigned int set, unsigned int clear)
 {
-	struct moxa_port *ch = tty->driver_data;
+	struct moxa_port *ch;
 	int port;
 	int dtr, rts;
 
 	port = tty->index;
-	if (!ch)
+	mutex_lock(&moxa_openlock);
+	ch = tty->driver_data;
+	if (!ch) {
+		mutex_unlock(&moxa_openlock);
 		return -EINVAL;
+	}
 
 	MoxaPortGetLineOut(ch, &dtr, &rts);
 	if (set & TIOCM_RTS)
@@ -1291,6 +1367,7 @@ static int moxa_tiocmset(struct tty_stru
 	if (clear & TIOCM_DTR)
 		dtr = 0;
 	MoxaPortLineCtrl(ch, dtr, rts);
+	mutex_unlock(&moxa_openlock);
 	return 0;
 }
 
@@ -1348,13 +1425,18 @@ static void moxa_start(struct tty_struct
 
 static void moxa_hangup(struct tty_struct *tty)
 {
-	struct moxa_port *ch = (struct moxa_port *) tty->driver_data;
+	struct moxa_port *ch;
 
-	moxa_flush_buffer(tty);
-	moxa_shut_down(ch);
+	mutex_lock(&moxa_openlock);
+	ch = tty->driver_data;
+	if (ch == NULL) {
+		mutex_unlock(&moxa_openlock);
+		return;
+	}
 	ch->count = 0;
-	ch->asyncflags &= ~ASYNC_NORMAL_ACTIVE;
-	ch->tty = NULL;
+	moxa_close_port(ch);
+	mutex_unlock(&moxa_openlock);
+
 	wake_up_interruptible(&ch->open_wait);
 }
 
@@ -1363,11 +1445,8 @@ static void moxa_new_dcdstate(struct mox
 	dcd = !!dcd;
 
 	if ((dcd != p->DCDState) && p->tty && C_CLOCAL(p->tty)) {
-		if (!dcd) {
+		if (!dcd)
 			tty_hangup(p->tty);
-			p->asyncflags &= ~ASYNC_NORMAL_ACTIVE;
-		}
-		wake_up_interruptible(&p->open_wait);
 	}
 	p->DCDState = dcd;
 }
@@ -1499,91 +1578,6 @@ static void moxa_set_tty_param(struct tt
 	tty_encode_baud_rate(tty, baud, baud);
 }
 
-static int moxa_block_till_ready(struct tty_struct *tty, struct file *filp,
-			    struct moxa_port *ch)
-{
-	DECLARE_WAITQUEUE(wait,current);
-	int retval;
-	int do_clocal = C_CLOCAL(tty);
-
-	/*
-	 * If the device is in the middle of being closed, then block
-	 * until it's done, and then try again.
-	 */
-	if (tty_hung_up_p(filp) || (ch->asyncflags & ASYNC_CLOSING)) {
-		if (ch->asyncflags & ASYNC_CLOSING)
-			wait_for_completion_interruptible(&ch->close_wait);
-#ifdef SERIAL_DO_RESTART
-		if (ch->asyncflags & ASYNC_HUP_NOTIFY)
-			return (-EAGAIN);
-		else
-			return (-ERESTARTSYS);
-#else
-		return (-EAGAIN);
-#endif
-	}
-	/*
-	 * If non-blocking mode is set, then make the check up front
-	 * and then exit.
-	 */
-	if (filp->f_flags & O_NONBLOCK) {
-		ch->asyncflags |= ASYNC_NORMAL_ACTIVE;
-		return (0);
-	}
-	/*
-	 * Block waiting for the carrier detect and the line to become free
-	 */
-	retval = 0;
-	add_wait_queue(&ch->open_wait, &wait);
-	pr_debug("block_til_ready before block: ttys%d, count = %d\n",
-		tty->index, ch->count);
-	spin_lock_bh(&moxa_lock);
-	if (!tty_hung_up_p(filp))
-		ch->count--;
-	ch->blocked_open++;
-	spin_unlock_bh(&moxa_lock);
-
-	while (1) {
-		set_current_state(TASK_INTERRUPTIBLE);
-		if (tty_hung_up_p(filp) ||
-		    !(ch->asyncflags & ASYNC_INITIALIZED)) {
-#ifdef SERIAL_DO_RESTART
-			if (ch->asyncflags & ASYNC_HUP_NOTIFY)
-				retval = -EAGAIN;
-			else
-				retval = -ERESTARTSYS;
-#else
-			retval = -EAGAIN;
-#endif
-			break;
-		}
-		if (!(ch->asyncflags & ASYNC_CLOSING) && (do_clocal ||
-				ch->DCDState))
-			break;
-
-		if (signal_pending(current)) {
-			retval = -ERESTARTSYS;
-			break;
-		}
-		schedule();
-	}
-	set_current_state(TASK_RUNNING);
-	remove_wait_queue(&ch->open_wait, &wait);
-
-	spin_lock_bh(&moxa_lock);
-	if (!tty_hung_up_p(filp))
-		ch->count++;
-	ch->blocked_open--;
-	spin_unlock_bh(&moxa_lock);
-	pr_debug("block_til_ready after blocking: ttys%d, count = %d\n",
-		tty->index, ch->count);
-	if (retval)
-		return (retval);
-	/* FIXME: review to see if we need to use set_bit on these */
-	ch->asyncflags |= ASYNC_NORMAL_ACTIVE;
-	return 0;
-}
-
 static void moxa_setup_empty_event(struct tty_struct *tty)
 {
 	struct moxa_port *ch = tty->driver_data;
@@ -1595,22 +1589,22 @@ static void moxa_setup_empty_event(struc
 
 static void moxa_shut_down(struct moxa_port *ch)
 {
-	struct tty_struct *tp;
+	struct tty_struct *tp = ch->tty;
 
 	if (!(ch->asyncflags & ASYNC_INITIALIZED))
 		return;
 
-	tp = ch->tty;
-
 	MoxaPortDisable(ch);
 
 	/*
 	 * If we're a modem control device and HUPCL is on, drop RTS & DTR.
 	 */
-	if (tp->termios->c_cflag & HUPCL)
+	if (C_HUPCL(tp))
 		MoxaPortLineCtrl(ch, 0, 0);
 
+	spin_lock_bh(&moxa_lock);
 	ch->asyncflags &= ~ASYNC_INITIALIZED;
+	spin_unlock_bh(&moxa_lock);
 }
 
 /*****************************************************************************
@@ -2029,7 +2023,9 @@ static int MoxaPortLineStatus(struct mox
 	val &= 0x0B;
 	if (val & 8)
 		val |= 4;
+	spin_lock_bh(&moxa_lock);
 	moxa_new_dcdstate(port, val & 8);
+	spin_unlock_bh(&moxa_lock);
 	val &= 7;
 	return val;
 }
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

