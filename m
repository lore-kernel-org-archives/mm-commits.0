From: akpm@linux-foundation.org
Subject: [merged] blackfin-spi-driver-use-len_in_bytes-when-we-care-about-the-number-of-bytes-transferred.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:06:24 -0700
Message-ID: <200904071906.n37J6OTH010795@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57409 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756401AbZDGTLV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:11:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, cooloney@kernel.org, david-b@pacbell.net, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     Blackfin SPI Driver: use len_in_bytes when we care about the number of bytes transferred
has been removed from the -mm tree.  Its filename was
     blackfin-spi-driver-use-len_in_bytes-when-we-care-about-the-number-of-bytes-transferred.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Blackfin SPI Driver: use len_in_bytes when we care about the number of bytes transferred
From: Mike Frysinger <vapier.adi@gmail.com>

Use len_in_bytes when we care about the number of bytes transferred rather
than the number of spi transactions.  (this value will be the same for
8bit transfers, but not any other sizes)

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-use-len_in_bytes-when-we-care-about-the-number-of-bytes-transferred drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-use-len_in_bytes-when-we-care-about-the-number-of-bytes-transferred
+++ a/drivers/spi/spi_bfin5xx.c
@@ -804,7 +804,7 @@ static void pump_transfers(unsigned long
 			if (bfin_addr_dcachable((unsigned long) drv_data->rx))
 				invalidate_dcache_range((unsigned long) drv_data->rx,
 							(unsigned long) (drv_data->rx +
-							drv_data->len));
+							drv_data->len_in_bytes));
 
 			/* clear tx reg soformer data is not shifted out */
 			write_TDBR(drv_data, 0xFFFF);
@@ -830,7 +830,7 @@ static void pump_transfers(unsigned long
 			if (bfin_addr_dcachable((unsigned long) drv_data->tx))
 				flush_dcache_range((unsigned long) drv_data->tx,
 						(unsigned long) (drv_data->tx +
-						drv_data->len));
+						drv_data->len_in_bytes));
 
 			/* start dma */
 			dma_enable_irq(drv_data->dma_channel);
@@ -893,7 +893,7 @@ static void pump_transfers(unsigned long
 			message->state = ERROR_STATE;
 		} else {
 			/* Update total byte transfered */
-			message->actual_length += drv_data->len;
+			message->actual_length += drv_data->len_in_bytes;
 
 			/* Move to next transfer of this msg */
 			message->state = next_transfer(drv_data);
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

origin.patch
linux-next.patch

