From: akpm@linux-foundation.org
Subject: + atmel_spi-reload-rcr-before-tcr.patch added to -mm tree
Date: Fri, 07 Dec 2007 15:19:01 -0800
Message-ID: <200712072319.lB7NJ1dm008674@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38061 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901AbXLGXTX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Dec 2007 18:19:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rini@arvoo.nl, dbrownell@users.sourceforge.net, hskinnemoen@atmel.com


The patch titled
     atmel_spi: reload RCR before TCR
has been added to the -mm tree.  Its filename is
     atmel_spi-reload-rcr-before-tcr.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: atmel_spi: reload RCR before TCR
From: Rini van Zetten <rini@arvoo.nl>

We have a wifi module connected to the spi bus and got sometimes FIFO
overrun errors on the spi bus.

After some investigation i found that the driver loads the TCR (transmit
count) register before the RCR (receive count).  When the transfer list is
not empty the atmel_spi_next_message is called while tx and rx are enabled.
 As soon as the TCR is loaded, hardware starts transfer and causes a rx
fifo overrun because the RCR is not loaded yet.

Load the RCR before the TCR.  After this patch the fifo overrun disapears
at out setup.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Rini van Zetten <rini@arvoo.nl>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/atmel_spi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/spi/atmel_spi.c~atmel_spi-reload-rcr-before-tcr drivers/spi/atmel_spi.c
--- a/drivers/spi/atmel_spi.c~atmel_spi-reload-rcr-before-tcr
+++ a/drivers/spi/atmel_spi.c
@@ -195,8 +195,8 @@ static void atmel_spi_next_xfer(struct s
 		xfer, xfer->len, xfer->tx_buf, xfer->tx_dma,
 		xfer->rx_buf, xfer->rx_dma, spi_readl(as, IMR));
 
-	spi_writel(as, TCR, len);
 	spi_writel(as, RCR, len);
+	spi_writel(as, TCR, len);
 	spi_writel(as, PTCR, SPI_BIT(TXTEN) | SPI_BIT(RXTEN));
 }
 
_

Patches currently in -mm which might be from rini@arvoo.nl are

atmel_spi-reload-rcr-before-tcr.patch
