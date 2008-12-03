From: akpm@linux-foundation.org
Subject: - 8250-dont-clobber-spinlocks.patch removed from -mm tree
Date: Tue, 02 Dec 2008 22:56:07 -0800
Message-ID: <200812030656.mB36u7rd029060@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55001 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752584AbYLCG4K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2008 01:56:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddaney@caviumnetworks.com, tpaoletti@caviumnetworks.com, mm-commits@vger.kernel.org


The patch titled
     8250: don't clobber spinlocks
has been removed from the -mm tree.  Its filename was
     8250-dont-clobber-spinlocks.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: 8250: don't clobber spinlocks
From: David Daney <ddaney@caviumnetworks.com>

In serial8250_isa_init_ports(), the port's lock is initialized.  We should
not overwrite it.  In early_serial_setup(), only copy in the fields we
need.  Since the early console code only uses a subset of the fields,
these are sufficient.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Signed-off-by: Tomaso Paoletti <tpaoletti@caviumnetworks.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff -puN drivers/serial/8250.c~8250-dont-clobber-spinlocks drivers/serial/8250.c
--- a/drivers/serial/8250.c~8250-dont-clobber-spinlocks
+++ a/drivers/serial/8250.c
@@ -2752,12 +2752,23 @@ static struct uart_driver serial8250_reg
  */
 int __init early_serial_setup(struct uart_port *port)
 {
+	struct uart_port *p;
+
 	if (port->line >= ARRAY_SIZE(serial8250_ports))
 		return -ENODEV;
 
 	serial8250_isa_init_ports();
-	serial8250_ports[port->line].port	= *port;
-	serial8250_ports[port->line].port.ops	= &serial8250_pops;
+	p = &serial8250_ports[port->line].port;
+	p->iobase       = port->iobase;
+	p->membase      = port->membase;
+	p->irq          = port->irq;
+	p->uartclk      = port->uartclk;
+	p->fifosize     = port->fifosize;
+	p->regshift     = port->regshift;
+	p->iotype       = port->iotype;
+	p->flags        = port->flags;
+	p->mapbase      = port->mapbase;
+	p->private_data = port->private_data;
 	return 0;
 }
 
_

Patches currently in -mm which might be from ddaney@caviumnetworks.com are

8250-dont-clobber-spinlocks.patch
8250-serial-driver-changes-to-support-future-cavium-octeon-serial-patches.patch
serial-allow-port-type-to-be-specified-when-calling-serial8250_register_port.patch
8250-allow-port-type-to-specify-bugs-that-are-not-probed-for.patch
serial-uart-driver-changes-for-cavium-octeon.patch

