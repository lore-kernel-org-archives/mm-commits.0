From: akpm@linux-foundation.org
Subject: [merged] serial-copy-uart-properties-of-upf_fixed_type-ports-provisioned-using-early_serial_setup.patch removed from -mm tree
Date: Tue, 29 Dec 2009 13:32:28 -0800
Message-ID: <200912292132.nBTLWSqh008630@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37326 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752777AbZL2Vcw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Dec 2009 16:32:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shmulik@jungo.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     serial: copy UART properties of UPF_FIXED_TYPE ports provisioned using early_serial_setup
has been removed from the -mm tree.  Its filename was
     serial-copy-uart-properties-of-upf_fixed_type-ports-provisioned-using-early_serial_setup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: copy UART properties of UPF_FIXED_TYPE ports provisioned using early_serial_setup
From: Shmulik Ladkani <shmulik@jungo.com>

Augment the UPF_FIXED_TYPE logic, which currently applies to UART ports
provisioned using platform_device_register.

The suggested patch applies same logic into 'serial8250_register_ports',
making UART ports provisioned using early_serial_setup inherit their
properties from the uart_config entry.

Signed-off-by: Shmulik Ladkani <shmulik@jungo.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff -puN drivers/serial/8250.c~serial-copy-uart-properties-of-upf_fixed_type-ports-provisioned-using-early_serial_setup drivers/serial/8250.c
--- a/drivers/serial/8250.c~serial-copy-uart-properties-of-upf_fixed_type-ports-provisioned-using-early_serial_setup
+++ a/drivers/serial/8250.c
@@ -2689,6 +2689,15 @@ static void __init serial8250_isa_init_p
 	}
 }
 
+static void
+serial8250_init_fixed_type_port(struct uart_8250_port *up, unsigned int type)
+{
+	up->port.type = type;
+	up->port.fifosize = uart_config[type].fifo_size;
+	up->capabilities = uart_config[type].flags;
+	up->tx_loadsz = uart_config[type].tx_loadsz;
+}
+
 static void __init
 serial8250_register_ports(struct uart_driver *drv, struct device *dev)
 {
@@ -2705,6 +2714,10 @@ serial8250_register_ports(struct uart_dr
 		struct uart_8250_port *up = &serial8250_ports[i];
 
 		up->port.dev = dev;
+
+		if (up->port.flags & UPF_FIXED_TYPE)
+			serial8250_init_fixed_type_port(up, up->port.type);
+
 		uart_add_one_port(drv, &up->port);
 	}
 }
@@ -3117,12 +3130,8 @@ int serial8250_register_port(struct uart
 		if (port->dev)
 			uart->port.dev = port->dev;
 
-		if (port->flags & UPF_FIXED_TYPE) {
-			uart->port.type = port->type;
-			uart->port.fifosize = uart_config[port->type].fifo_size;
-			uart->capabilities = uart_config[port->type].flags;
-			uart->tx_loadsz = uart_config[port->type].tx_loadsz;
-		}
+		if (port->flags & UPF_FIXED_TYPE)
+			serial8250_init_fixed_type_port(uart, port->type);
 
 		set_io_from_upio(&uart->port);
 		/* Possibly override default I/O functions.  */
_

Patches currently in -mm which might be from shmulik@jungo.com are

linux-next.patch

