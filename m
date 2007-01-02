From: akpm@osdl.org
Subject: - char-isicom-eliminate-spinlock-recursion.patch removed from -mm tree
Date: Mon, 01 Jan 2007 23:24:14 -0800
Message-ID: <200701020724.l027OE5a012930@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37275 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932739AbXABHYR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 02:24:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: isicom, eliminate spinlock recursion
has been removed from the -mm tree.  Its filename was
     char-isicom-eliminate-spinlock-recursion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: isicom, eliminate spinlock recursion
From: Jiri Slaby <jirislaby@gmail.com>

Many spinlock recursion was in the isicom driver.  Eliminate it.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/isicom.c |  103 +++++++++++++++++++---------------------
 1 file changed, 51 insertions(+), 52 deletions(-)

diff -puN drivers/char/isicom.c~char-isicom-eliminate-spinlock-recursion drivers/char/isicom.c
--- a/drivers/char/isicom.c~char-isicom-eliminate-spinlock-recursion
+++ a/drivers/char/isicom.c
@@ -230,6 +230,20 @@ static struct isi_port  isi_ports[PORT_C
  *	it wants to talk.
  */
 
+static inline int WaitTillCardIsFree(u16 base)
+{
+	unsigned int count = 0;
+	unsigned int a = in_atomic(); /* do we run under spinlock? */
+
+	while (!(inw(base + 0xe) & 0x1) && count++ < 100)
+		if (a)
+			mdelay(1);
+		else
+			msleep(1);
+
+	return !(inw(base + 0xe) & 0x1);
+}
+
 static int lock_card(struct isi_board *card)
 {
 	char		retries;
@@ -276,69 +290,71 @@ static void unlock_card(struct isi_board
  *  ISI Card specific ops ...
  */
 
+/* card->lock HAS to be held */
 static void raise_dtr(struct isi_port *port)
 {
 	struct isi_board *card = port->card;
 	unsigned long base = card->base;
 	u16 channel = port->channel;
 
-	if (!lock_card(card))
+	if (WaitTillCardIsFree(base))
 		return;
 
 	outw(0x8000 | (channel << card->shift_count) | 0x02, base);
 	outw(0x0504, base);
 	InterruptTheCard(base);
 	port->status |= ISI_DTR;
-	unlock_card(card);
 }
 
+/* card->lock HAS to be held */
 static inline void drop_dtr(struct isi_port *port)
 {
 	struct isi_board *card = port->card;
 	unsigned long base = card->base;
 	u16 channel = port->channel;
 
-	if (!lock_card(card))
+	if (WaitTillCardIsFree(base))
 		return;
 
 	outw(0x8000 | (channel << card->shift_count) | 0x02, base);
 	outw(0x0404, base);
 	InterruptTheCard(base);
 	port->status &= ~ISI_DTR;
-	unlock_card(card);
 }
 
+/* card->lock HAS to be held */
 static inline void raise_rts(struct isi_port *port)
 {
 	struct isi_board *card = port->card;
 	unsigned long base = card->base;
 	u16 channel = port->channel;
 
-	if (!lock_card(card))
+	if (WaitTillCardIsFree(base))
 		return;
 
 	outw(0x8000 | (channel << card->shift_count) | 0x02, base);
 	outw(0x0a04, base);
 	InterruptTheCard(base);
 	port->status |= ISI_RTS;
-	unlock_card(card);
 }
+
+/* card->lock HAS to be held */
 static inline void drop_rts(struct isi_port *port)
 {
 	struct isi_board *card = port->card;
 	unsigned long base = card->base;
 	u16 channel = port->channel;
 
-	if (!lock_card(card))
+	if (WaitTillCardIsFree(base))
 		return;
 
 	outw(0x8000 | (channel << card->shift_count) | 0x02, base);
 	outw(0x0804, base);
 	InterruptTheCard(base);
 	port->status &= ~ISI_RTS;
-	unlock_card(card);
 }
 
+/* card->lock MUST NOT be held */
 static inline void raise_dtr_rts(struct isi_port *port)
 {
 	struct isi_board *card = port->card;
@@ -355,35 +371,20 @@ static inline void raise_dtr_rts(struct 
 	unlock_card(card);
 }
 
+/* card->lock HAS to be held */
 static void drop_dtr_rts(struct isi_port *port)
 {
 	struct isi_board *card = port->card;
 	unsigned long base = card->base;
 	u16 channel = port->channel;
 
-	if (!lock_card(card))
+	if (WaitTillCardIsFree(base))
 		return;
 
 	outw(0x8000 | (channel << card->shift_count) | 0x02, base);
 	outw(0x0c04, base);
 	InterruptTheCard(base);
 	port->status &= ~(ISI_RTS | ISI_DTR);
-	unlock_card(card);
-}
-
-static inline void kill_queue(struct isi_port *port, short queue)
-{
-	struct isi_board *card = port->card;
-	unsigned long base = card->base;
-	u16 channel = port->channel;
-
-	if (!lock_card(card))
-		return;
-
-	outw(0x8000 | (channel << card->shift_count) | 0x02, base);
-	outw((queue << 8) | 0x06, base);
-	InterruptTheCard(base);
-	unlock_card(card);
 }
 
 /*
@@ -744,7 +745,7 @@ static void isicom_config_port(struct is
 	else
 		raise_dtr(port);
 
-	if (lock_card(card)) {
+	if (WaitTillCardIsFree(base) == 0) {
 		outw(0x8000 | (channel << shift_count) |0x03, base);
 		outw(linuxb_to_isib[baud] << 8 | 0x03, base);
 		channel_setup = 0;
@@ -772,7 +773,6 @@ static void isicom_config_port(struct is
 		}
 		outw(channel_setup, base);
 		InterruptTheCard(base);
-		unlock_card(card);
 	}
 	if (C_CLOCAL(tty))
 		port->flags &= ~ASYNC_CHECK_CD;
@@ -791,12 +791,11 @@ static void isicom_config_port(struct is
 	if (I_IXOFF(tty))
 		flow_ctrl |= ISICOM_INITIATE_XONXOFF;
 
-	if (lock_card(card)) {
+	if (WaitTillCardIsFree(base) == 0) {
 		outw(0x8000 | (channel << shift_count) |0x04, base);
 		outw(flow_ctrl << 8 | 0x05, base);
 		outw((STOP_CHAR(tty)) << 8 | (START_CHAR(tty)), base);
 		InterruptTheCard(base);
-		unlock_card(card);
 	}
 
 	/*	rx enabled -> enable port for rx on the card	*/
@@ -821,10 +820,9 @@ static inline void isicom_setup_board(st
 	}
 	port = bp->ports;
 	bp->status |= BOARD_ACTIVE;
-	spin_unlock_irqrestore(&bp->card_lock, flags);
 	for (channel = 0; channel < bp->port_count; channel++, port++)
 		drop_dtr_rts(port);
-	return;
+	spin_unlock_irqrestore(&bp->card_lock, flags);
 }
 
 static int isicom_setup_port(struct isi_port *port)
@@ -857,7 +855,12 @@ static int isicom_setup_port(struct isi_
 	port->xmit_cnt = port->xmit_head = port->xmit_tail = 0;
 
 	/*	discard any residual data	*/
-	kill_queue(port, ISICOM_KILLTX | ISICOM_KILLRX);
+	if (WaitTillCardIsFree(card->base) == 0) {
+		outw(0x8000 | (port->channel << card->shift_count) | 0x02,
+				card->base);
+		outw(((ISICOM_KILLTX | ISICOM_KILLRX) << 8) | 0x06, card->base);
+		InterruptTheCard(card->base);
+	}
 
 	isicom_config_port(port);
 	port->flags |= ASYNC_INITIALIZED;
@@ -983,28 +986,22 @@ static int isicom_open(struct tty_struct
 
 static inline void isicom_shutdown_board(struct isi_board *bp)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&bp->card_lock, flags);
 	if (bp->status & BOARD_ACTIVE) {
 		bp->status &= ~BOARD_ACTIVE;
 	}
-	spin_unlock_irqrestore(&bp->card_lock, flags);
 }
 
+/* card->lock HAS to be held */
 static void isicom_shutdown_port(struct isi_port *port)
 {
 	struct isi_board *card = port->card;
 	struct tty_struct *tty;
-	unsigned long flags;
 
 	tty = port->tty;
 
-	spin_lock_irqsave(&card->card_lock, flags);
-	if (!(port->flags & ASYNC_INITIALIZED)) {
-		spin_unlock_irqrestore(&card->card_lock, flags);
+	if (!(port->flags & ASYNC_INITIALIZED))
 		return;
-	}
+
 	if (port->xmit_buf) {
 		free_page((unsigned long) port->xmit_buf);
 		port->xmit_buf = NULL;
@@ -1012,7 +1009,6 @@ static void isicom_shutdown_port(struct 
 	port->flags &= ~ASYNC_INITIALIZED;
 	/* 3rd October 2000 : Vinayak P Risbud */
 	port->tty = NULL;
-	spin_unlock_irqrestore(&card->card_lock, flags);
 
 	/*Fix done by Anil .S on 30-04-2001
 	remote login through isi port has dtr toggle problem
@@ -1258,10 +1254,12 @@ static int isicom_tiocmset(struct tty_st
 	unsigned int set, unsigned int clear)
 {
 	struct isi_port *port = tty->driver_data;
+	unsigned long flags;
 
 	if (isicom_paranoia_check(port, tty->name, "isicom_ioctl"))
 		return -ENODEV;
 
+	spin_lock_irqsave(&port->card->card_lock, flags);
 	if (set & TIOCM_RTS)
 		raise_rts(port);
 	if (set & TIOCM_DTR)
@@ -1271,6 +1269,7 @@ static int isicom_tiocmset(struct tty_st
 		drop_rts(port);
 	if (clear & TIOCM_DTR)
 		drop_dtr(port);
+	spin_unlock_irqrestore(&port->card->card_lock, flags);
 
 	return 0;
 }
@@ -1303,7 +1302,10 @@ static int isicom_set_serial_info(struct
 				(newinfo.flags & ASYNC_FLAGS));
 	}
 	if (reconfig_port) {
+		unsigned long flags;
+		spin_lock_irqsave(&port->card->card_lock, flags);
 		isicom_config_port(port);
+		spin_unlock_irqrestore(&port->card->card_lock, flags);
 	}
 	return 0;
 }
@@ -1384,6 +1386,7 @@ static void isicom_set_termios(struct tt
 	struct ktermios *old_termios)
 {
 	struct isi_port *port = tty->driver_data;
+	unsigned long flags;
 
 	if (isicom_paranoia_check(port, tty->name, "isicom_set_termios"))
 		return;
@@ -1392,7 +1395,9 @@ static void isicom_set_termios(struct tt
 			tty->termios->c_iflag == old_termios->c_iflag)
 		return;
 
+	spin_lock_irqsave(&port->card->card_lock, flags);
 	isicom_config_port(port);
+	spin_unlock_irqrestore(&port->card->card_lock, flags);
 
 	if ((old_termios->c_cflag & CRTSCTS) &&
 			!(tty->termios->c_cflag & CRTSCTS)) {
@@ -1469,11 +1474,15 @@ static void do_isicom_hangup(struct work
 static void isicom_hangup(struct tty_struct *tty)
 {
 	struct isi_port *port = tty->driver_data;
+	unsigned long flags;
 
 	if (isicom_paranoia_check(port, tty->name, "isicom_hangup"))
 		return;
 
+	spin_lock_irqsave(&port->card->card_lock, flags);
 	isicom_shutdown_port(port);
+	spin_unlock_irqrestore(&port->card->card_lock, flags);
+
 	port->count = 0;
 	port->flags &= ~ASYNC_NORMAL_ACTIVE;
 	port->tty = NULL;
@@ -1578,16 +1587,6 @@ end:
 	return retval;
 }
 
-static inline int WaitTillCardIsFree(u16 base)
-{
-	unsigned long count = 0;
-
-	while (!(inw(base + 0xe) & 0x1) && count++ < 100)
-		msleep(5);
-
-	return !(inw(base + 0xe) & 0x1);
-}
-
 static int __devinit load_firmware(struct pci_dev *pdev,
 	const unsigned int index, const unsigned int signature)
 {
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
shrink_slab-handle-bad-shrinkers.patch
