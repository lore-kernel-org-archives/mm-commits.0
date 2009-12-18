From: akpm@linux-foundation.org
Subject: [merged] atmel_spi-fix-dma-addr-calculation-for-len-buffer_size.patch removed from -mm tree
Date: Fri, 18 Dec 2009 12:27:18 -0800
Message-ID: <200912182027.nBIKRIBQ016621@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35752 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932860AbZLRU1x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Dec 2009 15:27:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bn@niasdigital.com, dbrownell@users.sourceforge.net, hskinnemoen@atmel.com, mm-commits@vger.kernel.org


The patch titled
     atmel_spi: fix dma addr calculation for len > BUFFER_SIZE
has been removed from the -mm tree.  Its filename was
     atmel_spi-fix-dma-addr-calculation-for-len-buffer_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_spi: fix dma addr calculation for len > BUFFER_SIZE
From: Ben Nizette <bn@niasdigital.com>

If len > BUFFER_LEN and !xfer->rx_buf we end up calculating the tx buffer
address as

*tx_dma = xfer->tx_dma + xfer->len - BUFFER_SIZE;

which is constant; i.e.  we just send the last BUFFER_SIZE data over again
until we've reached the right number of bytes.

This patch gets around this by using the /requested/ length when
calculating addresses.

Note there's no way len != *plen when we calculate the rx buffer address
but conceptually we should be using *plen and I don't want someone to come
through later, see the calculations for rx and tx are different and "clean
up" back to what we had.

Signed-off-by: Ben Nizette <bn@niasdigital.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/atmel_spi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/spi/atmel_spi.c~atmel_spi-fix-dma-addr-calculation-for-len-buffer_size drivers/spi/atmel_spi.c
--- a/drivers/spi/atmel_spi.c~atmel_spi-fix-dma-addr-calculation-for-len-buffer_size
+++ a/drivers/spi/atmel_spi.c
@@ -189,14 +189,14 @@ static void atmel_spi_next_xfer_data(str
 
 	/* use scratch buffer only when rx or tx data is unspecified */
 	if (xfer->rx_buf)
-		*rx_dma = xfer->rx_dma + xfer->len - len;
+		*rx_dma = xfer->rx_dma + xfer->len - *plen;
 	else {
 		*rx_dma = as->buffer_dma;
 		if (len > BUFFER_SIZE)
 			len = BUFFER_SIZE;
 	}
 	if (xfer->tx_buf)
-		*tx_dma = xfer->tx_dma + xfer->len - len;
+		*tx_dma = xfer->tx_dma + xfer->len - *plen;
 	else {
 		*tx_dma = as->buffer_dma;
 		if (len > BUFFER_SIZE)
_

Patches currently in -mm which might be from bn@niasdigital.com are


