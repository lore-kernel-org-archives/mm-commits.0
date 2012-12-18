From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-max8925_blc-drop-devm_kfree-of-devm_kzallocd-data.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:05:27 -0800
Message-ID: <20121218200527.A9A9982004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:35885 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2LRUF2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:05:28 -0500
Received: by mail-ye0-f202.google.com with SMTP id l7so125621yen.3
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:05:28 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/max8925_bl.c: drop devm_kfree of devm_kzalloc'd data
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-max8925_blc-drop-devm_kfree-of-devm_kzallocd-data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/video/backlight/max8925_bl.c: drop devm_kfree of devm_kzalloc'd data

devm_kfree() allocates memory that is released when a driver detaches. 
Thus, there is no reason to explicitly call devm_kfree in probe or remove
functions.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/max8925_bl.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff -puN drivers/video/backlight/max8925_bl.c~drivers-video-backlight-max8925_blc-drop-devm_kfree-of-devm_kzallocd-data drivers/video/backlight/max8925_bl.c
--- a/drivers/video/backlight/max8925_bl.c~drivers-video-backlight-max8925_blc-drop-devm_kfree-of-devm_kzallocd-data
+++ a/drivers/video/backlight/max8925_bl.c
@@ -120,15 +120,13 @@ static int max8925_backlight_probe(struc
 	res = platform_get_resource(pdev, IORESOURCE_REG, 0);
 	if (!res) {
 		dev_err(&pdev->dev, "No REG resource for mode control!\n");
-		ret = -ENXIO;
-		goto out;
+		return -ENXIO;
 	}
 	data->reg_mode_cntl = res->start;
 	res = platform_get_resource(pdev, IORESOURCE_REG, 1);
 	if (!res) {
 		dev_err(&pdev->dev, "No REG resource for control!\n");
-		ret = -ENXIO;
-		goto out;
+		return -ENXIO;
 	}
 	data->reg_cntl = res->start;
 
@@ -142,8 +140,7 @@ static int max8925_backlight_probe(struc
 					&max8925_backlight_ops, &props);
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "failed to register backlight\n");
-		ret = PTR_ERR(bl);
-		goto out;
+		return PTR_ERR(bl);
 	}
 	bl->props.brightness = MAX_BRIGHTNESS;
 
@@ -166,8 +163,6 @@ static int max8925_backlight_probe(struc
 	return 0;
 out_brt:
 	backlight_device_unregister(bl);
-out:
-	devm_kfree(&pdev->dev, data);
 	return ret;
 }
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
backlight-locomolcd-fix-checkpatch-error-and-warning.patch

