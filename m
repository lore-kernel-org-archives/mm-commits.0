From: akpm@osdl.org
Subject: - fix-serial-uartlite-after-global-pt_regs.patch removed from -mm tree
Date: Wed, 06 Dec 2006 19:20:20 -0800
Message-ID: <200612070320.kB73KKmJ027090@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:41952 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967810AbWLGDVO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 6 Dec 2006 22:21:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jacmet@sunsite.dk, alan@lxorguk.ukuu.org.uk, olof@lixom.net, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Fix serial-uartlite after global pt_regs
has been removed from the -mm tree.  Its filename was
     fix-serial-uartlite-after-global-pt_regs.patch

This patch was dropped because it was folded into serial-uartlite-driver.patch

------------------------------------------------------
Subject: Fix serial-uartlite after global pt_regs
From: Peter Korsgaard <jacmet@sunsite.dk>

This little patch updates the serial uartlite driver in -mm for the global
pt_regs in 2.6.19-rc2+.

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
Cc: Olof Johansson <olof@lixom.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/serial/uartlite.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/serial/uartlite.c~fix-serial-uartlite-after-global-pt_regs drivers/serial/uartlite.c
--- a/drivers/serial/uartlite.c~fix-serial-uartlite-after-global-pt_regs
+++ a/drivers/serial/uartlite.c
@@ -126,7 +126,7 @@ static int ulite_transmit(struct uart_po
 	return 1;
 }
 
-static irqreturn_t ulite_isr(int irq, void *dev_id, struct pt_regs *regs)
+static irqreturn_t ulite_isr(int irq, void *dev_id)
 {
 	struct uart_port *port = (struct uart_port *)dev_id;
 	int busy;
_

Patches currently in -mm which might be from jacmet@sunsite.dk are

serial-uartlite-driver.patch
fix-serial-uartlite-after-global-pt_regs.patch
serial-uartlite-support-multiple-devices.patch
serial-uartlite-initialize-port-parameters-in-console_setup.patch

