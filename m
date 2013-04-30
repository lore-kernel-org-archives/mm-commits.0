From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-davinci-add-__exit-annotation.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:53:52 -0700
Message-ID: <20130430185352.726F031C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:61047 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933160Ab3D3Sxx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:53:53 -0400
Received: by mail-yh0-f74.google.com with SMTP id z12so86231yhz.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:53:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-davinci: add __exit annotation
has been removed from the -mm tree.  Its filename was
     rtc-rtc-davinci-add-__exit-annotation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

