From: akpm@linux-foundation.org
Subject: [merged]
 backlight-pandora_bl-use-devm_backlight_device_register.patch removed from
 -mm tree
Date: Wed, 13 Nov 2013 12:41:22 -0800
Message-ID: <5283e3f2.pZ0CEzNWybJrzihM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42988 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab3KMUlW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:41:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] backlight-pandora_bl-use-devm_backlight_device_register.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:41:22 -0800


The patch titled
     Subject: backlight: pandora_bl: use devm_backlight_device_register()
has been removed from the -mm tree.  Its filename was
     backlight-pandora_bl-use-devm_backlight_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: pandora_bl: use devm_backlight_device_register()

Use devm_backlight_device_register() to make cleanup paths simpler, and
remove unnecessary remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/pandora_bl.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff -puN drivers/video/backlight/pandora_bl.c~backlight-pandora_bl-use-devm_backlight_device_register drivers/video/backlight/pandora_bl.c
--- a/drivers/video/backlight/pandora_bl.c~backlight-pandora_bl-use-devm_backlight_device_register
+++ a/drivers/video/backlight/pandora_bl.c
@@ -120,8 +120,8 @@ static int pandora_backlight_probe(struc
 	memset(&props, 0, sizeof(props));
 	props.max_brightness = MAX_USER_VALUE;
 	props.type = BACKLIGHT_RAW;
-	bl = backlight_device_register(pdev->name, &pdev->dev,
-			NULL, &pandora_backlight_ops, &props);
+	bl = devm_backlight_device_register(&pdev->dev, pdev->name, &pdev->dev,
+					NULL, &pandora_backlight_ops, &props);
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "failed to register backlight\n");
 		return PTR_ERR(bl);
@@ -145,20 +145,12 @@ static int pandora_backlight_probe(struc
 	return 0;
 }
 
-static int pandora_backlight_remove(struct platform_device *pdev)
-{
-	struct backlight_device *bl = platform_get_drvdata(pdev);
-	backlight_device_unregister(bl);
-	return 0;
-}
