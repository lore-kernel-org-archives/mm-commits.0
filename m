From: akpm@linux-foundation.org
Subject: [merged] blackfin-serial-driver-fix-compile-error-in-pio-mode.patch removed from -mm tree
Date: Thu, 12 Mar 2009 13:17:09 -0700
Message-ID: <200903122017.n2CKH9jf032644@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39608 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751191AbZCLUUO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Mar 2009 16:20:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sonic.zhang@analog.com, alan@lxorguk.ukuu.org.uk, cooloney@kernel.org, mm-commits@vger.kernel.org


The patch titled
     blackfin serial driver: fix compile error in PIO mode
has been removed from the -mm tree.  Its filename was
     blackfin-serial-driver-fix-compile-error-in-pio-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: blackfin serial driver: fix compile error in PIO mode
From: Sonic Zhang <sonic.zhang@analog.com>

drivers/serial/bfin_5xx.c: In function bfin_serial_rx_chars:
drivers/serial/bfin_5xx.c:178: error: struct uart_info has no
member
named tty
make[3]: *** [drivers/serial/bfin_5xx.o] Error 1
make[2]: *** [drivers/serial] Error 2
make[1]: *** [drivers] Error 2
make[1]: *** Waiting for unfinished jobs....
make[1]: Leaving directory `/root/projects/uClinux-dist/linux-2.6.x'
make: *** [linux] Error 1

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/bfin_5xx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/serial/bfin_5xx.c~blackfin-serial-driver-fix-compile-error-in-pio-mode drivers/serial/bfin_5xx.c
--- a/drivers/serial/bfin_5xx.c~blackfin-serial-driver-fix-compile-error-in-pio-mode
+++ a/drivers/serial/bfin_5xx.c
@@ -172,10 +172,10 @@ static void bfin_serial_rx_chars(struct 
 			return;
 		}
 
-	if (!uart->port.info || !uart->port.info->tty)
+	if (!uart->port.info || !uart->port.info->port.tty)
 		return;
 #endif
-	tty = uart->port.info->tty;
+	tty = uart->port.info->port.tty;
 
 	if (ANOMALY_05000363) {
 		/* The BF533 (and BF561) family of processors have a nice anomaly
_

Patches currently in -mm which might be from sonic.zhang@analog.com are

origin.patch
linux-next.patch
blackfin-serial-driver-change-hardware-flowcontrol-from-poll-to-interrupt-driven.patch
blackfin-serial-driver-fix-bug-serial-port-transfer-big-file-from-host-to-target-would-have-more-lines.patch
blackfin-serial-driver-fix-bug-enable-hardware-based-cts-and-rts-for-bf548.patch

