From: akpm@linux-foundation.org
Subject: [merged] drivers-video-exynos-exynos_mipi_dsic-use-devm_-apis.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:38:28 -0800
Message-ID: <20130222203828.A77CC31C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:53963 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757125Ab3BVUi3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:38:29 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so103688ghb.3
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:38:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sachin.kamat@linaro.org, FlorianSchandinat@gmx.de, dh09.lee@samsung.com, inki.dae@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/exynos/exynos_mipi_dsi.c: use devm_* APIs
has been removed from the -mm tree.  Its filename was
     drivers-video-exynos-exynos_mipi_dsic-use-devm_-apis.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/video/exynos/exynos_mipi_dsi.c: use devm_* APIs

devm_* APIs are device managed and make exit and cleanup code simpler. 
While at it also remove some unused labels and fix an error path.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Acked-by: Donghwa Lee <dh09.lee@samsung.com>
Cc: Inki Dae <inki.dae@samsung.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/exynos/exynos_mipi_dsi.c |   68 +++++------------------
 include/video/exynos_mipi_dsim.h       |    1 
 2 files changed, 17 insertions(+), 52 deletions(-)

diff -puN drivers/video/exynos/exynos_mipi_dsi.c~drivers-video-exynos-exynos_mipi_dsic-use-devm_-apis drivers/video/exynos/exynos_mipi_dsi.c
--- a/drivers/video/exynos/exynos_mipi_dsi.c~drivers-video-exynos-exynos_mipi_dsic-use-devm_-apis
+++ a/drivers/video/exynos/exynos_mipi_dsi.c
@@ -338,7 +338,8 @@ static int exynos_mipi_dsi_probe(struct 
 	struct mipi_dsim_ddi *dsim_ddi;
 	int ret = -EINVAL;
 
-	dsim = kzalloc(sizeof(struct mipi_dsim_device), GFP_KERNEL);
+	dsim = devm_kzalloc(&pdev->dev, sizeof(struct mipi_dsim_device),
+				GFP_KERNEL);
 	if (!dsim) {
 		dev_err(&pdev->dev, "failed to allocate dsim object.\n");
 		return -ENOMEM;
@@ -352,13 +353,13 @@ static int exynos_mipi_dsi_probe(struct 
 	dsim_pd = (struct mipi_dsim_platform_data *)dsim->pd;
 	if (dsim_pd == NULL) {
 		dev_err(&pdev->dev, "failed to get platform data for dsim.\n");
-		goto err_clock_get;
+		return -EINVAL;
 	}
 	/* get mipi_dsim_config. */
 	dsim_config = dsim_pd->dsim_config;
 	if (dsim_config == NULL) {
 		dev_err(&pdev->dev, "failed to get dsim config data.\n");
-		goto err_clock_get;
+		return -EINVAL;
 	}
 
 	dsim->dsim_config = dsim_config;
@@ -366,41 +367,28 @@ static int exynos_mipi_dsi_probe(struct 
 
 	mutex_init(&dsim->lock);
 
-	ret = regulator_bulk_get(&pdev->dev, ARRAY_SIZE(supplies), supplies);
+	ret = devm_regulator_bulk_get(&pdev->dev, ARRAY_SIZE(supplies),
+					supplies);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to get regulators: %d\n", ret);
-		goto err_clock_get;
+		return ret;
 	}
 
-	dsim->clock = clk_get(&pdev->dev, "dsim0");
+	dsim->clock = devm_clk_get(&pdev->dev, "dsim0");
 	if (IS_ERR(dsim->clock)) {
 		dev_err(&pdev->dev, "failed to get dsim clock source\n");
-		ret = -ENODEV;
-		goto err_clock_get;
+		return -ENODEV;
 	}
 
 	clk_enable(dsim->clock);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "failed to get io memory region\n");
-		ret = -ENODEV;
-		goto err_platform_get;
-	}
-
-	dsim->res = request_mem_region(res->start, resource_size(res),
-					dev_name(&pdev->dev));
-	if (!dsim->res) {
-		dev_err(&pdev->dev, "failed to request io memory region\n");
-		ret = -ENOMEM;
-		goto err_mem_region;
-	}
 
-	dsim->reg_base = ioremap(res->start, resource_size(res));
+	dsim->reg_base = devm_request_and_ioremap(&pdev->dev, res);
 	if (!dsim->reg_base) {
 		dev_err(&pdev->dev, "failed to remap io region\n");
 		ret = -ENOMEM;
-		goto err_ioremap;
+		goto error;
 	}
 
 	mutex_init(&dsim->lock);
@@ -410,26 +398,27 @@ static int exynos_mipi_dsi_probe(struct 
 	if (!dsim_ddi) {
 		dev_err(&pdev->dev, "mipi_dsim_ddi object not found.\n");
 		ret = -EINVAL;
-		goto err_bind;
+		goto error;
 	}
 
 	dsim->irq = platform_get_irq(pdev, 0);
 	if (IS_ERR_VALUE(dsim->irq)) {
 		dev_err(&pdev->dev, "failed to request dsim irq resource\n");
 		ret = -EINVAL;
-		goto err_platform_get_irq;
+		goto error;
 	}
 
 	init_completion(&dsim_wr_comp);
 	init_completion(&dsim_rd_comp);
 	platform_set_drvdata(pdev, dsim);
 
-	ret = request_irq(dsim->irq, exynos_mipi_dsi_interrupt_handler,
+	ret = devm_request_irq(&pdev->dev, dsim->irq,
+			exynos_mipi_dsi_interrupt_handler,
 			IRQF_SHARED, dev_name(&pdev->dev), dsim);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "failed to request dsim irq\n");
 		ret = -EINVAL;
-		goto err_bind;
+		goto error;
 	}
 
 	/* enable interrupts */
@@ -471,22 +460,8 @@ done:
 
 	return 0;
 
-err_bind:
-	iounmap(dsim->reg_base);
-
-err_ioremap:
-	release_mem_region(dsim->res->start, resource_size(dsim->res));
-
-err_mem_region:
-	release_resource(dsim->res);
-
-err_platform_get:
+error:
 	clk_disable(dsim->clock);
-	clk_put(dsim->clock);
-err_clock_get:
-	kfree(dsim);
-
-err_platform_get_irq:
 	return ret;
 }
 
@@ -496,13 +471,7 @@ static int exynos_mipi_dsi_remove(struct
 	struct mipi_dsim_ddi *dsim_ddi, *next;
 	struct mipi_dsim_lcd_driver *dsim_lcd_drv;
 
-	iounmap(dsim->reg_base);
-
 	clk_disable(dsim->clock);
-	clk_put(dsim->clock);
-
-	release_resource(dsim->res);
-	release_mem_region(dsim->res->start, resource_size(dsim->res));
 
 	list_for_each_entry_safe(dsim_ddi, next, &dsim_ddi_list, list) {
 		if (dsim_ddi) {
@@ -518,9 +487,6 @@ static int exynos_mipi_dsi_remove(struct
 		}
 	}
 
-	regulator_bulk_free(ARRAY_SIZE(supplies), supplies);
-	kfree(dsim);
