From: akpm@linux-foundation.org
Subject: + atmel_serial-might-lose-modem-status-change.patch added to -mm tree
Date: Fri, 16 Jan 2009 12:30:00 -0800
Message-ID: <200901162030.n0GKU0kZ031586@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36607 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757928AbZAPUbk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 15:31:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, alan@lxorguk.ukuu.org.uk, haavard.skinnemoen@atmel.com, itai.levi.devel@gmail.com, linux@bohmer.net, marc.pignat@hevs.ch


The patch titled
     atmel_serial might lose modem status change
has been added to the -mm tree.  Its filename is
     atmel_serial-might-lose-modem-status-change.patch

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
Subject: atmel_serial might lose modem status change
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

I found a problem of handling of modem status of atmel_serial driver.

With the commit 1ecc26 ("atmel_serial: split the interrupt handler"),
handling of modem status signal was splitted into two parts.  The
atmel_tasklet_func() compares new status with irq_status_prev, but
irq_status_prev is not correct if signal status was changed while the port
is closed.

Here is a sequence to cause problem:

1. Remote side sets CTS (and DSR).
2. Local side close the port.
3. Local side clears RTS and DTR.
4. Remote side clears CTS and DSR.
5. Local side reopen the port.  hw_stopped becomes 1.
6. Local side sets RTS and DTR.
7. Remote side sets CTS and DSR.

Then CTS change interrupt can be received, but since CTS bit in
irq_status_prev and new status is same, uart_handle_cts_change() will not
be called (so hw_stopped will not be cleared, i.e.  cannot send any data).

I suppose irq_status_prev should be initialized at somewhere in open
sequence.

Itai Levi pointed out that we need to initialize atmel_port->irq_status
as well here. His analysis is as follows:

> Regarding the second part of the patch (which resets irq_status_prev),
> it turns out that both versions of the patch (mine and Atsushi's)
> still leave enough room for faulty behavior when opening the port.
>
> This is because we are not resetting both irq_status_prev and
> irq_status in atmel_startup() to CSR, which leads faulty behavior in
> the following sequences:
>
> First case:
> 1. closing the port while CTS line = 1 (TX not allowed)
> 2. setting CTS line = 0 (TX allowed)
> 3. opening the port
> 4. transmitting one char
> 5. Cannot transmit more chars, although CTS line is 0
>
> Second case:
> 1. closing the port while CTS line = 0 (TX allowed)
> 2. setting CTS line = 1 (TX not allowed)
> 3. opening the port
> 4. receiving some chars
> 5. Now we can transmit, although CTS line is 1
>
> This reason for this is that the tasklet is scheduled as a result of
> TX or RX interrupts (not a status change!), in steps 4 above. Inside
> the tasklet, the atmel_port->irq_status (which holds the value from
> the previous session) is compared to atmel_port->irq_status_prev.
> Hence, a status-change of the CTS line is faultily detected.
>
> Both cases were verified on 9260 hardware.

[haavard.skinnemoen@atmel.com: folded with patch from Itai Levi]
Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Remy Bohmer <linux@bohmer.net>
Cc: Marc Pignat <marc.pignat@hevs.ch>
Cc: Itai Levi <itai.levi.devel@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/atmel_serial.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/serial/atmel_serial.c~atmel_serial-might-lose-modem-status-change drivers/serial/atmel_serial.c
--- a/drivers/serial/atmel_serial.c~atmel_serial-might-lose-modem-status-change
+++ a/drivers/serial/atmel_serial.c
@@ -877,6 +877,10 @@ static int atmel_startup(struct uart_por
 		}
 	}
 
+	/* Save current CSR for comparison in atmel_tasklet_func() */
+	atmel_port->irq_status_prev = UART_GET_CSR(port);
+	atmel_port->irq_status = atmel_port->irq_status_prev;
+
 	/*
 	 * Finally, enable the serial port
 	 */
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
linux-next.patch
atmel_serial-might-lose-modem-status-change.patch

