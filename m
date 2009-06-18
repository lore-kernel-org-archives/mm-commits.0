From: akpm@linux-foundation.org
Subject: [merged] pxa2xx_spi-fix-for-spi_cs_high.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:44:09 -0700
Message-ID: <200906182244.n5IMi9Ro003249@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52354 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758302AbZFRWoO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:44:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: drwyrm@gmail.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     pxa2xx_spi: fix for SPI_CS_HIGH
has been removed from the -mm tree.  Its filename was
     pxa2xx_spi-fix-for-spi_cs_high.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pxa2xx_spi: fix for SPI_CS_HIGH
From: Daniel Ribeiro <drwyrm@gmail.com>

Commit a7bb3909b3293d503211d7f6af8ed62c1644b686 ("spi: pxa2xx_spi:
introduce chipselect GPIO to simplify the common cases") introduces
chipselect GPIO, and configures the CS polarity using SPI_CS_HIGH
spi->mode flag.  Add SPI_CS_HIGH to the allowed modes.

Signed-off-by: Daniel Ribeiro <drwyrm@gmail.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/pxa2xx_spi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/spi/pxa2xx_spi.c~pxa2xx_spi-fix-for-spi_cs_high drivers/spi/pxa2xx_spi.c
--- a/drivers/spi/pxa2xx_spi.c~pxa2xx_spi-fix-for-spi_cs_high
+++ a/drivers/spi/pxa2xx_spi.c
@@ -1485,7 +1485,7 @@ static int __init pxa2xx_spi_probe(struc
 	drv_data->ssp = ssp;
 
 	/* the spi->mode bits understood by this driver: */
-	master->mode_bits = SPI_CPOL | SPI_CPHA;
+	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH;
 
 	master->bus_num = pdev->id;
 	master->num_chipselect = platform_info->num_chipselect;
_

Patches currently in -mm which might be from drwyrm@gmail.com are

origin.patch
linux-next.patch

