From: akpm@linux-foundation.org
Subject: + char-isicom-cleanup-locking.patch added to -mm tree
Date: Sun, 20 May 2007 21:19:51 -0700
Message-ID: <200705210419.l4L4Jo8G002211@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48481 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753191AbXEUEVh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 00:21:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: isicom, cleanup locking
has been added to the -mm tree.  Its filename is
     char-isicom-cleanup-locking.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: isicom, cleanup locking
From: Jiri Slaby <jirislaby@gmail.com>

Don't spin processor when not needed (use sleep instead of delay).  Don't
release the lock when needed in next iteration -- this actually fixes a bug --
missing braces

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/isicom.c |   65 ++++++++++++++++------------------------
 1 file changed, 27 insertions(+), 38 deletions(-)

diff -puN drivers/char/isicom.c~char-isicom-cleanup-locking drivers/char/isicom.c
--- a/drivers/char/isicom.c~char-isicom-cleanup-locking
+++ a/drivers/char/isicom.c
@@ -243,17 +243,18 @@ static inline int WaitTillCardIsFree(u16
 
 static int lock_card(struct isi_board *card)
 {
-	char		retries;
 	unsigned long base = card->base;
+	unsigned int retries, a;
 
-	for (retries = 0; retries < 100; retries++) {
+	for (retries = 0; retries < 10; retries++) {
 		spin_lock_irqsave(&card->card_lock, card->flags);
-		if (inw(base + 0xe) & 0x1) {
-			return 1;
-		} else {
-			spin_unlock_irqrestore(&card->card_lock, card->flags);
-			udelay(1000);   /* 1ms */
+		for (a = 0; a < 10; a++) {
+			if (inw(base + 0xe) & 0x1)
+				return 1;
+			udelay(10);
 		}
+		spin_unlock_irqrestore(&card->card_lock, card->flags);
+		msleep(10);
 	}
 	printk(KERN_WARNING "ISICOM: Failed to lock Card (0x%lx)\n",
 		card->base);
@@ -261,23 +262,6 @@ static int lock_card(struct isi_board *c
 	return 0;	/* Failed to acquire the card! */
 }
 
-static int lock_card_at_interrupt(struct isi_board *card)
-{
-	unsigned char		retries;
-	unsigned long base = card->base;
-
-	for (retries = 0; retries < 200; retries++) {
-		spin_lock_irqsave(&card->card_lock, card->flags);
-
-		if (inw(base + 0xe) & 0x1)
-			return 1;
-		else
-			spin_unlock_irqrestore(&card->card_lock, card->flags);
-	}
-	/* Failing in interrupt is an acceptable event */
-	return 0;	/* Failed to acquire the card! */
-}
-
 static void unlock_card(struct isi_board *card)
 {
 	spin_unlock_irqrestore(&card->card_lock, card->flags);
@@ -415,6 +399,8 @@ static inline int __isicom_paranoia_chec
 
 static void isicom_tx(unsigned long _data)
 {
+	unsigned long flags;
+	unsigned int retries;
 	short count = (BOARD_COUNT-1), card, base;
 	short txcount, wrd, residue, word_count, cnt;
 	struct isi_port *port;
@@ -435,32 +421,34 @@ static void isicom_tx(unsigned long _dat
 	count = isi_card[card].port_count;
 	port = isi_card[card].ports;
 	base = isi_card[card].base;
+
+	spin_lock_irqsave(&isi_card[card].card_lock, flags);
+	for (retries = 0; retries < 100; retries++) {
+		if (inw(base + 0xe) & 0x1)
+			break;
+		udelay(2);
+	}
+	if (retries >= 100)
+		goto unlock;
+
 	for (;count > 0;count--, port++) {
-		if (!lock_card_at_interrupt(&isi_card[card]))
-			continue;
 		/* port not active or tx disabled to force flow control */
 		if (!(port->flags & ASYNC_INITIALIZED) ||
 				!(port->status & ISI_TXOK))
-			unlock_card(&isi_card[card]);
 			continue;
 
 		tty = port->tty;
 
-
-		if (tty == NULL) {
-			unlock_card(&isi_card[card]);
+		if (tty == NULL)
 			continue;
-		}
 
 		txcount = min_t(short, TX_SIZE, port->xmit_cnt);
-		if (txcount <= 0 || tty->stopped || tty->hw_stopped) {
-			unlock_card(&isi_card[card]);
+		if (txcount <= 0 || tty->stopped || tty->hw_stopped)
 			continue;
-		}
-		if (!(inw(base + 0x02) & (1 << port->channel))) {
-			unlock_card(&isi_card[card]);
+
+		if (!(inw(base + 0x02) & (1 << port->channel)))
 			continue;
-		}
+
 		pr_dbg("txing %d bytes, port%d.\n", txcount,
 			port->channel + 1);
 		outw((port->channel << isi_card[card].shift_count) | txcount,
@@ -508,9 +496,10 @@ static void isicom_tx(unsigned long _dat
 			port->status &= ~ISI_TXOK;
 		if (port->xmit_cnt <= WAKEUP_CHARS)
 			tty_wakeup(tty);
-		unlock_card(&isi_card[card]);
 	}
 
+unlock:
+	spin_unlock_irqrestore(&isi_card[card].card_lock, flags);
 	/*	schedule another tx for hopefully in about 10ms	*/
 sched_again:
 	if (!re_schedule) {
_

Patches currently in -mm which might be from jirislaby@gmail.com are

cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
char-cyclades-fix-deadlock.patch
misc-phantom-move-to-unlocked_ioctl.patch
misc-misc-phantom-move-to-unlocked_ioctl-fix.patch
misc-phantom-take-care-of-pci-posting.patch
char-cyclades-add-firmware-loading.patch
char-cyclades-fix-sparse-warning.patch
char-isicom-cleanup-locking.patch
char-isicom-del_timer-at-exit.patch
char-isicom-proper-variables-types.patch
shrink_slab-handle-bad-shrinkers.patch
