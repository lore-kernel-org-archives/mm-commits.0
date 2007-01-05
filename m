From: akpm@osdl.org
Subject: + char-moxa-variables-cleanup.patch added to -mm tree
Date: Fri, 05 Jan 2007 12:09:54 -0800
Message-ID: <200701052009.l05K9sh0031002@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56864 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbXAEUKA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 5 Jan 2007 15:10:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: moxa, variables cleanup
has been added to the -mm tree.  Its filename is
     char-moxa-variables-cleanup.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: moxa, variables cleanup
From: Jiri Slaby <jirislaby@gmail.com>

- rename moxaChannels to moxa_port
- rename moxa_str to moxa_ports
- move board global variables into moxa_board
- move port global variables into moxa_port

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/moxa.c |  398 ++++++++++++++++++++++--------------------
 1 files changed, 210 insertions(+), 188 deletions(-)

diff -puN drivers/char/moxa.c~char-moxa-variables-cleanup drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-variables-cleanup
+++ a/drivers/char/moxa.c
@@ -102,19 +102,35 @@ static struct moxa_isa_board_conf moxa_i
 /*       {MOXA_BOARD_C218_ISA,8,0xDC000}, */
 };
 
-struct moxa_board_conf {
+static struct moxa_board_conf {
 	int boardType;
 	int numPorts;
 	unsigned long baseAddr;
 	int busType;
 	struct pci_dev *pdev;
+
+	int loadstat;
+
+	void __iomem *basemem;
+	void __iomem *intNdx;
+	void __iomem *intPend;
+	void __iomem *intTable;
+} moxa_boards[MAX_BOARDS];
+
+struct mxser_mstatus {
+	tcflag_t cflag;
+	int cts;
+	int dsr;
+	int ri;
+	int dcd;
 };
 
-static struct moxa_board_conf moxa_boards[MAX_BOARDS];
-static void __iomem *moxaBaseAddr[MAX_BOARDS];
-static int loadstat[MAX_BOARDS];
+struct moxaq_str {
+	int inq;
+	int outq;
+};
 
-struct moxa_str {
+struct moxa_port {
 	int type;
 	int port;
 	int close_delay;
@@ -128,17 +144,20 @@ struct moxa_str {
 	int cflag;
 	wait_queue_head_t open_wait;
 	wait_queue_head_t close_wait;
-};
 
-struct mxser_mstatus {
-	tcflag_t cflag;
-	int cts;
-	int dsr;
-	int ri;
-	int dcd;
-};
+	struct timer_list emptyTimer;
+	struct mxser_mstatus GMStatus;
+	struct moxaq_str temp_queue;
+
+	char chkPort;
+	char lineCtrl;
+	void __iomem *tableAddr;
+	long curBaud;
+	char DCDState;
+	char lowChkFlag;
 
-static struct mxser_mstatus GMStatus[MAX_PORTS];
+	ushort breakCnt;
+};
 
 /* statusflags */
 #define TXSTOPPED	0x1
@@ -194,11 +213,11 @@ static int moxa_tiocmset(struct tty_stru
 static void moxa_poll(unsigned long);
 static void set_tty_param(struct tty_struct *);
 static int block_till_ready(struct tty_struct *, struct file *,
-			    struct moxa_str *);
+			    struct moxa_port *);
 static void setup_empty_event(struct tty_struct *);
 static void check_xmit_empty(unsigned long);
-static void shut_down(struct moxa_str *);
-static void receive_data(struct moxa_str *);
+static void shut_down(struct moxa_port *);
+static void receive_data(struct moxa_port *);
 /*
  * moxa board interface functions:
  */
@@ -228,8 +247,8 @@ static void MoxaPortTxDisable(int);
 static void MoxaPortTxEnable(int);
 static int MoxaPortResetBrkCnt(int);
 static void MoxaPortSendBreak(int, int);
-static int moxa_get_serial_info(struct moxa_str *, struct serial_struct __user *);
-static int moxa_set_serial_info(struct moxa_str *, struct serial_struct __user *);
+static int moxa_get_serial_info(struct moxa_port *, struct serial_struct __user *);
+static int moxa_set_serial_info(struct moxa_port *, struct serial_struct __user *);
 static void MoxaSetFifo(int port, int enable);
 
 static const struct tty_operations moxa_ops = {
@@ -253,9 +272,8 @@ static const struct tty_operations moxa_
 };
 
 static struct tty_driver *moxaDriver;
-static struct moxa_str moxaChannels[MAX_PORTS];
+static struct moxa_port moxa_ports[MAX_PORTS];
 static DEFINE_TIMER(moxaTimer, moxa_poll, 0, 0);
-static struct timer_list moxaEmptyTimer[MAX_PORTS];
 static DEFINE_SPINLOCK(moxa_lock);
 
 #ifdef CONFIG_PCI
@@ -288,7 +306,7 @@ static int moxa_get_PCI_conf(struct pci_
 static int __init moxa_init(void)
 {
 	int i, numBoards;
-	struct moxa_str *ch;
+	struct moxa_port *ch;
 
 	printk(KERN_INFO "MOXA Intellio family driver version %s\n", MOXA_VERSION);
 	moxaDriver = alloc_tty_driver(MAX_PORTS + 1);
@@ -308,7 +326,7 @@ static int __init moxa_init(void)
 	moxaDriver->flags = TTY_DRIVER_REAL_RAW;
 	tty_set_operations(moxaDriver, &moxa_ops);
 
-	for (i = 0, ch = moxaChannels; i < MAX_PORTS; i++, ch++) {
+	for (i = 0, ch = moxa_ports; i < MAX_PORTS; i++, ch++) {
 		ch->type = PORT_16550A;
 		ch->port = i;
 		ch->close_delay = 5 * HZ / 10;
@@ -316,6 +334,9 @@ static int __init moxa_init(void)
 		ch->cflag = B9600 | CS8 | CREAD | CLOCAL | HUPCL;
 		init_waitqueue_head(&ch->open_wait);
 		init_waitqueue_head(&ch->close_wait);
+
+		setup_timer(&ch->emptyTimer, check_xmit_empty,
+				(unsigned long)ch);
 	}
 
 	printk("Tty devices major number = %d\n", ttymajor);
@@ -325,9 +346,6 @@ static int __init moxa_init(void)
 		put_tty_driver(moxaDriver);
 		return -1;
 	}
-	for (i = 0; i < MAX_PORTS; i++)
-		setup_timer(&moxaEmptyTimer[i], check_xmit_empty,
-				(unsigned long)&moxaChannels[i]);
 
 	mod_timer(&moxaTimer, jiffies + HZ / 50);
 
@@ -402,7 +420,8 @@ static int __init moxa_init(void)
 	}
 #endif
 	for (i = 0; i < numBoards; i++) {
-		moxaBaseAddr[i] = ioremap((unsigned long) moxa_boards[i].baseAddr, 0x4000);
+		moxa_boards[i].basemem = ioremap(moxa_boards[i].baseAddr,
+				0x4000);
 	}
 
 	return (0);
@@ -418,15 +437,15 @@ static void __exit moxa_exit(void)
 	del_timer_sync(&moxaTimer);
 
 	for (i = 0; i < MAX_PORTS; i++)
-		del_timer_sync(&moxaEmptyTimer[i]);
+		del_timer_sync(&moxa_ports[i].emptyTimer);
 
 	if (tty_unregister_driver(moxaDriver))
 		printk("Couldn't unregister MOXA Intellio family serial driver\n");
 	put_tty_driver(moxaDriver);
 
 	for (i = 0; i < MAX_BOARDS; i++) {
-		if (moxaBaseAddr[i])
-			iounmap(moxaBaseAddr[i]);
+		if (moxa_boards[i].basemem)
+			iounmap(moxa_boards[i].basemem);
 		if (moxa_boards[i].busType == MOXA_BUS_TYPE_PCI)
 			pci_dev_put(moxa_boards[i].pdev);
 	}
@@ -440,7 +459,7 @@ module_exit(moxa_exit);
 
 static int moxa_open(struct tty_struct *tty, struct file *filp)
 {
-	struct moxa_str *ch;
+	struct moxa_port *ch;
 	int port;
 	int retval;
 
@@ -453,7 +472,7 @@ static int moxa_open(struct tty_struct *
 		return (-ENODEV);
 	}
 
-	ch = &moxaChannels[port];
+	ch = &moxa_ports[port];
 	ch->count++;
 	tty->driver_data = ch;
 	ch->tty = tty;
@@ -479,7 +498,7 @@ static int moxa_open(struct tty_struct *
 
 static void moxa_close(struct tty_struct *tty, struct file *filp)
 {
-	struct moxa_str *ch;
+	struct moxa_port *ch;
 	int port;
 
 	port = tty->index;
@@ -499,7 +518,7 @@ static void moxa_close(struct tty_struct
 	if (tty_hung_up_p(filp)) {
 		return;
 	}
-	ch = (struct moxa_str *) tty->driver_data;
+	ch = (struct moxa_port *) tty->driver_data;
 
 	if ((tty->count == 1) && (ch->count != 1)) {
 		printk("moxa_close: bad serial port count; tty->count is 1, "
@@ -520,7 +539,7 @@ static void moxa_close(struct tty_struct
 	if (ch->asyncflags & ASYNC_INITIALIZED) {
 		setup_empty_event(tty);
 		tty_wait_until_sent(tty, 30 * HZ);	/* 30 seconds timeout */
-		del_timer_sync(&moxaEmptyTimer[ch->port]);
+		del_timer_sync(&moxa_ports[ch->port].emptyTimer);
 	}
 	shut_down(ch);
 	MoxaPortFlushData(port, 2);
@@ -545,11 +564,11 @@ static void moxa_close(struct tty_struct
 static int moxa_write(struct tty_struct *tty,
 		      const unsigned char *buf, int count)
 {
-	struct moxa_str *ch;
+	struct moxa_port *ch;
 	int len, port;
 	unsigned long flags;
 
-	ch = (struct moxa_str *) tty->driver_data;
+	ch = (struct moxa_port *) tty->driver_data;
 	if (ch == NULL)
 		return (0);
 	port = ch->port;
@@ -568,11 +587,11 @@ static int moxa_write(struct tty_struct 
 
 static int moxa_write_room(struct tty_struct *tty)
 {
-	struct moxa_str *ch;
+	struct moxa_port *ch;
 
 	if (tty->stopped)
 		return (0);
-	ch = (struct moxa_str *) tty->driver_data;
+	ch = (struct moxa_port *) tty->driver_data;
 	if (ch == NULL)
 		return (0);
 	return (MoxaPortTxFree(ch->port));
@@ -580,7 +599,7 @@ static int moxa_write_room(struct tty_st
 
 static void moxa_flush_buffer(struct tty_struct *tty)
 {
-	struct moxa_str *ch = (struct moxa_str *) tty->driver_data;
+	struct moxa_port *ch = (struct moxa_port *) tty->driver_data;
 
 	if (ch == NULL)
 		return;
@@ -591,7 +610,7 @@ static void moxa_flush_buffer(struct tty
 static int moxa_chars_in_buffer(struct tty_struct *tty)
 {
 	int chars;
-	struct moxa_str *ch = (struct moxa_str *) tty->driver_data;
+	struct moxa_port *ch = (struct moxa_port *) tty->driver_data;
 
 	/*
 	 * Sigh...I have to check if driver_data is NULL here, because
@@ -623,11 +642,11 @@ static void moxa_flush_chars(struct tty_
 
 static void moxa_put_char(struct tty_struct *tty, unsigned char c)
 {
-	struct moxa_str *ch;
+	struct moxa_port *ch;
 	int port;
 	unsigned long flags;
 
-	ch = (struct moxa_str *) tty->driver_data;
+	ch = (struct moxa_port *) tty->driver_data;
 	if (ch == NULL)
 		return;
 	port = ch->port;
@@ -642,7 +661,7 @@ static void moxa_put_char(struct tty_str
 
 static int moxa_tiocmget(struct tty_struct *tty, struct file *file)
 {
-	struct moxa_str *ch = (struct moxa_str *) tty->driver_data;
+	struct moxa_port *ch = (struct moxa_port *) tty->driver_data;
 	int port;
 	int flag = 0, dtr, rts;
 
@@ -668,7 +687,7 @@ static int moxa_tiocmget(struct tty_stru
 static int moxa_tiocmset(struct tty_struct *tty, struct file *file,
 			 unsigned int set, unsigned int clear)
 {
-	struct moxa_str *ch = (struct moxa_str *) tty->driver_data;
+	struct moxa_port *ch = (struct moxa_port *) tty->driver_data;
 	int port;
 	int dtr, rts;
 
@@ -692,7 +711,7 @@ static int moxa_tiocmset(struct tty_stru
 static int moxa_ioctl(struct tty_struct *tty, struct file *file,
 		      unsigned int cmd, unsigned long arg)
 {
-	struct moxa_str *ch = (struct moxa_str *) tty->driver_data;
+	struct moxa_port *ch = (struct moxa_port *) tty->driver_data;
 	register int port;
 	void __user *argp = (void __user *)arg;
 	int retval;
@@ -745,14 +764,14 @@ static int moxa_ioctl(struct tty_struct 
 
 static void moxa_throttle(struct tty_struct *tty)
 {
-	struct moxa_str *ch = (struct moxa_str *) tty->driver_data;
+	struct moxa_port *ch = (struct moxa_port *) tty->driver_data;
 
 	ch->statusflags |= THROTTLE;
 }
 
 static void moxa_unthrottle(struct tty_struct *tty)
 {
-	struct moxa_str *ch = (struct moxa_str *) tty->driver_data;
+	struct moxa_port *ch = (struct moxa_port *) tty->driver_data;
 
 	ch->statusflags &= ~THROTTLE;
 }
@@ -760,7 +779,7 @@ static void moxa_unthrottle(struct tty_s
 static void moxa_set_termios(struct tty_struct *tty,
 			     struct ktermios *old_termios)
 {
-	struct moxa_str *ch = (struct moxa_str *) tty->driver_data;
+	struct moxa_port *ch = (struct moxa_port *) tty->driver_data;
 
 	if (ch == NULL)
 		return;
@@ -772,7 +791,7 @@ static void moxa_set_termios(struct tty_
 
 static void moxa_stop(struct tty_struct *tty)
 {
-	struct moxa_str *ch = (struct moxa_str *) tty->driver_data;
+	struct moxa_port *ch = (struct moxa_port *) tty->driver_data;
 
 	if (ch == NULL)
 		return;
@@ -783,7 +802,7 @@ static void moxa_stop(struct tty_struct 
 
 static void moxa_start(struct tty_struct *tty)
 {
-	struct moxa_str *ch = (struct moxa_str *) tty->driver_data;
+	struct moxa_port *ch = (struct moxa_port *) tty->driver_data;
 
 	if (ch == NULL)
 		return;
@@ -797,7 +816,7 @@ static void moxa_start(struct tty_struct
 
 static void moxa_hangup(struct tty_struct *tty)
 {
-	struct moxa_str *ch = (struct moxa_str *) tty->driver_data;
+	struct moxa_port *ch = (struct moxa_port *) tty->driver_data;
 
 	moxa_flush_buffer(tty);
 	shut_down(ch);
@@ -811,7 +830,7 @@ static void moxa_hangup(struct tty_struc
 static void moxa_poll(unsigned long ignored)
 {
 	register int card;
-	struct moxa_str *ch;
+	struct moxa_port *ch;
 	struct tty_struct *tp;
 	int i, ports;
 
@@ -824,7 +843,7 @@ static void moxa_poll(unsigned long igno
 	for (card = 0; card < MAX_BOARDS; card++) {
 		if ((ports = MoxaPortsOfCard(card)) <= 0)
 			continue;
-		ch = &moxaChannels[card * MAX_PORTS_PER_BOARD];
+		ch = &moxa_ports[card * MAX_PORTS_PER_BOARD];
 		for (i = 0; i < ports; i++, ch++) {
 			if ((ch->asyncflags & ASYNC_INITIALIZED) == 0)
 				continue;
@@ -867,10 +886,10 @@ static void moxa_poll(unsigned long igno
 static void set_tty_param(struct tty_struct *tty)
 {
 	register struct ktermios *ts;
-	struct moxa_str *ch;
+	struct moxa_port *ch;
 	int rts, cts, txflow, rxflow, xany;
 
-	ch = (struct moxa_str *) tty->driver_data;
+	ch = (struct moxa_port *) tty->driver_data;
 	ts = tty->termios;
 	if (ts->c_cflag & CLOCAL)
 		ch->asyncflags &= ~ASYNC_CHECK_CD;
@@ -890,7 +909,7 @@ static void set_tty_param(struct tty_str
 }
 
 static int block_till_ready(struct tty_struct *tty, struct file *filp,
-			    struct moxa_str *ch)
+			    struct moxa_port *ch)
 {
 	DECLARE_WAITQUEUE(wait,current);
 	unsigned long flags;
@@ -981,33 +1000,33 @@ static int block_till_ready(struct tty_s
 
 static void setup_empty_event(struct tty_struct *tty)
 {
-	struct moxa_str *ch = tty->driver_data;
+	struct moxa_port *ch = tty->driver_data;
 	unsigned long flags;
 
 	spin_lock_irqsave(&moxa_lock, flags);
 	ch->statusflags |= EMPTYWAIT;
-	mod_timer(&moxaEmptyTimer[ch->port], jiffies + HZ);
+	mod_timer(&moxa_ports[ch->port].emptyTimer, jiffies + HZ);
 	spin_unlock_irqrestore(&moxa_lock, flags);
 }
 
 static void check_xmit_empty(unsigned long data)
 {
-	struct moxa_str *ch;
+	struct moxa_port *ch;
 
-	ch = (struct moxa_str *) data;
-	del_timer_sync(&moxaEmptyTimer[ch->port]);
+	ch = (struct moxa_port *) data;
+	del_timer_sync(&moxa_ports[ch->port].emptyTimer);
 	if (ch->tty && (ch->statusflags & EMPTYWAIT)) {
 		if (MoxaPortTxQueue(ch->port) == 0) {
 			ch->statusflags &= ~EMPTYWAIT;
 			tty_wakeup(ch->tty);
 			return;
 		}
-		mod_timer(&moxaEmptyTimer[ch->port], jiffies + HZ);
+		mod_timer(&moxa_ports[ch->port].emptyTimer, jiffies + HZ);
 	} else
 		ch->statusflags &= ~EMPTYWAIT;
 }
 
-static void shut_down(struct moxa_str *ch)
+static void shut_down(struct moxa_port *ch)
 {
 	struct tty_struct *tp;
 
@@ -1027,7 +1046,7 @@ static void shut_down(struct moxa_str *c
 	ch->asyncflags &= ~ASYNC_INITIALIZED;
 }
 
-static void receive_data(struct moxa_str *ch)
+static void receive_data(struct moxa_port *ch)
 {
 	struct tty_struct *tp;
 	struct ktermios *ts;
@@ -1355,20 +1374,10 @@ struct mon_str {
 #define 	DCD_oldstate	0x80
 
 static unsigned char moxaBuff[10240];
-static void __iomem *moxaIntNdx[MAX_BOARDS];
-static void __iomem *moxaIntPend[MAX_BOARDS];
-static void __iomem *moxaIntTable[MAX_BOARDS];
-static char moxaChkPort[MAX_PORTS];
-static char moxaLineCtrl[MAX_PORTS];
-static void __iomem *moxaTableAddr[MAX_PORTS];
-static long moxaCurBaud[MAX_PORTS];
-static char moxaDCDState[MAX_PORTS];
-static char moxaLowChkFlag[MAX_PORTS];
 static int moxaLowWaterChk;
 static int moxaCard;
 static struct mon_str moxaLog;
 static int moxaFuncTout = HZ / 2;
-static ushort moxaBreakCnt[MAX_PORTS];
 
 static void moxadelay(int);
 static void moxafunc(void __iomem *, int, ushort);
@@ -1389,16 +1398,18 @@ static int moxaloadc320(int, void __iome
  *****************************************************************************/
 void MoxaDriverInit(void)
 {
-	int i;
+	struct moxa_port *p;
+	unsigned int i;
 
 	moxaFuncTout = HZ / 2;	/* 500 mini-seconds */
 	moxaCard = 0;
 	moxaLog.tick = 0;
 	moxaLowWaterChk = 0;
 	for (i = 0; i < MAX_PORTS; i++) {
-		moxaChkPort[i] = 0;
-		moxaLowChkFlag[i] = 0;
-		moxaLineCtrl[i] = 0;
+		p = &moxa_ports[i];
+		p->chkPort = 0;
+		p->lowChkFlag = 0;
+		p->lineCtrl = 0;
 		moxaLog.rxcnt[i] = 0;
 		moxaLog.txcnt[i] = 0;
 	}
@@ -1420,19 +1431,12 @@ void MoxaDriverInit(void)
 #define MOXA_GET_CUMAJOR        (MOXA + 64)
 #define MOXA_GETMSTATUS         (MOXA + 65)
 
-
-struct moxaq_str {
-	int inq;
-	int outq;
-};
-
 struct dl_str {
 	char __user *buf;
 	int len;
 	int cardno;
 };
 
-static struct moxaq_str temp_queue[MAX_PORTS];
 static struct dl_str dltmp;
 
 void MoxaPortFlushData(int port, int mode)
@@ -1440,10 +1444,10 @@ void MoxaPortFlushData(int port, int mod
 	void __iomem *ofsAddr;
 	if ((mode < 0) || (mode > 2))
 		return;
-	ofsAddr = moxaTableAddr[port];
+	ofsAddr = moxa_ports[port].tableAddr;
 	moxafunc(ofsAddr, FC_FlushQueue, mode);
 	if (mode != 1) {
-		moxaLowChkFlag[port] = 0;
+		moxa_ports[port].lowChkFlag = 0;
 		low_water_check(ofsAddr);
 	}
 }
@@ -1481,17 +1485,23 @@ int MoxaDriverIoctl(unsigned int cmd, un
 	case MOXA_FLUSH_QUEUE:
 		MoxaPortFlushData(port, arg);
 		return (0);
-	case MOXA_GET_IOQUEUE:
-		for (i = 0; i < MAX_PORTS; i++) {
-			if (moxaChkPort[i]) {
-				temp_queue[i].inq = MoxaPortRxQueue(i);
-				temp_queue[i].outq = MoxaPortTxQueue(i);
+	case MOXA_GET_IOQUEUE: {
+		struct moxaq_str __user *argm = argp;
+		struct moxa_port *p;
+
+		for (i = 0; i < MAX_PORTS; i++, argm++) {
+			p = &moxa_ports[i];
+			memset(&p->temp_queue, 0, sizeof(p->temp_queue));
+			if (p->chkPort) {
+				p->temp_queue.inq = MoxaPortRxQueue(i);
+				p->temp_queue.outq = MoxaPortTxQueue(i);
 			}
+			if (copy_to_user(argm, &p->temp_queue,
+						sizeof(p->temp_queue)))
+				return -EFAULT;
 		}
-		if(copy_to_user(argp, temp_queue, sizeof(struct moxaq_str) * MAX_PORTS))
-			return -EFAULT;
 		return (0);
-	case MOXA_GET_OQUEUE:
+	} case MOXA_GET_OQUEUE:
 		i = MoxaPortTxQueue(port);
 		return put_user(i, (unsigned long __user *)argp);
 	case MOXA_GET_IQUEUE:
@@ -1506,33 +1516,39 @@ int MoxaDriverIoctl(unsigned int cmd, un
 		if(copy_to_user(argp, &i, sizeof(int)))
 			return -EFAULT;
 		return 0;
-	case MOXA_GETMSTATUS:
-		for (i = 0; i < MAX_PORTS; i++) {
-			GMStatus[i].ri = 0;
-			GMStatus[i].dcd = 0;
-			GMStatus[i].dsr = 0;
-			GMStatus[i].cts = 0;
-			if (!moxaChkPort[i]) {
-				continue;
+	case MOXA_GETMSTATUS: {
+		struct mxser_mstatus __user *argm = argp;
+		struct moxa_port *p;
+
+		for (i = 0; i < MAX_PORTS; i++, argm++) {
+			p = &moxa_ports[i];
+			p->GMStatus.ri = 0;
+			p->GMStatus.dcd = 0;
+			p->GMStatus.dsr = 0;
+			p->GMStatus.cts = 0;
+			if (!p->chkPort) {
+				goto copy;
 			} else {
-				status = MoxaPortLineStatus(moxaChannels[i].port);
+				status = MoxaPortLineStatus(p->port);
 				if (status & 1)
-					GMStatus[i].cts = 1;
+					p->GMStatus.cts = 1;
 				if (status & 2)
-					GMStatus[i].dsr = 1;
+					p->GMStatus.dsr = 1;
 				if (status & 4)
-					GMStatus[i].dcd = 1;
+					p->GMStatus.dcd = 1;
 			}
 
-			if (!moxaChannels[i].tty || !moxaChannels[i].tty->termios)
-				GMStatus[i].cflag = moxaChannels[i].cflag;
+			if (!p->tty || !p->tty->termios)
+				p->GMStatus.cflag = p->cflag;
 			else
-				GMStatus[i].cflag = moxaChannels[i].tty->termios->c_cflag;
+				p->GMStatus.cflag = p->tty->termios->c_cflag;
+copy:
+			if (copy_to_user(argm, &p->GMStatus,
+						sizeof(p->GMStatus)))
+				return -EFAULT;
 		}
-		if(copy_to_user(argp, GMStatus, sizeof(struct mxser_mstatus) * MAX_PORTS))
-			return -EFAULT;
 		return 0;
-	default:
+	} default:
 		return (-ENOIOCTLCMD);
 	case MOXA_LOAD_BIOS:
 	case MOXA_FIND_BOARD:
@@ -1570,6 +1586,7 @@ int MoxaDriverIoctl(unsigned int cmd, un
 
 int MoxaDriverPoll(void)
 {
+	struct moxa_board_conf *brd;
 	register ushort temp;
 	register int card;
 	void __iomem *ofsAddr;
@@ -1579,43 +1596,44 @@ int MoxaDriverPoll(void)
 	if (moxaCard == 0)
 		return (-1);
 	for (card = 0; card < MAX_BOARDS; card++) {
-	        if (loadstat[card] == 0)
+		brd = &moxa_boards[card];
+	        if (brd->loadstat == 0)
 			continue;
-		if ((ports = moxa_boards[card].numPorts) == 0)
+		if ((ports = brd->numPorts) == 0)
 			continue;
-		if (readb(moxaIntPend[card]) == 0xff) {
-			ip = moxaIntTable[card] + readb(moxaIntNdx[card]);
+		if (readb(brd->intPend) == 0xff) {
+			ip = brd->intTable + readb(brd->intNdx);
 			p = card * MAX_PORTS_PER_BOARD;
 			ports <<= 1;
 			for (port = 0; port < ports; port += 2, p++) {
 				if ((temp = readw(ip + port)) != 0) {
 					writew(0, ip + port);
-					ofsAddr = moxaTableAddr[p];
+					ofsAddr = moxa_ports[p].tableAddr;
 					if (temp & IntrTx)
 						writew(readw(ofsAddr + HostStat) & ~WakeupTx, ofsAddr + HostStat);
 					if (temp & IntrBreak) {
-						moxaBreakCnt[p]++;
+						moxa_ports[p].breakCnt++;
 					}
 					if (temp & IntrLine) {
 						if (readb(ofsAddr + FlagStat) & DCD_state) {
-							if ((moxaDCDState[p] & DCD_oldstate) == 0)
-								moxaDCDState[p] = (DCD_oldstate |
+							if ((moxa_ports[p].DCDState & DCD_oldstate) == 0)
+								moxa_ports[p].DCDState = (DCD_oldstate |
 										   DCD_changed);
 						} else {
-							if (moxaDCDState[p] & DCD_oldstate)
-								moxaDCDState[p] = DCD_changed;
+							if (moxa_ports[p].DCDState & DCD_oldstate)
+								moxa_ports[p].DCDState = DCD_changed;
 						}
 					}
 				}
 			}
-			writeb(0, moxaIntPend[card]);
+			writeb(0, brd->intPend);
 		}
 		if (moxaLowWaterChk) {
 			p = card * MAX_PORTS_PER_BOARD;
 			for (port = 0; port < ports; port++, p++) {
-				if (moxaLowChkFlag[p]) {
-					moxaLowChkFlag[p] = 0;
-					ofsAddr = moxaTableAddr[p];
+				if (moxa_ports[p].lowChkFlag) {
+					moxa_ports[p].lowChkFlag = 0;
+					ofsAddr = moxa_ports[p].tableAddr;
 					low_water_check(ofsAddr);
 				}
 			}
@@ -1921,7 +1939,7 @@ int MoxaPortIsValid(int port)
 
 	if (moxaCard == 0)
 		return (0);
-	if (moxaChkPort[port] == 0)
+	if (moxa_ports[port].chkPort == 0)
 		return (0);
 	return (1);
 }
@@ -1932,9 +1950,9 @@ void MoxaPortEnable(int port)
 	int MoxaPortLineStatus(int);
 	short lowwater = 512;
 
-	ofsAddr = moxaTableAddr[port];
+	ofsAddr = moxa_ports[port].tableAddr;
 	writew(lowwater, ofsAddr + Low_water);
-	moxaBreakCnt[port] = 0;
+	moxa_ports[port].breakCnt = 0;
 	if ((moxa_boards[port / MAX_PORTS_PER_BOARD].boardType == MOXA_BOARD_C320_ISA) ||
 	    (moxa_boards[port / MAX_PORTS_PER_BOARD].boardType == MOXA_BOARD_C320_PCI)) {
 		moxafunc(ofsAddr, FC_SetBreakIrq, 0);
@@ -1951,7 +1969,7 @@ void MoxaPortEnable(int port)
 
 void MoxaPortDisable(int port)
 {
-	void __iomem *ofsAddr = moxaTableAddr[port];
+	void __iomem *ofsAddr = moxa_ports[port].tableAddr;
 
 	moxafunc(ofsAddr, FC_SetFlowCtl, 0);	/* disable flow control */
 	moxafunc(ofsAddr, FC_ClrLineIrq, Magic_code);
@@ -1977,7 +1995,7 @@ long MoxaPortSetBaud(int port, long baud
 
 	if ((baud < 50L) || ((max = MoxaPortGetMaxBaud(port)) == 0))
 		return (0);
-	ofsAddr = moxaTableAddr[port];
+	ofsAddr = moxa_ports[port].tableAddr;
 	if (baud > max)
 		baud = max;
 	if (max == 38400L)
@@ -1989,7 +2007,7 @@ long MoxaPortSetBaud(int port, long baud
 	val = clock / baud;
 	moxafunc(ofsAddr, FC_SetBaud, val);
 	baud = clock / val;
-	moxaCurBaud[port] = baud;
+	moxa_ports[port].curBaud = baud;
 	return (baud);
 }
 
@@ -1999,9 +2017,9 @@ int MoxaPortSetTermio(int port, struct k
 	tcflag_t cflag;
 	tcflag_t mode = 0;
 
-	if (moxaChkPort[port] == 0 || termio == 0)
+	if (moxa_ports[port].chkPort == 0 || termio == 0)
 		return (-1);
-	ofsAddr = moxaTableAddr[port];
+	ofsAddr = moxa_ports[port].tableAddr;
 	cflag = termio->c_cflag;	/* termio->c_cflag */
 
 	mode = termio->c_cflag & CSIZE;
@@ -2055,13 +2073,13 @@ int MoxaPortGetLineOut(int port, int *dt
 	if (!MoxaPortIsValid(port))
 		return (-1);
 	if (dtrState) {
-		if (moxaLineCtrl[port] & DTR_ON)
+		if (moxa_ports[port].lineCtrl & DTR_ON)
 			*dtrState = 1;
 		else
 			*dtrState = 0;
 	}
 	if (rtsState) {
-		if (moxaLineCtrl[port] & RTS_ON)
+		if (moxa_ports[port].lineCtrl & RTS_ON)
 			*rtsState = 1;
 		else
 			*rtsState = 0;
@@ -2074,13 +2092,13 @@ void MoxaPortLineCtrl(int port, int dtr,
 	void __iomem *ofsAddr;
 	int mode;
 
-	ofsAddr = moxaTableAddr[port];
+	ofsAddr = moxa_ports[port].tableAddr;
 	mode = 0;
 	if (dtr)
 		mode |= DTR_ON;
 	if (rts)
 		mode |= RTS_ON;
-	moxaLineCtrl[port] = mode;
+	moxa_ports[port].lineCtrl = mode;
 	moxafunc(ofsAddr, FC_LineControl, mode);
 }
 
@@ -2089,7 +2107,7 @@ void MoxaPortFlowCtrl(int port, int rts,
 	void __iomem *ofsAddr;
 	int mode;
 
-	ofsAddr = moxaTableAddr[port];
+	ofsAddr = moxa_ports[port].tableAddr;
 	mode = 0;
 	if (rts)
 		mode |= RTS_FlowCtl;
@@ -2109,7 +2127,7 @@ int MoxaPortLineStatus(int port)
 	void __iomem *ofsAddr;
 	int val;
 
-	ofsAddr = moxaTableAddr[port];
+	ofsAddr = moxa_ports[port].tableAddr;
 	if ((moxa_boards[port / MAX_PORTS_PER_BOARD].boardType == MOXA_BOARD_C320_ISA) ||
 	    (moxa_boards[port / MAX_PORTS_PER_BOARD].boardType == MOXA_BOARD_C320_PCI)) {
 		moxafunc(ofsAddr, FC_LineStatus, 0);
@@ -2120,11 +2138,11 @@ int MoxaPortLineStatus(int port)
 	val &= 0x0B;
 	if (val & 8) {
 		val |= 4;
-		if ((moxaDCDState[port] & DCD_oldstate) == 0)
-			moxaDCDState[port] = (DCD_oldstate | DCD_changed);
+		if ((moxa_ports[port].DCDState & DCD_oldstate) == 0)
+			moxa_ports[port].DCDState = (DCD_oldstate | DCD_changed);
 	} else {
-		if (moxaDCDState[port] & DCD_oldstate)
-			moxaDCDState[port] = DCD_changed;
+		if (moxa_ports[port].DCDState & DCD_oldstate)
+			moxa_ports[port].DCDState = DCD_changed;
 	}
 	val &= 7;
 	return (val);
@@ -2134,10 +2152,10 @@ int MoxaPortDCDChange(int port)
 {
 	int n;
 
-	if (moxaChkPort[port] == 0)
+	if (moxa_ports[port].chkPort == 0)
 		return (0);
-	n = moxaDCDState[port];
-	moxaDCDState[port] &= ~DCD_changed;
+	n = moxa_ports[port].DCDState;
+	moxa_ports[port].DCDState &= ~DCD_changed;
 	n &= DCD_changed;
 	return (n);
 }
@@ -2146,9 +2164,9 @@ int MoxaPortDCDON(int port)
 {
 	int n;
 
-	if (moxaChkPort[port] == 0)
+	if (moxa_ports[port].chkPort == 0)
 		return (0);
-	if (moxaDCDState[port] & DCD_oldstate)
+	if (moxa_ports[port].DCDState & DCD_oldstate)
 		n = 1;
 	else
 		n = 0;
@@ -2164,8 +2182,8 @@ int MoxaPortWriteData(int port, unsigned
 	ushort pageno, pageofs, bufhead;
 	void __iomem *baseAddr, *ofsAddr, *ofs;
 
-	ofsAddr = moxaTableAddr[port];
-	baseAddr = moxaBaseAddr[port / MAX_PORTS_PER_BOARD];
+	ofsAddr = moxa_ports[port].tableAddr;
+	baseAddr = moxa_boards[port / MAX_PORTS_PER_BOARD].basemem;
 	tx_mask = readw(ofsAddr + TX_mask);
 	spage = readw(ofsAddr + Page_txb);
 	epage = readw(ofsAddr + EndPage_txb);
@@ -2227,8 +2245,8 @@ int MoxaPortReadData(int port, struct tt
 	ushort pageno, bufhead;
 	void __iomem *baseAddr, *ofsAddr, *ofs;
 
-	ofsAddr = moxaTableAddr[port];
-	baseAddr = moxaBaseAddr[port / MAX_PORTS_PER_BOARD];
+	ofsAddr = moxa_ports[port].tableAddr;
+	baseAddr = moxa_boards[port / MAX_PORTS_PER_BOARD].basemem;
 	head = readw(ofsAddr + RXrptr);
 	tail = readw(ofsAddr + RXwptr);
 	rx_mask = readw(ofsAddr + RX_mask);
@@ -2283,7 +2301,7 @@ int MoxaPortReadData(int port, struct tt
 	}
 	if ((readb(ofsAddr + FlagStat) & Xoff_state) && (remain < LowWater)) {
 		moxaLowWaterChk = 1;
-		moxaLowChkFlag[port] = 1;
+		moxa_ports[port].lowChkFlag = 1;
 	}
 	return (total);
 }
@@ -2295,7 +2313,7 @@ int MoxaPortTxQueue(int port)
 	ushort rptr, wptr, mask;
 	int len;
 
-	ofsAddr = moxaTableAddr[port];
+	ofsAddr = moxa_ports[port].tableAddr;
 	rptr = readw(ofsAddr + TXrptr);
 	wptr = readw(ofsAddr + TXwptr);
 	mask = readw(ofsAddr + TX_mask);
@@ -2309,7 +2327,7 @@ int MoxaPortTxFree(int port)
 	ushort rptr, wptr, mask;
 	int len;
 
-	ofsAddr = moxaTableAddr[port];
+	ofsAddr = moxa_ports[port].tableAddr;
 	rptr = readw(ofsAddr + TXrptr);
 	wptr = readw(ofsAddr + TXwptr);
 	mask = readw(ofsAddr + TX_mask);
@@ -2323,7 +2341,7 @@ int MoxaPortRxQueue(int port)
 	ushort rptr, wptr, mask;
 	int len;
 
-	ofsAddr = moxaTableAddr[port];
+	ofsAddr = moxa_ports[port].tableAddr;
 	rptr = readw(ofsAddr + RXrptr);
 	wptr = readw(ofsAddr + RXwptr);
 	mask = readw(ofsAddr + RX_mask);
@@ -2336,7 +2354,7 @@ void MoxaPortTxDisable(int port)
 {
 	void __iomem *ofsAddr;
 
-	ofsAddr = moxaTableAddr[port];
+	ofsAddr = moxa_ports[port].tableAddr;
 	moxafunc(ofsAddr, FC_SetXoffState, Magic_code);
 }
 
@@ -2344,7 +2362,7 @@ void MoxaPortTxEnable(int port)
 {
 	void __iomem *ofsAddr;
 
-	ofsAddr = moxaTableAddr[port];
+	ofsAddr = moxa_ports[port].tableAddr;
 	moxafunc(ofsAddr, FC_SetXonState, Magic_code);
 }
 
@@ -2352,8 +2370,8 @@ void MoxaPortTxEnable(int port)
 int MoxaPortResetBrkCnt(int port)
 {
 	ushort cnt;
-	cnt = moxaBreakCnt[port];
-	moxaBreakCnt[port] = 0;
+	cnt = moxa_ports[port].breakCnt;
+	moxa_ports[port].breakCnt = 0;
 	return (cnt);
 }
 
@@ -2362,7 +2380,7 @@ void MoxaPortSendBreak(int port, int ms1
 {
 	void __iomem *ofsAddr;
 
-	ofsAddr = moxaTableAddr[port];
+	ofsAddr = moxa_ports[port].tableAddr;
 	if (ms100) {
 		moxafunc(ofsAddr, FC_SendBreak, Magic_code);
 		moxadelay(ms100 * (HZ / 10));
@@ -2373,7 +2391,7 @@ void MoxaPortSendBreak(int port, int ms1
 	moxafunc(ofsAddr, FC_StopBreak, Magic_code);
 }
 
-static int moxa_get_serial_info(struct moxa_str *info,
+static int moxa_get_serial_info(struct moxa_port *info,
 				struct serial_struct __user *retinfo)
 {
 	struct serial_struct tmp;
@@ -2395,7 +2413,7 @@ static int moxa_get_serial_info(struct m
 }
 
 
-static int moxa_set_serial_info(struct moxa_str *info,
+static int moxa_set_serial_info(struct moxa_port *info,
 				struct serial_struct __user *new_info)
 {
 	struct serial_struct new_serial;
@@ -2492,7 +2510,7 @@ static int moxaloadbios(int cardno, unsi
 
 	if(copy_from_user(moxaBuff, tmp, len))
 		return -EFAULT;
-	baseAddr = moxaBaseAddr[cardno];
+	baseAddr = moxa_boards[cardno].basemem;
 	writeb(HW_reset, baseAddr + Control_reg);	/* reset */
 	moxadelay(1);		/* delay 10 ms */
 	for (i = 0; i < 4096; i++)
@@ -2508,7 +2526,7 @@ static int moxafindcard(int cardno)
 	void __iomem *baseAddr;
 	ushort tmp;
 
-	baseAddr = moxaBaseAddr[cardno];
+	baseAddr = moxa_boards[cardno].basemem;
 	switch (moxa_boards[cardno].boardType) {
 	case MOXA_BOARD_C218_ISA:
 	case MOXA_BOARD_C218_PCI:
@@ -2541,7 +2559,7 @@ static int moxaload320b(int cardno, unsi
 		return -EINVAL;
 	if(copy_from_user(moxaBuff, tmp, len))
 		return -EFAULT;
-	baseAddr = moxaBaseAddr[cardno];
+	baseAddr = moxa_boards[cardno].basemem;
 	writew(len - 7168 - 2, baseAddr + C320bapi_len);
 	writeb(1, baseAddr + Control_reg);	/* Select Page 1 */
 	for (i = 0; i < 7168; i++)
@@ -2559,7 +2577,7 @@ static int moxaloadcode(int cardno, unsi
 
 	if(copy_from_user(moxaBuff, tmp, len))
 		return -EFAULT;
-	baseAddr = moxaBaseAddr[cardno];
+	baseAddr = moxa_boards[cardno].basemem;
 	switch (moxa_boards[cardno].boardType) {
 	case MOXA_BOARD_C218_ISA:
 	case MOXA_BOARD_C218_PCI:
@@ -2569,11 +2587,13 @@ static int moxaloadcode(int cardno, unsi
 			return (retval);
 		port = cardno * MAX_PORTS_PER_BOARD;
 		for (i = 0; i < moxa_boards[cardno].numPorts; i++, port++) {
-			moxaChkPort[port] = 1;
-			moxaCurBaud[port] = 9600L;
-			moxaDCDState[port] = 0;
-			moxaTableAddr[port] = baseAddr + Extern_table + Extern_size * i;
-			ofsAddr = moxaTableAddr[port];
+			struct moxa_port *p = &moxa_ports[port];
+
+			p->chkPort = 1;
+			p->curBaud = 9600L;
+			p->DCDState = 0;
+			p->tableAddr = baseAddr + Extern_table + Extern_size * i;
+			ofsAddr = p->tableAddr;
 			writew(C218rx_mask, ofsAddr + RX_mask);
 			writew(C218tx_mask, ofsAddr + TX_mask);
 			writew(C218rx_spage + i * C218buf_pageno, ofsAddr + Page_rxb);
@@ -2591,11 +2611,13 @@ static int moxaloadcode(int cardno, unsi
 			return (retval);
 		port = cardno * MAX_PORTS_PER_BOARD;
 		for (i = 0; i < moxa_boards[cardno].numPorts; i++, port++) {
-			moxaChkPort[port] = 1;
-			moxaCurBaud[port] = 9600L;
-			moxaDCDState[port] = 0;
-			moxaTableAddr[port] = baseAddr + Extern_table + Extern_size * i;
-			ofsAddr = moxaTableAddr[port];
+			struct moxa_port *p = &moxa_ports[port];
+
+			p->chkPort = 1;
+			p->curBaud = 9600L;
+			p->DCDState = 0;
+			p->tableAddr = baseAddr + Extern_table + Extern_size * i;
+			ofsAddr = p->tableAddr;
 			if (moxa_boards[cardno].numPorts == 8) {
 				writew(C320p8rx_mask, ofsAddr + RX_mask);
 				writew(C320p8tx_mask, ofsAddr + TX_mask);
@@ -2631,7 +2653,7 @@ static int moxaloadcode(int cardno, unsi
 		}
 		break;
 	}
-	loadstat[cardno] = 1;
+	moxa_boards[cardno].loadstat = 1;
 	return (0);
 }
 
@@ -2705,9 +2727,9 @@ static int moxaloadc218(int cardno, void
 		return (-1);
 	}
 	moxaCard = 1;
-	moxaIntNdx[cardno] = baseAddr + IRQindex;
-	moxaIntPend[cardno] = baseAddr + IRQpending;
-	moxaIntTable[cardno] = baseAddr + IRQtable;
+	moxa_boards[cardno].intNdx = baseAddr + IRQindex;
+	moxa_boards[cardno].intPend = baseAddr + IRQpending;
+	moxa_boards[cardno].intTable = baseAddr + IRQtable;
 	return (0);
 }
 
@@ -2800,15 +2822,15 @@ static int moxaloadc320(int cardno, void
 	if (readw(baseAddr + Magic_no) != Magic_code)
 		return (-102);
 	moxaCard = 1;
-	moxaIntNdx[cardno] = baseAddr + IRQindex;
-	moxaIntPend[cardno] = baseAddr + IRQpending;
-	moxaIntTable[cardno] = baseAddr + IRQtable;
+	moxa_boards[cardno].intNdx = baseAddr + IRQindex;
+	moxa_boards[cardno].intPend = baseAddr + IRQpending;
+	moxa_boards[cardno].intTable = baseAddr + IRQtable;
 	return (0);
 }
 
 static void MoxaSetFifo(int port, int enable)
 {
-	void __iomem *ofsAddr = moxaTableAddr[port];
+	void __iomem *ofsAddr = moxa_ports[port].tableAddr;
 
 	if (!enable) {
 		moxafunc(ofsAddr, FC_SetRxFIFOTrig, 0);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

git-input.patch
char-tty-delete-wake_up_interruptible-after-tty_wakeup.patch
char-isicom-remove-tty_hangwakeup-bottomhalves.patch
mxser-remove-ambiguous-redefinition-of-init_work.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
char-isicom-fix-locking-in-isr.patch
char-isicom-augment-card_reset.patch
char-isicom-check-card-state-in-isr.patch
char-isicom-support-higher-rates.patch
char-isicom-correct-probing-removing.patch
char-tty_wakeup-cleanup.patch
char-mxser_new-mark-init-functions.patch
char-mxser_new-remove-useless-spinlock.patch
char-serial167-cleanup.patch
char-n_r3964-cleanup.patch
char-mxser_new-remove-unused-stuff.patch
char-mxser-obsolete-old-nonexperimental-new.patch
char-mxser_new-remove-tty_wakeup-bottomhalf.patch
char-mxser_new-clean-request_irq-call.patch
doc-isicom-remove-reserved-ioctl-number.patch
char-mxser_new-alter-locking-in-isr.patch
char-mxser_new-header-file-cleanup.patch
char-mxser_new-less-loops-in-isr.patch
char-mxser_new-fix-twice-resource-releasing.patch
char-mxser_new-do-not-put-pdev.patch
char-mxser_new-upgrade-to-1915.patch
char-moxa-remove-unused-allocated-page.patch
char-moxa-do-not-initialize-global-static.patch
char-moxa-timers-cleanup.patch
char-moxa-remove-hangup-bottomhalf.patch
char-moxa-remove-unused-functions.patch
char-moxa-devids-cleanup.patch
char-moxa-use-pci_device.patch
char-moxa-eliminate-typedefs.patch
char-moxa-macros-cleanup.patch
char-moxa-use-del_timer_sync.patch
char-moxa-remove-moxa_pci_devinfo.patch
char-moxa-variables-cleanup.patch
char-moxa-remove-useless-vairables.patch
char-moxa-pci_probing-prepare.patch
char-moxa-pci-probing.patch
shrink_slab-handle-bad-shrinkers.patch
