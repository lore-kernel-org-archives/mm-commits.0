From: akpm@linux-foundation.org
Subject: + serial-mmio32-support-for-8250_earlyc.patch added to -mm tree
Date: Wed, 30 Jun 2010 15:25:16 -0700
Message-ID: <201006302225.o5UMPGQL030079@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757252Ab0F3WZV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jun 2010 18:25:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: _deepfire@feelingofgreen.ru, greg@kroah.com


The patch titled
     serial: MMIO32 support for 8250_early.c
has been added to the -mm tree.  Its filename is
     serial-mmio32-support-for-8250_earlyc.patch

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
Subject: serial: MMIO32 support for 8250_early.c
From: Samium Gromoff <_deepfire@feelingofgreen.ru>

Provide MMIO32 support in 8250_early (aka earlycon)

Signed-off-by: Samium Gromoff <_deepfire@feelingofgreen.ru>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    3 +
 drivers/serial/8250_early.c         |   53 ++++++++++++++++++--------
 2 files changed, 41 insertions(+), 15 deletions(-)

diff -puN Documentation/kernel-parameters.txt~serial-mmio32-support-for-8250_earlyc Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~serial-mmio32-support-for-8250_earlyc
+++ a/Documentation/kernel-parameters.txt
@@ -680,8 +680,11 @@ and is between 256 and 4096 characters. 
 	earlycon=	[KNL] Output early console device and options.
 		uart[8250],io,<addr>[,options]
 		uart[8250],mmio,<addr>[,options]
+		uart[8250],mmio32,<addr>[,options]
 			Start an early, polled-mode console on the 8250/16550
 			UART at the specified I/O port or MMIO address.
+			MMIO inter-register address stride is either 8bit (mmio)
+                        or 32bit (mmio32).
 			The options are the same as for ttyS, above.
 
 	earlyprintk=	[X86,SH,BLACKFIN]
diff -puN drivers/serial/8250_early.c~serial-mmio32-support-for-8250_earlyc drivers/serial/8250_early.c
--- a/drivers/serial/8250_early.c~serial-mmio32-support-for-8250_earlyc
+++ a/drivers/serial/8250_early.c
@@ -19,9 +19,11 @@
  * The user can specify the device directly, e.g.,
  *	earlycon=uart8250,io,0x3f8,9600n8
  *	earlycon=uart8250,mmio,0xff5e0000,115200n8
+ *	earlycon=uart8250,mmio32,0xff5e0000,115200n8
  * or
  *	console=uart8250,io,0x3f8,9600n8
  *	console=uart8250,mmio,0xff5e0000,115200n8
+ *	console=uart8250,mmio32,0xff5e0000,115200n8
  */
 
 #include <linux/tty.h>
@@ -48,18 +50,31 @@ static struct early_serial8250_device ea
 
 static unsigned int __init serial_in(struct uart_port *port, int offset)
 {
-	if (port->iotype == UPIO_MEM)
+	switch (port->iotype) {
+	case UPIO_MEM:
 		return readb(port->membase + offset);
-	else
+	case UPIO_MEM32:
+		return readl(port->membase + (offset << 2));
+	case UPIO_PORT:
 		return inb(port->iobase + offset);
+	default:
+		return 0;
+	}
 }
 
 static void __init serial_out(struct uart_port *port, int offset, int value)
 {
-	if (port->iotype == UPIO_MEM)
+	switch (port->iotype) {
+	case UPIO_MEM:
 		writeb(value, port->membase + offset);
-	else
+		break;
+	case UPIO_MEM32:
+		writel(value, port->membase + (offset << 2));
+		break;
+	case UPIO_PORT:
 		outb(value, port->iobase + offset);
+		break;
+	}
 }
 
 #define BOTH_EMPTY (UART_LSR_TEMT | UART_LSR_THRE)
@@ -137,15 +152,21 @@ static int __init parse_options(struct e
 								char *options)
 {
 	struct uart_port *port = &device->port;
-	int mmio, length;
+	int mmio, mmio32, length;
 
 	if (!options)
 		return -ENODEV;
 
 	port->uartclk = BASE_BAUD * 16;
-	if (!strncmp(options, "mmio,", 5)) {
-		port->iotype = UPIO_MEM;
-		port->mapbase = simple_strtoul(options + 5, &options, 0);
+
+	mmio = !strncmp(options, "mmio,", 5);
+	mmio32 = !strncmp(options, "mmio32,", 7);
+	if (mmio || mmio32) {
+		port->iotype = (mmio ? UPIO_MEM : UPIO_MEM32);
+		port->mapbase = simple_strtoul(options + (mmio ? 5 : 7),
+					       &options, 0);
+		if (mmio32)
+			port->regshift = 2;
 #ifdef CONFIG_FIX_EARLYCON_MEM
 		set_fixmap_nocache(FIX_EARLYCON_MEM_BASE,
 					port->mapbase & PAGE_MASK);
@@ -157,11 +178,10 @@ static int __init parse_options(struct e
 		if (!port->membase) {
 			printk(KERN_ERR "%s: Couldn't ioremap 0x%llx\n",
 				__func__,
-			       (unsigned long long)port->mapbase);
+			       (unsigned long long) port->mapbase);
 			return -ENOMEM;
 		}
 #endif
-		mmio = 1;
 	} else if (!strncmp(options, "io,", 3)) {
 		port->iotype = UPIO_PORT;
 		port->iobase = simple_strtoul(options + 3, &options, 0);
@@ -181,11 +201,14 @@ static int __init parse_options(struct e
 			device->baud);
 	}
 
-	printk(KERN_INFO "Early serial console at %s 0x%llx (options '%s')\n",
-		mmio ? "MMIO" : "I/O port",
-		mmio ? (unsigned long long) port->mapbase
-		     : (unsigned long long) port->iobase,
-		device->options);
+	if (mmio || mmio32)
+		printk(KERN_INFO "Early serial console at MMIO%s 0x%p (options '%s')\n",
+		       mmio32 ? "32" : "", (unsigned long long) port->mapbase,
+		       device->options);
+	else
+		printk(KERN_INFO "Early serial console at I/O port 0x%pr (options '%s')\n",
+		       (unsigned long long) port->iobase, device->options);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from _deepfire@feelingofgreen.ru are

serial-mmio32-support-for-8250_earlyc.patch

