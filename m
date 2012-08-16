From: akpm@linux-foundation.org
Subject: [nacked] drivers-video-backlight-aat2870_blc-remove-goto-out.patch removed from -mm tree
Date: Thu, 16 Aug 2012 11:31:37 -0700
Message-ID: <20120816183137.DA09A1E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:35434 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab2HPSbj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Aug 2012 14:31:39 -0400
Received: by obbwc20 with SMTP id wc20so2139255obb.1
        for <mm-commits@vger.kernel.org>; Thu, 16 Aug 2012 11:31:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, jinyoungp@nvidia.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/aat2870_bl.c: remove goto out
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-aat2870_blc-remove-goto-out.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/video/backlight/aat2870_bl.c: remove goto out

Remove goto out, which makes code a bit smaller.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Jinyoung Park <jinyoungp@nvidia.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/aat2870_bl.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff -puN drivers/video/backlight/aat2870_bl.c~drivers-video-backlight-aat2870_blc-remove-goto-out drivers/video/backlight/aat2870_bl.c
--- a/drivers/video/backlight/aat2870_bl.c~drivers-video-backlight-aat2870_blc-remove-goto-out
+++ a/drivers/video/backlight/aat2870_bl.c
@@ -135,14 +135,12 @@ static int aat2870_bl_probe(struct platf
 
 	if (!pdata) {
 		dev_err(&pdev->dev, "No platform data\n");
-		ret = -ENXIO;
-		goto out;
+		return -ENXIO;
 	}
 
 	if (pdev->id != AAT2870_ID_BL) {
 		dev_err(&pdev->dev, "Invalid device ID, %d\n", pdev->id);
-		ret = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
 	aat2870_bl = devm_kzalloc(&pdev->dev,
@@ -151,8 +149,7 @@ static int aat2870_bl_probe(struct platf
 	if (!aat2870_bl) {
 		dev_err(&pdev->dev,
 			"Failed to allocate memory for aat2870 backlight\n");
-		ret = -ENOMEM;
-		goto out;
+		return -ENOMEM;
 	}
 
 	memset(&props, 0, sizeof(struct backlight_properties));
@@ -163,8 +160,7 @@ static int aat2870_bl_probe(struct platf
 	if (IS_ERR(bd)) {
 		dev_err(&pdev->dev,
 			"Failed allocate memory for backlight device\n");
-		ret = PTR_ERR(bd);
-		goto out;
+		return PTR_ERR(bd);
 	}
 
 	aat2870_bl->pdev = pdev;
@@ -201,7 +197,6 @@ static int aat2870_bl_probe(struct platf
 
 out_bl_dev_unregister:
 	backlight_device_unregister(bd);
-out:
 	return ret;
 }
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

linux-next.patch
drivers-video-backlight-da9052_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-video-backlight-ltv350qvc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
drivers-video-backlight-kb3886_blc-use-usleep_range-instead-of-msleep-for-small-sleeps.patch
backlight-atmel-pwm-bl-remove-goto-err_free_mem.patch

