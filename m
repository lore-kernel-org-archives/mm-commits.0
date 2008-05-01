From: akpm@linux-foundation.org
Subject: - char-moxa-timer-cleanup.patch removed from -mm tree
Date: Thu, 01 May 2008 02:29:12 -0700
Message-ID: <200805010929.m419TCsq030653@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45514 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757130AbYEAJ3Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:29:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, Oyvind.Aabling@uni-c.dk, mm-commits@vger.kernel.org


The patch titled
     Char: moxa, timer cleanup
has been removed from the -mm tree.  Its filename was
     char-moxa-timer-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: moxa, timer cleanup
From: Jiri Slaby <jirislaby@gmail.com>

- schedule timer even after some card is installed, not after insmod
- cleanup timer functions

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Tested-by: Oyvind Aabling <Oyvind.Aabling@uni-c.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/moxa.c |   62 ++++++++++++++----------------------------
 1 file changed, 21 insertions(+), 41 deletions(-)

diff -puN drivers/char/moxa.c~char-moxa-timer-cleanup drivers/char/moxa.c
--- a/drivers/char/moxa.c~char-moxa-timer-cleanup
+++ a/drivers/char/moxa.c
@@ -215,7 +215,6 @@ static void moxa_receive_data(struct mox
  */
 static int MoxaDriverIoctl(struct tty_struct *, unsigned int, unsigned long);
 static int MoxaDriverPoll(void);
-static int MoxaPortsOfCard(int);
 static void MoxaPortEnable(struct moxa_port *);
 static void MoxaPortDisable(struct moxa_port *);
 static int MoxaPortSetTermio(struct moxa_port *, struct ktermios *, speed_t);
@@ -715,6 +714,9 @@ static int moxa_init_board(struct moxa_b
 
 	brd->ready = 1;
 
+	if (!timer_pending(&moxaTimer))
+		mod_timer(&moxaTimer, jiffies + HZ / 50);
+
 	return 0;
 err_free:
 	kfree(brd->ports);
@@ -856,8 +858,6 @@ static int __init moxa_init(void)
 		return -1;
 	}
 
-	mod_timer(&moxaTimer, jiffies + HZ / 50);
-
 	/* Find the boards defined from module args. */
 #ifdef MODULE
 	{
@@ -1285,10 +1285,10 @@ static void moxa_hangup(struct tty_struc
 
 static void moxa_poll(unsigned long ignored)
 {
-	register int card;
 	struct moxa_port *ch;
-	struct tty_struct *tp;
-	int i, ports;
+	struct tty_struct *tty;
+	unsigned int card;
+	int i;
 
 	del_timer(&moxaTimer);
 
@@ -1296,36 +1296,38 @@ static void moxa_poll(unsigned long igno
 		mod_timer(&moxaTimer, jiffies + HZ / 50);
 		return;
 	}
+
 	for (card = 0; card < MAX_BOARDS; card++) {
-		if ((ports = MoxaPortsOfCard(card)) <= 0)
+		if (!moxa_boards[card].ready)
 			continue;
 		ch = moxa_boards[card].ports;
-		for (i = 0; i < ports; i++, ch++) {
+		for (i = 0; i < moxa_boards[card].numPorts; i++, ch++) {
 			if ((ch->asyncflags & ASYNC_INITIALIZED) == 0)
 				continue;
 			if (!(ch->statusflags & THROTTLE) &&
 			    (MoxaPortRxQueue(ch) > 0))
 				moxa_receive_data(ch);
-			if ((tp = ch->tty) == 0)
+			tty = ch->tty;
+			if (tty == NULL)
 				continue;
 			if (ch->statusflags & LOWWAIT) {
 				if (MoxaPortTxQueue(ch) <= WAKEUP_CHARS) {
-					if (!tp->stopped) {
+					if (!tty->stopped) {
 						ch->statusflags &= ~LOWWAIT;
-						tty_wakeup(tp);
+						tty_wakeup(tty);
 					}
 				}
 			}
-			if (!I_IGNBRK(tp) && (MoxaPortResetBrkCnt(ch) > 0)) {
-				tty_insert_flip_char(tp, 0, TTY_BREAK);
-				tty_schedule_flip(tp);
+			if (!I_IGNBRK(tty) && (MoxaPortResetBrkCnt(ch) > 0)) {
+				tty_insert_flip_char(tty, 0, TTY_BREAK);
+				tty_schedule_flip(tty);
 			}
 			if (MoxaPortDCDChange(ch)) {
 				if (ch->asyncflags & ASYNC_CHECK_CD) {
 					if (MoxaPortDCDON(ch))
 						wake_up_interruptible(&ch->open_wait);
 					else {
-						tty_hangup(tp);
+						tty_hangup(tty);
 						wake_up_interruptible(&ch->open_wait);
 						ch->asyncflags &= ~ASYNC_NORMAL_ACTIVE;
 					}
@@ -1671,15 +1673,14 @@ copy:
 	return -ENOIOCTLCMD;
 }
 
-int MoxaDriverPoll(void)
+static int MoxaDriverPoll(void)
 {
 	struct moxa_board_conf *brd;
 	struct moxa_port *p;
-	register ushort temp;
-	register int card;
 	void __iomem *ofsAddr;
 	void __iomem *ip;
-	int port, ports;
+	unsigned int port, ports, card;
+	ushort temp;
 
 	for (card = 0; card < MAX_BOARDS; card++) {
 		brd = &moxa_boards[card];
@@ -1729,19 +1730,8 @@ int MoxaDriverPoll(void)
 		}
 	}
 	moxaLowWaterChk = 0;
-	return (0);
-}
-
-/*****************************************************************************
- *	Card level function:						     *
- *	1. MoxaPortsOfCard(int cardno); 				     *
- *****************************************************************************/
-int MoxaPortsOfCard(int cardno)
-{
 
-	if (moxa_boards[cardno].boardType == 0)
-		return (0);
-	return (moxa_boards[cardno].numPorts);
+	return 0;
 }
 
 /*****************************************************************************
@@ -1812,16 +1802,6 @@ int MoxaPortsOfCard(int cardno)
  *                      -1      : no any Moxa card.             
  *
  *
- *      Function 4:     Get the ports of this card.
- *      Syntax:
- *      int  MoxaPortsOfCard(int cardno);
- *
- *           int cardno         : card number (0 - 3)
- *
- *           return:    0       : this card is invalid
- *                      8/16/24/32
- *
- *
  *      Function 6:     Enable this port to start Tx/Rx data.
  *      Syntax:
  *      void MoxaPortEnable(int port);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

