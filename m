From: akpm@linux-foundation.org
Subject: + drivers-serial-atmel_serialc-fix-compile-when-config_serial_atmel=y-and-config_serial_atmel_console=n.patch added to -mm tree
Date: Tue, 28 Jul 2009 16:29:06 -0700
Message-ID: <200907282329.n6SNT6bL022516@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751052AbZG1X3e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Jul 2009 19:29:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: albin.tonnerre@gmail.com, albin.tonnerre@free-electrons.com, haavard.skinnemoen@atmel.com, nicolas.ferre@atmel.com


The patch titled
     drivers/serial/atmel_serial.c: fix compile when CONFIG_SERIAL_ATMEL=Y and CONFIG_SERIAL_ATMEL_CONSOLE=N
has been added to the -mm tree.  Its filename is
     drivers-serial-atmel_serialc-fix-compile-when-config_serial_atmel=y-and-config_serial_atmel_console=n.patch

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

drivers-serial-atmel_serialc-fix-compile-when-config_serial_atmel=y-and-config_serial_atmel_console=n.patch

