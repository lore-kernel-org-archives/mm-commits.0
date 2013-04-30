From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-em3027-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:57:20 -0700
Message-ID: <20130430185720.6E82931C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:51335 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933407Ab3D3S5W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:57:22 -0400
Received: by mail-ve0-f202.google.com with SMTP id ox1so77462veb.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:57:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-em3027: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-em3027-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-em3027: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup paths
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-em3027.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN drivers/rtc/rtc-em3027.c~rtc-rtc-em3027-use-devm_rtc_device_register drivers/rtc/rtc-em3027.c
--- a/drivers/rtc/rtc-em3027.c~rtc-rtc-em3027-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-em3027.c
@@ -121,7 +121,7 @@ static int em3027_probe(struct i2c_clien
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
 		return -ENODEV;
 
-	rtc = rtc_device_register(em3027_driver.driver.name, &client->dev,
+	rtc = devm_rtc_device_register(&client->dev, em3027_driver.driver.name,
 				  &em3027_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
@@ -133,11 +133,6 @@ static int em3027_probe(struct i2c_clien
 
 static int em3027_remove(struct i2c_client *client)
 {
-	struct rtc_device *rtc = i2c_get_clientdata(client);
-
-	if (rtc)
-		rtc_device_unregister(rtc);
