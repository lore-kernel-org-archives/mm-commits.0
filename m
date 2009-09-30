From: akpm@linux-foundation.org
Subject: + atmel_spi-fix-dma-addr-calculation-for-len-buffer_size.patch added to -mm tree
Date: Wed, 30 Sep 2009 15:52:24 -0700
Message-ID: <200909302252.n8UMqO83018732@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54688 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752293AbZI3Wxd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Sep 2009 18:53:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bn@niasdigital.com, dbrownell@users.sourceforge.net, hskinnemoen@atmel.com


The patch titled
     atmel_spi: fix dma addr calculation for len > BUFFER_SIZE
has been added to the -mm tree.  Its filename is
     atmel_spi-fix-dma-addr-calculation-for-len-buffer_size.patch

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

atmel_spi-fix-dma-addr-calculation-for-len-buffer_size.patch

