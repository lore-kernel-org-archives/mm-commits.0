From: akpm@linux-foundation.org
Subject: - atmel_spi-dma-address-bugfix.patch removed from -mm tree
Date: Fri, 01 Jun 2007 10:48:02 -0700
Message-ID: <200706011748.l51Hm14w015170@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:47132 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761446AbXFARsP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 13:48:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hskinnemoen@atmel.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     atmel_spi dma address bugfix
has been removed from the -mm tree.  Its filename was
     atmel_spi-dma-address-bugfix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: atmel_spi dma address bugfix
From: Haavard Skinnemoen <hskinnemoen@atmel.com>

When either rx_buf or tx_buf is not being used, i.e.  for plain read- or
write operations, the atmel_spi uses a fixed-size DMA buffer instead.  If
the transfer is longer than the size of this buffer, it is split into
multiple DMA transfers.

When the transfer is split like this, the atmel_spi driver ends up using
the same DMA address again and again even for the buffer that came from the
user, which is of course wrong.  Fix this by adding the number of bytes
already transferred to the DMA address so that the data ends up in the
right place.

Thanks to Wu Xuan for discovering this bug.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/atmel_spi.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/spi/atmel_spi.c~atmel_spi-dma-address-bugfix drivers/spi/atmel_spi.c
--- a/drivers/spi/atmel_spi.c~atmel_spi-dma-address-bugfix
+++ a/drivers/spi/atmel_spi.c
@@ -113,16 +113,16 @@ static void atmel_spi_next_xfer(struct s
 
 	len = as->remaining_bytes;
 
-	tx_dma = xfer->tx_dma;
-	rx_dma = xfer->rx_dma;
+	tx_dma = xfer->tx_dma + xfer->len - len;
+	rx_dma = xfer->rx_dma + xfer->len - len;
 
 	/* use scratch buffer only when rx or tx data is unspecified */
-	if (rx_dma == INVALID_DMA_ADDRESS) {
+	if (!xfer->rx_buf) {
 		rx_dma = as->buffer_dma;
 		if (len > BUFFER_SIZE)
 			len = BUFFER_SIZE;
 	}
-	if (tx_dma == INVALID_DMA_ADDRESS) {
+	if (!xfer->tx_buf) {
 		tx_dma = as->buffer_dma;
 		if (len > BUFFER_SIZE)
 			len = BUFFER_SIZE;
_

Patches currently in -mm which might be from hskinnemoen@atmel.com are

origin.patch
lots-of-architectures-enable-arbitary-speed-tty-support.patch
git-avr32.patch
