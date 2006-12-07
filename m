From: akpm@osdl.org
Subject: - serial-uartlite-support-multiple-devices.patch removed from -mm tree
Date: Wed, 06 Dec 2006 19:20:35 -0800
Message-ID: <200612070320.kB73KZKT027096@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:41967 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967815AbWLGDV2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 6 Dec 2006 22:21:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jacmet@sunsite.dk, alan@lxorguk.ukuu.org.uk, olof@lixom.net, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     serial-uartlite: Support multiple devices
has been removed from the -mm tree.  Its filename was
     serial-uartlite-support-multiple-devices.patch

This patch was dropped because it was folded into serial-uartlite-driver.patch

------------------------------------------------------
Subject: serial-uartlite: Support multiple devices
From: Peter Korsgaard <jacmet@sunsite.dk>

Set port->line in probe() so multiple devices can be used.

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
Acked-by: Olof Johansson <olof@lixom.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/serial/uartlite.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/serial/uartlite.c~serial-uartlite-support-multiple-devices drivers/serial/uartlite.c
--- a/drivers/serial/uartlite.c~serial-uartlite-support-multiple-devices
+++ a/drivers/serial/uartlite.c
@@ -437,6 +437,7 @@ static int __devinit ulite_probe(struct 
 	port->flags	= UPF_BOOT_AUTOCONF;
 	port->dev	= &pdev->dev;
 	port->type	= PORT_UNKNOWN;
+	port->line	= pdev->id;
 
 	uart_add_one_port(&ulite_uart_driver, port);
 	platform_set_drvdata(pdev, port);
_

Patches currently in -mm which might be from jacmet@sunsite.dk are

serial-uartlite-driver.patch
serial-uartlite-support-multiple-devices.patch
serial-uartlite-initialize-port-parameters-in-console_setup.patch

