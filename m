From: akpm@linux-foundation.org
Subject: + driver_bfin_serial_core-update.patch added to -mm tree
Date: Thu, 01 Mar 2007 00:48:28 -0800
Message-ID: <200703010848.l218mSod008810@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34712 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933138AbXCAIsl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 03:48:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@analog.com, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, rmk+lkml@arm.linux.org.uk


The patch titled
     Blackfin: on-chip serial driver update
has been added to the -mm tree.  Its filename is
     driver_bfin_serial_core-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

blackfin-Documentation.patch
blackfin-arch.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
blackfin-on-chip-ethernet-mac-controller-driver.patch
blackfin-patch-add-blackfin-support-in-smc91x.patch
blackfin-on-chip-rtc-controller-driver.patch
