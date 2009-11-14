From: akpm@linux-foundation.org
Subject: + 8250-add-serial-transmitter-fully-empty-test.patch added to -mm tree
Date: Fri, 13 Nov 2009 16:14:14 -0800
Message-ID: <200911140014.nAE0EEea026652@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48334 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757252AbZKNAOW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Nov 2009 19:14:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dick@softplc.com, alan@linux.intel.com, k.schoenmakers@sigmae.nl


The patch titled
     8250: add serial transmitter fully empty test
has been added to the -mm tree.  Its filename is
     8250-add-serial-transmitter-fully-empty-test.patch

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
Subject: 8250: add serial transmitter fully empty test
From: Dick Hollenbeck <dick@softplc.com>

When controlling an industrial radio modem it can be necessary to
manipulate the handshake lines in order to control the radio modem's
transmitter, from userspace.

The transmitter should not be turned off before all characters have been
transmitted.  serial8250_tx_empty() was reporting that all characters were
transmitted before they actually were.

===

Discovered in parallel with more testing and analysis by Kees Schoenmakers
as follows:

I ran into an NetMos 9835 serial pci board which behaves a little
different than the standard.  This type of expansion board is very common.

"Standard" 8250 compatible devices clear the 'UART_LST_TEMT" bit together
with the "UART_LSR_THRE" bit when writing data to the device.

The NetMos device does it slightly different

I believe that the TEMT bit is coupled to the shift register.  The problem
is that after writing data to the device and very quickly after that one
does call serial8250_tx_empty, it returns the wrong information.

My patch makes the test more robust (and solves the problem) and it does
not affect the already correct devices.


Alan:

  We may yet need to quirk this but now we know which chips we have a
  way to do that should we find this breaks some other 8250 clone with
  dodgy THRE.

Signed-off-by: Dick Hollenbeck <dick@softplc.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Kees Schoenmakers <k.schoenmakers@sigmae.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/serial/8250.c~8250-add-serial-transmitter-fully-empty-test drivers/serial/8250.c
--- a/drivers/serial/8250.c~8250-add-serial-transmitter-fully-empty-test
+++ a/drivers/serial/8250.c
@@ -83,6 +83,9 @@ static unsigned int skip_txen_test; /* f
 
 #define PASS_LIMIT	256
 
+#define BOTH_EMPTY 	(UART_LSR_TEMT | UART_LSR_THRE)
+
+
 /*
  * We default to IRQ0 for the "no irq" hack.   Some
  * machine types want others as well - they're free
@@ -1788,7 +1791,7 @@ static unsigned int serial8250_tx_empty(
 	up->lsr_saved_flags |= lsr & LSR_SAVE_FLAGS;
 	spin_unlock_irqrestore(&up->port.lock, flags);
 
-	return lsr & UART_LSR_TEMT ? TIOCSER_TEMT : 0;
+	return (lsr & BOTH_EMPTY) == BOTH_EMPTY ? TIOCSER_TEMT : 0;
 }
 
 static unsigned int serial8250_get_mctrl(struct uart_port *port)
@@ -1846,8 +1849,6 @@ static void serial8250_break_ctl(struct 
 	spin_unlock_irqrestore(&up->port.lock, flags);
 }
 
-#define BOTH_EMPTY (UART_LSR_TEMT | UART_LSR_THRE)
