From: akpm@linux-foundation.org
Subject: + rtc-rtc-tx4939-use-devm_rtc_device_register.patch added to -mm tree
Date: Wed, 06 Mar 2013 13:21:44 -0800
Message-ID: <20130306212144.AC9BB31C241@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:57767 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755642Ab3CFVVp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Mar 2013 16:21:45 -0500
Received: by mail-qc0-f202.google.com with SMTP id k26so343745qcs.1
        for <mm-commits@vger.kernel.org>; Wed, 06 Mar 2013 13:21:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: rtc: rtc-tx4939: use devm_rtc_device_register()
has been added to the -mm tree.  Its filename is
     rtc-rtc-tx4939-use-devm_rtc_device_register.patch

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
Subject: rtc: rtc-tx4939: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tx4939.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-tx4939.c~rtc-rtc-tx4939-use-devm_rtc_device_register drivers/rtc/rtc-tx4939.c
--- a/drivers/rtc/rtc-tx4939.c~rtc-rtc-tx4939-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-tx4939.c
@@ -268,14 +268,13 @@ static int __init tx4939_rtc_probe(struc
 	if (devm_request_irq(&pdev->dev, irq, tx4939_rtc_interrupt,
 			     0, pdev->name, &pdev->dev) < 0)
 		return -EBUSY;
-	rtc = rtc_device_register(pdev->name, &pdev->dev,
+	rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 				  &tx4939_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
 	pdata->rtc = rtc;
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &tx4939_rtc_nvram_attr);
-	if (ret)
-		rtc_device_unregister(rtc);
+
 	return ret;
 }
 
@@ -284,7 +283,6 @@ static int __exit tx4939_rtc_remove(stru
 	struct tx4939rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
 	sysfs_remove_bin_file(&pdev->dev.kobj, &tx4939_rtc_nvram_attr);
-	rtc_device_unregister(pdata->rtc);
 	spin_lock_irq(&pdata->lock);
 	tx4939_rtc_cmd(pdata->rtcreg, TX4939_RTCCTL_COMMAND_NOP);
 	spin_unlock_irq(&pdata->lock);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

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
rtc-add-devm_rtc_device_registerunregister.patch
rtc-max77686-use-module_platform_driver.patch
rtc-max77686-add-missing-module-author-name.patch
rtc-max77686-use-devm_kzalloc.patch
rtc-max77686-fix-indentation-of-bit-definitions.patch
rtc-max77686-use-dev_info-dev_emerg-instead-of-pr_info-pr_emerg.patch
rtc-rtc-v3020-use-gpio_request_array.patch
rtc-rtc-88pm80x-use-devm_rtc_device_register.patch
rtc-rtc-coh90133-use-devm_rtc_device_register.patch
rtc-rtc-da9052-use-devm_rtc_device_register.patch
rtc-rtc-da9055-use-devm_rtc_device_register.patch
rtc-rtc-davinci-use-devm_rtc_device_register.patch
rtc-rtc-ds1511-use-devm_rtc_device_register.patch
rtc-rtc-ds1553-use-devm_rtc_device_register.patch
rtc-rtc-ds1742-use-devm_rtc_device_register.patch
rtc-rtc-ep93xx-use-devm_rtc_device_register.patch
rtc-rtc-imxdi-use-devm_rtc_device_register.patch
rtc-rtc-lp8788-use-devm_rtc_device_register.patch
rtc-rtc-lpc32xx-use-devm_rtc_device_register.patch
rtc-rtc-max77686-use-devm_rtc_device_register.patch
rtc-rtc-max8907-use-devm_rtc_device_register.patch
rtc-rtc-max8997-use-devm_rtc_device_register.patch
rtc-rtc-mv-use-devm_rtc_device_register.patch
rtc-rtc-mxc-use-devm_rtc_device_register.patch
rtc-rtc-palmas-use-devm_rtc_device_register.patch
rtc-rtc-pcf8523-use-devm_rtc_device_register.patch
rtc-rtc-s3c-use-devm_rtc_device_register.patch
rtc-rtc-snvs-use-devm_rtc_device_register.patch
rtc-rtc-spear-use-devm_rtc_device_register.patch
rtc-rtc-stk17ta8-use-devm_rtc_device_register.patch
rtc-rtc-tegra-use-devm_rtc_device_register.patch
rtc-rtc-tps6586x-use-devm_rtc_device_register.patch
rtc-rtc-tps65910-use-devm_rtc_device_register.patch
rtc-rtc-tps80031-use-devm_rtc_device_register.patch
rtc-rtc-tx4939-use-devm_rtc_device_register.patch
rtc-rtc-vt8500-use-devm_rtc_device_register.patch
rtc-rtc-wm831x-use-devm_rtc_device_register.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

