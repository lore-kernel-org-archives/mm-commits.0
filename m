From: akpm@linux-foundation.org
Subject: [merged] serial-8250-fixes-for-alchemy-uarts.patch removed from -mm tree
Date: Mon, 09 Nov 2009 11:55:30 -0800
Message-ID: <200911091955.nA9JtU80024072@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52814 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753839AbZKITzm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2009 14:55:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: manuel.lauss@googlemail.com, alan@lxorguk.ukuu.org.uk, manuel.lauss@gmail.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     serial 8250: fixes for Alchemy uarts
has been removed from the -mm tree.  Its filename was
     serial-8250-fixes-for-alchemy-uarts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial 8250: fixes for Alchemy uarts
From: Manuel Lauss <manuel.lauss@googlemail.com>

Limit the amount of address space claimed for Alchemy serial ports to
0x1000.  On the Au1300, ports are only 0x1000 apart, and the registers
only extend to 0x110 at most on all supported alchemy models.

On the Au1300 the autodetect logic no longer works and this makes it
necessary to specify the port type through platform data.  Because of this
the MSR quirk needs to be moved outside the autoconfig() function which
will no longer be called when UPF_FIXED_TYPE is specified.

Signed-off-by: Manuel Lauss <manuel.lauss@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/serial/8250.c~serial-8250-fixes-for-alchemy-uarts drivers/serial/8250.c
--- a/drivers/serial/8250.c~serial-8250-fixes-for-alchemy-uarts
+++ a/drivers/serial/8250.c
@@ -1214,12 +1214,6 @@ static void autoconfig(struct uart_8250_
 	}
 #endif
 
-#ifdef CONFIG_SERIAL_8250_AU1X00
-	/* if access method is AU, it is a 16550 with a quirk */
-	if (up->port.type == PORT_16550A && up->port.iotype == UPIO_AU)
-		up->bugs |= UART_BUG_NOMSR;
-#endif
-
 	serial_outp(up, UART_LCR, save_lcr);
 
 	if (up->capabilities != uart_config[up->port.type].flags) {
@@ -2429,7 +2423,7 @@ serial8250_pm(struct uart_port *port, un
 static unsigned int serial8250_port_size(struct uart_8250_port *pt)
 {
 	if (pt->port.iotype == UPIO_AU)
-		return 0x100000;
+		return 0x1000;
 #ifdef CONFIG_ARCH_OMAP
 	if (is_omap_port(pt))
 		return 0x16 << pt->port.regshift;
@@ -2586,6 +2580,13 @@ static void serial8250_config_port(struc
 
 	if (flags & UART_CONFIG_TYPE)
 		autoconfig(up, probeflags);
+
+#ifdef CONFIG_SERIAL_8250_AU1X00
+	/* if access method is AU, it is a 16550 with a quirk */
+	if (up->port.type == PORT_16550A && up->port.iotype == UPIO_AU)
+		up->bugs |= UART_BUG_NOMSR;
+#endif
+
 	if (up->port.type != PORT_UNKNOWN && flags & UART_CONFIG_IRQ)
 		autoconfig_irq(up);
 
_

Patches currently in -mm which might be from manuel.lauss@googlemail.com are

linux-next.patch

