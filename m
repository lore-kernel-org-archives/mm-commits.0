From: akpm@linux-foundation.org
Subject: + atmel_serial-might-lose-modem-status-change.patch added to -mm tree
Date: Fri, 14 Nov 2008 13:27:29 -0800
Message-ID: <200811142127.mAELRT3W027635@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58452 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753679AbYKNV3V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Nov 2008 16:29:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, hskinnemoen@atmel.com, linux@bohmer.net, marc.pignat@hevs.ch


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

Acked-by: Remy Bohmer <linux@bohmer.net>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Marc Pignat <marc.pignat@hevs.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/atmel_serial.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/serial/atmel_serial.c~atmel_serial-might-lose-modem-status-change drivers/serial/atmel_serial.c
--- a/drivers/serial/atmel_serial.c~atmel_serial-might-lose-modem-status-change
+++ a/drivers/serial/atmel_serial.c
@@ -877,6 +877,9 @@ static int atmel_startup(struct uart_por
 		}
 	}
 
+	/* Save current CSR for comparison in atmel_tasklet_func() */
+	atmel_port->irq_status_prev = UART_GET_CSR(port);
+
 	/*
 	 * Finally, enable the serial port
 	 */
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

linux-next.patch
physmap-make-map_info-customizable.patch
physmap-fix-leak-of-memory-returned-by-parse_mtd_partitions.patch
physmap-fix-memory-leak-on-physmap_flash_remove-by-using-devres.patch
atmel_serial-might-lose-modem-status-change.patch

