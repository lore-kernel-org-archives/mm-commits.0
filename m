From: akpm@linux-foundation.org
Subject: + rtc-max77686-use-devm_kzalloc.patch added to -mm tree
Date: Thu, 28 Feb 2013 14:27:00 -0800
Message-ID: <20130228222701.3FC2F31C26C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:50783 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787Ab3B1W1C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 17:27:02 -0500
Received: by mail-qc0-f202.google.com with SMTP id k26so43835qcs.1
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 14:27:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: drivers/rtc/rtc-max77686.c: use devm_kzalloc()
has been added to the -mm tree.  Its filename is
     rtc-max77686-use-devm_kzalloc.patch

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
Subject: drivers/rtc/rtc-max77686.c: use devm_kzalloc()

Use devm_kzalloc() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max77686.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN drivers/rtc/rtc-max77686.c~rtc-max77686-use-devm_kzalloc drivers/rtc/rtc-max77686.c
--- a/drivers/rtc/rtc-max77686.c~rtc-max77686-use-devm_kzalloc
+++ a/drivers/rtc/rtc-max77686.c
@@ -505,7 +505,8 @@ static int max77686_rtc_probe(struct pla
 
 	dev_info(&pdev->dev, "%s\n", __func__);
 
-	info = kzalloc(sizeof(struct max77686_rtc_info), GFP_KERNEL);
+	info = devm_kzalloc(&pdev->dev, sizeof(struct max77686_rtc_info),
+				GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
 
@@ -519,7 +520,6 @@ static int max77686_rtc_probe(struct pla
 		ret = PTR_ERR(info->max77686->rtc_regmap);
 		dev_err(info->max77686->dev, "Failed to allocate register map: %d\n",
 				ret);
-		kfree(info);
 		return ret;
 	}
 	platform_set_drvdata(pdev, info);
@@ -563,11 +563,7 @@ static int max77686_rtc_probe(struct pla
 		goto err_rtc;
 	}
 
-	goto out;
 err_rtc:
-	kfree(info);
-	return ret;
-out:
 	return ret;
 }
 
@@ -578,7 +574,6 @@ static int max77686_rtc_remove(struct pl
 	if (info) {
 		free_irq(info->virq, info);
 		rtc_device_unregister(info->rtc_dev);
-		kfree(info);
 	}
 
 	return 0;
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
drivers-video-backlight-ams369fg06c-convert-ams369fg06-to-dev_pm_ops.patch
drivers-video-backlight-ams369fg06c-convert-ams369fg06-to-dev_pm_ops-fix.patch
backlight-platform_lcd-remove-unnecessary-ifdefs.patch
rtc-rtc-mv-add-__init-annotation.patch
rtc-rtc-davinci-add-__exit-annotation.patch
rtc-rtc-ds1302-add-__exit-annotation.patch
rtc-rtc-imxdi-add-__init-__exit-annotation.patch
rtc-rtc-nuc900-add-__init-__exit-annotation.patch
rtc-rtc-pcap-add-__init-__exit-annotation.patch
rtc-rtc-tegra-add-__init-__exit-annotation.patch
rtc-max77686-use-module_platform_driver.patch
rtc-max77686-add-missing-module-author-name.patch
rtc-max77686-use-devm_kzalloc.patch
rtc-max77686-fix-indentation-of-bit-definitions.patch
rtc-max77686-use-dev_info-dev_emerg-instead-of-pr_info-pr_emerg.patch
rtc-rtc-v3020-use-gpio_request_array.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

