From: akpm@linux-foundation.org
Subject: + serial-add-support-for-the-cell-network-processor-nwp-device-update.patch added to -mm tree
Date: Tue, 25 Nov 2008 14:26:06 -0800
Message-ID: <200811252226.mAPMQ6pa011267@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56162 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750812AbYKYW0f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Nov 2008 17:26:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@codiert.org, alan@lxorguk.ukuu.org.uk, arnd@arndb.de, david@gibson.dropbear.id.au, jwboyer@linux.vnet.ibm.com


The patch titled
     serial-add-support-for-the-cell-network-processor-nwp-device update
has been added to the -mm tree.  Its filename is
     serial-add-support-for-the-cell-network-processor-nwp-device-update.patch

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
Subject: serial-add-support-for-the-cell-network-processor-nwp-device update
From: Benjamin Krill <ben@codiert.org>

Signed-off-by: Benjamin Krill <ben@codiert.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/Kconfig     |   10 +++-
 drivers/serial/nwpserial.c |   80 ++++++++++++++++++++++++-----------
 drivers/serial/of_serial.c |    3 -
 3 files changed, 68 insertions(+), 25 deletions(-)

diff -puN drivers/serial/Kconfig~serial-add-support-for-the-cell-network-processor-nwp-device-update drivers/serial/Kconfig
--- a/drivers/serial/Kconfig~serial-add-support-for-the-cell-network-processor-nwp-device-update
+++ a/drivers/serial/Kconfig
@@ -1311,7 +1311,15 @@ config SERIAL_OF_PLATFORM_NWPSERIAL
 	select SERIAL_CORE_CONSOLE
 	select SERIAL_CORE
 	help
-	  This driver supports the nwp serial port.
+	  This driver supports the cell network processor nwp serial
+	  device.
+
+config SERIAL_OF_PLATFORM_NWPSERIAL_CONSOLE
+	bool "Console on NWP serial port"
+	depends on SERIAL_OF_PLATFORM_NWPSERIAL=y
+	select SERIAL_CORE_CONSOLE
+	help
+	  Support for Console on the NWP serial ports.
 
 config SERIAL_QE
 	tristate "Freescale QUICC Engine serial port support"
diff -puN drivers/serial/nwpserial.c~serial-add-support-for-the-cell-network-processor-nwp-device-update drivers/serial/nwpserial.c
--- a/drivers/serial/nwpserial.c~serial-add-support-for-the-cell-network-processor-nwp-device-update
+++ a/drivers/serial/nwpserial.c
@@ -9,6 +9,7 @@
  *  2 of the License, or (at your option) any later version.
  *
  */
+#include <linux/init.h>
 #include <linux/console.h>
 #include <linux/serial.h>
 #include <linux/serial_reg.h>
@@ -37,12 +38,27 @@ struct nwpserial_port {
 static DEFINE_MUTEX(nwpserial_mutex);
 static struct nwpserial_port nwpserial_ports[NWPSERIAL_NR];
 
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
 static void nwpserial_console_putchar(struct uart_port *port, int c)
 {
-	struct nwpserial_port *up = container_of(port, struct nwpserial_port, port);
+	struct nwpserial_port *up;
+	up = container_of(port, struct nwpserial_port, port);
 	/* check if tx buffer is full */
-	while ((dcr_read(up->dcr_host, UART_LSR) & UART_LSR_THRE) == 0)
-		cpu_relax();
+	wait_for_bits(up, UART_LSR_THRE);
 	dcr_write(up->dcr_host, UART_TX, c);
 	up->port.icount.tx++;
 }
@@ -85,8 +101,12 @@ static struct console nwpserial_console 
 	.index		= -1,
 	.data		= &nwpserial_reg,
 };
+#define NWPSERIAL_CONSOLE	(&nwpserial_console)
+#else
+#define NWPSERIAL_CONSOLE	NULL
+#endif /* CONFIG_SERIAL_OF_PLATFORM_NWPSERIAL_CONSOLE */
 
-/*******************************************************************************/
+/**************************************************************************/
 
 static int nwpserial_request_port(struct uart_port *port)
 {
@@ -105,7 +125,7 @@ static void nwpserial_config_port(struct
 
 static irqreturn_t nwpserial_interrupt(int irq, void *dev_id)
 {
-	struct nwpserial_port *up = dev_id;//container_of(dev_id, struct nwpserial_port, port);
+	struct nwpserial_port *up = dev_id;
 	struct tty_struct *tty = up->port.info->port.tty;
 	irqreturn_t ret;
 	unsigned int iir;
@@ -137,16 +157,18 @@ out:
 
 static int nwpserial_startup(struct uart_port *port)
 {
-	struct nwpserial_port *up = container_of(port, struct nwpserial_port, port);
+	struct nwpserial_port *up;
 	int err;
 
+	up = container_of(port, struct nwpserial_port, port);
+
 	/* disable flow control by default */
 	up->mcr = dcr_read(up->dcr_host, UART_MCR) & ~UART_MCR_AFE;
 	dcr_write(up->dcr_host, UART_MCR, up->mcr);
 
 	/* register interrupt handler */
 	err = request_irq(up->port.irq, nwpserial_interrupt,
-	                        IRQF_SHARED, "nwpserial", up);
+			IRQF_SHARED, "nwpserial", up);
 	if (err) {
 		free_irq(up->port.irq, port);
 		return err;
@@ -164,7 +186,8 @@ static int nwpserial_startup(struct uart
 
 static void nwpserial_shutdown(struct uart_port *port)
 {
-	struct nwpserial_port *up = container_of(port, struct nwpserial_port, port);
+	struct nwpserial_port *up;
+	up = container_of(port, struct nwpserial_port, port);
 
 	/* disable receiving */
 	up->port.ignore_status_mask |= NWPSERIAL_STATUS_RXVALID;
@@ -177,7 +200,8 @@ static void nwpserial_shutdown(struct ua
 	free_irq(up->port.irq, port);
 }
 
-static int nwpserial_verify_port(struct uart_port *port, struct serial_struct *ser)
+static int nwpserial_verify_port(struct uart_port *port,
+			struct serial_struct *ser)
 {
 	return -EINVAL;
 }
@@ -187,17 +211,23 @@ static const char *nwpserial_type(struct
 	return port->type == PORT_NWPSERIAL ? "nwpserial" : NULL;
 }
 
-static void nwpserial_set_termios(struct uart_port *port, struct ktermios *termios,
-                                struct ktermios *old)
+static void nwpserial_set_termios(struct uart_port *port,
+			struct ktermios *termios, struct ktermios *old)
 {
-	struct nwpserial_port *up = container_of(port, struct nwpserial_port, port);
+	struct nwpserial_port *up;
+	up = container_of(port, struct nwpserial_port, port);
 
-	up->port.read_status_mask = NWPSERIAL_STATUS_RXVALID | NWPSERIAL_STATUS_TXFULL;
+	up->port.read_status_mask = NWPSERIAL_STATUS_RXVALID
+				| NWPSERIAL_STATUS_TXFULL;
 
 	up->port.ignore_status_mask = 0;
 	/* ignore all characters if CREAD is not set */
 	if ((termios->c_cflag & CREAD) == 0)
 		up->port.ignore_status_mask |= NWPSERIAL_STATUS_RXVALID;
+
+	/* Copy back the old hardware settings */
+	if (old)
+		tty_termios_copy_hw(termios, old);
 }
 
 static void nwpserial_break_ctl(struct uart_port *port, int ctl)
@@ -212,7 +242,8 @@ static void nwpserial_enable_ms(struct u
 
 static void nwpserial_stop_rx(struct uart_port *port)
 {
-	struct nwpserial_port *up = container_of(port, struct nwpserial_port, port);
+	struct nwpserial_port *up;
+	up = container_of(port, struct nwpserial_port, port);
 	/* don't forward any more data (like !CREAD) */
 	up->port.ignore_status_mask = NWPSERIAL_STATUS_RXVALID;
 }
@@ -220,16 +251,17 @@ static void nwpserial_stop_rx(struct uar
 static void nwpserial_putchar(struct nwpserial_port *up, unsigned char c)
 {
 	/* check if tx buffer is full */
-	while ((dcr_read(up->dcr_host, UART_LSR) & UART_LSR_THRE) == 0)
-		cpu_relax();
+	wait_for_bits(up, UART_LSR_THRE);
 	dcr_write(up->dcr_host, UART_TX, c);
 	up->port.icount.tx++;
 }
 
 static void nwpserial_start_tx(struct uart_port *port)
 {
-	struct nwpserial_port *up = container_of(port, struct nwpserial_port, port);
-	struct circ_buf *xmit  = &up->port.info->xmit;
+	struct nwpserial_port *up;
+	struct circ_buf *xmit;
+	up = container_of(port, struct nwpserial_port, port);
+	xmit  = &up->port.info->xmit;
 
 	if (port->x_char) {
 		nwpserial_putchar(up, up->port.x_char);
@@ -259,9 +291,10 @@ static void nwpserial_stop_tx(struct uar
 
 static unsigned int nwpserial_tx_empty(struct uart_port *port)
 {
-	struct nwpserial_port *up = container_of(port, struct nwpserial_port, port);
+	struct nwpserial_port *up;
 	unsigned long flags;
 	int ret;
+	up = container_of(port, struct nwpserial_port, port);
 
 	spin_lock_irqsave(&up->port.lock, flags);
 	ret = dcr_read(up->dcr_host, UART_LSR);
@@ -296,11 +329,10 @@ static struct uart_driver nwpserial_reg 
 	.major       = TTY_MAJOR,
 	.minor       = 68,
 	.nr          = NWPSERIAL_NR,
-	.cons        = &nwpserial_console,
+	.cons        = NWPSERIAL_CONSOLE,
 };
 
-int
-nwpserial_register_port(struct uart_port *port)
+int nwpserial_register_port(struct uart_port *port)
 {
 	struct nwpserial_port *up = NULL;
 	int ret = -1;
@@ -368,7 +400,7 @@ nwpserial_register_port(struct uart_port
 
 		up->dcr_host = dcr_map(dn, dcr_base, dcr_len);
 		if (!DCR_MAP_OK(up->dcr_host)) {
-			printk("Cannot map DCR resources for NWPSERIAL");
+			printk(KERN_ERR "Cannot map DCR resources for NWPSERIAL");
 			goto out;
 		}
 	}
@@ -396,6 +428,7 @@ void nwpserial_unregister_port(int line)
 }
 EXPORT_SYMBOL(nwpserial_unregister_port);
 
+#ifdef CONFIG_SERIAL_OF_PLATFORM_NWPSERIAL_CONSOLE
 static int __init nwpserial_console_init(void)
 {
 	struct nwpserial_port *up = NULL;
@@ -441,3 +474,4 @@ static int __init nwpserial_console_init
 	return 0;
 }
 console_initcall(nwpserial_console_init);
+#endif /* CONFIG_SERIAL_OF_PLATFORM_NWPSERIAL_CONSOLE */
diff -puN drivers/serial/of_serial.c~serial-add-support-for-the-cell-network-processor-nwp-device-update drivers/serial/of_serial.c
--- a/drivers/serial/of_serial.c~serial-add-support-for-the-cell-network-processor-nwp-device-update
+++ a/drivers/serial/of_serial.c
@@ -164,7 +164,8 @@ static struct of_device_id __devinitdata
 	{ .type = "serial", .compatible = "ns16550",  .data = (void *)PORT_16550, },
 	{ .type = "serial", .compatible = "ns16750",  .data = (void *)PORT_16750, },
 #ifdef CONFIG_SERIAL_OF_PLATFORM_NWPSERIAL
-	{ .type = "serial", .compatible = "ibm,qpace-nwpserial",  .data = (void *)PORT_NWPSERIAL, },
+	{ .type = "serial", .compatible = "ibm,qpace-nwp-serial",
+					.data = (void *)PORT_NWPSERIAL, },
 #endif
 	{ .type = "serial",			      .data = (void *)PORT_UNKNOWN, },
 	{ /* end of list */ },
_

Patches currently in -mm which might be from ben@codiert.org are

serial-add-support-for-the-cell-network-processor-nwp-device.patch
serial-add-support-for-the-cell-network-processor-nwp-device-update.patch

