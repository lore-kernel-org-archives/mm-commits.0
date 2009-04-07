From: akpm@linux-foundation.org
Subject: - blackfin-serial-driver-use-the-dlab-macro-to-hide-variant-differences.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:05:03 -0700
Message-ID: <200904071905.n37J53Lu010203@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52169 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753335AbZDGTIy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:08:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk, cooloney@kernel.org, mm-commits@vger.kernel.org


The patch titled
     blackfin serial driver: use the DLAB macro to hide variant differences
has been removed from the -mm tree.  Its filename was
     blackfin-serial-driver-use-the-dlab-macro-to-hide-variant-differences.patch

This patch was dropped because someone merged some of these and fiddled with them - I lost the plot

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: blackfin serial driver: use the DLAB macro to hide variant differences
From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/bfin_5xx.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN drivers/serial/bfin_5xx.c~blackfin-serial-driver-use-the-dlab-macro-to-hide-variant-differences drivers/serial/bfin_5xx.c
--- a/drivers/serial/bfin_5xx.c~blackfin-serial-driver-use-the-dlab-macro-to-hide-variant-differences
+++ a/drivers/serial/bfin_5xx.c
@@ -1250,7 +1250,7 @@ struct console __init *bfin_earlyserial_
 void bfin_serial_debug(const char *fmt, ...)
 {
 	struct bfin_serial_port *uart = &bfin_serial_ports[0];
-	unsigned short status, tmp;
+	unsigned short status;
 	unsigned long flags;
 	int i, count;
 	char buf[128];
@@ -1273,11 +1273,7 @@ void bfin_serial_debug(const char *fmt, 
 			status = UART_GET_LSR(uart);
 		} while (!(status & THRE));
 
-#ifndef CONFIG_BF54x
-		tmp = UART_GET_LCR(uart);
-		tmp &= ~DLAB;
-		UART_PUT_LCR(uart, tmp);
-#endif
+		UART_CLEAR_DLAB(uart);
 		UART_PUT_CHAR(uart, buf[i]);
 		if (buf[i] == '\n') {
 			do {
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

origin.patch
linux-next.patch
blackfin-serial-driver-use-the-dlab-macro-to-hide-variant-differences.patch

