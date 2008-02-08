From: akpm@linux-foundation.org
Subject: - atmel_serial-use-cpu_relax-when-busy-waiting.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:18:28 -0800
Message-ID: <200802082018.m18KI92u010895@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45686 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755453AbYBHU42 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:56:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hskinnemoen@atmel.com, linux@maxim.org.za, marc.pignat@hevs.ch, mm-commits@vger.kernel.org


The patch titled
     atmel_serial: use cpu_relax() when busy-waiting
has been removed from the -mm tree.  Its filename was
     atmel_serial-use-cpu_relax-when-busy-waiting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_serial: use cpu_relax() when busy-waiting
From: Haavard Skinnemoen <hskinnemoen@atmel.com>

Replace two instances of barrier() with cpu_relax() since that's the right
thing to do when busy-waiting.  This does not actually change anything since
cpu_relax() is defined as barrier() on both ARM and AVR32.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Acked-by: Andrew Victor <linux@maxim.org.za>
Tested-by: Marc Pignat <marc.pignat@hevs.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/atmel_serial.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/serial/atmel_serial.c~atmel_serial-use-cpu_relax-when-busy-waiting drivers/serial/atmel_serial.c
--- a/drivers/serial/atmel_serial.c~atmel_serial-use-cpu_relax-when-busy-waiting
+++ a/drivers/serial/atmel_serial.c
@@ -615,7 +615,7 @@ static void atmel_set_termios(struct uar
 	imr = UART_GET_IMR(port);
 	UART_PUT_IDR(port, -1);
 	while (!(UART_GET_CSR(port) & ATMEL_US_TXEMPTY))
-		barrier();
+		cpu_relax();
 
 	/* disable receiver and transmitter */
 	UART_PUT_CR(port, ATMEL_US_TXDIS | ATMEL_US_RXDIS);
@@ -794,7 +794,7 @@ void __init atmel_register_uart_fns(stru
 static void atmel_console_putchar(struct uart_port *port, int ch)
 {
 	while (!(UART_GET_CSR(port) & ATMEL_US_TXRDY))
-		barrier();
+		cpu_relax();
 	UART_PUT_CHAR(port, ch);
 }
 
_

Patches currently in -mm which might be from hskinnemoen@atmel.com are

origin.patch
git-avr32.patch
