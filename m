From: akpm@linux-foundation.org
Subject: [merged] atmel_serial-fix-hang-in-set_termios-when-crtscts-is-enabled.patch removed from -mm tree
Date: Mon, 15 Jun 2009 12:01:48 -0700
Message-ID: <200906151901.n5FJ1mT9023165@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761717AbZFOTB7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Jun 2009 15:01:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haavard.skinnemoen@atmel.com, alan@lxorguk.ukuu.org.uk, eaa@wprmedical.com, mm-commits@vger.kernel.org


The patch titled
     atmel_serial: fix hang in set_termios when crtscts is enabled
has been removed from the -mm tree.  Its filename was
     atmel_serial-fix-hang-in-set_termios-when-crtscts-is-enabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_serial: fix hang in set_termios when crtscts is enabled
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

After enabling hardware flow control, any subsequent termios call may hang
waiting for the transmitter to drain.  This appears to be caused by a
busy-loop in set_termios() waiting for the transmitter to become empty,
which may take a very long time (or hang indefinitely) if the device at
the other end is blocking us.

A quick look through the tty and serial_core code indicates that any
necessary flushing (which is optional) has already been done at this
point, so there's no need for the driver to flush the transmitter on its
own.

Fix it by removing the busy-loop altogether.

Tested-by: Eirik Aanonsen <eaa@wprmedical.com>
Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/atmel_serial.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/serial/atmel_serial.c~atmel_serial-fix-hang-in-set_termios-when-crtscts-is-enabled drivers/serial/atmel_serial.c
--- a/drivers/serial/atmel_serial.c~atmel_serial-fix-hang-in-set_termios-when-crtscts-is-enabled
+++ a/drivers/serial/atmel_serial.c
@@ -1104,11 +1104,13 @@ static void atmel_set_termios(struct uar
 	/* update the per-port timeout */
 	uart_update_timeout(port, termios->c_cflag, baud);
 
-	/* save/disable interrupts and drain transmitter */
+	/*
+	 * save/disable interrupts. The tty layer will ensure that the
+	 * transmitter is empty if requested by the caller, so there's
+	 * no need to wait for it here.
+	 */
 	imr = UART_GET_IMR(port);
 	UART_PUT_IDR(port, -1);
-	while (!(UART_GET_CSR(port) & ATMEL_US_TXEMPTY))
-		cpu_relax();
 
 	/* disable receiver and transmitter */
 	UART_PUT_CR(port, ATMEL_US_TXDIS | ATMEL_US_RXDIS);
_

Patches currently in -mm which might be from haavard.skinnemoen@atmel.com are

origin.patch
linux-next.patch
atmel-lcdc-fix-pixclock-upper-bound-detection.patch
ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa.patch

