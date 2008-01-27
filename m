From: akpm@linux-foundation.org
Subject: + atmel_serial-split-the-interrupt-handler.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:17:59 -0800
Message-ID: <200801270517.m0R5Hufv031159@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46621 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751354AbYA0FUJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:20:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@bohmer.net, hskinnemoen@atmel.com, linux@maxim.org.za, marc.pignat@hevs.ch


The patch titled
     atmel_serial: split the interrupt handler
has been added to the -mm tree.  Its filename is
     atmel_serial-split-the-interrupt-handler.patch

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
Subject: atmel_serial: split the interrupt handler
From: Remy Bohmer <linux@bohmer.net>

Split up the interrupt handler of the serial port into a interrupt top-half
and a tasklet.

The goal is to get the interrupt top-half as short as possible to minimize
latencies on interrupts.  But the old code also does some calls in the
interrupt handler that are not allowed on preempt-RT in IRQF_NODELAY context. 
This handler is executed in this context because of the interrupt sharing with
the timer interrupt.  The timer interrupt on Preempt-RT runs in IRQF_NODELAY
context.

The tasklet takes care of handling control status changes, pushing incoming
characters to the tty layer, handling break and other errors.  It also handles
pushing TX data into the data register.

Reading the complete receive queue is still done in the top-half because we
never want to miss any incoming character.

[hskinnemoen@atmel.com: misc cleanups and simplifications]
Signed-off-by: Remy Bohmer <linux@bohmer.net>
Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Andrew Victor <linux@maxim.org.za>
Tested-by: Marc Pignat <marc.pignat@hevs.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/atmel_serial.c |  245 ++++++++++++++++++++++++--------
 1 file changed, 190 insertions(+), 55 deletions(-)

diff -puN drivers/serial/atmel_serial.c~atmel_serial-split-the-interrupt-handler drivers/serial/atmel_serial.c
--- a/drivers/serial/atmel_serial.c~atmel_serial-split-the-interrupt-handler
+++ a/drivers/serial/atmel_serial.c
@@ -104,6 +104,13 @@
 static int (*atmel_open_hook)(struct uart_port *);
 static void (*atmel_close_hook)(struct uart_port *);
 
+struct atmel_uart_char {
+	u16		status;
+	u16		ch;
+};
+
+#define ATMEL_SERIAL_RINGSIZE 1024
+
 /*
  * We wrap our port structure around the generic uart_port.
  */
@@ -112,6 +119,12 @@ struct atmel_uart_port {
 	struct clk		*clk;		/* uart clock */
 	unsigned short		suspended;	/* is port suspended? */
 	int			break_active;	/* break being received */
+
+	struct tasklet_struct	tasklet;
+	unsigned int		irq_status;
+	unsigned int		irq_status_prev;
+
+	struct circ_buf		rx_ring;
 };
 
 static struct atmel_uart_port atmel_ports[ATMEL_MAX_UART];
@@ -241,22 +254,42 @@ static void atmel_break_ctl(struct uart_
 }
 
 /*
+ * Stores the incoming character in the ring buffer
+ */
+static void
+atmel_buffer_rx_char(struct uart_port *port, unsigned int status,
+		     unsigned int ch)
+{
+	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct circ_buf *ring = &atmel_port->rx_ring;
+	struct atmel_uart_char *c;
+
+	if (!CIRC_SPACE(ring->head, ring->tail, ATMEL_SERIAL_RINGSIZE))
+		/* Buffer overflow, ignore char */
+		return;
+
+	c = &((struct atmel_uart_char *)ring->buf)[ring->head];
+	c->status	= status;
+	c->ch		= ch;
+
+	/* Make sure the character is stored before we update head. */
+	smp_wmb();
+
+	ring->head = (ring->head + 1) & (ATMEL_SERIAL_RINGSIZE - 1);
+}
+
+/*
  * Characters received (called from interrupt handler)
  */
 static void atmel_rx_chars(struct uart_port *port)
 {
 	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
-	struct tty_struct *tty = port->info->tty;
-	unsigned int status, ch, flg;
+	unsigned int status, ch;
 
 	status = UART_GET_CSR(port);
 	while (status & ATMEL_US_RXRDY) {
 		ch = UART_GET_CHAR(port);
 
-		port->icount.rx++;
-
-		flg = TTY_NORMAL;
-
 		/*
 		 * note that the error handling code is
 		 * out of the main execution path
@@ -264,17 +297,14 @@ static void atmel_rx_chars(struct uart_p
 		if (unlikely(status & (ATMEL_US_PARE | ATMEL_US_FRAME
 				       | ATMEL_US_OVRE | ATMEL_US_RXBRK)
 			     || atmel_port->break_active)) {
+
 			/* clear error */
 			UART_PUT_CR(port, ATMEL_US_RSTSTA);
+
 			if (status & ATMEL_US_RXBRK
 			    && !atmel_port->break_active) {
-				/* ignore side-effect */
-				status &= ~(ATMEL_US_PARE | ATMEL_US_FRAME);
-				port->icount.brk++;
 				atmel_port->break_active = 1;
 				UART_PUT_IER(port, ATMEL_US_RXBRK);
-				if (uart_handle_break(port))
-					goto ignore_char;
 			} else {
 				/*
 				 * This is either the end-of-break
@@ -287,52 +317,30 @@ static void atmel_rx_chars(struct uart_p
 				status &= ~ATMEL_US_RXBRK;
 				atmel_port->break_active = 0;
 			}
-			if (status & ATMEL_US_PARE)
-				port->icount.parity++;
-			if (status & ATMEL_US_FRAME)
-				port->icount.frame++;
-			if (status & ATMEL_US_OVRE)
-				port->icount.overrun++;
-
-			status &= port->read_status_mask;
-
-			if (status & ATMEL_US_RXBRK)
-				flg = TTY_BREAK;
-			else if (status & ATMEL_US_PARE)
-				flg = TTY_PARITY;
-			else if (status & ATMEL_US_FRAME)
-				flg = TTY_FRAME;
 		}
 
-		if (uart_handle_sysrq_char(port, ch))
-			goto ignore_char;
-
-		uart_insert_char(port, status, ATMEL_US_OVRE, ch, flg);
-
-ignore_char:
+		atmel_buffer_rx_char(port, status, ch);
 		status = UART_GET_CSR(port);
 	}
 
-	tty_flip_buffer_push(tty);
+	tasklet_schedule(&atmel_port->tasklet);
 }
 
 /*
- * Transmit characters (called from interrupt handler)
+ * Transmit characters (called from tasklet with TXRDY interrupt
+ * disabled)
  */
 static void atmel_tx_chars(struct uart_port *port)
 {
 	struct circ_buf *xmit = &port->info->xmit;
 
-	if (port->x_char) {
+	if (port->x_char && UART_GET_CSR(port) & ATMEL_US_TXRDY) {
 		UART_PUT_CHAR(port, port->x_char);
 		port->icount.tx++;
 		port->x_char = 0;
-		return;
 	}
-	if (uart_circ_empty(xmit) || uart_tx_stopped(port)) {
-		atmel_stop_tx(port);
+	if (uart_circ_empty(xmit) || uart_tx_stopped(port))
 		return;
-	}
 
 	while (UART_GET_CSR(port) & ATMEL_US_TXRDY) {
 		UART_PUT_CHAR(port, xmit->buf[xmit->tail]);
@@ -345,8 +353,8 @@ static void atmel_tx_chars(struct uart_p
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 		uart_write_wakeup(port);
 
-	if (uart_circ_empty(xmit))
-		atmel_stop_tx(port);
+	if (!uart_circ_empty(xmit))
+		UART_PUT_IER(port, ATMEL_US_TXRDY);
 }
 
 /*
@@ -372,14 +380,18 @@ atmel_handle_receive(struct uart_port *p
 }
 
 /*
- * transmit interrupt handler.
+ * transmit interrupt handler. (Transmit is IRQF_NODELAY safe)
  */
 static void
 atmel_handle_transmit(struct uart_port *port, unsigned int pending)
 {
+	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+
 	/* Interrupt transmit */
-	if (pending & ATMEL_US_TXRDY)
-		atmel_tx_chars(port);
+	if (pending & ATMEL_US_TXRDY) {
+		UART_PUT_IDR(port, ATMEL_US_TXRDY);
+		tasklet_schedule(&atmel_port->tasklet);
+	}
 }
 
 /*
@@ -389,18 +401,13 @@ static void
 atmel_handle_status(struct uart_port *port, unsigned int pending,
 		    unsigned int status)
 {
-	/* TODO: All reads to CSR will clear these interrupts! */
-	if (pending & ATMEL_US_RIIC)
-		port->icount.rng++;
-	if (pending & ATMEL_US_DSRIC)
-		port->icount.dsr++;
-	if (pending & ATMEL_US_DCDIC)
-		uart_handle_dcd_change(port, !(status & ATMEL_US_DCD));
-	if (pending & ATMEL_US_CTSIC)
-		uart_handle_cts_change(port, !(status & ATMEL_US_CTS));
+	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+
 	if (pending & (ATMEL_US_RIIC | ATMEL_US_DSRIC | ATMEL_US_DCDIC
-				| ATMEL_US_CTSIC))
-		wake_up_interruptible(&port->info->delta_msr_wait);
+				| ATMEL_US_CTSIC)) {
+		atmel_port->irq_status = status;
+		tasklet_schedule(&atmel_port->tasklet);
+	}
 }
 
 /*
@@ -427,6 +434,114 @@ static irqreturn_t atmel_interrupt(int i
 	return IRQ_HANDLED;
 }
 
+static void atmel_rx_from_ring(struct uart_port *port)
+{
+	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct circ_buf *ring = &atmel_port->rx_ring;
+	unsigned int flg;
+	unsigned int status;
+
+	while (ring->head != ring->tail) {
+		struct atmel_uart_char c;
+
+		/* Make sure c is loaded after head. */
+		smp_rmb();
+
+		c = ((struct atmel_uart_char *)ring->buf)[ring->tail];
+
+		ring->tail = (ring->tail + 1) & (ATMEL_SERIAL_RINGSIZE - 1);
+
+		port->icount.rx++;
+		status = c.status;
+		flg = TTY_NORMAL;
+
+		/*
+		 * note that the error handling code is
+		 * out of the main execution path
+		 */
+		if (unlikely(status & (ATMEL_US_PARE | ATMEL_US_FRAME
+				       | ATMEL_US_OVRE | ATMEL_US_RXBRK))) {
+			if (status & ATMEL_US_RXBRK) {
+				/* ignore side-effect */
+				status &= ~(ATMEL_US_PARE | ATMEL_US_FRAME);
+
+				port->icount.brk++;
+				if (uart_handle_break(port))
+					continue;
+			}
+			if (status & ATMEL_US_PARE)
+				port->icount.parity++;
+			if (status & ATMEL_US_FRAME)
+				port->icount.frame++;
+			if (status & ATMEL_US_OVRE)
+				port->icount.overrun++;
+
+			status &= port->read_status_mask;
+
+			if (status & ATMEL_US_RXBRK)
+				flg = TTY_BREAK;
+			else if (status & ATMEL_US_PARE)
+				flg = TTY_PARITY;
+			else if (status & ATMEL_US_FRAME)
+				flg = TTY_FRAME;
+		}
+
+
+		if (uart_handle_sysrq_char(port, c.ch))
+			continue;
+
+		uart_insert_char(port, status, ATMEL_US_OVRE, c.ch, flg);
+	}
+
+	/*
+	 * Drop the lock here since it might end up calling
+	 * uart_start(), which takes the lock.
+	 */
+	spin_unlock(&port->lock);
+	tty_flip_buffer_push(port->info->tty);
+	spin_lock(&port->lock);
+}
+
+/*
+ * tasklet handling tty stuff outside the interrupt handler.
+ */
+static void atmel_tasklet_func(unsigned long data)
+{
+	struct uart_port *port = (struct uart_port *)data;
+	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	unsigned int status;
+	unsigned int status_change;
+
+	/* The interrupt handler does not take the lock */
+	spin_lock(&port->lock);
+
+	atmel_tx_chars(port);
+
+	status = atmel_port->irq_status;
+	status_change = status ^ atmel_port->irq_status_prev;
+
+	if (status_change & (ATMEL_US_RI | ATMEL_US_DSR
+				| ATMEL_US_DCD | ATMEL_US_CTS)) {
+		/* TODO: All reads to CSR will clear these interrupts! */
+		if (status_change & ATMEL_US_RI)
+			port->icount.rng++;
+		if (status_change & ATMEL_US_DSR)
+			port->icount.dsr++;
+		if (status_change & ATMEL_US_DCD)
+			uart_handle_dcd_change(port, !(status & ATMEL_US_DCD));
+		if (status_change & ATMEL_US_CTS)
+			uart_handle_cts_change(port, !(status & ATMEL_US_CTS));
+
+		wake_up_interruptible(&port->info->delta_msr_wait);
+
+		atmel_port->irq_status_prev = status;
+	}
+
+	atmel_rx_from_ring(port);
+
+	spin_unlock(&port->lock);
+}
+
 /*
  * Perform initialization and enable port for reception
  */
@@ -758,6 +873,11 @@ static void __devinit atmel_init_port(st
 	port->mapbase	= pdev->resource[0].start;
 	port->irq	= pdev->resource[1].start;
 
+	tasklet_init(&atmel_port->tasklet, atmel_tasklet_func,
+			(unsigned long)port);
+
+	memset(&atmel_port->rx_ring, 0, sizeof(atmel_port->rx_ring));
+
 	if (data->regs)
 		/* Already mapped by setup code */
 		port->membase = data->regs;
@@ -998,11 +1118,20 @@ static int atmel_serial_resume(struct pl
 static int __devinit atmel_serial_probe(struct platform_device *pdev)
 {
 	struct atmel_uart_port *port;
+	void *data;
 	int ret;
 
+	BUILD_BUG_ON(!is_power_of_2(ATMEL_SERIAL_RINGSIZE));
+
 	port = &atmel_ports[pdev->id];
 	atmel_init_port(port, pdev);
 
+	ret = -ENOMEM;
+	data = kmalloc(ATMEL_SERIAL_RINGSIZE, GFP_KERNEL);
+	if (!data)
+		goto err_alloc_ring;
+	port->rx_ring.buf = data;
+
 	ret = uart_add_one_port(&atmel_uart, &port->uart);
 	if (ret)
 		goto err_add_port;
@@ -1013,6 +1142,9 @@ static int __devinit atmel_serial_probe(
 	return 0;
 
 err_add_port:
+	kfree(port->rx_ring.buf);
+	port->rx_ring.buf = NULL;
+err_alloc_ring:
 	if (!atmel_is_console_port(&port->uart)) {
 		clk_disable(port->clk);
 		clk_put(port->clk);
@@ -1033,6 +1165,9 @@ static int __devexit atmel_serial_remove
 
 	ret = uart_remove_one_port(&atmel_uart, port);
 
+	tasklet_kill(&atmel_port->tasklet);
+	kfree(atmel_port->rx_ring.buf);
+
 	/* "port" is allocated statically, so we shouldn't free it */
 
 	clk_disable(atmel_port->clk);
_

Patches currently in -mm which might be from linux@bohmer.net are

atmel_serial-clean-up-the-code.patch
atmel_serial-split-the-interrupt-handler.patch
atmel_serial-add-dma-support.patch
