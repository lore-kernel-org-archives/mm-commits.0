From: akpm@linux-foundation.org
Subject: + altera_uart-simplify-altera_uart_console_putc.patch added to -mm tree
Date: Fri, 28 May 2010 13:39:40 -0700
Message-ID: <201005282039.o4SKdenJ012228@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38349 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756766Ab0E1Ujx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 May 2010 16:39:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tklauser@distanz.ch, alan@lxorguk.ukuu.org.uk, greg@kroah.com, thomas@wytron.com.tw


The patch titled
     altera_uart: simplify altera_uart_console_putc
has been added to the -mm tree.  Its filename is
     altera_uart-simplify-altera_uart_console_putc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: altera_uart: simplify altera_uart_console_putc
From: Tobias Klauser <tklauser@distanz.ch>

The check for the TRDY flag after writing the character is not needed.
Also do a cpu_relax() inside the loop.

Pass a struct uart_port to altera_uart_console_putc, so we do not need
to get it (and dereference pointers) for every character.

Cc: Thomas Chou <thomas@wytron.com.tw>
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/altera_uart.c |   23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff -puN drivers/serial/altera_uart.c~altera_uart-simplify-altera_uart_console_putc drivers/serial/altera_uart.c
--- a/drivers/serial/altera_uart.c~altera_uart-simplify-altera_uart_console_putc
+++ a/drivers/serial/altera_uart.c
@@ -391,31 +391,24 @@ int __init early_altera_uart_setup(struc
 	return 0;
 }
 
-static void altera_uart_console_putc(struct console *co, const char c)
+static void altera_uart_console_putc(struct uart_port *port, const char c)
 {
-	struct uart_port *port = &(altera_uart_ports + co->index)->port;
-	int i;
+	while (!(readl(port->membase + ALTERA_UART_STATUS_REG) &
+	         ALTERA_UART_STATUS_TRDY_MSK))
+		cpu_relax();
 
-	for (i = 0; i < 0x10000; i++) {
-		if (readl(port->membase + ALTERA_UART_STATUS_REG) &
-		    ALTERA_UART_STATUS_TRDY_MSK)
-			break;
-	}
 	writel(c, port->membase + ALTERA_UART_TXDATA_REG);
-	for (i = 0; i < 0x10000; i++) {
-		if (readl(port->membase + ALTERA_UART_STATUS_REG) &
-		    ALTERA_UART_STATUS_TRDY_MSK)
-			break;
-	}
 }
 
 static void altera_uart_console_write(struct console *co, const char *s,
 				      unsigned int count)
 {
+	struct uart_port *port = &(altera_uart_ports + co->index)->port;
+
 	for (; count; count--, s++) {
-		altera_uart_console_putc(co, *s);
+		altera_uart_console_putc(port, *s);
 		if (*s == '\n')
-			altera_uart_console_putc(co, '\r');
+			altera_uart_console_putc(port, '\r');
 	}
 }
 
_

Patches currently in -mm which might be from tklauser@distanz.ch are

origin.patch
linux-next.patch
altera_uart-dont-take-spinlock-in-already-protected-functions.patch
altera_uart-simplify-altera_uart_console_putc.patch

