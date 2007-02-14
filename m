From: akpm@linux-foundation.org
Subject: - spi-atmel_spi-driver-fix.patch removed from -mm tree
Date: Tue, 13 Feb 2007 22:50:17 -0800
Message-ID: <200702140650.l1E6oH6N023655@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43780 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbXBNGuX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 01:50:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dbrownell@users.sourceforge.net, hskinnemoen@atmel.com, mm-commits@vger.kernel.org


The patch titled
     spi-atmel_spi-driver-fix
has been removed from the -mm tree.  Its filename was
     spi-atmel_spi-driver-fix.patch

This patch was dropped because it was folded into spi-atmel_spi-driver.patch

------------------------------------------------------
Subject: spi-atmel_spi-driver-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/atmel_spi.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/spi/atmel_spi.c~spi-atmel_spi-driver-fix drivers/spi/atmel_spi.c
--- a/drivers/spi/atmel_spi.c~spi-atmel_spi-driver-fix
+++ a/drivers/spi/atmel_spi.c
@@ -159,7 +159,6 @@ static void atmel_spi_next_xfer(struct s
 		xfer, xfer->len, xfer->tx_buf, xfer->tx_dma,
 		xfer->rx_buf, xfer->rx_dma, spi_readl(as, IMR));
 
-	wmb();
 	spi_writel(as, TCR, len);
 	spi_writel(as, RCR, len);
 	spi_writel(as, PTCR, SPI_BIT(TXTEN) | SPI_BIT(RXTEN));
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
spi-atmel_spi-driver.patch
spi-atmel_spi-driver-fix.patch
revert-x86_64-mm-putreg-check.patch
git-gccbug-fixup.patch
