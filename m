From: akpm@osdl.org
Subject: - serial-uartlite-driver.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:00:48 -0800
Message-ID: <200612072300.kB7N0mVN029673@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51606 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163674AbWLGXB4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:01:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jacmet@sunsite.dk, alan@lxorguk.ukuu.org.uk, olof@lixom.net, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     serial uartlite driver
has been removed from the -mm tree.  Its filename was
     serial-uartlite-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: serial uartlite driver
From: Peter Korsgaard <jacmet@sunsite.dk>

Add a driver for the Xilinx uartlite serial controller used in boards with
the PPC405 core in the Xilinx V2P/V4 fpgas.

The hardware is very simple (baudrate/start/stopbits fixed and no break
support).  See the datasheet for details:

http://www.xilinx.com/bvdocs/ipcenter/data_sheet/opb_uartlite.pdf

See http://thread.gmane.org/gmane.linux.serial/1237/ for the email thread.

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
Acked-by: Olof Johansson <olof@lixom.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 MAINTAINERS                 |    6 
 drivers/serial/Kconfig      |   19 +
 drivers/serial/Makefile     |    1 
 drivers/serial/uartlite.c   |  505 ++++++++++++++++++++++++++++++++++
 include/linux/serial_core.h |    2 
 5 files changed, 533 insertions(+)

diff -puN MAINTAINERS~serial-uartlite-driver MAINTAINERS
--- a/MAINTAINERS~serial-uartlite-driver
+++ a/MAINTAINERS
@@ -3454,6 +3454,12 @@ W:	http://oss.sgi.com/projects/xfs
 T:	git git://oss.sgi.com:8090/xfs/xfs-2.6
 S:	Supported
 
+XILINX UARTLITE SERIAL DRIVER
+P:	Peter Korsgaard
+M:	jacmet@sunsite.dk
+L:	linux-serial@vger.kernel.org
+S:	Maintained
+
 X86 3-LEVEL PAGING (PAE) SUPPORT
 P:	Ingo Molnar
 M:	mingo@redhat.com
diff -puN drivers/serial/Kconfig~serial-uartlite-driver drivers/serial/Kconfig
--- a/drivers/serial/Kconfig~serial-uartlite-driver
+++ a/drivers/serial/Kconfig
@@ -511,6 +511,25 @@ config SERIAL_IMX_CONSOLE
 	  your boot loader (lilo or loadlin) about how to pass options to the
 	  kernel at boot time.)
 
+config SERIAL_UARTLITE
+	tristate "Xilinx uartlite serial port support"
+	depends on PPC32
+	select SERIAL_CORE
+	help
+	  Say Y here if you want to use the Xilinx uartlite serial controller.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called uartlite.ko.
+
+config SERIAL_UARTLITE_CONSOLE
+	bool "Support for console on Xilinx uartlite serial port"
+	depends on SERIAL_UARTLITE=y
+	select SERIAL_CORE_CONSOLE
+	help
+	  Say Y here if you wish to use a Xilinx uartlite as the system
+	  console (the system console is the device which receives all kernel
+	  messages and warnings and which allows logins in single user mode).
+
 config SERIAL_SUNCORE
 	bool
 	depends on SPARC
diff -puN drivers/serial/Makefile~serial-uartlite-driver drivers/serial/Makefile
--- a/drivers/serial/Makefile~serial-uartlite-driver
+++ a/drivers/serial/Makefile
@@ -55,4 +55,5 @@ obj-$(CONFIG_SERIAL_VR41XX) += vr41xx_si
 obj-$(CONFIG_SERIAL_SGI_IOC4) += ioc4_serial.o
 obj-$(CONFIG_SERIAL_SGI_IOC3) += ioc3_serial.o
 obj-$(CONFIG_SERIAL_ATMEL) += atmel_serial.o
+obj-$(CONFIG_SERIAL_UARTLITE) += uartlite.o
 obj-$(CONFIG_SERIAL_NETX) += netx-serial.o
diff -puN /dev/null drivers/serial/uartlite.c
--- /dev/null
+++ a/drivers/serial/uartlite.c
@@ -0,0 +1,505 @@
+/*
+ * uartlite.c: Serial driver for Xilinx uartlite serial controller
+ *
+ * Peter Korsgaard <jacmet@sunsite.dk>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+#include <linux/platform_device.h>
+#include <linux/module.h>
+#include <linux/console.h>
+#include <linux/serial.h>
+#include <linux/serial_core.h>
+#include <linux/tty.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <asm/io.h>
+
+#define ULITE_MAJOR		204
+#define ULITE_MINOR		187
+#define ULITE_NR_UARTS		4
+
+/* For register details see datasheet:
+   http://www.xilinx.com/bvdocs/ipcenter/data_sheet/opb_uartlite.pdf
+*/
+#define ULITE_RX		0x00
+#define ULITE_TX		0x04
+#define ULITE_STATUS		0x08
+#define ULITE_CONTROL		0x0c
+
+#define ULITE_REGION		16
+
+#define ULITE_STATUS_RXVALID	0x01
+#define ULITE_STATUS_RXFULL	0x02
+#define ULITE_STATUS_TXEMPTY	0x04
+#define ULITE_STATUS_TXFULL	0x08
+#define ULITE_STATUS_IE		0x10
+#define ULITE_STATUS_OVERRUN	0x20
+#define ULITE_STATUS_FRAME	0x40
+#define ULITE_STATUS_PARITY	0x80
+
+#define ULITE_CONTROL_RST_TX	0x01
+#define ULITE_CONTROL_RST_RX	0x02
+#define ULITE_CONTROL_IE	0x10
+
+
+static struct uart_port ports[ULITE_NR_UARTS];
+
+static int ulite_receive(struct uart_port *port, int stat)
+{
+	struct tty_struct *tty = port->info->tty;
+	unsigned char ch = 0;
+	char flag = TTY_NORMAL;
+
+	if ((stat & (ULITE_STATUS_RXVALID | ULITE_STATUS_OVERRUN
+		     | ULITE_STATUS_FRAME)) == 0)
+		return 0;
+
+	/* stats */
+	if (stat & ULITE_STATUS_RXVALID) {
+		port->icount.rx++;
+		ch = readb(port->membase + ULITE_RX);
+
+		if (stat & ULITE_STATUS_PARITY)
+			port->icount.parity++;
+	}
+
+	if (stat & ULITE_STATUS_OVERRUN)
+		port->icount.overrun++;
+
+	if (stat & ULITE_STATUS_FRAME)
+		port->icount.frame++;
+
+
+	/* drop byte with parity error if IGNPAR specificed */
+	if (stat & port->ignore_status_mask & ULITE_STATUS_PARITY)
+		stat &= ~ULITE_STATUS_RXVALID;
+
+	stat &= port->read_status_mask;
+
+	if (stat & ULITE_STATUS_PARITY)
+		flag = TTY_PARITY;
+
+
+	stat &= ~port->ignore_status_mask;
+
+	if (stat & ULITE_STATUS_RXVALID)
+		tty_insert_flip_char(tty, ch, flag);
+
+	if (stat & ULITE_STATUS_FRAME)
+		tty_insert_flip_char(tty, 0, TTY_FRAME);
+
+	if (stat & ULITE_STATUS_OVERRUN)
+		tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+
+	return 1;
+}
+
+static int ulite_transmit(struct uart_port *port, int stat)
+{
+	struct circ_buf *xmit  = &port->info->xmit;
+
+	if (stat & ULITE_STATUS_TXFULL)
+		return 0;
+
+	if (port->x_char) {
+		writeb(port->x_char, port->membase + ULITE_TX);
+		port->x_char = 0;
+		port->icount.tx++;
+		return 1;
+	}
+
+	if (uart_circ_empty(xmit) || uart_tx_stopped(port))
+		return 0;
+
+	writeb(xmit->buf[xmit->tail], port->membase + ULITE_TX);
+	xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE-1);
+	port->icount.tx++;
+
+	/* wake up */
+	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
+		uart_write_wakeup(port);
+
+	return 1;
+}
+
+static irqreturn_t ulite_isr(int irq, void *dev_id)
+{
+	struct uart_port *port = (struct uart_port *)dev_id;
+	int busy;
+
+	do {
+		int stat = readb(port->membase + ULITE_STATUS);
+		busy  = ulite_receive(port, stat);
+		busy |= ulite_transmit(port, stat);
+	} while (busy);
+
+	tty_flip_buffer_push(port->info->tty);
+
+	return IRQ_HANDLED;
+}
+
+static unsigned int ulite_tx_empty(struct uart_port *port)
+{
+	unsigned long flags;
+	unsigned int ret;
+
+	spin_lock_irqsave(&port->lock, flags);
+	ret = readb(port->membase + ULITE_STATUS);
+	spin_unlock_irqrestore(&port->lock, flags);
+
+	return ret & ULITE_STATUS_TXEMPTY ? TIOCSER_TEMT : 0;
+}
+
+static unsigned int ulite_get_mctrl(struct uart_port *port)
+{
+	return TIOCM_CTS | TIOCM_DSR | TIOCM_CAR;
+}
+
+static void ulite_set_mctrl(struct uart_port *port, unsigned int mctrl)
+{
+	/* N/A */
+}
+
+static void ulite_stop_tx(struct uart_port *port)
+{
+	/* N/A */
+}
+
+static void ulite_start_tx(struct uart_port *port)
+{
+	ulite_transmit(port, readb(port->membase + ULITE_STATUS));
+}
+
+static void ulite_stop_rx(struct uart_port *port)
+{
+	/* don't forward any more data (like !CREAD) */
+	port->ignore_status_mask = ULITE_STATUS_RXVALID | ULITE_STATUS_PARITY
+		| ULITE_STATUS_FRAME | ULITE_STATUS_OVERRUN;
+}
+
+static void ulite_enable_ms(struct uart_port *port)
+{
+	/* N/A */
+}
+
+static void ulite_break_ctl(struct uart_port *port, int ctl)
+{
+	/* N/A */
+}
+
+static int ulite_startup(struct uart_port *port)
+{
+	int ret;
+
+	ret = request_irq(port->irq, ulite_isr,
+			  IRQF_DISABLED | IRQF_SAMPLE_RANDOM, "uartlite", port);
+	if (ret)
+		return ret;
+
+	writeb(ULITE_CONTROL_RST_RX | ULITE_CONTROL_RST_TX,
+	       port->membase + ULITE_CONTROL);
+	writeb(ULITE_CONTROL_IE, port->membase + ULITE_CONTROL);
+
+	return 0;
+}
+
+static void ulite_shutdown(struct uart_port *port)
+{
+	writeb(0, port->membase + ULITE_CONTROL);
+	readb(port->membase + ULITE_CONTROL); /* dummy */
+	free_irq(port->irq, port);
+}
+
+static void ulite_set_termios(struct uart_port *port, struct termios *termios,
+			      struct termios *old)
+{
+	unsigned long flags;
+	unsigned int baud;
+
+	spin_lock_irqsave(&port->lock, flags);
+
+	port->read_status_mask = ULITE_STATUS_RXVALID | ULITE_STATUS_OVERRUN
+		| ULITE_STATUS_TXFULL;
+
+	if (termios->c_iflag & INPCK)
+		port->read_status_mask |=
+			ULITE_STATUS_PARITY | ULITE_STATUS_FRAME;
+
+	port->ignore_status_mask = 0;
+	if (termios->c_iflag & IGNPAR)
+		port->ignore_status_mask |= ULITE_STATUS_PARITY
+			| ULITE_STATUS_FRAME | ULITE_STATUS_OVERRUN;
+
+	/* ignore all characters if CREAD is not set */
+	if ((termios->c_cflag & CREAD) == 0)
+		port->ignore_status_mask |=
+			ULITE_STATUS_RXVALID | ULITE_STATUS_PARITY
+			| ULITE_STATUS_FRAME | ULITE_STATUS_OVERRUN;
+
+	/* update timeout */
+	baud = uart_get_baud_rate(port, termios, old, 0, 460800);
+	uart_update_timeout(port, termios->c_cflag, baud);
+
+	spin_unlock_irqrestore(&port->lock, flags);
+}
+
+static const char *ulite_type(struct uart_port *port)
+{
+	return port->type == PORT_UARTLITE ? "uartlite" : NULL;
+}
+
+static void ulite_release_port(struct uart_port *port)
+{
+	release_mem_region(port->mapbase, ULITE_REGION);
+	iounmap(port->membase);
+	port->membase = 0;
+}
+
+static int ulite_request_port(struct uart_port *port)
+{
+	if (!request_mem_region(port->mapbase, ULITE_REGION, "uartlite")) {
+		dev_err(port->dev, "Memory region busy\n");
+		return -EBUSY;
+	}
+
+	port->membase = ioremap(port->mapbase, ULITE_REGION);
+	if (!port->membase) {
+		dev_err(port->dev, "Unable to map registers\n");
+		release_mem_region(port->mapbase, ULITE_REGION);
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
+static void ulite_config_port(struct uart_port *port, int flags)
+{
+	ulite_request_port(port);
+	port->type = PORT_UARTLITE;
+}
+
+static int ulite_verify_port(struct uart_port *port, struct serial_struct *ser)
+{
+	/* we don't want the core code to modify any port params */
+	return -EINVAL;
+}
+
+static struct uart_ops ulite_ops = {
+	.tx_empty	= ulite_tx_empty,
+	.set_mctrl	= ulite_set_mctrl,
+	.get_mctrl	= ulite_get_mctrl,
+	.stop_tx	= ulite_stop_tx,
+	.start_tx	= ulite_start_tx,
+	.stop_rx	= ulite_stop_rx,
+	.enable_ms	= ulite_enable_ms,
+	.break_ctl	= ulite_break_ctl,
+	.startup	= ulite_startup,
+	.shutdown	= ulite_shutdown,
+	.set_termios	= ulite_set_termios,
+	.type		= ulite_type,
+	.release_port	= ulite_release_port,
+	.request_port	= ulite_request_port,
+	.config_port	= ulite_config_port,
+	.verify_port	= ulite_verify_port
+};
+
+#ifdef CONFIG_SERIAL_UARTLITE_CONSOLE
+static void ulite_console_wait_tx(struct uart_port *port)
+{
+	int i;
+
+	/* wait up to 10ms for the character(s) to be sent */
+	for (i = 0; i < 10000; i++) {
+		if (readb(port->membase + ULITE_STATUS) & ULITE_STATUS_TXEMPTY)
+			break;
+		udelay(1);
+	}
+}
+
+static void ulite_console_putchar(struct uart_port *port, int ch)
+{
+	ulite_console_wait_tx(port);
+	writeb(ch, port->membase + ULITE_TX);
+}
+
+static void ulite_console_write(struct console *co, const char *s,
+				unsigned int count)
+{
+	struct uart_port *port = &ports[co->index];
+	unsigned long flags;
+	unsigned int ier;
+	int locked = 1;
+
+	if (oops_in_progress) {
+		locked = spin_trylock_irqsave(&port->lock, flags);
+	} else
+		spin_lock_irqsave(&port->lock, flags);
+
+	/* save and disable interrupt */
+	ier = readb(port->membase + ULITE_STATUS) & ULITE_STATUS_IE;
+	writeb(0, port->membase + ULITE_CONTROL);
+
+	uart_console_write(port, s, count, ulite_console_putchar);
+
+	ulite_console_wait_tx(port);
+
+	/* restore interrupt state */
+	if (ier)
+		writeb(ULITE_CONTROL_IE, port->membase + ULITE_CONTROL);
+
+	if (locked)
+		spin_unlock_irqrestore(&port->lock, flags);
+}
+
+static int __init ulite_console_setup(struct console *co, char *options)
+{
+	struct uart_port *port;
+	int baud = 9600;
+	int bits = 8;
+	int parity = 'n';
+	int flow = 'n';
+
+	if (co->index < 0 || co->index >= ULITE_NR_UARTS)
+		return -EINVAL;
+
+	port = &ports[co->index];
+
+	/* not initialized yet? */
+	if (!port->membase)
+		return -ENODEV;
+
+	if (options)
+		uart_parse_options(options, &baud, &parity, &bits, &flow);
+
+	return uart_set_options(port, co, baud, parity, bits, flow);
+}
+
+static struct uart_driver ulite_uart_driver;
+
+static struct console ulite_console = {
+	.name	= "ttyUL",
+	.write	= ulite_console_write,
+	.device	= uart_console_device,
+	.setup	= ulite_console_setup,
+	.flags	= CON_PRINTBUFFER,
+	.index	= -1, /* Specified on the cmdline (e.g. console=ttyUL0 ) */
+	.data	= &ulite_uart_driver,
+};
+
+static int __init ulite_console_init(void)
+{
+	register_console(&ulite_console);
+	return 0;
+}
+
+console_initcall(ulite_console_init);
+
+#endif /* CONFIG_SERIAL_UARTLITE_CONSOLE */
+
+static struct uart_driver ulite_uart_driver = {
+	.owner		= THIS_MODULE,
+	.driver_name	= "uartlite",
+	.dev_name	= "ttyUL",
+	.major		= ULITE_MAJOR,
+	.minor		= ULITE_MINOR,
+	.nr		= ULITE_NR_UARTS,
+#ifdef CONFIG_SERIAL_UARTLITE_CONSOLE
+	.cons		= &ulite_console,
+#endif
+};
+
+static int __devinit ulite_probe(struct platform_device *pdev)
+{
+	struct resource *res, *res2;
+	struct uart_port *port;
+
+	if (pdev->id < 0 || pdev->id >= ULITE_NR_UARTS)
+		return -EINVAL;
+
+	if (ports[pdev->id].membase)
+		return -EBUSY;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENODEV;
+
+	res2 = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!res2)
+		return -ENODEV;
+
+	port = &ports[pdev->id];
+
+	port->fifosize	= 16;
+	port->regshift	= 2;
+	port->iotype	= UPIO_MEM;
+	port->iobase	= 1; /* mark port in use */
+	port->mapbase	= res->start;
+	port->membase	= 0;
+	port->ops	= &ulite_ops;
+	port->irq	= res2->start;
+	port->flags	= UPF_BOOT_AUTOCONF;
+	port->dev	= &pdev->dev;
+	port->type	= PORT_UNKNOWN;
+	port->line	= pdev->id;
+
+	uart_add_one_port(&ulite_uart_driver, port);
+	platform_set_drvdata(pdev, port);
+
+	return 0;
+}
+
+static int ulite_remove(struct platform_device *pdev)
+{
+	struct uart_port *port = platform_get_drvdata(pdev);
+
+	platform_set_drvdata(pdev, NULL);
+
+	if (port)
+		uart_remove_one_port(&ulite_uart_driver, port);
+
+	/* mark port as free */
+	port->membase = 0;
+
+	return 0;
+}
+
+static struct platform_driver ulite_platform_driver = {
+	.probe	= ulite_probe,
+	.remove	= ulite_remove,
+	.driver	= {
+		   .owner = THIS_MODULE,
+		   .name  = "uartlite",
+		   },
+};
+
+int __init ulite_init(void)
+{
+	int ret;
+
+	ret = uart_register_driver(&ulite_uart_driver);
+	if (ret)
+		return ret;
+
+	ret = platform_driver_register(&ulite_platform_driver);
+	if (ret)
+		uart_unregister_driver(&ulite_uart_driver);
+
+	return ret;
+}
+
+void __exit ulite_exit(void)
+{
+	platform_driver_unregister(&ulite_platform_driver);
+	uart_unregister_driver(&ulite_uart_driver);
+}
+
+module_init(ulite_init);
+module_exit(ulite_exit);
+
+MODULE_AUTHOR("Peter Korsgaard <jacmet@sunsite.dk>");
+MODULE_DESCRIPTION("Xilinx uartlite serial driver");
+MODULE_LICENSE("GPL");
diff -puN include/linux/serial_core.h~serial-uartlite-driver include/linux/serial_core.h
--- a/include/linux/serial_core.h~serial-uartlite-driver
+++ a/include/linux/serial_core.h
@@ -132,6 +132,8 @@
 
 #define PORT_S3C2412	73
 
+/* Xilinx uartlite */
+#define PORT_UARTLITE	74
 
 #ifdef __KERNEL__
 
_

Patches currently in -mm which might be from jacmet@sunsite.dk are

origin.patch

