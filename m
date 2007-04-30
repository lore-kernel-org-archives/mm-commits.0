From: akpm@linux-foundation.org
Subject: - driver_bfin_serial_core-update.patch removed from -mm tree
Date: Mon, 30 Apr 2007 12:14:10 -0700
Message-ID: <200704301914.l3UJEAKX012557@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56342 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946667AbXD3TO0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 15:14:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bryan.wu@analog.com, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, rmk+lkml@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Blackfin: on-chip serial driver update
has been removed from the -mm tree.  Its filename was
     driver_bfin_serial_core-update.patch

This patch was dropped because it was folded into driver_bfin_serial_core.patch

------------------------------------------------------
Subject: Blackfin: on-chip serial driver update
From: "Wu, Bryan" <bryan.wu@analog.com>

Undocumented changes to driver_bfin_serial_core.patch

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/bfin_5xx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/serial/bfin_5xx.c~driver_bfin_serial_core-update drivers/serial/bfin_5xx.c
--- a/drivers/serial/bfin_5xx.c~driver_bfin_serial_core-update
+++ a/drivers/serial/bfin_5xx.c
@@ -121,7 +121,7 @@ static void bfin_serial_stop_rx(struct u
 	unsigned short ier;
 
 	ier = UART_GET_IER(uart);
-	ier &= ERBFI;
+	ier &= ~ERBFI;
 	UART_PUT_IER(uart, ier);
 }
 
@@ -606,7 +606,7 @@ bfin_serial_set_termios(struct uart_port
 			__FUNCTION__);
 	}
 
-	if (termios->c_cflag & CSTOPB);
+	if (termios->c_cflag & CSTOPB)
 		lcr |= STB;
 	if (termios->c_cflag & PARENB) {
 		lcr |= PEN;
_

Patches currently in -mm which might be from bryan.wu@analog.com are

origin.patch
blackfin-arch.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
blackfin-on-chip-ethernet-mac-controller-driver.patch
blackfin-on-chip-ethernet-mac-controller-driver-update.patch
blackfin-patch-add-blackfin-support-in-smc91x.patch
blackfin-on-chip-rtc-controller-driver.patch
blackfin-on-chip-rtc-controller-driver-fix-rtc_update_irq-augument.patch
blackfin-blackfin-on-chip-spi-controller-driver.patch
blackfin-blackfin-on-chip-spi-controller-driver-cleanup-and-coding-style-fixing.patch
blackfin-blackfin-on-chip-spi-controller-driver-fix-reboot-kernel-mounting-spi-flash-print-error-bug.patch
blackfin-spi-controller-driver-update-according-to-david-brownells-review.patch
blackfin-serial-core-driver-uart1-should-depend-on-bf534-bf536-bf537-remove-experimental-marking-from-on-chip-serial-core-driver-and-make-options-less-wordy.patch
move-die-notifier-handling-to-common-code-fix.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
revoke-core-code-generic_file_revoke-stub-for-nommu.patch
vdso-print-fatal-signals-fix-compiling-error-bug-in.patch
