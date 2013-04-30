From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-isl12022-use-devm_-functions.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:00:17 -0700
Message-ID: <20130430190017.72A0A5A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:38207 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933291Ab3D3TAS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:00:18 -0400
Received: by mail-qc0-f202.google.com with SMTP id k26so87284qcs.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:00:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-isl12022: use devm_*() functions
has been removed from the -mm tree.  Its filename was
     rtc-rtc-isl12022-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-isl12022: use devm_*() functions

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-isl12022.c |   29 +++++++----------------------
 1 file changed, 7 insertions(+), 22 deletions(-)

diff -puN drivers/rtc/rtc-isl12022.c~rtc-rtc-isl12022-use-devm_-functions drivers/rtc/rtc-isl12022.c
--- a/drivers/rtc/rtc-isl12022.c~rtc-rtc-isl12022-use-devm_-functions
+++ a/drivers/rtc/rtc-isl12022.c
@@ -252,12 +252,11 @@ static int isl12022_probe(struct i2c_cli
 {
 	struct isl12022 *isl12022;
 
-	int ret = 0;
-
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
 		return -ENODEV;
 
-	isl12022 = kzalloc(sizeof(struct isl12022), GFP_KERNEL);
+	isl12022 = devm_kzalloc(&client->dev, sizeof(struct isl12022),
+				GFP_KERNEL);
 	if (!isl12022)
 		return -ENOMEM;
 
@@ -265,31 +264,17 @@ static int isl12022_probe(struct i2c_cli
 
 	i2c_set_clientdata(client, isl12022);
 
-	isl12022->rtc = rtc_device_register(isl12022_driver.driver.name,
-					    &client->dev,
-					    &isl12022_rtc_ops,
-					    THIS_MODULE);
-
-	if (IS_ERR(isl12022->rtc)) {
-		ret = PTR_ERR(isl12022->rtc);
-		goto exit_kfree;
-	}
+	isl12022->rtc = devm_rtc_device_register(&client->dev,
+					isl12022_driver.driver.name,
+					&isl12022_rtc_ops, THIS_MODULE);
+	if (IS_ERR(isl12022->rtc))
+		return PTR_ERR(isl12022->rtc);
 
 	return 0;
-
-exit_kfree:
-	kfree(isl12022);
-
-	return ret;
 }
 
 static int isl12022_remove(struct i2c_client *client)
 {
-	struct isl12022 *isl12022 = i2c_get_clientdata(client);
-
-	rtc_device_unregister(isl12022->rtc);
-	kfree(isl12022);
