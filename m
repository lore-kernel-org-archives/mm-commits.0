From: akpm@linux-foundation.org
Subject: - use-resource_size_t-for-serial-port-io-addresses.patch removed from -mm tree
Date: Tue, 24 Jul 2007 16:24:19 -0700
Message-ID: <200707242324.l6ONOKYg006262@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37813 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756388AbXGXXYj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2007 19:24:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jwboyer@linux.vnet.ibm.com, dwg@au1.ibm.com, jason.wessel@windriver.com, paulus@samba.org, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Use resource_size_t for serial port IO addresses
has been removed from the -mm tree.  Its filename was
     use-resource_size_t-for-serial-port-io-addresses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use resource_size_t for serial port IO addresses
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>

At present, various parts of the serial code use unsigned long to define
resource addresses.  This is a problem, because some 32-bit platforms have
physical addresses larger than 32-bits, and have mmio serial uarts located
above the 4GB point.

This patch changes the type of mapbase in both struct uart_port and struct
plat_serial8250_port to resource_size_t, which can be configured to be 64
bits on such platforms.  The mapbase in serial_struct can't safely be
changed, because that structure is user visible.

Signed-off-by: David Gibson <dwg@au1.ibm.com>
Signed-off-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c        |    5 +++--
 drivers/serial/8250_early.c  |   10 ++++++----
 drivers/serial/serial_core.c |    9 +++++----
 include/linux/serial_8250.h  |    2 +-
 include/linux/serial_core.h  |    2 +-
 5 files changed, 16 insertions(+), 12 deletions(-)

diff -puN drivers/serial/8250.c~use-resource_size_t-for-serial-port-io-addresses drivers/serial/8250.c
--- a/drivers/serial/8250.c~use-resource_size_t-for-serial-port-io-addresses
+++ a/drivers/serial/8250.c
@@ -2650,8 +2650,9 @@ static int __devinit serial8250_probe(st
 		ret = serial8250_register_port(&port);
 		if (ret < 0) {
 			dev_err(&dev->dev, "unable to register port at index %d "
-				"(IO%lx MEM%lx IRQ%d): %d\n", i,
-				p->iobase, p->mapbase, p->irq, ret);
+				"(IO%lx MEM%llx IRQ%d): %d\n", i,
+				p->iobase, (unsigned long long)p->mapbase,
+				p->irq, ret);
 		}
 	}
 	return 0;
diff -puN drivers/serial/8250_early.c~use-resource_size_t-for-serial-port-io-addresses drivers/serial/8250_early.c
--- a/drivers/serial/8250_early.c~use-resource_size_t-for-serial-port-io-addresses
+++ a/drivers/serial/8250_early.c
@@ -151,8 +151,9 @@ static int __init parse_options(struct e
 #else
 		port->membase = ioremap(port->mapbase, 64);
 		if (!port->membase) {
-			printk(KERN_ERR "%s: Couldn't ioremap 0x%lx\n",
-				__FUNCTION__, port->mapbase);
+			printk(KERN_ERR "%s: Couldn't ioremap 0x%llx\n",
+				__FUNCTION__,
+			       (unsigned long long)port->mapbase);
 			return -ENOMEM;
 		}
 #endif
@@ -175,9 +176,10 @@ static int __init parse_options(struct e
 			device->baud);
 	}
 
-	printk(KERN_INFO "Early serial console at %s 0x%lx (options '%s')\n",
+	printk(KERN_INFO "Early serial console at %s 0x%llx (options '%s')\n",
 		mmio ? "MMIO" : "I/O port",
-		mmio ? port->mapbase : (unsigned long) port->iobase,
+		mmio ? (unsigned long long) port->mapbase
+	             : (unsigned long long) port->iobase,
 		device->options);
 	return 0;
 }
diff -puN drivers/serial/serial_core.c~use-resource_size_t-for-serial-port-io-addresses drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~use-resource_size_t-for-serial-port-io-addresses
+++ a/drivers/serial/serial_core.c
@@ -626,7 +626,7 @@ static int uart_get_info(struct uart_sta
 	tmp.hub6	    = port->hub6;
 	tmp.io_type         = port->iotype;
 	tmp.iomem_reg_shift = port->regshift;
-	tmp.iomem_base      = (void *)port->mapbase;
+	tmp.iomem_base      = (void *)(unsigned long)port->mapbase;
 
 	if (copy_to_user(retinfo, &tmp, sizeof(*retinfo)))
 		return -EFAULT;
@@ -1666,10 +1666,11 @@ static int uart_line_info(char *buf, str
 		return 0;
 
 	mmio = port->iotype >= UPIO_MEM;
-	ret = sprintf(buf, "%d: uart:%s %s%08lX irq:%d",
+	ret = sprintf(buf, "%d: uart:%s %s%08llX irq:%d",
 			port->line, uart_type(port),
 			mmio ? "mmio:0x" : "port:",
-			mmio ? port->mapbase : (unsigned long) port->iobase,
+			mmio ? (unsigned long long)port->mapbase
+		             : (unsigned long long) port->iobase,
 			port->irq);
 
 	if (port->type == PORT_UNKNOWN) {
@@ -2069,7 +2070,7 @@ uart_report_port(struct uart_driver *drv
 	case UPIO_TSI:
 	case UPIO_DWAPB:
 		snprintf(address, sizeof(address),
-			 "MMIO 0x%lx", port->mapbase);
+			 "MMIO 0x%llx", (unsigned long long)port->mapbase);
 		break;
 	default:
 		strlcpy(address, "*unknown*", sizeof(address));
diff -puN include/linux/serial_8250.h~use-resource_size_t-for-serial-port-io-addresses include/linux/serial_8250.h
--- a/include/linux/serial_8250.h~use-resource_size_t-for-serial-port-io-addresses
+++ a/include/linux/serial_8250.h
@@ -20,7 +20,7 @@
 struct plat_serial8250_port {
 	unsigned long	iobase;		/* io base address */
 	void __iomem	*membase;	/* ioremap cookie or NULL */
-	unsigned long	mapbase;	/* resource base */
+	resource_size_t	mapbase;	/* resource base */
 	unsigned int	irq;		/* interrupt number */
 	unsigned int	uartclk;	/* UART clock rate */
 	unsigned char	regshift;	/* register shift */
diff -puN include/linux/serial_core.h~use-resource_size_t-for-serial-port-io-addresses include/linux/serial_core.h
--- a/include/linux/serial_core.h~use-resource_size_t-for-serial-port-io-addresses
+++ a/include/linux/serial_core.h
@@ -288,7 +288,7 @@ struct uart_port {
 	const struct uart_ops	*ops;
 	unsigned int		custom_divisor;
 	unsigned int		line;			/* port index */
-	unsigned long		mapbase;		/* for ioremap */
+	resource_size_t		mapbase;		/* for ioremap */
 	struct device		*dev;			/* parent device */
 	unsigned char		hub6;			/* this should be in the 8250 driver */
 	unsigned char		unused[3];
_

Patches currently in -mm which might be from jwboyer@linux.vnet.ibm.com are

origin.patch
