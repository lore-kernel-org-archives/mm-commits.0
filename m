From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-rx8581-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:57:53 -0700
Message-ID: <20130430185753.6DFC331C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:48860 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933428Ab3D3S5y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:57:54 -0400
Received: by mail-gg0-f201.google.com with SMTP id y3so86982ggc.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:57:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-rx8581: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-rx8581-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-rx8581: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup paths
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rx8581.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN drivers/rtc/rtc-rx8581.c~rtc-rtc-rx8581-use-devm_rtc_device_register drivers/rtc/rtc-rx8581.c
--- a/drivers/rtc/rtc-rx8581.c~rtc-rtc-rx8581-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-rx8581.c
@@ -240,8 +240,8 @@ static int rx8581_probe(struct i2c_clien
 
 	dev_info(&client->dev, "chip found, driver version " DRV_VERSION "\n");
 
-	rtc = rtc_device_register(rx8581_driver.driver.name,
-				&client->dev, &rx8581_rtc_ops, THIS_MODULE);
+	rtc = devm_rtc_device_register(&client->dev, rx8581_driver.driver.name,
+					&rx8581_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
@@ -253,10 +253,6 @@ static int rx8581_probe(struct i2c_clien
 
 static int rx8581_remove(struct i2c_client *client)
 {
-	struct rtc_device *rtc = i2c_get_clientdata(client);
-
-	rtc_device_unregister(rtc);
