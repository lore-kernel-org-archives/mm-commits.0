From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-ds1672-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:57:13 -0700
Message-ID: <20130430185713.70B525A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:51263 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932617Ab3D3S5O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:57:14 -0400
Received: by mail-yh0-f73.google.com with SMTP id f35so86711yha.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:57:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-ds1672: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-ds1672-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-ds1672: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup paths
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1672.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN drivers/rtc/rtc-ds1672.c~rtc-rtc-ds1672-use-devm_rtc_device_register drivers/rtc/rtc-ds1672.c
--- a/drivers/rtc/rtc-ds1672.c~rtc-rtc-ds1672-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-ds1672.c
@@ -155,11 +155,6 @@ static const struct rtc_class_ops ds1672
 
 static int ds1672_remove(struct i2c_client *client)
 {
-	struct rtc_device *rtc = i2c_get_clientdata(client);
-
-	if (rtc)
-		rtc_device_unregister(rtc);
-
 	return 0;
 }
 
@@ -177,7 +172,7 @@ static int ds1672_probe(struct i2c_clien
 
 	dev_info(&client->dev, "chip found, driver version " DRV_VERSION "\n");
 
-	rtc = rtc_device_register(ds1672_driver.driver.name, &client->dev,
+	rtc = devm_rtc_device_register(&client->dev, ds1672_driver.driver.name,
 				  &ds1672_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(rtc))
@@ -202,7 +197,6 @@ static int ds1672_probe(struct i2c_clien
 	return 0;
 
  exit_devreg:
-	rtc_device_unregister(rtc);
 	return err;
 }
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

