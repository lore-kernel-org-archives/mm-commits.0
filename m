From: akpm@linux-foundation.org
Subject: - serial_txx9-use-upf_fixed_port.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:30:03 -0700
Message-ID: <200710162030.l9GKU3lT014372@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51182 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934704AbXJPUaJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 16:30:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, mm-commits@vger.kernel.org


The patch titled
     serial_txx9: Use UPF_FIXED_PORT
has been removed from the -mm tree.  Its filename was
     serial_txx9-use-upf_fixed_port.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: serial_txx9: Use UPF_FIXED_PORT
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

The UPF_FIXED_PORT flags was introduced in 2.6.22 and it can be used
instead of the driver specific verify_port routine.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_txx9.c |   26 +++++---------------------
 1 file changed, 5 insertions(+), 21 deletions(-)

diff -puN drivers/serial/serial_txx9.c~serial_txx9-use-upf_fixed_port drivers/serial/serial_txx9.c
--- a/drivers/serial/serial_txx9.c~serial_txx9-use-upf_fixed_port
+++ a/drivers/serial/serial_txx9.c
@@ -33,7 +33,7 @@
 
 #include <asm/io.h>
 
-static char *serial_version = "1.10";
+static char *serial_version = "1.11";
 static char *serial_name = "TX39/49 Serial driver";
 
 #define PASS_LIMIT	256
@@ -64,8 +64,6 @@ static char *serial_name = "TX39/49 Seri
  */
 #define UART_NR  CONFIG_SERIAL_TXX9_NR_UARTS
 
-#define HIGH_BITS_OFFSET	((sizeof(long)-sizeof(int))*8)
-
 struct uart_txx9_port {
 	struct uart_port	port;
 	/* No additional info for now */
@@ -752,21 +750,6 @@ static void serial_txx9_config_port(stru
 	serial_txx9_initialize(port);
 }
 
-static int
-serial_txx9_verify_port(struct uart_port *port, struct serial_struct *ser)
-{
-	unsigned long new_port = ser->port;
-	if (HIGH_BITS_OFFSET)
-		new_port += (unsigned long)ser->port_high << HIGH_BITS_OFFSET;
-	if (ser->type != port->type ||
-	    ser->irq != port->irq ||
-	    ser->io_type != port->iotype ||
-	    new_port != port->iobase ||
-	    (unsigned long)ser->iomem_base != port->mapbase)
-		return -EINVAL;
-	return 0;
-}
-
 static const char *
 serial_txx9_type(struct uart_port *port)
 {
@@ -790,7 +773,6 @@ static struct uart_ops serial_txx9_pops 
 	.release_port	= serial_txx9_release_port,
 	.request_port	= serial_txx9_request_port,
 	.config_port	= serial_txx9_config_port,
-	.verify_port	= serial_txx9_verify_port,
 };
 
 static struct uart_txx9_port serial_txx9_ports[UART_NR];
@@ -946,7 +928,8 @@ int __init early_serial_txx9_setup(struc
 
 	serial_txx9_ports[port->line].port = *port;
 	serial_txx9_ports[port->line].port.ops = &serial_txx9_pops;
-	serial_txx9_ports[port->line].port.flags |= UPF_BOOT_AUTOCONF;
+	serial_txx9_ports[port->line].port.flags |=
+		UPF_BOOT_AUTOCONF | UPF_FIXED_PORT;
 	return 0;
 }
 
@@ -991,7 +974,8 @@ static int __devinit serial_txx9_registe
 		uart->port.irq      = port->irq;
 		uart->port.uartclk  = port->uartclk;
 		uart->port.iotype   = port->iotype;
-		uart->port.flags    = port->flags | UPF_BOOT_AUTOCONF;
+		uart->port.flags    = port->flags
+			| UPF_BOOT_AUTOCONF | UPF_FIXED_PORT;
 		uart->port.mapbase  = port->mapbase;
 		if (port->dev)
 			uart->port.dev = port->dev;
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
