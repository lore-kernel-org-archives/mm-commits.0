From: akpm@linux-foundation.org
Subject: [merged] backlight-da903x_bl-use-dev_get_drvdata-instead-of-platform_get_drvdata.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:03:49 -0800
Message-ID: <20121218200350.33B4E20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f201.google.com ([74.125.82.201]:59713 "EHLO
	mail-we0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2LRUDw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:03:52 -0500
Received: by mail-we0-f201.google.com with SMTP id t11so63380wey.4
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:03:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mike@compulab.co.il, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: da903x_bl: use dev_get_drvdata() instead of platform_get_drvdata()
has been removed from the -mm tree.  Its filename was
     backlight-da903x_bl-use-dev_get_drvdata-instead-of-platform_get_drvdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: da903x_bl: use dev_get_drvdata() instead of platform_get_drvdata()

dev_get_drvdata() can be used instead of platform_get_drvdata()
to make the code smaller.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Mike Rapoport <mike@compulab.co.il>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/da903x_bl.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/video/backlight/da903x_bl.c~backlight-da903x_bl-use-dev_get_drvdata-instead-of-platform_get_drvdata drivers/video/backlight/da903x_bl.c
--- a/drivers/video/backlight/da903x_bl.c~backlight-da903x_bl-use-dev_get_drvdata-instead-of-platform_get_drvdata
+++ a/drivers/video/backlight/da903x_bl.c
@@ -164,15 +164,14 @@ static int da903x_backlight_remove(struc
 #ifdef CONFIG_PM
 static int da903x_backlight_suspend(struct device *dev)
 {
-	struct platform_device *pdev = to_platform_device(dev);
-	struct backlight_device *bl = platform_get_drvdata(pdev);
+	struct backlight_device *bl = dev_get_drvdata(dev);
+
 	return da903x_backlight_set(bl, 0);
 }
 
 static int da903x_backlight_resume(struct device *dev)
 {
-	struct platform_device *pdev = to_platform_device(dev);
-	struct backlight_device *bl = platform_get_drvdata(pdev);
+	struct backlight_device *bl = dev_get_drvdata(dev);
 
 	backlight_update_status(bl);
 	return 0;
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
backlight-locomolcd-fix-checkpatch-error-and-warning.patch

