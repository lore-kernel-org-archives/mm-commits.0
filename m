From: akpm@linux-foundation.org
Subject: - char-moxa-centralize-board-readiness.patch removed from -mm tree
Date: Thu, 01 May 2008 02:29:10 -0700
Message-ID: <200805010929.m419TA1n030650@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51681 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756270AbYEAJ3P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:29:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, Oyvind.Aabling@uni-c.dk, mm-commits@vger.kernel.org


The patch titled
     Char: moxa, centralize board readiness
has been removed from the -mm tree.  Its filename was
     char-moxa-centralize-board-readiness.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: moxa, centralize board readiness
From: Jiri Slaby <jirislaby@gmail.com>

The only relevant sign of port being ready is its board->ready since now. 
Remove all other flags for this purpose which are set almost on the same
place.  Move ports inside the board to be sure that nobody will grab reference
to the port without being sure that it exists.

[jirislaby@gmail.com: fix unused var warning]
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Tested-by: Oyvind Aabling <Oyvind.Aabling@uni-c.dk>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |  233 ++++++++++++++++++++----------------------
 1 file changed, 115 insertions(+), 118 deletions(-)

diff -puN drivers/char/moxa.c~char-moxa-centralize-board-readiness drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-centralize-board-readiness
+++ a/drivers/char/moxa.c
@@ -104,7 +104,7 @@ static struct moxa_board_conf {
 	int numPorts;
 	int busType;
 
-	int loadstat;
+	unsigned int ready;
 
 	struct moxa_port *ports;
 
@@ -142,7 +142,6 @@ struct moxa_port {
 
 	struct timer_list emptyTimer;
 
-	char chkPort;
 	char lineCtrl;
 	void __iomem *tableAddr;
 	char DCDState;
@@ -162,7 +161,6 @@ struct moxa_port {
 #define WAKEUP_CHARS		256
 
 static int ttymajor = MOXAMAJOR;
-static int moxaCard;
 /* Variables for insmod */
 #ifdef MODULE
 static unsigned long baseaddr[MAX_BOARDS];
@@ -218,7 +216,6 @@ static void moxa_receive_data(struct mox
 static int MoxaDriverIoctl(struct tty_struct *, unsigned int, unsigned long);
 static int MoxaDriverPoll(void);
 static int MoxaPortsOfCard(int);
-static int MoxaPortIsValid(int);
 static void MoxaPortEnable(struct moxa_port *);
 static void MoxaPortDisable(struct moxa_port *);
 static int MoxaPortSetTermio(struct moxa_port *, struct ktermios *, speed_t);
@@ -263,7 +260,6 @@ static const struct tty_operations moxa_
 };
 
 static struct tty_driver *moxaDriver;
-static struct moxa_port moxa_ports[MAX_PORTS];
 static DEFINE_TIMER(moxaTimer, moxa_poll, 0, 0);
 static DEFINE_SPINLOCK(moxa_lock);
 
@@ -480,7 +476,6 @@ static int moxa_real_load_code(struct mo
 		if (readw(baseAddr + Magic_no) != Magic_code)
 			return -EIO;
 	}
-	moxaCard = 1;
 	brd->intNdx = baseAddr + IRQindex;
 	brd->intPend = baseAddr + IRQpending;
 	brd->intTable = baseAddr + IRQtable;
@@ -511,7 +506,6 @@ static int moxa_load_code(struct moxa_bo
 		port = brd->ports;
 		for (i = 0; i < brd->numPorts; i++, port++) {
 			port->board = brd;
-			port->chkPort = 1;
 			port->DCDState = 0;
 			port->tableAddr = baseAddr + Extern_table +
 					Extern_size * i;
@@ -530,7 +524,6 @@ static int moxa_load_code(struct moxa_bo
 		port = brd->ports;
 		for (i = 0; i < brd->numPorts; i++, port++) {
 			port->board = brd;
-			port->chkPort = 1;
 			port->DCDState = 0;
 			port->tableAddr = baseAddr + Extern_table +
 					Extern_size * i;
@@ -575,7 +568,6 @@ static int moxa_load_code(struct moxa_bo
 		}
 		break;
 	}
-	brd->loadstat = 1;
 	return 0;
 }
 
@@ -672,8 +664,29 @@ static int moxa_init_board(struct moxa_b
 {
 	const struct firmware *fw;
 	const char *file;
+	struct moxa_port *p;
+	unsigned int i;
 	int ret;
 
+	brd->ports = kcalloc(MAX_PORTS_PER_BOARD, sizeof(*brd->ports),
+			GFP_KERNEL);
+	if (brd->ports == NULL) {
+		printk(KERN_ERR "cannot allocate memory for ports\n");
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	for (i = 0, p = brd->ports; i < MAX_PORTS_PER_BOARD; i++, p++) {
+		p->type = PORT_16550A;
+		p->close_delay = 5 * HZ / 10;
+		p->cflag = B9600 | CS8 | CREAD | CLOCAL | HUPCL;
+		init_waitqueue_head(&p->open_wait);
+		init_completion(&p->close_wait);
+
+		setup_timer(&p->emptyTimer, moxa_check_xmit_empty,
+				(unsigned long)p);
+	}
+
 	switch (brd->boardType) {
 	case MOXA_BOARD_C218_ISA:
 	case MOXA_BOARD_C218_PCI:
@@ -690,16 +703,38 @@ static int moxa_init_board(struct moxa_b
 	ret = request_firmware(&fw, file, dev);
 	if (ret) {
 		printk(KERN_ERR "request_firmware failed\n");
-		goto end;
+		goto err_free;
 	}
 
 	ret = moxa_load_fw(brd, fw);
 
 	release_firmware(fw);
-end:
+
+	if (ret)
+		goto err_free;
+
+	brd->ready = 1;
+
+	return 0;
+err_free:
+	kfree(brd->ports);
+err:
 	return ret;
 }
 
+static void moxa_board_deinit(struct moxa_board_conf *brd)
+{
+	unsigned int i;
+
+	brd->ready = 0;
+	for (i = 0; i < MAX_PORTS_PER_BOARD; i++)
+		del_timer_sync(&brd->ports[i].emptyTimer);
+
+	iounmap(brd->basemem);
+	brd->basemem = NULL;
+	kfree(brd->ports);
+}
+
 #ifdef CONFIG_PCI
 static int __devinit moxa_pci_probe(struct pci_dev *pdev,
 		const struct pci_device_id *ent)
@@ -727,7 +762,6 @@ static int __devinit moxa_pci_probe(stru
 	}
 
 	board = &moxa_boards[i];
-	board->ports = &moxa_ports[i * MAX_PORTS_PER_BOARD];
 
 	retval = pci_request_region(pdev, 2, "moxa-base");
 	if (retval) {
@@ -777,8 +811,8 @@ static void __devexit moxa_pci_remove(st
 {
 	struct moxa_board_conf *brd = pci_get_drvdata(pdev);
 
-	iounmap(brd->basemem);
-	brd->basemem = NULL;
+	moxa_board_deinit(brd);
+
 	pci_release_region(pdev, 2);
 }
 
@@ -792,8 +826,7 @@ static struct pci_driver moxa_pci_driver
 
 static int __init moxa_init(void)
 {
-	struct moxa_port *ch;
-	unsigned int i, isabrds = 0;
+	unsigned int isabrds = 0;
 	int retval = 0;
 
 	printk(KERN_INFO "MOXA Intellio family driver version %s\n",
@@ -815,17 +848,6 @@ static int __init moxa_init(void)
 	moxaDriver->flags = TTY_DRIVER_REAL_RAW;
 	tty_set_operations(moxaDriver, &moxa_ops);
 
-	for (i = 0, ch = moxa_ports; i < MAX_PORTS; i++, ch++) {
-		ch->type = PORT_16550A;
-		ch->close_delay = 5 * HZ / 10;
-		ch->cflag = B9600 | CS8 | CREAD | CLOCAL | HUPCL;
-		init_waitqueue_head(&ch->open_wait);
-		init_completion(&ch->close_wait);
-
-		setup_timer(&ch->emptyTimer, moxa_check_xmit_empty,
-				(unsigned long)ch);
-	}
-
 	pr_debug("Moxa tty devices major number = %d\n", ttymajor);
 
 	if (tty_register_driver(moxaDriver)) {
@@ -840,6 +862,7 @@ static int __init moxa_init(void)
 #ifdef MODULE
 	{
 	struct moxa_board_conf *brd = moxa_boards;
+	unsigned int i;
 	for (i = 0; i < MAX_BOARDS; i++) {
 		if (!baseaddr[i])
 			break;
@@ -849,7 +872,6 @@ static int __init moxa_init(void)
 					isabrds + 1, moxa_brdname[type[i] - 1],
 					baseaddr[i]);
 			brd->boardType = type[i];
-			brd->ports = &moxa_ports[isabrds * MAX_PORTS_PER_BOARD];
 			brd->numPorts = type[i] == MOXA_BOARD_C218_ISA ? 8 :
 					numports[i];
 			brd->busType = MOXA_BUS_TYPE_ISA;
@@ -890,9 +912,6 @@ static void __exit moxa_exit(void)
 
 	del_timer_sync(&moxaTimer);
 
-	for (i = 0; i < MAX_PORTS; i++)
-		del_timer_sync(&moxa_ports[i].emptyTimer);
-
 	if (tty_unregister_driver(moxaDriver))
 		printk(KERN_ERR "Couldn't unregister MOXA Intellio family "
 				"serial driver\n");
@@ -902,9 +921,9 @@ static void __exit moxa_exit(void)
 	pci_unregister_driver(&moxa_pci_driver);
 #endif
 
-	for (i = 0; i < MAX_BOARDS; i++)
-		if (moxa_boards[i].basemem)
-			iounmap(moxa_boards[i].basemem);
+	for (i = 0; i < MAX_BOARDS; i++) /* ISA boards */
+		if (moxa_boards[i].ready)
+			moxa_board_deinit(&moxa_boards[i]);
 }
 
 module_init(moxa_init);
@@ -912,6 +931,7 @@ module_exit(moxa_exit);
 
 static int moxa_open(struct tty_struct *tty, struct file *filp)
 {
+	struct moxa_board_conf *brd;
 	struct moxa_port *ch;
 	int port;
 	int retval;
@@ -920,12 +940,11 @@ static int moxa_open(struct tty_struct *
 	if (port == MAX_PORTS) {
 		return (0);
 	}
-	if (!MoxaPortIsValid(port)) {
-		tty->driver_data = NULL;
-		return (-ENODEV);
-	}
+	brd = &moxa_boards[port / MAX_PORTS_PER_BOARD];
+	if (!brd->ready)
+		return -ENODEV;
 
-	ch = &moxa_ports[port];
+	ch = &brd->ports[port % MAX_PORTS_PER_BOARD];
 	ch->count++;
 	tty->driver_data = ch;
 	ch->tty = tty;
@@ -958,11 +977,6 @@ static void moxa_close(struct tty_struct
 	if (port == MAX_PORTS) {
 		return;
 	}
-	if (!MoxaPortIsValid(port)) {
-		pr_debug("Invalid portno in moxa_close\n");
-		tty->driver_data = NULL;
-		return;
-	}
 	if (tty->driver_data == NULL) {
 		return;
 	}
@@ -1285,7 +1299,7 @@ static void moxa_poll(unsigned long igno
 	for (card = 0; card < MAX_BOARDS; card++) {
 		if ((ports = MoxaPortsOfCard(card)) <= 0)
 			continue;
-		ch = &moxa_ports[card * MAX_PORTS_PER_BOARD];
+		ch = moxa_boards[card].ports;
 		for (i = 0; i < ports; i++, ch++) {
 			if ((ch->asyncflags & ASYNC_INITIALIZED) == 0)
 				continue;
@@ -1589,17 +1603,22 @@ static int MoxaDriverIoctl(struct tty_st
 	case MOXA_GET_IOQUEUE: {
 		struct moxaq_str __user *argm = argp;
 		struct moxaq_str tmp;
+		struct moxa_port *p;
+		unsigned int j;
 
-		for (i = 0; i < MAX_PORTS; i++, argm++) {
-			memset(&tmp, 0, sizeof(tmp));
-			if (moxa_ports[i].chkPort) {
-				tmp.inq = MoxaPortRxQueue(&moxa_ports[i]);
-				tmp.outq = MoxaPortTxQueue(&moxa_ports[i]);
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
 			}
-			if (copy_to_user(argm, &tmp, sizeof(tmp)))
-				return -EFAULT;
 		}
-		return (0);
+		return 0;
 	} case MOXA_GET_OQUEUE:
 		i = MoxaPortTxQueue(port);
 		return put_user(i, (unsigned long __user *)argp);
@@ -1619,13 +1638,15 @@ static int MoxaDriverIoctl(struct tty_st
 		struct mxser_mstatus __user *argm = argp;
 		struct mxser_mstatus tmp;
 		struct moxa_port *p;
+		unsigned int j;
+
+		for (i = 0; i < MAX_BOARDS; i++) {
+			p = moxa_boards[i].ports;
+			for (j = 0; j < MAX_PORTS_PER_BOARD; j++, p++, argm++) {
+				memset(&tmp, 0, sizeof(tmp));
+				if (!moxa_boards[i].ready)
+					goto copy;
 
-		for (i = 0; i < MAX_PORTS; i++, argm++) {
-			p = &moxa_ports[i];
-			memset(&tmp, 0, sizeof(tmp));
-			if (!p->chkPort) {
-				goto copy;
-			} else {
 				status = MoxaPortLineStatus(p);
 				if (status & 1)
 					tmp.cts = 1;
@@ -1633,15 +1654,15 @@ static int MoxaDriverIoctl(struct tty_st
 					tmp.dsr = 1;
 				if (status & 4)
 					tmp.dcd = 1;
-			}
 
-			if (!p->tty || !p->tty->termios)
-				tmp.cflag = p->cflag;
-			else
-				tmp.cflag = p->tty->termios->c_cflag;
+				if (!p->tty || !p->tty->termios)
+					tmp.cflag = p->cflag;
+				else
+					tmp.cflag = p->tty->termios->c_cflag;
 copy:
-			if (copy_to_user(argm, &tmp, sizeof(tmp)))
-				return -EFAULT;
+				if (copy_to_user(argm, &tmp, sizeof(tmp)))
+					return -EFAULT;
+			}
 		}
 		return 0;
 	}
@@ -1653,53 +1674,55 @@ copy:
 int MoxaDriverPoll(void)
 {
 	struct moxa_board_conf *brd;
+	struct moxa_port *p;
 	register ushort temp;
 	register int card;
 	void __iomem *ofsAddr;
 	void __iomem *ip;
-	int port, p, ports;
+	int port, ports;
 
-	if (moxaCard == 0)
-		return (-1);
 	for (card = 0; card < MAX_BOARDS; card++) {
 		brd = &moxa_boards[card];
-	        if (brd->loadstat == 0)
+	        if (brd->ready == 0)
 			continue;
 		if ((ports = brd->numPorts) == 0)
 			continue;
 		if (readb(brd->intPend) == 0xff) {
 			ip = brd->intTable + readb(brd->intNdx);
-			p = card * MAX_PORTS_PER_BOARD;
+			p = brd->ports;
 			ports <<= 1;
 			for (port = 0; port < ports; port += 2, p++) {
-				if ((temp = readw(ip + port)) != 0) {
-					writew(0, ip + port);
-					ofsAddr = moxa_ports[p].tableAddr;
-					if (temp & IntrTx)
-						writew(readw(ofsAddr + HostStat) & ~WakeupTx, ofsAddr + HostStat);
-					if (temp & IntrBreak) {
-						moxa_ports[p].breakCnt++;
-					}
-					if (temp & IntrLine) {
-						if (readb(ofsAddr + FlagStat) & DCD_state) {
-							if ((moxa_ports[p].DCDState & DCD_oldstate) == 0)
-								moxa_ports[p].DCDState = (DCD_oldstate |
-										   DCD_changed);
-						} else {
-							if (moxa_ports[p].DCDState & DCD_oldstate)
-								moxa_ports[p].DCDState = DCD_changed;
-						}
+				temp = readw(ip + port);
+				if (temp == 0)
+					continue;
+
+				writew(0, ip + port);
+				ofsAddr = p->tableAddr;
+				if (temp & IntrTx)
+					writew(readw(ofsAddr + HostStat) &
+						~WakeupTx, ofsAddr + HostStat);
+				if (temp & IntrBreak)
+					p->breakCnt++;
+
+				if (temp & IntrLine) {
+					if (readb(ofsAddr + FlagStat) & DCD_state) {
+						if ((p->DCDState & DCD_oldstate) == 0)
+							p->DCDState = (DCD_oldstate |
+									   DCD_changed);
+					} else {
+						if (p->DCDState & DCD_oldstate)
+							p->DCDState = DCD_changed;
 					}
 				}
 			}
 			writeb(0, brd->intPend);
 		}
 		if (moxaLowWaterChk) {
-			p = card * MAX_PORTS_PER_BOARD;
+			p = brd->ports;
 			for (port = 0; port < ports; port++, p++) {
-				if (moxa_ports[p].lowChkFlag) {
-					moxa_ports[p].lowChkFlag = 0;
-					ofsAddr = moxa_ports[p].tableAddr;
+				if (p->lowChkFlag) {
+					p->lowChkFlag = 0;
+					ofsAddr = p->tableAddr;
 					moxa_low_water_check(ofsAddr);
 				}
 			}
@@ -1723,7 +1746,6 @@ int MoxaPortsOfCard(int cardno)
 
 /*****************************************************************************
  *	Port level functions:						     *
- *	1.  MoxaPortIsValid(int port);					     *
  *	2.  MoxaPortEnable(int port);					     *
  *	3.  MoxaPortDisable(int port);					     *
  *	4.  MoxaPortGetMaxBaud(int port);				     *
@@ -1800,15 +1822,6 @@ int MoxaPortsOfCard(int cardno)
  *                      8/16/24/32
  *
  *
- *      Function 5:     Check this port is valid or invalid
- *      Syntax:
- *      int  MoxaPortIsValid(int port);
- *           int port           : port number (0 - 127, ref port description)
- *
- *           return:    0       : this port is invalid
- *                      1       : this port is valid
- *
- *
  *      Function 6:     Enable this port to start Tx/Rx data.
  *      Syntax:
  *      void MoxaPortEnable(int port);
@@ -2000,14 +2013,6 @@ int MoxaPortsOfCard(int cardno)
  *                                send out a about 250 ms BREAK signal.
  *
  */
-static int MoxaPortIsValid(int port)
-{
-	if (moxaCard == 0)
-		return (0);
-	if (moxa_ports[port].chkPort == 0)
-		return (0);
-	return (1);
-}
 
 static void MoxaPortEnable(struct moxa_port *port)
 {
@@ -2081,8 +2086,6 @@ static int MoxaPortSetTermio(struct moxa
 	tcflag_t cflag;
 	tcflag_t mode = 0;
 
-	if (port->chkPort == 0 || termio == 0)
-		return (-1);
 	ofsAddr = port->tableAddr;
 	cflag = termio->c_cflag;	/* termio->c_cflag */
 
@@ -2135,8 +2138,6 @@ static int MoxaPortGetLineOut(struct mox
 		int *rtsState)
 {
 
-	if (!MoxaPortIsValid(port->tty->index))
-		return (-1);
 	if (dtrState)
 		*dtrState = !!(port->lineCtrl & DTR_ON);
 	if (rtsState)
@@ -2205,8 +2206,6 @@ static int MoxaPortDCDChange(struct moxa
 {
 	int n;
 
-	if (port->chkPort == 0)
-		return (0);
 	n = port->DCDState;
 	port->DCDState &= ~DCD_changed;
 	n &= DCD_changed;
@@ -2217,8 +2216,6 @@ static int MoxaPortDCDON(struct moxa_por
 {
 	int n;
 
-	if (port->chkPort == 0)
-		return (0);
 	if (port->DCDState & DCD_oldstate)
 		n = 1;
 	else
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

