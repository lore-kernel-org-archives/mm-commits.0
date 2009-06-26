From: akpm@linux-foundation.org
Subject: [merged] serial-8250c-irq-handling-race-and-spurious-iir-read.patch removed from -mm tree
Date: Fri, 26 Jun 2009 11:21:59 -0700
Message-ID: <200906261821.n5QILxIc012666@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37619 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754698AbZFZSWX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jun 2009 14:22:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ian.jackson@eu.citrix.com, alan@lxorguk.ukuu.org.uk, armbru@redhat.com, mm-commits@vger.kernel.org


The patch titled
     serial/8250.c: IRQ handling race and spurious IIR read
has been removed from the -mm tree.  Its filename was
     serial-8250c-irq-handling-race-and-spurious-iir-read.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial/8250.c: IRQ handling race and spurious IIR read
From: Ian Jackson <ian.jackson@eu.citrix.com>

Do not read IIR in serial8250_start_tx when UART_BUG_TXEN

Reading the IIR clears some oustanding interrupts so it is not safe.
Instead, simply transmit immediately if the buffer is empty without
regard to IIR.

Signed-off-by: Ian Jackson <ian.jackson@eu.citrix.com>
Reviewed-by: Markus Armbruster <armbru@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/serial/8250.c~serial-8250c-irq-handling-race-and-spurious-iir-read drivers/serial/8250.c
--- a/drivers/serial/8250.c~serial-8250c-irq-handling-race-and-spurious-iir-read
+++ a/drivers/serial/8250.c
@@ -1337,14 +1337,12 @@ static void serial8250_start_tx(struct u
 		serial_out(up, UART_IER, up->ier);
 
 		if (up->bugs & UART_BUG_TXEN) {
-			unsigned char lsr, iir;
+			unsigned char lsr;
 			lsr = serial_in(up, UART_LSR);
 			up->lsr_saved_flags |= lsr & LSR_SAVE_FLAGS;
-			iir = serial_in(up, UART_IIR) & 0x0f;
 			if ((up->port.type == PORT_RM9000) ?
-				(lsr & UART_LSR_THRE &&
-				(iir == UART_IIR_NO_INT || iir == UART_IIR_THRI)) :
-				(lsr & UART_LSR_TEMT && iir & UART_IIR_NO_INT))
+				(lsr & UART_LSR_THRE) :
+				(lsr & UART_LSR_TEMT))
 				transmit_chars(up);
 		}
 	}
_

Patches currently in -mm which might be from ian.jackson@eu.citrix.com are

linux-next.patch

