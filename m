From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-x1205-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:58:08 -0700
Message-ID: <20130430185808.5F9A45A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:37449 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933441Ab3D3S6J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:58:09 -0400
Received: by mail-ve0-f202.google.com with SMTP id ox1so77540veb.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:58:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-x1205: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-x1205-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-x1205: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup paths
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-x1205.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff -puN drivers/rtc/rtc-x1205.c~rtc-rtc-x1205-use-devm_rtc_device_register drivers/rtc/rtc-x1205.c
--- a/drivers/rtc/rtc-x1205.c~rtc-rtc-x1205-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-x1205.c
@@ -630,8 +630,8 @@ static int x1205_probe(struct i2c_client
 
 	dev_info(&client->dev, "chip found, driver version " DRV_VERSION "\n");
 
-	rtc = rtc_device_register(x1205_driver.driver.name, &client->dev,
-				&x1205_rtc_ops, THIS_MODULE);
+	rtc = devm_rtc_device_register(&client->dev, x1205_driver.driver.name,
+					&x1205_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
@@ -653,21 +653,13 @@ static int x1205_probe(struct i2c_client
 
 	err = x1205_sysfs_register(&client->dev);
 	if (err)
-		goto exit_devreg;
+		return err;
 
 	return 0;
-
-exit_devreg:
-	rtc_device_unregister(rtc);
-
-	return err;
 }
 
 static int x1205_remove(struct i2c_client *client)
 {
-	struct rtc_device *rtc = i2c_get_clientdata(client);
