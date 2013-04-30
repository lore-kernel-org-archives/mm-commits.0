From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-starfire-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:57:56 -0700
Message-ID: <20130430185756.738ED31C27C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:58896 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933436Ab3D3S55 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:57:57 -0400
Received: by mail-ve0-f202.google.com with SMTP id ox1so77506veb.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:57:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-starfire: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-starfire-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-starfire: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup paths
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-starfire.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN drivers/rtc/rtc-starfire.c~rtc-rtc-starfire-use-devm_rtc_device_register drivers/rtc/rtc-starfire.c
--- a/drivers/rtc/rtc-starfire.c~rtc-rtc-starfire-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-starfire.c
@@ -39,8 +39,10 @@ static const struct rtc_class_ops starfi
 
 static int __init starfire_rtc_probe(struct platform_device *pdev)
 {
-	struct rtc_device *rtc = rtc_device_register("starfire", &pdev->dev,
-				     &starfire_rtc_ops, THIS_MODULE);
+	struct rtc_device *rtc;
+
+	rtc = devm_rtc_device_register(&pdev->dev, "starfire",
+				&starfire_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
 
@@ -51,10 +53,6 @@ static int __init starfire_rtc_probe(str
 
 static int __exit starfire_rtc_remove(struct platform_device *pdev)
 {
-	struct rtc_device *rtc = platform_get_drvdata(pdev);
-
-	rtc_device_unregister(rtc);
