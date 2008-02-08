From: akpm@linux-foundation.org
Subject: - atmel_serial-fix-broken-rx-buffer-allocation.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:18:40 -0800
Message-ID: <200802082018.m18KILWp010915@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44366 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751138AbYBHUsg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:48:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hskinnemoen@atmel.com, trimarchi@gandalf.sssup.it, mm-commits@vger.kernel.org


The patch titled
     atmel_serial: fix broken RX buffer allocation
has been removed from the -mm tree.  Its filename was
     atmel_serial-fix-broken-rx-buffer-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_serial: fix broken RX buffer allocation
From: Haavard Skinnemoen <hskinnemoen@atmel.com>

Introduced by atmel_serial-split-the-interrupt-handler.patch.

Thanks to michael <trimarchi@gandalf.sssup.it> for spotting it.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/atmel_serial.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/serial/atmel_serial.c~atmel_serial-fix-broken-rx-buffer-allocation drivers/serial/atmel_serial.c
--- a/drivers/serial/atmel_serial.c~atmel_serial-fix-broken-rx-buffer-allocation
+++ a/drivers/serial/atmel_serial.c
@@ -1469,7 +1469,8 @@ static int __devinit atmel_serial_probe(
 
 	if (!atmel_use_dma_rx(&port->uart)) {
 		ret = -ENOMEM;
-		data = kmalloc(ATMEL_SERIAL_RINGSIZE, GFP_KERNEL);
+		data = kmalloc(sizeof(struct atmel_uart_char)
+				* ATMEL_SERIAL_RINGSIZE, GFP_KERNEL);
 		if (!data)
 			goto err_alloc_ring;
 		port->rx_ring.buf = data;
_

Patches currently in -mm which might be from hskinnemoen@atmel.com are

origin.patch
git-avr32.patch
