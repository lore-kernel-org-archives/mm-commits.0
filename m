From: akpm@linux-foundation.org
Subject: + sdio_uart-fix-sign-of-paramter-status-in-sdio_uart_receive_chars.patch added to -mm tree
Date: Mon, 26 Nov 2007 20:15:03 -0800
Message-ID: <200711270415.lAR4F3mx026371@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38483 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754914AbXK0EPd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 23:15:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andre@bitwigglers.org, drzeus-mmc@drzeus.cx, nico@cam.org


The patch titled
     sdio_uart: fix sign of paramter status in sdio_uart_receive_chars()
has been added to the -mm tree.  Its filename is
     sdio_uart-fix-sign-of-paramter-status-in-sdio_uart_receive_chars.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-arm.patch
sdio_uart-fix-sign-of-paramter-status-in-sdio_uart_receive_chars.patch
