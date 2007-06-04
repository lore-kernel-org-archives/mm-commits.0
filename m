From: akpm@linux-foundation.org
Subject: + atmel_serial-fix-break-handling.patch added to -mm tree
Date: Mon, 04 Jun 2007 12:35:04 -0700
Message-ID: <200706041935.l54JZ4RH011874@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48513 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750795AbXFDThy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 15:37:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hskinnemoen@atmel.com, akpm@linux-foundation.org, andrew@sanpeople.com, ivan.kuten@promwad.com, nicolas.ferre@rfo.atmel.com, patrice.vilchez@rfo.atmel.com, rmk@arm.linux.org.uk


The patch titled
     atmel_serial: fix break handling
has been added to the -mm tree.  Its filename is
     atmel_serial-fix-break-handling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: atmel_serial: fix break handling
From: Haavard Skinnemoen <hskinnemoen@atmel.com>

The RXBRK field in the AT91/AT32 USART status register has the
following definition according to e.g. the AT32AP7000 data sheet:

    RXBRK: Break Received/End of Break
    0: No Break received or End of Break detected since the last RSTSTA.
    1: Break Received or End of Break detected since the last RSTSTA.

Thus, for each break, the USART sets the RXBRK bit twice. This patch
modifies the driver to report the break event to the serial core only
once by keeping track of whether a break condition is currently
active. The break_active flag is reset as soon as a character is
received, so even if we miss the start-of-break interrupt this should
do the right thing.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Andrew Victor <andrew@sanpeople.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Ivan Kuten <ivan.kuten@promwad.com>
Cc: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Cc: Patrice Vilchez <patrice.vilchez@rfo.atmel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/atmel_serial.c |   32 ++++++++++++++++++++++++++++++--
 1 files changed, 30 insertions(+), 2 deletions(-)

diff -puN drivers/serial/atmel_serial.c~atmel_serial-fix-break-handling drivers/serial/atmel_serial.c
--- a/drivers/serial/atmel_serial.c~atmel_serial-fix-break-handling
+++ a/drivers/serial/atmel_serial.c
@@ -114,6 +114,7 @@ struct atmel_uart_port {
 	struct uart_port	uart;		/* uart */
 	struct clk		*clk;		/* uart clock */
 	unsigned short		suspended;	/* is port suspended? */
+	int			break_active;	/* break being received */
 };
 
 static struct atmel_uart_port atmel_ports[ATMEL_MAX_UART];
@@ -252,6 +253,7 @@ static void atmel_break_ctl(struct uart_
  */
 static void atmel_rx_chars(struct uart_port *port)
 {
+	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *) port;
 	struct tty_struct *tty = port->info->tty;
 	unsigned int status, ch, flg;
 
@@ -267,13 +269,29 @@ static void atmel_rx_chars(struct uart_p
 		 * note that the error handling code is
 		 * out of the main execution path
 		 */
-		if (unlikely(status & (ATMEL_US_PARE | ATMEL_US_FRAME | ATMEL_US_OVRE | ATMEL_US_RXBRK))) {
+		if (unlikely(status & (ATMEL_US_PARE | ATMEL_US_FRAME
+				       | ATMEL_US_OVRE | ATMEL_US_RXBRK)
+			     || atmel_port->break_active)) {
 			UART_PUT_CR(port, ATMEL_US_RSTSTA);	/* clear error */
-			if (status & ATMEL_US_RXBRK) {
+			if (status & ATMEL_US_RXBRK
+			    && !atmel_port->break_active) {
 				status &= ~(ATMEL_US_PARE | ATMEL_US_FRAME);	/* ignore side-effect */
 				port->icount.brk++;
+				atmel_port->break_active = 1;
+				UART_PUT_IER(port, ATMEL_US_RXBRK);
 				if (uart_handle_break(port))
 					goto ignore_char;
+			} else {
+				/*
+				 * This is either the end-of-break
+				 * condition or we've received at
+				 * least one character without RXBRK
+				 * being set. In both cases, the next
+				 * RXBRK will indicate start-of-break.
+				 */
+				UART_PUT_IDR(port, ATMEL_US_RXBRK);
+				status &= ~ATMEL_US_RXBRK;
+				atmel_port->break_active = 0;
 			}
 			if (status & ATMEL_US_PARE)
 				port->icount.parity++;
@@ -352,6 +370,16 @@ static irqreturn_t atmel_interrupt(int i
 		/* Interrupt receive */
 		if (pending & ATMEL_US_RXRDY)
 			atmel_rx_chars(port);
+		else if (pending & ATMEL_US_RXBRK) {
+			/*
+			 * End of break detected. If it came along
+			 * with a character, atmel_rx_chars will
+			 * handle it.
+			 */
+			UART_PUT_CR(port, ATMEL_US_RSTSTA);
+			UART_PUT_IDR(port, ATMEL_US_RXBRK);
+			atmel_port->break_active = 0;
+		}
 
 		// TODO: All reads to CSR will clear these interrupts!
 		if (pending & ATMEL_US_RIIC) port->icount.rng++;
_

Patches currently in -mm which might be from hskinnemoen@atmel.com are

origin.patch
lots-of-architectures-enable-arbitary-speed-tty-support.patch
git-avr32.patch
atmel_serial-fix-break-handling.patch
