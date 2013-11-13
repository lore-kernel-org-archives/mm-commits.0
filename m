From: akpm@linux-foundation.org
Subject: [merged]
 backlight-kb3886_bl-use-devm_backlight_device_register.patch removed from
 -mm tree
Date: Wed, 13 Nov 2013 12:41:12 -0800
Message-ID: <5283e3e8.0FfgekISvmjjcFDN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42979 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab3KMUlN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:41:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] backlight-kb3886_bl-use-devm_backlight_device_register.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:41:12 -0800


The patch titled
     Subject: backlight: kb3886_bl: use devm_backlight_device_register()
has been removed from the -mm tree.  Its filename was
     backlight-kb3886_bl-use-devm_backlight_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: kb3886_bl: use devm_backlight_device_register()

Use devm_backlight_device_register() to make cleanup paths simpler, and
remove unnecessary remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/kb3886_bl.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff -puN drivers/video/backlight/kb3886_bl.c~backlight-kb3886_bl-use-devm_backlight_device_register drivers/video/backlight/kb3886_bl.c
--- a/drivers/video/backlight/kb3886_bl.c~backlight-kb3886_bl-use-devm_backlight_device_register
+++ a/drivers/video/backlight/kb3886_bl.c
@@ -150,10 +150,10 @@ static int kb3886bl_probe(struct platfor
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = machinfo->max_intensity;
-	kb3886_backlight_device = backlight_device_register("kb3886-bl",
-							    &pdev->dev, NULL,
-							    &kb3886bl_ops,
-							    &props);
+	kb3886_backlight_device = devm_backlight_device_register(&pdev->dev,
+							"kb3886-bl", &pdev->dev,
+							NULL, &kb3886bl_ops,
+							&props);
 	if (IS_ERR(kb3886_backlight_device))
 		return PTR_ERR(kb3886_backlight_device);
 
@@ -166,18 +166,8 @@ static int kb3886bl_probe(struct platfor
 	return 0;
 }
 
-static int kb3886bl_remove(struct platform_device *pdev)
-{
-	struct backlight_device *bd = platform_get_drvdata(pdev);
-
-	backlight_device_unregister(bd);
-
-	return 0;
-}
