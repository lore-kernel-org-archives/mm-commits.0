From: akpm@linux-foundation.org
Subject: [merged]
 backlight-ep93xx-use-devm_backlight_device_register.patch removed from -mm
 tree
Date: Wed, 13 Nov 2013 12:41:06 -0800
Message-ID: <5283e3e2.yls1rUoj90gWf0Oh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42977 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab3KMUlL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:41:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] backlight-ep93xx-use-devm_backlight_device_register.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:41:06 -0800


The patch titled
     Subject: backlight: ep93xx: use devm_backlight_device_register()
has been removed from the -mm tree.  Its filename was
     backlight-ep93xx-use-devm_backlight_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: ep93xx: use devm_backlight_device_register()

Use devm_backlight_device_register() to make cleanup paths simpler, and
remove unnecessary remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ep93xx_bl.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff -puN drivers/video/backlight/ep93xx_bl.c~backlight-ep93xx-use-devm_backlight_device_register drivers/video/backlight/ep93xx_bl.c
--- a/drivers/video/backlight/ep93xx_bl.c~backlight-ep93xx-use-devm_backlight_device_register
+++ a/drivers/video/backlight/ep93xx_bl.c
@@ -92,8 +92,8 @@ static int ep93xxbl_probe(struct platfor
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = EP93XX_MAX_BRIGHT;
-	bl = backlight_device_register(dev->name, &dev->dev, ep93xxbl,
-				       &ep93xxbl_ops, &props);
+	bl = devm_backlight_device_register(&dev->dev, dev->name, &dev->dev,
+					ep93xxbl, &ep93xxbl_ops, &props);
 	if (IS_ERR(bl))
 		return PTR_ERR(bl);
 
@@ -106,14 +106,6 @@ static int ep93xxbl_probe(struct platfor
 	return 0;
 }
 
-static int ep93xxbl_remove(struct platform_device *dev)
-{
-	struct backlight_device *bl = platform_get_drvdata(dev);
-
-	backlight_device_unregister(bl);
-	return 0;
-}
