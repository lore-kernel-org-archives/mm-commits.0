From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-sun4v-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:57:59 -0700
Message-ID: <20130430185759.6FACB5A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:64865 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933437Ab3D3S6A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:58:00 -0400
Received: by mail-qe0-f73.google.com with SMTP id 9so87025qea.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:57:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-sun4v: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-sun4v-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-sun4v: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup paths
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-sun4v.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-sun4v.c~rtc-rtc-sun4v-use-devm_rtc_device_register drivers/rtc/rtc-sun4v.c
--- a/drivers/rtc/rtc-sun4v.c~rtc-rtc-sun4v-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-sun4v.c
@@ -81,8 +81,10 @@ static const struct rtc_class_ops sun4v_
 
 static int __init sun4v_rtc_probe(struct platform_device *pdev)
 {
-	struct rtc_device *rtc = rtc_device_register("sun4v", &pdev->dev,
-				     &sun4v_rtc_ops, THIS_MODULE);
+	struct rtc_device *rtc;
+
+	rtc = devm_rtc_device_register(&pdev->dev, "sun4v",
+				&sun4v_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
 
@@ -92,9 +94,6 @@ static int __init sun4v_rtc_probe(struct
 
 static int __exit sun4v_rtc_remove(struct platform_device *pdev)
 {
-	struct rtc_device *rtc = platform_get_drvdata(pdev);
