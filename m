From: akpm@linux-foundation.org
Subject: + m68k-gs-use-tty_port-fixes.patch added to -mm tree
Date: Sat, 26 Jul 2008 16:45:20 -0700
Message-ID: <200807262345.m6QNjKbM025048@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46081 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754369AbYGZXqJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 19:46:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org


The patch titled
     m68k: gs: use tty_port fixes
has been added to the -mm tree.  Its filename is
     m68k-gs-use-tty_port-fixes.patch

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
Subject: m68k: gs: use tty_port fixes
From: Geert Uytterhoeven <geert@linux-m68k.org>

commit b5391e29f428d11755ca2c91074c6db6f5c69d7c (gs: use tty_port) forgot to
update the m68k gs serial drivers.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ser_a2232.c |   52 ++++++++++++++++----------------
 drivers/char/vme_scc.c   |   59 ++++++++++++++++++-------------------
 2 files changed, 56 insertions(+), 55 deletions(-)

diff -puN drivers/char/ser_a2232.c~m68k-gs-use-tty_port-fixes drivers/char/ser_a2232.c
--- a/drivers/char/ser_a2232.c~m68k-gs-use-tty_port-fixes
+++ a/drivers/char/ser_a2232.c
@@ -192,7 +192,7 @@ static inline void a2232_receive_char(st
 	Maybe one could implement a more efficient version by not only
 	transferring one character at a time.
 */
-	struct tty_struct *tty = port->gs.tty;
+	struct tty_struct *tty = port->gs.port.tty;
 
 #if 0
 	switch(err) {
@@ -226,7 +226,7 @@ static void a2232_disable_tx_interrupts(
 
 	/* Does this here really have to be? */
 	local_irq_save(flags);
-	port->gs.flags &= ~GS_TX_INTEN;
+	port->gs.port.flags &= ~GS_TX_INTEN;
 	local_irq_restore(flags);
 }
 
@@ -242,7 +242,7 @@ static void a2232_enable_tx_interrupts(v
 
 	/* Does this here really have to be? */
 	local_irq_save(flags);
-	port->gs.flags |= GS_TX_INTEN;
+	port->gs.port.flags |= GS_TX_INTEN;
 	local_irq_restore(flags);
 }
 
@@ -276,9 +276,9 @@ static void a2232_shutdown_port(void *pt
 
 	local_irq_save(flags);
 
-	port->gs.flags &= ~GS_ACTIVE;
+	port->gs.port.flags &= ~GS_ACTIVE;
 	
-	if (port->gs.tty && port->gs.tty->termios->c_cflag & HUPCL) {
+	if (port->gs.port.tty && port->gs.port.tty->termios->c_cflag & HUPCL) {
 		/* Set DTR and RTS to Low, flush output.
 		   The NetBSD driver "msc.c" does it this way. */
 		stat->Command = (	(stat->Command & ~A2232CMD_CMask) | 
@@ -309,7 +309,7 @@ static int  a2232_set_real_termios(void 
 	volatile struct a2232status *status;
 	volatile struct a2232memory *mem;
 
-	if (!port->gs.tty || !port->gs.tty->termios) return 0;
+	if (!port->gs.port.tty || !port->gs.port.tty->termios) return 0;
 
 	status = a2232stat(port->which_a2232, port->which_port_on_a2232);
 	mem = a2232mem(port->which_a2232);
@@ -345,7 +345,7 @@ static int  a2232_set_real_termios(void 
 	}
 	a2232_param |= rate;
 
-	cflag  = port->gs.tty->termios->c_cflag;
+	cflag  = port->gs.port.tty->termios->c_cflag;
 
 	// get character size
 	chsize = cflag & CSIZE;
@@ -382,7 +382,7 @@ static int  a2232_set_real_termios(void 
 		the conventional way of inserting START/STOP characters
 		by hand in throttle()/unthrottle().
 	*/
-	softflow = !!( port->gs.tty->termios->c_iflag & IXOFF );
+	softflow = !!( port->gs.port.tty->termios->c_iflag & IXOFF );
 
 	// get Parity (Enabled/Disabled? If Enabled, Odd or Even?)
 	parity = cflag & (PARENB | PARODD);
@@ -400,9 +400,9 @@ static int  a2232_set_real_termios(void 
 	/*	Hmm. Maybe an own a2232_port structure
 		member would be cleaner?	*/
 	if (cflag & CLOCAL)
-		port->gs.flags &= ~ASYNC_CHECK_CD;
+		port->gs.port.flags &= ~ASYNC_CHECK_CD;
 	else
-		port->gs.flags |= ASYNC_CHECK_CD;
+		port->gs.port.flags |= ASYNC_CHECK_CD;
 
 
 	/* Now we have all parameters and can go to set them: */
@@ -482,18 +482,18 @@ static int  a2232_open(struct tty_struct
 	port = &a2232_ports[line];
 	
 	tty->driver_data = port;
-	port->gs.tty = tty;
-	port->gs.count++;
+	port->gs.port.tty = tty;
+	port->gs.port.count++;
 	retval = gs_init_port(&port->gs);
 	if (retval) {
-		port->gs.count--;
+		port->gs.port.count--;
 		return retval;
 	}
-	port->gs.flags |= GS_ACTIVE;
+	port->gs.port.flags |= GS_ACTIVE;
 	retval = gs_block_til_ready(port, filp);
 
 	if (retval) {
-		port->gs.count--;
+		port->gs.port.count--;
 		return retval;
 	}
 
@@ -522,7 +522,7 @@ int ch, err, n, p;
 		for (p = 0; p < NUMLINES; p++){	/* for every port on this board */
 			err = 0;
 			port = &a2232_ports[n*NUMLINES+p];
-			if ( port->gs.flags & GS_ACTIVE ){ /* if the port is used */
+			if ( port->gs.port.flags & GS_ACTIVE ){ /* if the port is used */
 
 				status = a2232stat(n,p);
 
@@ -577,8 +577,8 @@ int ch, err, n, p;
 				obuf = mem->OutBuf[p];
 				bufpos = status->OutHead;
 				while ( (port->gs.xmit_cnt > 0)		&&
-					(!port->gs.tty->stopped)	&&
-					(!port->gs.tty->hw_stopped) ){	/* While there are chars to transmit */
+					(!port->gs.port.tty->stopped)	&&
+					(!port->gs.port.tty->hw_stopped) ){	/* While there are chars to transmit */
 					if (((bufpos+1) & A2232_IOBUFLENMASK) != status->OutTail) { /* If the A2232 buffer is not full */
 						ch = port->gs.xmit_buf[port->gs.xmit_tail];					/* get the next char to transmit */
 						port->gs.xmit_tail = (port->gs.xmit_tail+1) & (SERIAL_XMIT_SIZE-1); /* modulo-addition for the gs.xmit_buf ring-buffer */
@@ -592,8 +592,8 @@ int ch, err, n, p;
 				status->OutHead = bufpos;
 					
 				/* WakeUp if output buffer runs low */
-				if ((port->gs.xmit_cnt <= port->gs.wakeup_chars) && port->gs.tty) {
-					tty_wakeup(port->gs.tty);
+				if ((port->gs.xmit_cnt <= port->gs.wakeup_chars) && port->gs.port.tty) {
+					tty_wakeup(port->gs.port.tty);
 				}
 			} // if the port is used
 		} // for every port on the board
@@ -613,16 +613,16 @@ int ch, err, n, p;
 						struct a2232_port *port = &a2232_ports[n*7+p];
 						port->cd_status = !(ncd & 1); /* ncd&1 <=> CD is now off */
 
-						if (!(port->gs.flags & ASYNC_CHECK_CD))
+						if (!(port->gs.port.flags & ASYNC_CHECK_CD))
 							;	/* Don't report DCD changes */
 						else if (port->cd_status) { // if DCD on: DCD went UP!
 							
 							/* Are we blocking in open?*/
-							wake_up_interruptible(&port->gs.open_wait);
+							wake_up_interruptible(&port->gs.port.open_wait);
 						}
 						else { // if DCD off: DCD went DOWN!
-							if (port->gs.tty)
-								tty_hangup (port->gs.tty);
+							if (port->gs.port.tty)
+								tty_hangup (port->gs.port.tty);
 						}
 						
 					} // if CD changed for this port
@@ -655,8 +655,8 @@ static void a2232_init_portstructs(void)
 #ifdef NEW_WRITE_LOCKING
 		mutex_init(&(port->gs.port_write_mutex));
 #endif
-		init_waitqueue_head(&port->gs.open_wait);
-		init_waitqueue_head(&port->gs.close_wait);
+		init_waitqueue_head(&port->gs.port.open_wait);
+		init_waitqueue_head(&port->gs.port.close_wait);
 	}
 }
 
diff -puN drivers/char/vme_scc.c~m68k-gs-use-tty_port-fixes drivers/char/vme_scc.c
--- a/drivers/char/vme_scc.c~m68k-gs-use-tty_port-fixes
+++ a/drivers/char/vme_scc.c
@@ -183,8 +183,8 @@ static void scc_init_portstructs(void)
 #ifdef NEW_WRITE_LOCKING
 		port->gs.port_write_mutex = MUTEX;
 #endif
-		init_waitqueue_head(&port->gs.open_wait);
-		init_waitqueue_head(&port->gs.close_wait);
+		init_waitqueue_head(&port->gs.port.open_wait);
+		init_waitqueue_head(&port->gs.port.close_wait);
 	}
 }
 
@@ -422,7 +422,7 @@ static irqreturn_t scc_rx_int(int irq, v
 {
 	unsigned char	ch;
 	struct scc_port *port = data;
-	struct tty_struct *tty = port->gs.tty;
+	struct tty_struct *tty = port->gs.port.tty;
 	SCC_ACCESS_INIT(port);
 
 	ch = SCCread_NB(RX_DATA_REG);
@@ -453,7 +453,7 @@ static irqreturn_t scc_rx_int(int irq, v
 static irqreturn_t scc_spcond_int(int irq, void *data)
 {
 	struct scc_port *port = data;
-	struct tty_struct *tty = port->gs.tty;
+	struct tty_struct *tty = port->gs.port.tty;
 	unsigned char	stat, ch, err;
 	int		int_pending_mask = port->channel == CHANNEL_A ?
 			                   IPR_A_RX : IPR_B_RX;
@@ -500,7 +500,7 @@ static irqreturn_t scc_tx_int(int irq, v
 	struct scc_port *port = data;
 	SCC_ACCESS_INIT(port);
 
-	if (!port->gs.tty) {
+	if (!port->gs.port.tty) {
 		printk(KERN_WARNING "scc_tx_int with NULL tty!\n");
 		SCCmod (INT_AND_DMA_REG, ~IDR_TX_INT_ENAB, 0);
 		SCCwrite(COMMAND_REG, CR_TX_PENDING_RESET);
@@ -512,8 +512,9 @@ static irqreturn_t scc_tx_int(int irq, v
 			SCCwrite(TX_DATA_REG, port->x_char);
 			port->x_char = 0;
 		}
-		else if ((port->gs.xmit_cnt <= 0) || port->gs.tty->stopped ||
-				port->gs.tty->hw_stopped)
+		else if ((port->gs.xmit_cnt <= 0) ||
+			 port->gs.port.tty->stopped ||
+			 port->gs.port.tty->hw_stopped)
 			break;
 		else {
 			SCCwrite(TX_DATA_REG, port->gs.xmit_buf[port->gs.xmit_tail++]);
@@ -522,15 +523,15 @@ static irqreturn_t scc_tx_int(int irq, v
 				break;
 		}
 	}
-	if ((port->gs.xmit_cnt <= 0) || port->gs.tty->stopped ||
-			port->gs.tty->hw_stopped) {
+	if ((port->gs.xmit_cnt <= 0) || port->gs.port.tty->stopped ||
+	    port->gs.port.tty->hw_stopped) {
 		/* disable tx interrupts */
 		SCCmod (INT_AND_DMA_REG, ~IDR_TX_INT_ENAB, 0);
 		SCCwrite(COMMAND_REG, CR_TX_PENDING_RESET);   /* disable tx_int on next tx underrun? */
-		port->gs.flags &= ~GS_TX_INTEN;
+		port->gs.port.flags &= ~GS_TX_INTEN;
 	}
-	if (port->gs.tty && port->gs.xmit_cnt <= port->gs.wakeup_chars)
-		tty_wakeup(port->gs.tty);
+	if (port->gs.port.tty && port->gs.xmit_cnt <= port->gs.wakeup_chars)
+		tty_wakeup(port->gs.port.tty);
 
 	SCCwrite_NB(COMMAND_REG, CR_HIGHEST_IUS_RESET);
 	return IRQ_HANDLED;
@@ -550,14 +551,14 @@ static irqreturn_t scc_stat_int(int irq,
 
 	if (changed & SR_DCD) {
 		port->c_dcd = !!(sr & SR_DCD);
-		if (!(port->gs.flags & ASYNC_CHECK_CD))
+		if (!(port->gs.port.flags & ASYNC_CHECK_CD))
 			;	/* Don't report DCD changes */
 		else if (port->c_dcd) {
-			wake_up_interruptible(&port->gs.open_wait);
+			wake_up_interruptible(&port->gs.port.open_wait);
 		}
 		else {
-			if (port->gs.tty)
-				tty_hangup (port->gs.tty);
+			if (port->gs.port.tty)
+				tty_hangup (port->gs.port.tty);
 		}
 	}
 	SCCwrite(COMMAND_REG, CR_EXTSTAT_RESET);
@@ -578,7 +579,7 @@ static void scc_disable_tx_interrupts(vo
 
 	local_irq_save(flags);
 	SCCmod(INT_AND_DMA_REG, ~IDR_TX_INT_ENAB, 0);
-	port->gs.flags &= ~GS_TX_INTEN;
+	port->gs.port.flags &= ~GS_TX_INTEN;
 	local_irq_restore(flags);
 }
 
@@ -636,8 +637,8 @@ static void scc_shutdown_port(void *ptr)
 {
 	struct scc_port *port = ptr;
 
-	port->gs.flags &= ~ GS_ACTIVE;
-	if (port->gs.tty && port->gs.tty->termios->c_cflag & HUPCL) {
+	port->gs.port.flags &= ~ GS_ACTIVE;
+	if (port->gs.port.tty && port->gs.port.tty->termios->c_cflag & HUPCL) {
 		scc_setsignals (port, 0, 0);
 	}
 }
@@ -652,14 +653,14 @@ static int scc_set_real_termios (void *p
 	struct scc_port *port = ptr;
 	SCC_ACCESS_INIT(port);
 
-	if (!port->gs.tty || !port->gs.tty->termios) return 0;
+	if (!port->gs.port.tty || !port->gs.port.tty->termios) return 0;
 
 	channel = port->channel;
 
 	if (channel == CHANNEL_A)
 		return 0;		/* Settings controlled by boot PROM */
 
-	cflag  = port->gs.tty->termios->c_cflag;
+	cflag  = port->gs.port.tty->termios->c_cflag;
 	baud = port->gs.baud;
 	chsize = (cflag & CSIZE) >> 4;
 
@@ -678,9 +679,9 @@ static int scc_set_real_termios (void *p
 	}
 
 	if (cflag & CLOCAL)
-		port->gs.flags &= ~ASYNC_CHECK_CD;
+		port->gs.port.flags &= ~ASYNC_CHECK_CD;
 	else
-		port->gs.flags |= ASYNC_CHECK_CD;
+		port->gs.port.flags |= ASYNC_CHECK_CD;
 
 #ifdef CONFIG_MVME147_SCC
 	if (MACH_IS_MVME147)
@@ -856,7 +857,7 @@ static int scc_open (struct tty_struct *
 		{ COMMAND_REG, CR_EXTSTAT_RESET },
 	};
 #endif
-	if (!(port->gs.flags & ASYNC_INITIALIZED)) {
+	if (!(port->gs.port.flags & ASYNC_INITIALIZED)) {
 		local_irq_save(flags);
 #if defined(CONFIG_MVME147_SCC) || defined(CONFIG_MVME162_SCC)
 		if (MACH_IS_MVME147 || MACH_IS_MVME16x) {
@@ -880,18 +881,18 @@ static int scc_open (struct tty_struct *
 	}
 
 	tty->driver_data = port;
-	port->gs.tty = tty;
-	port->gs.count++;
+	port->gs.port.tty = tty;
+	port->gs.port.count++;
 	retval = gs_init_port(&port->gs);
 	if (retval) {
-		port->gs.count--;
+		port->gs.port.count--;
 		return retval;
 	}
-	port->gs.flags |= GS_ACTIVE;
+	port->gs.port.flags |= GS_ACTIVE;
 	retval = gs_block_til_ready(port, filp);
 
 	if (retval) {
-		port->gs.count--;
+		port->gs.port.count--;
 		return retval;
 	}
 
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
m68k-gs-use-tty_port-fixes.patch
linux-next.patch

