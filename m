From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-pcf8563-use-devm_-functions.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:00:43 -0700
Message-ID: <20130430190043.70D935A41E9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:62447 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933285Ab3D3TAo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:00:44 -0400
Received: by mail-qa0-f74.google.com with SMTP id bs12so88804qab.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:00:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-pcf8563: use devm_*() functions
has been removed from the -mm tree.  Its filename was
     rtc-rtc-pcf8563-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-pcf8563: use devm_*() functions

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf8563.c |   28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

diff -puN drivers/rtc/rtc-pcf8563.c~rtc-rtc-pcf8563-use-devm_-functions drivers/rtc/rtc-pcf8563.c
--- a/drivers/rtc/rtc-pcf8563.c~rtc-rtc-pcf8563-use-devm_-functions
+++ a/drivers/rtc/rtc-pcf8563.c
@@ -245,14 +245,13 @@ static int pcf8563_probe(struct i2c_clie
 {
 	struct pcf8563 *pcf8563;
 
-	int err = 0;
-
 	dev_dbg(&client->dev, "%s\n", __func__);
 
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
 		return -ENODEV;
 
-	pcf8563 = kzalloc(sizeof(struct pcf8563), GFP_KERNEL);
+	pcf8563 = devm_kzalloc(&client->dev, sizeof(struct pcf8563),
+				GFP_KERNEL);
 	if (!pcf8563)
 		return -ENOMEM;
 
@@ -260,31 +259,18 @@ static int pcf8563_probe(struct i2c_clie
 
 	i2c_set_clientdata(client, pcf8563);
 
-	pcf8563->rtc = rtc_device_register(pcf8563_driver.driver.name,
-				&client->dev, &pcf8563_rtc_ops, THIS_MODULE);
+	pcf8563->rtc = devm_rtc_device_register(&client->dev,
+				pcf8563_driver.driver.name,
+				&pcf8563_rtc_ops, THIS_MODULE);
 
-	if (IS_ERR(pcf8563->rtc)) {
-		err = PTR_ERR(pcf8563->rtc);
-		goto exit_kfree;
-	}
+	if (IS_ERR(pcf8563->rtc))
+		return PTR_ERR(pcf8563->rtc);
 
 	return 0;
-
-exit_kfree:
-	kfree(pcf8563);
-
-	return err;
 }
 
 static int pcf8563_remove(struct i2c_client *client)
 {
-	struct pcf8563 *pcf8563 = i2c_get_clientdata(client);
-
-	if (pcf8563->rtc)
-		rtc_device_unregister(pcf8563->rtc);
-
-	kfree(pcf8563);
