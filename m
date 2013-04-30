From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-m48t86-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:57:33 -0700
Message-ID: <20130430185733.6E6D131C2AA@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:35166 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933391Ab3D3S5e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:57:34 -0400
Received: by mail-qa0-f73.google.com with SMTP id p6so88312qad.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:57:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-m48t86: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-m48t86-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-m48t86: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup paths
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-m48t86.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff -puN drivers/rtc/rtc-m48t86.c~rtc-rtc-m48t86-use-devm_rtc_device_register drivers/rtc/rtc-m48t86.c
--- a/drivers/rtc/rtc-m48t86.c~rtc-rtc-m48t86-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-m48t86.c
@@ -148,8 +148,10 @@ static int m48t86_rtc_probe(struct platf
 {
 	unsigned char reg;
 	struct m48t86_ops *ops = dev->dev.platform_data;
-	struct rtc_device *rtc = rtc_device_register("m48t86",
-				&dev->dev, &m48t86_rtc_ops, THIS_MODULE);
+	struct rtc_device *rtc;
+
+	rtc = devm_rtc_device_register(&dev->dev, "m48t86",
+				&m48t86_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
@@ -166,11 +168,6 @@ static int m48t86_rtc_probe(struct platf
 
 static int m48t86_rtc_remove(struct platform_device *dev)
 {
-	struct rtc_device *rtc = platform_get_drvdata(dev);
-
- 	if (rtc)
-		rtc_device_unregister(rtc);
