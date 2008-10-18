From: akpm@linux-foundation.org
Subject: - pxa2xx_spi-minor-cleanup.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:14:37 -0700
Message-ID: <200810182314.m9INEbRd028439@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34250 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751654AbYJRXPF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:15:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: g.liakhovetski@pengutronix.de, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     pxa2xx_spi: minor cleanup
has been removed from the -mm tree.  Its filename was
     pxa2xx_spi-minor-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pxa2xx_spi: minor cleanup
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

Minor fixes: remove redundant local variable initialization, fix "can not"
to what I _think_ is a preferred spelling, output IRQ number if requesting
it failed.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/pxa2xx_spi.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/spi/pxa2xx_spi.c~pxa2xx_spi-minor-cleanup drivers/spi/pxa2xx_spi.c
--- a/drivers/spi/pxa2xx_spi.c~pxa2xx_spi-minor-cleanup
+++ a/drivers/spi/pxa2xx_spi.c
@@ -1407,9 +1407,9 @@ static int __init pxa2xx_spi_probe(struc
 	struct device *dev = &pdev->dev;
 	struct pxa2xx_spi_master *platform_info;
 	struct spi_master *master;
-	struct driver_data *drv_data = NULL;
+	struct driver_data *drv_data;
 	struct ssp_device *ssp;
-	int status = 0;
+	int status;
 
 	platform_info = dev->platform_data;
 
@@ -1422,7 +1422,7 @@ static int __init pxa2xx_spi_probe(struc
 	/* Allocate master with space for drv_data and null dma buffer */
 	master = spi_alloc_master(dev, sizeof(struct driver_data) + 16);
 	if (!master) {
-		dev_err(&pdev->dev, "can not alloc spi_master\n");
+		dev_err(&pdev->dev, "cannot alloc spi_master\n");
 		ssp_free(ssp);
 		return -ENOMEM;
 	}
@@ -1458,7 +1458,7 @@ static int __init pxa2xx_spi_probe(struc
 
 	status = request_irq(ssp->irq, ssp_int, 0, dev->bus_id, drv_data);
 	if (status < 0) {
-		dev_err(&pdev->dev, "can not get IRQ\n");
+		dev_err(&pdev->dev, "cannot get IRQ %d\n", ssp->irq);
 		goto out_error_master_alloc;
 	}
 
_

Patches currently in -mm which might be from g.liakhovetski@pengutronix.de are

origin.patch

