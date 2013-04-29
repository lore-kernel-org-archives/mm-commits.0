From: akpm@linux-foundation.org
Subject: [folded-merged] drivers-video-backlight-ams369fg06c-convert-ams369fg06-to-dev_pm_ops-fix.patch removed from -mm tree
Date: Mon, 29 Apr 2013 16:01:00 -0700
Message-ID: <20130429230100.98B125A418D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:43266 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757577Ab3D2XBC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Apr 2013 19:01:02 -0400
Received: by mail-gh0-f201.google.com with SMTP id r13so390545ghr.0
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2013 16:01:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers-video-backlight-ams369fg06c-convert-ams369fg06-to-dev_pm_ops-fix
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-ams369fg06c-convert-ams369fg06-to-dev_pm_ops-fix.patch

This patch was dropped because it was folded into drivers-video-backlight-ams369fg06c-convert-ams369fg06-to-dev_pm_ops.patch

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers-video-backlight-ams369fg06c-convert-ams369fg06-to-dev_pm_ops-fix

- Remove unnecessary ifdefs.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ams369fg06.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/video/backlight/ams369fg06.c~drivers-video-backlight-ams369fg06c-convert-ams369fg06-to-dev_pm_ops-fix drivers/video/backlight/ams369fg06.c
--- a/drivers/video/backlight/ams369fg06.c~drivers-video-backlight-ams369fg06c-convert-ams369fg06-to-dev_pm_ops-fix
+++ a/drivers/video/backlight/ams369fg06.c
@@ -533,7 +533,7 @@ static int ams369fg06_remove(struct spi_
 	return 0;
 }
 
-#if defined(CONFIG_PM)
+#ifdef CONFIG_PM_SLEEP
 static int ams369fg06_suspend(struct device *dev)
 {
 	struct ams369fg06 *lcd = dev_get_drvdata(dev);
@@ -555,10 +555,10 @@ static int ams369fg06_resume(struct devi
 
 	return ams369fg06_power(lcd, FB_BLANK_UNBLANK);
 }
+#endif
 
 static SIMPLE_DEV_PM_OPS(ams369fg06_pm_ops, ams369fg06_suspend,
 			ams369fg06_resume);
-#endif
 
 static void ams369fg06_shutdown(struct spi_device *spi)
 {
@@ -571,9 +571,7 @@ static struct spi_driver ams369fg06_driv
 	.driver = {
 		.name	= "ams369fg06",
 		.owner	= THIS_MODULE,
-#ifdef CONFIG_PM
 		.pm	= &ams369fg06_pm_ops,
-#endif
 	},
 	.probe		= ams369fg06_probe,
 	.remove		= ams369fg06_remove,
_

Patches currently in -mm which might be from jg1.han@samsung.com are


