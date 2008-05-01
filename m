From: akpm@linux-foundation.org
Subject: - blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart.patch removed from -mm tree
Date: Thu, 01 May 2008 02:24:48 -0700
Message-ID: <200805010924.m419OmhE030142@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56619 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755309AbYEAJZ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:25:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bryan.wu@analog.com, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Blackfin serial driver: this driver enable SPORTs on Blackfin emulate UART
has been removed from the -mm tree.  Its filename was
     blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Blackfin serial driver: this driver enable SPORTs on Blackfin emulate UART
From: Bryan Wu <bryan.wu@analog.com>

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Cc: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/Kconfig           |   43 ++
 drivers/serial/Makefile          |    1 
 drivers/serial/bfin_sport_uart.c |  614 +++++++++++++++++++++++++++++
 drivers/serial/bfin_sport_uart.h |   63 ++
 include/linux/serial_core.h      |    6 
 5 files changed, 725 insertions(+), 2 deletions(-)

diff -puN drivers/serial/Kconfig~blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart drivers/serial/Kconfig
--- a/drivers/serial/Kconfig~blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart
+++ a/drivers/serial/Kconfig
@@ -1355,4 +1355,47 @@ config SERIAL_SC26XX_CONSOLE
 	help
 	  Support for Console on SC2681/SC2692 serial ports.
 
+config SERIAL_BFIN_SPORT
+	tristate "Blackfin SPORT emulate UART (EXPERIMENTAL)"
+	depends on BFIN && EXPERIMENTAL
+	select SERIAL_CORE
+	help
+	  Enble support SPORT emulate UART on Blackfin series.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called bfin_sport_uart.
+
+choice
+	prompt "Baud rate for Blackfin SPORT UART"
+	depends on SERIAL_BFIN_SPORT
+	default SERIAL_SPORT_BAUD_RATE_57600
+	help
+	  Choose a baud rate for the SPORT UART, other uart settings are
+	  8 bit, 1 stop bit, no parity, no flow control.
+
+config SERIAL_SPORT_BAUD_RATE_115200
+	bool "115200"
+
+config SERIAL_SPORT_BAUD_RATE_57600
+	bool "57600"
+
+config SERIAL_SPORT_BAUD_RATE_38400
+	bool "38400"
+
+config SERIAL_SPORT_BAUD_RATE_19200
+	bool "19200"
+
+config SERIAL_SPORT_BAUD_RATE_9600
+	bool "9600"
+endchoice
+
+config SPORT_BAUD_RATE
+	int
+	depends on SERIAL_BFIN_SPORT
+	default 115200 if (SERIAL_SPORT_BAUD_RATE_115200)
+	default 57600 if (SERIAL_SPORT_BAUD_RATE_57600)
+	default 38400 if (SERIAL_SPORT_BAUD_RATE_38400)
+	default 19200 if (SERIAL_SPORT_BAUD_RATE_19200)
+	default 9600 if (SERIAL_SPORT_BAUD_RATE_9600)
+
 endmenu
diff -puN drivers/serial/Makefile~blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart drivers/serial/Makefile
--- a/drivers/serial/Makefile~blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart
+++ a/drivers/serial/Makefile
@@ -27,6 +27,7 @@ obj-$(CONFIG_SERIAL_PXA) += pxa.o
 obj-$(CONFIG_SERIAL_PNX8XXX) += pnx8xxx_uart.o
 obj-$(CONFIG_SERIAL_SA1100) += sa1100.o
 obj-$(CONFIG_SERIAL_BFIN) += bfin_5xx.o
+obj-$(CONFIG_SERIAL_BFIN_SPORT) += bfin_sport_uart.o
 obj-$(CONFIG_SERIAL_S3C2410) += s3c2410.o
 obj-$(CONFIG_SERIAL_SUNCORE) += suncore.o
 obj-$(CONFIG_SERIAL_SUNHV) += sunhv.o
diff -puN /dev/null drivers/serial/bfin_sport_uart.c
--- /dev/null
+++ a/drivers/serial/bfin_sport_uart.c
@@ -0,0 +1,614 @@
+/*
+ * File:	linux/drivers/serial/bfin_sport_uart.c
+ *
+ * Based on:	drivers/serial/bfin_5xx.c by Aubrey Li.
+ * Author:	Roy Huang <roy.huang@analog.com>
+ *
+ * Created:	Nov 22, 2006
+ * Copyright:	(c) 2006-2007 Analog Devices Inc.
+ * Description: this driver enable SPORTs on Blackfin emulate UART.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+/*
+ * This driver and the hardware supported are in term of EE-191 of ADI.
+ * http://www.analog.com/UploadedFiles/Application_Notes/399447663EE191.pdf
+ * This application note describe how to implement a UART on a Sharc DSP,
+ * but this driver is implemented on Blackfin Processor.
+ */
+
+/* After reset, there is a prelude of low level pulse when transmit data first
+ * time. No addtional pulse in following transmit.
+ * According to document:
+ * The SPORTs are ready to start transmitting or receiving data no later than
+ * three serial clock cycles after they are enabled in the SPORTx_TCR1 or
+ * SPORTx_RCR1 register. No serial clock cycles are lost from this point on.
+ * The first internal frame sync will occur one frame sync delay after the
+ * SPORTs are ready. External frame syncs can occur as soon as the SPORT is
+ * ready.
+ */
+
+/* Thanks to Axel Alatalo <axel@rubico.se> for fixing sport rx bug. Sometimes
+ * sport receives data incorrectly. The following is Axel's words.
+ * As EE-191, sport rx samples 3 times of the UART baudrate and takes the
+ * middle smaple of every 3 samples as the data bit. For a 8-N-1 UART setting,
+ * 30 samples will be required for a byte. If transmitter sends a 1/3 bit short
+ * byte due to buadrate drift, then the 30th sample of a byte, this sample is
+ * also the third sample of the stop bit, will happens on the immediately
+ * following start bit which will be thrown away and missed. Thus since parts
+ * of the startbit will be missed and the receiver will begin to drift, the
+ * effect accumulates over time until synchronization is lost.
+ * If only require 2 samples of the stopbit (by sampling in total 29 samples),
+ * then a to short byte as in the case above will be tolerated. Then the 1/3
+ * early startbit will trigger a framesync since the last read is complete
+ * after only 2/3 stopbit and framesync is active during the last 1/3 looking
+ * for a possible early startbit. */
+
+//#define DEBUG
+
+#include <linux/module.h>
+#include <linux/ioport.h>
+#include <linux/init.h>
+#include <linux/console.h>
+#include <linux/sysrq.h>
+#include <linux/platform_device.h>
+#include <linux/tty.h>
+#include <linux/tty_flip.h>
+#include <linux/serial_core.h>
+
+#include <asm/delay.h>
+#include <asm/portmux.h>
+
+#include "bfin_sport_uart.h"
+
+unsigned short bfin_uart_pin_req_sport0[] =
+	{P_SPORT0_TFS, P_SPORT0_DTPRI, P_SPORT0_TSCLK, P_SPORT0_RFS, \
+	 P_SPORT0_DRPRI, P_SPORT0_RSCLK, P_SPORT0_DRSEC, P_SPORT0_DTSEC, 0};
+
+unsigned short bfin_uart_pin_req_sport1[] =
+	{P_SPORT1_TFS, P_SPORT1_DTPRI, P_SPORT1_TSCLK, P_SPORT1_RFS, \
+	P_SPORT1_DRPRI, P_SPORT1_RSCLK, P_SPORT1_DRSEC, P_SPORT1_DTSEC, 0};
+
+#define DRV_NAME "bfin-sport-uart"
+
+struct sport_uart_port {
+	struct uart_port	port;
+	char			*name;
+
+	int			tx_irq;
+	int			rx_irq;
+	int			err_irq;
+};
+
+static void sport_uart_tx_chars(struct sport_uart_port *up);
+static void sport_stop_tx(struct uart_port *port);
+
+static inline void tx_one_byte(struct sport_uart_port *up, unsigned int value)
+{
+	pr_debug("%s value:%x\n", __FUNCTION__, value);
+	/* Place a Start and Stop bit */
+	__asm__ volatile (
+		"R2 = b#01111111100;\n\t"
+		"R3 = b#10000000001;\n\t"
+		"%0 <<= 2;\n\t"
+		"%0 = %0 & R2;\n\t"
+		"%0 = %0 | R3;\n\t"
+		:"=r"(value)
+		:"0"(value)
+		:"R2", "R3");
+	pr_debug("%s value:%x\n", __FUNCTION__, value);
+
+	SPORT_PUT_TX(up, value);
+}
+
+static inline unsigned int rx_one_byte(struct sport_uart_port *up)
+{
+	unsigned int value, extract;
+
+	value = SPORT_GET_RX32(up);
+	pr_debug("%s value:%x\n", __FUNCTION__, value);
+
+	/* Extract 8 bits data */
+	__asm__ volatile (
+		"R5 = 0;\n\t"
+		"P0 = 8;\n\t"
+		"R1 = 0x1801(Z);\n\t"
+		"R3 = 0x0300(Z);\n\t"
+		"R4 = 0;\n\t"
+		"LSETUP(loop_s, loop_e) LC0 = P0;\nloop_s:\t"
+		"R2 = extract(%1, R1.L)(Z);\n\t"
+		"R2 <<= R4;\n\t"
+		"R5 = R5 | R2;\n\t"
+		"R1 = R1 - R3;\nloop_e:\t"
+		"R4 += 1;\n\t"
+		"%0 = R5;\n\t"
+		:"=r"(extract)
+		:"r"(value)
+		:"P0", "R1", "R2","R3","R4", "R5");
+
+	pr_debug("	extract:%x\n", extract);
+	return extract;
+}
+
+static int sport_uart_setup(struct sport_uart_port *up, int sclk, int baud_rate)
+{
+	int tclkdiv, tfsdiv, rclkdiv;
+
+	/* Set TCR1 and TCR2 */
+	SPORT_PUT_TCR1(up, (LTFS | ITFS | TFSR | TLSBIT | ITCLK));
+	SPORT_PUT_TCR2(up, 10);
+	pr_debug("%s TCR1:%x, TCR2:%x\n", __FUNCTION__, SPORT_GET_TCR1(up), SPORT_GET_TCR2(up));
+
+	/* Set RCR1 and RCR2 */
+	SPORT_PUT_RCR1(up, (RCKFE | LARFS | LRFS | RFSR | IRCLK));
+	SPORT_PUT_RCR2(up, 28);
+	pr_debug("%s RCR1:%x, RCR2:%x\n", __FUNCTION__, SPORT_GET_RCR1(up), SPORT_GET_RCR2(up));
+
+	tclkdiv = sclk/(2 * baud_rate) - 1;
+	tfsdiv = 12;
+	rclkdiv = sclk/(2 * baud_rate * 3) - 1;
+	SPORT_PUT_TCLKDIV(up, tclkdiv);
+	SPORT_PUT_TFSDIV(up, tfsdiv);
+	SPORT_PUT_RCLKDIV(up, rclkdiv);
+	SSYNC();
+	pr_debug("%s sclk:%d, baud_rate:%d, tclkdiv:%d, tfsdiv:%d, rclkdiv:%d\n",
+			__FUNCTION__, sclk, baud_rate, tclkdiv, tfsdiv, rclkdiv);
+
+	return 0;
+}
+
+static irqreturn_t sport_uart_rx_irq(int irq, void *dev_id)
+{
+	struct sport_uart_port *up = dev_id;
+	struct tty_struct *tty = up->port.info->tty;
+	unsigned int ch;
+
+	do {
+		ch = rx_one_byte(up);
+		up->port.icount.rx++;
+
+		if (uart_handle_sysrq_char(&up->port, ch))
+			;
+		else
+			tty_insert_flip_char(tty, ch, TTY_NORMAL);
+	} while (SPORT_GET_STAT(up) & RXNE);
+	tty_flip_buffer_push(tty);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t sport_uart_tx_irq(int irq, void *dev_id)
+{
+	sport_uart_tx_chars(dev_id);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t sport_uart_err_irq(int irq, void *dev_id)
+{
+	struct sport_uart_port *up = dev_id;
+	struct tty_struct *tty = up->port.info->tty;
+	unsigned int stat = SPORT_GET_STAT(up);
+
+	/* Overflow in RX FIFO */
+	if (stat & ROVF) {
+		up->port.icount.overrun++;
+		tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+		SPORT_PUT_STAT(up, ROVF); /* Clear ROVF bit */
+	}
+	/* These should not happen */
+	if (stat & (TOVF | TUVF | RUVF)) {
+		printk(KERN_ERR "SPORT Error:%s %s %s\n",
+				(stat & TOVF)?"TX overflow":"",
+				(stat & TUVF)?"TX underflow":"",
+				(stat & RUVF)?"RX underflow":"");
+		SPORT_PUT_TCR1(up, SPORT_GET_TCR1(up) & ~TSPEN);
+		SPORT_PUT_RCR1(up, SPORT_GET_RCR1(up) & ~RSPEN);
+	}
+	SSYNC();
+
+	return IRQ_HANDLED;
+}
+
+/* Reqeust IRQ, Setup clock */
+static int sport_startup(struct uart_port *port)
+{
+	struct sport_uart_port *up = (struct sport_uart_port *)port;
+	char buffer[20];
+	int retval;
+
+	pr_debug("%s enter\n", __FUNCTION__);
+	memset(buffer, 20, '\0');
+	snprintf(buffer, 20, "%s rx", up->name);
+	retval = request_irq(up->rx_irq, sport_uart_rx_irq, IRQF_SAMPLE_RANDOM, buffer, up);
+	if (retval) {
+		printk(KERN_ERR "Unable to request interrupt %s\n", buffer);
+		return retval;
+	}
+
+	snprintf(buffer, 20, "%s tx", up->name);
+	retval = request_irq(up->tx_irq, sport_uart_tx_irq, IRQF_SAMPLE_RANDOM, buffer, up);
+	if (retval) {
+		printk(KERN_ERR "Unable to request interrupt %s\n", buffer);
+		goto fail1;
+	}
+
+	snprintf(buffer, 20, "%s err", up->name);
+	retval = request_irq(up->err_irq, sport_uart_err_irq, IRQF_SAMPLE_RANDOM, buffer, up);
+	if (retval) {
+		printk(KERN_ERR "Unable to request interrupt %s\n", buffer);
+		goto fail2;
+	}
+
+	if (port->line) {
+		if (peripheral_request_list(bfin_uart_pin_req_sport1, DRV_NAME))
+			goto fail3;
+	} else {
+		if (peripheral_request_list(bfin_uart_pin_req_sport0, DRV_NAME))
+			goto fail3;
+	}
+
+	sport_uart_setup(up, get_sclk(), port->uartclk);
+
+	/* Enable receive interrupt */
+	SPORT_PUT_RCR1(up, (SPORT_GET_RCR1(up) | RSPEN));
+	SSYNC();
+
+	return 0;
+
+
+fail3:
+	printk(KERN_ERR DRV_NAME
+		": Requesting Peripherals failed\n");
+
+	free_irq(up->err_irq, up);
+fail2:
+	free_irq(up->tx_irq, up);
+fail1:
+	free_irq(up->rx_irq, up);
+
+	return retval;
+
+}
+
+static void sport_uart_tx_chars(struct sport_uart_port *up)
+{
+	struct circ_buf *xmit = &up->port.info->xmit;
+
+	if (SPORT_GET_STAT(up) & TXF)
+		return;
+
+	if (up->port.x_char) {
+		tx_one_byte(up, up->port.x_char);
+		up->port.icount.tx++;
+		up->port.x_char = 0;
+		return;
+	}
+
+	if (uart_circ_empty(xmit) || uart_tx_stopped(&up->port)) {
+		sport_stop_tx(&up->port);
+		return;
+	}
+
+	while(!(SPORT_GET_STAT(up) & TXF) && !uart_circ_empty(xmit)) {
+		tx_one_byte(up, xmit->buf[xmit->tail]);
+		xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE -1);
+		up->port.icount.tx++;
+	}
+
+	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
+		uart_write_wakeup(&up->port);
+}
+
+static unsigned int sport_tx_empty(struct uart_port *port)
+{
+	struct sport_uart_port *up = (struct sport_uart_port *)port;
+	unsigned int stat;
+
+	stat = SPORT_GET_STAT(up);
+	pr_debug("%s stat:%04x\n", __FUNCTION__, stat);
+	if (stat & TXHRE) {
+		return TIOCSER_TEMT;
+	} else
+		return 0;
+}
+
+static unsigned int sport_get_mctrl(struct uart_port *port)
+{
+	pr_debug("%s enter\n", __FUNCTION__);
+	return (TIOCM_CTS | TIOCM_CD | TIOCM_DSR);
+}
+
+static void sport_set_mctrl(struct uart_port *port, unsigned int mctrl)
+{
+	pr_debug("%s enter\n", __FUNCTION__);
+}
+
+static void sport_stop_tx(struct uart_port *port)
+{
+	struct sport_uart_port *up = (struct sport_uart_port *)port;
+	unsigned int stat;
+
+	pr_debug("%s enter\n", __FUNCTION__);
+
+	stat = SPORT_GET_STAT(up);
+	while(!(stat & TXHRE)) {
+		udelay(1);
+		stat = SPORT_GET_STAT(up);
+	}
+	/* Although the hold register is empty, last byte is still in shift
+	 * register and not sent out yet. If baud rate is lower than default,
+	 * delay should be longer. For example, if the baud rate is 9600,
+	 * the delay must be at least 2ms by experience */
+	udelay(500);
+
+	SPORT_PUT_TCR1(up, (SPORT_GET_TCR1(up) & ~TSPEN));
+	SSYNC();
+
+	return;
+}
+
+static void sport_start_tx(struct uart_port *port)
+{
+	struct sport_uart_port *up = (struct sport_uart_port *)port;
+
+	pr_debug("%s enter\n", __FUNCTION__);
+	/* Write data into SPORT FIFO before enable SPROT to transmit */
+	sport_uart_tx_chars(up);
+
+	/* Enable transmit, then an interrupt will generated */
+	SPORT_PUT_TCR1(up, (SPORT_GET_TCR1(up) | TSPEN));
+	SSYNC();
+	pr_debug("%s exit\n", __FUNCTION__);
+}
+
+static void sport_stop_rx(struct uart_port *port)
+{
+	struct sport_uart_port *up = (struct sport_uart_port *)port;
+
+	pr_debug("%s enter\n", __FUNCTION__);
+	/* Disable sport to stop rx */
+	SPORT_PUT_RCR1(up, (SPORT_GET_RCR1(up) & ~RSPEN));
+	SSYNC();
+}
+
+static void sport_enable_ms(struct uart_port *port)
+{
+	pr_debug("%s enter\n", __FUNCTION__);
+}
+
+static void sport_break_ctl(struct uart_port *port, int break_state)
+{
+	pr_debug("%s enter\n", __FUNCTION__);
+}
+
+static void sport_shutdown(struct uart_port *port)
+{
+	struct sport_uart_port *up = (struct sport_uart_port *)port;
+
+	pr_debug("%s enter\n", __FUNCTION__);
+
+	/* Disable sport */
+	SPORT_PUT_TCR1(up, (SPORT_GET_TCR1(up) & ~TSPEN));
+	SPORT_PUT_RCR1(up, (SPORT_GET_RCR1(up) & ~RSPEN));
+	SSYNC();
+
+	if (port->line) {
+		peripheral_free_list(bfin_uart_pin_req_sport1);
+	} else {
+		peripheral_free_list(bfin_uart_pin_req_sport0);
+	}
+
+	free_irq(up->rx_irq, up);
+	free_irq(up->tx_irq, up);
+	free_irq(up->err_irq, up);
+}
+
+static void sport_set_termios(struct uart_port *port,
+		struct termios *termios, struct termios *old)
+{
+	pr_debug("%s enter, c_cflag:%08x\n", __FUNCTION__, termios->c_cflag);
+	uart_update_timeout(port, CS8 ,port->uartclk);
+}
+
+static const char *sport_type(struct uart_port *port)
+{
+	struct sport_uart_port *up = (struct sport_uart_port *)port;
+
+	pr_debug("%s enter\n", __FUNCTION__);
+	return up->name;
+}
+
+static void sport_release_port(struct uart_port *port)
+{
+	pr_debug("%s enter\n", __FUNCTION__);
+}
+
+static int sport_request_port(struct uart_port *port)
+{
+	pr_debug("%s enter\n", __FUNCTION__);
+	return 0;
+}
+
+static void sport_config_port(struct uart_port *port, int flags)
+{
+	struct sport_uart_port *up = (struct sport_uart_port *)port;
+
+	pr_debug("%s enter\n", __FUNCTION__);
+	up->port.type = PORT_BFIN_SPORT;
+}
+
+static int sport_verify_port(struct uart_port *port, struct serial_struct *ser)
+{
+	pr_debug("%s enter\n", __FUNCTION__);
+	return 0;
+}
+
+struct uart_ops sport_uart_ops = {
+	.tx_empty	= sport_tx_empty,
+	.set_mctrl	= sport_set_mctrl,
+	.get_mctrl	= sport_get_mctrl,
+	.stop_tx	= sport_stop_tx,
+	.start_tx	= sport_start_tx,
+	.stop_rx	= sport_stop_rx,
+	.enable_ms	= sport_enable_ms,
+	.break_ctl	= sport_break_ctl,
+	.startup	= sport_startup,
+	.shutdown	= sport_shutdown,
+	.set_termios	= sport_set_termios,
+	.type		= sport_type,
+	.release_port	= sport_release_port,
+	.request_port	= sport_request_port,
+	.config_port	= sport_config_port,
+	.verify_port	= sport_verify_port,
+};
+
+static struct sport_uart_port sport_uart_ports[] = {
+	{ /* SPORT 0 */
+		.name	= "SPORT0",
+		.tx_irq = IRQ_SPORT0_TX,
+		.rx_irq = IRQ_SPORT0_RX,
+		.err_irq= IRQ_SPORT0_ERROR,
+		.port	= {
+			.type		= PORT_BFIN_SPORT,
+			.iotype		= UPIO_MEM,
+			.membase	= (void __iomem *)SPORT0_TCR1,
+			.mapbase	= SPORT0_TCR1,
+			.irq		= IRQ_SPORT0_RX,
+			.uartclk	= CONFIG_SPORT_BAUD_RATE,
+			.fifosize	= 8,
+			.ops		= &sport_uart_ops,
+			.line		= 0,
+		},
+	}, { /* SPORT 1 */
+		.name	= "SPORT1",
+		.tx_irq = IRQ_SPORT1_TX,
+		.rx_irq = IRQ_SPORT1_RX,
+		.err_irq= IRQ_SPORT1_ERROR,
+		.port	= {
+			.type		= PORT_BFIN_SPORT,
+			.iotype		= UPIO_MEM,
+			.membase	= (void __iomem *)SPORT1_TCR1,
+			.mapbase	= SPORT1_TCR1,
+			.irq		= IRQ_SPORT1_RX,
+			.uartclk	= CONFIG_SPORT_BAUD_RATE,
+			.fifosize	= 8,
+			.ops		= &sport_uart_ops,
+			.line		= 1,
+		},
+	}
+};
+
+static struct uart_driver sport_uart_reg = {
+	.owner		= THIS_MODULE,
+	.driver_name	= "SPORT-UART",
+	.dev_name	= "ttySS",
+	.major		= 204,
+	.minor		= 84,
+	.nr		= ARRAY_SIZE(sport_uart_ports),
+	.cons		= NULL,
+};
+
+static int sport_uart_suspend(struct platform_device *dev, pm_message_t state)
+{
+	struct sport_uart_port *sport = platform_get_drvdata(dev);
+
+	pr_debug("%s enter\n", __FUNCTION__);
+	if (sport)
+		uart_suspend_port(&sport_uart_reg, &sport->port);
+
+	return 0;
+}
+
+static int sport_uart_resume(struct platform_device *dev)
+{
+	struct sport_uart_port *sport = platform_get_drvdata(dev);
+
+	pr_debug("%s enter\n", __FUNCTION__);
+	if (sport)
+		uart_resume_port(&sport_uart_reg, &sport->port);
+
+	return 0;
+}
+
+static int sport_uart_probe(struct platform_device *dev)
+{
+	pr_debug("%s enter\n", __FUNCTION__);
+	sport_uart_ports[dev->id].port.dev = &dev->dev;
+	uart_add_one_port(&sport_uart_reg, &sport_uart_ports[dev->id].port);
+	platform_set_drvdata(dev, &sport_uart_ports[dev->id]);
+
+	return 0;
+}
+
+static int sport_uart_remove(struct platform_device *dev)
+{
+	struct sport_uart_port *sport = platform_get_drvdata(dev);
+
+	pr_debug("%s enter\n", __FUNCTION__);
+	platform_set_drvdata(dev, NULL);
+
+	if (sport)
+		uart_remove_one_port(&sport_uart_reg, &sport->port);
+
+	return 0;
+}
+
+static struct platform_driver sport_uart_driver = {
+	.probe		= sport_uart_probe,
+	.remove		= sport_uart_remove,
+	.suspend	= sport_uart_suspend,
+	.resume		= sport_uart_resume,
+	.driver		= {
+		.name	= DRV_NAME,
+	},
+};
+
+static int __init sport_uart_init(void)
+{
+	int ret;
+
+	pr_debug("%s enter\n", __FUNCTION__);
+	ret = uart_register_driver(&sport_uart_reg);
+	if (ret != 0) {
+		printk(KERN_ERR "Failed to register %s:%d\n",
+				sport_uart_reg.driver_name, ret);
+		return ret;
+	}
+
+	ret = platform_driver_register(&sport_uart_driver);
+	if (ret != 0) {
+		printk(KERN_ERR "Failed to register sport uart driver:%d\n", ret);
+		uart_unregister_driver(&sport_uart_reg);
+	}
+
+
+	pr_debug("%s exit\n", __FUNCTION__);
+	return ret;
+}
+
+static void __exit sport_uart_exit(void)
+{
+	pr_debug("%s enter\n", __FUNCTION__);
+	platform_driver_unregister(&sport_uart_driver);
+	uart_unregister_driver(&sport_uart_reg);
+}
+
+module_init(sport_uart_init);
+module_exit(sport_uart_exit);
+
+MODULE_LICENSE("GPL");
diff -puN /dev/null drivers/serial/bfin_sport_uart.h
--- /dev/null
+++ a/drivers/serial/bfin_sport_uart.h
@@ -0,0 +1,63 @@
+/*
+ * File:	linux/drivers/serial/bfin_sport_uart.h
+ *
+ * Based on:	include/asm-blackfin/mach-533/bfin_serial_5xx.h
+ * Author:	Roy Huang <roy.huang>analog.com>
+ *
+ * Created:	Nov 22, 2006
+ * Copyright:	(C) Analog Device Inc.
+ * Description: this driver enable SPORTs on Blackfin emulate UART.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+
+#define OFFSET_TCR1		0x00	/* Transmit Configuration 1 Register */
+#define OFFSET_TCR2		0x04	/* Transmit Configuration 2 Register */
+#define OFFSET_TCLKDIV		0x08	/* Transmit Serial Clock Divider Register */
+#define OFFSET_TFSDIV		0x0C	/* Transmit Frame Sync Divider Register */
+#define OFFSET_TX		0x10	/* Transmit Data Register		*/
+#define OFFSET_RX		0x18	/* Receive Data Register		*/
+#define OFFSET_RCR1		0x20	/* Receive Configuration 1 Register	*/
+#define OFFSET_RCR2		0x24	/* Receive Configuration 2 Register	*/
+#define OFFSET_RCLKDIV		0x28	/* Receive Serial Clock Divider Register */
+#define OFFSET_RFSDIV		0x2c	/* Receive Frame Sync Divider Register */
+#define OFFSET_STAT		0x30	/* Status Register			*/
+
+#define SPORT_GET_TCR1(sport)		bfin_read16(((sport)->port.membase + OFFSET_TCR1))
+#define SPORT_GET_TCR2(sport)		bfin_read16(((sport)->port.membase + OFFSET_TCR2))
+#define SPORT_GET_TCLKDIV(sport)	bfin_read16(((sport)->port.membase + OFFSET_TCLKDIV))
+#define SPORT_GET_TFSDIV(sport)		bfin_read16(((sport)->port.membase + OFFSET_TFSDIV))
+#define SPORT_GET_TX(sport)		bfin_read16(((sport)->port.membase + OFFSET_TX))
+#define SPORT_GET_RX(sport)		bfin_read16(((sport)->port.membase + OFFSET_RX))
+#define SPORT_GET_RX32(sport)		bfin_read32(((sport)->port.membase + OFFSET_RX))
+#define SPORT_GET_RCR1(sport)		bfin_read16(((sport)->port.membase + OFFSET_RCR1))
+#define SPORT_GET_RCR2(sport)		bfin_read16(((sport)->port.membase + OFFSET_RCR2))
+#define SPORT_GET_RCLKDIV(sport)	bfin_read16(((sport)->port.membase + OFFSET_RCLKDIV))
+#define SPORT_GET_RFSDIV(sport)		bfin_read16(((sport)->port.membase + OFFSET_RFSDIV))
+#define SPORT_GET_STAT(sport)		bfin_read16(((sport)->port.membase + OFFSET_STAT))
+
+#define SPORT_PUT_TCR1(sport, v)	bfin_write16(((sport)->port.membase + OFFSET_TCR1), v)
+#define SPORT_PUT_TCR2(sport, v)	bfin_write16(((sport)->port.membase + OFFSET_TCR2), v)
+#define SPORT_PUT_TCLKDIV(sport, v)	bfin_write16(((sport)->port.membase + OFFSET_TCLKDIV), v)
+#define SPORT_PUT_TFSDIV(sport, v)	bfin_write16(((sport)->port.membase + OFFSET_TFSDIV), v)
+#define SPORT_PUT_TX(sport, v)		bfin_write16(((sport)->port.membase + OFFSET_TX), v)
+#define SPORT_PUT_RX(sport, v)		bfin_write16(((sport)->port.membase + OFFSET_RX), v)
+#define SPORT_PUT_RCR1(sport, v)	bfin_write16(((sport)->port.membase + OFFSET_RCR1), v)
+#define SPORT_PUT_RCR2(sport, v)	bfin_write16(((sport)->port.membase + OFFSET_RCR2), v)
+#define SPORT_PUT_RCLKDIV(sport, v)	bfin_write16(((sport)->port.membase + OFFSET_RCLKDIV), v)
+#define SPORT_PUT_RFSDIV(sport, v)	bfin_write16(((sport)->port.membase + OFFSET_RFSDIV), v)
+#define SPORT_PUT_STAT(sport, v)	bfin_write16(((sport)->port.membase + OFFSET_STAT), v)
diff -puN include/linux/serial_core.h~blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart include/linux/serial_core.h
--- a/include/linux/serial_core.h~blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart
+++ a/include/linux/serial_core.h
@@ -149,13 +149,15 @@
 /* Freescale ColdFire */
 #define PORT_MCF	78
 
-#define PORT_SC26XX	79
