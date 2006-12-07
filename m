From: akpm@osdl.org
Subject: - exar-quad-port-serial.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:03:38 -0800
Message-ID: <200612072303.kB7N3c1H029976@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53014 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163864AbWLGXKY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:10:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pschroeder@uplogix.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com, lsorense@csclub.uwaterloo.ca, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Exar quad port serial
has been removed from the -mm tree.  Its filename was
     exar-quad-port-serial.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Exar quad port serial
From: Paul B Schroeder <pschroeder@uplogix.com>

This is on our "Envoy" boxes which we have, according to the documentation, an
"Exar ST16C554/554D Quad UART with 16-byte Fifo's".  The box also has two
other "on-board" serial ports and a modem chip.

The two on-board serial UARTs were being detected along with the first two
Exar UARTs.  The last two Exar UARTs were not showing up and neither was the
modem.

This patch was the only way I could the kernel to see beyond the standard four
serial ports and get all four of the Exar UARTs to show up.

[akpm@osdl.org: build fix]
Signed-off-by:  Paul B Schroeder <pschroeder@uplogix.com>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/serial/8250_exar_st16c554.c |   52 ++++++++++++++++++++++++++
 drivers/serial/Kconfig              |   11 +++++
 drivers/serial/Makefile             |    1 
 include/linux/serial_8250.h         |    1 
 4 files changed, 65 insertions(+)

diff -puN /dev/null drivers/serial/8250_exar_st16c554.c
--- /dev/null
+++ a/drivers/serial/8250_exar_st16c554.c
@@ -0,0 +1,52 @@
+/*
+ *  linux/drivers/serial/8250_exar.c
+ *
+ *  Written by Paul B Schroeder < pschroeder "at" uplogix "dot" com >
+ *  Based on 8250_boca.
+ *
+ *  Copyright (C) 2005 Russell King.
+ *  Data taken from include/asm-i386/serial.h
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/serial_8250.h>
+
+#define PORT(_base,_irq)				\
+	{						\
+		.iobase		= _base,		\
+		.irq		= _irq,			\
+		.uartclk	= 1843200,		\
+		.iotype		= UPIO_PORT,		\
+		.flags		= UPF_BOOT_AUTOCONF,	\
+	}
+
+static struct plat_serial8250_port exar_data[] = {
+	PORT(0x100, 5),
+	PORT(0x108, 5),
+	PORT(0x110, 5),
+	PORT(0x118, 5),
+	{ },
+};
+
+static struct platform_device exar_device = {
+	.name			= "serial8250",
+	.id			= PLAT8250_DEV_EXAR_ST16C554,
+	.dev			= {
+		.platform_data	= exar_data,
+	},
+};
+
+static int __init exar_init(void)
+{
+	return platform_device_register(&exar_device);
+}
+
+module_init(exar_init);
+
+MODULE_AUTHOR("Paul B Schroeder");
+MODULE_DESCRIPTION("8250 serial probe module for Exar cards");
+MODULE_LICENSE("GPL");
diff -puN drivers/serial/Kconfig~exar-quad-port-serial drivers/serial/Kconfig
--- a/drivers/serial/Kconfig~exar-quad-port-serial
+++ a/drivers/serial/Kconfig
@@ -210,6 +210,17 @@ config SERIAL_8250_BOCA
 	  To compile this driver as a module, choose M here: the module
 	  will be called 8250_boca.
 
+config SERIAL_8250_EXAR_ST16C554
+	tristate "Support Exar ST16C554/554D Quad UART"
+	depends on SERIAL_8250 != n && ISA && SERIAL_8250_MANY_PORTS
+	help
+	  The Uplogix Envoy TU301 uses this Exar Quad UART.  If you are
+	  tinkering with your Envoy TU301, or have a machine with this UART,
+	  say Y here.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called 8250_exar_st16c554.
+
 config SERIAL_8250_HUB6
 	tristate "Support Hub6 cards"
 	depends on SERIAL_8250 != n && ISA && SERIAL_8250_MANY_PORTS
diff -puN drivers/serial/Makefile~exar-quad-port-serial drivers/serial/Makefile
--- a/drivers/serial/Makefile~exar-quad-port-serial
+++ a/drivers/serial/Makefile
@@ -17,6 +17,7 @@ obj-$(CONFIG_SERIAL_8250_CONSOLE) += 825
 obj-$(CONFIG_SERIAL_8250_FOURPORT) += 8250_fourport.o
 obj-$(CONFIG_SERIAL_8250_ACCENT) += 8250_accent.o
 obj-$(CONFIG_SERIAL_8250_BOCA) += 8250_boca.o
+obj-$(CONFIG_SERIAL_8250_EXAR_ST16C554) += 8250_exar_st16c554.o
 obj-$(CONFIG_SERIAL_8250_HUB6) += 8250_hub6.o
 obj-$(CONFIG_SERIAL_8250_MCA) += 8250_mca.o
 obj-$(CONFIG_SERIAL_8250_AU1X00) += 8250_au1x00.o
diff -puN include/linux/serial_8250.h~exar-quad-port-serial include/linux/serial_8250.h
--- a/include/linux/serial_8250.h~exar-quad-port-serial
+++ a/include/linux/serial_8250.h
@@ -41,6 +41,7 @@ enum {
 	PLAT8250_DEV_FOURPORT,
 	PLAT8250_DEV_ACCENT,
 	PLAT8250_DEV_BOCA,
+	PLAT8250_DEV_EXAR_ST16C554,
 	PLAT8250_DEV_HUB6,
 	PLAT8250_DEV_MCA,
 	PLAT8250_DEV_AU1X00,
_

Patches currently in -mm which might be from pschroeder@uplogix.com are

origin.patch

