From: akpm@linux-foundation.org
Subject: + char-moxa-little-cleanup.patch added to -mm tree
Date: Wed, 27 Feb 2008 15:13:24 -0800
Message-ID: <200802272313.m1RNDODR003302@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:51357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758441AbYB0XN7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 18:13:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, Oyvind.Aabling@uni-c.dk


The patch titled
     Char: moxa, little cleanup
has been added to the -mm tree.  Its filename is
     char-moxa-little-cleanup.patch

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
Subject: Char: moxa, little cleanup
From: Jiri Slaby <jirislaby@gmail.com>

Cleanup of
- whitespace
- macros
- useless casts
- return (sth); -> return sth;
- types
- superfluous parenthesis and braces
- init tmp directly in moxa_get_serial_info
- commented defunct code
- commented prototypes
- MOXA/moxa printk case

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Tested-by: Oyvind Aabling <Oyvind.Aabling@uni-c.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |  172 +++++++++++++++---------------------------
 1 file changed, 62 insertions(+), 110 deletions(-)

diff -puN drivers/char/moxa.c~char-moxa-little-cleanup drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-little-cleanup
+++ a/drivers/char/moxa.c
@@ -54,7 +54,6 @@
 #define MOXA_FW_HDRLEN		32
 
 #define MOXAMAJOR		172
-#define MOXACUMAJOR		173
 
 #define MAX_BOARDS		4	/* Don't change this value */
 #define MAX_PORTS_PER_BOARD	32	/* Don't change this value */
@@ -246,7 +245,7 @@ static void moxa_wait_finish(void __iome
 		printk(KERN_WARNING "moxa function expired\n");
 }
 
-static void moxafunc(void __iomem *ofsAddr, int cmd, ushort arg)
+static void moxafunc(void __iomem *ofsAddr, u16 cmd, u16 arg)
 {
 	writew(arg, ofsAddr + FuncArg);
 	writew(cmd, ofsAddr + FuncCode);
@@ -478,7 +477,7 @@ static int moxa_load_bios(struct moxa_bo
 			goto err;
 		tmp = readw(baseAddr + C320_status);
 		if (tmp != STS_init) {
-			printk(KERN_ERR "moxa: bios upload failed -- CPU/Basic "
+			printk(KERN_ERR "MOXA: bios upload failed -- CPU/Basic "
 					"module not found\n");
 			return -EIO;
 		}
@@ -487,7 +486,7 @@ static int moxa_load_bios(struct moxa_bo
 
 	return 0;
 err:
-	printk(KERN_ERR "moxa: bios upload failed -- board not found\n");
+	printk(KERN_ERR "MOXA: bios upload failed -- board not found\n");
 	return -EIO;
 }
 
@@ -497,7 +496,7 @@ static int moxa_load_320b(struct moxa_bo
 	void __iomem *baseAddr = brd->basemem;
 
 	if (len < 7168) {
-		printk(KERN_ERR "moxa: invalid 320 bios -- too short\n");
+		printk(KERN_ERR "MOXA: invalid 320 bios -- too short\n");
 		return -EINVAL;
 	}
 
@@ -642,7 +641,7 @@ static int moxa_load_code(struct moxa_bo
 	int retval, i;
 
 	if (len % 2) {
-		printk(KERN_ERR "moxa: bios length is not even\n");
+		printk(KERN_ERR "MOXA: bios length is not even\n");
 		return -EINVAL;
 	}
 
@@ -764,7 +763,7 @@ static int moxa_load_fw(struct moxa_boar
 		lens[a] = le16_to_cpu(hdr->len[a]);
 		if (lens[a] && len + lens[a] <= fw->size &&
 				moxa_check_fw(&fw->data[len]))
-			printk(KERN_WARNING "moxa firmware: unexpected input "
+			printk(KERN_WARNING "MOXA firmware: unexpected input "
 				"at offset %u, but going on\n", (u32)len);
 		if (!lens[a] && a < lencnt) {
 			sprintf(rsn, "too few entries in fw file");
@@ -965,7 +964,7 @@ static int __devinit moxa_pci_probe(stru
 
 	pci_set_drvdata(pdev, board);
 
-	return (0);
+	return 0;
 err_base:
 	iounmap(board->basemem);
 	board->basemem = NULL;
@@ -1016,10 +1015,8 @@ static int __init moxa_init(void)
 	moxaDriver->flags = TTY_DRIVER_REAL_RAW;
 	tty_set_operations(moxaDriver, &moxa_ops);
 
-	pr_debug("Moxa tty devices major number = %d\n", ttymajor);
-
 	if (tty_register_driver(moxaDriver)) {
-		printk(KERN_ERR "Couldn't install MOXA Smartio family driver !\n");
+		printk(KERN_ERR "can't register MOXA Smartio tty driver!\n");
 		put_tty_driver(moxaDriver);
 		return -1;
 	}
@@ -1042,7 +1039,7 @@ static int __init moxa_init(void)
 			brd->busType = MOXA_BUS_TYPE_ISA;
 			brd->basemem = ioremap(baseaddr[i], 0x4000);
 			if (!brd->basemem) {
-				printk(KERN_ERR "moxa: can't remap %lx\n",
+				printk(KERN_ERR "MOXA: can't remap %lx\n",
 						baseaddr[i]);
 				continue;
 			}
@@ -1062,7 +1059,7 @@ static int __init moxa_init(void)
 #ifdef CONFIG_PCI
 	retval = pci_register_driver(&moxa_pci_driver);
 	if (retval) {
-		printk(KERN_ERR "Can't register moxa pci driver!\n");
+		printk(KERN_ERR "Can't register MOXA pci driver!\n");
 		if (isabrds)
 			retval = 0;
 	}
@@ -1073,7 +1070,7 @@ static int __init moxa_init(void)
 
 static void __exit moxa_exit(void)
 {
-	int i;
+	unsigned int i;
 
 #ifdef CONFIG_PCI
 	pci_unregister_driver(&moxa_pci_driver);
@@ -1235,12 +1232,8 @@ static int moxa_write(struct tty_struct 
 	len = MoxaPortWriteData(ch, buf, count);
 	spin_unlock_bh(&moxa_lock);
 
-	/*********************************************
-	if ( !(ch->statusflags & LOWWAIT) &&
-	     ((len != count) || (MoxaPortTxFree(port) <= 100)) )
-	************************************************/
 	ch->statusflags |= LOWWAIT;
-	return (len);
+	return len;
 }
 
 static int moxa_write_room(struct tty_struct *tty)
@@ -1248,10 +1241,10 @@ static int moxa_write_room(struct tty_st
 	struct moxa_port *ch;
 
 	if (tty->stopped)
-		return (0);
+		return 0;
 	ch = tty->driver_data;
 	if (ch == NULL)
-		return (0);
+		return 0;
 	return MoxaPortTxFree(ch);
 }
 
@@ -1277,7 +1270,7 @@ static int moxa_chars_in_buffer(struct t
 	 * routine.  And since the open() failed, we return 0 here.  TDJ
 	 */
 	if (ch == NULL)
-		return (0);
+		return 0;
 	chars = MoxaPortTxQueue(ch);
 	if (chars) {
 		/*
@@ -1287,7 +1280,7 @@ static int moxa_chars_in_buffer(struct t
 		if (!(ch->statusflags & EMPTYWAIT))
 			moxa_setup_empty_event(tty);
 	}
-	return (chars);
+	return chars;
 }
 
 static void moxa_flush_chars(struct tty_struct *tty)
@@ -1307,9 +1300,7 @@ static void moxa_put_char(struct tty_str
 	spin_lock_bh(&moxa_lock);
 	MoxaPortWriteData(ch, &c, 1);
 	spin_unlock_bh(&moxa_lock);
-	/************************************************
-	if ( !(ch->statusflags & LOWWAIT) && (MoxaPortTxFree(port) <= 100) )
-	*************************************************/
+
 	ch->statusflags |= LOWWAIT;
 }
 
@@ -1372,34 +1363,33 @@ static int moxa_tiocmset(struct tty_stru
 
 static void moxa_throttle(struct tty_struct *tty)
 {
-	struct moxa_port *ch = (struct moxa_port *) tty->driver_data;
+	struct moxa_port *ch = tty->driver_data;
 
 	ch->statusflags |= THROTTLE;
 }
 
 static void moxa_unthrottle(struct tty_struct *tty)
 {
-	struct moxa_port *ch = (struct moxa_port *) tty->driver_data;
+	struct moxa_port *ch = tty->driver_data;
 
 	ch->statusflags &= ~THROTTLE;
 }
 
 static void moxa_set_termios(struct tty_struct *tty,
-			     struct ktermios *old_termios)
+		struct ktermios *old_termios)
 {
-	struct moxa_port *ch = (struct moxa_port *) tty->driver_data;
+	struct moxa_port *ch = tty->driver_data;
 
 	if (ch == NULL)
 		return;
 	moxa_set_tty_param(tty, old_termios);
-	if (!(old_termios->c_cflag & CLOCAL) &&
-	    (tty->termios->c_cflag & CLOCAL))
+	if (!(old_termios->c_cflag & CLOCAL) && C_CLOCAL(tty))
 		wake_up_interruptible(&ch->open_wait);
 }
 
 static void moxa_stop(struct tty_struct *tty)
 {
-	struct moxa_port *ch = (struct moxa_port *) tty->driver_data;
+	struct moxa_port *ch = tty->driver_data;
 
 	if (ch == NULL)
 		return;
@@ -1410,7 +1400,7 @@ static void moxa_stop(struct tty_struct 
 
 static void moxa_start(struct tty_struct *tty)
 {
-	struct moxa_port *ch = (struct moxa_port *) tty->driver_data;
+	struct moxa_port *ch = tty->driver_data;
 
 	if (ch == NULL)
 		return;
@@ -1443,7 +1433,7 @@ static void moxa_new_dcdstate(struct mox
 {
 	dcd = !!dcd;
 
-	if ((dcd != p->DCDState) && p->tty && C_CLOCAL(p->tty)) {
+	if (dcd != p->DCDState && p->tty && C_CLOCAL(p->tty)) {
 		if (!dcd)
 			tty_hangup(p->tty);
 	}
@@ -1551,12 +1541,10 @@ static void moxa_poll(unsigned long igno
 
 static void moxa_set_tty_param(struct tty_struct *tty, struct ktermios *old_termios)
 {
-	register struct ktermios *ts;
-	struct moxa_port *ch;
+	register struct ktermios *ts = tty->termios;
+	struct moxa_port *ch = tty->driver_data;
 	int rts, cts, txflow, rxflow, xany, baud;
 
-	ch = (struct moxa_port *) tty->driver_data;
-	ts = tty->termios;
 	rts = cts = txflow = rxflow = xany = 0;
 	if (ts->c_cflag & CRTSCTS)
 		rts = cts = 1;
@@ -1613,7 +1601,7 @@ static void moxa_shut_down(struct moxa_p
 static void MoxaPortFlushData(struct moxa_port *port, int mode)
 {
 	void __iomem *ofsAddr;
-	if ((mode < 0) || (mode > 2))
+	if (mode < 0 || mode > 2)
 		return;
 	ofsAddr = port->tableAddr;
 	moxafunc(ofsAddr, FC_FlushQueue, mode);
@@ -1623,27 +1611,6 @@ static void MoxaPortFlushData(struct mox
 	}
 }
 
-/*****************************************************************************
- *	Port level functions:						     *
- *	2.  MoxaPortEnable(int port);					     *
- *	3.  MoxaPortDisable(int port);					     *
- *	4.  MoxaPortGetMaxBaud(int port);				     *
- *	6.  MoxaPortSetBaud(int port, long baud);			     *
- *	8.  MoxaPortSetTermio(int port, unsigned char *termio); 	     *
- *	9.  MoxaPortGetLineOut(int port, int *dtrState, int *rtsState);      *
- *	10. MoxaPortLineCtrl(int port, int dtrState, int rtsState);	     *
- *	11. MoxaPortFlowCtrl(int port, int rts, int cts, int rx, int tx,int xany);    *
- *	12. MoxaPortLineStatus(int port);				     *
- *	15. MoxaPortFlushData(int port, int mode);	                     *
- *	16. MoxaPortWriteData(int port, unsigned char * buffer, int length); *
- *	17. MoxaPortReadData(int port, struct tty_struct *tty); 	     *
- *	20. MoxaPortTxQueue(int port);					     *
- *	21. MoxaPortTxFree(int port);					     *
- *	22. MoxaPortRxQueue(int port);					     *
- *	24. MoxaPortTxDisable(int port);				     *
- *	25. MoxaPortTxEnable(int port); 				     *
- *	27. MoxaPortResetBrkCnt(int port);				     *
- *****************************************************************************/
 /*
  *    Moxa Port Number Description:
  *
@@ -1848,16 +1815,16 @@ static void MoxaPortFlushData(struct mox
 static void MoxaPortEnable(struct moxa_port *port)
 {
 	void __iomem *ofsAddr;
-	short lowwater = 512;
+	u16 lowwater = 512;
 
 	ofsAddr = port->tableAddr;
 	writew(lowwater, ofsAddr + Low_water);
 	if (port->board->boardType == MOXA_BOARD_C320_ISA ||
-	    port->board->boardType == MOXA_BOARD_C320_PCI) {
+			port->board->boardType == MOXA_BOARD_C320_PCI)
 		moxafunc(ofsAddr, FC_SetBreakIrq, 0);
-	} else {
-		writew(readw(ofsAddr + HostStat) | WakeupBreak, ofsAddr + HostStat);
-	}
+	else
+		writew(readw(ofsAddr + HostStat) | WakeupBreak,
+				ofsAddr + HostStat);
 
 	moxafunc(ofsAddr, FC_SetLineIrq, Magic_code);
 	moxafunc(ofsAddr, FC_FlushQueue, 2);
@@ -1880,9 +1847,9 @@ static long MoxaPortGetMaxBaud(struct mo
 {
 	if (port->board->boardType == MOXA_BOARD_C320_ISA ||
 			port->board->boardType == MOXA_BOARD_C320_PCI)
-		return (460800L);
+		return 460800L;
 	else
-		return (921600L);
+		return 921600L;
 }
 
 
@@ -1892,8 +1859,8 @@ static long MoxaPortSetBaud(struct moxa_
 	long max, clock;
 	unsigned int val;
 
-	if ((baud < 50L) || ((max = MoxaPortGetMaxBaud(port)) == 0))
-		return (0);
+	if (baud < 50L || (max = MoxaPortGetMaxBaud(port)) == 0)
+		return 0;
 	ofsAddr = port->tableAddr;
 	if (baud > max)
 		baud = max;
@@ -1906,7 +1873,7 @@ static long MoxaPortSetBaud(struct moxa_
 	val = clock / baud;
 	moxafunc(ofsAddr, FC_SetBaud, val);
 	baud = clock / val;
-	return (baud);
+	return baud;
 }
 
 static int MoxaPortSetTermio(struct moxa_port *port, struct ktermios *termio,
@@ -1945,12 +1912,12 @@ static int MoxaPortSetTermio(struct moxa
 	} else
 		mode |= MX_PARNONE;
 
-	moxafunc(ofsAddr, FC_SetDataMode, (ushort) mode);
+	moxafunc(ofsAddr, FC_SetDataMode, (u16)mode);
 
 	if (port->board->boardType == MOXA_BOARD_C320_ISA ||
 			port->board->boardType == MOXA_BOARD_C320_PCI) {
 		if (baud >= 921600L)
-			return (-1);
+			return -1;
 	}
 	baud = MoxaPortSetBaud(port, baud);
 
@@ -1961,24 +1928,23 @@ static int MoxaPortSetTermio(struct moxa
 		moxa_wait_finish(ofsAddr);
 
 	}
-	return (baud);
+	return baud;
 }
 
 static int MoxaPortGetLineOut(struct moxa_port *port, int *dtrState,
 		int *rtsState)
 {
-
 	if (dtrState)
 		*dtrState = !!(port->lineCtrl & DTR_ON);
 	if (rtsState)
 		*rtsState = !!(port->lineCtrl & RTS_ON);
 
-	return (0);
+	return 0;
 }
 
 static void MoxaPortLineCtrl(struct moxa_port *port, int dtr, int rts)
 {
-	int mode = 0;
+	u8 mode = 0;
 
 	if (dtr)
 		mode |= DTR_ON;
@@ -2192,60 +2158,46 @@ static void MoxaPortTxEnable(struct moxa
 }
 
 static int moxa_get_serial_info(struct moxa_port *info,
-				struct serial_struct __user *retinfo)
+		struct serial_struct __user *retinfo)
 {
-	struct serial_struct tmp;
-
-	memset(&tmp, 0, sizeof(tmp));
-	tmp.type = info->type;
-	tmp.line = info->tty->index;
-	tmp.port = 0;
-	tmp.irq = 0;
-	tmp.flags = info->asyncflags;
-	tmp.baud_base = 921600;
-	tmp.close_delay = info->close_delay;
-	tmp.custom_divisor = 0;
-	tmp.hub6 = 0;
-	if(copy_to_user(retinfo, &tmp, sizeof(*retinfo)))
-		return -EFAULT;
-	return (0);
+	struct serial_struct tmp = {
+		.type = info->type,
+		.line = info->tty->index,
+		.flags = info->asyncflags,
+		.baud_base = 921600,
+		.close_delay = info->close_delay
+	};
+	return copy_to_user(retinfo, &tmp, sizeof(*retinfo)) ? -EFAULT : 0;
 }
 
 
 static int moxa_set_serial_info(struct moxa_port *info,
-				struct serial_struct __user *new_info)
+		struct serial_struct __user *new_info)
 {
 	struct serial_struct new_serial;
 
-	if(copy_from_user(&new_serial, new_info, sizeof(new_serial)))
+	if (copy_from_user(&new_serial, new_info, sizeof(new_serial)))
 		return -EFAULT;
 
-	if ((new_serial.irq != 0) ||
-	    (new_serial.port != 0) ||
-//           (new_serial.type != info->type) ||
-	    (new_serial.custom_divisor != 0) ||
-	    (new_serial.baud_base != 921600))
-		return (-EPERM);
+	if (new_serial.irq != 0 || new_serial.port != 0 ||
+			new_serial.custom_divisor != 0 ||
+			new_serial.baud_base != 921600)
+		return -EPERM;
 
 	if (!capable(CAP_SYS_ADMIN)) {
 		if (((new_serial.flags & ~ASYNC_USR_MASK) !=
 		     (info->asyncflags & ~ASYNC_USR_MASK)))
-			return (-EPERM);
-	} else {
+			return -EPERM;
+	} else
 		info->close_delay = new_serial.close_delay * HZ / 100;
-	}
 
 	new_serial.flags = (new_serial.flags & ~ASYNC_FLAGS);
 	new_serial.flags |= (info->asyncflags & ASYNC_FLAGS);
 
-	if (new_serial.type == PORT_16550A) {
-		MoxaSetFifo(info, 1);
-	} else {
-		MoxaSetFifo(info, 0);
-	}
+	MoxaSetFifo(info, new_serial.type == PORT_16550A);
 
 	info->type = new_serial.type;
-	return (0);
+	return 0;
 }
 
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

git-drm.patch
drm-i915-fix-oops-after-killing-x.patch
wdev-ath5k-typecheck-on-nondebug.patch
misc-phantom-add-compat-ioctl.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
misc-phantom-fix-poll.patch
mxser-prepare-for-bkl-pushdown.patch
tty-bkl-pushdown-fix.patch
tty-bkl-pushdown-fix1.patch
char-moxa-remove-static-isa-support.patch
char-moxa-cleanup-module-param-passed-isa-init.patch
char-moxa-pci-io-space-fixup.patch
char-moxa-fix-tiocg-ssoftcar-param.patch
char-moxa-add-firmware-loading.patch
char-moxa-merge-c2xx-and-c320-firmware-loading.patch
char-moxa-remove-port-port.patch
char-moxa-remove-unused-port-entries.patch
char-moxa-centralize-board-readiness.patch
char-moxa-timer-cleanup.patch
char-moxa-ioctl-cleanup.patch
char-moxa-merge-2-poll-functions.patch
char-moxa-cleanup-rx-tx.patch
char-moxa-serialise-timer.patch
char-moxa-rework-open-close.patch
char-moxa-little-cleanup.patch
char-moxa-remove-useless-tty-functions.patch
char-moxa-introduce-moxa_is_320-macro.patch
char-moxa-notify-about-board-readiness.patch
char-moxa-update-credits.patch
char-moxa-add-firmware-loading-fix.patch
mxser-convert-large-macros-to-functions.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
