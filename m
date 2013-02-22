From: akpm@linux-foundation.org
Subject: [merged] drivers-video-exynos-s6e8ax0c-use-devm_-apis-in-s6e8ax0c.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:38:22 -0800
Message-ID: <20130222203822.ABB755A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:59356 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756764Ab3BVUiX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:38:23 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so103627ggi.3
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:38:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sachin.kamat@linaro.org, FlorianSchandinat@gmx.de, dh09.lee@samsung.com, inki.dae@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/exynos/s6e8ax0.c: use devm_* APIs in s6e8ax0.c
has been removed from the -mm tree.  Its filename was
     drivers-video-exynos-s6e8ax0c-use-devm_-apis-in-s6e8ax0c.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/video/exynos/s6e8ax0.c: use devm_* APIs in s6e8ax0.c

devm_* APIs are device managed and make error handling and code cleanup
simpler.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Acked-by: Donghwa Lee <dh09.lee@samsung.com>
Cc: Inki Dae <inki.dae@samsung.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/exynos/s6e8ax0.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff -puN drivers/video/exynos/s6e8ax0.c~drivers-video-exynos-s6e8ax0c-use-devm_-apis-in-s6e8ax0c drivers/video/exynos/s6e8ax0.c
--- a/drivers/video/exynos/s6e8ax0.c~drivers-video-exynos-s6e8ax0c-use-devm_-apis-in-s6e8ax0c
+++ a/drivers/video/exynos/s6e8ax0.c
@@ -776,7 +776,7 @@ static int s6e8ax0_probe(struct mipi_dsi
 	int ret;
 	u8 mtp_id[3] = {0, };
 
-	lcd = kzalloc(sizeof(struct s6e8ax0), GFP_KERNEL);
+	lcd = devm_kzalloc(&dsim_dev->dev, sizeof(struct s6e8ax0), GFP_KERNEL);
 	if (!lcd) {
 		dev_err(&dsim_dev->dev, "failed to allocate s6e8ax0 structure.\n");
 		return -ENOMEM;
@@ -788,18 +788,17 @@ static int s6e8ax0_probe(struct mipi_dsi
 
 	mutex_init(&lcd->lock);
 
-	ret = regulator_bulk_get(lcd->dev, ARRAY_SIZE(supplies), supplies);
+	ret = devm_regulator_bulk_get(lcd->dev, ARRAY_SIZE(supplies), supplies);
 	if (ret) {
 		dev_err(lcd->dev, "Failed to get regulators: %d\n", ret);
-		goto err_lcd_register;
+		return ret;
 	}
 
 	lcd->ld = lcd_device_register("s6e8ax0", lcd->dev, lcd,
 			&s6e8ax0_lcd_ops);
 	if (IS_ERR(lcd->ld)) {
 		dev_err(lcd->dev, "failed to register lcd ops.\n");
-		ret = PTR_ERR(lcd->ld);
-		goto err_lcd_register;
+		return PTR_ERR(lcd->ld);
 	}
 
 	lcd->bd = backlight_device_register("s6e8ax0-bl", lcd->dev, lcd,
@@ -838,11 +837,6 @@ static int s6e8ax0_probe(struct mipi_dsi
 
 err_backlight_register:
 	lcd_device_unregister(lcd->ld);
-
-err_lcd_register:
-	regulator_bulk_free(ARRAY_SIZE(supplies), supplies);
-	kfree(lcd);
