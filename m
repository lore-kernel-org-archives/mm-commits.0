From: akpm@linux-foundation.org
Subject: - char-moxa-merge-2-poll-functions.patch removed from -mm tree
Date: Thu, 01 May 2008 02:29:16 -0700
Message-ID: <200805010929.m419TGQu030659@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40838 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756319AbYEAJ3V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:29:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, Oyvind.Aabling@uni-c.dk, mm-commits@vger.kernel.org


The patch titled
     Char: moxa, merge 2 poll functions
has been removed from the -mm tree.  Its filename was
     char-moxa-merge-2-poll-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: moxa, merge 2 poll functions
From: Jiri Slaby <jirislaby@gmail.com>

- merge 2 timers into one -- one can handle the emptywait as good as the other
- merge 2 separated poll functions into one, this allows handle the actions
  directly and simplifies the code

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Tested-by: Oyvind Aabling <Oyvind.Aabling@uni-c.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |  421 +++++++++++++-----------------------------
 drivers/char/moxa.h |   10 
 2 files changed, 141 insertions(+), 290 deletions(-)

diff -puN drivers/char/moxa.c~char-moxa-merge-2-poll-functions drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-merge-2-poll-functions
+++ a/drivers/char/moxa.c
@@ -129,25 +129,22 @@ struct moxaq_str {
 
 struct moxa_port {
 	struct moxa_board_conf *board;
+	struct tty_struct *tty;
+	void __iomem *tableAddr;
+
 	int type;
 	int close_delay;
 	int count;
 	int blocked_open;
 	int asyncflags;
-	unsigned long statusflags;
-	struct tty_struct *tty;
 	int cflag;
+	unsigned long statusflags;
 	wait_queue_head_t open_wait;
 	struct completion close_wait;
 
-	struct timer_list emptyTimer;
-
-	char lineCtrl;
-	void __iomem *tableAddr;
-	char DCDState;
-	char lowChkFlag;
-
-	ushort breakCnt;
+	u8 DCDState;
+	u8 lineCtrl;
+	u8 lowChkFlag;
 };
 
 struct mon_str {
@@ -169,6 +166,7 @@ struct mon_str {
 static int ttymajor = MOXAMAJOR;
 static struct mon_str moxaLog;
 static unsigned int moxaFuncTout = HZ / 2;
+static unsigned int moxaLowWaterChk;
 /* Variables for insmod */
 #ifdef MODULE
 static unsigned long baseaddr[MAX_BOARDS];
@@ -214,13 +212,10 @@ static void moxa_set_tty_param(struct tt
 static int moxa_block_till_ready(struct tty_struct *, struct file *,
 			    struct moxa_port *);
 static void moxa_setup_empty_event(struct tty_struct *);
-static void moxa_check_xmit_empty(unsigned long);
 static void moxa_shut_down(struct moxa_port *);
-static void moxa_receive_data(struct moxa_port *);
 /*
  * moxa board interface functions:
  */
-static int MoxaDriverPoll(void);
 static void MoxaPortEnable(struct moxa_port *);
 static void MoxaPortDisable(struct moxa_port *);
 static int MoxaPortSetTermio(struct moxa_port *, struct ktermios *, speed_t);
@@ -228,17 +223,14 @@ static int MoxaPortGetLineOut(struct mox
 static void MoxaPortLineCtrl(struct moxa_port *, int, int);
 static void MoxaPortFlowCtrl(struct moxa_port *, int, int, int, int, int);
 static int MoxaPortLineStatus(struct moxa_port *);
-static int MoxaPortDCDChange(struct moxa_port *);
-static int MoxaPortDCDON(struct moxa_port *);
 static void MoxaPortFlushData(struct moxa_port *, int);
 static int MoxaPortWriteData(struct moxa_port *, unsigned char *, int);
-static int MoxaPortReadData(struct moxa_port *, struct tty_struct *tty);
+static int MoxaPortReadData(struct moxa_port *);
 static int MoxaPortTxQueue(struct moxa_port *);
 static int MoxaPortRxQueue(struct moxa_port *);
 static int MoxaPortTxFree(struct moxa_port *);
 static void MoxaPortTxDisable(struct moxa_port *);
 static void MoxaPortTxEnable(struct moxa_port *);
-static int MoxaPortResetBrkCnt(struct moxa_port *);
 static int moxa_get_serial_info(struct moxa_port *, struct serial_struct __user *);
 static int moxa_set_serial_info(struct moxa_port *, struct serial_struct __user *);
 static void MoxaSetFifo(struct moxa_port *port, int enable);
@@ -265,6 +257,20 @@ static void moxafunc(void __iomem *ofsAd
 	moxa_wait_finish(ofsAddr);
 }
 
+static void moxa_low_water_check(void __iomem *ofsAddr)
+{
+	u16 rptr, wptr, mask, len;
+
+	if (readb(ofsAddr + FlagStat) & Xoff_state) {
+		rptr = readw(ofsAddr + RXrptr);
+		wptr = readw(ofsAddr + RXwptr);
+		mask = readw(ofsAddr + RX_mask);
+		len = (wptr - rptr) & mask;
+		if (len <= Low_water)
+			moxafunc(ofsAddr, FC_SendXon, 0);
+	}
+}
+
 /*
  * TTY operations
  */
@@ -812,9 +818,6 @@ static int moxa_init_board(struct moxa_b
 		p->cflag = B9600 | CS8 | CREAD | CLOCAL | HUPCL;
 		init_waitqueue_head(&p->open_wait);
 		init_completion(&p->close_wait);
-
-		setup_timer(&p->emptyTimer, moxa_check_xmit_empty,
-				(unsigned long)p);
 	}
 
 	switch (brd->boardType) {
@@ -857,12 +860,9 @@ err:
 
 static void moxa_board_deinit(struct moxa_board_conf *brd)
 {
-	unsigned int i;
-
+	spin_lock_bh(&moxa_lock);
 	brd->ready = 0;
-	for (i = 0; i < MAX_PORTS_PER_BOARD; i++)
-		del_timer_sync(&brd->ports[i].emptyTimer);
-
+	spin_unlock_bh(&moxa_lock);
 	iounmap(brd->basemem);
 	brd->basemem = NULL;
 	kfree(brd->ports);
@@ -1135,7 +1135,6 @@ static void moxa_close(struct tty_struct
 	if (ch->asyncflags & ASYNC_INITIALIZED) {
 		moxa_setup_empty_event(tty);
 		tty_wait_until_sent(tty, 30 * HZ);	/* 30 seconds timeout */
-		del_timer_sync(&ch->emptyTimer);
 	}
 	moxa_shut_down(ch);
 	MoxaPortFlushData(ch, 2);
@@ -1160,15 +1159,14 @@ static int moxa_write(struct tty_struct 
 		      const unsigned char *buf, int count)
 {
 	struct moxa_port *ch = tty->driver_data;
-	unsigned long flags;
 	int len;
 
 	if (ch == NULL)
 		return 0;
 
-	spin_lock_irqsave(&moxa_lock, flags);
+	spin_lock_bh(&moxa_lock);
 	len = MoxaPortWriteData(ch, (unsigned char *) buf, count);
-	spin_unlock_irqrestore(&moxa_lock, flags);
+	spin_unlock_bh(&moxa_lock);
 
 	/*********************************************
 	if ( !(ch->statusflags & LOWWAIT) &&
@@ -1236,13 +1234,12 @@ static void moxa_flush_chars(struct tty_
 static void moxa_put_char(struct tty_struct *tty, unsigned char c)
 {
 	struct moxa_port *ch = tty->driver_data;
-	unsigned long flags;
 
 	if (ch == NULL)
 		return;
-	spin_lock_irqsave(&moxa_lock, flags);
+	spin_lock_bh(&moxa_lock);
 	MoxaPortWriteData(ch, &c, 1);
-	spin_unlock_irqrestore(&moxa_lock, flags);
+	spin_unlock_bh(&moxa_lock);
 	/************************************************
 	if ( !(ch->statusflags & LOWWAIT) && (MoxaPortTxFree(port) <= 100) )
 	*************************************************/
@@ -1360,58 +1357,110 @@ static void moxa_hangup(struct tty_struc
 	wake_up_interruptible(&ch->open_wait);
 }
 
-static void moxa_poll(unsigned long ignored)
+static void moxa_new_dcdstate(struct moxa_port *p, u8 dcd)
 {
-	struct moxa_port *ch;
-	struct tty_struct *tty;
-	unsigned int card;
-	int i;
+	dcd = !!dcd;
 
-	del_timer(&moxaTimer);
+	if ((dcd != p->DCDState) && p->tty && C_CLOCAL(p->tty)) {
+		if (!dcd) {
+			tty_hangup(p->tty);
+			p->asyncflags &= ~ASYNC_NORMAL_ACTIVE;
+		}
+		wake_up_interruptible(&p->open_wait);
+	}
+	p->DCDState = dcd;
+}
 
-	if (MoxaDriverPoll() < 0) {
-		mod_timer(&moxaTimer, jiffies + HZ / 50);
-		return;
+static int moxa_poll_port(struct moxa_port *p, unsigned int handle,
+		u16 __iomem *ip)
+{
+	struct tty_struct *tty = p->tty;
+	void __iomem *ofsAddr;
+	unsigned int inited = p->asyncflags & ASYNC_INITIALIZED;
+	u16 intr;
+
+	if (tty) {
+		if ((p->statusflags & EMPTYWAIT) &&
+				MoxaPortTxQueue(p) == 0) {
+			p->statusflags &= ~EMPTYWAIT;
+			tty_wakeup(tty);
+		}
+		if ((p->statusflags & LOWWAIT) && !tty->stopped &&
+				MoxaPortTxQueue(p) <= WAKEUP_CHARS) {
+			p->statusflags &= ~LOWWAIT;
+			tty_wakeup(tty);
+		}
+
+		if (inited && !(p->statusflags & THROTTLE) &&
+				MoxaPortRxQueue(p) > 0) { /* RX */
+			MoxaPortReadData(p);
+			tty_schedule_flip(tty);
+		}
+	} else {
+		p->statusflags &= ~EMPTYWAIT;
+		MoxaPortFlushData(p, 0); /* flush RX */
 	}
 
+	if (!handle) /* nothing else to do */
+		return 0;
+
+	intr = readw(ip); /* port irq status */
+	if (intr == 0)
+		return 0;
+
+	writew(0, ip); /* ACK port */
+	ofsAddr = p->tableAddr;
+	if (intr & IntrTx) /* disable tx intr */
+		writew(readw(ofsAddr + HostStat) & ~WakeupTx,
+				ofsAddr + HostStat);
+
+	if (!inited)
+		return 0;
+
+	if (tty && (intr & IntrBreak) && !I_IGNBRK(tty)) { /* BREAK */
+		tty_insert_flip_char(tty, 0, TTY_BREAK);
+		tty_schedule_flip(tty);
+	}
+
+	if (intr & IntrLine)
+		moxa_new_dcdstate(p, readb(ofsAddr + FlagStat) & DCD_state);
+
+	return 0;
+}
+
+static void moxa_poll(unsigned long ignored)
+{
+	struct moxa_board_conf *brd;
+	u16 __iomem *ip;
+	unsigned int card, port;
+
+	spin_lock(&moxa_lock);
 	for (card = 0; card < MAX_BOARDS; card++) {
-		if (!moxa_boards[card].ready)
+		brd = &moxa_boards[card];
+		if (!brd->ready)
 			continue;
-		ch = moxa_boards[card].ports;
-		for (i = 0; i < moxa_boards[card].numPorts; i++, ch++) {
-			if ((ch->asyncflags & ASYNC_INITIALIZED) == 0)
-				continue;
-			if (!(ch->statusflags & THROTTLE) &&
-			    (MoxaPortRxQueue(ch) > 0))
-				moxa_receive_data(ch);
-			tty = ch->tty;
-			if (tty == NULL)
-				continue;
-			if (ch->statusflags & LOWWAIT) {
-				if (MoxaPortTxQueue(ch) <= WAKEUP_CHARS) {
-					if (!tty->stopped) {
-						ch->statusflags &= ~LOWWAIT;
-						tty_wakeup(tty);
-					}
-				}
-			}
-			if (!I_IGNBRK(tty) && (MoxaPortResetBrkCnt(ch) > 0)) {
-				tty_insert_flip_char(tty, 0, TTY_BREAK);
-				tty_schedule_flip(tty);
-			}
-			if (MoxaPortDCDChange(ch)) {
-				if (ch->asyncflags & ASYNC_CHECK_CD) {
-					if (MoxaPortDCDON(ch))
-						wake_up_interruptible(&ch->open_wait);
-					else {
-						tty_hangup(tty);
-						wake_up_interruptible(&ch->open_wait);
-						ch->asyncflags &= ~ASYNC_NORMAL_ACTIVE;
-					}
+
+		ip = NULL;
+		if (readb(brd->intPend) == 0xff)
+			ip = brd->intTable + readb(brd->intNdx);
+
+		for (port = 0; port < brd->numPorts; port++)
+			moxa_poll_port(&brd->ports[port], !!ip, ip + port);
+
+		if (ip)
+			writeb(0, brd->intPend); /* ACK */
+
+		if (moxaLowWaterChk) {
+			struct moxa_port *p = brd->ports;
+			for (port = 0; port < brd->numPorts; port++, p++)
+				if (p->lowChkFlag) {
+					p->lowChkFlag = 0;
+					moxa_low_water_check(p->tableAddr);
 				}
-			}
 		}
 	}
+	moxaLowWaterChk = 0;
+	spin_unlock(&moxa_lock);
 
 	mod_timer(&moxaTimer, jiffies + HZ / 50);
 }
@@ -1426,10 +1475,6 @@ static void moxa_set_tty_param(struct tt
 
 	ch = (struct moxa_port *) tty->driver_data;
 	ts = tty->termios;
-	if (ts->c_cflag & CLOCAL)
-		ch->asyncflags &= ~ASYNC_CHECK_CD;
-	else
-		ch->asyncflags |= ASYNC_CHECK_CD;
 	rts = cts = txflow = rxflow = xany = 0;
 	if (ts->c_cflag & CRTSCTS)
 		rts = cts = 1;
@@ -1454,7 +1499,6 @@ static int moxa_block_till_ready(struct 
 			    struct moxa_port *ch)
 {
 	DECLARE_WAITQUEUE(wait,current);
-	unsigned long flags;
 	int retval;
 	int do_clocal = C_CLOCAL(tty);
 
@@ -1489,11 +1533,11 @@ static int moxa_block_till_ready(struct 
 	add_wait_queue(&ch->open_wait, &wait);
 	pr_debug("block_til_ready before block: ttys%d, count = %d\n",
 		tty->index, ch->count);
-	spin_lock_irqsave(&moxa_lock, flags);
+	spin_lock_bh(&moxa_lock);
 	if (!tty_hung_up_p(filp))
 		ch->count--;
 	ch->blocked_open++;
-	spin_unlock_irqrestore(&moxa_lock, flags);
+	spin_unlock_bh(&moxa_lock);
 
 	while (1) {
 		set_current_state(TASK_INTERRUPTIBLE);
@@ -1510,7 +1554,7 @@ static int moxa_block_till_ready(struct 
 			break;
 		}
 		if (!(ch->asyncflags & ASYNC_CLOSING) && (do_clocal ||
-						MoxaPortDCDON(ch)))
+				ch->DCDState))
 			break;
 
 		if (signal_pending(current)) {
@@ -1522,11 +1566,11 @@ static int moxa_block_till_ready(struct 
 	set_current_state(TASK_RUNNING);
 	remove_wait_queue(&ch->open_wait, &wait);
 
-	spin_lock_irqsave(&moxa_lock, flags);
+	spin_lock_bh(&moxa_lock);
 	if (!tty_hung_up_p(filp))
 		ch->count++;
 	ch->blocked_open--;
-	spin_unlock_irqrestore(&moxa_lock, flags);
+	spin_unlock_bh(&moxa_lock);
 	pr_debug("block_til_ready after blocking: ttys%d, count = %d\n",
 		tty->index, ch->count);
 	if (retval)
@@ -1539,28 +1583,10 @@ static int moxa_block_till_ready(struct 
 static void moxa_setup_empty_event(struct tty_struct *tty)
 {
 	struct moxa_port *ch = tty->driver_data;
-	unsigned long flags;
 
-	spin_lock_irqsave(&moxa_lock, flags);
+	spin_lock_bh(&moxa_lock);
 	ch->statusflags |= EMPTYWAIT;
-	mod_timer(&ch->emptyTimer, jiffies + HZ);
-	spin_unlock_irqrestore(&moxa_lock, flags);
-}
-
-static void moxa_check_xmit_empty(unsigned long data)
-{
-	struct moxa_port *ch;
-
-	ch = (struct moxa_port *) data;
-	if (ch->tty && (ch->statusflags & EMPTYWAIT)) {
-		if (MoxaPortTxQueue(ch) == 0) {
-			ch->statusflags &= ~EMPTYWAIT;
-			tty_wakeup(ch->tty);
-			return;
-		}
-		mod_timer(&ch->emptyTimer, round_jiffies(jiffies + HZ));
-	} else
-		ch->statusflags &= ~EMPTYWAIT;
+	spin_unlock_bh(&moxa_lock);
 }
 
 static void moxa_shut_down(struct moxa_port *ch)
@@ -1583,43 +1609,8 @@ static void moxa_shut_down(struct moxa_p
 	ch->asyncflags &= ~ASYNC_INITIALIZED;
 }
 
-static void moxa_receive_data(struct moxa_port *ch)
-{
-	struct tty_struct *tp;
-	struct ktermios *ts;
-	unsigned long flags;
-
-	ts = NULL;
-	tp = ch->tty;
-	if (tp)
-		ts = tp->termios;
-	/**************************************************
-	if ( !tp || !ts || !(ts->c_cflag & CREAD) ) {
-	*****************************************************/
-	if (!tp || !ts) {
-		MoxaPortFlushData(ch, 0);
-		return;
-	}
-	spin_lock_irqsave(&moxa_lock, flags);
-	MoxaPortReadData(ch, tp);
-	spin_unlock_irqrestore(&moxa_lock, flags);
-	tty_schedule_flip(tp);
-}
-
-/*
- *    Query
- */
-
-#define 	DCD_changed	0x01
-#define 	DCD_oldstate	0x80
-
-static int moxaLowWaterChk;
-
-static void moxa_low_water_check(void __iomem *);
-
 /*****************************************************************************
  *	Driver level functions: 					     *
- *	3. MoxaDriverPoll(void);					     *
  *****************************************************************************/
 
 static void MoxaPortFlushData(struct moxa_port *port, int mode)
@@ -1635,67 +1626,6 @@ static void MoxaPortFlushData(struct mox
 	}
 }
 
-static int MoxaDriverPoll(void)
-{
-	struct moxa_board_conf *brd;
-	struct moxa_port *p;
-	void __iomem *ofsAddr;
-	void __iomem *ip;
-	unsigned int port, ports, card;
-	ushort temp;
-
-	for (card = 0; card < MAX_BOARDS; card++) {
-		brd = &moxa_boards[card];
-	        if (brd->ready == 0)
-			continue;
-		if ((ports = brd->numPorts) == 0)
-			continue;
-		if (readb(brd->intPend) == 0xff) {
-			ip = brd->intTable + readb(brd->intNdx);
-			p = brd->ports;
-			ports <<= 1;
-			for (port = 0; port < ports; port += 2, p++) {
-				temp = readw(ip + port);
-				if (temp == 0)
-					continue;
-
-				writew(0, ip + port);
-				ofsAddr = p->tableAddr;
-				if (temp & IntrTx)
-					writew(readw(ofsAddr + HostStat) &
-						~WakeupTx, ofsAddr + HostStat);
-				if (temp & IntrBreak)
-					p->breakCnt++;
-
-				if (temp & IntrLine) {
-					if (readb(ofsAddr + FlagStat) & DCD_state) {
-						if ((p->DCDState & DCD_oldstate) == 0)
-							p->DCDState = (DCD_oldstate |
-									   DCD_changed);
-					} else {
-						if (p->DCDState & DCD_oldstate)
-							p->DCDState = DCD_changed;
-					}
-				}
-			}
-			writeb(0, brd->intPend);
-		}
-		if (moxaLowWaterChk) {
-			p = brd->ports;
-			for (port = 0; port < ports; port++, p++) {
-				if (p->lowChkFlag) {
-					p->lowChkFlag = 0;
-					ofsAddr = p->tableAddr;
-					moxa_low_water_check(ofsAddr);
-				}
-			}
-		}
-	}
-	moxaLowWaterChk = 0;
-
-	return 0;
-}
-
 /*****************************************************************************
  *	Port level functions:						     *
  *	2.  MoxaPortEnable(int port);					     *
@@ -1707,8 +1637,6 @@ static int MoxaDriverPoll(void)
  *	10. MoxaPortLineCtrl(int port, int dtrState, int rtsState);	     *
  *	11. MoxaPortFlowCtrl(int port, int rts, int cts, int rx, int tx,int xany);    *
  *	12. MoxaPortLineStatus(int port);				     *
- *	13. MoxaPortDCDChange(int port);				     *
- *	14. MoxaPortDCDON(int port);					     *
  *	15. MoxaPortFlushData(int port, int mode);	                     *
  *	16. MoxaPortWriteData(int port, unsigned char * buffer, int length); *
  *	17. MoxaPortReadData(int port, struct tty_struct *tty); 	     *
@@ -1755,14 +1683,6 @@ static int MoxaDriverPoll(void)
  *                      -ENOIOCTLCMD
  *
  *
- *      Function 3:     Moxa driver polling process routine.
- *      Syntax:
- *      int  MoxaDriverPoll(void);
- *
- *           return:    0       ; polling O.K.
- *                      -1      : no any Moxa card.             
- *
- *
  *      Function 6:     Enable this port to start Tx/Rx data.
  *      Syntax:
  *      void MoxaPortEnable(int port);
@@ -1853,25 +1773,6 @@ static int MoxaDriverPoll(void)
  *                      Bit 2 - DCD state (0: off, 1: on)
  *
  *
- *      Function 17:    Check the DCD state has changed since the last read
- *                      of this function.
- *      Syntax:
- *      int  MoxaPortDCDChange(int port);
- *           int port           : port number (0 - 127)
- *
- *           return:    0       : no changed
- *                      1       : DCD has changed
- *
- *
- *      Function 18:    Check ths current DCD state is ON or not.
- *      Syntax:
- *      int  MoxaPortDCDON(int port);
- *           int port           : port number (0 - 127)
- *
- *           return:    0       : DCD off
- *                      1       : DCD on
- *
- *
  *      Function 19:    Flush the Rx/Tx buffer data of this port.
  *      Syntax:
  *      void MoxaPortFlushData(int port, int mode);
@@ -1954,7 +1855,6 @@ static void MoxaPortEnable(struct moxa_p
 
 	ofsAddr = port->tableAddr;
 	writew(lowwater, ofsAddr + Low_water);
-	port->breakCnt = 0;
 	if (port->board->boardType == MOXA_BOARD_C320_ISA ||
 	    port->board->boardType == MOXA_BOARD_C320_PCI) {
 		moxafunc(ofsAddr, FC_SetBreakIrq, 0);
@@ -2123,37 +2023,11 @@ static int MoxaPortLineStatus(struct mox
 		val = readw(ofsAddr + FlagStat) >> 4;
 	}
 	val &= 0x0B;
-	if (val & 8) {
+	if (val & 8)
 		val |= 4;
-		if ((port->DCDState & DCD_oldstate) == 0)
-			port->DCDState = (DCD_oldstate | DCD_changed);
-	} else {
-		if (port->DCDState & DCD_oldstate)
-			port->DCDState = DCD_changed;
-	}
+	moxa_new_dcdstate(port, val & 8);
 	val &= 7;
-	return (val);
-}
-
-static int MoxaPortDCDChange(struct moxa_port *port)
-{
-	int n;
-
-	n = port->DCDState;
-	port->DCDState &= ~DCD_changed;
-	n &= DCD_changed;
-	return (n);
-}
-
-static int MoxaPortDCDON(struct moxa_port *port)
-{
-	int n;
-
-	if (port->DCDState & DCD_oldstate)
-		n = 1;
-	else
-		n = 0;
-	return (n);
+	return val;
 }
 
 static int MoxaPortWriteData(struct moxa_port *port, unsigned char *buffer,
@@ -2221,8 +2095,9 @@ static int MoxaPortWriteData(struct moxa
 	return (total);
 }
 
-static int MoxaPortReadData(struct moxa_port *port, struct tty_struct *tty)
+static int MoxaPortReadData(struct moxa_port *port)
 {
+	struct tty_struct *tty = port->tty;
 	register ushort head, pageofs;
 	int i, count, cnt, len, total, remain;
 	ushort tail, rx_mask, spage, epage;
@@ -2243,7 +2118,7 @@ static int MoxaPortReadData(struct moxa_
 
 	total = count;
 	remain = count - total;
-	moxaLog.rxcnt[port->tty->index] += total;
+	moxaLog.rxcnt[tty->index] += total;
 	count = total;
 	if (spage == epage) {
 		bufhead = readw(ofsAddr + Ofs_rxb);
@@ -2341,15 +2216,6 @@ static void MoxaPortTxEnable(struct moxa
 	moxafunc(port->tableAddr, FC_SetXonState, Magic_code);
 }
 
-
-static int MoxaPortResetBrkCnt(struct moxa_port *port)
-{
-	ushort cnt;
-	cnt = port->breakCnt;
-	port->breakCnt = 0;
-	return (cnt);
-}
-
 static int moxa_get_serial_info(struct moxa_port *info,
 				struct serial_struct __user *retinfo)
 {
@@ -2413,21 +2279,6 @@ static int moxa_set_serial_info(struct m
  *	Static local functions: 					     *
  *****************************************************************************/
 
-static void moxa_low_water_check(void __iomem *ofsAddr)
-{
-	int len;
-	ushort rptr, wptr, mask;
-
-	if (readb(ofsAddr + FlagStat) & Xoff_state) {
-		rptr = readw(ofsAddr + RXrptr);
-		wptr = readw(ofsAddr + RXwptr);
-		mask = readw(ofsAddr + RX_mask);
-		len = (wptr - rptr) & mask;
-		if (len <= Low_water)
-			moxafunc(ofsAddr, FC_SendXon, 0);
-	}
-}
-
 static void MoxaSetFifo(struct moxa_port *port, int enable)
 {
 	void __iomem *ofsAddr = port->tableAddr;
diff -puN drivers/char/moxa.h~char-moxa-merge-2-poll-functions drivers/char/moxa.h
--- a/drivers/char/moxa.h~char-moxa-merge-2-poll-functions
+++ a/drivers/char/moxa.h
@@ -165,11 +165,11 @@
 #define HostStat	0x08	/* IRQ flag and general flag      */
 #define FlagStat	0x0A
 #define FlowControl	0x0C	/* B7 B6 B5 B4 B3 B2 B1 B0              */
-					/*  x  x  x  x  |  |  |  |            */
-					/*              |  |  |  + CTS flow   */
-					/*              |  |  +--- RTS flow   */
-					/*              |  +------ TX Xon/Xoff */
-					/*              +--------- RX Xon/Xoff */
+				/*  x  x  x  x  |  |  |  |            */
+				/*              |  |  |  + CTS flow   */
+				/*              |  |  +--- RTS flow   */
+				/*              |  +------ TX Xon/Xoff */
+				/*              +--------- RX Xon/Xoff */
 #define Break_cnt	0x0E	/* received break count   */
 #define CD180TXirq	0x10	/* if non-0: enable TX irq        */
 #define RX_mask 	0x12
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

