From: akpm@linux-foundation.org
Subject: - atmel_serial-filter-out-fp-during-baud-rate-detection.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:48:44 -0700
Message-ID: <200806081948.m58Jmib7017531@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35307 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754375AbYFHTtG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:49:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haavard.skinnemoen@atmel.com, linux@maxim.org.za, mm-commits@vger.kernel.org


The patch titled
     atmel_serial: filter out FP during baud rate detection
has been removed from the -mm tree.  Its filename was
     atmel_serial-filter-out-fp-during-baud-rate-detection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_serial: filter out FP during baud rate detection
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

I made a change to u-boot that used the FP (Fractional Part) field of BRGR
to achieve more accurate baud rate generation.  Unfortunately, the
atmel_serial driver looks at the whole BRGR register when trying to detect
the baud rate that the port is currently running at, so setting FP to a
nonzero value breaks the baud rate detection.

I'll sit on the u-boot patch for a while longer, but this is clearly a
bug in the atmel_serial driver which should be fixed.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Acked-by: Andrew Victor <linux@maxim.org.za>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/atmel_serial.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/serial/atmel_serial.c~atmel_serial-filter-out-fp-during-baud-rate-detection drivers/serial/atmel_serial.c
--- a/drivers/serial/atmel_serial.c~atmel_serial-filter-out-fp-during-baud-rate-detection
+++ a/drivers/serial/atmel_serial.c
@@ -1318,7 +1318,7 @@ static void __init atmel_console_get_opt
 	 * If the baud rate generator isn't running, the port wasn't
 	 * initialized by the boot loader.
 	 */
-	quot = UART_GET_BRGR(port);
+	quot = UART_GET_BRGR(port) & ATMEL_US_CD;
 	if (!quot)
 		return;
 
_

Patches currently in -mm which might be from haavard.skinnemoen@atmel.com are

origin.patch
linux-next.patch

