From: akpm@linux-foundation.org
Subject: [merged] backlight-omap1-use-devm_backlight_device_register.patch removed from -mm tree
Date: Fri, 24 Jan 2014 11:01:13 -0800
Message-ID: <52e2b879.hPejWjT3Gva9/Erq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43575 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaAXTBO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:01:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tomi.valkeinen@ti.com, jg1.han@samsung.com

Subject: [merged] backlight-omap1-use-devm_backlight_device_register.patch removed from -mm tree
To: jg1.han@samsung.com,tomi.valkeinen@ti.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:01:13 -0800


The patch titled
     Subject: backlight: omap1: use devm_backlight_device_register()
has been removed from the -mm tree.  Its filename was
     backlight-omap1-use-devm_backlight_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: omap1: use devm_backlight_device_register()

Use devm_backlight_device_register() to make cleanup paths simpler,
and remove unnecessary remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/omap1_bl.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff -puN drivers/video/backlight/omap1_bl.c~backlight-omap1-use-devm_backlight_device_register drivers/video/backlight/omap1_bl.c
--- a/drivers/video/backlight/omap1_bl.c~backlight-omap1-use-devm_backlight_device_register
+++ a/drivers/video/backlight/omap1_bl.c
@@ -146,8 +146,8 @@ static int omapbl_probe(struct platform_
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = OMAPBL_MAX_INTENSITY;
-	dev = backlight_device_register("omap-bl", &pdev->dev, bl, &omapbl_ops,
-					&props);
+	dev = devm_backlight_device_register(&pdev->dev, "omap-bl", &pdev->dev,
+					bl, &omapbl_ops, &props);
 	if (IS_ERR(dev))
 		return PTR_ERR(dev);
 
@@ -170,20 +170,10 @@ static int omapbl_probe(struct platform_
 	return 0;
 }
 
-static int omapbl_remove(struct platform_device *pdev)
-{
-	struct backlight_device *dev = platform_get_drvdata(pdev);
-
-	backlight_device_unregister(dev);
-
-	return 0;
-}
