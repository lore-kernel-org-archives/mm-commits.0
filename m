From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-88pm860x_blc-drop-devm_kfree-of-devm_kzallocd-data.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:05:24 -0800
Message-ID: <20121218200524.A00DB100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:40069 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2LRUFZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:05:25 -0500
Received: by mail-vc0-f201.google.com with SMTP id p1so125403vcq.4
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:05:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/88pm860x_bl.c: drop devm_kfree of devm_kzalloc'd data
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-88pm860x_blc-drop-devm_kfree-of-devm_kzallocd-data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/video/backlight/88pm860x_bl.c: drop devm_kfree of devm_kzalloc'd data

devm_kfree() allocates memory that is released when a driver detaches. 
Thus, there is no reason to explicitly call devm_kfree() in probe or remove
functions.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/88pm860x_bl.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff -puN drivers/video/backlight/88pm860x_bl.c~drivers-video-backlight-88pm860x_blc-drop-devm_kfree-of-devm_kzallocd-data drivers/video/backlight/88pm860x_bl.c
--- a/drivers/video/backlight/88pm860x_bl.c~drivers-video-backlight-88pm860x_blc-drop-devm_kfree-of-devm_kzallocd-data
+++ a/drivers/video/backlight/88pm860x_bl.c
@@ -208,22 +208,19 @@ static int pm860x_backlight_probe(struct
 	res = platform_get_resource_byname(pdev, IORESOURCE_REG, "duty cycle");
 	if (!res) {
 		dev_err(&pdev->dev, "No REG resource for duty cycle\n");
-		ret = -ENXIO;
-		goto out;
+		return -ENXIO;
 	}
 	data->reg_duty_cycle = res->start;
 	res = platform_get_resource_byname(pdev, IORESOURCE_REG, "always on");
 	if (!res) {
 		dev_err(&pdev->dev, "No REG resorce for always on\n");
-		ret = -ENXIO;
-		goto out;
+		return -ENXIO;
 	}
 	data->reg_always_on = res->start;
 	res = platform_get_resource_byname(pdev, IORESOURCE_REG, "current");
 	if (!res) {
 		dev_err(&pdev->dev, "No REG resource for current\n");
-		ret = -ENXIO;
-		goto out;
+		return -ENXIO;
 	}
 	data->reg_current = res->start;
 
@@ -263,8 +260,6 @@ static int pm860x_backlight_probe(struct
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

