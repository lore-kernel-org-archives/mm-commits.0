From: akpm@linux-foundation.org
Subject: [merged] blackfin-serial-driver-change-hardware-flowcontrol-from-poll-to-interrupt-driven.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:10:01 -0700
Message-ID: <200904071910.n37JA1sK012626@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47682 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751287AbZDGT7p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:59:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sonic.zhang@analog.com, alan@lxorguk.ukuu.org.uk, cooloney@kernel.org, mm-commits@vger.kernel.org


The patch titled
     blackfin serial driver: change hardware flowcontrol from poll to interrupt driven.
has been removed from the -mm tree.  Its filename was
     blackfin-serial-driver-change-hardware-flowcontrol-from-poll-to-interrupt-driven.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: blackfin serial driver: change hardware flowcontrol from poll to interrupt driven.
From: Sonic Zhang <sonic.zhang@analog.com>

Only CTS bit is affected.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/mach-bf527/include/mach/bfin_serial_5xx.h |   26 -
 arch/blackfin/mach-bf533/include/mach/bfin_serial_5xx.h |   20 -
 arch/blackfin/mach-bf537/include/mach/bfin_serial_5xx.h |   27 --
 arch/blackfin/mach-bf548/include/mach/bfin_serial_5xx.h |   45 ---
 arch/blackfin/mach-bf561/include/mach/bfin_serial_5xx.h |   20 -
 drivers/serial/bfin_5xx.c                               |  131 ++++++----
 6 files changed, 82 insertions(+), 187 deletions(-)

diff -puN arch/blackfin/mach-bf527/include/mach/bfin_serial_5xx.h~blackfin-serial-driver-change-hardware-flowcontrol-from-poll-to-interrupt-driven arch/blackfin/mach-bf527/include/mach/bfin_serial_5xx.h
--- a/arch/blackfin/mach-bf527/include/mach/bfin_serial_5xx.h~blackfin-serial-driver-change-hardware-flowcontrol-from-poll-to-interrupt-driven
+++ a/arch/blackfin/mach-bf527/include/mach/bfin_serial_5xx.h
@@ -167,29 +167,3 @@ struct bfin_serial_res bfin_serial_resou
 };
 
 #define DRIVER_NAME "bfin-uart"
-
-static void bfin_serial_hw_init(struct bfin_serial_port *uart)
-{
-
-#ifdef CONFIG_SERIAL_BFIN_UART0
-	peripheral_request(P_UART0_TX, DRIVER_NAME);
-	peripheral_request(P_UART0_RX, DRIVER_NAME);
-#endif
-
-#ifdef CONFIG_SERIAL_BFIN_UART1
-	peripheral_request(P_UART1_TX, DRIVER_NAME);
-	peripheral_request(P_UART1_RX, DRIVER_NAME);
-#endif
-
-#ifdef CONFIG_SERIAL_BFIN_CTSRTS
-	if (uart->cts_pin >= 0) {
-		gpio_request(uart->cts_pin, DRIVER_NAME);
-		gpio_direction_input(uart->cts_pin);
-	}
-
-	if (uart->rts_pin >= 0) {
-		gpio_request(uart->rts_pin, DRIVER_NAME);
-		gpio_direction_output(uart->rts_pin, 0);
-	}
-#endif
-}
diff -puN arch/blackfin/mach-bf533/include/mach/bfin_serial_5xx.h~blackfin-serial-driver-change-hardware-flowcontrol-from-poll-to-interrupt-driven arch/blackfin/mach-bf533/include/mach/bfin_serial_5xx.h
--- a/arch/blackfin/mach-bf533/include/mach/bfin_serial_5xx.h~blackfin-serial-driver-change-hardware-flowcontrol-from-poll-to-interrupt-driven
+++ a/arch/blackfin/mach-bf533/include/mach/bfin_serial_5xx.h
@@ -142,23 +142,3 @@ struct bfin_serial_res bfin_serial_resou
 };
 
 #define DRIVER_NAME "bfin-uart"
-
-static void bfin_serial_hw_init(struct bfin_serial_port *uart)
-{
-
-#ifdef CONFIG_SERIAL_BFIN_UART0
-	peripheral_request(P_UART0_TX, DRIVER_NAME);
-	peripheral_request(P_UART0_RX, DRIVER_NAME);
-#endif
-
-#ifdef CONFIG_SERIAL_BFIN_CTSRTS
-	if (uart->cts_pin >= 0) {
-		gpio_request(uart->cts_pin, DRIVER_NAME);
-		gpio_direction_input(uart->cts_pin);
-	}
-	if (uart->rts_pin >= 0) {
-		gpio_request(uart->rts_pin, DRIVER_NAME);
-		gpio_direction_output(uart->rts_pin, 0);
-	}
-#endif
-}
diff -puN arch/blackfin/mach-bf537/include/mach/bfin_serial_5xx.h~blackfin-serial-driver-change-hardware-flowcontrol-from-poll-to-interrupt-driven arch/blackfin/mach-bf537/include/mach/bfin_serial_5xx.h
--- a/arch/blackfin/mach-bf537/include/mach/bfin_serial_5xx.h~blackfin-serial-driver-change-hardware-flowcontrol-from-poll-to-interrupt-driven
+++ a/arch/blackfin/mach-bf537/include/mach/bfin_serial_5xx.h
@@ -99,7 +99,6 @@ struct bfin_serial_port {
 	struct work_struct	tx_dma_workqueue;
 #endif
 #ifdef CONFIG_SERIAL_BFIN_CTSRTS
-	struct timer_list 	cts_timer;
 	int		cts_pin;
 	int 		rts_pin;
 #endif
@@ -167,29 +166,3 @@ struct bfin_serial_res bfin_serial_resou
 };
 
 #define DRIVER_NAME "bfin-uart"
-
-static void bfin_serial_hw_init(struct bfin_serial_port *uart)
-{
-
-#ifdef CONFIG_SERIAL_BFIN_UART0
-	peripheral_request(P_UART0_TX, DRIVER_NAME);
-	peripheral_request(P_UART0_RX, DRIVER_NAME);
-#endif
-
-#ifdef CONFIG_SERIAL_BFIN_UART1
-	peripheral_request(P_UART1_TX, DRIVER_NAME);
-	peripheral_request(P_UART1_RX, DRIVER_NAME);
-#endif
-
-#ifdef CONFIG_SERIAL_BFIN_CTSRTS
-	if (uart->cts_pin >= 0) {
-		gpio_request(uart->cts_pin, DRIVER_NAME);
-		gpio_direction_input(uart->cts_pin);
-	}
-
-	if (uart->rts_pin >= 0) {
-		gpio_request(uart->rts_pin, DRIVER_NAME);
-		gpio_direction_output(uart->rts_pin, 0);
-	}
-#endif
-}
diff -puN arch/blackfin/mach-bf548/include/mach/bfin_serial_5xx.h~blackfin-serial-driver-change-hardware-flowcontrol-from-poll-to-interrupt-driven arch/blackfin/mach-bf548/include/mach/bfin_serial_5xx.h
--- a/arch/blackfin/mach-bf548/include/mach/bfin_serial_5xx.h~blackfin-serial-driver-change-hardware-flowcontrol-from-poll-to-interrupt-driven
+++ a/arch/blackfin/mach-bf548/include/mach/bfin_serial_5xx.h
@@ -181,48 +181,3 @@ struct bfin_serial_res bfin_serial_resou
 };
 
 #define DRIVER_NAME "bfin-uart"
-
-static void bfin_serial_hw_init(struct bfin_serial_port *uart)
-{
-#ifdef CONFIG_SERIAL_BFIN_UART0
-	peripheral_request(P_UART0_TX, DRIVER_NAME);
-	peripheral_request(P_UART0_RX, DRIVER_NAME);
-#endif
-
-#ifdef CONFIG_SERIAL_BFIN_UART1
-	peripheral_request(P_UART1_TX, DRIVER_NAME);
-	peripheral_request(P_UART1_RX, DRIVER_NAME);
-
-#ifdef CONFIG_BFIN_UART1_CTSRTS
-	peripheral_request(P_UART1_RTS, DRIVER_NAME);
-	peripheral_request(P_UART1_CTS, DRIVER_NAME);
-#endif
-#endif
-
-#ifdef CONFIG_SERIAL_BFIN_UART2
-	peripheral_request(P_UART2_TX, DRIVER_NAME);
-	peripheral_request(P_UART2_RX, DRIVER_NAME);
-#endif
-
-#ifdef CONFIG_SERIAL_BFIN_UART3
-	peripheral_request(P_UART3_TX, DRIVER_NAME);
-	peripheral_request(P_UART3_RX, DRIVER_NAME);
-
-#ifdef CONFIG_BFIN_UART3_CTSRTS
-	peripheral_request(P_UART3_RTS, DRIVER_NAME);
-	peripheral_request(P_UART3_CTS, DRIVER_NAME);
-#endif
-#endif
-	SSYNC();
-#ifdef CONFIG_SERIAL_BFIN_CTSRTS
-	if (uart->cts_pin >= 0) {
-		gpio_request(uart->cts_pin, DRIVER_NAME);
-		gpio_direction_input(uart->cts_pin);
-	}
-
-	if (uart->rts_pin >= 0) {
-		gpio_request(uart->rts_pin, DRIVER_NAME);
-		gpio_direction_output(uart->rts_pin, 0);
-	}
-#endif
-}
diff -puN arch/blackfin/mach-bf561/include/mach/bfin_serial_5xx.h~blackfin-serial-driver-change-hardware-flowcontrol-from-poll-to-interrupt-driven arch/blackfin/mach-bf561/include/mach/bfin_serial_5xx.h
--- a/arch/blackfin/mach-bf561/include/mach/bfin_serial_5xx.h~blackfin-serial-driver-change-hardware-flowcontrol-from-poll-to-interrupt-driven
+++ a/arch/blackfin/mach-bf561/include/mach/bfin_serial_5xx.h
@@ -142,23 +142,3 @@ struct bfin_serial_res bfin_serial_resou
 };
 
 #define DRIVER_NAME "bfin-uart"
-
-static void bfin_serial_hw_init(struct bfin_serial_port *uart)
-{
-
-#ifdef CONFIG_SERIAL_BFIN_UART0
-	peripheral_request(P_UART0_TX, DRIVER_NAME);
-	peripheral_request(P_UART0_RX, DRIVER_NAME);
-#endif
-
-#ifdef CONFIG_SERIAL_BFIN_CTSRTS
-	if (uart->cts_pin >= 0) {
-		gpio_request(uart->cts_pin, DRIVER_NAME);
-		gpio_direction_input(uart->cts_pin);
-	}
-	if (uart->rts_pin >= 0) {
-		gpio_request(uart->rts_pin, DRIVER_NAME);
-		gpio_direction_output(uart->rts_pin, 0);
-	}
-#endif
-}
diff -puN drivers/serial/bfin_5xx.c~blackfin-serial-driver-change-hardware-flowcontrol-from-poll-to-interrupt-driven drivers/serial/bfin_5xx.c
--- a/drivers/serial/bfin_5xx.c~blackfin-serial-driver-change-hardware-flowcontrol-from-poll-to-interrupt-driven
+++ a/drivers/serial/bfin_5xx.c
@@ -64,7 +64,6 @@ static int kgdboc_break_enabled;
 #define DMA_RX_YCOUNT		(PAGE_SIZE / DMA_RX_XCOUNT)
 
 #define DMA_RX_FLUSH_JIFFIES	(HZ / 50)
-#define CTS_CHECK_JIFFIES	(HZ / 50)
 
 #ifdef CONFIG_SERIAL_BFIN_DMA
 static void bfin_serial_dma_tx_chars(struct bfin_serial_port *uart);
@@ -72,8 +71,6 @@ static void bfin_serial_dma_tx_chars(str
 static void bfin_serial_tx_chars(struct bfin_serial_port *uart);
 #endif
 
-static void bfin_serial_mctrl_check(struct bfin_serial_port *uart);
-
 static void bfin_serial_reset_irda(struct uart_port *port);
 
 /*
@@ -265,12 +262,6 @@ static void bfin_serial_tx_chars(struct 
 {
 	struct circ_buf *xmit = &uart->port.info->xmit;
 
-	/*
-	 * Check the modem control lines before
-	 * transmitting anything.
-	 */
-	bfin_serial_mctrl_check(uart);
-
 	if (uart_circ_empty(xmit) || uart_tx_stopped(&uart->port)) {
 #ifdef CONFIG_BF54x
 		/* Clear TFI bit */
@@ -329,12 +320,6 @@ static void bfin_serial_dma_tx_chars(str
 
 	uart->tx_done = 0;
 
-	/*
-	 * Check the modem control lines before
-	 * transmitting anything.
-	 */
-	bfin_serial_mctrl_check(uart);
-
 	if (uart_circ_empty(xmit) || uart_tx_stopped(&uart->port)) {
 		uart->tx_count = 0;
 		uart->tx_done = 1;
@@ -524,29 +509,21 @@ static void bfin_serial_set_mctrl(struct
 #endif
 }
 
+#ifdef CONFIG_SERIAL_BFIN_CTSRTS
 /*
- * Handle any change of modem status signal since we were last called.
+ * Handle any change of modem status signal.
  */
-static void bfin_serial_mctrl_check(struct bfin_serial_port *uart)
+static irqreturn_t bfin_serial_mctrl_cts_int(int irq, void *dev_id)
 {
-#ifdef CONFIG_SERIAL_BFIN_CTSRTS
+	struct bfin_serial_port *uart = dev_id;
 	unsigned int status;
-	struct uart_info *info = uart->port.info;
-	struct tty_struct *tty = info->port.tty;
 
 	status = bfin_serial_get_mctrl(&uart->port);
 	uart_handle_cts_change(&uart->port, status & TIOCM_CTS);
-	if (!(status & TIOCM_CTS)) {
-		tty->hw_stopped = 1;
-		uart->cts_timer.data = (unsigned long)(uart);
-		uart->cts_timer.function = (void *)bfin_serial_mctrl_check;
-		uart->cts_timer.expires = jiffies + CTS_CHECK_JIFFIES;
-		add_timer(&(uart->cts_timer));
-	} else {
-		tty->hw_stopped = 0;
-	}
-#endif
+
+	return IRQ_HANDLED;
 }
+#endif
 
 /*
  * Interrupts are always disabled.
@@ -606,7 +583,7 @@ static int bfin_serial_startup(struct ua
 	uart->rx_dma_timer.expires = jiffies + DMA_RX_FLUSH_JIFFIES;
 	add_timer(&(uart->rx_dma_timer));
 #else
-#if defined(CONFIG_KGDB_SERIAL_CONSOLE) || \
+# if defined(CONFIG_KGDB_SERIAL_CONSOLE) || \
 	defined(CONFIG_KGDB_SERIAL_CONSOLE_MODULE)
 	if (kgdboc_port_line == uart->port.line && kgdboc_break_enabled)
 		kgdboc_break_enabled = 0;
@@ -661,11 +638,28 @@ static int bfin_serial_startup(struct ua
 		}
 	}
 # endif
-#if defined(CONFIG_KGDB_SERIAL_CONSOLE) || \
+# if defined(CONFIG_KGDB_SERIAL_CONSOLE) || \
 	defined(CONFIG_KGDB_SERIAL_CONSOLE_MODULE)
 	}
 # endif
 #endif
+
+#ifdef CONFIG_SERIAL_BFIN_CTSRTS
+	if (uart->cts_pin >= 0) {
+		if (request_irq(gpio_to_irq(uart->cts_pin),
+			bfin_serial_mctrl_cts_int,
+			IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING |
+			IRQF_DISABLED, "BFIN_UART_CTS", uart)) {
+			uart->cts_pin = -1;
+			pr_info("Unable to attach BlackFin UART CTS interrupt.\
+				 So, disable it.\n");
+		}
+	}
+	if (uart->rts_pin >= 0) {
+		gpio_request(uart->rts_pin, DRIVER_NAME);
+		gpio_direction_output(uart->rts_pin, 0);
+	}
+#endif
 	UART_SET_IER(uart, ERBFI);
 	return 0;
 }
@@ -699,6 +693,13 @@ static void bfin_serial_shutdown(struct 
 	free_irq(uart->port.irq, uart);
 	free_irq(uart->port.irq+1, uart);
 #endif
+
+# ifdef CONFIG_SERIAL_BFIN_CTSRTS
+	if (uart->cts_pin >= 0)
+		free_irq(gpio_to_irq(uart->cts_pin), uart);
+	if (uart->rts_pin >= 0)
+		gpio_free(uart->rts_pin);
+# endif
 }
 
 static void
@@ -864,6 +865,20 @@ static void bfin_serial_set_ldisc(struct
 	}
 }
 
+static void bfin_serial_reset_irda(struct uart_port *port)
+{
+	int line = port->line;
+	unsigned short val;
+
+	val = UART_GET_GCTL(&bfin_serial_ports[line]);
+	val &= ~(IREN | RPOLC);
+	UART_PUT_GCTL(&bfin_serial_ports[line], val);
+	SSYNC();
+	val |= (IREN | RPOLC);
+	UART_PUT_GCTL(&bfin_serial_ports[line], val);
+	SSYNC();
+}
+
 #ifdef CONFIG_CONSOLE_POLL
 static void bfin_serial_poll_put_char(struct uart_port *port, unsigned char chr)
 {
@@ -909,20 +924,6 @@ static int bfin_kgdboc_port_startup(stru
 }
 #endif
 
-static void bfin_serial_reset_irda(struct uart_port *port)
-{
-	int line = port->line;
-	unsigned short val;
-
-	val = UART_GET_GCTL(&bfin_serial_ports[line]);
-	val &= ~(IREN | RPOLC);
-	UART_PUT_GCTL(&bfin_serial_ports[line], val);
-	SSYNC();
-	val |= (IREN | RPOLC);
-	UART_PUT_GCTL(&bfin_serial_ports[line], val);
-	SSYNC();
-}
-
 static struct uart_ops bfin_serial_pops = {
 	.tx_empty	= bfin_serial_tx_empty,
 	.set_mctrl	= bfin_serial_set_mctrl,
@@ -952,6 +953,39 @@ static struct uart_ops bfin_serial_pops 
 #endif
 };
 
+static void __init bfin_serial_hw_init(void)
+{
+#ifdef CONFIG_SERIAL_BFIN_UART0
+	peripheral_request(P_UART0_TX, DRIVER_NAME);
+	peripheral_request(P_UART0_RX, DRIVER_NAME);
+#endif
+
+#ifdef CONFIG_SERIAL_BFIN_UART1
+	peripheral_request(P_UART1_TX, DRIVER_NAME);
+	peripheral_request(P_UART1_RX, DRIVER_NAME);
+
+# if defined(CONFIG_BFIN_UART1_CTSRTS) && defined(CONFIG_BF54x)
+	peripheral_request(P_UART1_RTS, DRIVER_NAME);
+	peripheral_request(P_UART1_CTS, DRIVER_NAME);
+# endif
+#endif
+
+#ifdef CONFIG_SERIAL_BFIN_UART2
+	peripheral_request(P_UART2_TX, DRIVER_NAME);
+	peripheral_request(P_UART2_RX, DRIVER_NAME);
+#endif
+
+#ifdef CONFIG_SERIAL_BFIN_UART3
+	peripheral_request(P_UART3_TX, DRIVER_NAME);
+	peripheral_request(P_UART3_RX, DRIVER_NAME);
+
+# if defined(CONFIG_BFIN_UART3_CTSRTS) && defined(CONFIG_BF54x)
+	peripheral_request(P_UART3_RTS, DRIVER_NAME);
+	peripheral_request(P_UART3_CTS, DRIVER_NAME);
+# endif
+#endif
+}
+
 static void __init bfin_serial_init_ports(void)
 {
 	static int first = 1;
@@ -961,6 +995,8 @@ static void __init bfin_serial_init_port
 		return;
 	first = 0;
 
+	bfin_serial_hw_init();
+
 	for (i = 0; i < nr_active_ports; i++) {
 		bfin_serial_ports[i].port.uartclk   = get_sclk();
 		bfin_serial_ports[i].port.fifosize  = BFIN_UART_TX_FIFO_SIZE;
@@ -984,15 +1020,12 @@ static void __init bfin_serial_init_port
 		init_timer(&(bfin_serial_ports[i].rx_dma_timer));
 #endif
 #ifdef CONFIG_SERIAL_BFIN_CTSRTS
-		init_timer(&(bfin_serial_ports[i].cts_timer));
 		bfin_serial_ports[i].cts_pin	    =
 			bfin_serial_resource[i].uart_cts_pin;
 		bfin_serial_ports[i].rts_pin	    =
 			bfin_serial_resource[i].uart_rts_pin;
 #endif
-		bfin_serial_hw_init(&bfin_serial_ports[i]);
 	}
