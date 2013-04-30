From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-test-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:58:01 -0700
Message-ID: <20130430185801.7084431C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:33842 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933441Ab3D3S6D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:58:03 -0400
Received: by mail-qe0-f74.google.com with SMTP id a11so86999qen.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:58:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-test: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-test-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-test: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup paths
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-test.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN drivers/rtc/rtc-test.c~rtc-rtc-test-use-devm_rtc_device_register drivers/rtc/rtc-test.c
--- a/drivers/rtc/rtc-test.c~rtc-rtc-test-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-test.c
@@ -99,8 +99,10 @@ static DEVICE_ATTR(irq, S_IRUGO | S_IWUS
 static int test_probe(struct platform_device *plat_dev)
 {
 	int err;
-	struct rtc_device *rtc = rtc_device_register("test", &plat_dev->dev,
-						&test_rtc_ops, THIS_MODULE);
+	struct rtc_device *rtc;
+
+	rtc = devm_rtc_device_register(&plat_dev->dev, "test",
+				&test_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc)) {
 		err = PTR_ERR(rtc);
 		return err;
@@ -115,15 +117,11 @@ static int test_probe(struct platform_de
 	return 0;
 
 err:
-	rtc_device_unregister(rtc);
 	return err;
 }
 
 static int test_remove(struct platform_device *plat_dev)
 {
-	struct rtc_device *rtc = platform_get_drvdata(plat_dev);
