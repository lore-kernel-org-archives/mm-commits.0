From: akpm@linux-foundation.org
Subject: + atmel_serial-clean-up-the-code.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:17:47 -0800
Message-ID: <200801270517.m0R5HiiP031144@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41529 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750920AbYA0FSQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:18:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@bohmer.net, hskinnemoen@atmel.com, linux@maxim.org.za, marc.pignat@hevs.ch


The patch titled
     atmel_serial: clean up the code
has been added to the -mm tree.  Its filename is
     atmel_serial-clean-up-the-code.patch

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
Subject: atmel_serial: clean up the code
From: Remy Bohmer <linux@bohmer.net>

Clean up the atmel_serial driver to conform the coding rules.  It contains no
functional change.

Signed-off-by: Remy Bohmer <linux@bohmer.net>
Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Acked-by: Andrew Victor <linux@maxim.org.za>
Tested-by: Marc Pignat <marc.pignat@hevs.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/atmel_serial.c |  255 ++++++++++++++++++--------------
 1 file changed, 150 insertions(+), 105 deletions(-)

diff -puN drivers/serial/atmel_serial.c~atmel_serial-clean-up-the-code drivers/serial/atmel_serial.c
--- a/drivers/serial/atmel_serial.c~atmel_serial-clean-up-the-code
+++ a/drivers/serial/atmel_serial.c
@@ -74,6 +74,7 @@
 
 #define ATMEL_ISR_PASS_LIMIT	256
 
+/* UART registers. CR is write-only, hence no GET macro */
 #define UART_PUT_CR(port,v)	__raw_writel(v, (port)->membase + ATMEL_US_CR)
 #define UART_GET_MR(port)	__raw_readl((port)->membase + ATMEL_US_MR)
 #define UART_PUT_MR(port,v)	__raw_writel(v, (port)->membase + ATMEL_US_MR)
@@ -87,8 +88,6 @@
 #define UART_PUT_BRGR(port,v)	__raw_writel(v, (port)->membase + ATMEL_US_BRGR)
 #define UART_PUT_RTOR(port,v)	__raw_writel(v, (port)->membase + ATMEL_US_RTOR)
 
-// #define UART_GET_CR(port)	__raw_readl((port)->membase + ATMEL_US_CR)		// is write-only
-
  /* PDC registers */
 #define UART_PUT_PTCR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_PTCR)
 #define UART_GET_PTSR(port)	__raw_readl((port)->membase + ATMEL_PDC_PTSR)
@@ -101,8 +100,6 @@
 
 #define UART_PUT_TPR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_TPR)
 #define UART_PUT_TCR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_TCR)
-//#define UART_PUT_TNPR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_TNPR)
-//#define UART_PUT_TNCR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_TNCR)
 
 static int (*atmel_open_hook)(struct uart_port *);
 static void (*atmel_close_hook)(struct uart_port *);
@@ -142,8 +139,8 @@ static void atmel_set_mctrl(struct uart_
 #ifdef CONFIG_ARCH_AT91RM9200
 	if (cpu_is_at91rm9200()) {
 		/*
-		 * AT91RM9200 Errata #39: RTS0 is not internally connected to PA21.
-		 *  We need to drive the pin manually.
+		 * AT91RM9200 Errata #39: RTS0 is not internally connected
+		 * to PA21. We need to drive the pin manually.
 		 */
 		if (port->mapbase == AT91RM9200_BASE_US0) {
 			if (mctrl & TIOCM_RTS)
@@ -228,7 +225,8 @@ static void atmel_stop_rx(struct uart_po
  */
 static void atmel_enable_ms(struct uart_port *port)
 {
-	UART_PUT_IER(port, ATMEL_US_RIIC | ATMEL_US_DSRIC | ATMEL_US_DCDIC | ATMEL_US_CTSIC);
+	UART_PUT_IER(port, ATMEL_US_RIIC | ATMEL_US_DSRIC
+			| ATMEL_US_DCDIC | ATMEL_US_CTSIC);
 }
 
 /*
@@ -247,7 +245,7 @@ static void atmel_break_ctl(struct uart_
  */
 static void atmel_rx_chars(struct uart_port *port)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *) port;
+	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
 	struct tty_struct *tty = port->info->tty;
 	unsigned int status, ch, flg;
 
@@ -266,10 +264,12 @@ static void atmel_rx_chars(struct uart_p
 		if (unlikely(status & (ATMEL_US_PARE | ATMEL_US_FRAME
 				       | ATMEL_US_OVRE | ATMEL_US_RXBRK)
 			     || atmel_port->break_active)) {
-			UART_PUT_CR(port, ATMEL_US_RSTSTA);	/* clear error */
+			/* clear error */
+			UART_PUT_CR(port, ATMEL_US_RSTSTA);
 			if (status & ATMEL_US_RXBRK
 			    && !atmel_port->break_active) {
-				status &= ~(ATMEL_US_PARE | ATMEL_US_FRAME);	/* ignore side-effect */
+				/* ignore side-effect */
+				status &= ~(ATMEL_US_PARE | ATMEL_US_FRAME);
 				port->icount.brk++;
 				atmel_port->break_active = 1;
 				UART_PUT_IER(port, ATMEL_US_RXBRK);
@@ -309,7 +309,7 @@ static void atmel_rx_chars(struct uart_p
 
 		uart_insert_char(port, status, ATMEL_US_OVRE, ch, flg);
 
-	ignore_char:
+ignore_char:
 		status = UART_GET_CSR(port);
 	}
 
@@ -350,44 +350,73 @@ static void atmel_tx_chars(struct uart_p
 }
 
 /*
+ * receive interrupt handler.
+ */
+static void
+atmel_handle_receive(struct uart_port *port, unsigned int pending)
+{
+	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+
+	/* Interrupt receive */
+	if (pending & ATMEL_US_RXRDY)
+		atmel_rx_chars(port);
+	else if (pending & ATMEL_US_RXBRK) {
+		/*
+		 * End of break detected. If it came along with a
+		 * character, atmel_rx_chars will handle it.
+		 */
+		UART_PUT_CR(port, ATMEL_US_RSTSTA);
+		UART_PUT_IDR(port, ATMEL_US_RXBRK);
+		atmel_port->break_active = 0;
+	}
+}
+
+/*
+ * transmit interrupt handler.
+ */
+static void
+atmel_handle_transmit(struct uart_port *port, unsigned int pending)
+{
+	/* Interrupt transmit */
+	if (pending & ATMEL_US_TXRDY)
+		atmel_tx_chars(port);
+}
+
+/*
+ * status flags interrupt handler.
+ */
+static void
+atmel_handle_status(struct uart_port *port, unsigned int pending,
+		    unsigned int status)
+{
+	/* TODO: All reads to CSR will clear these interrupts! */
+	if (pending & ATMEL_US_RIIC)
+		port->icount.rng++;
+	if (pending & ATMEL_US_DSRIC)
+		port->icount.dsr++;
+	if (pending & ATMEL_US_DCDIC)
+		uart_handle_dcd_change(port, !(status & ATMEL_US_DCD));
+	if (pending & ATMEL_US_CTSIC)
+		uart_handle_cts_change(port, !(status & ATMEL_US_CTS));
+	if (pending & (ATMEL_US_RIIC | ATMEL_US_DSRIC | ATMEL_US_DCDIC
+				| ATMEL_US_CTSIC))
+		wake_up_interruptible(&port->info->delta_msr_wait);
+}
+
+/*
  * Interrupt handler
  */
 static irqreturn_t atmel_interrupt(int irq, void *dev_id)
 {
 	struct uart_port *port = dev_id;
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *) port;
 	unsigned int status, pending, pass_counter = 0;
 
 	status = UART_GET_CSR(port);
 	pending = status & UART_GET_IMR(port);
 	while (pending) {
-		/* Interrupt receive */
-		if (pending & ATMEL_US_RXRDY)
-			atmel_rx_chars(port);
-		else if (pending & ATMEL_US_RXBRK) {
-			/*
-			 * End of break detected. If it came along
-			 * with a character, atmel_rx_chars will
-			 * handle it.
-			 */
-			UART_PUT_CR(port, ATMEL_US_RSTSTA);
-			UART_PUT_IDR(port, ATMEL_US_RXBRK);
-			atmel_port->break_active = 0;
-		}
-
-		// TODO: All reads to CSR will clear these interrupts!
-		if (pending & ATMEL_US_RIIC) port->icount.rng++;
-		if (pending & ATMEL_US_DSRIC) port->icount.dsr++;
-		if (pending & ATMEL_US_DCDIC)
-			uart_handle_dcd_change(port, !(status & ATMEL_US_DCD));
-		if (pending & ATMEL_US_CTSIC)
-			uart_handle_cts_change(port, !(status & ATMEL_US_CTS));
-		if (pending & (ATMEL_US_RIIC | ATMEL_US_DSRIC | ATMEL_US_DCDIC | ATMEL_US_CTSIC))
-			wake_up_interruptible(&port->info->delta_msr_wait);
-
-		/* Interrupt transmit */
-		if (pending & ATMEL_US_TXRDY)
-			atmel_tx_chars(port);
+		atmel_handle_receive(port, pending);
+		atmel_handle_status(port, pending, status);
+		atmel_handle_transmit(port, pending);
 
 		if (pass_counter++ > ATMEL_ISR_PASS_LIMIT)
 			break;
@@ -415,7 +444,8 @@ static int atmel_startup(struct uart_por
 	/*
 	 * Allocate the IRQ
 	 */
-	retval = request_irq(port->irq, atmel_interrupt, IRQF_SHARED, "atmel_serial", port);
+	retval = request_irq(port->irq, atmel_interrupt, IRQF_SHARED,
+			"atmel_serial", port);
 	if (retval) {
 		printk("atmel_serial: atmel_startup - Can't get irq\n");
 		return retval;
@@ -437,9 +467,11 @@ static int atmel_startup(struct uart_por
 	 * Finally, enable the serial port
 	 */
 	UART_PUT_CR(port, ATMEL_US_RSTSTA | ATMEL_US_RSTRX);
-	UART_PUT_CR(port, ATMEL_US_TXEN | ATMEL_US_RXEN);		/* enable xmit & rcvr */
+	/* enable xmit & rcvr */
+	UART_PUT_CR(port, ATMEL_US_TXEN | ATMEL_US_RXEN);
 
-	UART_PUT_IER(port, ATMEL_US_RXRDY);		/* enable receive only */
+	/* enable receive only */
+	UART_PUT_IER(port, ATMEL_US_RXRDY);
 
 	return 0;
 }
@@ -471,45 +503,48 @@ static void atmel_shutdown(struct uart_p
 /*
  * Power / Clock management.
  */
-static void atmel_serial_pm(struct uart_port *port, unsigned int state, unsigned int oldstate)
+static void atmel_serial_pm(struct uart_port *port, unsigned int state,
+			    unsigned int oldstate)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *) port;
+	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
 
 	switch (state) {
-		case 0:
-			/*
-			 * Enable the peripheral clock for this serial port.
-			 * This is called on uart_open() or a resume event.
-			 */
-			clk_enable(atmel_port->clk);
-			break;
-		case 3:
-			/*
-			 * Disable the peripheral clock for this serial port.
-			 * This is called on uart_close() or a suspend event.
-			 */
-			clk_disable(atmel_port->clk);
-			break;
-		default:
-			printk(KERN_ERR "atmel_serial: unknown pm %d\n", state);
+	case 0:
+		/*
+		 * Enable the peripheral clock for this serial port.
+		 * This is called on uart_open() or a resume event.
+		 */
+		clk_enable(atmel_port->clk);
+		break;
+	case 3:
+		/*
+		 * Disable the peripheral clock for this serial port.
+		 * This is called on uart_close() or a suspend event.
+		 */
+		clk_disable(atmel_port->clk);
+		break;
+	default:
+		printk(KERN_ERR "atmel_serial: unknown pm %d\n", state);
 	}
 }
 
 /*
  * Change the port parameters
  */
-static void atmel_set_termios(struct uart_port *port, struct ktermios * termios, struct ktermios * old)
+static void atmel_set_termios(struct uart_port *port, struct ktermios *termios,
+			      struct ktermios *old)
 {
 	unsigned long flags;
 	unsigned int mode, imr, quot, baud;
 
 	/* Get current mode register */
-	mode = UART_GET_MR(port) & ~(ATMEL_US_USCLKS | ATMEL_US_CHRL | ATMEL_US_NBSTOP | ATMEL_US_PAR);
+	mode = UART_GET_MR(port) & ~(ATMEL_US_USCLKS | ATMEL_US_CHRL
+					| ATMEL_US_NBSTOP | ATMEL_US_PAR);
 
-	baud = uart_get_baud_rate(port, termios, old, 0, port->uartclk/16);
+	baud = uart_get_baud_rate(port, termios, old, 0, port->uartclk / 16);
 	quot = uart_get_divisor(port, baud);
 
-	if (quot > 65535) {		/* BRGR is 16-bit, so switch to slower clock */
+	if (quot > 65535) {	/* BRGR is 16-bit, so switch to slower clock */
 		quot /= 8;
 		mode |= ATMEL_US_USCLKS_MCK_DIV8;
 	}
@@ -536,18 +571,17 @@ static void atmel_set_termios(struct uar
 
 	/* parity */
 	if (termios->c_cflag & PARENB) {
-		if (termios->c_cflag & CMSPAR) {			/* Mark or Space parity */
+		/* Mark or Space parity */
+		if (termios->c_cflag & CMSPAR) {
 			if (termios->c_cflag & PARODD)
 				mode |= ATMEL_US_PAR_MARK;
 			else
 				mode |= ATMEL_US_PAR_SPACE;
-		}
-		else if (termios->c_cflag & PARODD)
+		} else if (termios->c_cflag & PARODD)
 			mode |= ATMEL_US_PAR_ODD;
 		else
 			mode |= ATMEL_US_PAR_EVEN;
-	}
-	else
+	} else
 		mode |= ATMEL_US_PAR_NONE;
 
 	spin_lock_irqsave(&port->lock, flags);
@@ -573,16 +607,16 @@ static void atmel_set_termios(struct uar
 		if (termios->c_iflag & IGNPAR)
 			port->ignore_status_mask |= ATMEL_US_OVRE;
 	}
-
-	// TODO: Ignore all characters if CREAD is set.
+	/* TODO: Ignore all characters if CREAD is set.*/
 
 	/* update the per-port timeout */
 	uart_update_timeout(port, termios->c_cflag, baud);
 
-	/* disable interrupts and drain transmitter */
-	imr = UART_GET_IMR(port);	/* get interrupt mask */
-	UART_PUT_IDR(port, -1);		/* disable all interrupts */
-	while (!(UART_GET_CSR(port) & ATMEL_US_TXEMPTY)) { barrier(); }
+	/* save/disable interrupts and drain transmitter */
+	imr = UART_GET_IMR(port);
+	UART_PUT_IDR(port, -1);
+	while (!(UART_GET_CSR(port) & ATMEL_US_TXEMPTY))
+		barrier();
 
 	/* disable receiver and transmitter */
 	UART_PUT_CR(port, ATMEL_US_TXDIS | ATMEL_US_RXDIS);
@@ -708,7 +742,8 @@ static struct uart_ops atmel_pops = {
 /*
  * Configure the port from the platform device resource info.
  */
-static void __devinit atmel_init_port(struct atmel_uart_port *atmel_port, struct platform_device *pdev)
+static void __devinit atmel_init_port(struct atmel_uart_port *atmel_port,
+				      struct platform_device *pdev)
 {
 	struct uart_port *port = &atmel_port->uart;
 	struct atmel_uart_data *data = pdev->dev.platform_data;
@@ -731,7 +766,8 @@ static void __devinit atmel_init_port(st
 		port->membase	= NULL;
 	}
 
-	if (!atmel_port->clk) {		/* for console, the clock could already be configured */
+	/* for console, the clock could already be configured */
+	if (!atmel_port->clk) {
 		atmel_port->clk = clk_get(&pdev->dev, "usart");
 		clk_enable(atmel_port->clk);
 		port->uartclk = clk_get_rate(atmel_port->clk);
@@ -755,7 +791,6 @@ void __init atmel_register_uart_fns(stru
 	atmel_pops.set_wake	= fns->set_wake;
 }
 
-
 #ifdef CONFIG_SERIAL_ATMEL_CONSOLE
 static void atmel_console_putchar(struct uart_port *port, int ch)
 {
@@ -773,28 +808,30 @@ static void atmel_console_write(struct c
 	unsigned int status, imr;
 
 	/*
-	 *	First, save IMR and then disable interrupts
+	 * First, save IMR and then disable interrupts
 	 */
-	imr = UART_GET_IMR(port);	/* get interrupt mask */
+	imr = UART_GET_IMR(port);
 	UART_PUT_IDR(port, ATMEL_US_RXRDY | ATMEL_US_TXRDY);
 
 	uart_console_write(port, s, count, atmel_console_putchar);
 
 	/*
-	 *	Finally, wait for transmitter to become empty
-	 *	and restore IMR
+	 * Finally, wait for transmitter to become empty
+	 * and restore IMR
 	 */
 	do {
 		status = UART_GET_CSR(port);
 	} while (!(status & ATMEL_US_TXRDY));
-	UART_PUT_IER(port, imr);	/* set interrupts back the way they were */
+	/* set interrupts back the way they were */
+	UART_PUT_IER(port, imr);
 }
 
 /*
- * If the port was already initialised (eg, by a boot loader), try to determine
- * the current setup.
+ * If the port was already initialised (eg, by a boot loader),
+ * try to determine the current setup.
  */
-static void __init atmel_console_get_options(struct uart_port *port, int *baud, int *parity, int *bits)
+static void __init atmel_console_get_options(struct uart_port *port, int *baud,
+					     int *parity, int *bits)
 {
 	unsigned int mr, quot;
 
@@ -836,10 +873,12 @@ static int __init atmel_console_setup(st
 	int parity = 'n';
 	int flow = 'n';
 
-	if (port->membase == 0)		/* Port not initialized yet - delay setup */
+	if (port->membase == NULL) {
+		/* Port not initialized yet - delay setup */
 		return -ENODEV;
+	}
 
-	UART_PUT_IDR(port, -1);				/* disable interrupts */
+	UART_PUT_IDR(port, -1);
 	UART_PUT_CR(port, ATMEL_US_RSTSTA | ATMEL_US_RSTRX);
 	UART_PUT_CR(port, ATMEL_US_TXEN | ATMEL_US_RXEN);
 
@@ -871,13 +910,16 @@ static struct console atmel_console = {
 static int __init atmel_console_init(void)
 {
 	if (atmel_default_console_device) {
-		add_preferred_console(ATMEL_DEVICENAME, atmel_default_console_device->id, NULL);
-		atmel_init_port(&(atmel_ports[atmel_default_console_device->id]), atmel_default_console_device);
+		add_preferred_console(ATMEL_DEVICENAME,
+				      atmel_default_console_device->id, NULL);
+		atmel_init_port(&atmel_ports[atmel_default_console_device->id],
+				atmel_default_console_device);
 		register_console(&atmel_console);
 	}
 
 	return 0;
 }
+
 console_initcall(atmel_console_init);
 
 /*
@@ -885,11 +927,13 @@ console_initcall(atmel_console_init);
  */
 static int __init atmel_late_console_init(void)
 {
-	if (atmel_default_console_device && !(atmel_console.flags & CON_ENABLED))
+	if (atmel_default_console_device
+	    && !(atmel_console.flags & CON_ENABLED))
 		register_console(&atmel_console);
 
 	return 0;
 }
+
 core_initcall(atmel_late_console_init);
 
 #else
@@ -897,22 +941,24 @@ core_initcall(atmel_late_console_init);
 #endif
 
 static struct uart_driver atmel_uart = {
-	.owner			= THIS_MODULE,
-	.driver_name		= "atmel_serial",
-	.dev_name		= ATMEL_DEVICENAME,
-	.major			= SERIAL_ATMEL_MAJOR,
-	.minor			= MINOR_START,
-	.nr			= ATMEL_MAX_UART,
-	.cons			= ATMEL_CONSOLE_DEVICE,
+	.owner		= THIS_MODULE,
+	.driver_name	= "atmel_serial",
+	.dev_name	= ATMEL_DEVICENAME,
+	.major		= SERIAL_ATMEL_MAJOR,
+	.minor		= MINOR_START,
+	.nr		= ATMEL_MAX_UART,
+	.cons		= ATMEL_CONSOLE_DEVICE,
 };
 
 #ifdef CONFIG_PM
-static int atmel_serial_suspend(struct platform_device *pdev, pm_message_t state)
+static int atmel_serial_suspend(struct platform_device *pdev,
+				pm_message_t state)
 {
 	struct uart_port *port = platform_get_drvdata(pdev);
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *) port;
+	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
 
-	if (device_may_wakeup(&pdev->dev) && !at91_suspend_entering_slow_clock())
+	if (device_may_wakeup(&pdev->dev)
+	    && !at91_suspend_entering_slow_clock())
 		enable_irq_wake(port->irq);
 	else {
 		uart_suspend_port(&atmel_uart, port);
@@ -925,13 +971,12 @@ static int atmel_serial_suspend(struct p
 static int atmel_serial_resume(struct platform_device *pdev)
 {
 	struct uart_port *port = platform_get_drvdata(pdev);
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *) port;
+	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
 
 	if (atmel_port->suspended) {
 		uart_resume_port(&atmel_uart, port);
 		atmel_port->suspended = 0;
-	}
-	else
+	} else
 		disable_irq_wake(port->irq);
 
 	return 0;
@@ -961,7 +1006,7 @@ static int __devinit atmel_serial_probe(
 static int __devexit atmel_serial_remove(struct platform_device *pdev)
 {
 	struct uart_port *port = platform_get_drvdata(pdev);
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *) port;
+	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
 	int ret = 0;
 
 	clk_disable(atmel_port->clk);
_

Patches currently in -mm which might be from linux@bohmer.net are

atmel_serial-clean-up-the-code.patch
atmel_serial-split-the-interrupt-handler.patch
atmel_serial-add-dma-support.patch
