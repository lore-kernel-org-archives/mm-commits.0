From: akpm@linux-foundation.org
Subject: - serial-convert-early_uart-to-earlycon-for-8250-fix.patch removed from -mm tree
Date: Wed, 30 May 2007 18:32:31 -0700
Message-ID: <200705310135.l4V1ZuSC009759@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:57136 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752886AbXEaBgH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 21:36:07 -0400
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

Please use this one instead. it add _init to update_console_cmdline, and
serial8250_find_port_for_earlycon. and CON_BOOT to flag of early_serial8250_console

Signed-off-by: <yinghai.lu@sun.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Gerd Hoffmann <kraxel@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_early.c |    5 ++---
 kernel/printk.c             |    2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/serial/8250_early.c~serial-convert-early_uart-to-earlycon-for-8250-fix drivers/serial/8250_early.c
--- a/drivers/serial/8250_early.c~serial-convert-early_uart-to-earlycon-for-8250-fix
+++ a/drivers/serial/8250_early.c
@@ -170,7 +170,7 @@ static int __init parse_options(struct e
 static struct console early_serial8250_console __initdata = {
 	.name	= "uart",
 	.write	= early_serial8250_write,
-	.flags	= CON_PRINTBUFFER,
+	.flags	= CON_PRINTBUFFER | CON_BOOT,
 	.index	= -1,
 };
 
@@ -202,13 +202,12 @@ static int __init setup_early_serial8250
 	if ((err = early_serial8250_setup(options)) < 0)
 		return err;
 
-	early_serial8250_console.flags |= CON_BOOT;
 	register_console(&early_serial8250_console);
 
 	return 0;
 }
 
-int serial8250_find_port_for_earlycon(void)
+int __init serial8250_find_port_for_earlycon(void)
 {
 	struct early_serial8250_device *device = &early_device;
 	struct uart_port *port = &device->port;
diff -puN kernel/printk.c~serial-convert-early_uart-to-earlycon-for-8250-fix kernel/printk.c
--- a/kernel/printk.c~serial-convert-early_uart-to-earlycon-for-8250-fix
+++ a/kernel/printk.c
@@ -726,7 +726,7 @@ int __init add_preferred_console(char *n
 	return 0;
 }
 
-int update_console_cmdline(char *name, int idx, char *name_new, int idx_new, char *options)
+int __init update_console_cmdline(char *name, int idx, char *name_new, int idx_new, char *options)
 {
 	struct console_cmdline *c;
 	int i;
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

console-more-buf-for-index-parsing.patch
console-console-handover-to-preferred-console.patch
serial-convert-early_uart-to-earlycon-for-8250.patch
serial-convert-early_uart-to-earlycon-for-8250-fix.patch
serial-set-dtr-in-uart-for-kernel-serial-console.patch
