From: akpm@linux-foundation.org
Subject: - atmel_serial-fix-bugs-in-probe-error-path-and-remove.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:18:32 -0800
Message-ID: <200802082018.m18KID8d010906@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52463 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753924AbYBHU63 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:58:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hskinnemoen@atmel.com, linux@maxim.org.za, marc.pignat@hevs.ch, mm-commits@vger.kernel.org


The patch titled
     atmel_serial: fix bugs in probe() error path and remove()
has been removed from the -mm tree.  Its filename was
     atmel_serial-fix-bugs-in-probe-error-path-and-remove.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_serial: fix bugs in probe() error path and remove()
From: Haavard Skinnemoen <hskinnemoen@atmel.com>

When an error happens in probe(), the clocks should be disabled, but
only if the port isn't already used as a console.

In remove(), the port struct shouldn't be freed because it's defined
statically.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Andrew Victor <linux@maxim.org.za>
Tested-by: Marc Pignat <marc.pignat@hevs.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/atmel_serial.c |   39 +++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 10 deletions(-)

diff -puN drivers/serial/atmel_serial.c~atmel_serial-fix-bugs-in-probe-error-path-and-remove drivers/serial/atmel_serial.c
--- a/drivers/serial/atmel_serial.c~atmel_serial-fix-bugs-in-probe-error-path-and-remove
+++ a/drivers/serial/atmel_serial.c
@@ -934,8 +934,18 @@ static int __init atmel_late_console_ini
 
 core_initcall(atmel_late_console_init);
 
+static inline bool atmel_is_console_port(struct uart_port *port)
+{
+	return port->cons && port->cons->index == port->line;
+}
+
 #else
 #define ATMEL_CONSOLE_DEVICE	NULL
+
+static inline bool atmel_is_console_port(struct uart_port *port)
+{
+	return false;
+}
 #endif
 
 static struct uart_driver atmel_uart = {
@@ -993,9 +1003,19 @@ static int __devinit atmel_serial_probe(
 	atmel_init_port(port, pdev);
 
 	ret = uart_add_one_port(&atmel_uart, &port->uart);
-	if (!ret) {
-		device_init_wakeup(&pdev->dev, 1);
-		platform_set_drvdata(pdev, port);
+	if (ret)
+		goto err_add_port;
+
+	device_init_wakeup(&pdev->dev, 1);
+	platform_set_drvdata(pdev, port);
+
+	return 0;
+
+err_add_port:
+	if (!atmel_is_console_port(&port->uart)) {
+		clk_disable(port->clk);
+		clk_put(port->clk);
+		port->clk = NULL;
 	}
 
 	return ret;
@@ -1007,16 +1027,15 @@ static int __devexit atmel_serial_remove
 	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
 	int ret = 0;
 
-	clk_disable(atmel_port->clk);
-	clk_put(atmel_port->clk);
-
 	device_init_wakeup(&pdev->dev, 0);
 	platform_set_drvdata(pdev, NULL);
 
-	if (port) {
-		ret = uart_remove_one_port(&atmel_uart, port);
-		kfree(port);
-	}
+	ret = uart_remove_one_port(&atmel_uart, port);
+
+	/* "port" is allocated statically, so we shouldn't free it */
+
+	clk_disable(atmel_port->clk);
+	clk_put(atmel_port->clk);
 
 	return ret;
 }
_

Patches currently in -mm which might be from hskinnemoen@atmel.com are

origin.patch
git-avr32.patch
