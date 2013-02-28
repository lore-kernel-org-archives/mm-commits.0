From: akpm@linux-foundation.org
Subject: + rtc-rtc-davinci-add-__exit-annotation.patch added to -mm tree
Date: Thu, 28 Feb 2013 13:32:55 -0800
Message-ID: <20130228213256.6A1EA5A41DD@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:52912 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759816Ab3B1Vc5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 16:32:57 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so256492yhz.3
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 13:32:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: rtc: rtc-davinci: add __exit annotation
has been added to the -mm tree.  Its filename is
     rtc-rtc-davinci-add-__exit-annotation.patch

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
Subject: rtc: rtc-davinci: add __exit annotation

When platform_driver_probe() is used, bind/unbind via sysfs is disabled. 
Thus, __init/__exit annotations can be added to probe()/remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-davinci.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-davinci.c~rtc-rtc-davinci-add-__exit-annotation drivers/rtc/rtc-davinci.c
--- a/drivers/rtc/rtc-davinci.c~rtc-rtc-davinci-add-__exit-annotation
+++ a/drivers/rtc/rtc-davinci.c
@@ -564,7 +564,7 @@ fail1:
 	return ret;
 }
 
-static int davinci_rtc_remove(struct platform_device *pdev)
+static int __exit davinci_rtc_remove(struct platform_device *pdev)
 {
 	struct davinci_rtc *davinci_rtc = platform_get_drvdata(pdev);
 
@@ -581,7 +581,7 @@ static int davinci_rtc_remove(struct pla
 
 static struct platform_driver davinci_rtc_driver = {
 	.probe		= davinci_rtc_probe,
-	.remove		= davinci_rtc_remove,
+	.remove		= __exit_p(davinci_rtc_remove),
 	.driver		= {
 		.name = "rtc_davinci",
 		.owner = THIS_MODULE,
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

