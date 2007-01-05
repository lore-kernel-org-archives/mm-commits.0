From: akpm@osdl.org
Subject: + arm-imx-serial-fix-tx-buffer-overflows.patch added to -mm tree
Date: Fri, 05 Jan 2007 12:22:48 -0800
Message-ID: <200701052022.l05KMmEj031336@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57940 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbXAEUXO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 5 Jan 2007 15:23:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: s.hauer@pengutronix.de, pisa@cmp.felk.cvut.cz, rmk@arm.linux.org.uk


The patch titled
     ARM i.MX serial: fix tx buffer overflows
has been added to the -mm tree.  Its filename is
     arm-imx-serial-fix-tx-buffer-overflows.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ARM i.MX serial: fix tx buffer overflows
From: Sascha Hauer <s.hauer@pengutronix.de>

Fix occasional tx buffer overflows in the i.MX serial driver which came
from the fact that space in the buffer was checked after sending the first
byte.  Also, fifosize is 32 bytes, not 8.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de
Cc: Russell King <rmk@arm.linux.org.uk>
Acked-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/serial/imx.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff -puN drivers/serial/imx.c~arm-imx-serial-fix-tx-buffer-overflows drivers/serial/imx.c
--- a/drivers/serial/imx.c~arm-imx-serial-fix-tx-buffer-overflows
+++ a/drivers/serial/imx.c
@@ -154,7 +154,7 @@ static inline void imx_transmit_buffer(s
 {
 	struct circ_buf *xmit = &sport->port.info->xmit;
 
-	do {
+	while (!(UTS((u32)sport->port.membase) & UTS_TXFULL)) {
 		/* send xmit->buf[xmit->tail]
 		 * out the port here */
 		URTX0((u32)sport->port.membase) = xmit->buf[xmit->tail];
@@ -163,7 +163,7 @@ static inline void imx_transmit_buffer(s
 		sport->port.icount.tx++;
 		if (uart_circ_empty(xmit))
 			break;
-	} while (!(UTS((u32)sport->port.membase) & UTS_TXFULL));
+	}
 
 	if (uart_circ_empty(xmit))
 		imx_stop_tx(&sport->port);
@@ -178,8 +178,7 @@ static void imx_start_tx(struct uart_por
 
 	UCR1((u32)sport->port.membase) |= UCR1_TXMPTYEN;
 
-	if(UTS((u32)sport->port.membase) & UTS_TXEMPTY)
-		imx_transmit_buffer(sport);
+	imx_transmit_buffer(sport);
 }
 
 static irqreturn_t imx_rtsint(int irq, void *dev_id)
@@ -678,7 +677,7 @@ static struct imx_port imx_ports[] = {
 		.mapbase	= IMX_UART1_BASE, /* FIXME */
 		.irq		= UART1_MINT_RX,
 		.uartclk	= 16000000,
-		.fifosize	= 8,
+		.fifosize	= 32,
 		.flags		= UPF_BOOT_AUTOCONF,
 		.ops		= &imx_pops,
 		.line		= 0,
@@ -694,7 +693,7 @@ static struct imx_port imx_ports[] = {
 		.mapbase	= IMX_UART2_BASE, /* FIXME */
 		.irq		= UART2_MINT_RX,
 		.uartclk	= 16000000,
-		.fifosize	= 8,
+		.fifosize	= 32,
 		.flags		= UPF_BOOT_AUTOCONF,
 		.ops		= &imx_pops,
 		.line		= 1,
_

Patches currently in -mm which might be from s.hauer@pengutronix.de are

arm-imx-serial-fix-tx-buffer-overflows.patch
