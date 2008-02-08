From: akpm@linux-foundation.org
Subject: - moxa-first-pass-at-termios-reporting.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:12:34 -0800
Message-ID: <200802082012.m18KCFtJ010186@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53748 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756212AbYBHVBa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:01:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     moxa: first pass at termios reporting
has been removed from the -mm tree.  Its filename was
     moxa-first-pass-at-termios-reporting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: moxa: first pass at termios reporting
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff -puN drivers/char/moxa.c~moxa-first-pass-at-termios-reporting drivers/char/moxa.c
--- a/drivers/char/moxa.c~moxa-first-pass-at-termios-reporting
+++ a/drivers/char/moxa.c
@@ -207,7 +207,7 @@ static int moxa_tiocmget(struct tty_stru
 static int moxa_tiocmset(struct tty_struct *tty, struct file *file,
 			 unsigned int set, unsigned int clear);
 static void moxa_poll(unsigned long);
-static void moxa_set_tty_param(struct tty_struct *);
+static void moxa_set_tty_param(struct tty_struct *, struct ktermios *);
 static int moxa_block_till_ready(struct tty_struct *, struct file *,
 			    struct moxa_port *);
 static void moxa_setup_empty_event(struct tty_struct *);
@@ -500,7 +500,7 @@ static int moxa_open(struct tty_struct *
 	ch->tty = tty;
 	if (!(ch->asyncflags & ASYNC_INITIALIZED)) {
 		ch->statusflags = 0;
-		moxa_set_tty_param(tty);
+		moxa_set_tty_param(tty, tty->termios);
 		MoxaPortLineCtrl(ch->port, 1, 1);
 		MoxaPortEnable(ch->port);
 		ch->asyncflags |= ASYNC_INITIALIZED;
@@ -803,7 +803,7 @@ static void moxa_set_termios(struct tty_
 
 	if (ch == NULL)
 		return;
-	moxa_set_tty_param(tty);
+	moxa_set_tty_param(tty, old_termios);
 	if (!(old_termios->c_cflag & CLOCAL) &&
 	    (tty->termios->c_cflag & CLOCAL))
 		wake_up_interruptible(&ch->open_wait);
@@ -903,11 +903,11 @@ static void moxa_poll(unsigned long igno
 
 /******************************************************************************/
 
-static void moxa_set_tty_param(struct tty_struct *tty)
+static void moxa_set_tty_param(struct tty_struct *tty, struct ktermios *old_termios)
 {
 	register struct ktermios *ts;
 	struct moxa_port *ch;
-	int rts, cts, txflow, rxflow, xany;
+	int rts, cts, txflow, rxflow, xany, baud;
 
 	ch = (struct moxa_port *) tty->driver_data;
 	ts = tty->termios;
@@ -924,8 +924,15 @@ static void moxa_set_tty_param(struct tt
 		rxflow = 1;
 	if (ts->c_iflag & IXANY)
 		xany = 1;
+
+	/* Clear the features we don't support */
+	ts->c_cflag &= ~CMSPAR;
 	MoxaPortFlowCtrl(ch->port, rts, cts, txflow, rxflow, xany);
-	MoxaPortSetTermio(ch->port, ts, tty_get_baud_rate(tty));
+	baud = MoxaPortSetTermio(ch->port, ts, tty_get_baud_rate(tty));
+	if (baud == -1)
+		baud = tty_termios_baud_rate(old_termios);
+	/* Not put the baud rate into the termios data */
+	tty_encode_baud_rate(tty, baud, baud);
 }
 
 static int moxa_block_till_ready(struct tty_struct *tty, struct file *filp,
@@ -2065,7 +2072,7 @@ int MoxaPortSetTermio(int port, struct k
 		if (baud >= 921600L)
 			return (-1);
 	}
-	MoxaPortSetBaud(port, baud);
+	baud = MoxaPortSetBaud(port, baud);
 
 	if (termio->c_iflag & (IXON | IXOFF | IXANY)) {
 		writeb(termio->c_cc[VSTART], ofsAddr + FuncArg);
@@ -2074,7 +2081,7 @@ int MoxaPortSetTermio(int port, struct k
 		moxa_wait_finish(ofsAddr);
 
 	}
-	return (0);
+	return (baud);
 }
 
 int MoxaPortGetLineOut(int port, int *dtrState, int *rtsState)
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
hci_ldisc-fix-null-pointer-deref.patch
parisc-new-termios-definitions.patch
git-sh.patch
git-watchdog.patch
