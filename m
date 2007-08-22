From: akpm@linux-foundation.org
Subject: + char-moxa-function-names-cleanup.patch added to -mm tree
Date: Wed, 22 Aug 2007 16:10:48 -0700
Message-ID: <200708222310.l7MNAm7g009685@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43306 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932946AbXHVXL0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Aug 2007 19:11:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: moxa, function names cleanup
has been added to the -mm tree.  Its filename is
     char-moxa-function-names-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: moxa, function names cleanup
From: Jiri Slaby <jirislaby@gmail.com>

prepend moxa_ to all moxa functions which laxes this

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |   62 +++++++++++++++++++++---------------------
 1 files changed, 31 insertions(+), 31 deletions(-)

diff -puN drivers/char/moxa.c~char-moxa-function-names-cleanup drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-function-names-cleanup
+++ a/drivers/char/moxa.c
@@ -206,13 +206,13 @@ static int moxa_tiocmget(struct tty_stru
 static int moxa_tiocmset(struct tty_struct *tty, struct file *file,
 			 unsigned int set, unsigned int clear);
 static void moxa_poll(unsigned long);
-static void set_tty_param(struct tty_struct *);
-static int block_till_ready(struct tty_struct *, struct file *,
+static void moxa_set_tty_param(struct tty_struct *);
+static int moxa_block_till_ready(struct tty_struct *, struct file *,
 			    struct moxa_port *);
-static void setup_empty_event(struct tty_struct *);
-static void check_xmit_empty(unsigned long);
-static void shut_down(struct moxa_port *);
-static void receive_data(struct moxa_port *);
+static void moxa_setup_empty_event(struct tty_struct *);
+static void moxa_check_xmit_empty(unsigned long);
+static void moxa_shut_down(struct moxa_port *);
+static void moxa_receive_data(struct moxa_port *);
 /*
  * moxa board interface functions:
  */
@@ -376,7 +376,7 @@ static int __init moxa_init(void)
 		init_waitqueue_head(&ch->open_wait);
 		init_waitqueue_head(&ch->close_wait);
 
-		setup_timer(&ch->emptyTimer, check_xmit_empty,
+		setup_timer(&ch->emptyTimer, moxa_check_xmit_empty,
 				(unsigned long)ch);
 	}
 
@@ -499,12 +499,12 @@ static int moxa_open(struct tty_struct *
 	ch->tty = tty;
 	if (!(ch->asyncflags & ASYNC_INITIALIZED)) {
 		ch->statusflags = 0;
-		set_tty_param(tty);
+		moxa_set_tty_param(tty);
 		MoxaPortLineCtrl(ch->port, 1, 1);
 		MoxaPortEnable(ch->port);
 		ch->asyncflags |= ASYNC_INITIALIZED;
 	}
-	retval = block_till_ready(tty, filp, ch);
+	retval = moxa_block_till_ready(tty, filp, ch);
 
 	moxa_unthrottle(tty);
 
@@ -556,11 +556,11 @@ static void moxa_close(struct tty_struct
 
 	ch->cflag = tty->termios->c_cflag;
 	if (ch->asyncflags & ASYNC_INITIALIZED) {
-		setup_empty_event(tty);
+		moxa_setup_empty_event(tty);
 		tty_wait_until_sent(tty, 30 * HZ);	/* 30 seconds timeout */
 		del_timer_sync(&moxa_ports[ch->port].emptyTimer);
 	}
-	shut_down(ch);
+	moxa_shut_down(ch);
 	MoxaPortFlushData(port, 2);
 
 	if (tty->driver->flush_buffer)
@@ -646,7 +646,7 @@ static int moxa_chars_in_buffer(struct t
 		 * in tty_ioctl.c, etc.
 		 */
 		if (!(ch->statusflags & EMPTYWAIT))
-			setup_empty_event(tty);
+			moxa_setup_empty_event(tty);
 	}
 	return (chars);
 }
@@ -744,7 +744,7 @@ static int moxa_ioctl(struct tty_struct 
 		retval = tty_check_change(tty);
 		if (retval)
 			return (retval);
-		setup_empty_event(tty);
+		moxa_setup_empty_event(tty);
 		tty_wait_until_sent(tty, 0);
 		if (!arg)
 			MoxaPortSendBreak(ch->port, 0);
@@ -753,7 +753,7 @@ static int moxa_ioctl(struct tty_struct 
 		retval = tty_check_change(tty);
 		if (retval)
 			return (retval);
-		setup_empty_event(tty);
+		moxa_setup_empty_event(tty);
 		tty_wait_until_sent(tty, 0);
 		MoxaPortSendBreak(ch->port, arg);
 		return (0);
@@ -802,7 +802,7 @@ static void moxa_set_termios(struct tty_
 
 	if (ch == NULL)
 		return;
-	set_tty_param(tty);
+	moxa_set_tty_param(tty);
 	if (!(old_termios->c_cflag & CLOCAL) &&
 	    (tty->termios->c_cflag & CLOCAL))
 		wake_up_interruptible(&ch->open_wait);
@@ -838,7 +838,7 @@ static void moxa_hangup(struct tty_struc
 	struct moxa_port *ch = (struct moxa_port *) tty->driver_data;
 
 	moxa_flush_buffer(tty);
-	shut_down(ch);
+	moxa_shut_down(ch);
 	ch->event = 0;
 	ch->count = 0;
 	ch->asyncflags &= ~ASYNC_NORMAL_ACTIVE;
@@ -868,7 +868,7 @@ static void moxa_poll(unsigned long igno
 				continue;
 			if (!(ch->statusflags & THROTTLE) &&
 			    (MoxaPortRxQueue(ch->port) > 0))
-				receive_data(ch);
+				moxa_receive_data(ch);
 			if ((tp = ch->tty) == 0)
 				continue;
 			if (ch->statusflags & LOWWAIT) {
@@ -902,7 +902,7 @@ static void moxa_poll(unsigned long igno
 
 /******************************************************************************/
 
-static void set_tty_param(struct tty_struct *tty)
+static void moxa_set_tty_param(struct tty_struct *tty)
 {
 	register struct ktermios *ts;
 	struct moxa_port *ch;
@@ -927,7 +927,7 @@ static void set_tty_param(struct tty_str
 	MoxaPortSetTermio(ch->port, ts, tty_get_baud_rate(tty));
 }
 
-static int block_till_ready(struct tty_struct *tty, struct file *filp,
+static int moxa_block_till_ready(struct tty_struct *tty, struct file *filp,
 			    struct moxa_port *ch)
 {
 	DECLARE_WAITQUEUE(wait,current);
@@ -1013,7 +1013,7 @@ static int block_till_ready(struct tty_s
 	return 0;
 }
 
-static void setup_empty_event(struct tty_struct *tty)
+static void moxa_setup_empty_event(struct tty_struct *tty)
 {
 	struct moxa_port *ch = tty->driver_data;
 	unsigned long flags;
@@ -1024,7 +1024,7 @@ static void setup_empty_event(struct tty
 	spin_unlock_irqrestore(&moxa_lock, flags);
 }
 
-static void check_xmit_empty(unsigned long data)
+static void moxa_check_xmit_empty(unsigned long data)
 {
 	struct moxa_port *ch;
 
@@ -1041,7 +1041,7 @@ static void check_xmit_empty(unsigned lo
 		ch->statusflags &= ~EMPTYWAIT;
 }
 
-static void shut_down(struct moxa_port *ch)
+static void moxa_shut_down(struct moxa_port *ch)
 {
 	struct tty_struct *tp;
 
@@ -1061,7 +1061,7 @@ static void shut_down(struct moxa_port *
 	ch->asyncflags &= ~ASYNC_INITIALIZED;
 }
 
-static void receive_data(struct moxa_port *ch)
+static void moxa_receive_data(struct moxa_port *ch)
 {
 	struct tty_struct *tp;
 	struct ktermios *ts;
@@ -1395,8 +1395,8 @@ static struct mon_str moxaLog;
 static int moxaFuncTout = HZ / 2;
 
 static void moxafunc(void __iomem *, int, ushort);
-static void wait_finish(void __iomem *);
-static void low_water_check(void __iomem *);
+static void moxa_wait_finish(void __iomem *);
+static void moxa_low_water_check(void __iomem *);
 static int moxaloadbios(int, unsigned char __user *, int);
 static int moxafindcard(int);
 static int moxaload320b(int, unsigned char __user *, int);
@@ -1462,7 +1462,7 @@ void MoxaPortFlushData(int port, int mod
 	moxafunc(ofsAddr, FC_FlushQueue, mode);
 	if (mode != 1) {
 		moxa_ports[port].lowChkFlag = 0;
-		low_water_check(ofsAddr);
+		moxa_low_water_check(ofsAddr);
 	}
 }
 
@@ -1643,7 +1643,7 @@ int MoxaDriverPoll(void)
 				if (moxa_ports[p].lowChkFlag) {
 					moxa_ports[p].lowChkFlag = 0;
 					ofsAddr = moxa_ports[p].tableAddr;
-					low_water_check(ofsAddr);
+					moxa_low_water_check(ofsAddr);
 				}
 			}
 		}
@@ -2070,7 +2070,7 @@ int MoxaPortSetTermio(int port, struct k
 		writeb(termio->c_cc[VSTART], ofsAddr + FuncArg);
 		writeb(termio->c_cc[VSTOP], ofsAddr + FuncArg1);
 		writeb(FC_SetXonXoff, ofsAddr + FuncCode);
-		wait_finish(ofsAddr);
+		moxa_wait_finish(ofsAddr);
 
 	}
 	return (0);
@@ -2469,10 +2469,10 @@ static void moxafunc(void __iomem *ofsAd
 
 	writew(arg, ofsAddr + FuncArg);
 	writew(cmd, ofsAddr + FuncCode);
-	wait_finish(ofsAddr);
+	moxa_wait_finish(ofsAddr);
 }
 
-static void wait_finish(void __iomem *ofsAddr)
+static void moxa_wait_finish(void __iomem *ofsAddr)
 {
 	unsigned long i, j;
 
@@ -2485,7 +2485,7 @@ static void wait_finish(void __iomem *of
 	}
 }
 
-static void low_water_check(void __iomem *ofsAddr)
+static void moxa_low_water_check(void __iomem *ofsAddr)
 {
 	int len;
 	ushort rptr, wptr, mask;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

net-add-ath5k-wireless-driver.patch
net-add-ath5k-wireless-driver-fix.patch
ath5k-printk-fix.patch
ath5k-kconfig-fix.patch
ath5k-needs-pci.patch
epcac-reformat-comments-and-coding-style-improvements.patch
char-mxser_new-upgrade-to-110.patch
char-mxser_new-move-to-pci_vdevice.patch
char-mxser_new-remove-useless-comments-in-mxser_cards.patch
char-moxa-fix-and-optimise-empty-timer.patch
char-cyclades-remove-bottom-half-processing.patch
char-cyclades-make-the-isr-code-readable.patch
char-cyclades-move-spin_lock-to-one-place.patch
char-cyclades-fix-some-w-warnings.patch
char-moxa-cleanup-prints.patch
char-moxa-function-names-cleanup.patch
char-moxa-remove-sleep_on.patch
fs-select-remove-unused-macros.patch
cyber2000fb-rename-bit-macro.patch
i2c-pxa-rename-bit-macro-to-pxa_bit.patch
s2io-rename-bit-macro.patch
amba-pl011-rename-bit-macro.patch
define-first-set-of-bit-macros.patch
get-rid-of-input-bit-duplicate-defines.patch
define-global-bit-macro.patch
flashpoint-use-bit-instead-of-bitw.patch
shrink_slab-handle-bad-shrinkers.patch
