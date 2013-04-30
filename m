From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-m41t80-use-devm_-functions.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:00:20 -0700
Message-ID: <20130430190020.714A35A4278@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:53708 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933493Ab3D3TAV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:00:21 -0400
Received: by mail-qa0-f73.google.com with SMTP id p6so88681qad.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:00:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-m41t80: use devm_*() functions
has been removed from the -mm tree.  Its filename was
     rtc-rtc-m41t80-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-m41t80: use devm_*() functions

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-m41t80.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff -puN drivers/rtc/rtc-m41t80.c~rtc-rtc-m41t80-use-devm_-functions drivers/rtc/rtc-m41t80.c
--- a/drivers/rtc/rtc-m41t80.c~rtc-rtc-m41t80-use-devm_-functions
+++ a/drivers/rtc/rtc-m41t80.c
@@ -637,7 +637,8 @@ static int m41t80_probe(struct i2c_clien
 	dev_info(&client->dev,
 		 "chip found, driver version " DRV_VERSION "\n");
 
-	clientdata = kzalloc(sizeof(*clientdata), GFP_KERNEL);
+	clientdata = devm_kzalloc(&client->dev, sizeof(*clientdata),
+				GFP_KERNEL);
 	if (!clientdata) {
 		rc = -ENOMEM;
 		goto exit;
@@ -646,8 +647,8 @@ static int m41t80_probe(struct i2c_clien
 	clientdata->features = id->driver_data;
 	i2c_set_clientdata(client, clientdata);
 
-	rtc = rtc_device_register(client->name, &client->dev,
-				  &m41t80_rtc_ops, THIS_MODULE);
+	rtc = devm_rtc_device_register(&client->dev, client->name,
+					&m41t80_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc)) {
 		rc = PTR_ERR(rtc);
 		rtc = NULL;
@@ -718,26 +719,19 @@ ht_err:
 	goto exit;
 
 exit:
-	if (rtc)
-		rtc_device_unregister(rtc);
-	kfree(clientdata);
 	return rc;
 }
 
 static int m41t80_remove(struct i2c_client *client)
 {
+#ifdef CONFIG_RTC_DRV_M41T80_WDT
 	struct m41t80_data *clientdata = i2c_get_clientdata(client);
-	struct rtc_device *rtc = clientdata->rtc;
 
-#ifdef CONFIG_RTC_DRV_M41T80_WDT
 	if (clientdata->features & M41T80_FEATURE_HT) {
 		misc_deregister(&wdt_dev);
 		unregister_reboot_notifier(&wdt_notifier);
 	}
 #endif
-	if (rtc)
-		rtc_device_unregister(rtc);
-	kfree(clientdata);
 
 	return 0;
 }
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

