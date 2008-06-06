From: akpm@linux-foundation.org
Subject: + 8250-fix-break-handling-for-intel-82571.patch added to -mm tree
Date: Fri, 06 Jun 2008 13:27:52 -0700
Message-ID: <200806062027.m56KRq7A017607@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42815 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753136AbYFFU2u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jun 2008 16:28:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arozansk@redhat.com, alan@lxorguk.ukuu.org.uk


The patch titled
     8250: fix break handling for Intel 82571
has been added to the -mm tree.  Its filename is
     8250-fix-break-handling-for-intel-82571.patch

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
Subject: 8250: fix break handling for Intel 82571
From: Aristeu Rozanski <arozansk@redhat.com>

Intel 82571 has a "Serial Over LAN" feature that doesn't properly
implements the receiving of break characters.  When a break is received,
it doesn't set UART_LSR_DR and unless another character is received, the
break won't be received by the application.

Signed-off-by: Aristeu Rozanski <arozansk@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff -puN drivers/serial/8250.c~8250-fix-break-handling-for-intel-82571 drivers/serial/8250.c
--- a/drivers/serial/8250.c~8250-fix-break-handling-for-intel-82571
+++ a/drivers/serial/8250.c
@@ -1295,7 +1295,18 @@ receive_chars(struct uart_8250_port *up,
 	char flag;
 
 	do {
-		ch = serial_inp(up, UART_RX);
+		if (likely(lsr & UART_LSR_DR))
+			ch = serial_inp(up, UART_RX);
+		else
+			/*
+			 * Intel 82571 has a Serial Over Lan device that will
+			 * set UART_LSR_BI without setting UART_LSR_DR when
+			 * it receives a break. To avoid reading from the
+			 * receive buffer without UART_LSR_DR bit set, we
+			 * just force the read character to be 0
+			 */
+			ch = 0;
+
 		flag = TTY_NORMAL;
 		up->port.icount.rx++;
 
@@ -1344,7 +1355,7 @@ receive_chars(struct uart_8250_port *up,
 
 ignore_char:
 		lsr = serial_inp(up, UART_LSR);
-	} while ((lsr & UART_LSR_DR) && (max_count-- > 0));
+	} while ((lsr & (UART_LSR_DR | UART_LSR_BI)) && (max_count-- > 0));
 	spin_unlock(&up->port.lock);
 	tty_flip_buffer_push(tty);
 	spin_lock(&up->port.lock);
@@ -1427,7 +1438,7 @@ serial8250_handle_port(struct uart_8250_
 
 	DEBUG_INTR("status = %x...", status);
 
-	if (status & UART_LSR_DR)
+	if (status & (UART_LSR_DR | UART_LSR_BI))
 		receive_chars(up, &status);
 	check_modem_status(up);
 	if (status & UART_LSR_THRE)
_

Patches currently in -mm which might be from arozansk@redhat.com are

8250-fix-break-handling-for-intel-82571.patch

