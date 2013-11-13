From: akpm@linux-foundation.org
Subject: [merged]
 backlight-as3711_bl-use-devm_backlight_device_register.patch removed from
 -mm tree
Date: Wed, 13 Nov 2013 12:40:56 -0800
Message-ID: <5283e3d8./FLYezxljEWql4XQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42960 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab3KMUk4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:40:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] backlight-as3711_bl-use-devm_backlight_device_register.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:40:56 -0800


The patch titled
     Subject: backlight: as3711_bl: use devm_backlight_device_register()
has been removed from the -mm tree.  Its filename was
     backlight-as3711_bl-use-devm_backlight_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: as3711_bl: use devm_backlight_device_register()

Use devm_backlight_device_register() to make cleanup paths simpler, and
remove unnecessary remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/as3711_bl.c |   26 +++++---------------------
 1 file changed, 5 insertions(+), 21 deletions(-)

diff -puN drivers/video/backlight/as3711_bl.c~backlight-as3711_bl-use-devm_backlight_device_register drivers/video/backlight/as3711_bl.c
--- a/drivers/video/backlight/as3711_bl.c~backlight-as3711_bl-use-devm_backlight_device_register
+++ a/drivers/video/backlight/as3711_bl.c
@@ -240,7 +240,8 @@ static int as3711_bl_register(struct pla
 	/* max tuning I = 31uA for voltage- and 38250uA for current-feedback */
 	props.max_brightness = max_brightness;
 
-	bl = backlight_device_register(su->type == AS3711_BL_SU1 ?
+	bl = devm_backlight_device_register(&pdev->dev,
+				       su->type == AS3711_BL_SU1 ?
 				       "as3711-su1" : "as3711-su2",
 				       &pdev->dev, su,
 				       &as3711_bl_ops, &props);
@@ -432,8 +433,7 @@ static int as3711_backlight_probe(struct
 		case AS3711_SU2_LX_SD4:
 			break;
 		default:
-			ret = -EINVAL;
-			goto esu2;
+			return -EINVAL;
 		}
 
 		switch (pdata->su2_feedback) {
@@ -447,8 +447,7 @@ static int as3711_backlight_probe(struct
 			max_brightness = min(pdata->su2_max_uA / 150, 255);
 			break;
 		default:
-			ret = -EINVAL;
-			goto esu2;
+			return -EINVAL;
 		}
 
 		ret = as3711_bl_init_su2(supply);
@@ -457,26 +456,12 @@ static int as3711_backlight_probe(struct
 
 		ret = as3711_bl_register(pdev, max_brightness, su);
 		if (ret < 0)
-			goto esu2;
+			return ret;
 	}
 
 	platform_set_drvdata(pdev, supply);
 
 	return 0;
-
-esu2:
-	backlight_device_unregister(supply->su1.bl);
-	return ret;
-}
-
-static int as3711_backlight_remove(struct platform_device *pdev)
-{
-	struct as3711_bl_supply *supply = platform_get_drvdata(pdev);
-
-	backlight_device_unregister(supply->su1.bl);
-	backlight_device_unregister(supply->su2.bl);
