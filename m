From: akpm@linux-foundation.org
Subject: + use-resource_size_t-for-serial-port-io-addresses.patch added to -mm tree
Date: Fri, 13 Jul 2007 12:02:32 -0700
Message-ID: <200707131902.l6DJ2WTW012978@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58042 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757364AbXGMTDe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 15:03:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jwboyer@linux.vnet.ibm.com, dwg@au1.ibm.com, paulus@samba.org, rmk@arm.linux.org.uk


The patch titled
     Use resource_size_t for serial port IO addresses
has been added to the -mm tree.  Its filename is
     use-resource_size_t-for-serial-port-io-addresses.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c        |    5 +++--
 drivers/serial/8250_early.c  |   16 +++++++++-------
 drivers/serial/serial_core.c |    9 +++++----
 include/linux/serial_8250.h  |    2 +-
 include/linux/serial_core.h  |    2 +-
 5 files changed, 19 insertions(+), 15 deletions(-)

diff -puN drivers/serial/8250.c~use-resource_size_t-for-serial-port-io-addresses drivers/serial/8250.c
--- a/drivers/serial/8250.c~use-resource_size_t-for-serial-port-io-addresses
+++ a/drivers/serial/8250.c
@@ -2664,8 +2664,9 @@ static int __devinit serial8250_probe(st
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
@@ -145,8 +145,9 @@ static int __init parse_options(struct e
 		port->mapbase = simple_strtoul(options + 5, &options, 0);
 		port->membase = ioremap(port->mapbase, mapsize);
 		if (!port->membase) {
-			printk(KERN_ERR "%s: Couldn't ioremap 0x%lx\n",
-				__FUNCTION__, port->mapbase);
+			printk(KERN_ERR "%s: Couldn't ioremap 0x%llx\n",
+				__FUNCTION__,
+			       (unsigned long long)port->mapbase);
 			return -ENOMEM;
 		}
 		mmio = 1;
@@ -168,9 +169,10 @@ static int __init parse_options(struct e
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
@@ -236,10 +238,10 @@ static int __init early_uart_console_swi
 	mmio = (port->iotype == UPIO_MEM);
 	line = serial8250_start_console(port, device->options);
 	if (line < 0)
-		printk("No ttyS device at %s 0x%lx for console\n",
+		printk("No ttyS device at %s 0x%llx for console\n",
 			mmio ? "MMIO" : "I/O port",
-			mmio ? port->mapbase :
-			    (unsigned long) port->iobase);
+			mmio ? (unsigned long long) port->mapbase
+		             : (unsigned long long) port->iobase);
 
 	unregister_console(&early_uart_console);
 	if (mmio)
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
@@ -1669,10 +1669,11 @@ static int uart_line_info(char *buf, str
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
@@ -2072,7 +2073,7 @@ uart_report_port(struct uart_driver *drv
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
@@ -284,7 +284,7 @@ struct uart_port {
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

git-powerpc.patch
git-ubi.patch
use-resource_size_t-for-serial-port-io-addresses.patch
