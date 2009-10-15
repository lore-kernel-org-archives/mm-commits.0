From: akpm@linux-foundation.org
Subject: + 8250-serial-transmitter-fully-empty-test.patch added to -mm tree
Date: Thu, 15 Oct 2009 14:24:00 -0700
Message-ID: <200910152124.n9FLO0Rt003852@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37748 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933339AbZJOVYx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Oct 2009 17:24:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dick@softplc.com, alan@lxorguk.ukuu.org.uk, rmk@arm.linux.org.uk


The patch titled
     8250: fix serial transmitter fully empty test
has been added to the -mm tree.  Its filename is
     8250-serial-transmitter-fully-empty-test.patch

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
Subject: 8250: fix serial transmitter fully empty test
From: Dick Hollenbeck <dick@softplc.com>

When controlling an industrial radio modem it can be necessary to
manipulate the handshake lines in order to control the radio modem's
transmitter, from userspace.

The transmitter should not be turned off before all characters have been
transmitted.  serial8250_tx_empty() was reporting that all characters were
transmitted before they actually were.

Signed-off-by: Dick Hollenbeck <dick@softplc.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/serial/8250.c~8250-serial-transmitter-fully-empty-test drivers/serial/8250.c
--- a/drivers/serial/8250.c~8250-serial-transmitter-fully-empty-test
+++ a/drivers/serial/8250.c
@@ -83,6 +83,9 @@ static unsigned int skip_txen_test; /* f
 
 #define PASS_LIMIT	256
 
+#define BOTH_EMPTY 	(UART_LSR_TEMT | UART_LSR_THRE)
+
+
 /*
  * We default to IRQ0 for the "no irq" hack.   Some
  * machine types want others as well - they're free
@@ -1794,7 +1797,7 @@ static unsigned int serial8250_tx_empty(
 	up->lsr_saved_flags |= lsr & LSR_SAVE_FLAGS;
 	spin_unlock_irqrestore(&up->port.lock, flags);
 
-	return lsr & UART_LSR_TEMT ? TIOCSER_TEMT : 0;
+	return (lsr & BOTH_EMPTY) == BOTH_EMPTY ? TIOCSER_TEMT : 0;
 }
 
 static unsigned int serial8250_get_mctrl(struct uart_port *port)
@@ -1852,8 +1855,6 @@ static void serial8250_break_ctl(struct 
 	spin_unlock_irqrestore(&up->port.lock, flags);
 }
 
-#define BOTH_EMPTY (UART_LSR_TEMT | UART_LSR_THRE)
