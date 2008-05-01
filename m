From: akpm@linux-foundation.org
Subject: - tty-serial-lay-the-foundations-for-the-next-set-of-reworks.patch removed from -mm tree
Date: Thu, 01 May 2008 02:30:03 -0700
Message-ID: <200805010930.m419U3LP030736@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43429 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754926AbYEAJa3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:30:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     tty/serial: lay the foundations for the next set of reworks
has been removed from the -mm tree.  Its filename was
     tty-serial-lay-the-foundations-for-the-next-set-of-reworks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tty/serial: lay the foundations for the next set of reworks
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

- Stop drivers calling their own flush method indirectly, it obfuscates code
  and it will change soon anyway

- A few more lock_kernel paths temporarily needed in some driver internal
  waiting code

- Remove private put_char method that does a write call for one char - we
  have that anyway

- Most but not yet all of the termios copy under lock fixing (some has other
  dependencies to follow)

- Note a few locking bugs in drivers found in the process

- Kill remaining [ab]users of TIOCG/SSOFTCAR in the driver, these must go to
  fix the termios locking

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/amiserial.c          |    6 +-
 drivers/char/cyclades.c           |   76 ++++++++++++++--------------
 drivers/char/epca.c               |   13 ----
 drivers/char/esp.c                |    3 -
 drivers/char/generic_serial.c     |    3 -
 drivers/char/isicom.c             |   35 ++++++------
 drivers/char/moxa.c               |    2 
 drivers/char/mxser.c              |   47 ++++++++---------
 drivers/char/nozomi.c             |   13 ----
 drivers/char/pcmcia/synclink_cs.c |   16 -----
 drivers/char/riscom8.c            |   38 +++++++-------
 drivers/char/rocket.c             |    2 
 drivers/char/serial167.c          |    3 -
 drivers/char/specialix.c          |   46 ++++++++--------
 drivers/char/stallion.c           |    2 
 drivers/char/synclink.c           |    7 +-
 drivers/char/synclink_gt.c        |    6 +-
 drivers/char/synclinkmp.c         |    8 ++
 drivers/char/tty_io.c             |    2 
 drivers/char/tty_ioctl.c          |   14 ++++-
 drivers/isdn/i4l/isdn_tty.c       |    4 -
 drivers/serial/68328serial.c      |   18 ------
 drivers/serial/68360serial.c      |   17 +-----
 drivers/serial/crisv10.c          |   23 ++++----
 drivers/serial/mcfserial.c        |   18 +-----
 drivers/serial/netx-serial.c      |    1 
 26 files changed, 189 insertions(+), 234 deletions(-)

diff -puN drivers/char/amiserial.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks drivers/char/amiserial.c
--- a/drivers/char/amiserial.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks
+++ a/drivers/char/amiserial.c
@@ -1505,8 +1505,7 @@ static void rs_close(struct tty_struct *
 		rs_wait_until_sent(tty, info->timeout);
 	}
 	shutdown(info);
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
+	rs_flush_buffer(tty);
 		
 	tty_ldisc_flush(tty);
 	tty->closing = 0;
@@ -1539,6 +1538,8 @@ static void rs_wait_until_sent(struct tt
 		return; /* Just in case.... */
 
 	orig_jiffies = jiffies;
+
+	lock_kernel();
 	/*
 	 * Set the check interval to be 1/5 of the estimated time to
 	 * send a single character, and make it at least 1.  The check
@@ -1579,6 +1580,7 @@ static void rs_wait_until_sent(struct tt
 			break;
 	}
 	__set_current_state(TASK_RUNNING);
+	unlock_kernel();
 #ifdef SERIAL_DEBUG_RS_WAIT_UNTIL_SENT
 	printk("lsr = %d (jiff=%lu)...done\n", lsr, jiffies);
 #endif
diff -puN drivers/char/cyclades.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks
+++ a/drivers/char/cyclades.c
@@ -2522,6 +2522,7 @@ static void cy_wait_until_sent(struct tt
 		return;		/* Just in case.... */
 
 	orig_jiffies = jiffies;
+	lock_kernel();
 	/*
 	 * Set the check interval to be 1/5 of the estimated time to
 	 * send a single character, and make it at least 1.  The check
@@ -2573,11 +2574,47 @@ static void cy_wait_until_sent(struct tt
 	}
 	/* Run one more char cycle */
 	msleep_interruptible(jiffies_to_msecs(char_time * 5));
+	unlock_kernel();
 #ifdef CY_DEBUG_WAIT_UNTIL_SENT
 	printk(KERN_DEBUG "Clean (jiff=%lu)...done\n", jiffies);
 #endif
 }
 
+static void cy_flush_buffer(struct tty_struct *tty)
+{
+	struct cyclades_port *info = tty->driver_data;
+	struct cyclades_card *card;
+	int channel, retval;
+	unsigned long flags;
+
+#ifdef CY_DEBUG_IO
+	printk(KERN_DEBUG "cyc:cy_flush_buffer ttyC%d\n", info->line);
+#endif
+
+	if (serial_paranoia_check(info, tty->name, "cy_flush_buffer"))
+		return;
+
+	card = info->card;
+	channel = info->line - card->first_line;
+
+	spin_lock_irqsave(&card->card_lock, flags);
+	info->xmit_cnt = info->xmit_head = info->xmit_tail = 0;
+	spin_unlock_irqrestore(&card->card_lock, flags);
+
+	if (IS_CYC_Z(*card)) {	/* If it is a Z card, flush the on-board
+					   buffers as well */
+		spin_lock_irqsave(&card->card_lock, flags);
+		retval = cyz_issue_cmd(card, channel, C_CM_FLUSH_TX, 0L);
+		if (retval != 0) {
+			printk(KERN_ERR "cyc: flush_buffer retval on ttyC%d "
+				"was %x\n", info->line, retval);
+		}
+		spin_unlock_irqrestore(&card->card_lock, flags);
+	}
+	tty_wakeup(tty);
+}				/* cy_flush_buffer */
+
+
 /*
  * This routine is called when a particular tty device is closed.
  */
@@ -2689,8 +2726,7 @@ static void cy_close(struct tty_struct *
 
 	spin_unlock_irqrestore(&card->card_lock, flags);
 	shutdown(info);
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
+	cy_flush_buffer(tty);
 	tty_ldisc_flush(tty);
 	spin_lock_irqsave(&card->card_lock, flags);
 
@@ -2881,6 +2917,7 @@ static int cy_chars_in_buffer(struct tty
 		int char_count;
 		__u32 tx_put, tx_get, tx_bufsize;
 
+		lock_kernel();
 		firm_id = card->base_addr + ID_ADDRESS;
 		zfw_ctrl = card->base_addr +
 			(readl(&firm_id->zfwctrl_addr) & 0xfffff);
@@ -2898,6 +2935,7 @@ static int cy_chars_in_buffer(struct tty
 		printk(KERN_DEBUG "cyc:cy_chars_in_buffer ttyC%d %d\n",
 			info->line, info->xmit_cnt + char_count);
 #endif
+		unlock_kernel();
 		return info->xmit_cnt + char_count;
 	}
 #endif				/* Z_EXT_CHARS_IN_BUFFER */
@@ -4271,40 +4309,6 @@ static void cy_start(struct tty_struct *
 	}
 }				/* cy_start */
 
-static void cy_flush_buffer(struct tty_struct *tty)
-{
-	struct cyclades_port *info = tty->driver_data;
-	struct cyclades_card *card;
-	int channel, retval;
-	unsigned long flags;
-
-#ifdef CY_DEBUG_IO
-	printk(KERN_DEBUG "cyc:cy_flush_buffer ttyC%d\n", info->line);
-#endif
-
-	if (serial_paranoia_check(info, tty->name, "cy_flush_buffer"))
-		return;
-
-	card = info->card;
-	channel = info->line - card->first_line;
-
-	spin_lock_irqsave(&card->card_lock, flags);
-	info->xmit_cnt = info->xmit_head = info->xmit_tail = 0;
-	spin_unlock_irqrestore(&card->card_lock, flags);
-
-	if (IS_CYC_Z(*card)) {	/* If it is a Z card, flush the on-board
-					   buffers as well */
-		spin_lock_irqsave(&card->card_lock, flags);
-		retval = cyz_issue_cmd(card, channel, C_CM_FLUSH_TX, 0L);
-		if (retval != 0) {
-			printk(KERN_ERR "cyc: flush_buffer retval on ttyC%d "
-				"was %x\n", info->line, retval);
-		}
-		spin_unlock_irqrestore(&card->card_lock, flags);
-	}
-	tty_wakeup(tty);
-}				/* cy_flush_buffer */
-
 /*
  * cy_hangup() --- called by tty_hangup() when a hangup is signaled.
  */
diff -puN drivers/char/epca.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks drivers/char/epca.c
--- a/drivers/char/epca.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks
+++ a/drivers/char/epca.c
@@ -157,7 +157,6 @@ static void epca_error(int, char *);
 static void pc_close(struct tty_struct *, struct file *);
 static void shutdown(struct channel *);
 static void pc_hangup(struct tty_struct *);
-static void pc_put_char(struct tty_struct *, unsigned char);
 static int pc_write_room(struct tty_struct *);
 static int pc_chars_in_buffer(struct tty_struct *);
 static void pc_flush_buffer(struct tty_struct *);
@@ -459,8 +458,7 @@ static void pc_close(struct tty_struct *
 			setup_empty_event(tty, ch);
 			tty_wait_until_sent(tty, 3000); /* 30 seconds timeout */
 		}
-		if (tty->driver->flush_buffer)
-			tty->driver->flush_buffer(tty);
+		pc_flush_buffer(tty);
 
 		tty_ldisc_flush(tty);
 		shutdown(ch);
@@ -532,8 +530,7 @@ static void pc_hangup(struct tty_struct 
 	if ((ch = verifyChannel(tty)) != NULL) {
 		unsigned long flags;
 
-		if (tty->driver->flush_buffer)
-			tty->driver->flush_buffer(tty);
+		pc_flush_buffer(tty);
 		tty_ldisc_flush(tty);
 		shutdown(ch);
 
@@ -645,11 +642,6 @@ static int pc_write(struct tty_struct *t
 	return amountCopied;
 }
 
-static void pc_put_char(struct tty_struct *tty, unsigned char c)
-{
-	pc_write(tty, &c, 1);
-}
-
 static int pc_write_room(struct tty_struct *tty)
 {
 	int remain;
@@ -1035,7 +1027,6 @@ static const struct tty_operations pc_op
 	.flush_buffer = pc_flush_buffer,
 	.chars_in_buffer = pc_chars_in_buffer,
 	.flush_chars = pc_flush_chars,
-	.put_char = pc_put_char,
 	.ioctl = pc_ioctl,
 	.set_termios = pc_set_termios,
 	.stop = pc_stop,
diff -puN drivers/char/esp.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks drivers/char/esp.c
--- a/drivers/char/esp.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks
+++ a/drivers/char/esp.c
@@ -1994,8 +1994,7 @@ static void rs_close(struct tty_struct *
 		rs_wait_until_sent(tty, info->timeout);
 	}
 	shutdown(info);
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
+	rs_flush_buffer(tty);
 	tty_ldisc_flush(tty);
 	tty->closing = 0;
 	info->tty = NULL;
diff -puN drivers/char/generic_serial.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks drivers/char/generic_serial.c
--- a/drivers/char/generic_serial.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks
+++ a/drivers/char/generic_serial.c
@@ -586,8 +586,7 @@ void gs_close(struct tty_struct * tty, s
 
 	port->flags &= ~GS_ACTIVE;
 
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
+	gs_flush_buffer(tty);
 
 	tty_ldisc_flush(tty);
 	tty->closing = 0;
diff -puN drivers/char/isicom.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks drivers/char/isicom.c
--- a/drivers/char/isicom.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks
+++ a/drivers/char/isicom.c
@@ -1012,6 +1012,22 @@ static void isicom_shutdown_port(struct 
 	}
 }
 
+static void isicom_flush_buffer(struct tty_struct *tty)
+{
+	struct isi_port *port = tty->driver_data;
+	struct isi_board *card = port->card;
+	unsigned long flags;
+
+	if (isicom_paranoia_check(port, tty->name, "isicom_flush_buffer"))
+		return;
+
+	spin_lock_irqsave(&card->card_lock, flags);
+	port->xmit_cnt = port->xmit_head = port->xmit_tail = 0;
+	spin_unlock_irqrestore(&card->card_lock, flags);
+
+	tty_wakeup(tty);
+}
+
 static void isicom_close(struct tty_struct *tty, struct file *filp)
 {
 	struct isi_port *port = tty->driver_data;
@@ -1065,8 +1081,7 @@ static void isicom_close(struct tty_stru
 	isicom_shutdown_port(port);
 	spin_unlock_irqrestore(&card->card_lock, flags);
 
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
+	isicom_flush_buffer(tty);
 	tty_ldisc_flush(tty);
 
 	spin_lock_irqsave(&card->card_lock, flags);
@@ -1447,22 +1462,6 @@ static void isicom_hangup(struct tty_str
 	wake_up_interruptible(&port->open_wait);
 }
 
-/* flush_buffer et all */
-static void isicom_flush_buffer(struct tty_struct *tty)
-{
-	struct isi_port *port = tty->driver_data;
-	struct isi_board *card = port->card;
-	unsigned long flags;
-
-	if (isicom_paranoia_check(port, tty->name, "isicom_flush_buffer"))
-		return;
-
-	spin_lock_irqsave(&card->card_lock, flags);
-	port->xmit_cnt = port->xmit_head = port->xmit_tail = 0;
-	spin_unlock_irqrestore(&card->card_lock, flags);
-
-	tty_wakeup(tty);
-}
 
 /*
  * Driver init and deinit functions
diff -puN drivers/char/moxa.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks drivers/char/moxa.c
--- a/drivers/char/moxa.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks
+++ a/drivers/char/moxa.c
@@ -1280,6 +1280,7 @@ static int moxa_chars_in_buffer(struct t
 	 */
 	if (ch == NULL)
 		return 0;
+	lock_kernel();
 	chars = MoxaPortTxQueue(ch);
 	if (chars) {
 		/*
@@ -1289,6 +1290,7 @@ static int moxa_chars_in_buffer(struct t
 		if (!(ch->statusflags & EMPTYWAIT))
 			moxa_setup_empty_event(tty);
 	}
+	unlock_kernel();
 	return chars;
 }
 
diff -puN drivers/char/mxser.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks drivers/char/mxser.c
--- a/drivers/char/mxser.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks
+++ a/drivers/char/mxser.c
@@ -927,6 +927,27 @@ static int mxser_open(struct tty_struct 
 	return 0;
 }
 
+static void mxser_flush_buffer(struct tty_struct *tty)
+{
+	struct mxser_port *info = tty->driver_data;
+	char fcr;
+	unsigned long flags;
+
+
+	spin_lock_irqsave(&info->slock, flags);
+	info->xmit_cnt = info->xmit_head = info->xmit_tail = 0;
+
+	fcr = inb(info->ioaddr + UART_FCR);
+	outb((fcr | UART_FCR_CLEAR_RCVR | UART_FCR_CLEAR_XMIT),
+		info->ioaddr + UART_FCR);
+	outb(fcr, info->ioaddr + UART_FCR);
+
+	spin_unlock_irqrestore(&info->slock, flags);
+
+	tty_wakeup(tty);
+}
+
+
 /*
  * This routine is called when the serial port gets closed.  First, we
  * wait for the last remaining data to be sent.  Then, we unlink its
@@ -1013,9 +1034,7 @@ static void mxser_close(struct tty_struc
 	}
 	mxser_shutdown(info);
 
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
-
+	mxser_flush_buffer(tty);
 	tty_ldisc_flush(tty);
 
 	tty->closing = 0;
@@ -1142,26 +1161,6 @@ static int mxser_chars_in_buffer(struct 
 	return info->xmit_cnt;
 }
 
-static void mxser_flush_buffer(struct tty_struct *tty)
-{
-	struct mxser_port *info = tty->driver_data;
-	char fcr;
-	unsigned long flags;
-
-
-	spin_lock_irqsave(&info->slock, flags);
-	info->xmit_cnt = info->xmit_head = info->xmit_tail = 0;
-
-	fcr = inb(info->ioaddr + UART_FCR);
-	outb((fcr | UART_FCR_CLEAR_RCVR | UART_FCR_CLEAR_XMIT),
-		info->ioaddr + UART_FCR);
-	outb(fcr, info->ioaddr + UART_FCR);
-
-	spin_unlock_irqrestore(&info->slock, flags);
-
-	tty_wakeup(tty);
-}
-
 /*
  * ------------------------------------------------------------
  * friends of mxser_ioctl()
@@ -1992,6 +1991,7 @@ static void mxser_wait_until_sent(struct
 		timeout, char_time);
 	printk("jiff=%lu...", jiffies);
 #endif
+	lock_kernel();
 	while (!((lsr = inb(info->ioaddr + UART_LSR)) & UART_LSR_TEMT)) {
 #ifdef SERIAL_DEBUG_RS_WAIT_UNTIL_SENT
 		printk("lsr = %d (jiff=%lu)...", lsr, jiffies);
@@ -2003,6 +2003,7 @@ static void mxser_wait_until_sent(struct
 			break;
 	}
 	set_current_state(TASK_RUNNING);
+	unlock_kernel();
 
 #ifdef SERIAL_DEBUG_RS_WAIT_UNTIL_SENT
 	printk("lsr = %d (jiff=%lu)...done\n", lsr, jiffies);
diff -puN drivers/char/nozomi.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks drivers/char/nozomi.c
--- a/drivers/char/nozomi.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks
+++ a/drivers/char/nozomi.c
@@ -1724,6 +1724,8 @@ static int ntty_tiocmget(struct tty_stru
 	const struct ctrl_dl *ctrl_dl = &port->ctrl_dl;
 	const struct ctrl_ul *ctrl_ul = &port->ctrl_ul;
 
+	/* Note: these could change under us but it is not clear this
+	   matters if so */
 	return	(ctrl_ul->RTS ? TIOCM_RTS : 0) |
 		(ctrl_ul->DTR ? TIOCM_DTR : 0) |
 		(ctrl_dl->DCD ? TIOCM_CAR : 0) |
@@ -1849,16 +1851,6 @@ static void ntty_throttle(struct tty_str
 	spin_unlock_irqrestore(&dc->spin_mutex, flags);
 }
 
-/* just to discard single character writes */
-static void ntty_put_char(struct tty_struct *tty, unsigned char c)
-{
-	/*
-	 * card does not react correct when we write single chars
-	 * to the card, so we discard them
-	 */
-	DBG2("PUT CHAR Function: %c", c);
-}
-
 /* Returns number of chars in buffer, called by tty layer */
 static s32 ntty_chars_in_buffer(struct tty_struct *tty)
 {
@@ -1892,7 +1884,6 @@ static const struct tty_operations tty_o
 	.unthrottle = ntty_unthrottle,
 	.throttle = ntty_throttle,
 	.chars_in_buffer = ntty_chars_in_buffer,
-	.put_char = ntty_put_char,
 	.tiocmget = ntty_tiocmget,
 	.tiocmset = ntty_tiocmset,
 };
diff -puN drivers/char/pcmcia/synclink_cs.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks drivers/char/pcmcia/synclink_cs.c
--- a/drivers/char/pcmcia/synclink_cs.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks
+++ a/drivers/char/pcmcia/synclink_cs.c
@@ -503,20 +503,9 @@ static void* mgslpc_get_text_ptr(void)
  * The wrappers maintain line discipline references
  * while calling into the line discipline.
  *
- * ldisc_flush_buffer - flush line discipline receive buffers
  * ldisc_receive_buf  - pass receive data to line discipline
  */
 
-static void ldisc_flush_buffer(struct tty_struct *tty)
-{
-	struct tty_ldisc *ld = tty_ldisc_ref(tty);
-	if (ld) {
-		if (ld->flush_buffer)
-			ld->flush_buffer(tty);
-		tty_ldisc_deref(ld);
-	}
-}
-
 static void ldisc_receive_buf(struct tty_struct *tty,
 			      const __u8 *data, char *flags, int count)
 {
@@ -2467,10 +2456,9 @@ static void mgslpc_close(struct tty_stru
  	if (info->flags & ASYNC_INITIALIZED)
  		mgslpc_wait_until_sent(tty, info->timeout);
 
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
+	mgslpc_flush_buffer(tty);
 
-	ldisc_flush_buffer(tty);
+	tty_ldisc_flush(tty);
 
 	shutdown(info);
 
diff -puN drivers/char/riscom8.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks drivers/char/riscom8.c
--- a/drivers/char/riscom8.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks
+++ a/drivers/char/riscom8.c
@@ -1015,6 +1015,24 @@ static int rc_open(struct tty_struct * t
 	return 0;
 }
 
+static void rc_flush_buffer(struct tty_struct *tty)
+{
+	struct riscom_port *port = (struct riscom_port *)tty->driver_data;
+	unsigned long flags;
+
+	if (rc_paranoia_check(port, tty->name, "rc_flush_buffer"))
+		return;
+
+	spin_lock_irqsave(&riscom_lock, flags);
+
+	port->xmit_cnt = port->xmit_head = port->xmit_tail = 0;
+
+	spin_unlock_irqrestore(&riscom_lock, flags);
+
+	tty_wakeup(tty);
+}
+
+
 static void rc_close(struct tty_struct * tty, struct file * filp)
 {
 	struct riscom_port *port = (struct riscom_port *) tty->driver_data;
@@ -1078,8 +1096,7 @@ static void rc_close(struct tty_struct *
 		}
 	}
 	rc_shutdown_port(bp, port);
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
+	rc_flush_buffer(tty);
 	tty_ldisc_flush(tty);
 
 	tty->closing = 0;
@@ -1213,23 +1230,6 @@ static int rc_chars_in_buffer(struct tty
 	return port->xmit_cnt;
 }
 
-static void rc_flush_buffer(struct tty_struct *tty)
-{
-	struct riscom_port *port = (struct riscom_port *)tty->driver_data;
-	unsigned long flags;
-				
-	if (rc_paranoia_check(port, tty->name, "rc_flush_buffer"))
-		return;
-
-	spin_lock_irqsave(&riscom_lock, flags);
-
-	port->xmit_cnt = port->xmit_head = port->xmit_tail = 0;
-
-	spin_unlock_irqrestore(&riscom_lock, flags);
-	
-	tty_wakeup(tty);
-}
-
 static int rc_tiocmget(struct tty_struct *tty, struct file *file)
 {
 	struct riscom_port *port = (struct riscom_port *)tty->driver_data;
diff -puN drivers/char/rocket.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks drivers/char/rocket.c
--- a/drivers/char/rocket.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks
+++ a/drivers/char/rocket.c
@@ -1585,6 +1585,7 @@ static void rp_wait_until_sent(struct tt
 	       jiffies);
 	printk(KERN_INFO "cps=%d...\n", info->cps);
 #endif
+	lock_kernel();
 	while (1) {
 		txcnt = sGetTxCnt(cp);
 		if (!txcnt) {
@@ -1612,6 +1613,7 @@ static void rp_wait_until_sent(struct tt
 			break;
 	}
 	__set_current_state(TASK_RUNNING);
+	unlock_kernel();
 #ifdef ROCKET_DEBUG_WAIT_UNTIL_SENT
 	printk(KERN_INFO "txcnt = %d (jiff=%lu)...done\n", txcnt, jiffies);
 #endif
diff -puN drivers/char/serial167.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks drivers/char/serial167.c
--- a/drivers/char/serial167.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks
+++ a/drivers/char/serial167.c
@@ -1674,8 +1674,7 @@ static void cy_close(struct tty_struct *
 	if (info->flags & ASYNC_INITIALIZED)
 		tty_wait_until_sent(tty, 3000);	/* 30 seconds timeout */
 	shutdown(info);
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
+	cy_flush_buffer(tty);
 	tty_ldisc_flush(tty);
 	info->tty = NULL;
 	if (info->blocked_open) {
diff -puN drivers/char/specialix.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks drivers/char/specialix.c
--- a/drivers/char/specialix.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks
+++ a/drivers/char/specialix.c
@@ -1504,6 +1504,27 @@ static int sx_open(struct tty_struct * t
 	return 0;
 }
 
+static void sx_flush_buffer(struct tty_struct *tty)
+{
+	struct specialix_port *port = (struct specialix_port *)tty->driver_data;
+	unsigned long flags;
+	struct specialix_board  * bp;
+
+	func_enter();
+
+	if (sx_paranoia_check(port, tty->name, "sx_flush_buffer")) {
+		func_exit();
+		return;
+	}
+
+	bp = port_Board(port);
+	spin_lock_irqsave(&port->lock, flags);
+	port->xmit_cnt = port->xmit_head = port->xmit_tail = 0;
+	spin_unlock_irqrestore(&port->lock, flags);
+	tty_wakeup(tty);
+
+	func_exit();
+}
 
 static void sx_close(struct tty_struct * tty, struct file * filp)
 {
@@ -1597,8 +1618,7 @@ static void sx_close(struct tty_struct *
 	}
 
 	sx_shutdown_port(bp, port);
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
+	sx_flush_buffer(tty);
 	tty_ldisc_flush(tty);
 	spin_lock_irqsave(&port->lock, flags);
 	tty->closing = 0;
@@ -1770,28 +1790,6 @@ static int sx_chars_in_buffer(struct tty
 }
 
 
-static void sx_flush_buffer(struct tty_struct *tty)
-{
-	struct specialix_port *port = (struct specialix_port *)tty->driver_data;
-	unsigned long flags;
-	struct specialix_board  * bp;
-
-	func_enter();
-
-	if (sx_paranoia_check(port, tty->name, "sx_flush_buffer")) {
-		func_exit();
-		return;
-	}
-
-	bp = port_Board(port);
-	spin_lock_irqsave(&port->lock, flags);
-	port->xmit_cnt = port->xmit_head = port->xmit_tail = 0;
-	spin_unlock_irqrestore(&port->lock, flags);
-	tty_wakeup(tty);
-
-	func_exit();
-}
-
 
 static int sx_tiocmget(struct tty_struct *tty, struct file *file)
 {
diff -puN drivers/char/stallion.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks drivers/char/stallion.c
--- a/drivers/char/stallion.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks
+++ a/drivers/char/stallion.c
@@ -875,6 +875,7 @@ static void stl_waituntilsent(struct tty
 		timeout = HZ;
 	tend = jiffies + timeout;
 
+	lock_kernel();
 	while (stl_datastate(portp)) {
 		if (signal_pending(current))
 			break;
@@ -882,6 +883,7 @@ static void stl_waituntilsent(struct tty
 		if (time_after_eq(jiffies, tend))
 			break;
 	}
+	unlock_kernel();
 }
 
 /*****************************************************************************/
diff -puN drivers/char/synclink.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks drivers/char/synclink.c
--- a/drivers/char/synclink.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks
+++ a/drivers/char/synclink.c
@@ -3157,8 +3157,7 @@ static void mgsl_close(struct tty_struct
  	if (info->flags & ASYNC_INITIALIZED)
  		mgsl_wait_until_sent(tty, info->timeout);
 
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
+	mgsl_flush_buffer(tty);
 
 	tty_ldisc_flush(tty);
 		
@@ -3221,7 +3220,8 @@ static void mgsl_wait_until_sent(struct 
 	 * interval should also be less than the timeout.
 	 * Note: use tight timings here to satisfy the NIST-PCTS.
 	 */ 
-       
+
+	lock_kernel();
 	if ( info->params.data_rate ) {
 	       	char_time = info->timeout/(32 * 5);
 		if (!char_time)
@@ -3251,6 +3251,7 @@ static void mgsl_wait_until_sent(struct 
 				break;
 		}
 	}
+	unlock_kernel();
       
 exit:
 	if (debug_level >= DEBUG_LEVEL_INFO)
diff -puN drivers/char/synclink_gt.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks drivers/char/synclink_gt.c
--- a/drivers/char/synclink_gt.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks
+++ a/drivers/char/synclink_gt.c
@@ -771,8 +771,7 @@ static void close(struct tty_struct *tty
 
  	if (info->flags & ASYNC_INITIALIZED)
  		wait_until_sent(tty, info->timeout);
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
+	flush_buffer(tty);
 	tty_ldisc_flush(tty);
 
 	shutdown(info);
@@ -967,6 +966,8 @@ static void wait_until_sent(struct tty_s
 	 * Note: use tight timings here to satisfy the NIST-PCTS.
 	 */
 
+	lock_kernel();
+
 	if (info->params.data_rate) {
 	       	char_time = info->timeout/(32 * 5);
 		if (!char_time)
@@ -984,6 +985,7 @@ static void wait_until_sent(struct tty_s
 		if (timeout && time_after(jiffies, orig_jiffies + timeout))
 			break;
 	}
+	unlock_kernel();
 
 exit:
 	DBGINFO(("%s wait_until_sent exit\n", info->device_name));
diff -puN drivers/char/synclinkmp.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks drivers/char/synclinkmp.c
--- a/drivers/char/synclinkmp.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks
+++ a/drivers/char/synclinkmp.c
@@ -862,8 +862,7 @@ static void close(struct tty_struct *tty
  	if (info->flags & ASYNC_INITIALIZED)
  		wait_until_sent(tty, info->timeout);
 
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
+	flush_buffer(tty);
 
 	tty_ldisc_flush(tty);
 
@@ -1119,6 +1118,8 @@ static void wait_until_sent(struct tty_s
 	if (sanity_check(info, tty->name, "wait_until_sent"))
 		return;
 
+	lock_kernel();
+
 	if (!(info->flags & ASYNC_INITIALIZED))
 		goto exit;
 
@@ -1161,6 +1162,7 @@ static void wait_until_sent(struct tty_s
 	}
 
 exit:
+	unlock_kernel();
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):%s wait_until_sent() exit\n",
 			 __FILE__,__LINE__, info->device_name );
@@ -1176,6 +1178,7 @@ static int write_room(struct tty_struct 
 	if (sanity_check(info, tty->name, "write_room"))
 		return 0;
 
+	lock_kernel();
 	if (info->params.mode == MGSL_MODE_HDLC) {
 		ret = (info->tx_active) ? 0 : HDLC_MAX_FRAME_SIZE;
 	} else {
@@ -1183,6 +1186,7 @@ static int write_room(struct tty_struct 
 		if (ret < 0)
 			ret = 0;
 	}
+	unlock_kernel();
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):%s write_room()=%d\n",
diff -puN drivers/char/tty_io.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks
+++ a/drivers/char/tty_io.c
@@ -1204,7 +1204,7 @@ EXPORT_SYMBOL_GPL(tty_find_polling_drive
  *	not in the foreground, send a SIGTTOU.  If the signal is blocked or
  *	ignored, go ahead and perform the operation.  (POSIX 7.2)
  *
- *	Locking: ctrl_lock - FIXME: review this
+ *	Locking: ctrl_lock
  */
 
 int tty_check_change(struct tty_struct *tty)
diff -puN drivers/char/tty_ioctl.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks drivers/char/tty_ioctl.c
--- a/drivers/char/tty_ioctl.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks
+++ a/drivers/char/tty_ioctl.c
@@ -396,7 +396,7 @@ EXPORT_SYMBOL(tty_termios_hw_change);
 static void change_termios(struct tty_struct *tty, struct ktermios *new_termios)
 {
 	int canon_change;
-	struct ktermios old_termios = *tty->termios;
+	struct ktermios old_termios;
 	struct tty_ldisc *ld;
 	unsigned long flags;
 
@@ -408,7 +408,7 @@ static void change_termios(struct tty_st
 	/* FIXME: we need to decide on some locking/ordering semantics
 	   for the set_termios notification eventually */
 	mutex_lock(&tty->termios_mutex);
-
+	old_termios = *tty->termios;
 	*tty->termios = *new_termios;
 	unset_locked_termios(tty->termios, &old_termios, tty->termios_locked);
 	canon_change = (old_termios.c_lflag ^ tty->termios->c_lflag) & ICANON;
@@ -480,7 +480,9 @@ static int set_termios(struct tty_struct
 	if (retval)
 		return retval;
 
+	mutex_lock(&tty->termios_mutex);
 	memcpy(&tmp_termios, tty->termios, sizeof(struct ktermios));
+	mutex_unlock(&tty->termios_mutex);
 
 	if (opt & TERMIOS_TERMIO) {
 		if (user_termio_to_kernel_termios(&tmp_termios,
@@ -666,12 +668,14 @@ static int get_tchars(struct tty_struct 
 {
 	struct tchars tmp;
 
+	mutex_lock(&tty->termios_mutex);
 	tmp.t_intrc = tty->termios->c_cc[VINTR];
 	tmp.t_quitc = tty->termios->c_cc[VQUIT];
 	tmp.t_startc = tty->termios->c_cc[VSTART];
 	tmp.t_stopc = tty->termios->c_cc[VSTOP];
 	tmp.t_eofc = tty->termios->c_cc[VEOF];
 	tmp.t_brkc = tty->termios->c_cc[VEOL2];	/* what is brkc anyway? */
+	mutex_unlock(&tty->termios_mutex);
 	return copy_to_user(tchars, &tmp, sizeof(tmp)) ? -EFAULT : 0;
 }
 
@@ -681,12 +685,14 @@ static int set_tchars(struct tty_struct 
 
 	if (copy_from_user(&tmp, tchars, sizeof(tmp)))
 		return -EFAULT;
+	mutex_lock(&tty->termios_mutex);
 	tty->termios->c_cc[VINTR] = tmp.t_intrc;
 	tty->termios->c_cc[VQUIT] = tmp.t_quitc;
 	tty->termios->c_cc[VSTART] = tmp.t_startc;
 	tty->termios->c_cc[VSTOP] = tmp.t_stopc;
 	tty->termios->c_cc[VEOF] = tmp.t_eofc;
 	tty->termios->c_cc[VEOL2] = tmp.t_brkc;	/* what is brkc anyway? */
+	mutex_unlock(&tty->termios_mutex);
 	return 0;
 }
 #endif
@@ -696,6 +702,7 @@ static int get_ltchars(struct tty_struct
 {
 	struct ltchars tmp;
 
+	mutex_lock(&tty->termios_mutex);
 	tmp.t_suspc = tty->termios->c_cc[VSUSP];
 	/* what is dsuspc anyway? */
 	tmp.t_dsuspc = tty->termios->c_cc[VSUSP];
@@ -704,6 +711,7 @@ static int get_ltchars(struct tty_struct
 	tmp.t_flushc = tty->termios->c_cc[VEOL2];
 	tmp.t_werasc = tty->termios->c_cc[VWERASE];
 	tmp.t_lnextc = tty->termios->c_cc[VLNEXT];
+	mutex_unlock(&tty->termios_mutex);
 	return copy_to_user(ltchars, &tmp, sizeof(tmp)) ? -EFAULT : 0;
 }
 
@@ -714,6 +722,7 @@ static int set_ltchars(struct tty_struct
 	if (copy_from_user(&tmp, ltchars, sizeof(tmp)))
 		return -EFAULT;
 
+	mutex_lock(&tty->termios_mutex);
 	tty->termios->c_cc[VSUSP] = tmp.t_suspc;
 	/* what is dsuspc anyway? */
 	tty->termios->c_cc[VEOL2] = tmp.t_dsuspc;
@@ -722,6 +731,7 @@ static int set_ltchars(struct tty_struct
 	tty->termios->c_cc[VEOL2] = tmp.t_flushc;
 	tty->termios->c_cc[VWERASE] = tmp.t_werasc;
 	tty->termios->c_cc[VLNEXT] = tmp.t_lnextc;
+	mutex_unlock(&tty->termios_mutex);
 	return 0;
 }
 #endif
diff -puN drivers/isdn/i4l/isdn_tty.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks drivers/isdn/i4l/isdn_tty.c
--- a/drivers/isdn/i4l/isdn_tty.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks
+++ a/drivers/isdn/i4l/isdn_tty.c
@@ -1708,9 +1708,7 @@ isdn_tty_close(struct tty_struct *tty, s
 	}
 	dev->modempoll--;
 	isdn_tty_shutdown(info);
-	
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
+	isdn_tty_flush_buffer(tty);
 	tty_ldisc_flush(tty);
 	info->tty = NULL;
 	info->ncarrier = 0;
diff -puN drivers/serial/68328serial.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks drivers/serial/68328serial.c
--- a/drivers/serial/68328serial.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks
+++ a/drivers/serial/68328serial.c
@@ -1017,18 +1017,6 @@ static int rs_ioctl(struct tty_struct *t
 			tty_wait_until_sent(tty, 0);
 			send_break(info, arg ? arg*(100) : 250);
 			return 0;
-		case TIOCGSOFTCAR:
-			error = put_user(C_CLOCAL(tty) ? 1 : 0,
-				    (unsigned long *) arg);
-			if (error)
-				return error;
-			return 0;
-		case TIOCSSOFTCAR:
-			get_user(arg, (unsigned long *) arg);
-			tty->termios->c_cflag =
-				((tty->termios->c_cflag & ~CLOCAL) |
-				 (arg ? CLOCAL : 0));
-			return 0;
 		case TIOCGSERIAL:
 			if (access_ok(VERIFY_WRITE, (void *) arg,
 						sizeof(struct serial_struct)))
@@ -1061,9 +1049,6 @@ static void rs_set_termios(struct tty_st
 {
 	struct m68k_serial *info = (struct m68k_serial *)tty->driver_data;
 
-	if (tty->termios->c_cflag == old_termios->c_cflag)
-		return;
-
 	change_speed(info);
 
 	if ((old_termios->c_cflag & CRTSCTS) &&
@@ -1140,8 +1125,7 @@ static void rs_close(struct tty_struct *
 	uart->ustcnt &= ~(USTCNT_RXEN | USTCNT_RX_INTR_MASK);
 
 	shutdown(info);
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
+	rs_flush_buffer(tty);
 		
 	tty_ldisc_flush(tty);
 	tty->closing = 0;
diff -puN drivers/serial/68360serial.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks drivers/serial/68360serial.c
--- a/drivers/serial/68360serial.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks
+++ a/drivers/serial/68360serial.c
@@ -1436,18 +1436,6 @@ static int rs_360_ioctl(struct tty_struc
 				return retval;
 			end_break(info);
 			return 0;
-		case TIOCGSOFTCAR:
-			/* return put_user(C_CLOCAL(tty) ? 1 : 0, (int *) arg); */
-			put_user(C_CLOCAL(tty) ? 1 : 0, (int *) arg);
-			return 0;
-		case TIOCSSOFTCAR:
-			error = get_user(arg, (unsigned int *) arg); 
-			if (error)
-				return error;
-			tty->termios->c_cflag =
-				((tty->termios->c_cflag & ~CLOCAL) |
-				 (arg ? CLOCAL : 0));
-			return 0;
 #ifdef maybe
 		case TIOCSERGETLSR: /* Get line status register */
 			return get_lsr_info(info, (unsigned int *) arg);
@@ -1665,8 +1653,7 @@ static void rs_360_close(struct tty_stru
 		rs_360_wait_until_sent(tty, info->timeout);
 	}
 	shutdown(info);
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
+	rs_360_flush_buffer(tty);
 	tty_ldisc_flush(tty);		
 	tty->closing = 0;
 	info->event = 0;
@@ -1717,6 +1704,7 @@ static void rs_360_wait_until_sent(struc
 	printk("jiff=%lu...", jiffies);
 #endif
 
+	lock_kernel();
 	/* We go through the loop at least once because we can't tell
 	 * exactly when the last character exits the shifter.  There can
 	 * be at least two characters waiting to be sent after the buffers
@@ -1745,6 +1733,7 @@ static void rs_360_wait_until_sent(struc
 			bdp--;
 	} while (bdp->status & BD_SC_READY);
 	current->state = TASK_RUNNING;
+	unlock_kernel();
 #ifdef SERIAL_DEBUG_RS_WAIT_UNTIL_SENT
 	printk("lsr = %d (jiff=%lu)...done\n", lsr, jiffies);
 #endif
diff -puN drivers/serial/crisv10.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks drivers/serial/crisv10.c
--- a/drivers/serial/crisv10.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks
+++ a/drivers/serial/crisv10.c
@@ -3581,8 +3581,9 @@ rs_tiocmset(struct tty_struct *tty, stru
 		unsigned int set, unsigned int clear)
 {
 	struct e100_serial *info = (struct e100_serial *)tty->driver_data;
+	unsigned long flags;
 
-	lock_kernel();
+	local_irq_save(flags);
 
 	if (clear & TIOCM_RTS)
 		e100_rts(info, 0);
@@ -3604,7 +3605,7 @@ rs_tiocmset(struct tty_struct *tty, stru
 	if (set & TIOCM_CD)
 		e100_cd_out(info, 1);
 
-	unlock_kernel();
+	local_irq_restore(flags);
 	return 0;
 }
 
@@ -3613,8 +3614,10 @@ rs_tiocmget(struct tty_struct *tty, stru
 {
 	struct e100_serial *info = (struct e100_serial *)tty->driver_data;
 	unsigned int result;
+	unsigned long flags;
+
+	local_irq_save(flags);
 
-	lock_kernel();
 	result =
 		(!E100_RTS_GET(info) ? TIOCM_RTS : 0)
 		| (!E100_DTR_GET(info) ? TIOCM_DTR : 0)
@@ -3623,7 +3626,7 @@ rs_tiocmget(struct tty_struct *tty, stru
 		| (!E100_CD_GET(info) ? TIOCM_CAR : 0)
 		| (!E100_CTS_GET(info) ? TIOCM_CTS : 0);
 
-	unlock_kernel();
+	local_irq_restore(flags);
 
 #ifdef SERIAL_DEBUG_IO
 	printk(KERN_DEBUG "ser%i: modem state: %i 0x%08X\n",
@@ -3702,10 +3705,6 @@ rs_set_termios(struct tty_struct *tty, s
 {
 	struct e100_serial *info = (struct e100_serial *)tty->driver_data;
 
-	if (tty->termios->c_cflag == old_termios->c_cflag &&
-	    tty->termios->c_iflag == old_termios->c_iflag)
-		return;
-
 	change_speed(info);
 
 	/* Handle turning off CRTSCTS */
@@ -3808,10 +3807,8 @@ rs_close(struct tty_struct *tty, struct 
 #endif
 
 	shutdown(info);
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
-	if (tty->ldisc.flush_buffer)
-		tty->ldisc.flush_buffer(tty);
+	rs_flush_buffer(tty);
+	tty_ldisc_flush_buffer(tty);
 	tty->closing = 0;
 	info->event = 0;
 	info->tty = 0;
@@ -3885,6 +3882,7 @@ static void rs_wait_until_sent(struct tt
 	 * Check R_DMA_CHx_STATUS bit 0-6=number of available bytes in FIFO
 	 * R_DMA_CHx_HWSW bit 31-16=nbr of bytes left in DMA buffer (0=64k)
 	 */
+	lock_kernel();
 	orig_jiffies = jiffies;
 	while (info->xmit.head != info->xmit.tail || /* More in send queue */
 	       (*info->ostatusadr & 0x007f) ||  /* more in FIFO */
@@ -3901,6 +3899,7 @@ static void rs_wait_until_sent(struct tt
 			curr_time_usec - info->last_tx_active_usec;
 	}
 	set_current_state(TASK_RUNNING);
+	unlock_kernel();
 }
 
 /*
diff -puN drivers/serial/mcfserial.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks drivers/serial/mcfserial.c
--- a/drivers/serial/mcfserial.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks
+++ a/drivers/serial/mcfserial.c
@@ -1072,18 +1072,6 @@ static int mcfrs_ioctl(struct tty_struct
 			tty_wait_until_sent(tty, 0);
 			send_break(info, arg ? arg*(HZ/10) : HZ/4);
 			return 0;
-		case TIOCGSOFTCAR:
-			error = put_user(C_CLOCAL(tty) ? 1 : 0,
-				    (unsigned long *) arg);
-			if (error)
-				return error;
-			return 0;
-		case TIOCSSOFTCAR:
-			get_user(arg, (unsigned long *) arg);
-			tty->termios->c_cflag =
-				((tty->termios->c_cflag & ~CLOCAL) |
-				 (arg ? CLOCAL : 0));
-			return 0;
 		case TIOCGSERIAL:
 			if (access_ok(VERIFY_WRITE, (void *) arg,
 						sizeof(struct serial_struct)))
@@ -1222,8 +1210,7 @@ static void mcfrs_close(struct tty_struc
 	} else
 #endif
 	shutdown(info);
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
+	mcfrs_flush_buffer(tty);
 	tty_ldisc_flush(tty);
 	
 	tty->closing = 0;
@@ -1276,6 +1263,8 @@ mcfrs_wait_until_sent(struct tty_struct 
 	 * Note: we have to use pretty tight timings here to satisfy
 	 * the NIST-PCTS.
 	 */
+	lock_kernel();
+
 	fifo_time = (MCF5272_FIFO_SIZE * HZ * 10) / info->baud;
 	char_time = fifo_time / 5;
 	if (char_time == 0)
@@ -1312,6 +1301,7 @@ mcfrs_wait_until_sent(struct tty_struct 
 		if (timeout && time_after(jiffies, orig_jiffies + timeout))
 			break;
 	}
+	unlock_kernel();
 #else
 	/*
 	 * For the other coldfire models, assume all data has been sent
diff -puN drivers/serial/netx-serial.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks drivers/serial/netx-serial.c
--- a/drivers/serial/netx-serial.c~tty-serial-lay-the-foundations-for-the-next-set-of-reworks
+++ a/drivers/serial/netx-serial.c
@@ -287,6 +287,7 @@ static void netx_set_mctrl(struct uart_p
 {
 	unsigned int val;
 
+	/* FIXME: Locking needed ? */
 	if (mctrl & TIOCM_RTS) {
 		val = readl(port->membase + UART_RTS_CR);
 		writel(val | RTS_CR_RTS, port->membase + UART_RTS_CR);
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
pata_atiixp-simplex-clear.patch
pata_atiixp-dont-disable.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
generic-irq-let-setup_irq-reenable-a-shared-irq.patch
8250-switch-8250-drivers-to-use-_nocache-ioremaps.patch
sxc-fix-printk-warnings-on-sparc32.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

