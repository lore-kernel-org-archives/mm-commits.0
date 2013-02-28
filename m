From: akpm@linux-foundation.org
Subject: + rtc-rtc-ds1302-add-__exit-annotation.patch added to -mm tree
Date: Thu, 28 Feb 2013 13:32:58 -0800
Message-ID: <20130228213259.312235A41DD@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:59275 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759820Ab3B1VdA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 16:33:00 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so254854vea.4
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 13:32:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: rtc: rtc-ds1302: add __exit annotation
has been added to the -mm tree.  Its filename is
     rtc-rtc-ds1302-add-__exit-annotation.patch

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
Subject: rtc: rtc-ds1302: add __exit annotation

When platform_driver_probe() is used, bind/unbind via sysfs is disabled. 
Thus, __init/__exit annotations can be added to probe()/remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1302.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-ds1302.c~rtc-rtc-ds1302-add-__exit-annotation drivers/rtc/rtc-ds1302.c
--- a/drivers/rtc/rtc-ds1302.c~rtc-rtc-ds1302-add-__exit-annotation
+++ a/drivers/rtc/rtc-ds1302.c
@@ -234,7 +234,7 @@ static int __init ds1302_rtc_probe(struc
 	return 0;
 }
 
-static int ds1302_rtc_remove(struct platform_device *pdev)
+static int __exit ds1302_rtc_remove(struct platform_device *pdev)
 {
 	struct rtc_device *rtc = platform_get_drvdata(pdev);
 
@@ -249,7 +249,7 @@ static struct platform_driver ds1302_pla
 		.name	= DRV_NAME,
 		.owner	= THIS_MODULE,
 	},
-	.remove		= ds1302_rtc_remove,
+	.remove		= __exit_p(ds1302_rtc_remove),
 };
 
 static int __init ds1302_rtc_init(void)
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

