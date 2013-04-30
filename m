From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-l4f00242t03c-check-return-value-of-regulator_enable.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:51:35 -0700
Message-ID: <20130430185135.7279231C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:41106 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932551Ab3D3Svg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:51:36 -0400
Received: by mail-gg0-f201.google.com with SMTP id y3so86256ggc.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:51:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/l4f00242t03.c: check return value of regulator_enable()
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-l4f00242t03c-check-return-value-of-regulator_enable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/video/backlight/l4f00242t03.c: check return value of regulator_enable()

regulator_enable() is marked as as __must_check.  Therefore the return
value of regulator_enable() should be checked.  Also, this patch checks
return value of regulator_set_voltage().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/l4f00242t03.c |   27 ++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff -puN drivers/video/backlight/l4f00242t03.c~drivers-video-backlight-l4f00242t03c-check-return-value-of-regulator_enable drivers/video/backlight/l4f00242t03.c
--- a/drivers/video/backlight/l4f00242t03.c~drivers-video-backlight-l4f00242t03c-check-return-value-of-regulator_enable
+++ a/drivers/video/backlight/l4f00242t03.c
@@ -51,14 +51,33 @@ static void l4f00242t03_lcd_init(struct
 	struct l4f00242t03_pdata *pdata = spi->dev.platform_data;
 	struct l4f00242t03_priv *priv = spi_get_drvdata(spi);
 	const u16 cmd[] = { 0x36, param(0), 0x3A, param(0x60) };
+	int ret;
 
 	dev_dbg(&spi->dev, "initializing LCD\n");
 
-	regulator_set_voltage(priv->io_reg, 1800000, 1800000);
-	regulator_enable(priv->io_reg);
+	ret = regulator_set_voltage(priv->io_reg, 1800000, 1800000);
+	if (ret) {
+		dev_err(&spi->dev, "failed to set the IO regulator voltage.\n");
+		return;
+	}
+	ret = regulator_enable(priv->io_reg);
+	if (ret) {
+		dev_err(&spi->dev, "failed to enable the IO regulator.\n");
+		return;
+	}
 
-	regulator_set_voltage(priv->core_reg, 2800000, 2800000);
-	regulator_enable(priv->core_reg);
+	ret = regulator_set_voltage(priv->core_reg, 2800000, 2800000);
+	if (ret) {
+		dev_err(&spi->dev, "failed to set the core regulator voltage.\n");
+		regulator_disable(priv->io_reg);
+		return;
+	}
+	ret = regulator_enable(priv->core_reg);
+	if (ret) {
+		dev_err(&spi->dev, "failed to enable the core regulator.\n");
+		regulator_disable(priv->io_reg);
+		return;
+	}
 
 	l4f00242t03_reset(pdata->reset_gpio);
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

