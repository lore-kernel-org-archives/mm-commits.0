From: akpm@linux-foundation.org
Subject: - char-moxa-ioctl-cleanup.patch removed from -mm tree
Date: Thu, 01 May 2008 02:29:14 -0700
Message-ID: <200805010929.m419TECq030656@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49773 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757353AbYEAJ3T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:29:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, Oyvind.Aabling@uni-c.dk, mm-commits@vger.kernel.org


The patch titled
     Char: moxa, ioctl cleanup
has been removed from the -mm tree.  Its filename was
     char-moxa-ioctl-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: moxa, ioctl cleanup
From: Jiri Slaby <jirislaby@gmail.com>

- allow stats only for sys_admin
- move TCSBRK* processing to .break_ctl tty op
- let TIOCGSOFTCAR and TIOCSSOFTCAR be processed by ldisc
- remove MOXA_GET_MAJOR, MOXA_GET_CUMAJOR
- fix jiffies subtraction by time_after
- move moxa ioctl numbers into the header; still not exported to userspace,
  needs _IOC and 32/64 compat cleanup anyways

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Tested-by: Oyvind Aabling <Oyvind.Aabling@uni-c.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |  360 ++++++++++++++++--------------------------
 drivers/char/moxa.h |    8 
 2 files changed, 147 insertions(+), 221 deletions(-)

diff -puN drivers/char/moxa.c~char-moxa-ioctl-cleanup drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-ioctl-cleanup
+++ a/drivers/char/moxa.c
@@ -150,6 +150,12 @@ struct moxa_port {
 	ushort breakCnt;
 };
 
+struct mon_str {
+	int tick;
+	int rxcnt[MAX_PORTS];
+	int txcnt[MAX_PORTS];
+};
+
 /* statusflags */
 #define TXSTOPPED	0x1
 #define LOWWAIT 	0x2
@@ -161,6 +167,8 @@ struct moxa_port {
 #define WAKEUP_CHARS		256
 
 static int ttymajor = MOXAMAJOR;
+static struct mon_str moxaLog;
+static unsigned int moxaFuncTout = HZ / 2;
 /* Variables for insmod */
 #ifdef MODULE
 static unsigned long baseaddr[MAX_BOARDS];
@@ -192,7 +200,6 @@ static void moxa_flush_buffer(struct tty
 static int moxa_chars_in_buffer(struct tty_struct *);
 static void moxa_flush_chars(struct tty_struct *);
 static void moxa_put_char(struct tty_struct *, unsigned char);
-static int moxa_ioctl(struct tty_struct *, struct file *, unsigned int, unsigned long);
 static void moxa_throttle(struct tty_struct *);
 static void moxa_unthrottle(struct tty_struct *);
 static void moxa_set_termios(struct tty_struct *, struct ktermios *);
@@ -213,7 +220,6 @@ static void moxa_receive_data(struct mox
 /*
  * moxa board interface functions:
  */
-static int MoxaDriverIoctl(struct tty_struct *, unsigned int, unsigned long);
 static int MoxaDriverPoll(void);
 static void MoxaPortEnable(struct moxa_port *);
 static void MoxaPortDisable(struct moxa_port *);
@@ -233,11 +239,131 @@ static int MoxaPortTxFree(struct moxa_po
 static void MoxaPortTxDisable(struct moxa_port *);
 static void MoxaPortTxEnable(struct moxa_port *);
 static int MoxaPortResetBrkCnt(struct moxa_port *);
-static void MoxaPortSendBreak(struct moxa_port *, int);
 static int moxa_get_serial_info(struct moxa_port *, struct serial_struct __user *);
 static int moxa_set_serial_info(struct moxa_port *, struct serial_struct __user *);
 static void MoxaSetFifo(struct moxa_port *port, int enable);
 
+/*
+ * I/O functions
+ */
+
+static void moxa_wait_finish(void __iomem *ofsAddr)
+{
+	unsigned long end = jiffies + moxaFuncTout;
+
+	while (readw(ofsAddr + FuncCode) != 0)
+		if (time_after(jiffies, end))
+			return;
+	if (readw(ofsAddr + FuncCode) != 0 && printk_ratelimit())
+		printk(KERN_WARNING "moxa function expired\n");
+}
+
+static void moxafunc(void __iomem *ofsAddr, int cmd, ushort arg)
+{
+	writew(arg, ofsAddr + FuncArg);
+	writew(cmd, ofsAddr + FuncCode);
+	moxa_wait_finish(ofsAddr);
+}
+
+/*
+ * TTY operations
+ */
+
+static int moxa_ioctl(struct tty_struct *tty, struct file *file,
+		      unsigned int cmd, unsigned long arg)
+{
+	struct moxa_port *ch = tty->driver_data;
+	void __user *argp = (void __user *)arg;
+	int status;
+
+	if (tty->index == MAX_PORTS) {
+		if (cmd != MOXA_GETDATACOUNT && cmd != MOXA_GET_IOQUEUE &&
+				cmd != MOXA_GETMSTATUS)
+			return -EINVAL;
+	} else if (!ch)
+		return -ENODEV;
+
+	switch (cmd) {
+	case MOXA_GETDATACOUNT:
+		moxaLog.tick = jiffies;
+		return copy_to_user(argp, &moxaLog, sizeof(moxaLog)) ?
+			-EFAULT : 0;
+	case MOXA_FLUSH_QUEUE:
+		MoxaPortFlushData(ch, arg);
+		return 0;
+	case MOXA_GET_IOQUEUE: {
+		struct moxaq_str __user *argm = argp;
+		struct moxaq_str tmp;
+		struct moxa_port *p;
+		unsigned int i, j;
+
+		for (i = 0; i < MAX_BOARDS; i++) {
+			p = moxa_boards[i].ports;
+			for (j = 0; j < MAX_PORTS_PER_BOARD; j++, p++, argm++) {
+				memset(&tmp, 0, sizeof(tmp));
+				if (moxa_boards[i].ready) {
+					tmp.inq = MoxaPortRxQueue(p);
+					tmp.outq = MoxaPortTxQueue(p);
+				}
+				if (copy_to_user(argm, &tmp, sizeof(tmp)))
+					return -EFAULT;
+			}
+		}
+		return 0;
+	} case MOXA_GET_OQUEUE:
+		status = MoxaPortTxQueue(ch);
+		return put_user(status, (unsigned long __user *)argp);
+	case MOXA_GET_IQUEUE:
+		status = MoxaPortRxQueue(ch);
+		return put_user(status, (unsigned long __user *)argp);
+	case MOXA_GETMSTATUS: {
+		struct mxser_mstatus __user *argm = argp;
+		struct mxser_mstatus tmp;
+		struct moxa_port *p;
+		unsigned int i, j;
+
+		for (i = 0; i < MAX_BOARDS; i++) {
+			p = moxa_boards[i].ports;
+			for (j = 0; j < MAX_PORTS_PER_BOARD; j++, p++, argm++) {
+				memset(&tmp, 0, sizeof(tmp));
+				if (!moxa_boards[i].ready)
+					goto copy;
+
+				status = MoxaPortLineStatus(p);
+				if (status & 1)
+					tmp.cts = 1;
+				if (status & 2)
+					tmp.dsr = 1;
+				if (status & 4)
+					tmp.dcd = 1;
+
+				if (!p->tty || !p->tty->termios)
+					tmp.cflag = p->cflag;
+				else
+					tmp.cflag = p->tty->termios->c_cflag;
+copy:
+				if (copy_to_user(argm, &tmp, sizeof(tmp)))
+					return -EFAULT;
+			}
+		}
+		return 0;
+	}
+	case TIOCGSERIAL:
+		return moxa_get_serial_info(ch, argp);
+	case TIOCSSERIAL:
+		return moxa_set_serial_info(ch, argp);
+	}
+	return -ENOIOCTLCMD;
+}
+
+static void moxa_break_ctl(struct tty_struct *tty, int state)
+{
+	struct moxa_port *port = tty->driver_data;
+
+	moxafunc(port->tableAddr, state ? FC_SendBreak : FC_StopBreak,
+			Magic_code);
+}
+
 static const struct tty_operations moxa_ops = {
 	.open = moxa_open,
 	.close = moxa_close,
@@ -254,6 +380,7 @@ static const struct tty_operations moxa_
 	.stop = moxa_stop,
 	.start = moxa_start,
 	.hangup = moxa_hangup,
+	.break_ctl = moxa_break_ctl,
 	.tiocmget = moxa_tiocmget,
 	.tiocmset = moxa_tiocmset,
 };
@@ -262,6 +389,10 @@ static struct tty_driver *moxaDriver;
 static DEFINE_TIMER(moxaTimer, moxa_poll, 0, 0);
 static DEFINE_SPINLOCK(moxa_lock);
 
+/*
+ * HW init
+ */
+
 static int moxa_check_fw_model(struct moxa_board_conf *brd, u8 model)
 {
 	switch (brd->boardType) {
@@ -938,7 +1069,7 @@ static int moxa_open(struct tty_struct *
 
 	port = tty->index;
 	if (port == MAX_PORTS) {
-		return (0);
+		return capable(CAP_SYS_ADMIN) ? 0 : -EPERM;
 	}
 	brd = &moxa_boards[port / MAX_PORTS_PER_BOARD];
 	if (!brd->ready)
@@ -1123,8 +1254,8 @@ static int moxa_tiocmget(struct tty_stru
 	struct moxa_port *ch = tty->driver_data;
 	int flag = 0, dtr, rts;
 
-	if ((tty->index != MAX_PORTS) && (!ch))
-		return (-EINVAL);
+	if (!ch)
+		return -EINVAL;
 
 	MoxaPortGetLineOut(ch, &dtr, &rts);
 	if (dtr)
@@ -1149,8 +1280,8 @@ static int moxa_tiocmset(struct tty_stru
 	int dtr, rts;
 
 	port = tty->index;
-	if ((port != MAX_PORTS) && (!ch))
-		return (-EINVAL);
+	if (!ch)
+		return -EINVAL;
 
 	MoxaPortGetLineOut(ch, &dtr, &rts);
 	if (set & TIOCM_RTS)
@@ -1165,60 +1296,6 @@ static int moxa_tiocmset(struct tty_stru
 	return 0;
 }
 
-static int moxa_ioctl(struct tty_struct *tty, struct file *file,
-		      unsigned int cmd, unsigned long arg)
-{
-	struct moxa_port *ch = tty->driver_data;
-	register int port;
-	void __user *argp = (void __user *)arg;
-	int retval;
-
-	port = tty->index;
-	if ((port != MAX_PORTS) && (!ch))
-		return (-EINVAL);
-
-	switch (cmd) {
-	case TCSBRK:		/* SVID version: non-zero arg --> no break */
-		retval = tty_check_change(tty);
-		if (retval)
-			return (retval);
-		moxa_setup_empty_event(tty);
-		tty_wait_until_sent(tty, 0);
-		if (!arg)
-			MoxaPortSendBreak(ch, 0);
-		return (0);
-	case TCSBRKP:		/* support for POSIX tcsendbreak() */
-		retval = tty_check_change(tty);
-		if (retval)
-			return (retval);
-		moxa_setup_empty_event(tty);
-		tty_wait_until_sent(tty, 0);
-		MoxaPortSendBreak(ch, arg);
-		return (0);
-	case TIOCGSOFTCAR:
-		return put_user(C_CLOCAL(tty) ? 1 : 0, (int __user *)argp);
-	case TIOCSSOFTCAR:
-		if (get_user(retval, (int __user *)argp))
-			return -EFAULT;
-		arg = retval;
-		tty->termios->c_cflag = ((tty->termios->c_cflag & ~CLOCAL) |
-					 (arg ? CLOCAL : 0));
-		if (C_CLOCAL(tty))
-			ch->asyncflags &= ~ASYNC_CHECK_CD;
-		else
-			ch->asyncflags |= ASYNC_CHECK_CD;
-		return (0);
-	case TIOCGSERIAL:
-		return moxa_get_serial_info(ch, argp);
-
-	case TIOCSSERIAL:
-		return moxa_set_serial_info(ch, argp);
-	default:
-		retval = MoxaDriverIoctl(tty, cmd, arg);
-	}
-	return (retval);
-}
-
 static void moxa_throttle(struct tty_struct *tty)
 {
 	struct moxa_port *ch = (struct moxa_port *) tty->driver_data;
@@ -1533,38 +1610,17 @@ static void moxa_receive_data(struct mox
  *    Query
  */
 
-struct mon_str {
-	int tick;
-	int rxcnt[MAX_PORTS];
-	int txcnt[MAX_PORTS];
-};
-
 #define 	DCD_changed	0x01
 #define 	DCD_oldstate	0x80
 
 static int moxaLowWaterChk;
-static struct mon_str moxaLog;
-static int moxaFuncTout = HZ / 2;
 
-static void moxafunc(void __iomem *, int, ushort);
-static void moxa_wait_finish(void __iomem *);
 static void moxa_low_water_check(void __iomem *);
 
 /*****************************************************************************
  *	Driver level functions: 					     *
- *	2. MoxaDriverIoctl(unsigned int cmd, unsigned long arg, int port);   *
  *	3. MoxaDriverPoll(void);					     *
  *****************************************************************************/
-#define	MOXA		0x400
-#define MOXA_GET_IQUEUE 	(MOXA + 1)	/* get input buffered count */
-#define MOXA_GET_OQUEUE 	(MOXA + 2)	/* get output buffered count */
-#define MOXA_GETDATACOUNT       (MOXA + 23)
-#define MOXA_GET_IOQUEUE	(MOXA + 27)
-#define MOXA_FLUSH_QUEUE	(MOXA + 28)
-#define MOXA_GET_CONF		(MOXA + 35)	/* configuration */
-#define MOXA_GET_MAJOR          (MOXA + 63)
-#define MOXA_GET_CUMAJOR        (MOXA + 64)
-#define MOXA_GETMSTATUS         (MOXA + 65)
 
 static void MoxaPortFlushData(struct moxa_port *port, int mode)
 {
@@ -1579,100 +1635,6 @@ static void MoxaPortFlushData(struct mox
 	}
 }
 
-static int MoxaDriverIoctl(struct tty_struct *tty, unsigned int cmd,
-		unsigned long arg)
-{
-	struct moxa_port *port = tty->driver_data;
-	int i;
-	int status;
-	void __user *argp = (void __user *)arg;
-
-	if (tty->index == MAX_PORTS) {
-		if ((cmd != MOXA_GET_CONF) && (cmd != MOXA_GETDATACOUNT) &&
-		    (cmd != MOXA_GET_IOQUEUE) && (cmd != MOXA_GET_MAJOR) &&
-		    (cmd != MOXA_GET_CUMAJOR) && (cmd != MOXA_GETMSTATUS))
-			return (-EINVAL);
-	}
-	switch (cmd) {
-	case MOXA_GETDATACOUNT:
-		moxaLog.tick = jiffies;
-		if(copy_to_user(argp, &moxaLog, sizeof(struct mon_str)))
-			return -EFAULT;
-		return (0);
-	case MOXA_FLUSH_QUEUE:
-		MoxaPortFlushData(port, arg);
-		return (0);
-	case MOXA_GET_IOQUEUE: {
-		struct moxaq_str __user *argm = argp;
-		struct moxaq_str tmp;
-		struct moxa_port *p;
-		unsigned int j;
-
-		for (i = 0; i < MAX_BOARDS; i++) {
-			p = moxa_boards[i].ports;
-			for (j = 0; j < MAX_PORTS_PER_BOARD; j++, p++, argm++) {
-				memset(&tmp, 0, sizeof(tmp));
-				if (moxa_boards[i].ready) {
-					tmp.inq = MoxaPortRxQueue(p);
-					tmp.outq = MoxaPortTxQueue(p);
-				}
-				if (copy_to_user(argm, &tmp, sizeof(tmp)))
-					return -EFAULT;
-			}
-		}
-		return 0;
-	} case MOXA_GET_OQUEUE:
-		i = MoxaPortTxQueue(port);
-		return put_user(i, (unsigned long __user *)argp);
-	case MOXA_GET_IQUEUE:
-		i = MoxaPortRxQueue(port);
-		return put_user(i, (unsigned long __user *)argp);
-	case MOXA_GET_MAJOR:
-		if(copy_to_user(argp, &ttymajor, sizeof(int)))
-			return -EFAULT;
-		return 0;
-	case MOXA_GET_CUMAJOR:
-		i = 0;
-		if(copy_to_user(argp, &i, sizeof(int)))
-			return -EFAULT;
-		return 0;
-	case MOXA_GETMSTATUS: {
-		struct mxser_mstatus __user *argm = argp;
-		struct mxser_mstatus tmp;
-		struct moxa_port *p;
-		unsigned int j;
-
-		for (i = 0; i < MAX_BOARDS; i++) {
-			p = moxa_boards[i].ports;
-			for (j = 0; j < MAX_PORTS_PER_BOARD; j++, p++, argm++) {
-				memset(&tmp, 0, sizeof(tmp));
-				if (!moxa_boards[i].ready)
-					goto copy;
-
-				status = MoxaPortLineStatus(p);
-				if (status & 1)
-					tmp.cts = 1;
-				if (status & 2)
-					tmp.dsr = 1;
-				if (status & 4)
-					tmp.dcd = 1;
-
-				if (!p->tty || !p->tty->termios)
-					tmp.cflag = p->cflag;
-				else
-					tmp.cflag = p->tty->termios->c_cflag;
-copy:
-				if (copy_to_user(argm, &tmp, sizeof(tmp)))
-					return -EFAULT;
-			}
-		}
-		return 0;
-	}
-	}
-
-	return -ENOIOCTLCMD;
-}
-
 static int MoxaDriverPoll(void)
 {
 	struct moxa_board_conf *brd;
@@ -1756,7 +1718,6 @@ static int MoxaDriverPoll(void)
  *	24. MoxaPortTxDisable(int port);				     *
  *	25. MoxaPortTxEnable(int port); 				     *
  *	27. MoxaPortResetBrkCnt(int port);				     *
- *	30. MoxaPortSendBreak(int port, int ticks);			     *
  *****************************************************************************/
 /*
  *    Moxa Port Number Description:
@@ -1984,14 +1945,6 @@ static int MoxaDriverPoll(void)
  *           return:    0 - ..  : BREAK signal count
  *
  *
- *      Function 34:    Send out a BREAK signal.
- *      Syntax:
- *      void MoxaPortSendBreak(int port, int ms100);
- *           int port           : port number (0 - 127)
- *           int ms100          : break signal time interval.
- *                                unit: 100 mini-second. if ms100 == 0, it will
- *                                send out a about 250 ms BREAK signal.
- *
  */
 
 static void MoxaPortEnable(struct moxa_port *port)
@@ -2397,21 +2350,6 @@ static int MoxaPortResetBrkCnt(struct mo
 	return (cnt);
 }
 
-
-static void MoxaPortSendBreak(struct moxa_port *port, int ms100)
-{
-	void __iomem *ofsAddr = port->tableAddr;
-
-	if (ms100) {
-		moxafunc(ofsAddr, FC_SendBreak, Magic_code);
-		msleep(ms100 * 10);
-	} else {
-		moxafunc(ofsAddr, FC_SendBreak, Magic_code);
-		msleep(250);
-	}
-	moxafunc(ofsAddr, FC_StopBreak, Magic_code);
-}
-
 static int moxa_get_serial_info(struct moxa_port *info,
 				struct serial_struct __user *retinfo)
 {
@@ -2474,26 +2412,6 @@ static int moxa_set_serial_info(struct m
 /*****************************************************************************
  *	Static local functions: 					     *
  *****************************************************************************/
-static void moxafunc(void __iomem *ofsAddr, int cmd, ushort arg)
-{
-
-	writew(arg, ofsAddr + FuncArg);
-	writew(cmd, ofsAddr + FuncCode);
-	moxa_wait_finish(ofsAddr);
-}
-
-static void moxa_wait_finish(void __iomem *ofsAddr)
-{
-	unsigned long i, j;
-
-	i = jiffies;
-	while (readw(ofsAddr + FuncCode) != 0) {
-		j = jiffies;
-		if ((j - i) > moxaFuncTout) {
-			return;
-		}
-	}
-}
 
 static void moxa_low_water_check(void __iomem *ofsAddr)
 {
diff -puN drivers/char/moxa.h~char-moxa-ioctl-cleanup drivers/char/moxa.h
--- a/drivers/char/moxa.h~char-moxa-ioctl-cleanup
+++ a/drivers/char/moxa.h
@@ -1,6 +1,14 @@
 #ifndef MOXA_H_FILE
 #define MOXA_H_FILE
 
+#define	MOXA		0x400
+#define MOXA_GET_IQUEUE 	(MOXA + 1)	/* get input buffered count */
+#define MOXA_GET_OQUEUE 	(MOXA + 2)	/* get output buffered count */
+#define MOXA_GETDATACOUNT       (MOXA + 23)
+#define MOXA_GET_IOQUEUE	(MOXA + 27)
+#define MOXA_FLUSH_QUEUE	(MOXA + 28)
+#define MOXA_GETMSTATUS         (MOXA + 65)
+
 /*
  *    System Configuration
  */
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

