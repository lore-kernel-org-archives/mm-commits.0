From: akpm@linux-foundation.org
Subject: + rtc-tegra-use-managed-rtc_device_register.patch added to -mm tree
Date: Mon, 11 Mar 2013 13:28:18 -0700
Message-ID: <20130311202818.CB5B831C18B@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:60050 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505Ab3CKU2U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Mar 2013 16:28:20 -0400
Received: by mail-qc0-f202.google.com with SMTP id k26so353504qcs.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Mar 2013 13:28:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ldewangan@nvidia.com, jg1.han@samsung.com, swarren@nvidia.com, thierry.reding@avionic-design.de


The patch titled
     Subject: drivers/rtc/rtc-tegra.c: use managed rtc_device_register()
has been added to the -mm tree.  Its filename is
     rtc-tegra-use-managed-rtc_device_register.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Laxman Dewangan <ldewangan@nvidia.com>
Subject: drivers/rtc/rtc-tegra.c: use managed rtc_device_register()

Use devm_rtc_device_register() for registering RTC device.  This will
reduce the code for unregistering RTC device in cleanup path and remove
the implementation of remove callback of platform driver.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
Reviewed-by: Stephen Warren <swarren@nvidia.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tegra.c |   27 ++++-----------------------
 1 file changed, 4 insertions(+), 23 deletions(-)

diff -puN drivers/rtc/rtc-tegra.c~rtc-tegra-use-managed-rtc_device_register drivers/rtc/rtc-tegra.c
--- a/drivers/rtc/rtc-tegra.c~rtc-tegra-use-managed-rtc_device_register
+++ a/drivers/rtc/rtc-tegra.c
@@ -349,13 +349,11 @@ static int __init tegra_rtc_probe(struct
 
 	device_init_wakeup(&pdev->dev, 1);
 
-	info->rtc_dev = rtc_device_register(
-		pdev->name, &pdev->dev, &tegra_rtc_ops, THIS_MODULE);
+	info->rtc_dev = devm_rtc_device_register(dev_name(&pdev->dev),
+				&pdev->dev, &tegra_rtc_ops, THIS_MODULE);
 	if (IS_ERR(info->rtc_dev)) {
 		ret = PTR_ERR(info->rtc_dev);
-		info->rtc_dev = NULL;
-		dev_err(&pdev->dev,
-			"Unable to register device (err=%d).\n",
+		dev_err(&pdev->dev, "Unable to register device (err=%d).\n",
 			ret);
 		return ret;
 	}
@@ -367,28 +365,12 @@ static int __init tegra_rtc_probe(struct
 		dev_err(&pdev->dev,
 			"Unable to request interrupt for device (err=%d).\n",
 			ret);
-		goto err_dev_unreg;
+		return ret;
 	}
 
 	dev_notice(&pdev->dev, "Tegra internal Real Time Clock\n");
 
 	return 0;
-
-err_dev_unreg:
-	rtc_device_unregister(info->rtc_dev);
-
-	return ret;
-}
-
-static int __exit tegra_rtc_remove(struct platform_device *pdev)
-{
-	struct tegra_rtc_info *info = platform_get_drvdata(pdev);
-
-	rtc_device_unregister(info->rtc_dev);
-
-	platform_set_drvdata(pdev, NULL);
