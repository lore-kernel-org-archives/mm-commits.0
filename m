From: akpm@linux-foundation.org
Subject: [merged]
 backlight-tps65217_bl-use-devm_backlight_device_register.patch removed from -mm tree
Date: Wed, 13 Nov 2013 12:41:26 -0800
Message-ID: <5283e3f6.e7srCBJ+9jQNSQrt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43001 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab3KMUl0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:41:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] backlight-tps65217_bl-use-devm_backlight_device_register.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:41:26 -0800


The patch titled
     Subject: backlight: tps65217_bl: use devm_backlight_device_register()
has been removed from the -mm tree.  Its filename was
     backlight-tps65217_bl-use-devm_backlight_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: tps65217_bl: use devm_backlight_device_register()

Use devm_backlight_device_register() to make cleanup paths simpler, and
remove unnecessary remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/tps65217_bl.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff -puN drivers/video/backlight/tps65217_bl.c~backlight-tps65217_bl-use-devm_backlight_device_register drivers/video/backlight/tps65217_bl.c
--- a/drivers/video/backlight/tps65217_bl.c~backlight-tps65217_bl-use-devm_backlight_device_register
+++ a/drivers/video/backlight/tps65217_bl.c
@@ -313,7 +313,7 @@ static int tps65217_bl_probe(struct plat
 	bl_props.type = BACKLIGHT_RAW;
 	bl_props.max_brightness = 100;
 
-	tps65217_bl->bl = backlight_device_register(pdev->name,
+	tps65217_bl->bl = devm_backlight_device_register(&pdev->dev, pdev->name,
 						tps65217_bl->dev, tps65217_bl,
 						&tps65217_bl_ops, &bl_props);
 	if (IS_ERR(tps65217_bl->bl)) {
@@ -329,18 +329,8 @@ static int tps65217_bl_probe(struct plat
 	return 0;
 }
 
-static int tps65217_bl_remove(struct platform_device *pdev)
-{
-	struct tps65217_bl *tps65217_bl = platform_get_drvdata(pdev);
-
-	backlight_device_unregister(tps65217_bl->bl);
-
-	return 0;
-}
