From: akpm@linux-foundation.org
Subject: [merged]
 backlight-ot200_bl-use-devm_backlight_device_register.patch removed from
 -mm tree
Date: Fri, 24 Jan 2014 11:01:15 -0800
Message-ID: <52e2b87b.P12BQVI05lr+R8C4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43578 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaAXTBP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:01:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tomi.valkeinen@ti.com, jg1.han@samsung.com

Subject: [merged] backlight-ot200_bl-use-devm_backlight_device_register.patch removed from -mm tree
To: jg1.han@samsung.com,tomi.valkeinen@ti.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:01:15 -0800


The patch titled
     Subject: backlight: ot200_bl: use devm_backlight_device_register()
has been removed from the -mm tree.  Its filename was
     backlight-ot200_bl-use-devm_backlight_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: ot200_bl: use devm_backlight_device_register()

Use devm_backlight_device_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ot200_bl.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN drivers/video/backlight/ot200_bl.c~backlight-ot200_bl-use-devm_backlight_device_register drivers/video/backlight/ot200_bl.c
--- a/drivers/video/backlight/ot200_bl.c~backlight-ot200_bl-use-devm_backlight_device_register
+++ a/drivers/video/backlight/ot200_bl.c
@@ -118,8 +118,9 @@ static int ot200_backlight_probe(struct
 	props.brightness = 100;
 	props.type = BACKLIGHT_RAW;
 
-	bl = backlight_device_register(dev_name(&pdev->dev), &pdev->dev, data,
-					&ot200_backlight_ops, &props);
+	bl = devm_backlight_device_register(&pdev->dev, dev_name(&pdev->dev),
+					&pdev->dev, data, &ot200_backlight_ops,
+					&props);
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "failed to register backlight\n");
 		retval = PTR_ERR(bl);
@@ -137,10 +138,6 @@ error_devm_kzalloc:
 
 static int ot200_backlight_remove(struct platform_device *pdev)
 {
-	struct backlight_device *bl = platform_get_drvdata(pdev);
-
-	backlight_device_unregister(bl);
