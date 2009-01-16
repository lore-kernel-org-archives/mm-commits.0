From: akpm@linux-foundation.org
Subject: [merged] serial-pnx8xxx_uart-fix-break-signal-handling.patch removed from -mm tree
Date: Fri, 16 Jan 2009 11:18:30 -0800
Message-ID: <200901161918.n0GJIUCu027106@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53460 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936800AbZAPTTF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 14:19:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mischa.jonker@nxp.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     serial: pnx8xxx_uart: Fix break signal handling
has been removed from the -mm tree.  Its filename was
     serial-pnx8xxx_uart-fix-break-signal-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: pnx8xxx_uart: Fix break signal handling
From: Mischa Jonker <mischa.jonker@nxp.com>

When a break signal is detected, the next character should be ignored.
This was not implemented correctly for the pnx8xxx_uart driver.

It can be viewed as two separate bugs:

a) the next character is not ignored while it should;
b) the status bits 31-8 are copied to the 'ch' variable while they shouldn't.

Both bugs prevent correct break signal handling (and therefore correct
behaviour of the magic SysRq key).  Bug b) didn't cause too much trouble
earlier because in most situations the status bits are all zero; for this
case they unfortunately aren't.

Signed-off-by: Mischa Jonker <mischa.jonker@nxp.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/pnx8xxx_uart.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff -puN drivers/serial/pnx8xxx_uart.c~serial-pnx8xxx_uart-fix-break-signal-handling drivers/serial/pnx8xxx_uart.c
--- a/drivers/serial/pnx8xxx_uart.c~serial-pnx8xxx_uart-fix-break-signal-handling
+++ a/drivers/serial/pnx8xxx_uart.c
@@ -187,7 +187,7 @@ static void pnx8xxx_rx_chars(struct pnx8
 	status = FIFO_TO_SM(serial_in(sport, PNX8XXX_FIFO)) |
 		 ISTAT_TO_SM(serial_in(sport, PNX8XXX_ISTAT));
 	while (status & FIFO_TO_SM(PNX8XXX_UART_FIFO_RXFIFO)) {
-		ch = serial_in(sport, PNX8XXX_FIFO);
+		ch = serial_in(sport, PNX8XXX_FIFO) & 0xff;
 
 		sport->port.icount.rx++;
 
@@ -198,9 +198,16 @@ static void pnx8xxx_rx_chars(struct pnx8
 		 * out of the main execution path
 		 */
 		if (status & (FIFO_TO_SM(PNX8XXX_UART_FIFO_RXFE |
-					PNX8XXX_UART_FIFO_RXPAR) |
+					PNX8XXX_UART_FIFO_RXPAR |
+					PNX8XXX_UART_FIFO_RXBRK) |
 			      ISTAT_TO_SM(PNX8XXX_UART_INT_RXOVRN))) {
-			if (status & FIFO_TO_SM(PNX8XXX_UART_FIFO_RXPAR))
+			if (status & FIFO_TO_SM(PNX8XXX_UART_FIFO_RXBRK)) {
+				status &= ~(FIFO_TO_SM(PNX8XXX_UART_FIFO_RXFE) |
+					FIFO_TO_SM(PNX8XXX_UART_FIFO_RXPAR));
+				sport->port.icount.brk++;
+				if (uart_handle_break(&sport->port))
+					goto ignore_char;
+			} else if (status & FIFO_TO_SM(PNX8XXX_UART_FIFO_RXPAR))
 				sport->port.icount.parity++;
 			else if (status & FIFO_TO_SM(PNX8XXX_UART_FIFO_RXFE))
 				sport->port.icount.frame++;
@@ -284,14 +291,8 @@ static irqreturn_t pnx8xxx_int(int irq, 
 	/* Get the interrupts */
 	status  = serial_in(sport, PNX8XXX_ISTAT) & serial_in(sport, PNX8XXX_IEN);
 
-	/* Break signal received */
-	if (status & PNX8XXX_UART_INT_BREAK) {
-		sport->port.icount.brk++;
-		uart_handle_break(&sport->port);
-	}
