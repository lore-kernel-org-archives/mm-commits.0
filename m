From: akpm@linux-foundation.org
Subject: - serial-convert-early_uart-to-earlycon-for-8250-fix.patch removed from -mm tree
Date: Mon, 09 Jul 2007 13:25:12 -0700
Message-ID: <200707092025.l69KPCua009240@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50883 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755929AbXGIU0A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 16:26:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yinghai.Lu@Sun.COM, ak@suse.de, bjorn.helgaas@hp.com, kraxel@suse.de, rmk@arm.linux.org.uk, yinghai.lu@Sun.COM, mm-commits@vger.kernel.org


The patch titled
     serial-convert-early_uart-to-earlycon-for-8250 fix
has been removed from the -mm tree.  Its filename was
     serial-convert-early_uart-to-earlycon-for-8250-fix.patch

This patch was dropped because it was folded into serial-convert-early_uart-to-earlycon-for-8250.patch

------------------------------------------------------
Subject: serial-convert-early_uart-to-earlycon-for-8250 fix
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

please use this one instead. it fixs ia64 compilation.

Signed-off-by: <yinghai.lu@sun.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Gerd Hoffmann <kraxel@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/pcdp.c     |    5 +++--
 drivers/serial/8250_early.c |    2 +-
 include/linux/serial_8250.h |    1 +
 3 files changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/firmware/pcdp.c~serial-convert-early_uart-to-earlycon-for-8250-fix drivers/firmware/pcdp.c
--- a/drivers/firmware/pcdp.c~serial-convert-early_uart-to-earlycon-for-8250-fix
+++ a/drivers/firmware/pcdp.c
@@ -15,6 +15,7 @@
 #include <linux/console.h>
 #include <linux/efi.h>
 #include <linux/serial.h>
+#include <linux/serial_8250.h>
 #include <asm/vga.h>
 #include "pcdp.h"
 
@@ -27,7 +28,7 @@ setup_serial_console(struct pcdp_uart *u
 	char parity;
 
 	mmio = (uart->addr.space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY);
-	p += sprintf(p, "console=uart,%s,0x%lx",
+	p += sprintf(p, "uart8250,%s,0x%lx",
 		mmio ? "mmio" : "io", uart->addr.address);
 	if (uart->baud) {
 		p += sprintf(p, ",%lu", uart->baud);
@@ -41,7 +42,7 @@ setup_serial_console(struct pcdp_uart *u
 		}
 	}
 
-	return early_serial_console_init(options);
+	return setup_early_serial8250_console(options);
 #else
 	return -ENODEV;
 #endif
diff -puN drivers/serial/8250_early.c~serial-convert-early_uart-to-earlycon-for-8250-fix drivers/serial/8250_early.c
--- a/drivers/serial/8250_early.c~serial-convert-early_uart-to-earlycon-for-8250-fix
+++ a/drivers/serial/8250_early.c
@@ -204,7 +204,7 @@ static int __init early_serial8250_setup
 	return 0;
 }
 
-static int __init setup_early_serial8250_console(char *cmdline)
+int __init setup_early_serial8250_console(char *cmdline)
 {
 	char *options;
 	int err;
diff -puN include/linux/serial_8250.h~serial-convert-early_uart-to-earlycon-for-8250-fix include/linux/serial_8250.h
--- a/include/linux/serial_8250.h~serial-convert-early_uart-to-earlycon-for-8250-fix
+++ a/include/linux/serial_8250.h
@@ -63,5 +63,6 @@ void serial8250_resume_port(int line);
 
 extern int serial8250_find_port(struct uart_port *p);
 extern int serial8250_find_port_for_earlycon(void);
+extern int setup_early_serial8250_console(char *cmdline);
 
 #endif
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
serial-convert-early_uart-to-earlycon-for-8250-fix.patch
serial-convert-early_uart-to-earlycon-for-8250-ia64-fix.patch
serial-convert-early_uart-to-earlycon-for-8250-fix-3-alias.patch
dma-make-dma-pool-to-use-kmalloc_node.patch
