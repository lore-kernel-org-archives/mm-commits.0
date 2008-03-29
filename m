From: akpm@linux-foundation.org
Subject: + atmel_serial-fix-uart-console-concurrent-access.patch added to -mm tree
Date: Sat, 29 Mar 2008 11:56:21 -0700
Message-ID: <200803291856.m2TIuLRc021603@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56994 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753413AbYC2S4u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 29 Mar 2008 14:56:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marc.pignat@hevs.ch, haavard.skinnemoen@atmel.com


The patch titled
     atmel_serial: fix uart/console concurrent access
has been added to the -mm tree.  Its filename is
     atmel_serial-fix-uart-console-concurrent-access.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_serial: fix uart/console concurrent access
From: Marc Pignat <marc.pignat@hevs.ch>

Strange chars appear on the serial port when a printk and a printf happens at
the same time.  This is caused by the pdc sending chars while
atmel_console_write (called from printk) is executing

Concurent access of uart and console to the same port leads to corrupted data
to be transmitted, so disable tx dma (PDC) while writing to the console.

Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>
Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/atmel_serial.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN drivers/serial/atmel_serial.c~atmel_serial-fix-uart-console-concurrent-access drivers/serial/atmel_serial.c
--- a/drivers/serial/atmel_serial.c~atmel_serial-fix-uart-console-concurrent-access
+++ a/drivers/serial/atmel_serial.c
@@ -107,6 +107,7 @@
 
 #define UART_PUT_TPR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_TPR)
 #define UART_PUT_TCR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_TCR)
+#define UART_GET_TCR(port)	__raw_readl((port)->membase + ATMEL_PDC_TCR)
 
 static int (*atmel_open_hook)(struct uart_port *);
 static void (*atmel_close_hook)(struct uart_port *);
@@ -1275,6 +1276,7 @@ static void atmel_console_write(struct c
 {
 	struct uart_port *port = &atmel_ports[co->index].uart;
 	unsigned int status, imr;
+	unsigned int pdc_tx;
 
 	/*
 	 * First, save IMR and then disable interrupts
@@ -1282,6 +1284,10 @@ static void atmel_console_write(struct c
 	imr = UART_GET_IMR(port);
 	UART_PUT_IDR(port, ATMEL_US_RXRDY | ATMEL_US_TXRDY);
 
+	/* Store PDC transmit status and disable it */
+	pdc_tx = UART_GET_PTSR(port) & ATMEL_PDC_TXTEN;
+	UART_PUT_PTCR(port, ATMEL_PDC_TXTDIS);
+
 	uart_console_write(port, s, count, atmel_console_putchar);
 
 	/*
@@ -1291,6 +1297,11 @@ static void atmel_console_write(struct c
 	do {
 		status = UART_GET_CSR(port);
 	} while (!(status & ATMEL_US_TXRDY));
+
+	/* Restore PDC transmit status */
+	if (pdc_tx)
+		UART_PUT_PTCR(port, ATMEL_PDC_TXTEN);
+
 	/* set interrupts back the way they were */
 	UART_PUT_IER(port, imr);
 }
_

Patches currently in -mm which might be from marc.pignat@hevs.ch are

atmel_serial-fix-uart-console-concurrent-access.patch

