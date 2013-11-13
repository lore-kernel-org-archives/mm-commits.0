From: akpm@linux-foundation.org
Subject: [merged]
 backlight-max8925_bl-use-devm_backlight_device_register.patch removed from
 -mm tree
Date: Wed, 13 Nov 2013 12:41:20 -0800
Message-ID: <5283e3f0.gnku0c7WCyth5eTP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42986 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab3KMUlU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:41:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] backlight-max8925_bl-use-devm_backlight_device_register.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:41:20 -0800


The patch titled
     Subject: backlight: max8925_bl: use devm_backlight_device_register()
has been removed from the -mm tree.  Its filename was
     backlight-max8925_bl-use-devm_backlight_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: max8925_bl: use devm_backlight_device_register()

Use devm_backlight_device_register() to make cleanup paths simpler, and
remove unnecessary remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/max8925_bl.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff -puN drivers/video/backlight/max8925_bl.c~backlight-max8925_bl-use-devm_backlight_device_register drivers/video/backlight/max8925_bl.c
--- a/drivers/video/backlight/max8925_bl.c~backlight-max8925_bl-use-devm_backlight_device_register
+++ a/drivers/video/backlight/max8925_bl.c
@@ -163,7 +163,8 @@ static int max8925_backlight_probe(struc
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = MAX_BRIGHTNESS;
-	bl = backlight_device_register("max8925-backlight", &pdev->dev, data,
+	bl = devm_backlight_device_register(&pdev->dev, "max8925-backlight",
+					&pdev->dev, data,
 					&max8925_backlight_ops, &props);
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "failed to register backlight\n");
@@ -188,20 +189,9 @@ static int max8925_backlight_probe(struc
 	}
 	ret = max8925_set_bits(chip->i2c, data->reg_mode_cntl, 0xfe, value);
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
-static int max8925_backlight_remove(struct platform_device *pdev)
-{
-	struct backlight_device *bl = platform_get_drvdata(pdev);
