From: akpm@linux-foundation.org
Subject: - atmel_serial-use-existing-console-options-only-if-brg-is-running.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:18:30 -0800
Message-ID: <200802082018.m18KIBl1010903@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54481 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753257AbYBHU5E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:57:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hskinnemoen@atmel.com, linux@maxim.org.za, marc.pignat@hevs.ch, mm-commits@vger.kernel.org


The patch titled
     atmel_serial: use existing console options only if BRG is running
has been removed from the -mm tree.  Its filename was
     atmel_serial-use-existing-console-options-only-if-brg-is-running.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_serial: use existing console options only if BRG is running
From: Haavard Skinnemoen <hskinnemoen@atmel.com>

If BRGR is zero, the baud rate generator isn't running, so the boot loader
can't have initialized the port.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Acked-by: Andrew Victor <linux@maxim.org.za>
Tested-by: Marc Pignat <marc.pignat@hevs.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/atmel_serial.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN drivers/serial/atmel_serial.c~atmel_serial-use-existing-console-options-only-if-brg-is-running drivers/serial/atmel_serial.c
--- a/drivers/serial/atmel_serial.c~atmel_serial-use-existing-console-options-only-if-brg-is-running
+++ a/drivers/serial/atmel_serial.c
@@ -834,13 +834,13 @@ static void __init atmel_console_get_opt
 {
 	unsigned int mr, quot;
 
-// TODO: CR is a write-only register
-//	unsigned int cr;
-//
-//	cr = UART_GET_CR(port) & (ATMEL_US_RXEN | ATMEL_US_TXEN);
-//	if (cr == (ATMEL_US_RXEN | ATMEL_US_TXEN)) {
-//		/* ok, the port was enabled */
-//	}
+	/*
+	 * If the baud rate generator isn't running, the port wasn't
+	 * initialized by the boot loader.
+	 */
+	quot = UART_GET_BRGR(port);
+	if (!quot)
+		return;
 
 	mr = UART_GET_MR(port) & ATMEL_US_CHRL;
 	if (mr == ATMEL_US_CHRL_8)
@@ -860,7 +860,6 @@ static void __init atmel_console_get_opt
 	 * lower than one of those, as it would make us fall through
 	 * to a much lower baud rate than we really want.
 	 */
-	quot = UART_GET_BRGR(port);
 	*baud = port->uartclk / (16 * (quot - 1));
 }
 
_

Patches currently in -mm which might be from hskinnemoen@atmel.com are

origin.patch
git-avr32.patch
