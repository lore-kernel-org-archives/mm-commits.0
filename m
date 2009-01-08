From: akpm@linux-foundation.org
Subject: - serial-add-support-for-the-cell-network-processor-nwp-device.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:51:34 -0800
Message-ID: <200901082251.n08MpY55030733@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42332 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760836AbZAHWwH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:52:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben@codiert.org, alan@lxorguk.ukuu.org.uk, arnd@arndb.de, david@gibson.dropbear.id.au, jwboyer@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     serial: add support for the cell network processor NWP device
has been removed from the -mm tree.  Its filename was
     serial-add-support-for-the-cell-network-processor-nwp-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: add support for the cell network processor NWP device
From: Benjamin Krill <ben@codiert.org>

Add support for the nwp serial device which is connected to a DCR bus.  It
uses the of_serial device driver to determine necessary properties from
the device tree.  The supported device is added as serial port number 84.

NWP stands for network processor and it is part of the QPACE - Quantum
Chromodynamics Parallel Computing on the Cell Broadband Engine project. 
The implementation is a lightweight uart implementation with the focus to
consume as little resources as possible and it is connected to a DCR bus.

Signed-off-by: Benjamin Krill <ben@codiert.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/Kconfig      |   19 +
 drivers/serial/Makefile     |    1 
 drivers/serial/nwpserial.c  |  477 ++++++++++++++++++++++++++++++++++
 drivers/serial/of_serial.c  |   19 +
 include/linux/nwpserial.h   |   18 +
 include/linux/serial_core.h |    3 
 6 files changed, 536 insertions(+), 1 deletion(-)

diff -puN drivers/serial/Kconfig~serial-add-support-for-the-cell-network-processor-nwp-device drivers/serial/Kconfig
--- a/drivers/serial/Kconfig~serial-add-support-for-the-cell-network-processor-nwp-device
+++ a/drivers/serial/Kconfig
@@ -1320,13 +1320,30 @@ config SERIAL_NETX_CONSOLE
 config SERIAL_OF_PLATFORM
 	tristate "Serial port on Open Firmware platform bus"
 	depends on PPC_OF
-	depends on SERIAL_8250
+	depends on SERIAL_8250 || SERIAL_OF_PLATFORM_NWPSERIAL
 	help
 	  If you have a PowerPC based system that has serial ports
 	  on a platform specific bus, you should enable this option.
 	  Currently, only 8250 compatible ports are supported, but
 	  others can easily be added.
 
+config SERIAL_OF_PLATFORM_NWPSERIAL
+	tristate "NWP serial port driver"
+	depends on PPC_OF && PPC_DCR
+	select SERIAL_OF_PLATFORM
+	select SERIAL_CORE_CONSOLE
+	select SERIAL_CORE
+	help
+	  This driver supports the cell network processor nwp serial
+	  device.
+
+config SERIAL_OF_PLATFORM_NWPSERIAL_CONSOLE
+	bool "Console on NWP serial port"
+	depends on SERIAL_OF_PLATFORM_NWPSERIAL=y
+	select SERIAL_CORE_CONSOLE
+	help
+	  Support for Console on the NWP serial ports.
+
 config SERIAL_QE
 	tristate "Freescale QUICC Engine serial port support"
 	depends on QUICC_ENGINE
diff -puN drivers/serial/Makefile~serial-add-support-for-the-cell-network-processor-nwp-device drivers/serial/Makefile
--- a/drivers/serial/Makefile~serial-add-support-for-the-cell-network-processor-nwp-device
+++ a/drivers/serial/Makefile
@@ -72,6 +72,7 @@ obj-$(CONFIG_SERIAL_ATMEL) += atmel_seri
 obj-$(CONFIG_SERIAL_UARTLITE) += uartlite.o
 obj-$(CONFIG_SERIAL_NETX) += netx-serial.o
 obj-$(CONFIG_SERIAL_OF_PLATFORM) += of_serial.o
+obj-$(CONFIG_SERIAL_OF_PLATFORM_NWPSERIAL) += nwpserial.o
 obj-$(CONFIG_SERIAL_KS8695) += serial_ks8695.o
 obj-$(CONFIG_KGDB_SERIAL_CONSOLE) += kgdboc.o
 obj-$(CONFIG_SERIAL_QE) += ucc_uart.o
diff -puN /dev/null drivers/serial/nwpserial.c
--- /dev/null
+++ a/drivers/serial/nwpserial.c
@@ -0,0 +1,477 @@
+/*
+ *  Serial Port driver for a NWP uart device
+ *
+ *    Copyright (C) 2008 IBM Corp., Benjamin Krill <ben@codiert.org>
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation; either version
+ *  2 of the License, or (at your option) any later version.
+ *
+ */
+#include <linux/init.h>
+#include <linux/console.h>
+#include <linux/serial.h>
+#include <linux/serial_reg.h>
+#include <linux/serial_core.h>
+#include <linux/tty.h>
+#include <linux/irqreturn.h>
+#include <linux/mutex.h>
+#include <linux/of_platform.h>
+#include <linux/of_device.h>
+#include <linux/nwpserial.h>
+#include <asm/prom.h>
+#include <asm/dcr.h>
+
+#define NWPSERIAL_NR               2
+
+#define NWPSERIAL_STATUS_RXVALID 0x1
+#define NWPSERIAL_STATUS_TXFULL  0x2
+
+struct nwpserial_port {
+	struct uart_port port;
+	dcr_host_t dcr_host;
+	unsigned int ier;
+	unsigned int mcr;
+};
+
+static DEFINE_MUTEX(nwpserial_mutex);
+static struct nwpserial_port nwpserial_ports[NWPSERIAL_NR];
+
+static void wait_for_bits(struct nwpserial_port *up, int bits)
+{
+	unsigned int status, tmout = 10000;
+
+	/* Wait up to 10ms for the character(s) to be sent. */
+	do {
+		status = dcr_read(up->dcr_host, UART_LSR);
+
+		if (--tmout == 0)
+			break;
+		udelay(1);
+	} while ((status & bits) != bits);
+}
+
+#ifdef CONFIG_SERIAL_OF_PLATFORM_NWPSERIAL_CONSOLE
+static void nwpserial_console_putchar(struct uart_port *port, int c)
+{
+	struct nwpserial_port *up;
+	up = container_of(port, struct nwpserial_port, port);
+	/* check if tx buffer is full */
+	wait_for_bits(up, UART_LSR_THRE);
+	dcr_write(up->dcr_host, UART_TX, c);
+	up->port.icount.tx++;
+}
+
+static void
+nwpserial_console_write(struct console *co, const char *s, unsigned int count)
+{
+	struct nwpserial_port *up = &nwpserial_ports[co->index];
+	unsigned long flags;
+	int locked = 1;
+
+	if (oops_in_progress)
+		locked = spin_trylock_irqsave(&up->port.lock, flags);
+	else
+		spin_lock_irqsave(&up->port.lock, flags);
+
+	/* save and disable interrupt */
+	up->ier = dcr_read(up->dcr_host, UART_IER);
+	dcr_write(up->dcr_host, UART_IER, up->ier & ~UART_IER_RDI);
+
+	uart_console_write(&up->port, s, count, nwpserial_console_putchar);
+
+	/* wait for transmitter to become emtpy */
+	while ((dcr_read(up->dcr_host, UART_LSR) & UART_LSR_THRE) == 0)
+		cpu_relax();
+
+	/* restore interrupt state */
+	dcr_write(up->dcr_host, UART_IER, up->ier);
+
+	if (locked)
+		spin_unlock_irqrestore(&up->port.lock, flags);
+}
+
+static struct uart_driver nwpserial_reg;
+static struct console nwpserial_console = {
+	.name		= "ttySQ",
+	.write		= nwpserial_console_write,
+	.device		= uart_console_device,
+	.flags		= CON_PRINTBUFFER,
+	.index		= -1,
+	.data		= &nwpserial_reg,
+};
+#define NWPSERIAL_CONSOLE	(&nwpserial_console)
+#else
+#define NWPSERIAL_CONSOLE	NULL
+#endif /* CONFIG_SERIAL_OF_PLATFORM_NWPSERIAL_CONSOLE */
+
+/**************************************************************************/
+
+static int nwpserial_request_port(struct uart_port *port)
+{
+	return 0;
+}
+
+static void nwpserial_release_port(struct uart_port *port)
+{
+	/* N/A */
+}
+
+static void nwpserial_config_port(struct uart_port *port, int flags)
+{
+	port->type = PORT_NWPSERIAL;
+}
+
+static irqreturn_t nwpserial_interrupt(int irq, void *dev_id)
+{
+	struct nwpserial_port *up = dev_id;
+	struct tty_struct *tty = up->port.info->port.tty;
+	irqreturn_t ret;
+	unsigned int iir;
+	unsigned char ch;
+
+	spin_lock(&up->port.lock);
+
+	/* check if the uart was the interrupt source. */
+	iir = dcr_read(up->dcr_host, UART_IIR);
+	if (!iir) {
+		ret = IRQ_NONE;
+		goto out;
+	}
+
+	do {
+		up->port.icount.rx++;
+		ch = dcr_read(up->dcr_host, UART_RX);
+		if (up->port.ignore_status_mask != NWPSERIAL_STATUS_RXVALID)
+			tty_insert_flip_char(tty, ch, TTY_NORMAL);
+	} while (dcr_read(up->dcr_host, UART_RX) & UART_LSR_DR);
+
+	tty_flip_buffer_push(tty);
+	ret = IRQ_HANDLED;
+
+out:
+	spin_unlock(&up->port.lock);
+	return ret;
+}
+
+static int nwpserial_startup(struct uart_port *port)
+{
+	struct nwpserial_port *up;
+	int err;
+
+	up = container_of(port, struct nwpserial_port, port);
+
+	/* disable flow control by default */
+	up->mcr = dcr_read(up->dcr_host, UART_MCR) & ~UART_MCR_AFE;
+	dcr_write(up->dcr_host, UART_MCR, up->mcr);
+
+	/* register interrupt handler */
+	err = request_irq(up->port.irq, nwpserial_interrupt,
+			IRQF_SHARED, "nwpserial", up);
+	if (err) {
+		free_irq(up->port.irq, port);
+		return err;
+	}
+
+	/* enable interrupts */
+	up->ier = UART_IER_RDI;
+	dcr_write(up->dcr_host, UART_IER, up->ier);
+
+	/* enable receiving */
+	up->port.ignore_status_mask &= ~NWPSERIAL_STATUS_RXVALID;
+
+	return 0;
+}
+
+static void nwpserial_shutdown(struct uart_port *port)
+{
+	struct nwpserial_port *up;
+	up = container_of(port, struct nwpserial_port, port);
+
+	/* disable receiving */
+	up->port.ignore_status_mask |= NWPSERIAL_STATUS_RXVALID;
+
+	/* disable interrupts from this port */
+	up->ier = 0;
+	dcr_write(up->dcr_host, UART_IER, up->ier);
+
+	/* free irq */
+	free_irq(up->port.irq, port);
+}
+
+static int nwpserial_verify_port(struct uart_port *port,
+			struct serial_struct *ser)
+{
+	return -EINVAL;
+}
+
+static const char *nwpserial_type(struct uart_port *port)
+{
+	return port->type == PORT_NWPSERIAL ? "nwpserial" : NULL;
+}
+
+static void nwpserial_set_termios(struct uart_port *port,
+			struct ktermios *termios, struct ktermios *old)
+{
+	struct nwpserial_port *up;
+	up = container_of(port, struct nwpserial_port, port);
+
+	up->port.read_status_mask = NWPSERIAL_STATUS_RXVALID
+				| NWPSERIAL_STATUS_TXFULL;
+
+	up->port.ignore_status_mask = 0;
+	/* ignore all characters if CREAD is not set */
+	if ((termios->c_cflag & CREAD) == 0)
+		up->port.ignore_status_mask |= NWPSERIAL_STATUS_RXVALID;
+
+	/* Copy back the old hardware settings */
+	if (old)
+		tty_termios_copy_hw(termios, old);
+}
+
+static void nwpserial_break_ctl(struct uart_port *port, int ctl)
+{
+	/* N/A */
+}
+
+static void nwpserial_enable_ms(struct uart_port *port)
+{
+	/* N/A */
+}
+
+static void nwpserial_stop_rx(struct uart_port *port)
+{
+	struct nwpserial_port *up;
+	up = container_of(port, struct nwpserial_port, port);
+	/* don't forward any more data (like !CREAD) */
+	up->port.ignore_status_mask = NWPSERIAL_STATUS_RXVALID;
+}
+
+static void nwpserial_putchar(struct nwpserial_port *up, unsigned char c)
+{
+	/* check if tx buffer is full */
+	wait_for_bits(up, UART_LSR_THRE);
+	dcr_write(up->dcr_host, UART_TX, c);
+	up->port.icount.tx++;
+}
+
+static void nwpserial_start_tx(struct uart_port *port)
+{
+	struct nwpserial_port *up;
+	struct circ_buf *xmit;
+	up = container_of(port, struct nwpserial_port, port);
+	xmit  = &up->port.info->xmit;
+
+	if (port->x_char) {
+		nwpserial_putchar(up, up->port.x_char);
+		port->x_char = 0;
+	}
+
+	while (!(uart_circ_empty(xmit) || uart_tx_stopped(&up->port))) {
+		nwpserial_putchar(up, xmit->buf[xmit->tail]);
+		xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE-1);
+	}
+}
+
+static unsigned int nwpserial_get_mctrl(struct uart_port *port)
+{
+	return 0;
+}
+
+static void nwpserial_set_mctrl(struct uart_port *port, unsigned int mctrl)
+{
+	/* N/A */
+}
+
+static void nwpserial_stop_tx(struct uart_port *port)
+{
+	/* N/A */
+}
+
+static unsigned int nwpserial_tx_empty(struct uart_port *port)
+{
+	struct nwpserial_port *up;
+	unsigned long flags;
+	int ret;
+	up = container_of(port, struct nwpserial_port, port);
+
+	spin_lock_irqsave(&up->port.lock, flags);
+	ret = dcr_read(up->dcr_host, UART_LSR);
+	spin_unlock_irqrestore(&up->port.lock, flags);
+
+	return ret & UART_LSR_TEMT ? TIOCSER_TEMT : 0;
+}
+
+static struct uart_ops nwpserial_pops = {
+	.tx_empty     = nwpserial_tx_empty,
+	.set_mctrl    = nwpserial_set_mctrl,
+	.get_mctrl    = nwpserial_get_mctrl,
+	.stop_tx      = nwpserial_stop_tx,
+	.start_tx     = nwpserial_start_tx,
+	.stop_rx      = nwpserial_stop_rx,
+	.enable_ms    = nwpserial_enable_ms,
+	.break_ctl    = nwpserial_break_ctl,
+	.startup      = nwpserial_startup,
+	.shutdown     = nwpserial_shutdown,
+	.set_termios  = nwpserial_set_termios,
+	.type         = nwpserial_type,
+	.release_port = nwpserial_release_port,
+	.request_port = nwpserial_request_port,
+	.config_port  = nwpserial_config_port,
+	.verify_port  = nwpserial_verify_port,
+};
+
+static struct uart_driver nwpserial_reg = {
+	.owner       = THIS_MODULE,
+	.driver_name = "nwpserial",
+	.dev_name    = "ttySQ",
+	.major       = TTY_MAJOR,
+	.minor       = 68,
+	.nr          = NWPSERIAL_NR,
+	.cons        = NWPSERIAL_CONSOLE,
+};
+
+int nwpserial_register_port(struct uart_port *port)
+{
+	struct nwpserial_port *up = NULL;
+	int ret = -1;
+	int i;
+	static int first = 1;
+	int dcr_len;
+	int dcr_base;
+	struct device_node *dn;
+
+	mutex_lock(&nwpserial_mutex);
+
+	dn = to_of_device(port->dev)->node;
+	if (dn == NULL)
+		goto out;
+
+	/* get dcr base. */
+	dcr_base = dcr_resource_start(dn, 0);
+
+	/* find matching entry */
+	for (i = 0; i < NWPSERIAL_NR; i++)
+		if (nwpserial_ports[i].port.iobase == dcr_base) {
+			up = &nwpserial_ports[i];
+			break;
+		}
+
+	/* we didn't find a mtching entry, search for a free port */
+	if (up == NULL)
+		for (i = 0; i < NWPSERIAL_NR; i++)
+			if (nwpserial_ports[i].port.type == PORT_UNKNOWN &&
+				nwpserial_ports[i].port.iobase == 0) {
+				up = &nwpserial_ports[i];
+				break;
+			}
+
+	if (up == NULL) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	if (first)
+		uart_register_driver(&nwpserial_reg);
+	first = 0;
+
+	up->port.membase      = port->membase;
+	up->port.irq          = port->irq;
+	up->port.uartclk      = port->uartclk;
+	up->port.fifosize     = port->fifosize;
+	up->port.regshift     = port->regshift;
+	up->port.iotype       = port->iotype;
+	up->port.flags        = port->flags;
+	up->port.mapbase      = port->mapbase;
+	up->port.private_data = port->private_data;
+
+	if (port->dev)
+		up->port.dev = port->dev;
+
+	if (up->port.iobase != dcr_base) {
+		up->port.ops          = &nwpserial_pops;
+		up->port.fifosize     = 16;
+
+		spin_lock_init(&up->port.lock);
+
+		up->port.iobase = dcr_base;
+		dcr_len = dcr_resource_len(dn, 0);
+
+		up->dcr_host = dcr_map(dn, dcr_base, dcr_len);
+		if (!DCR_MAP_OK(up->dcr_host)) {
+			printk(KERN_ERR "Cannot map DCR resources for NWPSERIAL");
+			goto out;
+		}
+	}
+
+	ret = uart_add_one_port(&nwpserial_reg, &up->port);
+	if (ret == 0)
+		ret = up->port.line;
+
+out:
+	mutex_unlock(&nwpserial_mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL(nwpserial_register_port);
+
+void nwpserial_unregister_port(int line)
+{
+	struct nwpserial_port *up = &nwpserial_ports[line];
+	mutex_lock(&nwpserial_mutex);
+	uart_remove_one_port(&nwpserial_reg, &up->port);
+
+	up->port.type = PORT_UNKNOWN;
+
+	mutex_unlock(&nwpserial_mutex);
+}
+EXPORT_SYMBOL(nwpserial_unregister_port);
+
+#ifdef CONFIG_SERIAL_OF_PLATFORM_NWPSERIAL_CONSOLE
+static int __init nwpserial_console_init(void)
+{
+	struct nwpserial_port *up = NULL;
+	struct device_node *dn;
+	const char *name;
+	int dcr_base;
+	int dcr_len;
+	int i;
+
+	/* search for a free port */
+	for (i = 0; i < NWPSERIAL_NR; i++)
+		if (nwpserial_ports[i].port.type == PORT_UNKNOWN) {
+			up = &nwpserial_ports[i];
+			break;
+		}
+
+	if (up == NULL)
+		return -1;
+
+	name = of_get_property(of_chosen, "linux,stdout-path", NULL);
+	if (name == NULL)
+		return -1;
+
+	dn = of_find_node_by_path(name);
+	if (!dn)
+		return -1;
+
+	spin_lock_init(&up->port.lock);
+	up->port.ops = &nwpserial_pops;
+	up->port.type = PORT_NWPSERIAL;
+	up->port.fifosize = 16;
+
+	dcr_base = dcr_resource_start(dn, 0);
+	dcr_len = dcr_resource_len(dn, 0);
+	up->port.iobase = dcr_base;
+
+	up->dcr_host = dcr_map(dn, dcr_base, dcr_len);
+	if (!DCR_MAP_OK(up->dcr_host)) {
+		printk("Cannot map DCR resources for SERIAL");
+		return -1;
+	}
+	register_console(&nwpserial_console);
+	return 0;
+}
+console_initcall(nwpserial_console_init);
+#endif /* CONFIG_SERIAL_OF_PLATFORM_NWPSERIAL_CONSOLE */
diff -puN drivers/serial/of_serial.c~serial-add-support-for-the-cell-network-processor-nwp-device drivers/serial/of_serial.c
--- a/drivers/serial/of_serial.c~serial-add-support-for-the-cell-network-processor-nwp-device
+++ a/drivers/serial/of_serial.c
@@ -14,6 +14,7 @@
 #include <linux/serial_core.h>
 #include <linux/serial_8250.h>
 #include <linux/of_platform.h>
+#include <linux/nwpserial.h>
 
 #include <asm/prom.h>
 
@@ -99,9 +100,16 @@ static int __devinit of_platform_serial_
 		goto out;
 
 	switch (port_type) {
+#ifdef CONFIG_SERIAL_8250
 	case PORT_8250 ... PORT_MAX_8250:
 		ret = serial8250_register_port(&port);
 		break;
+#endif
+#ifdef CONFIG_SERIAL_OF_PLATFORM_NWPSERIAL
+	case PORT_NWPSERIAL:
+		ret = nwpserial_register_port(&port);
+		break;
+#endif
 	default:
 		/* need to add code for these */
 	case PORT_UNKNOWN:
@@ -129,9 +137,16 @@ static int of_platform_serial_remove(str
 {
 	struct of_serial_info *info = ofdev->dev.driver_data;
 	switch (info->type) {
+#ifdef CONFIG_SERIAL_8250
 	case PORT_8250 ... PORT_MAX_8250:
 		serial8250_unregister_port(info->line);
 		break;
+#endif
+#ifdef CONFIG_SERIAL_OF_PLATFORM_NWPSERIAL
+	case PORT_NWPSERIAL:
+		nwpserial_unregister_port(info->line);
+		break;
+#endif
 	default:
 		/* need to add code for these */
 		break;
@@ -148,6 +163,10 @@ static struct of_device_id __devinitdata
 	{ .type = "serial", .compatible = "ns16450",  .data = (void *)PORT_16450, },
 	{ .type = "serial", .compatible = "ns16550",  .data = (void *)PORT_16550, },
 	{ .type = "serial", .compatible = "ns16750",  .data = (void *)PORT_16750, },
+#ifdef CONFIG_SERIAL_OF_PLATFORM_NWPSERIAL
+	{ .type = "serial", .compatible = "ibm,qpace-nwp-serial",
+					.data = (void *)PORT_NWPSERIAL, },
+#endif
 	{ .type = "serial",			      .data = (void *)PORT_UNKNOWN, },
 	{ /* end of list */ },
 };
diff -puN /dev/null include/linux/nwpserial.h
--- /dev/null
+++ a/include/linux/nwpserial.h
@@ -0,0 +1,18 @@
+/*
+ *  Serial Port driver for a NWP uart device
+ *
+ *    Copyright (C) 2008 IBM Corp., Benjamin Krill <ben@codiert.org>
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation; either version
+ *  2 of the License, or (at your option) any later version.
+ *
+ */
+#ifndef _NWPSERIAL_H
+#define _NWPSERIAL_H
+
+int nwpserial_register_port(struct uart_port *port);
+void nwpserial_unregister_port(int line);
+
+#endif /* _NWPSERIAL_H */
diff -puN include/linux/serial_core.h~serial-add-support-for-the-cell-network-processor-nwp-device include/linux/serial_core.h
--- a/include/linux/serial_core.h~serial-add-support-for-the-cell-network-processor-nwp-device
+++ a/include/linux/serial_core.h
@@ -161,6 +161,9 @@
 
 #define PORT_S3C6400	84
 
+/* NWPSERIAL */
+#define PORT_NWPSERIAL	85
+
 #ifdef __KERNEL__
 
 #include <linux/compiler.h>
_

Patches currently in -mm which might be from ben@codiert.org are

origin.patch

