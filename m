From: akpm@linux-foundation.org
Subject: + rtc-rtc-nuc900-add-__init-__exit-annotation.patch added to -mm tree
Date: Thu, 28 Feb 2013 13:33:03 -0800
Message-ID: <20130228213304.4B92931C1E1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:46078 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758894Ab3B1VdF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 16:33:05 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so254748ghb.4
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 13:33:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: rtc: rtc-nuc900: add __init/__exit annotation
has been added to the -mm tree.  Its filename is
     rtc-rtc-nuc900-add-__init-__exit-annotation.patch

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
Subject: rtc: rtc-nuc900: add __init/__exit annotation

When platform_driver_probe() is used, bind/unbind via sysfs is disabled. 
Thus, __init/__exit annotations can be added to probe()/remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-nuc900.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-nuc900.c~rtc-rtc-nuc900-add-__init-__exit-annotation drivers/rtc/rtc-nuc900.c
--- a/drivers/rtc/rtc-nuc900.c~rtc-rtc-nuc900-add-__init-__exit-annotation
+++ a/drivers/rtc/rtc-nuc900.c
@@ -222,7 +222,7 @@ static struct rtc_class_ops nuc900_rtc_o
 	.alarm_irq_enable = nuc900_alarm_irq_enable,
 };
 
-static int nuc900_rtc_probe(struct platform_device *pdev)
+static int __init nuc900_rtc_probe(struct platform_device *pdev)
 {
 	struct resource *res;
 	struct nuc900_rtc *nuc900_rtc;
@@ -284,7 +284,7 @@ fail1:	kfree(nuc900_rtc);
 	return err;
 }
 
-static int nuc900_rtc_remove(struct platform_device *pdev)
+static int __exit nuc900_rtc_remove(struct platform_device *pdev)
 {
 	struct nuc900_rtc *nuc900_rtc = platform_get_drvdata(pdev);
 	struct resource *res;
@@ -304,7 +304,7 @@ static int nuc900_rtc_remove(struct plat
 }
 
 static struct platform_driver nuc900_rtc_driver = {
-	.remove		= nuc900_rtc_remove,
+	.remove		= __exit_p(nuc900_rtc_remove),
 	.driver		= {
 		.name	= "nuc900-rtc",
 		.owner	= THIS_MODULE,
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

