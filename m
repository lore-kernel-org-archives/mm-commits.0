From: akpm@linux-foundation.org
Subject: + atmel_serial-might-lose-modem-status-change-fix.patch added to -mm tree
Date: Tue, 13 Jan 2009 14:06:03 -0800
Message-ID: <200901132206.n0DM63oQ012129@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50732 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753324AbZAMWGj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 17:06:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haavard.skinnemoen@atmel.com, anemo@mba.ocn.ne.jp


The patch titled
     atmel_serial-might-lose-modem-status-change fix
has been added to the -mm tree.  Its filename is
     atmel_serial-might-lose-modem-status-change-fix.patch

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
Subject: atmel_serial-might-lose-modem-status-change fix
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

...Itai Levi pointed out that we need to initialize
atmel_port->irq_status as well here. His analysis is as follows:

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
>
> The solution for this, is to reset both irq_status_prev and irq_status
> to the value of CSR in atmel_startup().
>
> Here is my updated patch (you can ignore the first part which you
> already accepted):

Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/atmel_serial.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/serial/atmel_serial.c~atmel_serial-might-lose-modem-status-change-fix drivers/serial/atmel_serial.c
--- a/drivers/serial/atmel_serial.c~atmel_serial-might-lose-modem-status-change-fix
+++ a/drivers/serial/atmel_serial.c
@@ -805,6 +805,9 @@ static int atmel_startup(struct uart_por
 	 */
 	UART_PUT_IDR(port, -1);
 
+	atmel_port->irq_status_prev = UART_GET_CSR(port);
+	atmel_port->irq_status = atmel_port->irq_status_prev;
+
 	/*
 	 * Allocate the IRQ
 	 */
_

Patches currently in -mm which might be from haavard.skinnemoen@atmel.com are

atmel_serial-fix-flow-control-bug.patch
atmel_spi-allow-transfer-when-max_speed_hz-=-0.patch
atmel_serial-might-lose-modem-status-change-fix.patch

