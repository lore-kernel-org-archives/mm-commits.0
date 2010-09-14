From: akpm@linux-foundation.org
Subject: + serial-add-sc16is7x2-driver.patch added to -mm tree
Date: Mon, 13 Sep 2010 17:26:05 -0700
Message-ID: <201009140026.o8E0Q5PR029987@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38114 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752220Ab0INA0M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Sep 2010 20:26:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: manuel.stahl@iis.fraunhofer.de, grant.likely@secretlab.ca, greg@kroah.com


The patch titled
     serial: add sc16is7x2 driver
has been added to the -mm tree.  Its filename is
     serial-add-sc16is7x2-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: add sc16is7x2 driver
From: Manuel Stahl <manuel.stahl@iis.fraunhofer.de>

Add support for the sc16is7x2 chips.

Signed-off-by: Manuel Stahl <manuel.stahl@iis.fraunhofer.de>
Cc: Greg KH <greg@kroah.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/Kconfig        |    7 
 drivers/serial/Makefile       |    1 
 drivers/serial/sc16is7x2.c    | 1351 ++++++++++++++++++++++++++++++++
 include/linux/serial_core.h   |    3 
 include/linux/spi/sc16is7x2.h |   17 
 5 files changed, 1379 insertions(+)

diff -puN drivers/serial/Kconfig~serial-add-sc16is7x2-driver drivers/serial/Kconfig
--- a/drivers/serial/Kconfig~serial-add-sc16is7x2-driver
+++ a/drivers/serial/Kconfig
@@ -351,6 +351,13 @@ config SERIAL_SB1250_DUART_CONSOLE
 
 	  If unsure, say Y.
 
+config SERIAL_SC16IS7X2
+	tristate "SC16IS7x2 chips"
+	depends on SPI_MASTER && GPIOLIB
+	select SERIAL_CORE
+	help
+	  gpio driver for SC16IS7x2 SPI UARTs.
+
 config SERIAL_ATMEL
 	bool "AT91 / AT32 on-chip serial port support"
 	depends on (ARM && ARCH_AT91) || AVR32
diff -puN drivers/serial/Makefile~serial-add-sc16is7x2-driver drivers/serial/Makefile
--- a/drivers/serial/Makefile~serial-add-sc16is7x2-driver
+++ a/drivers/serial/Makefile
@@ -45,6 +45,7 @@ obj-$(CONFIG_SERIAL_S3C2440) += s3c2440.
 obj-$(CONFIG_SERIAL_S3C24A0) += s3c24a0.o
 obj-$(CONFIG_SERIAL_S3C6400) += s3c6400.o
 obj-$(CONFIG_SERIAL_S5PV210) += s5pv210.o
+obj-$(CONFIG_SERIAL_SC16IS7X2) += sc16is7x2.o
 obj-$(CONFIG_SERIAL_MAX3100) += max3100.o
 obj-$(CONFIG_SERIAL_MAX3107) += max3107.o
 obj-$(CONFIG_SERIAL_MAX3107_AAVA) += max3107-aava.o
diff -puN /dev/null drivers/serial/sc16is7x2.c
--- /dev/null
+++ a/drivers/serial/sc16is7x2.c
@@ -0,0 +1,1351 @@
+/**
+ * drivers/serial/sc16is7x2.c
+ *
+ * Copyright (C) 2009 Manuel Stahl <manuel.stahl@iis.fraunhofer.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * The SC16IS7x2 device is a SPI driven dual UART with GPIOs.
+ *
+ * The driver exports two uarts and a gpiochip interface.
+ */
+
+/* #define DEBUG */
+
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/mutex.h>
+#include <linux/spi/spi.h>
+#include <linux/freezer.h>
+#include <linux/spi/sc16is7x2.h>
+#include <linux/serial_core.h>
+#include <linux/serial_reg.h>
+#include <linux/gpio.h>
+
+#define SC16IS7X2_MAJOR		204
+#define SC16IS7X2_MINOR		209
+#define MAX_SC16IS7X2		8
+#define FIFO_SIZE		64
+
+#define DRIVER_NAME		"sc16is7x2"
+#define TYPE_NAME		"SC16IS7x2"
+
+
+
+#define REG_READ	0x80
+#define REG_WRITE	0x00
+
+/* Special registers */
+#define REG_TXLVL	0x08	/* Transmitter FIFO Level register */
+#define REG_RXLVL	0x09	/* Receiver FIFO Level register */
+#define REG_IOD		0x0A	/* IO Direction register */
+#define REG_IOS		0x0B	/* IO State register */
+#define REG_IOI		0x0C	/* IO Interrupt Enable register */
+#define REG_IOC		0x0E	/* IO Control register */
+
+#define IOC_SRESET	0x08    /* Software reset */
+#define IOC_GPIO30	0x04    /* GPIO 3:0 unset: as IO, set: as modem pins */
+#define IOC_GPIO74	0x02    /* GPIO 7:4 unset: as IO, set: as modem pins */
+#define IOC_IOLATCH	0x01    /* Unset: input unlatched, set: input latched */
+
+/* Redefine some MCR bits */
+#ifdef UART_MCR_TCRTLR
+#undef UART_MCR_TCRTLR
+#endif
+#define UART_MCR_TCRTLR		0x04
+#define UART_MCR_IRDA		0x40
+
+
+#define WRITE_CMD(reg, ch) (REG_WRITE | (reg & 0xf) << 3 | (ch & 0x1) << 1)
+#define READ_CMD(reg, ch)  (REG_READ  | (reg & 0xf) << 3 | (ch & 0x1) << 1)
+
+/* 16bit SPI command to read or write a register */
+struct sc16is7x2_spi_reg {
+	u8 cmd;
+	u8 value;
+} __attribute__ ((packed));
+
+struct sc16is7x2_chip;
+
+/*
+ * Some registers must be read back to modify.
+ * To save time we cache them here in memory
+ */
+struct sc16is7x2_channel {
+	struct sc16is7x2_chip	*chip;	/* back link */
+	struct mutex		lock;
+	struct uart_port 	uart;
+	struct spi_transfer fifo_rx;
+	struct spi_transfer fifo_tx[3];
+	u8		iir;
+	u8		lsr;
+	u8		msr;
+	u8		ier;		/* cache for IER register */
+	u8		fcr;		/* cache for FCR register */
+	u8		lcr;		/* cache for LCR register */
+	u8		mcr;		/* cache for MCR register */
+	u8		rxbuf[FIFO_SIZE+1];
+	u8		write_fifo_cmd;
+	u8		read_fifo_cmd;
+	bool		active;
+};
+
+struct sc16is7x2_chip {
+	struct spi_device *spi;
+	struct gpio_chip gpio;
+	struct mutex	 lock;
+	struct sc16is7x2_channel channel[2];
+
+	/* for handling irqs: need workqueue since we do spi_sync */
+	struct workqueue_struct *workqueue;
+	struct work_struct work;
+	/* set to 1 to make the workhandler exit as soon as possible */
+	int force_end_work;
+	/* need to know we are suspending to avoid deadlock on workqueue */
+	int suspending;
+
+	struct spi_message fifo_message;
+
+#define UART_BUG_TXEN	BIT(1)	/* UART has buggy TX IIR status */
+#define UART_BUG_NOMSR	BIT(2)	/* UART has buggy MSR status bits (Au1x00) */
+#define UART_BUG_THRE	BIT(3)	/* UART has buggy THRE reassertion */
+	u16		bugs;		/* port bugs */
+
+#define LSR_SAVE_FLAGS UART_LSR_BRK_ERROR_BITS
+	u8		lsr_saved_flags;
+#define MSR_SAVE_FLAGS UART_MSR_ANY_DELTA
+	u8		msr_saved_flags;
+	u8		io_dir;		/* cache for IODir register */
+	u8		io_state;	/* cache for IOState register */
+	u8		io_gpio;	/* PIN is GPIO */
+	u8		io_control;	/* cache for IOControl register */
+};
+
+/* ******************************** SPI ********************************* */
+
+
+/*
+ * Reserve memory for command sequence
+ * @param cnt number of commands
+ */
+static inline struct sc16is7x2_spi_reg *
+sc16is7x2_alloc_spi_cmds(unsigned cnt)
+{
+	return kzalloc(sizeof(struct sc16is7x2_spi_reg)*cnt, GFP_KERNEL);
+}
+
+/*
+ * sc16is7x2_add_write_cmd - Add write command to sequence
+ */
+static inline void sc16is7x2_add_write_cmd(struct sc16is7x2_spi_reg *cmd,
+		u8 reg, u8 ch, u8 value)
+{
+	cmd->cmd = WRITE_CMD(reg, ch);
+	cmd->value = value;
+}
+
+/*
+ * sc16is7x2_add_read_cmd - Add read command to sequence
+ */
+static inline void sc16is7x2_add_read_cmd(struct sc16is7x2_spi_reg *cmd,
+		u8 reg, u8 ch)
+{
+	cmd->cmd = READ_CMD(reg, ch);
+	cmd->value = 0;
+}
+
+/*
+ * sc16is7x2_complete - Completion handler for async SPI transfers
+ */
+static void sc16is7x2_complete(void *context)
+{
+	struct spi_message *m = context;
+	u8 *tx_chain = m->state;
+
+	kfree(tx_chain);
+	kfree(m);
+}
+
+/*
+ * sc16is7x2_spi_async - Send command sequence
+ */
+static int sc16is7x2_spi_async(struct spi_device *spi,
+		struct sc16is7x2_spi_reg *cmds, unsigned len)
+{
+	struct spi_transfer *t;
+	struct spi_message *m;
+
+	m = spi_message_alloc(len, GFP_KERNEL);
+	if (!m)
+		return -ENOMEM;
+
+	m->complete = sc16is7x2_complete;
+	m->context = m;
+	m->state = cmds;
+	list_for_each_entry(t, &m->transfers, transfer_list) {
+		t->tx_buf = (u8 *)cmds;
+		t->len = 2;
+		t->cs_change = true;
+		cmds++;
+	}
+
+	return spi_async(spi, m);
+}
+
+/*
+ * sc16is7x2_write_async - Write a new register content (async)
+ */
+static inline int sc16is7x2_write_async(struct spi_device *spi, u8 reg, u8 ch,
+		u8 value)
+{
+	struct sc16is7x2_spi_reg *cmd = sc16is7x2_alloc_spi_cmds(1);
+	if (!cmd)
+		return -ENOMEM;
+	sc16is7x2_add_write_cmd(cmd, reg, ch, value);
+	return sc16is7x2_spi_async(spi, cmd, 1);
+}
+
+/*
+ * sc16is7x2_write - Write a new register content (sync)
+ */
+static int sc16is7x2_write(struct spi_device *spi, u8 reg, u8 ch, u8 val)
+{
+	u16 word = REG_WRITE | (reg & 0xf) << 3 | (ch & 0x3) << 1 | val << 8;
+	return spi_write(spi, (const u8 *)&word, sizeof(word));
+}
+
+/**
+ * sc16is7x2_read - Read back register content
+ * @spi: The SPI device
+ * @reg: Register offset
+ *
+ * Returns positive 8 bit value from device if successful or a
+ * negative value on error
+ */
+static int sc16is7x2_read(struct spi_device *spi, unsigned reg, unsigned ch)
+{
+	u8 cmd = REG_READ | (reg & 0xf) << 3 | (ch & 0x3) << 1;
+	return spi_w8r8(spi, cmd);
+}
+
+/* ******************************** UART ********************************* */
+
+/* Uart divisor latch write */
+static inline void sc16is7x2_add_dl_write_cmd(struct sc16is7x2_spi_reg *cmd,
+		u8 ch, int value)
+{
+	sc16is7x2_add_write_cmd(&cmd[0], UART_DLL, ch, value & 0xff);
+	sc16is7x2_add_write_cmd(&cmd[1], UART_DLM, ch, value >> 8 & 0xff);
+}
+
+static unsigned int sc16is7x2_tx_empty(struct uart_port *port)
+{
+	struct sc16is7x2_channel *chan =
+			container_of(port, struct sc16is7x2_channel, uart);
+	struct sc16is7x2_chip *ts = chan->chip;
+	unsigned lsr;
+
+	dev_dbg(&ts->spi->dev, "%s\n", __func__);
+
+	mutex_lock(&chan->lock);
+	lsr = chan->lsr;
+	mutex_unlock(&chan->lock);
+
+	return lsr & UART_LSR_TEMT ? TIOCSER_TEMT : 0;
+}
+
+static unsigned int sc16is7x2_get_mctrl(struct uart_port *port)
+{
+	struct sc16is7x2_channel *chan =
+			container_of(port, struct sc16is7x2_channel, uart);
+	struct sc16is7x2_chip *ts = chan->chip;
+	unsigned int status;
+	unsigned int ret;
+
+	dev_dbg(&ts->spi->dev, "%s\n", __func__);
+
+	status = chan->msr;
+
+	ret = 0;
+	if (status & UART_MSR_DCD)
+		ret |= TIOCM_CAR;
+	if (status & UART_MSR_RI)
+		ret |= TIOCM_RNG;
+	if (status & UART_MSR_DSR)
+		ret |= TIOCM_DSR;
+	if (status & UART_MSR_CTS)
+		ret |= TIOCM_CTS;
+	return ret;
+}
+
+static unsigned int __set_mctrl(unsigned int mctrl)
+{
+	unsigned char mcr = 0;
+
+	if (mctrl & TIOCM_RTS)
+		mcr |= UART_MCR_RTS;
+	if (mctrl & TIOCM_DTR)
+		mcr |= UART_MCR_DTR;
+	if (mctrl & TIOCM_LOOP)
+		mcr |= UART_MCR_LOOP;
+
+	return mcr;
+}
+
+static void sc16is7x2_set_mctrl(struct uart_port *port, unsigned int mctrl)
+{
+	struct sc16is7x2_channel *chan =
+			container_of(port, struct sc16is7x2_channel, uart);
+	struct sc16is7x2_chip *ts = chan->chip;
+	unsigned ch = port->line & 0x01;
+
+	dev_dbg(&ts->spi->dev, "%s\n", __func__);
+	sc16is7x2_write_async(ts->spi, UART_MCR, ch, __set_mctrl(mctrl));
+}
+
+static inline void __stop_tx(struct sc16is7x2_channel *chan)
+{
+	struct sc16is7x2_chip *ts = chan->chip;
+	unsigned ch = chan->uart.line & 0x01;
+	if (chan->ier & UART_IER_THRI) {
+		chan->ier &= ~UART_IER_THRI;
+		sc16is7x2_write_async(ts->spi, UART_IER, ch, chan->ier);
+	}
+}
+
+static void sc16is7x2_stop_tx(struct uart_port *port)
+{
+	struct sc16is7x2_channel *chan =
+			container_of(port, struct sc16is7x2_channel, uart);
+	struct sc16is7x2_chip *ts = chan->chip;
+
+	dev_dbg(&ts->spi->dev, "%s\n", __func__);
+
+	__stop_tx(chan);
+}
+
+static void sc16is7x2_start_tx(struct uart_port *port)
+{
+	struct sc16is7x2_channel *chan =
+			container_of(port, struct sc16is7x2_channel, uart);
+	struct sc16is7x2_chip *ts = chan->chip;
+	unsigned ch = port->line & 0x01;
+
+	dev_dbg(&ts->spi->dev, "%s\n", __func__);
+
+	if (!(chan->ier & UART_IER_THRI)) {
+		chan->ier |= UART_IER_THRI;
+		sc16is7x2_write_async(ts->spi, UART_IER, ch, chan->ier);
+	}
+}
+
+static void sc16is7x2_stop_rx(struct uart_port *port)
+{
+	struct sc16is7x2_channel *chan =
+			container_of(port, struct sc16is7x2_channel, uart);
+	struct sc16is7x2_chip *ts = chan->chip;
+	unsigned ch = port->line & 0x01;
+
+	dev_dbg(&ts->spi->dev, "%s\n", __func__);
+
+	chan->ier &= ~UART_IER_RLSI;
+	chan->uart.read_status_mask &= ~UART_LSR_DR;
+	sc16is7x2_write_async(ts->spi, UART_IER, ch, chan->ier);
+}
+
+static void sc16is7x2_enable_ms(struct uart_port *port)
+{
+	struct sc16is7x2_channel *chan =
+			container_of(port, struct sc16is7x2_channel, uart);
+	struct sc16is7x2_chip *ts = chan->chip;
+	unsigned ch = port->line & 0x01;
+
+	dev_dbg(&ts->spi->dev, "%s\n", __func__);
+
+	chan->ier |= UART_IER_MSI;
+	sc16is7x2_write_async(ts->spi, UART_IER, ch, chan->ier);
+}
+
+static void sc16is7x2_break_ctl(struct uart_port *port, int break_state)
+{
+	struct sc16is7x2_channel *chan =
+			container_of(port, struct sc16is7x2_channel, uart);
+	struct sc16is7x2_chip *ts = chan->chip;
+	unsigned ch = port->line & 0x01;
+	unsigned long flags;
+
+	dev_dbg(&ts->spi->dev, "%s\n", __func__);
+
+	spin_lock_irqsave(&chan->uart.lock, flags);
+	if (break_state == -1)
+		chan->lcr |= UART_LCR_SBC;
+	else
+		chan->lcr &= ~UART_LCR_SBC;
+	spin_unlock_irqrestore(&chan->uart.lock, flags);
+
+	sc16is7x2_write_async(ts->spi, UART_LCR, ch, chan->lcr);
+}
+
+static int sc16is7x2_startup(struct uart_port *port)
+{
+	struct sc16is7x2_channel *chan =
+			container_of(port, struct sc16is7x2_channel, uart);
+	struct sc16is7x2_chip *ts = chan->chip;
+	unsigned ch = port->line & 0x01;
+	struct sc16is7x2_spi_reg *cmds, *cmd;
+	unsigned long flags;
+
+	dev_dbg(&ts->spi->dev, "%s (line %d)\n", __func__, port->line);
+
+	spin_lock_irqsave(&chan->uart.lock, flags);
+	chan->lcr = UART_LCR_WLEN8;
+	chan->mcr = __set_mctrl(chan->uart.mctrl);
+	chan->fcr = 0;
+	chan->ier = UART_IER_RLSI | UART_IER_RDI;
+	spin_unlock_irqrestore(&chan->uart.lock, flags);
+
+	cmds = sc16is7x2_alloc_spi_cmds(8);
+	if (!cmds)
+		return -ENOMEM;
+
+	cmd = cmds;
+	/* Clear the interrupt registers. */
+	sc16is7x2_add_write_cmd(cmd, UART_IER, ch, 0);
+	sc16is7x2_add_read_cmd(++cmd, UART_IIR, ch);
+	sc16is7x2_add_read_cmd(++cmd, UART_LSR, ch);
+	sc16is7x2_add_read_cmd(++cmd, UART_MSR, ch);
+
+	sc16is7x2_add_write_cmd(++cmd, UART_FCR, ch, UART_FCR_ENABLE_FIFO |
+		       UART_FCR_CLEAR_RCVR | UART_FCR_CLEAR_XMIT);
+	sc16is7x2_add_write_cmd(++cmd, UART_FCR, ch, chan->fcr);
+	/* Now, initialize the UART */
+	sc16is7x2_add_write_cmd(++cmd, UART_LCR, ch, chan->lcr);
+	sc16is7x2_add_write_cmd(++cmd, UART_MCR, ch, chan->mcr);
+
+	sc16is7x2_spi_async(ts->spi, cmds, 8);
+
+	chan->active = true;
+	return 0;
+}
+
+static void sc16is7x2_shutdown(struct uart_port *port)
+{
+	struct sc16is7x2_channel *chan =
+			container_of(port, struct sc16is7x2_channel, uart);
+	struct sc16is7x2_chip *ts = chan->chip;
+	unsigned long flags;
+	unsigned ch = port->line & 0x01;
+
+	dev_dbg(&ts->spi->dev, "%s\n", __func__);
+
+	BUG_ON(!chan);
+	BUG_ON(!ts);
+
+	if (ts->suspending)
+		return;
+
+	/* Disable interrupts from this port */
+	chan->ier = 0;
+	chan->active = false;
+	sc16is7x2_write(ts->spi, UART_IER, ch, chan->ier);
+
+	/* Wait for worker of this channel to finish */
+	mutex_lock(&chan->lock);
+
+	spin_lock_irqsave(&chan->uart.lock, flags);
+	chan->mcr = __set_mctrl(chan->uart.mctrl);
+	spin_unlock_irqrestore(&chan->uart.lock, flags);
+
+	/* Disable break condition and FIFOs */
+	chan->lcr &= ~UART_LCR_SBC;
+
+	sc16is7x2_write(ts->spi, UART_MCR, ch, chan->mcr);
+	sc16is7x2_write(ts->spi, UART_LCR, ch, chan->lcr);
+
+	mutex_unlock(&chan->lock);
+}
+
+static void
+sc16is7x2_set_termios(struct uart_port *port, struct ktermios *termios,
+		       struct ktermios *old)
+{
+	struct sc16is7x2_channel *chan =
+			container_of(port, struct sc16is7x2_channel, uart);
+	struct sc16is7x2_chip *ts = chan->chip;
+	struct sc16is7x2_spi_reg *cmds;
+	unsigned ch = port->line & 0x01;
+	unsigned long flags;
+	unsigned int baud, quot;
+	u8 ier, mcr, lcr, fcr = 0;
+	u8 efr = UART_EFR_ECB;
+
+	/* set word length */
+	switch (termios->c_cflag & CSIZE) {
+	case CS5:
+		lcr = UART_LCR_WLEN5;
+		break;
+	case CS6:
+		lcr = UART_LCR_WLEN6;
+		break;
+	case CS7:
+		lcr = UART_LCR_WLEN7;
+		break;
+	default:
+	case CS8:
+		lcr = UART_LCR_WLEN8;
+		break;
+	}
+
+	if (termios->c_cflag & CSTOPB)
+		lcr |= UART_LCR_STOP;
+	if (termios->c_cflag & PARENB)
+		lcr |= UART_LCR_PARITY;
+	if (!(termios->c_cflag & PARODD))
+		lcr |= UART_LCR_EPAR;
+#ifdef CMSPAR
+	if (termios->c_cflag & CMSPAR)
+		lcr |= UART_LCR_SPAR;
+#endif
+
+	/* Ask the core to calculate the divisor for us. */
+	baud = uart_get_baud_rate(port, termios, old,
+				  port->uartclk / 16 / 0xffff,
+				  port->uartclk / 16);
+	quot = uart_get_divisor(port, baud);
+
+	dev_dbg(&ts->spi->dev, "%s (baud %u)\n", __func__, baud);
+
+
+	/* configure the fifo */
+	if (baud < 2400)
+		fcr = UART_FCR_ENABLE_FIFO | UART_FCR_TRIGGER_1;
+	else
+		fcr = UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_01;
+
+	/*
+	 * MCR-based auto flow control.  When AFE is enabled, RTS will be
+	 * deasserted when the receive FIFO contains more characters than
+	 * the trigger, or the MCR RTS bit is cleared.  In the case where
+	 * the remote UART is not using CTS auto flow control, we must
+	 * have sufficient FIFO entries for the latency of the remote
+	 * UART to respond.  IOW, at least 32 bytes of FIFO.
+	 */
+	chan->mcr &= ~UART_MCR_AFE;
+	if (termios->c_cflag & CRTSCTS)
+		chan->mcr |= UART_MCR_AFE;
+
+	/*
+	 * Ok, we're now changing the port state.  Do it with
+	 * interrupts disabled.
+	 */
+	spin_lock_irqsave(&chan->uart.lock, flags);
+
+	/* we are sending char from a workqueue so enable */
+	chan->uart.state->port.tty->low_latency = 1;
+
+	/* Update the per-port timeout. */
+	uart_update_timeout(port, termios->c_cflag, baud);
+
+	chan->uart.read_status_mask = UART_LSR_OE | UART_LSR_THRE | UART_LSR_DR;
+	if (termios->c_iflag & INPCK)
+		chan->uart.read_status_mask |= UART_LSR_FE | UART_LSR_PE;
+	if (termios->c_iflag & (BRKINT | PARMRK))
+		chan->uart.read_status_mask |= UART_LSR_BI;
+
+	/* Characters to ignore */
+	chan->uart.ignore_status_mask = 0;
+	if (termios->c_iflag & IGNPAR)
+		chan->uart.ignore_status_mask |= UART_LSR_PE | UART_LSR_FE;
+	if (termios->c_iflag & IGNBRK) {
+		chan->uart.ignore_status_mask |= UART_LSR_BI;
+		/*
+		 * If we're ignoring parity and break indicators,
+		 * ignore overruns too (for real raw support).
+		 */
+		if (termios->c_iflag & IGNPAR)
+			chan->uart.ignore_status_mask |= UART_LSR_OE;
+	}
+
+	/* ignore all characters if CREAD is not set */
+	if ((termios->c_cflag & CREAD) == 0)
+		chan->uart.ignore_status_mask |= UART_LSR_DR;
+
+	/* CTS flow control flag and modem status interrupts */
+	chan->ier &= ~UART_IER_MSI;
+	if (UART_ENABLE_MS(&chan->uart, termios->c_cflag))
+		chan->ier |= UART_IER_MSI;
+
+	if (termios->c_cflag & CRTSCTS)
+		efr |= UART_EFR_CTS | UART_EFR_RTS;
+
+	mcr = __set_mctrl(chan->uart.mctrl);
+	ier = chan->ier;
+	chan->lcr = lcr;				/* Save LCR */
+	chan->fcr = fcr;				/* Save FCR */
+	chan->mcr = mcr;				/* Save MCR */
+
+	fcr |= UART_FCR_CLEAR_RCVR | UART_FCR_CLEAR_XMIT;
+
+	spin_unlock_irqrestore(&chan->uart.lock, flags);
+
+	/* build a compound spi message to set all registers */
+	cmds = sc16is7x2_alloc_spi_cmds(9);
+	if (!cmds)
+		return;
+
+	/* set DLAB */
+	sc16is7x2_add_write_cmd(&cmds[0], UART_LCR, ch, UART_LCR_DLAB);
+	/* set divisor, must be set before UART_EFR_ECB */
+	sc16is7x2_add_dl_write_cmd(&cmds[1], ch, quot);
+	sc16is7x2_add_write_cmd(&cmds[3], UART_LCR, ch, 0xBF);	/* access EFR */
+	sc16is7x2_add_write_cmd(&cmds[4], UART_EFR, ch, efr);
+	sc16is7x2_add_write_cmd(&cmds[5], UART_LCR, ch, lcr);	/* reset DLAB */
+	sc16is7x2_add_write_cmd(&cmds[6], UART_FCR, ch, fcr);
+	sc16is7x2_add_write_cmd(&cmds[7], UART_MCR, ch, mcr);
+	sc16is7x2_add_write_cmd(&cmds[8], UART_IER, ch, ier);
+
+	sc16is7x2_spi_async(ts->spi, cmds, 9);
+
+	/* Don't rewrite B0 */
+	if (tty_termios_baud_rate(termios))
+		tty_termios_encode_baud_rate(termios, baud, baud);
+}
+
+static const char *
+sc16is7x2_type(struct uart_port *port)
+{
+	struct sc16is7x2_channel *chan =
+			container_of(port, struct sc16is7x2_channel, uart);
+	struct sc16is7x2_chip *ts = chan->chip;
+	dev_dbg(&ts->spi->dev, "%s\n", __func__);
+	return TYPE_NAME;
+}
+
+static void sc16is7x2_release_port(struct uart_port *port)
+{
+	struct sc16is7x2_channel *chan =
+			container_of(port, struct sc16is7x2_channel, uart);
+	struct sc16is7x2_chip *ts = chan->chip;
+	dev_dbg(&ts->spi->dev, "%s\n", __func__);
+	ts->force_end_work = 1;
+}
+
+static int sc16is7x2_request_port(struct uart_port *port)
+{
+	struct sc16is7x2_channel *chan =
+			container_of(port, struct sc16is7x2_channel, uart);
+	struct sc16is7x2_chip *ts = chan->chip;
+	dev_dbg(&ts->spi->dev, "%s\n", __func__);
+	return 0;
+}
+
+static void sc16is7x2_config_port(struct uart_port *port, int flags)
+{
+	struct sc16is7x2_channel *chan =
+			container_of(port, struct sc16is7x2_channel, uart);
+	struct sc16is7x2_chip *ts = chan->chip;
+	dev_dbg(&ts->spi->dev, "%s\n", __func__);
+	if (flags & UART_CONFIG_TYPE)
+		chan->uart.type = PORT_SC16IS7X2;
+}
+
+static int
+sc16is7x2_verify_port(struct uart_port *port, struct serial_struct *ser)
+{
+	struct sc16is7x2_channel *chan =
+			container_of(port, struct sc16is7x2_channel, uart);
+	struct sc16is7x2_chip *ts = chan->chip;
+	dev_dbg(&ts->spi->dev, "%s\n", __func__);
+	if (ser->irq < 0 || ser->baud_base < 9600 ||
+			ser->type != PORT_SC16IS7X2)
+		return -EINVAL;
+	return 0;
+}
+
+static struct uart_ops sc16is7x2_uart_ops = {
+	.tx_empty	= sc16is7x2_tx_empty,
+	.set_mctrl	= sc16is7x2_set_mctrl,
+	.get_mctrl	= sc16is7x2_get_mctrl,
+	.stop_tx        = sc16is7x2_stop_tx,
+	.start_tx	= sc16is7x2_start_tx,
+	.stop_rx	= sc16is7x2_stop_rx,
+	.enable_ms      = sc16is7x2_enable_ms,
+	.break_ctl      = sc16is7x2_break_ctl,
+	.startup	= sc16is7x2_startup,
+	.shutdown	= sc16is7x2_shutdown,
+	.set_termios	= sc16is7x2_set_termios,
+	.type		= sc16is7x2_type,
+	.release_port   = sc16is7x2_release_port,
+	.request_port   = sc16is7x2_request_port,
+	.config_port	= sc16is7x2_config_port,
+	.verify_port	= sc16is7x2_verify_port,
+};
+
+
+#define MIN(a, b) ((a < b) ? (a) : (b))
+
+/* ******************************** GPIO ********************************* */
+
+static int sc16is7x2_gpio_request(struct gpio_chip *gpio, unsigned offset)
+{
+	struct sc16is7x2_chip *ts =
+			container_of(gpio, struct sc16is7x2_chip, gpio);
+	int control = (offset < 4) ? IOC_GPIO30 : IOC_GPIO74;
+	int ret = 0;
+
+	BUG_ON(offset > 8);
+	dev_dbg(&ts->spi->dev, "%s: offset = %d\n", __func__, offset);
+
+	mutex_lock(&ts->lock);
+
+	/* GPIO 0:3 and 4:7 can only be controlled as block */
+	ts->io_gpio |= BIT(offset);
+	if (ts->io_control & control) {
+		dev_dbg(&ts->spi->dev, "activate GPIOs %s\n",
+				(offset < 4) ? "0-3" : "4-7");
+		ts->io_control &= ~control;
+		ret = sc16is7x2_write(ts->spi, REG_IOC, 0, ts->io_control);
+	}
+
+	mutex_unlock(&ts->lock);
+
+	return ret;
+}
+
+static void sc16is7x2_gpio_free(struct gpio_chip *gpio, unsigned offset)
+{
+	struct sc16is7x2_chip *ts =
+			container_of(gpio, struct sc16is7x2_chip, gpio);
+	int control = (offset < 4) ? IOC_GPIO30 : IOC_GPIO74;
+	int mask = (offset < 4) ? 0x0f : 0xf0;
+
+	BUG_ON(offset > 8);
+
+	mutex_lock(&ts->lock);
+
+	/* GPIO 0:3 and 4:7 can only be controlled as block */
+	ts->io_gpio &= ~BIT(offset);
+	dev_dbg(&ts->spi->dev, "%s: io_gpio = 0x%02X\n", __func__, ts->io_gpio);
+	if (!(ts->io_control & control) && !(ts->io_gpio & mask)) {
+		dev_dbg(&ts->spi->dev, "deactivate GPIOs %s\n",
+				(offset < 4) ? "0-3" : "4-7");
+		ts->io_control |= control;
+		sc16is7x2_write(ts->spi, REG_IOC, 0, ts->io_control);
+	}
+
+	mutex_unlock(&ts->lock);
+}
+
+static int sc16is7x2_direction_input(struct gpio_chip *gpio, unsigned offset)
+{
+	struct sc16is7x2_chip *ts =
+			container_of(gpio, struct sc16is7x2_chip, gpio);
+	unsigned io_dir;
+
+	BUG_ON(offset > 8);
+
+	mutex_lock(&ts->lock);
+
+	ts->io_dir &= ~BIT(offset);
+	io_dir = ts->io_dir;
+
+	mutex_unlock(&ts->lock);
+
+	return sc16is7x2_write_async(ts->spi, REG_IOD, 0, io_dir);
+}
+
+static int sc16is7x2_direction_output(struct gpio_chip *gpio, unsigned offset,
+				    int value)
+{
+	struct sc16is7x2_chip *ts =
+			container_of(gpio, struct sc16is7x2_chip, gpio);
+	struct sc16is7x2_spi_reg *cmds;
+
+	BUG_ON(offset > 8);
+
+	mutex_lock(&ts->lock);
+
+	if (value)
+		ts->io_state |= BIT(offset);
+	else
+		ts->io_state &= ~BIT(offset);
+
+	ts->io_dir |= BIT(offset);
+
+	cmds = sc16is7x2_alloc_spi_cmds(2);
+	if (cmds) {
+		sc16is7x2_add_write_cmd(&cmds[0], REG_IOS, 0, ts->io_state);
+		sc16is7x2_add_write_cmd(&cmds[1], REG_IOD, 0, ts->io_dir);
+	}
+
+	mutex_unlock(&ts->lock);
+
+	return sc16is7x2_spi_async(ts->spi, cmds, 2);
+}
+
+static int sc16is7x2_get(struct gpio_chip *gpio, unsigned offset)
+{
+	struct sc16is7x2_chip *ts =
+			container_of(gpio, struct sc16is7x2_chip, gpio);
+	int level = -EINVAL;
+
+	BUG_ON(offset > 8);
+
+	mutex_lock(&ts->lock);
+
+	if (ts->io_dir & BIT(offset)) {
+		/* Output: return cached level */
+		level = (ts->io_state >> offset) & 0x01;
+	} else {
+		/* Input: read out all pins */
+		level = sc16is7x2_read(ts->spi, REG_IOS, 0);
+		if (level >= 0) {
+			ts->io_state = level;
+			level = (ts->io_state >> offset) & 0x01;
+		}
+	}
+
+	mutex_unlock(&ts->lock);
+
+	return level;
+}
+
+static void sc16is7x2_set(struct gpio_chip *gpio, unsigned offset, int value)
+{
+	struct sc16is7x2_chip *ts =
+			container_of(gpio, struct sc16is7x2_chip, gpio);
+	unsigned io_state;
+
+	BUG_ON(offset > 8);
+
+	mutex_lock(&ts->lock);
+
+	if (value)
+		ts->io_state |= BIT(offset);
+	else
+		ts->io_state &= ~BIT(offset);
+	io_state = ts->io_state;
+
+	mutex_unlock(&ts->lock);
+
+	sc16is7x2_write_async(ts->spi, REG_IOS, 0, io_state);
+}
+
+/* ******************************** IRQ ********************************* */
+
+static void sc16is7x2_handle_fifo_rx(struct sc16is7x2_channel *chan)
+{
+	struct uart_port *uart = &chan->uart;
+	struct tty_struct *tty = uart->state->port.tty;
+	u8 *rxbuf = chan->rxbuf;
+	u8 lsr = chan->lsr;
+	unsigned i, count = chan->fifo_rx.len;
+	unsigned long flags;
+	char flag = TTY_NORMAL;
+
+	spin_lock_irqsave(&uart->lock, flags);
+
+	if (unlikely(lsr & UART_LSR_BRK_ERROR_BITS)) {
+		/*
+		 * For statistics only
+		 */
+		if (lsr & UART_LSR_BI) {
+			lsr &= ~(UART_LSR_FE | UART_LSR_PE);
+			chan->uart.icount.brk++;
+			/*
+			 * We do the SysRQ and SAK checking
+			 * here because otherwise the break
+			 * may get masked by ignore_status_mask
+			 * or read_status_mask.
+			 */
+			if (uart_handle_break(&chan->uart))
+				goto ignore_char;
+		} else if (lsr & UART_LSR_PE)
+			chan->uart.icount.parity++;
+		else if (lsr & UART_LSR_FE)
+			chan->uart.icount.frame++;
+		if (lsr & UART_LSR_OE)
+			chan->uart.icount.overrun++;
+
+		/*
+		 * Mask off conditions which should be ignored.
+		 */
+		lsr &= chan->uart.read_status_mask;
+
+		if (lsr & UART_LSR_BI)
+			flag = TTY_BREAK;
+		else if (lsr & UART_LSR_PE)
+			flag = TTY_PARITY;
+		else if (lsr & UART_LSR_FE)
+			flag = TTY_FRAME;
+	}
+
+	for (i = 1; i < count; i++) {
+		uart->icount.rx++;
+
+		if (!uart_handle_sysrq_char(uart, rxbuf[i]))
+			uart_insert_char(uart, lsr, UART_LSR_OE,
+					rxbuf[i], flag);
+	}
+
+ignore_char:
+	spin_unlock_irqrestore(&uart->lock, flags);
+
+	if (count > 1)
+		tty_flip_buffer_push(tty);
+}
+
+static void sc16is7x2_handle_fifo_tx(struct sc16is7x2_channel *chan)
+{
+	struct uart_port *uart = &chan->uart;
+	struct circ_buf *xmit = &uart->state->xmit;
+	unsigned count = chan->fifo_tx[1].len + chan->fifo_tx[2].len;
+	unsigned long flags;
+
+	BUG_ON(!uart);
+	BUG_ON(!xmit);
+
+	spin_lock_irqsave(&uart->lock, flags);
+
+	uart->icount.tx += count;
+	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
+		uart_write_wakeup(uart);
+
+	if (uart_circ_empty(xmit))
+		__stop_tx(chan);
+
+	spin_unlock_irqrestore(&uart->lock, flags);
+}
+
+static bool sc16is7x2_msg_add_fifo_rx(struct sc16is7x2_chip *ts, unsigned ch)
+{
+	struct spi_message *m = &(ts->fifo_message);
+	struct spi_transfer *t = &(ts->channel[ch].fifo_rx);
+	int rxlvl = sc16is7x2_read(ts->spi, REG_RXLVL, ch);
+	if (rxlvl > 0) {
+		t->len = rxlvl + 1;
+		spi_message_add_tail(t, m);
+		return true;
+	}
+	return false;
+}
+
+static bool sc16is7x2_msg_add_fifo_tx(struct sc16is7x2_chip *ts, unsigned ch)
+{
+	struct sc16is7x2_channel * const chan = &(ts->channel[ch]);
+	struct uart_port *uart = &chan->uart;
+	struct circ_buf *xmit = &uart->state->xmit;
+	unsigned count;
+	bool split_transfer;
+	u8 txlvl;
+
+	if (chan->uart.x_char && chan->lsr & UART_LSR_THRE) {
+		dev_dbg(&ts->spi->dev, "tx: x-char\n");
+		sc16is7x2_write(ts->spi, UART_TX, ch, uart->x_char);
+		uart->icount.tx++;
+		uart->x_char = 0;
+		return false;
+	}
+	if (uart_tx_stopped(&chan->uart)) {
+		dev_dbg(&ts->spi->dev, "tx: stopped!\n");
+		sc16is7x2_stop_tx(uart);
+		return false;
+	}
+	if (uart_circ_empty(xmit)) {
+		__stop_tx(chan);
+		return false;
+	}
+
+	txlvl = sc16is7x2_read(ts->spi, REG_TXLVL, ch);
+	if (txlvl <= 0) {
+		dev_dbg(&ts->spi->dev, " fifo full\n");
+		return false;
+	}
+
+	/* number of bytes to transfer to the fifo */
+	count = MIN(txlvl, uart_circ_chars_pending(xmit));
+	split_transfer = (UART_XMIT_SIZE - xmit->tail) <= count;
+
+	/* add command transfer */
+	spi_message_add_tail(&(chan->fifo_tx[0]), &(ts->fifo_message));
+	/* add first fifo transfer */
+	spi_message_add_tail(&(chan->fifo_tx[1]), &(ts->fifo_message));
+
+	chan->fifo_tx[1].tx_buf = xmit->buf + xmit->tail;
+
+	if (!split_transfer) {
+		chan->fifo_tx[1].len = count;
+		chan->fifo_tx[1].cs_change = true;
+
+		chan->fifo_tx[2].len = 0;
+	} else {
+		chan->fifo_tx[1].len = (UART_XMIT_SIZE - 1) - xmit->tail;
+		chan->fifo_tx[1].cs_change = false;
+
+		chan->fifo_tx[2].tx_buf = xmit->buf;
+		chan->fifo_tx[2].cs_change = true;
+		chan->fifo_tx[2].len = count - chan->fifo_tx[1].len;
+		/* add second fifo transfer */
+		spi_message_add_tail(&(chan->fifo_tx[2]), &(ts->fifo_message));
+	}
+
+	xmit->tail = (xmit->tail + count) & (UART_XMIT_SIZE - 1);
+	return true;
+}
+
+static void sc16is7x2_handle_modem(struct sc16is7x2_chip *ts, unsigned ch)
+{
+	struct sc16is7x2_channel *chan = &(ts->channel[ch]);
+	struct uart_port *uart = &chan->uart;
+
+	if (chan->msr & UART_MSR_ANY_DELTA
+			&& chan->ier & UART_IER_MSI
+			&& uart->state != NULL) {
+		if (chan->msr & UART_MSR_TERI)
+			uart->icount.rng++;
+		if (chan->msr & UART_MSR_DDSR)
+			uart->icount.dsr++;
+		if (chan->msr & UART_MSR_DDCD)
+			uart_handle_dcd_change(uart, chan->msr & UART_MSR_DCD);
+		if (chan->msr & UART_MSR_DCTS)
+			uart_handle_cts_change(uart, chan->msr & UART_MSR_CTS);
+
+		wake_up_interruptible(&uart->state->port.delta_msr_wait);
+	}
+}
+
+static bool sc16is7x2_handle_channel(struct sc16is7x2_chip *ts, unsigned ch)
+{
+	struct sc16is7x2_channel *chan = &(ts->channel[ch]);
+	struct spi_message *m = &(ts->fifo_message);
+	bool rx, tx;
+
+	dev_dbg(&ts->spi->dev, "%s (%i)\n", __func__, ch);
+
+	chan->iir = sc16is7x2_read(ts->spi, UART_IIR, ch);
+	chan->msr = sc16is7x2_read(ts->spi, UART_MSR, ch);
+	chan->lsr = sc16is7x2_read(ts->spi, UART_LSR, ch);
+
+	sc16is7x2_handle_modem(ts, ch);
+
+	spi_message_init(m);
+	rx = sc16is7x2_msg_add_fifo_rx(ts, ch);
+	tx = sc16is7x2_msg_add_fifo_tx(ts, ch);
+
+	if (rx || tx)
+		spi_sync(ts->spi, m);
+
+	if (rx)
+		sc16is7x2_handle_fifo_rx(chan);
+	if (tx)
+		sc16is7x2_handle_fifo_tx(chan);
+
+	dev_dbg(&ts->spi->dev, "%s finished (iir = 0x%02x)\n",
+			__func__, chan->iir);
+
+	return (chan->iir & UART_IIR_NO_INT) == 0x00;
+}
+
+static void sc16is7x2_work(struct work_struct *w)
+{
+	struct sc16is7x2_chip *ts =
+			container_of(w, struct sc16is7x2_chip, work);
+	unsigned pending = 0;
+	unsigned ch = 0;
+
+	dev_dbg(&ts->spi->dev, "%s\n", __func__);
+	BUG_ON(!w);
+	BUG_ON(!ts);
+
+
+	if (ts->force_end_work) {
+		dev_dbg(&ts->spi->dev, "%s: force end!\n", __func__);
+		return;
+	}
+
+	if (ts->channel[0].active)
+		pending |= BIT(0);
+	if (ts->channel[1].active)
+		pending |= BIT(1);
+
+	do {
+		mutex_lock(&(ts->channel[ch].lock));
+		if (pending & BIT(ch) && ts->channel[ch].active) {
+			if (!sc16is7x2_handle_channel(ts, ch))
+				pending &= ~BIT(ch);
+		}
+		mutex_unlock(&(ts->channel[ch].lock));
+		ch ^= 1;	/* switch channel */
+	} while (!ts->force_end_work && !freezing(current) && pending);
+
+	dev_dbg(&ts->spi->dev, "%s finished\n", __func__);
+}
+
+static irqreturn_t sc16is7x2_interrupt(int irq, void *dev_id)
+{
+	struct sc16is7x2_chip *ts = dev_id;
+
+	dev_dbg(&ts->spi->dev, "%s\n", __func__);
+
+	if (!ts->force_end_work && !work_pending(&ts->work) &&
+	    !freezing(current) && !ts->suspending)
+		queue_work(ts->workqueue, &ts->work);
+
+	return IRQ_HANDLED;
+}
+
+/* ******************************** INIT ********************************* */
+
+static struct uart_driver sc16is7x2_uart_driver;
+
+static int sc16is7x2_register_gpio(struct sc16is7x2_chip *ts,
+		struct sc16is7x2_platform_data *pdata)
+{
+	struct sc16is7x2_spi_reg *cmds;
+
+	ts->gpio.label = (pdata->label) ? pdata->label : DRIVER_NAME;
+	ts->gpio.request	= sc16is7x2_gpio_request;
+	ts->gpio.free		= sc16is7x2_gpio_free;
+	ts->gpio.get		= sc16is7x2_get;
+	ts->gpio.set		= sc16is7x2_set;
+	ts->gpio.direction_input = sc16is7x2_direction_input;
+	ts->gpio.direction_output = sc16is7x2_direction_output;
+
+	ts->gpio.base = pdata->gpio_base;
+	ts->gpio.names = pdata->names;
+	ts->gpio.ngpio = SC16IS7X2_NR_GPIOS;
+	ts->gpio.can_sleep = 1;
+	ts->gpio.dev = &ts->spi->dev;
+	ts->gpio.owner = THIS_MODULE;
+
+	/* disable all GPIOs, enable on request */
+	ts->io_dir = 0x0f;
+	ts->io_state = 0;
+	ts->io_gpio = 0;
+	ts->io_control = IOC_GPIO30 | IOC_GPIO74;
+
+	cmds = sc16is7x2_alloc_spi_cmds(4);
+	if (!cmds)
+		return -ENOMEM;
+
+	sc16is7x2_add_write_cmd(&cmds[0], REG_IOI, 0, 0);
+	sc16is7x2_add_write_cmd(&cmds[1], REG_IOC, 0, ts->io_control);
+	sc16is7x2_add_write_cmd(&cmds[2], REG_IOS, 0, ts->io_state);
+	sc16is7x2_add_write_cmd(&cmds[3], REG_IOD, 0, ts->io_dir);
+	sc16is7x2_spi_async(ts->spi, cmds, 4);
+
+	return gpiochip_add(&ts->gpio);
+}
+
+static int sc16is7x2_register_uart_port(struct sc16is7x2_chip *ts,
+		struct sc16is7x2_platform_data *pdata, unsigned ch)
+{
+	struct sc16is7x2_channel *chan = &(ts->channel[ch]);
+	struct uart_port *uart = &chan->uart;
+
+	mutex_init(&chan->lock);
+	chan->active = false;	/* will be set in startup */
+	chan->chip = ts;
+
+	chan->read_fifo_cmd = READ_CMD(UART_RX, ch);
+	chan->fifo_rx.tx_buf = &(chan->read_fifo_cmd);
+	chan->fifo_rx.rx_buf = chan->rxbuf;
+	chan->fifo_rx.cs_change = true;
+
+	chan->write_fifo_cmd = WRITE_CMD(UART_TX, ch);
+	chan->fifo_tx[0].tx_buf = &(chan->write_fifo_cmd);
+	chan->fifo_tx[0].rx_buf = NULL;
+	chan->fifo_tx[0].len = 1;
+	chan->fifo_tx[0].cs_change = false;
+	chan->fifo_tx[1].rx_buf = NULL;
+	chan->fifo_tx[2].rx_buf = NULL;
+
+	uart->irq = ts->spi->irq;
+	uart->uartclk = pdata->uartclk;
+	uart->fifosize = FIFO_SIZE;
+	uart->ops = &sc16is7x2_uart_ops;
+	uart->flags = UPF_SKIP_TEST | UPF_BOOT_AUTOCONF;
+	uart->line = pdata->uart_base + ch;
+	uart->type = PORT_SC16IS7X2;
+	uart->dev = &ts->spi->dev;
+
+	return uart_add_one_port(&sc16is7x2_uart_driver, uart);
+}
+
+static int __devinit sc16is7x2_probe(struct spi_device *spi)
+{
+	struct sc16is7x2_chip *ts;
+	struct sc16is7x2_platform_data *pdata;
+	int ret;
+
+	pdata = spi->dev.platform_data;
+	if (!pdata || !pdata->gpio_base /* || pdata->uart_base */) {
+		dev_dbg(&spi->dev, "incorrect or missing platform data\n");
+		return -EINVAL;
+	}
+
+	printk(KERN_INFO DRIVER_NAME " at CS%d (irq %d), 2 UARTs, 8 GPIOs\n"
+			"    eser%d, eser%d, gpiochip%d\n",
+			spi->chip_select, spi->irq,
+			pdata->uart_base, pdata->uart_base + 1,
+			pdata->gpio_base);
+
+	ret = spi_setup(spi);
+	if (ret < 0)
+		return ret;
+
+	ts = kzalloc(sizeof(struct sc16is7x2_chip), GFP_KERNEL);
+	if (!ts)
+		return -ENOMEM;
+
+	mutex_init(&ts->lock);
+	dev_set_drvdata(&spi->dev, ts);
+	ts->spi = spi;
+	ts->force_end_work = 1;
+
+	/* Reset the chip TODO: and disable IRQ output */
+	sc16is7x2_write(spi, REG_IOC, 0, IOC_SRESET);
+
+	ret = request_irq(spi->irq, sc16is7x2_interrupt,
+			IRQF_TRIGGER_FALLING | IRQF_SHARED, "sc16is7x2", ts);
+	if (ret) {
+		dev_warn(&ts->spi->dev, "cannot register interrupt\n");
+		goto exit_destroy;
+	}
+
+	ret = sc16is7x2_register_uart_port(ts, pdata, 0);
+	if (ret)
+		goto exit_irq;
+	ret = sc16is7x2_register_uart_port(ts, pdata, 1);
+	if (ret)
+		goto exit_uart0;
+
+	ret = sc16is7x2_register_gpio(ts, pdata);
+	if (ret)
+		goto exit_uart1;
+
+	ts->workqueue = create_freezeable_workqueue(DRIVER_NAME);
+	if (!ts->workqueue) {
+		dev_warn(&ts->spi->dev, "cannot create workqueue\n");
+		ret = -EBUSY;
+		goto exit_gpio;
+	}
+	INIT_WORK(&ts->work, sc16is7x2_work);
+	ts->force_end_work = 0;
+
+	return ret;
+
+exit_gpio:
+	ret = gpiochip_remove(&ts->gpio);
+
+exit_uart1:
+	uart_remove_one_port(&sc16is7x2_uart_driver, &ts->channel[1].uart);
+
+exit_uart0:
+	uart_remove_one_port(&sc16is7x2_uart_driver, &ts->channel[0].uart);
+
+exit_irq:
+	free_irq(spi->irq, ts);
+
+exit_destroy:
+	dev_set_drvdata(&spi->dev, NULL);
+	mutex_destroy(&ts->lock);
+	kfree(ts);
+	return ret;
+}
+
+static int __devexit sc16is7x2_remove(struct spi_device *spi)
+{
+	struct sc16is7x2_chip *ts;
+	int ret;
+
+	ts = dev_get_drvdata(&spi->dev);
+	if (ts == NULL)
+		return -ENODEV;
+
+	free_irq(spi->irq, ts);
+	ts->force_end_work = 1;
+
+	if (ts->workqueue) {
+		flush_workqueue(ts->workqueue);
+		destroy_workqueue(ts->workqueue);
+		ts->workqueue = NULL;
+	}
+
+	dev_set_drvdata(&spi->dev, NULL);
+
+	ret = uart_remove_one_port(&sc16is7x2_uart_driver,
+			&ts->channel[0].uart);
+	if (ret) {
+		dev_err(&spi->dev, "Failed to remove the UART port A: %d\n",
+			ret);
+		goto exit_error;
+	}
+	ret = uart_remove_one_port(&sc16is7x2_uart_driver,
+			&ts->channel[1].uart);
+	if (ret) {
+		dev_err(&spi->dev, "Failed to remove the UART port B: %d\n",
+			ret);
+		goto exit_error;
+	}
+	ret = gpiochip_remove(&ts->gpio);
+	if (ret) {
+		dev_err(&spi->dev, "Failed to remove the GPIO controller: %d\n",
+			ret);
+		goto exit_error;
+	}
+
+	mutex_destroy(&ts->lock);
+	kfree(ts);
+
+exit_error:
+	return ret;
+}
+
+static struct uart_driver sc16is7x2_uart_driver = {
+	.owner          = THIS_MODULE,
+	.driver_name    = DRIVER_NAME,
+	.dev_name       = "eser",
+	.major          = SC16IS7X2_MAJOR,
+	.minor          = SC16IS7X2_MINOR,
+	.nr             = MAX_SC16IS7X2,
+};
+
+static struct spi_driver sc16is7x2_spi_driver = {
+	.driver = {
+		.name		= DRIVER_NAME,
+		.owner		= THIS_MODULE,
+	},
+	.probe		= sc16is7x2_probe,
+	.remove		= __devexit_p(sc16is7x2_remove),
+};
+
+static int __init sc16is7x2_init(void)
+{
+	int ret;
+	ret = uart_register_driver(&sc16is7x2_uart_driver);
+	if (ret) {
+		printk(KERN_ERR "Couldn't register sc16is7x2 uart driver\n");
+		return ret;
+	}
+
+	return spi_register_driver(&sc16is7x2_spi_driver);
+}
+/* register after spi postcore initcall and before
+ * subsys initcalls that may rely on these GPIOs
+ */
+subsys_initcall(sc16is7x2_init);
+
+static void __exit sc16is7x2_exit(void)
+{
+	uart_unregister_driver(&sc16is7x2_uart_driver);
+	spi_unregister_driver(&sc16is7x2_spi_driver);
+}
+module_exit(sc16is7x2_exit);
+
+MODULE_AUTHOR("Manuel Stahl");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("SC16IS7x2 SPI based UART chip");
+MODULE_ALIAS("spi:" DRIVER_NAME);
diff -puN include/linux/serial_core.h~serial-add-sc16is7x2-driver include/linux/serial_core.h
--- a/include/linux/serial_core.h~serial-add-sc16is7x2-driver
+++ a/include/linux/serial_core.h
@@ -235,6 +235,9 @@ struct uart_ops {
 			      unsigned int oldstate);
 	int		(*set_wake)(struct uart_port *, unsigned int state);
 
+/* SC16IS7x2 SPI UART */
+#define PORT_SC16IS7X2	19
+
 	/*
 	 * Return a string describing the type of the port
 	 */
diff -puN /dev/null include/linux/spi/sc16is7x2.h
--- /dev/null
+++ a/include/linux/spi/sc16is7x2.h
@@ -0,0 +1,17 @@
+#ifndef LINUX_SPI_SC16IS752_H
+#define LINUX_SPI_SC16IS752_H
+
+#define SC16IS7X2_NR_GPIOS 8
+
+struct sc16is7x2_platform_data {
+	unsigned int	uartclk;
+	/* uart line number of the first channel */
+	unsigned	uart_base;
+	/* number assigned to the first GPIO */
+	unsigned	gpio_base;
+	char		*label;
+	/* list of GPIO names (array length = SC16IS7X2_NR_GPIOS) */
+	const char	*const *names;
+};
+
+#endif
_

Patches currently in -mm which might be from manuel.stahl@iis.fraunhofer.de are

linux-next.patch
serial-add-sc16is7x2-driver.patch
serial-add-sc16is7x2-driver-checkpatch-fixes.patch

