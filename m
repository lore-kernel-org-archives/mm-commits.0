From: akpm@osdl.org
Subject: - serial-uartlite-initialize-port-parameters-in-console_setup.patch removed from -mm tree
Date: Wed, 06 Dec 2006 19:20:38 -0800
Message-ID: <200612070320.kB73KcUx027099@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:41969 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967817AbWLGDVb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 6 Dec 2006 22:21:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jacmet@sunsite.dk, alan@lxorguk.ukuu.org.uk, olof@lixom.net, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     serial-uartlite: Initialize port parameters in console_setup
has been removed from the -mm tree.  Its filename was
     serial-uartlite-initialize-port-parameters-in-console_setup.patch

This patch was dropped because it was folded into serial-uartlite-driver.patch

------------------------------------------------------
Subject: serial-uartlite: Initialize port parameters in console_setup
From: Peter Korsgaard <jacmet@sunsite.dk>

Initialize port parameters in console_setup so port timeout is set to
something sensible even if user space never calls set_termios.

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
Cc: Olof Johansson <olof@lixom.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/serial/uartlite.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletion(-)

diff -puN drivers/serial/uartlite.c~serial-uartlite-initialize-port-parameters-in-console_setup drivers/serial/uartlite.c
--- a/drivers/serial/uartlite.c~serial-uartlite-initialize-port-parameters-in-console_setup
+++ a/drivers/serial/uartlite.c
@@ -358,6 +358,10 @@ static void ulite_console_write(struct c
 static int __init ulite_console_setup(struct console *co, char *options)
 {
 	struct uart_port *port;
+	int baud = 9600;
+	int bits = 8;
+	int parity = 'n';
+	int flow = 'n';
 
 	if (co->index < 0 || co->index >= ULITE_NR_UARTS)
 		return -EINVAL;
@@ -368,7 +372,10 @@ static int __init ulite_console_setup(st
 	if (!port->membase)
 		return -ENODEV;
 
-	return 0;
+	if (options)
+		uart_parse_options(options, &baud, &parity, &bits, &flow);
+
+	return uart_set_options(port, co, baud, parity, bits, flow);
 }
 
 static struct uart_driver ulite_uart_driver;
_

Patches currently in -mm which might be from jacmet@sunsite.dk are

serial-uartlite-driver.patch
serial-uartlite-initialize-port-parameters-in-console_setup.patch

