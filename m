From: akpm@linux-foundation.org
Subject: [merged] drivers-serial-atmel_serialc-fix-compile-when-config_serial_atmel=y-and-config_serial_atmel_console=n.patch removed from -mm tree
Date: Thu, 30 Jul 2009 13:37:37 -0700
Message-ID: <200907302037.n6UKbbvc011702@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38070 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752454AbZG3Uhp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 16:37:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: albin.tonnerre@gmail.com, albin.tonnerre@free-electrons.com, haavard.skinnemoen@atmel.com, nicolas.ferre@atmel.com, mm-commits@vger.kernel.org


The patch titled
     drivers/serial/atmel_serial.c: fix compile when CONFIG_SERIAL_ATMEL=Y and CONFIG_SERIAL_ATMEL_CONSOLE=N
has been removed from the -mm tree.  Its filename was
     drivers-serial-atmel_serialc-fix-compile-when-config_serial_atmel=y-and-config_serial_atmel_console=n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/serial/atmel_serial.c: fix compile when CONFIG_SERIAL_ATMEL=Y and CONFIG_SERIAL_ATMEL_CONSOLE=N
From: Albin Tonnerre <albin.tonnerre@gmail.com>

When SERIAL_ATMEL_CONSOLE is disabled, ATMEL_CONSOLE_DEVICE is set to
NULL, and trying to access ATMEL_CONSOLE_DEVICE->flags in
atmel_serial_probe makes the compile fail.  This fixes the issue by only
accessing it if CONFIG_SERIAL_ATMEL_CONSOLE is defined

Signed-off-by: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/atmel_serial.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/serial/atmel_serial.c~drivers-serial-atmel_serialc-fix-compile-when-config_serial_atmel=y-and-config_serial_atmel_console=n drivers/serial/atmel_serial.c
--- a/drivers/serial/atmel_serial.c~drivers-serial-atmel_serialc-fix-compile-when-config_serial_atmel=y-and-config_serial_atmel_console=n
+++ a/drivers/serial/atmel_serial.c
@@ -1551,6 +1551,7 @@ static int __devinit atmel_serial_probe(
 	if (ret)
 		goto err_add_port;
 
+#ifdef CONFIG_SERIAL_ATMEL_CONSOLE
 	if (atmel_is_console_port(&port->uart)
 			&& ATMEL_CONSOLE_DEVICE->flags & CON_ENABLED) {
 		/*
@@ -1559,6 +1560,7 @@ static int __devinit atmel_serial_probe(
 		 */
 		clk_disable(port->clk);
 	}
+#endif
 
 	device_init_wakeup(&pdev->dev, 1);
 	platform_set_drvdata(pdev, port);
_

Patches currently in -mm which might be from albin.tonnerre@gmail.com are

origin.patch

