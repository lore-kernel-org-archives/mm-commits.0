From: akpm@linux-foundation.org
Subject: [merged] video-exynos-mipi-dsi-avoid-races-in-probe.patch removed from -mm tree
Date: Wed, 16 May 2012 11:47:09 -0700
Message-ID: <20120516184709.6E80AA028F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:34617 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760358Ab2EPSrK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 May 2012 14:47:10 -0400
Received: by ggeh3 with SMTP id h3so128573gge.1
        for <mm-commits@vger.kernel.org>; Wed, 16 May 2012 11:47:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: s.nawrocki@samsung.com, FlorianSchandinat@gmx.de, dh09.lee@samsung.com, inki.dae@samsung.com, kyungmin.park@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: video: exynos mipi dsi: Avoid races in probe()
has been removed from the -mm tree.  Its filename was
     video-exynos-mipi-dsi-avoid-races-in-probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: video: exynos mipi dsi: Avoid races in probe()

Make sure all resources are initialized before interrupt handler is
registered.  Pass full platform device name to request_irq() so it can be
distinguished which device has requested an interrupt in cases there are
multiple instances in the system.

Also enable voltage regulators regardless of they have been enabled by
bootloader or not, to make sure other drivers using same regulators don't
disable them unexpectedly.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Donghwa Lee <dh09.lee@samsung.com>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/exynos/exynos_mipi_dsi.c |   26 ++++++++++++-----------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff -puN drivers/video/exynos/exynos_mipi_dsi.c~video-exynos-mipi-dsi-avoid-races-in-probe drivers/video/exynos/exynos_mipi_dsi.c
--- a/drivers/video/exynos/exynos_mipi_dsi.c~video-exynos-mipi-dsi-avoid-races-in-probe
+++ a/drivers/video/exynos/exynos_mipi_dsi.c
@@ -415,27 +415,30 @@ static int exynos_mipi_dsi_probe(struct 
 		goto err_platform_get_irq;
 	}
 
+	init_completion(&dsim_wr_comp);
+	init_completion(&dsim_rd_comp);
+	platform_set_drvdata(pdev, dsim);
+
 	ret = request_irq(dsim->irq, exynos_mipi_dsi_interrupt_handler,
-			IRQF_SHARED, pdev->name, dsim);
+			IRQF_SHARED, dev_name(&pdev->dev), dsim);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "failed to request dsim irq\n");
 		ret = -EINVAL;
 		goto err_bind;
 	}
 
-	init_completion(&dsim_wr_comp);
-	init_completion(&dsim_rd_comp);
-
-	/* enable interrupt */
+	/* enable interrupts */
 	exynos_mipi_dsi_init_interrupt(dsim);
 
 	/* initialize mipi-dsi client(lcd panel). */
 	if (dsim_ddi->dsim_lcd_drv && dsim_ddi->dsim_lcd_drv->probe)
 		dsim_ddi->dsim_lcd_drv->probe(dsim_ddi->dsim_lcd_dev);
 
-	/* in case that mipi got enabled at bootloader. */
-	if (dsim_pd->enabled)
-		goto out;
+	/* in case mipi-dsi has been enabled by bootloader */
+	if (dsim_pd->enabled) {
+		exynos_mipi_regulator_enable(dsim);
+		goto done;
+	}
 
 	/* lcd panel power on. */
 	if (dsim_ddi->dsim_lcd_drv && dsim_ddi->dsim_lcd_drv->power_on)
@@ -455,12 +458,11 @@ static int exynos_mipi_dsi_probe(struct 
 
 	dsim->suspended = false;
 
-out:
+done:
 	platform_set_drvdata(pdev, dsim);
 
-	dev_dbg(&pdev->dev, "mipi-dsi driver(%s mode) has been probed.\n",
-		(dsim_config->e_interface == DSIM_COMMAND) ?
-			"CPU" : "RGB");
+	dev_dbg(&pdev->dev, "%s() completed sucessfuly (%s mode)\n", __func__,
+		dsim_config->e_interface == DSIM_COMMAND ? "CPU" : "RGB");
 
 	return 0;
 
_

Patches currently in -mm which might be from s.nawrocki@samsung.com are

origin.patch
linux-next.patch

