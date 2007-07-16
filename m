From: akpm@linux-foundation.org
Subject: - atmel_serial-fix-break-handling.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:55:41 -0700
Message-ID: <200707162055.l6GKtfCT001953@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45969 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759742AbXGPVVE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:21:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hskinnemoen@atmel.com, akpm@linux-foundation.org, andrew@sanpeople.com, ivan.kuten@promwad.com, nicolas.ferre@rfo.atmel.com, patrice.vilchez@rfo.atmel.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     atmel_serial: fix break handling
has been removed from the -mm tree.  Its filename was
     atmel_serial-fix-break-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 30 insertions(+), 2 deletions(-)

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
git-watchdog.patch
atmel_spi-minor-updates.patch
atmel_spi-dont-always-deselect-chip-between-messages.patch
rtc-make-example-code-jump-to-done-instead-of-return-when-ioctl-not-supported.patch
rtc-dev-return-enotty-in-ioctl-if-irq_set_freq-is-not-implemented-by-driver.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices.patch
