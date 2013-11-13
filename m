From: akpm@linux-foundation.org
Subject: [merged]
 backlight-88pm860x_bl-use-devm_backlight_device_register.patch removed from -mm tree
Date: Wed, 13 Nov 2013 12:40:46 -0800
Message-ID: <5283e3ce.bZ+pZXr8nLw0MC3x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42952 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab3KMUkq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:40:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] backlight-88pm860x_bl-use-devm_backlight_device_register.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:40:46 -0800


The patch titled
     Subject: backlight: 88pm860x_bl: use devm_backlight_device_register()
has been removed from the -mm tree.  Its filename was
     backlight-88pm860x_bl-use-devm_backlight_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: 88pm860x_bl: use devm_backlight_device_register()

Use devm_backlight_device_register() to make cleanup paths simpler, and
remove unnecessary remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/88pm860x_bl.c |   16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff -puN drivers/video/backlight/88pm860x_bl.c~backlight-88pm860x_bl-use-devm_backlight_device_register drivers/video/backlight/88pm860x_bl.c
--- a/drivers/video/backlight/88pm860x_bl.c~backlight-88pm860x_bl-use-devm_backlight_device_register
+++ a/drivers/video/backlight/88pm860x_bl.c
@@ -243,7 +243,7 @@ static int pm860x_backlight_probe(struct
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = MAX_BRIGHTNESS;
-	bl = backlight_device_register(name, &pdev->dev, data,
+	bl = devm_backlight_device_register(&pdev->dev, name, &pdev->dev, data,
 					&pm860x_backlight_ops, &props);
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "failed to register backlight\n");
@@ -256,21 +256,10 @@ static int pm860x_backlight_probe(struct
 	/* read current backlight */
 	ret = pm860x_backlight_get_brightness(bl);
 	if (ret < 0)
-		goto out_brt;
+		return ret;
 
 	backlight_update_status(bl);
 	return 0;
-out_brt:
-	backlight_device_unregister(bl);
-	return ret;
-}
-
-static int pm860x_backlight_remove(struct platform_device *pdev)
-{
-	struct backlight_device *bl = platform_get_drvdata(pdev);
