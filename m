From: akpm@linux-foundation.org
Subject: - serial-8250-tighten-test-for-using-backup-timer.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:55:31 -0700
Message-ID: <200804282155.m3SLtVIV018109@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42792 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934141AbYD1Vzu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:55:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.williamson@hp.com, alan@lxorguk.ukuu.org.uk, rmk@arm.linux.org.uk, thomas@koeller.dyndns.org, mm-commits@vger.kernel.org


The patch titled
     serial 8250: tighten test for using backup timer
has been removed from the -mm tree.  Its filename was
     serial-8250-tighten-test-for-using-backup-timer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial 8250: tighten test for using backup timer
From: Alex Williamson <alex.williamson@hp.com>

Thomas Koeller had reported an issue where a device that had been making use
of the UART_BUG_TXEN code in the 8250 driver was mistakenly being caught by
the backup timer test, causing the device to work improperly.

To fix this, tighten the test requirements to enable the backup timer
workaround.

The backup timer is really meant to catch UARTs that don't re-assert the THRE
interrupt.  The expectation is that they do initially assert THRE.  This patch
clarifies the test.

Signed-off-by: Alex Williamson <alex.williamson@hp.com>
Cc: Thomas Koeller <thomas@koeller.dyndns.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/serial/8250.c~serial-8250-tighten-test-for-using-backup-timer drivers/serial/8250.c
--- a/drivers/serial/8250.c~serial-8250-tighten-test-for-using-backup-timer
+++ a/drivers/serial/8250.c
@@ -1868,6 +1868,7 @@ static int serial8250_startup(struct uar
 	}
 
 	if (is_real_interrupt(up->port.irq)) {
+		unsigned char iir1;
 		/*
 		 * Test for UARTs that do not reassert THRE when the
 		 * transmitter is idle and the interrupt has already
@@ -1881,7 +1882,7 @@ static int serial8250_startup(struct uar
 		wait_for_xmitr(up, UART_LSR_THRE);
 		serial_out_sync(up, UART_IER, UART_IER_THRI);
 		udelay(1); /* allow THRE to set */
-		serial_in(up, UART_IIR);
+		iir1 = serial_in(up, UART_IIR);
 		serial_out(up, UART_IER, 0);
 		serial_out_sync(up, UART_IER, UART_IER_THRI);
 		udelay(1); /* allow a working UART time to re-assert THRE */
@@ -1894,7 +1895,7 @@ static int serial8250_startup(struct uar
 		 * If the interrupt is not reasserted, setup a timer to
 		 * kick the UART on a regular basis.
 		 */
-		if (iir & UART_IIR_NO_INT) {
+		if (!(iir1 & UART_IIR_NO_INT) && (iir & UART_IIR_NO_INT)) {
 			pr_debug("ttyS%d - using backup timer\n", port->line);
 			up->timer.function = serial8250_backup_timeout;
 			up->timer.data = (unsigned long)up;
_

Patches currently in -mm which might be from alex.williamson@hp.com are

origin.patch

