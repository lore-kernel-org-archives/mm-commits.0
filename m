From: akpm@osdl.org
Subject: - serial-uartlite-driver-fix.patch removed from -mm tree
Date: Wed, 06 Dec 2006 19:20:03 -0800
Message-ID: <200612070320.kB73K34d027084@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:41940 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967808AbWLGDVF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 6 Dec 2006 22:21:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jacmet@sunsite.dk, alan@lxorguk.ukuu.org.uk, olof@lixom.net, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     serial-uartlite-driver fix
has been removed from the -mm tree.  Its filename was
     serial-uartlite-driver-fix.patch

This patch was dropped because it was folded into serial-uartlite-driver.patch

------------------------------------------------------
Subject: serial-uartlite-driver fix
From: Peter Korsgaard <jacmet@sunsite.dk>

 >> Ok, I can add a wmb(); between.

 Andrew> wmb() won't make that `0' hit the device.  It'll take a
 Andrew> readb() to accomplish that.

Ah yes, the following tiny patch does that:

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
Cc: Olof Johansson <olof@lixom.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/serial/uartlite.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/serial/uartlite.c~serial-uartlite-driver-fix drivers/serial/uartlite.c
--- a/drivers/serial/uartlite.c~serial-uartlite-driver-fix
+++ a/drivers/serial/uartlite.c
@@ -210,6 +210,7 @@ static int ulite_startup(struct uart_por
 static void ulite_shutdown(struct uart_port *port)
 {
 	writeb(0, port->membase + ULITE_CONTROL);
+	readb(port->membase + ULITE_CONTROL); /* dummy */
 	free_irq(port->irq, port);
 }
 
_

Patches currently in -mm which might be from jacmet@sunsite.dk are

serial-uartlite-driver.patch
serial-uartlite-driver-fix.patch
fix-serial-uartlite-after-global-pt_regs.patch
serial-uartlite-support-multiple-devices.patch
serial-uartlite-initialize-port-parameters-in-console_setup.patch

