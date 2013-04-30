From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-pcf8583-use-devm_-functions.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:00:46 -0700
Message-ID: <20130430190046.6EAF331C2AA@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:55604 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933573Ab3D3TAr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:00:47 -0400
Received: by mail-yh0-f74.google.com with SMTP id z12so87059yhz.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:00:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-pcf8583: use devm_*() functions
has been removed from the -mm tree.  Its filename was
     rtc-rtc-pcf8583-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-pcf8583: use devm_*() functions

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf8583.c |   24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

diff -puN drivers/rtc/rtc-pcf8583.c~rtc-rtc-pcf8583-use-devm_-functions drivers/rtc/rtc-pcf8583.c
--- a/drivers/rtc/rtc-pcf8583.c~rtc-rtc-pcf8583-use-devm_-functions
+++ a/drivers/rtc/rtc-pcf8583.c
@@ -268,39 +268,29 @@ static int pcf8583_probe(struct i2c_clie
 				const struct i2c_device_id *id)
 {
 	struct pcf8583 *pcf8583;
-	int err;
 
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
 		return -ENODEV;
 
-	pcf8583 = kzalloc(sizeof(struct pcf8583), GFP_KERNEL);
+	pcf8583 = devm_kzalloc(&client->dev, sizeof(struct pcf8583),
+				GFP_KERNEL);
 	if (!pcf8583)
 		return -ENOMEM;
 
 	i2c_set_clientdata(client, pcf8583);
 
-	pcf8583->rtc = rtc_device_register(pcf8583_driver.driver.name,
-			&client->dev, &pcf8583_rtc_ops, THIS_MODULE);
+	pcf8583->rtc = devm_rtc_device_register(&client->dev,
+				pcf8583_driver.driver.name,
+				&pcf8583_rtc_ops, THIS_MODULE);
 
-	if (IS_ERR(pcf8583->rtc)) {
-		err = PTR_ERR(pcf8583->rtc);
-		goto exit_kfree;
-	}
+	if (IS_ERR(pcf8583->rtc))
+		return PTR_ERR(pcf8583->rtc);
 
 	return 0;
-
-exit_kfree:
-	kfree(pcf8583);
-	return err;
 }
 
 static int pcf8583_remove(struct i2c_client *client)
 {
-	struct pcf8583 *pcf8583 = i2c_get_clientdata(client);
