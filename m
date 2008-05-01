From: akpm@linux-foundation.org
Subject: - char-moxa-remove-port-port.patch removed from -mm tree
Date: Thu, 01 May 2008 02:29:06 -0700
Message-ID: <200805010929.m419T6HC030644@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52585 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757136AbYEAJ3M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:29:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, Oyvind.Aabling@uni-c.dk, mm-commits@vger.kernel.org


The patch titled
     Char: moxa, remove port->port
has been removed from the -mm tree.  Its filename was
     char-moxa-remove-port-port.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: moxa, remove port->port
From: Jiri Slaby <jirislaby@gmail.com>

We don't need to hold a reference to port index.  In most cases we need port
structure anyway and index is available in port->tty->index.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Tested-by: Oyvind Aabling <Oyvind.Aabling@uni-c.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |  354 +++++++++++++++++++-----------------------
 1 file changed, 163 insertions(+), 191 deletions(-)

diff -puN drivers/char/moxa.c~char-moxa-remove-port-port drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-remove-port-port
+++ a/drivers/char/moxa.c
@@ -128,8 +128,8 @@ struct moxaq_str {
 };
 
 struct moxa_port {
+	struct moxa_board_conf *board;
 	int type;
-	int port;
 	int close_delay;
 	unsigned short closing_wait;
 	int count;
@@ -218,34 +218,32 @@ static void moxa_receive_data(struct mox
 /*
  * moxa board interface functions:
  */
-static int MoxaDriverIoctl(unsigned int, unsigned long, int);
+static int MoxaDriverIoctl(struct tty_struct *, unsigned int, unsigned long);
 static int MoxaDriverPoll(void);
 static int MoxaPortsOfCard(int);
 static int MoxaPortIsValid(int);
-static void MoxaPortEnable(int);
-static void MoxaPortDisable(int);
-static long MoxaPortGetMaxBaud(int);
-static long MoxaPortSetBaud(int, long);
-static int MoxaPortSetTermio(int, struct ktermios *, speed_t);
-static int MoxaPortGetLineOut(int, int *, int *);
-static void MoxaPortLineCtrl(int, int, int);
-static void MoxaPortFlowCtrl(int, int, int, int, int, int);
-static int MoxaPortLineStatus(int);
-static int MoxaPortDCDChange(int);
-static int MoxaPortDCDON(int);
-static void MoxaPortFlushData(int, int);
-static int MoxaPortWriteData(int, unsigned char *, int);
-static int MoxaPortReadData(int, struct tty_struct *tty);
-static int MoxaPortTxQueue(int);
-static int MoxaPortRxQueue(int);
-static int MoxaPortTxFree(int);
-static void MoxaPortTxDisable(int);
-static void MoxaPortTxEnable(int);
-static int MoxaPortResetBrkCnt(int);
-static void MoxaPortSendBreak(int, int);
+static void MoxaPortEnable(struct moxa_port *);
+static void MoxaPortDisable(struct moxa_port *);
+static int MoxaPortSetTermio(struct moxa_port *, struct ktermios *, speed_t);
+static int MoxaPortGetLineOut(struct moxa_port *, int *, int *);
+static void MoxaPortLineCtrl(struct moxa_port *, int, int);
+static void MoxaPortFlowCtrl(struct moxa_port *, int, int, int, int, int);
+static int MoxaPortLineStatus(struct moxa_port *);
+static int MoxaPortDCDChange(struct moxa_port *);
+static int MoxaPortDCDON(struct moxa_port *);
+static void MoxaPortFlushData(struct moxa_port *, int);
+static int MoxaPortWriteData(struct moxa_port *, unsigned char *, int);
+static int MoxaPortReadData(struct moxa_port *, struct tty_struct *tty);
+static int MoxaPortTxQueue(struct moxa_port *);
+static int MoxaPortRxQueue(struct moxa_port *);
+static int MoxaPortTxFree(struct moxa_port *);
+static void MoxaPortTxDisable(struct moxa_port *);
+static void MoxaPortTxEnable(struct moxa_port *);
+static int MoxaPortResetBrkCnt(struct moxa_port *);
+static void MoxaPortSendBreak(struct moxa_port *, int);
 static int moxa_get_serial_info(struct moxa_port *, struct serial_struct __user *);
 static int moxa_set_serial_info(struct moxa_port *, struct serial_struct __user *);
-static void MoxaSetFifo(int port, int enable);
+static void MoxaSetFifo(struct moxa_port *port, int enable);
 
 static const struct tty_operations moxa_ops = {
 	.open = moxa_open,
@@ -515,6 +513,7 @@ static int moxa_load_code(struct moxa_bo
 	case MOXA_BOARD_CP204J:
 		port = brd->ports;
 		for (i = 0; i < brd->numPorts; i++, port++) {
+			port->board = brd;
 			port->chkPort = 1;
 			port->curBaud = 9600L;
 			port->DCDState = 0;
@@ -534,6 +533,7 @@ static int moxa_load_code(struct moxa_bo
 	default:
 		port = brd->ports;
 		for (i = 0; i < brd->numPorts; i++, port++) {
+			port->board = brd;
 			port->chkPort = 1;
 			port->curBaud = 9600L;
 			port->DCDState = 0;
@@ -822,7 +822,6 @@ static int __init moxa_init(void)
 
 	for (i = 0, ch = moxa_ports; i < MAX_PORTS; i++, ch++) {
 		ch->type = PORT_16550A;
-		ch->port = i;
 		ch->close_delay = 5 * HZ / 10;
 		ch->closing_wait = 30 * HZ;
 		ch->cflag = B9600 | CS8 | CREAD | CLOCAL | HUPCL;
@@ -939,8 +938,8 @@ static int moxa_open(struct tty_struct *
 	if (!(ch->asyncflags & ASYNC_INITIALIZED)) {
 		ch->statusflags = 0;
 		moxa_set_tty_param(tty, tty->termios);
-		MoxaPortLineCtrl(ch->port, 1, 1);
-		MoxaPortEnable(ch->port);
+		MoxaPortLineCtrl(ch, 1, 1);
+		MoxaPortEnable(ch);
 		ch->asyncflags |= ASYNC_INITIALIZED;
 	}
 	retval = moxa_block_till_ready(tty, filp, ch);
@@ -948,9 +947,9 @@ static int moxa_open(struct tty_struct *
 	moxa_unthrottle(tty);
 
 	if (ch->type == PORT_16550A) {
-		MoxaSetFifo(ch->port, 1);
+		MoxaSetFifo(ch, 1);
 	} else {
-		MoxaSetFifo(ch->port, 0);
+		MoxaSetFifo(ch, 0);
 	}
 
 	return (retval);
@@ -997,10 +996,10 @@ static void moxa_close(struct tty_struct
 	if (ch->asyncflags & ASYNC_INITIALIZED) {
 		moxa_setup_empty_event(tty);
 		tty_wait_until_sent(tty, 30 * HZ);	/* 30 seconds timeout */
-		del_timer_sync(&moxa_ports[ch->port].emptyTimer);
+		del_timer_sync(&ch->emptyTimer);
 	}
 	moxa_shut_down(ch);
-	MoxaPortFlushData(port, 2);
+	MoxaPortFlushData(ch, 2);
 
 	if (tty->driver->flush_buffer)
 		tty->driver->flush_buffer(tty);
@@ -1022,17 +1021,15 @@ static void moxa_close(struct tty_struct
 static int moxa_write(struct tty_struct *tty,
 		      const unsigned char *buf, int count)
 {
-	struct moxa_port *ch;
-	int len, port;
+	struct moxa_port *ch = tty->driver_data;
 	unsigned long flags;
+	int len;
 
-	ch = (struct moxa_port *) tty->driver_data;
 	if (ch == NULL)
-		return (0);
-	port = ch->port;
+		return 0;
 
 	spin_lock_irqsave(&moxa_lock, flags);
-	len = MoxaPortWriteData(port, (unsigned char *) buf, count);
+	len = MoxaPortWriteData(ch, (unsigned char *) buf, count);
 	spin_unlock_irqrestore(&moxa_lock, flags);
 
 	/*********************************************
@@ -1049,26 +1046,26 @@ static int moxa_write_room(struct tty_st
 
 	if (tty->stopped)
 		return (0);
-	ch = (struct moxa_port *) tty->driver_data;
+	ch = tty->driver_data;
 	if (ch == NULL)
 		return (0);
-	return (MoxaPortTxFree(ch->port));
+	return MoxaPortTxFree(ch);
 }
 
 static void moxa_flush_buffer(struct tty_struct *tty)
 {
-	struct moxa_port *ch = (struct moxa_port *) tty->driver_data;
+	struct moxa_port *ch = tty->driver_data;
 
 	if (ch == NULL)
 		return;
-	MoxaPortFlushData(ch->port, 1);
+	MoxaPortFlushData(ch, 1);
 	tty_wakeup(tty);
 }
 
 static int moxa_chars_in_buffer(struct tty_struct *tty)
 {
+	struct moxa_port *ch = tty->driver_data;
 	int chars;
-	struct moxa_port *ch = (struct moxa_port *) tty->driver_data;
 
 	/*
 	 * Sigh...I have to check if driver_data is NULL here, because
@@ -1078,7 +1075,7 @@ static int moxa_chars_in_buffer(struct t
 	 */
 	if (ch == NULL)
 		return (0);
-	chars = MoxaPortTxQueue(ch->port);
+	chars = MoxaPortTxQueue(ch);
 	if (chars) {
 		/*
 		 * Make it possible to wakeup anything waiting for output
@@ -1100,16 +1097,13 @@ static void moxa_flush_chars(struct tty_
 
 static void moxa_put_char(struct tty_struct *tty, unsigned char c)
 {
-	struct moxa_port *ch;
-	int port;
+	struct moxa_port *ch = tty->driver_data;
 	unsigned long flags;
 
-	ch = (struct moxa_port *) tty->driver_data;
 	if (ch == NULL)
 		return;
-	port = ch->port;
 	spin_lock_irqsave(&moxa_lock, flags);
-	MoxaPortWriteData(port, &c, 1);
+	MoxaPortWriteData(ch, &c, 1);
 	spin_unlock_irqrestore(&moxa_lock, flags);
 	/************************************************
 	if ( !(ch->statusflags & LOWWAIT) && (MoxaPortTxFree(port) <= 100) )
@@ -1119,20 +1113,18 @@ static void moxa_put_char(struct tty_str
 
 static int moxa_tiocmget(struct tty_struct *tty, struct file *file)
 {
-	struct moxa_port *ch = (struct moxa_port *) tty->driver_data;
-	int port;
+	struct moxa_port *ch = tty->driver_data;
 	int flag = 0, dtr, rts;
 
-	port = tty->index;
-	if ((port != MAX_PORTS) && (!ch))
+	if ((tty->index != MAX_PORTS) && (!ch))
 		return (-EINVAL);
 
-	MoxaPortGetLineOut(ch->port, &dtr, &rts);
+	MoxaPortGetLineOut(ch, &dtr, &rts);
 	if (dtr)
 		flag |= TIOCM_DTR;
 	if (rts)
 		flag |= TIOCM_RTS;
-	dtr = MoxaPortLineStatus(ch->port);
+	dtr = MoxaPortLineStatus(ch);
 	if (dtr & 1)
 		flag |= TIOCM_CTS;
 	if (dtr & 2)
@@ -1145,7 +1137,7 @@ static int moxa_tiocmget(struct tty_stru
 static int moxa_tiocmset(struct tty_struct *tty, struct file *file,
 			 unsigned int set, unsigned int clear)
 {
-	struct moxa_port *ch = (struct moxa_port *) tty->driver_data;
+	struct moxa_port *ch = tty->driver_data;
 	int port;
 	int dtr, rts;
 
@@ -1153,7 +1145,7 @@ static int moxa_tiocmset(struct tty_stru
 	if ((port != MAX_PORTS) && (!ch))
 		return (-EINVAL);
 
-	MoxaPortGetLineOut(ch->port, &dtr, &rts);
+	MoxaPortGetLineOut(ch, &dtr, &rts);
 	if (set & TIOCM_RTS)
 		rts = 1;
 	if (set & TIOCM_DTR)
@@ -1162,14 +1154,14 @@ static int moxa_tiocmset(struct tty_stru
 		rts = 0;
 	if (clear & TIOCM_DTR)
 		dtr = 0;
-	MoxaPortLineCtrl(ch->port, dtr, rts);
+	MoxaPortLineCtrl(ch, dtr, rts);
 	return 0;
 }
 
 static int moxa_ioctl(struct tty_struct *tty, struct file *file,
 		      unsigned int cmd, unsigned long arg)
 {
-	struct moxa_port *ch = (struct moxa_port *) tty->driver_data;
+	struct moxa_port *ch = tty->driver_data;
 	register int port;
 	void __user *argp = (void __user *)arg;
 	int retval;
@@ -1186,7 +1178,7 @@ static int moxa_ioctl(struct tty_struct 
 		moxa_setup_empty_event(tty);
 		tty_wait_until_sent(tty, 0);
 		if (!arg)
-			MoxaPortSendBreak(ch->port, 0);
+			MoxaPortSendBreak(ch, 0);
 		return (0);
 	case TCSBRKP:		/* support for POSIX tcsendbreak() */
 		retval = tty_check_change(tty);
@@ -1194,7 +1186,7 @@ static int moxa_ioctl(struct tty_struct 
 			return (retval);
 		moxa_setup_empty_event(tty);
 		tty_wait_until_sent(tty, 0);
-		MoxaPortSendBreak(ch->port, arg);
+		MoxaPortSendBreak(ch, arg);
 		return (0);
 	case TIOCGSOFTCAR:
 		return put_user(C_CLOCAL(tty) ? 1 : 0, (int __user *)argp);
@@ -1215,7 +1207,7 @@ static int moxa_ioctl(struct tty_struct 
 	case TIOCSSERIAL:
 		return moxa_set_serial_info(ch, argp);
 	default:
-		retval = MoxaDriverIoctl(cmd, arg, port);
+		retval = MoxaDriverIoctl(tty, cmd, arg);
 	}
 	return (retval);
 }
@@ -1253,7 +1245,7 @@ static void moxa_stop(struct tty_struct 
 
 	if (ch == NULL)
 		return;
-	MoxaPortTxDisable(ch->port);
+	MoxaPortTxDisable(ch);
 	ch->statusflags |= TXSTOPPED;
 }
 
@@ -1268,7 +1260,7 @@ static void moxa_start(struct tty_struct
 	if (!(ch->statusflags & TXSTOPPED))
 		return;
 
-	MoxaPortTxEnable(ch->port);
+	MoxaPortTxEnable(ch);
 	ch->statusflags &= ~TXSTOPPED;
 }
 
@@ -1306,25 +1298,25 @@ static void moxa_poll(unsigned long igno
 			if ((ch->asyncflags & ASYNC_INITIALIZED) == 0)
 				continue;
 			if (!(ch->statusflags & THROTTLE) &&
-			    (MoxaPortRxQueue(ch->port) > 0))
+			    (MoxaPortRxQueue(ch) > 0))
 				moxa_receive_data(ch);
 			if ((tp = ch->tty) == 0)
 				continue;
 			if (ch->statusflags & LOWWAIT) {
-				if (MoxaPortTxQueue(ch->port) <= WAKEUP_CHARS) {
+				if (MoxaPortTxQueue(ch) <= WAKEUP_CHARS) {
 					if (!tp->stopped) {
 						ch->statusflags &= ~LOWWAIT;
 						tty_wakeup(tp);
 					}
 				}
 			}
-			if (!I_IGNBRK(tp) && (MoxaPortResetBrkCnt(ch->port) > 0)) {
+			if (!I_IGNBRK(tp) && (MoxaPortResetBrkCnt(ch) > 0)) {
 				tty_insert_flip_char(tp, 0, TTY_BREAK);
 				tty_schedule_flip(tp);
 			}
-			if (MoxaPortDCDChange(ch->port)) {
+			if (MoxaPortDCDChange(ch)) {
 				if (ch->asyncflags & ASYNC_CHECK_CD) {
-					if (MoxaPortDCDON(ch->port))
+					if (MoxaPortDCDON(ch))
 						wake_up_interruptible(&ch->open_wait);
 					else {
 						tty_hangup(tp);
@@ -1365,8 +1357,8 @@ static void moxa_set_tty_param(struct tt
 
 	/* Clear the features we don't support */
 	ts->c_cflag &= ~CMSPAR;
-	MoxaPortFlowCtrl(ch->port, rts, cts, txflow, rxflow, xany);
-	baud = MoxaPortSetTermio(ch->port, ts, tty_get_baud_rate(tty));
+	MoxaPortFlowCtrl(ch, rts, cts, txflow, rxflow, xany);
+	baud = MoxaPortSetTermio(ch, ts, tty_get_baud_rate(tty));
 	if (baud == -1)
 		baud = tty_termios_baud_rate(old_termios);
 	/* Not put the baud rate into the termios data */
@@ -1411,7 +1403,7 @@ static int moxa_block_till_ready(struct 
 	retval = 0;
 	add_wait_queue(&ch->open_wait, &wait);
 	pr_debug("block_til_ready before block: ttys%d, count = %d\n",
-		ch->port, ch->count);
+		tty->index, ch->count);
 	spin_lock_irqsave(&moxa_lock, flags);
 	if (!tty_hung_up_p(filp))
 		ch->count--;
@@ -1433,7 +1425,7 @@ static int moxa_block_till_ready(struct 
 			break;
 		}
 		if (!(ch->asyncflags & ASYNC_CLOSING) && (do_clocal ||
-						MoxaPortDCDON(ch->port)))
+						MoxaPortDCDON(ch)))
 			break;
 
 		if (signal_pending(current)) {
@@ -1451,7 +1443,7 @@ static int moxa_block_till_ready(struct 
 	ch->blocked_open--;
 	spin_unlock_irqrestore(&moxa_lock, flags);
 	pr_debug("block_til_ready after blocking: ttys%d, count = %d\n",
-		ch->port, ch->count);
+		tty->index, ch->count);
 	if (retval)
 		return (retval);
 	/* FIXME: review to see if we need to use set_bit on these */
@@ -1466,7 +1458,7 @@ static void moxa_setup_empty_event(struc
 
 	spin_lock_irqsave(&moxa_lock, flags);
 	ch->statusflags |= EMPTYWAIT;
-	mod_timer(&moxa_ports[ch->port].emptyTimer, jiffies + HZ);
+	mod_timer(&ch->emptyTimer, jiffies + HZ);
 	spin_unlock_irqrestore(&moxa_lock, flags);
 }
 
@@ -1476,13 +1468,12 @@ static void moxa_check_xmit_empty(unsign
 
 	ch = (struct moxa_port *) data;
 	if (ch->tty && (ch->statusflags & EMPTYWAIT)) {
-		if (MoxaPortTxQueue(ch->port) == 0) {
+		if (MoxaPortTxQueue(ch) == 0) {
 			ch->statusflags &= ~EMPTYWAIT;
 			tty_wakeup(ch->tty);
 			return;
 		}
-		mod_timer(&moxa_ports[ch->port].emptyTimer,
-				round_jiffies(jiffies + HZ));
+		mod_timer(&ch->emptyTimer, round_jiffies(jiffies + HZ));
 	} else
 		ch->statusflags &= ~EMPTYWAIT;
 }
@@ -1496,13 +1487,13 @@ static void moxa_shut_down(struct moxa_p
 
 	tp = ch->tty;
 
-	MoxaPortDisable(ch->port);
+	MoxaPortDisable(ch);
 
 	/*
 	 * If we're a modem control device and HUPCL is on, drop RTS & DTR.
 	 */
 	if (tp->termios->c_cflag & HUPCL)
-		MoxaPortLineCtrl(ch->port, 0, 0);
+		MoxaPortLineCtrl(ch, 0, 0);
 
 	ch->asyncflags &= ~ASYNC_INITIALIZED;
 }
@@ -1521,11 +1512,11 @@ static void moxa_receive_data(struct mox
 	if ( !tp || !ts || !(ts->c_cflag & CREAD) ) {
 	*****************************************************/
 	if (!tp || !ts) {
-		MoxaPortFlushData(ch->port, 0);
+		MoxaPortFlushData(ch, 0);
 		return;
 	}
 	spin_lock_irqsave(&moxa_lock, flags);
-	MoxaPortReadData(ch->port, tp);
+	MoxaPortReadData(ch, tp);
 	spin_unlock_irqrestore(&moxa_lock, flags);
 	tty_schedule_flip(tp);
 }
@@ -1567,27 +1558,28 @@ static void moxa_low_water_check(void __
 #define MOXA_GET_CUMAJOR        (MOXA + 64)
 #define MOXA_GETMSTATUS         (MOXA + 65)
 
-void MoxaPortFlushData(int port, int mode)
+static void MoxaPortFlushData(struct moxa_port *port, int mode)
 {
 	void __iomem *ofsAddr;
 	if ((mode < 0) || (mode > 2))
 		return;
-	ofsAddr = moxa_ports[port].tableAddr;
+	ofsAddr = port->tableAddr;
 	moxafunc(ofsAddr, FC_FlushQueue, mode);
 	if (mode != 1) {
-		moxa_ports[port].lowChkFlag = 0;
+		port->lowChkFlag = 0;
 		moxa_low_water_check(ofsAddr);
 	}
 }
 
-int MoxaDriverIoctl(unsigned int cmd, unsigned long arg, int port)
+static int MoxaDriverIoctl(struct tty_struct *tty, unsigned int cmd,
+		unsigned long arg)
 {
+	struct moxa_port *port = tty->driver_data;
 	int i;
 	int status;
-	int MoxaPortTxQueue(int), MoxaPortRxQueue(int);
 	void __user *argp = (void __user *)arg;
 
-	if (port == MAX_PORTS) {
+	if (tty->index == MAX_PORTS) {
 		if ((cmd != MOXA_GET_CONF) && (cmd != MOXA_GETDATACOUNT) &&
 		    (cmd != MOXA_GET_IOQUEUE) && (cmd != MOXA_GET_MAJOR) &&
 		    (cmd != MOXA_GET_CUMAJOR) && (cmd != MOXA_GETMSTATUS))
@@ -1609,8 +1601,8 @@ int MoxaDriverIoctl(unsigned int cmd, un
 		for (i = 0; i < MAX_PORTS; i++, argm++) {
 			memset(&tmp, 0, sizeof(tmp));
 			if (moxa_ports[i].chkPort) {
-				tmp.inq = MoxaPortRxQueue(i);
-				tmp.outq = MoxaPortTxQueue(i);
+				tmp.inq = MoxaPortRxQueue(&moxa_ports[i]);
+				tmp.outq = MoxaPortTxQueue(&moxa_ports[i]);
 			}
 			if (copy_to_user(argm, &tmp, sizeof(tmp)))
 				return -EFAULT;
@@ -1642,7 +1634,7 @@ int MoxaDriverIoctl(unsigned int cmd, un
 			if (!p->chkPort) {
 				goto copy;
 			} else {
-				status = MoxaPortLineStatus(p->port);
+				status = MoxaPortLineStatus(p);
 				if (status & 1)
 					tmp.cts = 1;
 				if (status & 2)
@@ -2016,7 +2008,7 @@ int MoxaPortsOfCard(int cardno)
  *                                send out a about 250 ms BREAK signal.
  *
  */
-int MoxaPortIsValid(int port)
+static int MoxaPortIsValid(int port)
 {
 	if (moxaCard == 0)
 		return (0);
@@ -2025,17 +2017,16 @@ int MoxaPortIsValid(int port)
 	return (1);
 }
 
-void MoxaPortEnable(int port)
+static void MoxaPortEnable(struct moxa_port *port)
 {
 	void __iomem *ofsAddr;
-	int MoxaPortLineStatus(int);
 	short lowwater = 512;
 
-	ofsAddr = moxa_ports[port].tableAddr;
+	ofsAddr = port->tableAddr;
 	writew(lowwater, ofsAddr + Low_water);
-	moxa_ports[port].breakCnt = 0;
-	if ((moxa_boards[port / MAX_PORTS_PER_BOARD].boardType == MOXA_BOARD_C320_ISA) ||
-	    (moxa_boards[port / MAX_PORTS_PER_BOARD].boardType == MOXA_BOARD_C320_PCI)) {
+	port->breakCnt = 0;
+	if (port->board->boardType == MOXA_BOARD_C320_ISA ||
+	    port->board->boardType == MOXA_BOARD_C320_PCI) {
 		moxafunc(ofsAddr, FC_SetBreakIrq, 0);
 	} else {
 		writew(readw(ofsAddr + HostStat) | WakeupBreak, ofsAddr + HostStat);
@@ -2048,9 +2039,9 @@ void MoxaPortEnable(int port)
 	MoxaPortLineStatus(port);
 }
 
-void MoxaPortDisable(int port)
+static void MoxaPortDisable(struct moxa_port *port)
 {
-	void __iomem *ofsAddr = moxa_ports[port].tableAddr;
+	void __iomem *ofsAddr = port->tableAddr;
 
 	moxafunc(ofsAddr, FC_SetFlowCtl, 0);	/* disable flow control */
 	moxafunc(ofsAddr, FC_ClrLineIrq, Magic_code);
@@ -2058,17 +2049,17 @@ void MoxaPortDisable(int port)
 	moxafunc(ofsAddr, FC_DisableCH, Magic_code);
 }
 
-long MoxaPortGetMaxBaud(int port)
+static long MoxaPortGetMaxBaud(struct moxa_port *port)
 {
-	if ((moxa_boards[port / MAX_PORTS_PER_BOARD].boardType == MOXA_BOARD_C320_ISA) ||
-	    (moxa_boards[port / MAX_PORTS_PER_BOARD].boardType == MOXA_BOARD_C320_PCI))
+	if (port->board->boardType == MOXA_BOARD_C320_ISA ||
+			port->board->boardType == MOXA_BOARD_C320_PCI)
 		return (460800L);
 	else
 		return (921600L);
 }
 
 
-long MoxaPortSetBaud(int port, long baud)
+static long MoxaPortSetBaud(struct moxa_port *port, long baud)
 {
 	void __iomem *ofsAddr;
 	long max, clock;
@@ -2076,7 +2067,7 @@ long MoxaPortSetBaud(int port, long baud
 
 	if ((baud < 50L) || ((max = MoxaPortGetMaxBaud(port)) == 0))
 		return (0);
-	ofsAddr = moxa_ports[port].tableAddr;
+	ofsAddr = port->tableAddr;
 	if (baud > max)
 		baud = max;
 	if (max == 38400L)
@@ -2088,19 +2079,20 @@ long MoxaPortSetBaud(int port, long baud
 	val = clock / baud;
 	moxafunc(ofsAddr, FC_SetBaud, val);
 	baud = clock / val;
-	moxa_ports[port].curBaud = baud;
+	port->curBaud = baud;
 	return (baud);
 }
 
-int MoxaPortSetTermio(int port, struct ktermios *termio, speed_t baud)
+static int MoxaPortSetTermio(struct moxa_port *port, struct ktermios *termio,
+		speed_t baud)
 {
 	void __iomem *ofsAddr;
 	tcflag_t cflag;
 	tcflag_t mode = 0;
 
-	if (moxa_ports[port].chkPort == 0 || termio == 0)
+	if (port->chkPort == 0 || termio == 0)
 		return (-1);
-	ofsAddr = moxa_ports[port].tableAddr;
+	ofsAddr = port->tableAddr;
 	cflag = termio->c_cflag;	/* termio->c_cflag */
 
 	mode = termio->c_cflag & CSIZE;
@@ -2131,8 +2123,8 @@ int MoxaPortSetTermio(int port, struct k
 
 	moxafunc(ofsAddr, FC_SetDataMode, (ushort) mode);
 
-	if ((moxa_boards[port / MAX_PORTS_PER_BOARD].boardType == MOXA_BOARD_C320_ISA) ||
-	    (moxa_boards[port / MAX_PORTS_PER_BOARD].boardType == MOXA_BOARD_C320_PCI)) {
+	if (port->board->boardType == MOXA_BOARD_C320_ISA ||
+			port->board->boardType == MOXA_BOARD_C320_PCI) {
 		if (baud >= 921600L)
 			return (-1);
 	}
@@ -2148,48 +2140,37 @@ int MoxaPortSetTermio(int port, struct k
 	return (baud);
 }
 
-int MoxaPortGetLineOut(int port, int *dtrState, int *rtsState)
+static int MoxaPortGetLineOut(struct moxa_port *port, int *dtrState,
+		int *rtsState)
 {
 
-	if (!MoxaPortIsValid(port))
+	if (!MoxaPortIsValid(port->tty->index))
 		return (-1);
-	if (dtrState) {
-		if (moxa_ports[port].lineCtrl & DTR_ON)
-			*dtrState = 1;
-		else
-			*dtrState = 0;
-	}
-	if (rtsState) {
-		if (moxa_ports[port].lineCtrl & RTS_ON)
-			*rtsState = 1;
-		else
-			*rtsState = 0;
-	}
+	if (dtrState)
+		*dtrState = !!(port->lineCtrl & DTR_ON);
+	if (rtsState)
+		*rtsState = !!(port->lineCtrl & RTS_ON);
+
 	return (0);
 }
 
-void MoxaPortLineCtrl(int port, int dtr, int rts)
+static void MoxaPortLineCtrl(struct moxa_port *port, int dtr, int rts)
 {
-	void __iomem *ofsAddr;
-	int mode;
+	int mode = 0;
 
-	ofsAddr = moxa_ports[port].tableAddr;
-	mode = 0;
 	if (dtr)
 		mode |= DTR_ON;
 	if (rts)
 		mode |= RTS_ON;
-	moxa_ports[port].lineCtrl = mode;
-	moxafunc(ofsAddr, FC_LineControl, mode);
+	port->lineCtrl = mode;
+	moxafunc(port->tableAddr, FC_LineControl, mode);
 }
 
-void MoxaPortFlowCtrl(int port, int rts, int cts, int txflow, int rxflow, int txany)
+static void MoxaPortFlowCtrl(struct moxa_port *port, int rts, int cts,
+		int txflow, int rxflow, int txany)
 {
-	void __iomem *ofsAddr;
-	int mode;
+	int mode = 0;
 
-	ofsAddr = moxa_ports[port].tableAddr;
-	mode = 0;
 	if (rts)
 		mode |= RTS_FlowCtl;
 	if (cts)
@@ -2200,17 +2181,17 @@ void MoxaPortFlowCtrl(int port, int rts,
 		mode |= Rx_FlowCtl;
 	if (txany)
 		mode |= IXM_IXANY;
-	moxafunc(ofsAddr, FC_SetFlowCtl, mode);
+	moxafunc(port->tableAddr, FC_SetFlowCtl, mode);
 }
 
-int MoxaPortLineStatus(int port)
+static int MoxaPortLineStatus(struct moxa_port *port)
 {
 	void __iomem *ofsAddr;
 	int val;
 
-	ofsAddr = moxa_ports[port].tableAddr;
-	if ((moxa_boards[port / MAX_PORTS_PER_BOARD].boardType == MOXA_BOARD_C320_ISA) ||
-	    (moxa_boards[port / MAX_PORTS_PER_BOARD].boardType == MOXA_BOARD_C320_PCI)) {
+	ofsAddr = port->tableAddr;
+	if (port->board->boardType == MOXA_BOARD_C320_ISA ||
+			port->board->boardType == MOXA_BOARD_C320_PCI) {
 		moxafunc(ofsAddr, FC_LineStatus, 0);
 		val = readw(ofsAddr + FuncArg);
 	} else {
@@ -2219,42 +2200,43 @@ int MoxaPortLineStatus(int port)
 	val &= 0x0B;
 	if (val & 8) {
 		val |= 4;
-		if ((moxa_ports[port].DCDState & DCD_oldstate) == 0)
-			moxa_ports[port].DCDState = (DCD_oldstate | DCD_changed);
+		if ((port->DCDState & DCD_oldstate) == 0)
+			port->DCDState = (DCD_oldstate | DCD_changed);
 	} else {
-		if (moxa_ports[port].DCDState & DCD_oldstate)
-			moxa_ports[port].DCDState = DCD_changed;
+		if (port->DCDState & DCD_oldstate)
+			port->DCDState = DCD_changed;
 	}
 	val &= 7;
 	return (val);
 }
 
-int MoxaPortDCDChange(int port)
+static int MoxaPortDCDChange(struct moxa_port *port)
 {
 	int n;
 
-	if (moxa_ports[port].chkPort == 0)
+	if (port->chkPort == 0)
 		return (0);
-	n = moxa_ports[port].DCDState;
-	moxa_ports[port].DCDState &= ~DCD_changed;
+	n = port->DCDState;
+	port->DCDState &= ~DCD_changed;
 	n &= DCD_changed;
 	return (n);
 }
 
-int MoxaPortDCDON(int port)
+static int MoxaPortDCDON(struct moxa_port *port)
 {
 	int n;
 
-	if (moxa_ports[port].chkPort == 0)
+	if (port->chkPort == 0)
 		return (0);
-	if (moxa_ports[port].DCDState & DCD_oldstate)
+	if (port->DCDState & DCD_oldstate)
 		n = 1;
 	else
 		n = 0;
 	return (n);
 }
 
-int MoxaPortWriteData(int port, unsigned char * buffer, int len)
+static int MoxaPortWriteData(struct moxa_port *port, unsigned char *buffer,
+		int len)
 {
 	int c, total, i;
 	ushort tail;
@@ -2263,8 +2245,8 @@ int MoxaPortWriteData(int port, unsigned
 	ushort pageno, pageofs, bufhead;
 	void __iomem *baseAddr, *ofsAddr, *ofs;
 
-	ofsAddr = moxa_ports[port].tableAddr;
-	baseAddr = moxa_boards[port / MAX_PORTS_PER_BOARD].basemem;
+	ofsAddr = port->tableAddr;
+	baseAddr = port->board->basemem;
 	tx_mask = readw(ofsAddr + TX_mask);
 	spage = readw(ofsAddr + Page_txb);
 	epage = readw(ofsAddr + EndPage_txb);
@@ -2274,7 +2256,7 @@ int MoxaPortWriteData(int port, unsigned
 	    : (head - tail + tx_mask);
 	if (c > len)
 		c = len;
-	moxaLog.txcnt[port] += c;
+	moxaLog.txcnt[port->tty->index] += c;
 	total = c;
 	if (spage == epage) {
 		bufhead = readw(ofsAddr + Ofs_txb);
@@ -2318,7 +2300,7 @@ int MoxaPortWriteData(int port, unsigned
 	return (total);
 }
 
-int MoxaPortReadData(int port, struct tty_struct *tty)
+static int MoxaPortReadData(struct moxa_port *port, struct tty_struct *tty)
 {
 	register ushort head, pageofs;
 	int i, count, cnt, len, total, remain;
@@ -2326,8 +2308,8 @@ int MoxaPortReadData(int port, struct tt
 	ushort pageno, bufhead;
 	void __iomem *baseAddr, *ofsAddr, *ofs;
 
-	ofsAddr = moxa_ports[port].tableAddr;
-	baseAddr = moxa_boards[port / MAX_PORTS_PER_BOARD].basemem;
+	ofsAddr = port->tableAddr;
+	baseAddr = port->board->basemem;
 	head = readw(ofsAddr + RXrptr);
 	tail = readw(ofsAddr + RXwptr);
 	rx_mask = readw(ofsAddr + RX_mask);
@@ -2340,7 +2322,7 @@ int MoxaPortReadData(int port, struct tt
 
 	total = count;
 	remain = count - total;
-	moxaLog.rxcnt[port] += total;
+	moxaLog.rxcnt[port->tty->index] += total;
 	count = total;
 	if (spage == epage) {
 		bufhead = readw(ofsAddr + Ofs_rxb);
@@ -2382,19 +2364,18 @@ int MoxaPortReadData(int port, struct tt
 	}
 	if ((readb(ofsAddr + FlagStat) & Xoff_state) && (remain < LowWater)) {
 		moxaLowWaterChk = 1;
-		moxa_ports[port].lowChkFlag = 1;
+		port->lowChkFlag = 1;
 	}
 	return (total);
 }
 
 
-int MoxaPortTxQueue(int port)
+static int MoxaPortTxQueue(struct moxa_port *port)
 {
-	void __iomem *ofsAddr;
+	void __iomem *ofsAddr = port->tableAddr;
 	ushort rptr, wptr, mask;
 	int len;
 
-	ofsAddr = moxa_ports[port].tableAddr;
 	rptr = readw(ofsAddr + TXrptr);
 	wptr = readw(ofsAddr + TXwptr);
 	mask = readw(ofsAddr + TX_mask);
@@ -2402,13 +2383,12 @@ int MoxaPortTxQueue(int port)
 	return (len);
 }
 
-int MoxaPortTxFree(int port)
+static int MoxaPortTxFree(struct moxa_port *port)
 {
-	void __iomem *ofsAddr;
+	void __iomem *ofsAddr = port->tableAddr;
 	ushort rptr, wptr, mask;
 	int len;
 
-	ofsAddr = moxa_ports[port].tableAddr;
 	rptr = readw(ofsAddr + TXrptr);
 	wptr = readw(ofsAddr + TXwptr);
 	mask = readw(ofsAddr + TX_mask);
@@ -2416,13 +2396,12 @@ int MoxaPortTxFree(int port)
 	return (len);
 }
 
-int MoxaPortRxQueue(int port)
+static int MoxaPortRxQueue(struct moxa_port *port)
 {
-	void __iomem *ofsAddr;
+	void __iomem *ofsAddr = port->tableAddr;
 	ushort rptr, wptr, mask;
 	int len;
 
-	ofsAddr = moxa_ports[port].tableAddr;
 	rptr = readw(ofsAddr + RXrptr);
 	wptr = readw(ofsAddr + RXwptr);
 	mask = readw(ofsAddr + RX_mask);
@@ -2431,37 +2410,30 @@ int MoxaPortRxQueue(int port)
 }
 
 
-void MoxaPortTxDisable(int port)
+static void MoxaPortTxDisable(struct moxa_port *port)
 {
-	void __iomem *ofsAddr;
-
-	ofsAddr = moxa_ports[port].tableAddr;
-	moxafunc(ofsAddr, FC_SetXoffState, Magic_code);
+	moxafunc(port->tableAddr, FC_SetXoffState, Magic_code);
 }
 
-void MoxaPortTxEnable(int port)
+static void MoxaPortTxEnable(struct moxa_port *port)
 {
-	void __iomem *ofsAddr;
-
-	ofsAddr = moxa_ports[port].tableAddr;
-	moxafunc(ofsAddr, FC_SetXonState, Magic_code);
+	moxafunc(port->tableAddr, FC_SetXonState, Magic_code);
 }
 
 
-int MoxaPortResetBrkCnt(int port)
+static int MoxaPortResetBrkCnt(struct moxa_port *port)
 {
 	ushort cnt;
-	cnt = moxa_ports[port].breakCnt;
-	moxa_ports[port].breakCnt = 0;
+	cnt = port->breakCnt;
+	port->breakCnt = 0;
 	return (cnt);
 }
 
 
-void MoxaPortSendBreak(int port, int ms100)
+static void MoxaPortSendBreak(struct moxa_port *port, int ms100)
 {
-	void __iomem *ofsAddr;
+	void __iomem *ofsAddr = port->tableAddr;
 
-	ofsAddr = moxa_ports[port].tableAddr;
 	if (ms100) {
 		moxafunc(ofsAddr, FC_SendBreak, Magic_code);
 		msleep(ms100 * 10);
@@ -2479,7 +2451,7 @@ static int moxa_get_serial_info(struct m
 
 	memset(&tmp, 0, sizeof(tmp));
 	tmp.type = info->type;
-	tmp.line = info->port;
+	tmp.line = info->tty->index;
 	tmp.port = 0;
 	tmp.irq = 0;
 	tmp.flags = info->asyncflags;
@@ -2522,9 +2494,9 @@ static int moxa_set_serial_info(struct m
 	new_serial.flags |= (info->asyncflags & ASYNC_FLAGS);
 
 	if (new_serial.type == PORT_16550A) {
-		MoxaSetFifo(info->port, 1);
+		MoxaSetFifo(info, 1);
 	} else {
-		MoxaSetFifo(info->port, 0);
+		MoxaSetFifo(info, 0);
 	}
 
 	info->type = new_serial.type;
@@ -2572,9 +2544,9 @@ static void moxa_low_water_check(void __
 	}
 }
 
-static void MoxaSetFifo(int port, int enable)
+static void MoxaSetFifo(struct moxa_port *port, int enable)
 {
-	void __iomem *ofsAddr = moxa_ports[port].tableAddr;
+	void __iomem *ofsAddr = port->tableAddr;
 
 	if (!enable) {
 		moxafunc(ofsAddr, FC_SetRxFIFOTrig, 0);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

