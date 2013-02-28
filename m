From: akpm@linux-foundation.org
Subject: + rtc-rtc-tegra-add-__init-__exit-annotation.patch added to -mm tree
Date: Thu, 28 Feb 2013 13:33:10 -0800
Message-ID: <20130228213310.8E8AB5A41DD@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:35243 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758894Ab3B1VdL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 16:33:11 -0500
Received: by mail-yh0-f73.google.com with SMTP id 28so256761yhr.0
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 13:33:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: rtc: rtc-tegra: add __init/__exit annotation
has been added to the -mm tree.  Its filename is
     rtc-rtc-tegra-add-__init-__exit-annotation.patch

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
Subject: rtc: rtc-tegra: add __init/__exit annotation

When platform_driver_probe() is used, bind/unbind via sysfs is disabled. 
Thus, __init/__exit annotations can be added to probe()/remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tegra.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-tegra.c~rtc-rtc-tegra-add-__init-__exit-annotation drivers/rtc/rtc-tegra.c
--- a/drivers/rtc/rtc-tegra.c~rtc-rtc-tegra-add-__init-__exit-annotation
+++ a/drivers/rtc/rtc-tegra.c
@@ -309,7 +309,7 @@ static const struct of_device_id tegra_r
 };
 MODULE_DEVICE_TABLE(of, tegra_rtc_dt_match);
 
-static int tegra_rtc_probe(struct platform_device *pdev)
+static int __init tegra_rtc_probe(struct platform_device *pdev)
 {
 	struct tegra_rtc_info *info;
 	struct resource *res;
@@ -379,7 +379,7 @@ err_dev_unreg:
 	return ret;
 }
 
-static int tegra_rtc_remove(struct platform_device *pdev)
+static int __exit tegra_rtc_remove(struct platform_device *pdev)
 {
 	struct tegra_rtc_info *info = platform_get_drvdata(pdev);
 
@@ -439,7 +439,7 @@ static void tegra_rtc_shutdown(struct pl
 
 MODULE_ALIAS("platform:tegra_rtc");
 static struct platform_driver tegra_rtc_driver = {
-	.remove		= tegra_rtc_remove,
+	.remove		= __exit_p(tegra_rtc_remove),
 	.shutdown	= tegra_rtc_shutdown,
 	.driver		= {
 		.name	= "tegra_rtc",
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
rtc-rtc-v3020-use-gpio_request_array.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

