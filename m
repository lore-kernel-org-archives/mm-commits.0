From: akpm@linux-foundation.org
Subject: + 8250c-support-specifying-dw-apb-uarts-in-device-platform_data.patch added to -mm tree
Date: Fri, 04 Jan 2008 22:52:17 -0800
Message-ID: <200801050653.m056r3at032596@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52841 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751770AbYAEGxt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 5 Jan 2008 01:53:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: will.newton@gmail.com, alan@lxorguk.ukuu.org.uk, rmk@arm.linux.org.uk


The patch titled
     8250.c: support specifying DW APB UARTs in device platform_data
has been added to the -mm tree.  Its filename is
     8250c-support-specifying-dw-apb-uarts-in-device-platform_data.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: 8250.c: support specifying DW APB UARTs in device platform_data
From: "Will Newton" <will.newton@gmail.com>

Allow the private_data field to be specified in platform_data for the
standard 8250/16550 UART.  This field is used by DW APB type UARTs and
without this patch it's only possible to set this field when registering
the port by hand.  If private_data is not set then the driver will
potentially oops with a NULL pointer dereference.

Signed-off-by: Will Newton <will.newton@gmail.com>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c       |   40 +++++++++++++++++-----------------
 include/linux/serial_8250.h |    1 
 2 files changed, 22 insertions(+), 19 deletions(-)

diff -puN drivers/serial/8250.c~8250c-support-specifying-dw-apb-uarts-in-device-platform_data drivers/serial/8250.c
--- a/drivers/serial/8250.c~8250c-support-specifying-dw-apb-uarts-in-device-platform_data
+++ a/drivers/serial/8250.c
@@ -2662,16 +2662,17 @@ static int __devinit serial8250_probe(st
 	memset(&port, 0, sizeof(struct uart_port));
 
 	for (i = 0; p && p->flags != 0; p++, i++) {
-		port.iobase	= p->iobase;
-		port.membase	= p->membase;
-		port.irq	= p->irq;
-		port.uartclk	= p->uartclk;
-		port.regshift	= p->regshift;
-		port.iotype	= p->iotype;
-		port.flags	= p->flags;
-		port.mapbase	= p->mapbase;
-		port.hub6	= p->hub6;
-		port.dev	= &dev->dev;
+		port.iobase		= p->iobase;
+		port.membase		= p->membase;
+		port.irq		= p->irq;
+		port.uartclk		= p->uartclk;
+		port.regshift		= p->regshift;
+		port.iotype		= p->iotype;
+		port.flags		= p->flags;
+		port.mapbase		= p->mapbase;
+		port.hub6		= p->hub6;
+		port.private_data	= p->private_data;
+		port.dev		= &dev->dev;
 		if (share_irqs)
 			port.flags |= UPF_SHARE_IRQ;
 		ret = serial8250_register_port(&port);
@@ -2812,15 +2813,16 @@ int serial8250_register_port(struct uart
 	if (uart) {
 		uart_remove_one_port(&serial8250_reg, &uart->port);
 
-		uart->port.iobase   = port->iobase;
-		uart->port.membase  = port->membase;
-		uart->port.irq      = port->irq;
-		uart->port.uartclk  = port->uartclk;
-		uart->port.fifosize = port->fifosize;
-		uart->port.regshift = port->regshift;
-		uart->port.iotype   = port->iotype;
-		uart->port.flags    = port->flags | UPF_BOOT_AUTOCONF;
-		uart->port.mapbase  = port->mapbase;
+		uart->port.iobase       = port->iobase;
+		uart->port.membase      = port->membase;
+		uart->port.irq          = port->irq;
+		uart->port.uartclk      = port->uartclk;
+		uart->port.fifosize     = port->fifosize;
+		uart->port.regshift     = port->regshift;
+		uart->port.iotype       = port->iotype;
+		uart->port.flags        = port->flags | UPF_BOOT_AUTOCONF;
+		uart->port.mapbase      = port->mapbase;
+		uart->port.private_data = port->private_data;
 		if (port->dev)
 			uart->port.dev = port->dev;
 
diff -puN include/linux/serial_8250.h~8250c-support-specifying-dw-apb-uarts-in-device-platform_data include/linux/serial_8250.h
--- a/include/linux/serial_8250.h~8250c-support-specifying-dw-apb-uarts-in-device-platform_data
+++ a/include/linux/serial_8250.h
@@ -23,6 +23,7 @@ struct plat_serial8250_port {
 	resource_size_t	mapbase;	/* resource base */
 	unsigned int	irq;		/* interrupt number */
 	unsigned int	uartclk;	/* UART clock rate */
+	void            *private_data;
 	unsigned char	regshift;	/* register shift */
 	unsigned char	iotype;		/* UPIO_* */
 	unsigned char	hub6;
_

Patches currently in -mm which might be from will.newton@gmail.com are

8250c-support-specifying-dw-apb-uarts-in-device-platform_data.patch
