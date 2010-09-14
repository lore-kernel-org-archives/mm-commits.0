From: akpm@linux-foundation.org
Subject: + serial-add-sc16is7x2-driver-update.patch added to -mm tree
Date: Tue, 14 Sep 2010 11:57:50 -0700
Message-ID: <201009141857.o8EIvoBe012358@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43422 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753070Ab0INS60 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Sep 2010 14:58:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: manuel.stahl@iis.fraunhofer.de, grant.likely@secretlab.ca, greg@kroah.com


The patch titled
     serial-add-sc16is7x2-driver-update
has been added to the -mm tree.  Its filename is
     serial-add-sc16is7x2-driver-update.patch

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
Subject: serial-add-sc16is7x2-driver-update
From: Manuel Stahl <manuel.stahl@iis.fraunhofer.de>

Signed-off-by: Manuel Stahl <manuel.stahl@iis.fraunhofer.de>
Cc: Greg KH <greg@kroah.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/Kconfig      |   16 +--
 drivers/serial/Makefile     |    2 
 drivers/serial/sc16is7x2.c  |  160 +++++++++++++++++++---------------
 include/linux/serial_core.h |    6 -
 4 files changed, 105 insertions(+), 79 deletions(-)

diff -puN drivers/serial/Kconfig~serial-add-sc16is7x2-driver-update drivers/serial/Kconfig
--- a/drivers/serial/Kconfig~serial-add-sc16is7x2-driver-update
+++ a/drivers/serial/Kconfig
@@ -269,6 +269,15 @@ config SERIAL_8250_RM9K
 
 comment "Non-8250 serial port support"
 
+config SERIAL_SC16IS7X2
+	tristate "SC16IS7x2 chips"
+	depends on SPI_MASTER && GPIOLIB
+	select SERIAL_CORE
+	help
+	  Selecting this option will add support for SC16IS7x2 SPI UARTs.
+	  The GPIOs are exported via gpiolib interface.
+	  If unsure, say N.
+
 config SERIAL_AMBA_PL010
 	tristate "ARM AMBA PL010 serial port support"
 	depends on ARM_AMBA && (BROKEN || !ARCH_VERSATILE)
@@ -351,13 +360,6 @@ config SERIAL_SB1250_DUART_CONSOLE
 
 	  If unsure, say Y.
 
-config SERIAL_SC16IS7X2
-	tristate "SC16IS7x2 chips"
-	depends on SPI_MASTER && GPIOLIB
-	select SERIAL_CORE
-	help
-	  gpio driver for SC16IS7x2 SPI UARTs.
-
 config SERIAL_ATMEL
 	bool "AT91 / AT32 on-chip serial port support"
 	depends on (ARM && ARCH_AT91) || AVR32
diff -puN drivers/serial/Makefile~serial-add-sc16is7x2-driver-update drivers/serial/Makefile
--- a/drivers/serial/Makefile~serial-add-sc16is7x2-driver-update
+++ a/drivers/serial/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_SERIAL_8250_BOCA) += 8250_b
 obj-$(CONFIG_SERIAL_8250_EXAR_ST16C554) += 8250_exar_st16c554.o
 obj-$(CONFIG_SERIAL_8250_HUB6) += 8250_hub6.o
 obj-$(CONFIG_SERIAL_8250_MCA) += 8250_mca.o
+obj-$(CONFIG_SERIAL_SC16IS7X2)	+= sc16is7x2.o
 obj-$(CONFIG_SERIAL_AMBA_PL010) += amba-pl010.o
 obj-$(CONFIG_SERIAL_AMBA_PL011) += amba-pl011.o
 obj-$(CONFIG_SERIAL_CLPS711X) += clps711x.o
@@ -45,7 +46,6 @@ obj-$(CONFIG_SERIAL_S3C2440) += s3c2440.
 obj-$(CONFIG_SERIAL_S3C24A0) += s3c24a0.o
 obj-$(CONFIG_SERIAL_S3C6400) += s3c6400.o
 obj-$(CONFIG_SERIAL_S5PV210) += s5pv210.o
-obj-$(CONFIG_SERIAL_SC16IS7X2) += sc16is7x2.o
 obj-$(CONFIG_SERIAL_MAX3100) += max3100.o
 obj-$(CONFIG_SERIAL_MAX3107) += max3107.o
 obj-$(CONFIG_SERIAL_MAX3107_AAVA) += max3107-aava.o
diff -puN drivers/serial/sc16is7x2.c~serial-add-sc16is7x2-driver-update drivers/serial/sc16is7x2.c
--- a/drivers/serial/sc16is7x2.c~serial-add-sc16is7x2-driver-update
+++ a/drivers/serial/sc16is7x2.c
@@ -57,26 +57,23 @@
 #define UART_MCR_TCRTLR		0x04
 #define UART_MCR_IRDA		0x40
 
-
-#define WRITE_CMD(reg, ch) (REG_WRITE | (reg & 0xf) << 3 | (ch & 0x1) << 1)
-#define READ_CMD(reg, ch)  (REG_READ  | (reg & 0xf) << 3 | (ch & 0x1) << 1)
-
 /* 16bit SPI command to read or write a register */
 struct sc16is7x2_spi_reg {
 	u8 cmd;
 	u8 value;
-} __attribute__ ((packed));
+} __packed;
 
 struct sc16is7x2_chip;
 
 /*
  * Some registers must be read back to modify.
- * To save time we cache them here in memory
+ * To save time we cache them here in memory.
+ * The @lock mutex is there to protect them.
  */
 struct sc16is7x2_channel {
 	struct sc16is7x2_chip	*chip;	/* back link */
 	struct mutex		lock;
-	struct uart_port 	uart;
+	struct uart_port	uart;
 	struct spi_transfer fifo_rx;
 	struct spi_transfer fifo_tx[3];
 	u8		iir;
@@ -86,7 +83,7 @@ struct sc16is7x2_channel {
 	u8		fcr;		/* cache for FCR register */
 	u8		lcr;		/* cache for LCR register */
 	u8		mcr;		/* cache for MCR register */
-	u8		rxbuf[FIFO_SIZE+1];
+	u8		*rx_buf;
 	u8		write_fifo_cmd;
 	u8		read_fifo_cmd;
 	bool		active;
@@ -125,34 +122,43 @@ struct sc16is7x2_chip {
 
 /* ******************************** SPI ********************************* */
 
+static u8 write_cmd(u8 reg, u8 ch)
+{
+	return REG_WRITE | (reg & 0xf) << 3 | (ch & 0x1) << 1;
+}
+
+static u8 read_cmd(u8 reg, u8 ch)
+{
+	return REG_READ  | (reg & 0xf) << 3 | (ch & 0x1) << 1;
+}
 
 /*
  * Reserve memory for command sequence
- * @param cnt number of commands
+ * @cnt number of commands
  */
-static inline struct sc16is7x2_spi_reg *
+static struct sc16is7x2_spi_reg *
 sc16is7x2_alloc_spi_cmds(unsigned cnt)
 {
-	return kzalloc(sizeof(struct sc16is7x2_spi_reg)*cnt, GFP_KERNEL);
+	return kcalloc(cnt, sizeof(struct sc16is7x2_spi_reg), GFP_KERNEL);
 }
 
 /*
  * sc16is7x2_add_write_cmd - Add write command to sequence
  */
-static inline void sc16is7x2_add_write_cmd(struct sc16is7x2_spi_reg *cmd,
+static void sc16is7x2_add_write_cmd(struct sc16is7x2_spi_reg *cmd,
 		u8 reg, u8 ch, u8 value)
 {
-	cmd->cmd = WRITE_CMD(reg, ch);
+	cmd->cmd = write_cmd(reg, ch);
 	cmd->value = value;
 }
 
 /*
  * sc16is7x2_add_read_cmd - Add read command to sequence
  */
-static inline void sc16is7x2_add_read_cmd(struct sc16is7x2_spi_reg *cmd,
+static void sc16is7x2_add_read_cmd(struct sc16is7x2_spi_reg *cmd,
 		u8 reg, u8 ch)
 {
-	cmd->cmd = READ_CMD(reg, ch);
+	cmd->cmd = read_cmd(reg, ch);
 	cmd->value = 0;
 }
 
@@ -197,10 +203,11 @@ static int sc16is7x2_spi_async(struct sp
 /*
  * sc16is7x2_write_async - Write a new register content (async)
  */
-static inline int sc16is7x2_write_async(struct spi_device *spi, u8 reg, u8 ch,
+static int sc16is7x2_write_async(struct spi_device *spi, u8 reg, u8 ch,
 		u8 value)
 {
 	struct sc16is7x2_spi_reg *cmd = sc16is7x2_alloc_spi_cmds(1);
+
 	if (!cmd)
 		return -ENOMEM;
 	sc16is7x2_add_write_cmd(cmd, reg, ch, value);
@@ -212,28 +219,31 @@ static inline int sc16is7x2_write_async(
  */
 static int sc16is7x2_write(struct spi_device *spi, u8 reg, u8 ch, u8 val)
 {
-	u16 word = REG_WRITE | (reg & 0xf) << 3 | (ch & 0x3) << 1 | val << 8;
-	return spi_write(spi, (const u8 *)&word, sizeof(word));
+	struct sc16is7x2_spi_reg out;
+
+	out.cmd = write_cmd(reg, ch);
+	out.value = val;
+	return spi_write(spi, (const u8 *)&out, sizeof(out));
 }
 
 /**
  * sc16is7x2_read - Read back register content
  * @spi: The SPI device
  * @reg: Register offset
+ * @ch:  Channel (0 or 1)
  *
  * Returns positive 8 bit value from device if successful or a
  * negative value on error
  */
 static int sc16is7x2_read(struct spi_device *spi, unsigned reg, unsigned ch)
 {
-	u8 cmd = REG_READ | (reg & 0xf) << 3 | (ch & 0x3) << 1;
-	return spi_w8r8(spi, cmd);
+	return spi_w8r8(spi, read_cmd(reg, ch));
 }
 
 /* ******************************** UART ********************************* */
 
 /* Uart divisor latch write */
-static inline void sc16is7x2_add_dl_write_cmd(struct sc16is7x2_spi_reg *cmd,
+static void sc16is7x2_add_dl_write_cmd(struct sc16is7x2_spi_reg *cmd,
 		u8 ch, int value)
 {
 	sc16is7x2_add_write_cmd(&cmd[0], UART_DLL, ch, value & 0xff);
@@ -249,10 +259,7 @@ static unsigned int sc16is7x2_tx_empty(s
 
 	dev_dbg(&ts->spi->dev, "%s\n", __func__);
 
-	mutex_lock(&chan->lock);
 	lsr = chan->lsr;
-	mutex_unlock(&chan->lock);
-
 	return lsr & UART_LSR_TEMT ? TIOCSER_TEMT : 0;
 }
 
@@ -305,10 +312,11 @@ static void sc16is7x2_set_mctrl(struct u
 	sc16is7x2_write_async(ts->spi, UART_MCR, ch, __set_mctrl(mctrl));
 }
 
-static inline void __stop_tx(struct sc16is7x2_channel *chan)
+static void __stop_tx(struct sc16is7x2_channel *chan)
 {
 	struct sc16is7x2_chip *ts = chan->chip;
 	unsigned ch = chan->uart.line & 0x01;
+
 	if (chan->ier & UART_IER_THRI) {
 		chan->ier &= ~UART_IER_THRI;
 		sc16is7x2_write_async(ts->spi, UART_IER, ch, chan->ier);
@@ -619,6 +627,7 @@ sc16is7x2_type(struct uart_port *port)
 	struct sc16is7x2_channel *chan =
 			container_of(port, struct sc16is7x2_channel, uart);
 	struct sc16is7x2_chip *ts = chan->chip;
+
 	dev_dbg(&ts->spi->dev, "%s\n", __func__);
 	return TYPE_NAME;
 }
@@ -628,6 +637,7 @@ static void sc16is7x2_release_port(struc
 	struct sc16is7x2_channel *chan =
 			container_of(port, struct sc16is7x2_channel, uart);
 	struct sc16is7x2_chip *ts = chan->chip;
+
 	dev_dbg(&ts->spi->dev, "%s\n", __func__);
 	ts->force_end_work = 1;
 }
@@ -637,6 +647,7 @@ static int sc16is7x2_request_port(struct
 	struct sc16is7x2_channel *chan =
 			container_of(port, struct sc16is7x2_channel, uart);
 	struct sc16is7x2_chip *ts = chan->chip;
+
 	dev_dbg(&ts->spi->dev, "%s\n", __func__);
 	return 0;
 }
@@ -646,6 +657,7 @@ static void sc16is7x2_config_port(struct
 	struct sc16is7x2_channel *chan =
 			container_of(port, struct sc16is7x2_channel, uart);
 	struct sc16is7x2_chip *ts = chan->chip;
+
 	dev_dbg(&ts->spi->dev, "%s\n", __func__);
 	if (flags & UART_CONFIG_TYPE)
 		chan->uart.type = PORT_SC16IS7X2;
@@ -657,6 +669,7 @@ sc16is7x2_verify_port(struct uart_port *
 	struct sc16is7x2_channel *chan =
 			container_of(port, struct sc16is7x2_channel, uart);
 	struct sc16is7x2_chip *ts = chan->chip;
+
 	dev_dbg(&ts->spi->dev, "%s\n", __func__);
 	if (ser->irq < 0 || ser->baud_base < 9600 ||
 			ser->type != PORT_SC16IS7X2)
@@ -684,8 +697,6 @@ static struct uart_ops sc16is7x2_uart_op
 };
 
 
-#define MIN(a, b) ((a < b) ? (a) : (b))
-
 /* ******************************** GPIO ********************************* */
 
 static int sc16is7x2_gpio_request(struct gpio_chip *gpio, unsigned offset)
@@ -839,7 +850,7 @@ static void sc16is7x2_handle_fifo_rx(str
 {
 	struct uart_port *uart = &chan->uart;
 	struct tty_struct *tty = uart->state->port.tty;
-	u8 *rxbuf = chan->rxbuf;
+	u8 *rxbuf = chan->fifo_rx.rx_buf;
 	u8 lsr = chan->lsr;
 	unsigned i, count = chan->fifo_rx.len;
 	unsigned long flags;
@@ -924,6 +935,7 @@ static bool sc16is7x2_msg_add_fifo_rx(st
 	struct spi_message *m = &(ts->fifo_message);
 	struct spi_transfer *t = &(ts->channel[ch].fifo_rx);
 	int rxlvl = sc16is7x2_read(ts->spi, REG_RXLVL, ch);
+
 	if (rxlvl > 0) {
 		t->len = rxlvl + 1;
 		spi_message_add_tail(t, m);
@@ -965,7 +977,7 @@ static bool sc16is7x2_msg_add_fifo_tx(st
 	}
 
 	/* number of bytes to transfer to the fifo */
-	count = MIN(txlvl, uart_circ_chars_pending(xmit));
+	count = min(txlvl, (u8)uart_circ_chars_pending(xmit));
 	split_transfer = (UART_XMIT_SIZE - xmit->tail) <= count;
 
 	/* add command transfer */
@@ -1016,6 +1028,15 @@ static void sc16is7x2_handle_modem(struc
 	}
 }
 
+static void sc16is7x2_read_status(struct sc16is7x2_chip *ts, unsigned ch)
+{
+	struct sc16is7x2_channel *chan = &(ts->channel[ch]);
+
+	chan->iir = sc16is7x2_read(ts->spi, UART_IIR, ch);
+	chan->msr = sc16is7x2_read(ts->spi, UART_MSR, ch);
+	chan->lsr = sc16is7x2_read(ts->spi, UART_LSR, ch);
+}
+
 static bool sc16is7x2_handle_channel(struct sc16is7x2_chip *ts, unsigned ch)
 {
 	struct sc16is7x2_channel *chan = &(ts->channel[ch]);
@@ -1024,10 +1045,7 @@ static bool sc16is7x2_handle_channel(str
 
 	dev_dbg(&ts->spi->dev, "%s (%i)\n", __func__, ch);
 
-	chan->iir = sc16is7x2_read(ts->spi, UART_IIR, ch);
-	chan->msr = sc16is7x2_read(ts->spi, UART_MSR, ch);
-	chan->lsr = sc16is7x2_read(ts->spi, UART_LSR, ch);
-
+	sc16is7x2_read_status(ts, ch);
 	sc16is7x2_handle_modem(ts, ch);
 
 	spi_message_init(m);
@@ -1149,12 +1167,17 @@ static int sc16is7x2_register_uart_port(
 	chan->active = false;	/* will be set in startup */
 	chan->chip = ts;
 
-	chan->read_fifo_cmd = READ_CMD(UART_RX, ch);
-	chan->fifo_rx.tx_buf = &(chan->read_fifo_cmd);
-	chan->fifo_rx.rx_buf = chan->rxbuf;
+	chan->rx_buf = kzalloc(FIFO_SIZE+1, GFP_KERNEL);
+		if (chan->rx_buf == NULL)
+			return -ENOMEM;
+
+	chan->read_fifo_cmd = read_cmd(UART_RX, ch);
 	chan->fifo_rx.cs_change = true;
+	chan->fifo_rx.tx_buf = &(chan->read_fifo_cmd);
+	chan->fifo_rx.rx_buf = chan->rx_buf;
+
 
-	chan->write_fifo_cmd = WRITE_CMD(UART_TX, ch);
+	chan->write_fifo_cmd = write_cmd(UART_TX, ch);
 	chan->fifo_tx[0].tx_buf = &(chan->write_fifo_cmd);
 	chan->fifo_tx[0].rx_buf = NULL;
 	chan->fifo_tx[0].len = 1;
@@ -1174,6 +1197,22 @@ static int sc16is7x2_register_uart_port(
 	return uart_add_one_port(&sc16is7x2_uart_driver, uart);
 }
 
+static int sc16is7x2_unregister_uart_port(struct sc16is7x2_chip *ts,
+		unsigned channel)
+{
+	int ret;
+
+	kfree(&ts->channel[channel].rx_buf);
+	ret = uart_remove_one_port(&sc16is7x2_uart_driver,
+			&ts->channel[channel].uart);
+	if (ret)
+		dev_err(&ts->spi->dev, "Failed to remove the UART port %c: %d\n",
+			'A' + channel, ret);
+
+	return ret;
+}
+
+
 static int __devinit sc16is7x2_probe(struct spi_device *spi)
 {
 	struct sc16is7x2_chip *ts;
@@ -1186,22 +1225,12 @@ static int __devinit sc16is7x2_probe(str
 		return -EINVAL;
 	}
 
-	printk(KERN_INFO DRIVER_NAME " at CS%d (irq %d), 2 UARTs, 8 GPIOs\n"
-			"    eser%d, eser%d, gpiochip%d\n",
-			spi->chip_select, spi->irq,
-			pdata->uart_base, pdata->uart_base + 1,
-			pdata->gpio_base);
-
-	ret = spi_setup(spi);
-	if (ret < 0)
-		return ret;
-
 	ts = kzalloc(sizeof(struct sc16is7x2_chip), GFP_KERNEL);
 	if (!ts)
 		return -ENOMEM;
 
 	mutex_init(&ts->lock);
-	dev_set_drvdata(&spi->dev, ts);
+	spi_set_drvdata(spi, ts);
 	ts->spi = spi;
 	ts->force_end_work = 1;
 
@@ -1235,16 +1264,22 @@ static int __devinit sc16is7x2_probe(str
 	INIT_WORK(&ts->work, sc16is7x2_work);
 	ts->force_end_work = 0;
 
+	printk(KERN_INFO DRIVER_NAME " at CS%d (irq %d), 2 UARTs, 8 GPIOs\n"
+			"    eser%d, eser%d, gpiochip%d\n",
+			spi->chip_select, spi->irq,
+			pdata->uart_base, pdata->uart_base + 1,
+			pdata->gpio_base);
+
 	return ret;
 
 exit_gpio:
 	ret = gpiochip_remove(&ts->gpio);
 
 exit_uart1:
-	uart_remove_one_port(&sc16is7x2_uart_driver, &ts->channel[1].uart);
+	sc16is7x2_unregister_uart_port(ts, 1);
 
 exit_uart0:
-	uart_remove_one_port(&sc16is7x2_uart_driver, &ts->channel[0].uart);
+	sc16is7x2_unregister_uart_port(ts, 0);
 
 exit_irq:
 	free_irq(spi->irq, ts);
@@ -1258,10 +1293,9 @@ exit_destroy:
 
 static int __devexit sc16is7x2_remove(struct spi_device *spi)
 {
-	struct sc16is7x2_chip *ts;
+	struct sc16is7x2_chip *ts = spi_get_drvdata(spi);
 	int ret;
 
-	ts = dev_get_drvdata(&spi->dev);
 	if (ts == NULL)
 		return -ENODEV;
 
@@ -1274,22 +1308,12 @@ static int __devexit sc16is7x2_remove(st
 		ts->workqueue = NULL;
 	}
 
-	dev_set_drvdata(&spi->dev, NULL);
-
-	ret = uart_remove_one_port(&sc16is7x2_uart_driver,
-			&ts->channel[0].uart);
-	if (ret) {
-		dev_err(&spi->dev, "Failed to remove the UART port A: %d\n",
-			ret);
+	ret = sc16is7x2_unregister_uart_port(ts, 0);
+	if (ret)
 		goto exit_error;
-	}
-	ret = uart_remove_one_port(&sc16is7x2_uart_driver,
-			&ts->channel[1].uart);
-	if (ret) {
-		dev_err(&spi->dev, "Failed to remove the UART port B: %d\n",
-			ret);
+	ret = sc16is7x2_unregister_uart_port(ts, 1);
+	if (ret)
 		goto exit_error;
-	}
 	ret = gpiochip_remove(&ts->gpio);
 	if (ret) {
 		dev_err(&spi->dev, "Failed to remove the GPIO controller: %d\n",
@@ -1324,8 +1348,8 @@ static struct spi_driver sc16is7x2_spi_d
 
 static int __init sc16is7x2_init(void)
 {
-	int ret;
-	ret = uart_register_driver(&sc16is7x2_uart_driver);
+	int ret = uart_register_driver(&sc16is7x2_uart_driver);
+
 	if (ret) {
 		printk(KERN_ERR "Couldn't register sc16is7x2 uart driver\n");
 		return ret;
diff -puN include/linux/serial_core.h~serial-add-sc16is7x2-driver-update include/linux/serial_core.h
--- a/include/linux/serial_core.h~serial-add-sc16is7x2-driver-update
+++ a/include/linux/serial_core.h
@@ -47,6 +47,9 @@
 #define PORT_U6_16550A	19	/* ST-Ericsson U6xxx internal UART */
 #define PORT_MAX_8250	19	/* max port ID */
 
+/* SC16IS7x2 SPI UART */
+#define PORT_SC16IS7X2	19
+
 /*
  * ARM specific type numbers.  These are not currently guaranteed
  * to be implemented, and will change in the future.  These are
@@ -235,9 +238,6 @@ struct uart_ops {
 			      unsigned int oldstate);
 	int		(*set_wake)(struct uart_port *, unsigned int state);
 
-/* SC16IS7x2 SPI UART */
-#define PORT_SC16IS7X2	19
