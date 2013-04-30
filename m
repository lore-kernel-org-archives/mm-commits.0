From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-ds3232c-use-devm_-apis.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:59:43 -0700
Message-ID: <20130430185943.7735E5A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:63826 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933472Ab3D3S7o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:59:44 -0400
Received: by mail-vc0-f202.google.com with SMTP id hr11so87276vcb.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:59:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sachin.kamat@linaro.org, jg1.han@samsung.com, srikanth.srinivasan@freescale.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-ds3232.c: use devm_* APIs
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-ds3232c-use-devm_-apis.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-ds3232.c: use devm_* APIs

devm_* functions are device managed and make cleanup code simpler.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Srikanth Srinivasan <srikanth.srinivasan@freescale.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds3232.c |   25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff -puN drivers/rtc/rtc-ds3232.c~drivers-rtc-rtc-ds3232c-use-devm_-apis drivers/rtc/rtc-ds3232.c
--- a/drivers/rtc/rtc-ds3232.c~drivers-rtc-rtc-ds3232c-use-devm_-apis
+++ a/drivers/rtc/rtc-ds3232.c
@@ -397,7 +397,7 @@ static int ds3232_probe(struct i2c_clien
 	struct ds3232 *ds3232;
 	int ret;
 
-	ds3232 = kzalloc(sizeof(struct ds3232), GFP_KERNEL);
+	ds3232 = devm_kzalloc(&client->dev, sizeof(struct ds3232), GFP_KERNEL);
 	if (!ds3232)
 		return -ENOMEM;
 
@@ -409,34 +409,25 @@ static int ds3232_probe(struct i2c_clien
 
 	ret = ds3232_check_rtc_status(client);
 	if (ret)
-		goto out_free;
+		return ret;
 
-	ds3232->rtc = rtc_device_register(client->name, &client->dev,
+	ds3232->rtc = devm_rtc_device_register(&client->dev, client->name,
 					  &ds3232_rtc_ops, THIS_MODULE);
 	if (IS_ERR(ds3232->rtc)) {
-		ret = PTR_ERR(ds3232->rtc);
 		dev_err(&client->dev, "unable to register the class device\n");
-		goto out_irq;
+		return PTR_ERR(ds3232->rtc);
 	}
 
 	if (client->irq >= 0) {
-		ret = request_irq(client->irq, ds3232_irq, 0,
+		ret = devm_request_irq(&client->dev, client->irq, ds3232_irq, 0,
 				 "ds3232", client);
 		if (ret) {
 			dev_err(&client->dev, "unable to request IRQ\n");
-			goto out_free;
+			return ret;
 		}
 	}
 
 	return 0;
-
-out_irq:
-	if (client->irq >= 0)
-		free_irq(client->irq, client);
-
-out_free:
-	kfree(ds3232);
-	return ret;
 }
 
 static int ds3232_remove(struct i2c_client *client)
@@ -448,12 +439,10 @@ static int ds3232_remove(struct i2c_clie
 		ds3232->exiting = 1;
 		mutex_unlock(&ds3232->mutex);
 
-		free_irq(client->irq, client);
+		devm_free_irq(&client->dev, client->irq, client);
 		cancel_work_sync(&ds3232->work);
 	}
 
-	rtc_device_unregister(ds3232->rtc);
-	kfree(ds3232);
 	return 0;
 }
 
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

origin.patch
linux-next.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch

