From: akpm@linux-foundation.org
Subject: + spi-fix-spi_imx-probe-oopsing.patch added to -mm tree
Date: Sat, 22 Nov 2008 13:13:26 -0800
Message-ID: <200811222113.mAMLDQfO022889@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52756 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752866AbYKVVNx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 22 Nov 2008 16:13:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julien.boibessot@free.fr, dbrownell@users.sourceforge.net, julien.boibessot@armadeus.com, s.hauer@pengutronix.de


The patch titled
     spi: fix spi_imx probe oopsing
has been added to the -mm tree.  Its filename is
     spi-fix-spi_imx-probe-oopsing.patch

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
Subject: spi: fix spi_imx probe oopsing
From: Julien Boibessot <julien.boibessot@free.fr>

Corrects spi_imx driver oops during initialization/probing: can't use
drv_data before it's allocated.

Signed-off-by: Julien Boibessot <julien.boibessot@armadeus.com>
Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_imx.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff -puN drivers/spi/spi_imx.c~spi-fix-spi_imx-probe-oopsing drivers/spi/spi_imx.c
--- a/drivers/spi/spi_imx.c~spi-fix-spi_imx-probe-oopsing
+++ a/drivers/spi/spi_imx.c
@@ -1456,7 +1456,7 @@ static int __init spi_imx_probe(struct p
 	struct device *dev = &pdev->dev;
 	struct spi_imx_master *platform_info;
 	struct spi_master *master;
-	struct driver_data *drv_data = NULL;
+	struct driver_data *drv_data;
 	struct resource *res;
 	int irq, status = 0;
 
@@ -1467,14 +1467,6 @@ static int __init spi_imx_probe(struct p
 		goto err_no_pdata;
 	}
 
-	drv_data->clk = clk_get(&pdev->dev, "perclk2");
-	if (IS_ERR(drv_data->clk)) {
-		dev_err(&pdev->dev, "probe - cannot get get\n");
-		status = PTR_ERR(drv_data->clk);
-		goto err_no_clk;
-	}
-	clk_enable(drv_data->clk);
-
 	/* Allocate master with space for drv_data */
 	master = spi_alloc_master(dev, sizeof(struct driver_data));
 	if (!master) {
@@ -1495,6 +1487,14 @@ static int __init spi_imx_probe(struct p
 
 	drv_data->dummy_dma_buf = SPI_DUMMY_u32;
 
+	drv_data->clk = clk_get(&pdev->dev, "perclk2");
+	if (IS_ERR(drv_data->clk)) {
+		dev_err(&pdev->dev, "probe - cannot get clock\n");
+		status = PTR_ERR(drv_data->clk);
+		goto err_no_clk;
+	}
+	clk_enable(drv_data->clk);
+
 	/* Find and map resources */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
@@ -1630,12 +1630,13 @@ err_no_iomap:
 	kfree(drv_data->ioarea);
 
 err_no_iores:
-	spi_master_put(master);
