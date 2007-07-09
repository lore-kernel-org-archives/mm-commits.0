From: akpm@linux-foundation.org
Subject: - serial-convert-early_uart-to-earlycon-for-8250-fix-3-alias.patch removed from -mm tree
Date: Mon, 09 Jul 2007 13:25:17 -0700
Message-ID: <200707092025.l69KPHtg009248@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39888 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754334AbXGIU0i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 16:26:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yinghai.Lu@Sun.COM, ak@suse.de, apw@shadowen.org, bjorn.helgaas@hp.com, kraxel@suse.de, rmk@arm.linux.org.uk, yinghai.lu@Sun.COM, mm-commits@vger.kernel.org


The patch titled
     serial: convert early_uart to earlycon for 8250 fix 3 alias
has been removed from the -mm tree.  Its filename was
     serial-convert-early_uart-to-earlycon-for-8250-fix-3-alias.patch

This patch was dropped because it was folded into serial-convert-early_uart-to-earlycon-for-8250.patch

------------------------------------------------------
Subject: serial: convert early_uart to earlycon for 8250 fix 3 alias
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

make the console=uart,io,0x3f8,9600n8 like console=uart8250,io,0x3f8,9600
suggested by Andy Whitcroft.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Gerd Hoffmann <kraxel@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    8 ++++----
 drivers/serial/8250_early.c         |   15 ++++++++++++---
 2 files changed, 16 insertions(+), 7 deletions(-)

diff -puN Documentation/kernel-parameters.txt~serial-convert-early_uart-to-earlycon-for-8250-fix-3-alias Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~serial-convert-early_uart-to-earlycon-for-8250-fix-3-alias
+++ a/Documentation/kernel-parameters.txt
@@ -462,16 +462,16 @@ and is between 256 and 4096 characters. 
 			Documentation/networking/netconsole.txt for an
 			alternative.
 
-		uart8250,io,<addr>[,options]
-		uart8250,mmio,<addr>[,options]
+		uart[8250],io,<addr>[,options]
+		uart[8250],mmio,<addr>[,options]
 			Start an early, polled-mode console on the 8250/16550
 			UART at the specified I/O port or MMIO address,
 			switching to the matching ttyS device later.  The
 			options are the same as for ttyS, above.
 
 	earlycon=	[KNL] Output early console device and options.
-		uart8250,io,<addr>[,options]
-		uart8250,mmio,<addr>[,options]
+		uart[8250],io,<addr>[,options]
+		uart[8250],mmio,<addr>[,options]
 			Start an early, polled-mode console on the 8250/16550
 			UART at the specified I/O port or MMIO address.
 			The options are the same as for ttyS, above.
diff -puN drivers/serial/8250_early.c~serial-convert-early_uart-to-earlycon-for-8250-fix-3-alias drivers/serial/8250_early.c
--- a/drivers/serial/8250_early.c~serial-convert-early_uart-to-earlycon-for-8250-fix-3-alias
+++ a/drivers/serial/8250_early.c
@@ -210,8 +210,11 @@ int __init setup_early_serial8250_consol
 	int err;
 
 	options = strstr(cmdline, "uart8250,");
-	if (!options)
-		return 0;
+	if (!options) {
+		options = strstr(cmdline, "uart,");
+		if (!options)
+			return 0;
+	}
 
 	options = strchr(cmdline, ',') + 1;
 	if ((err = early_serial8250_setup(options)) < 0)
@@ -227,6 +230,7 @@ int __init serial8250_find_port_for_earl
 	struct early_serial8250_device *device = &early_device;
 	struct uart_port *port = &device->port;
 	int line;
+	int ret;
 
 	if (!device->port.membase && !device->port.iobase)
 		return -ENODEV;
@@ -235,8 +239,13 @@ int __init serial8250_find_port_for_earl
 	if (line < 0)
 		return -ENODEV;
 
-	return update_console_cmdline("uart", 8250,
+	ret = update_console_cmdline("uart", 8250,
+			     "ttyS", line, device->options);
+	if (ret < 0)
+		ret = update_console_cmdline("uart", 0,
 				     "ttyS", line, device->options);
+
+	return ret;
 }
 
 early_param("earlycon", setup_early_serial8250_console);
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

serial-assert-dtr-for-serial-console-devices.patch
usb-make-the-usb_device-numa_node-to-get-assigned-from.patch
x86-64-disable-the-gart-in-shutdown.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
x86_64-change-_map_single-to-static-in-pci_gartc-etc.patch
x86_64-geode-hw-random-number-generator-depend-on-x86_3.patch
x86_64-get-mp_bus_to_node-as-early.patch
console-more-buf-for-index-parsing.patch
console-console-handover-to-preferred-console.patch
serial-convert-early_uart-to-earlycon-for-8250.patch
serial-convert-early_uart-to-earlycon-for-8250-fix-3-alias.patch
dma-make-dma-pool-to-use-kmalloc_node.patch
