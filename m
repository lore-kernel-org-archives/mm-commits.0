From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-ams369fg06c-convert-ams369fg06-to-dev_pm_ops-fix.patch added to -mm tree
Date: Mon, 25 Feb 2013 14:53:11 -0800
Message-ID: <20130225225311.A42F35A42E2@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:56635 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124Ab3BYWxM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 17:53:12 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so364735vch.2
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 14:53:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: drivers-video-backlight-ams369fg06c-convert-ams369fg06-to-dev_pm_ops-fix
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-ams369fg06c-convert-ams369fg06-to-dev_pm_ops-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

origin.patch
linux-next.patch
backlight-ams369fg06-make-power_on-call-optional.patch
lib-devresc-fix-misplaced-endif.patch
drivers-video-backlight-ams369fg06c-convert-ams369fg06-to-dev_pm_ops.patch
drivers-video-backlight-ams369fg06c-convert-ams369fg06-to-dev_pm_ops-fix.patch
backlight-platform_lcd-remove-unnecessary-ifdefs.patch
rtc-rtc-v3020-use-gpio_request_array.patch
rtc-add-devm_rtc_device_registerunregister.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

