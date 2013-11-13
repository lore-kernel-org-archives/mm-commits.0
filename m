From: akpm@linux-foundation.org
Subject: [merged]
 backlight-pcf50633-use-devm_backlight_device_register.patch removed from
 -mm tree
Date: Wed, 13 Nov 2013 12:41:24 -0800
Message-ID: <5283e3f4.EN9V3m9u9OA3ZW/R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42992 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab3KMUlZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:41:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] backlight-pcf50633-use-devm_backlight_device_register.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:41:24 -0800


The patch titled
     Subject: backlight: pcf50633: use devm_backlight_device_register()
has been removed from the -mm tree.  Its filename was
     backlight-pcf50633-use-devm_backlight_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: pcf50633: use devm_backlight_device_register()

Use devm_backlight_device_register() to make cleanup paths simpler, and
remove unnecessary remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/pcf50633-backlight.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff -puN drivers/video/backlight/pcf50633-backlight.c~backlight-pcf50633-use-devm_backlight_device_register drivers/video/backlight/pcf50633-backlight.c
--- a/drivers/video/backlight/pcf50633-backlight.c~backlight-pcf50633-use-devm_backlight_device_register
+++ a/drivers/video/backlight/pcf50633-backlight.c
@@ -126,7 +126,8 @@ static int pcf50633_bl_probe(struct plat
 
 	pcf_bl->pcf = dev_to_pcf50633(pdev->dev.parent);
 
-	pcf_bl->bl = backlight_device_register(pdev->name, &pdev->dev, pcf_bl,
+	pcf_bl->bl = devm_backlight_device_register(&pdev->dev, pdev->name,
+						&pdev->dev, pcf_bl,
 						&pcf50633_bl_ops, &bl_props);
 
 	if (IS_ERR(pcf_bl->bl))
@@ -147,18 +148,8 @@ static int pcf50633_bl_probe(struct plat
 	return 0;
 }
 
-static int pcf50633_bl_remove(struct platform_device *pdev)
-{
-	struct pcf50633_bl *pcf_bl = platform_get_drvdata(pdev);
-
-	backlight_device_unregister(pcf_bl->bl);
-
-	return 0;
-}
