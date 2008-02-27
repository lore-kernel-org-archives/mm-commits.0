From: akpm@linux-foundation.org
Subject: + char-moxa-timer-cleanup.patch added to -mm tree
Date: Wed, 27 Feb 2008 15:13:10 -0800
Message-ID: <200802272313.m1RNDAx8003269@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34523 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760444AbYB0XVP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 18:21:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, Oyvind.Aabling@uni-c.dk


The patch titled
     Char: moxa, timer cleanup
has been added to the -mm tree.  Its filename is
     char-moxa-timer-cleanup.patch

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
@@ -1284,10 +1284,10 @@ static void moxa_hangup(struct tty_struc
 
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
 
@@ -1295,36 +1295,38 @@ static void moxa_poll(unsigned long igno
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
@@ -1670,15 +1672,14 @@ copy:
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
@@ -1728,19 +1729,8 @@ int MoxaDriverPoll(void)
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
@@ -1811,16 +1801,6 @@ int MoxaPortsOfCard(int cardno)
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
