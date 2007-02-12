From: akpm@linux-foundation.org
Subject: - arm-imx-serial-fix-irq-allocation.patch removed from -mm tree
Date: Sun, 11 Feb 2007 23:11:03 -0800
Message-ID: <200702120711.l1C7B3Sp024546@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44346 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964775AbXBLHMS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 02:12:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ppisa4lists@pikron.com, rmk@arm.linux.org.uk, s.hauer@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     ARM i.MX serial: fix IRQ allocation
has been removed from the -mm tree.  Its filename was
     arm-imx-serial-fix-irq-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ARM i.MX serial: fix IRQ allocation
From: Pavel Pisa <ppisa4lists@pikron.com>

If RTS interrupt is caused by RTS senzing logic inside i.MX UART module the
IRQ type cannot be set.

It applies only for interrupts going through GPIO layer.  The problem has
been noticed by Konstantin Kletschke some time ago.

  No IRQF_TRIGGER set_type function for IRQ 26 (MPU)

I would not change type to fixed 0, because it could be possible to use
different GPIO MX1 pin for RTS in the theory.  On the other hand it is only
for documentation purposes now, because RTS read code would have to be
adjusted in such case.

Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/imx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/serial/imx.c~arm-imx-serial-fix-irq-allocation drivers/serial/imx.c
--- a/drivers/serial/imx.c~arm-imx-serial-fix-irq-allocation
+++ a/drivers/serial/imx.c
@@ -403,7 +403,8 @@ static int imx_startup(struct uart_port 
 	if (retval) goto error_out2;
 
 	retval = request_irq(sport->rtsirq, imx_rtsint,
-			     IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
+			     (sport->rtsirq < IMX_IRQS) ? 0 :
+			       IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
 			     DRIVER_NAME, sport);
 	if (retval) goto error_out3;
 
_

Patches currently in -mm which might be from ppisa4lists@pikron.com are
