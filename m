From: akpm@linux-foundation.org
Subject: - 8250_early-coding-style.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:12:52 -0800
Message-ID: <200802082012.m18KCXaJ010211@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47796 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753723AbYBHUv5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:51:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     8250_early: coding style
has been removed from the -mm tree.  Its filename was
     8250_early-coding-style.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: 8250_early: coding style
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_early.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff -puN drivers/serial/8250_early.c~8250_early-coding-style drivers/serial/8250_early.c
--- a/drivers/serial/8250_early.c~8250_early-coding-style
+++ a/drivers/serial/8250_early.c
@@ -82,7 +82,8 @@ static void __init serial_putc(struct ua
 	serial_out(port, UART_TX, c);
 }
 
-static void __init early_serial8250_write(struct console *console, const char *s, unsigned int count)
+static void __init early_serial8250_write(struct console *console,
+					const char *s, unsigned int count)
 {
 	struct uart_port *port = &early_device.port;
 	unsigned int ier;
@@ -132,7 +133,8 @@ static void __init init_port(struct earl
 	serial_out(port, UART_LCR, c & ~UART_LCR_DLAB);
 }
 
-static int __init parse_options(struct early_serial8250_device *device, char *options)
+static int __init parse_options(struct early_serial8250_device *device,
+								char *options)
 {
 	struct uart_port *port = &device->port;
 	int mmio, length;
@@ -145,8 +147,10 @@ static int __init parse_options(struct e
 		port->iotype = UPIO_MEM;
 		port->mapbase = simple_strtoul(options + 5, &options, 0);
 #ifdef CONFIG_FIX_EARLYCON_MEM
-		set_fixmap_nocache(FIX_EARLYCON_MEM_BASE, port->mapbase & PAGE_MASK);
-		port->membase = (void __iomem *)__fix_to_virt(FIX_EARLYCON_MEM_BASE);
+		set_fixmap_nocache(FIX_EARLYCON_MEM_BASE,
+					port->mapbase & PAGE_MASK);
+		port->membase =
+			(void __iomem *)__fix_to_virt(FIX_EARLYCON_MEM_BASE);
 		port->membase += port->mapbase & ~PAGE_MASK;
 #else
 		port->membase = ioremap(port->mapbase, 64);
@@ -165,7 +169,8 @@ static int __init parse_options(struct e
 	} else
 		return -EINVAL;
 
-	if ((options = strchr(options, ','))) {
+	options = strchr(options, ',');
+	if (options) {
 		options++;
 		device->baud = simple_strtoul(options, NULL, 0);
 		length = min(strcspn(options, " "), sizeof(device->options));
@@ -179,7 +184,7 @@ static int __init parse_options(struct e
 	printk(KERN_INFO "Early serial console at %s 0x%llx (options '%s')\n",
 		mmio ? "MMIO" : "I/O port",
 		mmio ? (unsigned long long) port->mapbase
-	             : (unsigned long long) port->iobase,
+		     : (unsigned long long) port->iobase,
 		device->options);
 	return 0;
 }
@@ -199,7 +204,8 @@ static int __init early_serial8250_setup
 	if (device->port.membase || device->port.iobase)
 		return 0;
 
-	if ((err = parse_options(device, options)) < 0)
+	err = parse_options(device, options);
+	if (err < 0)
 		return err;
 
 	init_port(device);
@@ -219,7 +225,8 @@ int __init setup_early_serial8250_consol
 	}
 
 	options = strchr(cmdline, ',') + 1;
-	if ((err = early_serial8250_setup(options)) < 0)
+	err = early_serial8250_setup(options);
+	if (err < 0)
 		return err;
 
 	register_console(&early_serial8250_console);
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
hci_ldisc-fix-null-pointer-deref.patch
parisc-new-termios-definitions.patch
git-sh.patch
git-watchdog.patch
