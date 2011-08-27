From: akpm@linux-foundation.org
Subject: + drivers-tty-serial-pch_uartc-add-console-support.patch added to -mm tree
Date: Fri, 26 Aug 2011 17:05:41 -0700
Message-ID: <201108270005.p7R05fUm020391@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54838 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753627Ab1H0AF6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Aug 2011 20:05:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexander.stein@systec-electronic.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com


The patch titled
     drivers/tty/serial/pch_uart.c: add console support
has been added to the -mm tree.  Its filename is
     drivers-tty-serial-pch_uartc-add-console-support.patch

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
Subject: drivers/tty/serial/pch_uart.c: add console support
From: Alexander Stein <alexander.stein@systec-electronic.com>

Add console support to pch_uart.  To enable append e.g. 
console=ttyPCH0,115200 to your kernel command line.

This is not expected work on CM-iTC boards due to their having a different
clock.

Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/serial/Kconfig    |    9 +
 drivers/tty/serial/pch_uart.c |  160 +++++++++++++++++++++++++++++++-
 2 files changed, 168 insertions(+), 1 deletion(-)

diff -puN drivers/tty/serial/Kconfig~drivers-tty-serial-pch_uartc-add-console-support drivers/tty/serial/Kconfig
--- a/drivers/tty/serial/Kconfig~drivers-tty-serial-pch_uartc-add-console-support
+++ a/drivers/tty/serial/Kconfig
@@ -1585,6 +1585,15 @@ config SERIAL_PCH_UART
 	  ML7213/ML7223 is companion chip for Intel Atom E6xx series.
 	  ML7213/ML7223 is completely compatible for Intel EG20T PCH.
 
+config SERIAL_PCH_UART_CONSOLE
+	bool "Support for console on Intel EG20T PCH UART/OKI SEMICONDUCTOR ML7213 IOH"
+	depends on SERIAL_PCH_UART=y
+	select SERIAL_CORE_CONSOLE
+	help
+	  Say Y here if you wish to use the PCH UART as the system console
+	  (the system  console is the device which receives all kernel messages and
+	  warnings and which allows logins in single user mode).
+
 config SERIAL_MSM_SMD
 	bool "Enable tty device interface for some SMD ports"
 	default n
diff -puN drivers/tty/serial/pch_uart.c~drivers-tty-serial-pch_uartc-add-console-support drivers/tty/serial/pch_uart.c
--- a/drivers/tty/serial/pch_uart.c~drivers-tty-serial-pch_uartc-add-console-support
+++ a/drivers/tty/serial/pch_uart.c
@@ -23,6 +23,9 @@
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/dmi.h>
+#include <linux/console.h>
+#include <linux/nmi.h>
+#include <linux/delay.h>
 
 #include <linux/dmaengine.h>
 #include <linux/pch_dma.h>
@@ -196,6 +199,10 @@ enum {
 
 #define PCI_VENDOR_ID_ROHM		0x10DB
 
+#define BOTH_EMPTY (UART_LSR_TEMT | UART_LSR_THRE)
+
+#define DEFAULT_BAUD_RATE 1843200 /* 1.8432MHz */
+
 struct pch_uart_buffer {
 	unsigned char *buf;
 	int size;
@@ -270,6 +277,9 @@ static struct pch_uart_driver_data drv_d
 	[pch_ml7223_uart1] = {PCH_UART_2LINE, 1},
 };
 
+#ifdef CONFIG_SERIAL_PCH_UART_CONSOLE
+static struct eg20t_port *pch_uart_ports[PCH_UART_NR];
+#endif
 static unsigned int default_baud = 9600;
 static const int trigger_level_256[4] = { 1, 64, 128, 224 };
 static const int trigger_level_64[4] = { 1, 16, 32, 56 };
@@ -1378,6 +1388,143 @@ static struct uart_ops pch_uart_ops = {
 	.verify_port = pch_uart_verify_port
 };
 
+#ifdef CONFIG_SERIAL_PCH_UART_CONSOLE
+
+/*
+ *	Wait for transmitter & holding register to empty
+ */
+static void wait_for_xmitr(struct eg20t_port *up, int bits)
+{
+	unsigned int status, tmout = 10000;
+
+	/* Wait up to 10ms for the character(s) to be sent. */
+	for (;;) {
+		status = ioread8(up->membase + UART_LSR);
+
+		if ((status & bits) == bits)
+			break;
+		if (--tmout == 0)
+			break;
+		udelay(1);
+	}
+
+	/* Wait up to 1s for flow control if necessary */
+	if (up->port.flags & UPF_CONS_FLOW) {
+		unsigned int tmout;
+		for (tmout = 1000000; tmout; tmout--) {
+			unsigned int msr = ioread8(up->membase + UART_MSR);
+			if (msr & UART_MSR_CTS)
+				break;
+			udelay(1);
+			touch_nmi_watchdog();
+		}
+	}
+}
+
+static void pch_console_putchar(struct uart_port *port, int ch)
+{
+	struct eg20t_port *priv =
+		container_of(port, struct eg20t_port, port);
+
+	wait_for_xmitr(priv, UART_LSR_THRE);
+	iowrite8(ch, priv->membase + PCH_UART_THR);
+}
+
+/*
+ *	Print a string to the serial port trying not to disturb
+ *	any possible real use of the port...
+ *
+ *	The console_lock must be held when we get here.
+ */
+static void
+pch_console_write(struct console *co, const char *s, unsigned int count)
+{
+	struct eg20t_port *priv;
+
+	unsigned long flags;
+	u8 ier;
+	int locked = 1;
+
+	priv = pch_uart_ports[co->index];
+
+	touch_nmi_watchdog();
+
+	local_irq_save(flags);
+	if (priv->port.sysrq) {
+		/* serial8250_handle_port() already took the lock */
+		locked = 0;
+	} else if (oops_in_progress) {
+		locked = spin_trylock(&priv->port.lock);
+	} else
+		spin_lock(&priv->port.lock);
+
+	/*
+	 *	First save the IER then disable the interrupts
+	 */
+	ier = ioread8(priv->membase + UART_IER);
+
+	pch_uart_hal_disable_interrupt(priv, PCH_UART_HAL_ALL_INT);
+
+	uart_console_write(&priv->port, s, count, pch_console_putchar);
+
+	/*
+	 *	Finally, wait for transmitter to become empty
+	 *	and restore the IER
+	 */
+	wait_for_xmitr(priv, BOTH_EMPTY);
+	iowrite8(ier, priv->membase + UART_IER);
+
+	if (locked)
+		spin_unlock(&priv->port.lock);
+	local_irq_restore(flags);
+}
+
+static int __init pch_console_setup(struct console *co, char *options)
+{
+	struct uart_port *port;
+	int baud = 9600;
+	int bits = 8;
+	int parity = 'n';
+	int flow = 'n';
+
+	/*
+	 * Check whether an invalid uart number has been specified, and
+	 * if so, search for the first available port that does have
+	 * console support.
+	 */
+	if (co->index >= PCH_UART_NR)
+		co->index = 0;
+	port = &pch_uart_ports[co->index]->port;
+
+	if (!port || (!port->iobase && !port->membase))
+		return -ENODEV;
+
+	/* setup uartclock */
+	port->uartclk = DEFAULT_BAUD_RATE;
+
+	if (options)
+		uart_parse_options(options, &baud, &parity, &bits, &flow);
+
+	return uart_set_options(port, co, baud, parity, bits, flow);
+}
+
+static struct uart_driver pch_uart_driver;
+
+static struct console pch_console = {
+	.name		= PCH_UART_DRIVER_DEVICE,
+	.write		= pch_console_write,
+	.device		= uart_console_device,
+	.setup		= pch_console_setup,
+	.flags		= CON_PRINTBUFFER | CON_ANYTIME,
+	.index		= -1,
+	.data		= &pch_uart_driver,
+};
+
+#define PCH_CONSOLE	(&pch_console)
+#else
+#define PCH_CONSOLE	NULL
+#endif
+
 static struct uart_driver pch_uart_driver = {
 	.owner = THIS_MODULE,
 	.driver_name = KBUILD_MODNAME,
@@ -1385,6 +1532,7 @@ static struct uart_driver pch_uart_drive
 	.major = 0,
 	.minor = 0,
 	.nr = PCH_UART_NR,
+	.cons = PCH_CONSOLE,
 };
 
 static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
@@ -1411,7 +1559,7 @@ static struct eg20t_port *pch_uart_init_
 	if (!rxbuf)
 		goto init_port_free_txbuf;
 
-	base_baud = 1843200; /* 1.8432MHz */
+	base_baud = DEFAULT_BAUD_RATE;
 
 	/* quirk for CM-iTC board */
 	board_name = dmi_get_system_info(DMI_BOARD_NAME);
@@ -1461,6 +1609,9 @@ static struct eg20t_port *pch_uart_init_
 	pci_set_drvdata(pdev, priv);
 	pch_uart_hal_request(pdev, fifosize, base_baud);
 
+#ifdef CONFIG_SERIAL_PCH_UART_CONSOLE
+	pch_uart_ports[board->line_no] = priv;
+#endif
 	ret = uart_add_one_port(&pch_uart_driver, &priv->port);
 	if (ret < 0)
 		goto init_port_hal_free;
@@ -1468,6 +1619,9 @@ static struct eg20t_port *pch_uart_init_
 	return priv;
 
 init_port_hal_free:
+#ifdef CONFIG_SERIAL_PCH_UART_CONSOLE
+	pch_uart_ports[board->line_no] = NULL;
+#endif
 	free_page((unsigned long)rxbuf);
 init_port_free_txbuf:
 	kfree(priv);
@@ -1490,6 +1644,10 @@ static void pch_uart_pci_remove(struct p
 	priv = (struct eg20t_port *)pci_get_drvdata(pdev);
 
 	pci_disable_msi(pdev);
+
+#ifdef CONFIG_SERIAL_PCH_UART_CONSOLE
+	pch_uart_ports[priv->port.line] = NULL;
+#endif
 	pch_uart_exit_port(priv);
 	pci_disable_device(pdev);
 	kfree(priv);
_

Patches currently in -mm which might be from alexander.stein@systec-electronic.com are

drivers-tty-serial-pch_uartc-add-console-support.patch

