From: akpm@linux-foundation.org
Subject: - sdio_uart-fix-sign-of-paramter-status-in-sdio_uart_receive_chars.patch removed from -mm tree
Date: Fri, 30 Nov 2007 16:23:05 -0800
Message-ID: <200712010023.lB10N5oQ031972@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33088 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757601AbXLAA1i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Nov 2007 19:27:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andre@bitwigglers.org, drzeus-mmc@drzeus.cx, nico@cam.org, mm-commits@vger.kernel.org


The patch titled
     sdio_uart: fix sign of paramter status in sdio_uart_receive_chars()
has been removed from the -mm tree.  Its filename was
     sdio_uart-fix-sign-of-paramter-status-in-sdio_uart_receive_chars.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sdio_uart: fix sign of paramter status in sdio_uart_receive_chars()
From: Andre Haupt <andre@bitwigglers.org>

The status paramter should be unsigned.  This also fixes a sparse warning
about different signedness.  Only compile tested, because i do not have the
hardware.

Signed-off-by: Andre Haupt <andre@bitwigglers.org>
Acked-by: Nicolas Pitre <nico@cam.org>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/card/sdio_uart.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mmc/card/sdio_uart.c~sdio_uart-fix-sign-of-paramter-status-in-sdio_uart_receive_chars drivers/mmc/card/sdio_uart.c
--- a/drivers/mmc/card/sdio_uart.c~sdio_uart-fix-sign-of-paramter-status-in-sdio_uart_receive_chars
+++ a/drivers/mmc/card/sdio_uart.c
@@ -386,7 +386,7 @@ static void sdio_uart_stop_rx(struct sdi
 	sdio_out(port, UART_IER, port->ier);
 }
 
-static void sdio_uart_receive_chars(struct sdio_uart_port *port, int *status)
+static void sdio_uart_receive_chars(struct sdio_uart_port *port, unsigned int *status)
 {
 	struct tty_struct *tty = port->tty;
 	unsigned int ch, flag;
_

Patches currently in -mm which might be from andre@bitwigglers.org are

origin.patch
git-arm.patch
fbmon-remove-unnecessary-local-variable.patch
fbmon-cleanup-trailing-whitespaces.patch
fbmon-cleanup-trailing-whitespaces-checkpatch-fixes.patch
