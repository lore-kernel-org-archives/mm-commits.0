From: akpm@linux-foundation.org
Subject: - serial-allow-port-type-to-be-specified-when-calling-serial8250_register_port.patch removed from -mm tree
Date: Tue, 02 Dec 2008 22:56:12 -0800
Message-ID: <200812030656.mB36uC2Q029068@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52364 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752654AbYLCG4O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2008 01:56:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddaney@caviumnetworks.com, mm-commits@vger.kernel.org


The patch titled
     serial: allow port type to be specified when calling serial8250_register_port
has been removed from the -mm tree.  Its filename was
     serial-allow-port-type-to-be-specified-when-calling-serial8250_register_port.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: allow port type to be specified when calling serial8250_register_port
From: David Daney <ddaney@caviumnetworks.com>

Add flag value UPF_FIXED_TYPE which specifies that the UART type is known
and should not be probed.  For this case the UARTs properties are just
copied out of the uart_config entry.

This allows us to keep SOC specific 8250 probe code out of 8250.c.  In
this case we know the serial hardware will not be changing as it is on the
same silicon as the CPU, and we can specify it with certainty in the
board/cpu setup code.

The alternative is to load up 8250.c with a bunch of OCTEON specific
special cases in the probing code.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c        |    9 +++++++++
 drivers/serial/serial_core.c |    7 +++++--
 include/linux/serial_8250.h  |    1 +
 include/linux/serial_core.h  |    2 ++
 4 files changed, 17 insertions(+), 2 deletions(-)

diff -puN drivers/serial/8250.c~serial-allow-port-type-to-be-specified-when-calling-serial8250_register_port drivers/serial/8250.c
--- a/drivers/serial/8250.c~serial-allow-port-type-to-be-specified-when-calling-serial8250_register_port
+++ a/drivers/serial/8250.c
@@ -2903,6 +2903,7 @@ static int __devinit serial8250_probe(st
 		port.mapbase		= p->mapbase;
 		port.hub6		= p->hub6;
 		port.private_data	= p->private_data;
+		port.type		= p->type;
 		port.serial_in		= p->serial_in;
 		port.serial_out		= p->serial_out;
 		port.dev		= &dev->dev;
@@ -3058,6 +3059,14 @@ int serial8250_register_port(struct uart
 		uart->port.private_data = port->private_data;
 		if (port->dev)
 			uart->port.dev = port->dev;
+
+		if (port->flags & UPF_FIXED_TYPE) {
+			uart->port.type = port->type;
+			uart->port.fifosize = uart_config[port->type].fifo_size;
+			uart->capabilities = uart_config[port->type].flags;
+			uart->tx_loadsz = uart_config[port->type].tx_loadsz;
+		}
+
 		set_io_from_upio(&uart->port);
 		/* Possibly override default I/O functions.  */
 		if (port->serial_in)
diff -puN drivers/serial/serial_core.c~serial-allow-port-type-to-be-specified-when-calling-serial8250_register_port drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~serial-allow-port-type-to-be-specified-when-calling-serial8250_register_port
+++ a/drivers/serial/serial_core.c
@@ -2198,11 +2198,14 @@ uart_configure_port(struct uart_driver *
 	 * Now do the auto configuration stuff.  Note that config_port
 	 * is expected to claim the resources and map the port for us.
 	 */
-	flags = UART_CONFIG_TYPE;
+	flags = 0;
 	if (port->flags & UPF_AUTO_IRQ)
 		flags |= UART_CONFIG_IRQ;
 	if (port->flags & UPF_BOOT_AUTOCONF) {
-		port->type = PORT_UNKNOWN;
+		if (!(port->flags & UPF_FIXED_TYPE)) {
+			port->type = PORT_UNKNOWN;
+			flags |= UART_CONFIG_TYPE;
+		}
 		port->ops->config_port(port, flags);
 	}
 
diff -puN include/linux/serial_8250.h~serial-allow-port-type-to-be-specified-when-calling-serial8250_register_port include/linux/serial_8250.h
--- a/include/linux/serial_8250.h~serial-allow-port-type-to-be-specified-when-calling-serial8250_register_port
+++ a/include/linux/serial_8250.h
@@ -28,6 +28,7 @@ struct plat_serial8250_port {
 	unsigned char	iotype;		/* UPIO_* */
 	unsigned char	hub6;
 	upf_t		flags;		/* UPF_* flags */
+	unsigned int	type;		/* If UPF_FIXED_TYPE */
 	unsigned int	(*serial_in)(struct uart_port *, int);
 	void		(*serial_out)(struct uart_port *, int, int);
 };
diff -puN include/linux/serial_core.h~serial-allow-port-type-to-be-specified-when-calling-serial8250_register_port include/linux/serial_core.h
--- a/include/linux/serial_core.h~serial-allow-port-type-to-be-specified-when-calling-serial8250_register_port
+++ a/include/linux/serial_core.h
@@ -296,6 +296,8 @@ struct uart_port {
 #define UPF_MAGIC_MULTIPLIER	((__force upf_t) (1 << 16))
 #define UPF_CONS_FLOW		((__force upf_t) (1 << 23))
 #define UPF_SHARE_IRQ		((__force upf_t) (1 << 24))
+/* The exact UART type is known and should not be probed.  */
+#define UPF_FIXED_TYPE		((__force upf_t) (1 << 27))
 #define UPF_BOOT_AUTOCONF	((__force upf_t) (1 << 28))
 #define UPF_FIXED_PORT		((__force upf_t) (1 << 29))
 #define UPF_DEAD		((__force upf_t) (1 << 30))
_

Patches currently in -mm which might be from ddaney@caviumnetworks.com are

serial-allow-port-type-to-be-specified-when-calling-serial8250_register_port.patch
8250-allow-port-type-to-specify-bugs-that-are-not-probed-for.patch
serial-uart-driver-changes-for-cavium-octeon.patch

