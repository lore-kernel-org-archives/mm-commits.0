From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-ds1374c-use-devm_-apis.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:59:40 -0700
Message-ID: <20130430185940.6DA1931C27C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:55878 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933472Ab3D3S7l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:59:41 -0400
Received: by mail-ve0-f202.google.com with SMTP id ox1so77721veb.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:59:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sachin.kamat@linaro.org, jg1.han@samsung.com, scottwood@freescale.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-ds1374.c: use devm_* APIs
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-ds1374c-use-devm_-apis.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-ds1374.c: use devm_* APIs

devm_* functions are device managed and make cleanup code simpler.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Scott Wood <scottwood@freescale.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1374.c |   25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff -puN drivers/rtc/rtc-ds1374.c~drivers-rtc-rtc-ds1374c-use-devm_-apis drivers/rtc/rtc-ds1374.c
--- a/drivers/rtc/rtc-ds1374.c~drivers-rtc-rtc-ds1374c-use-devm_-apis
+++ a/drivers/rtc/rtc-ds1374.c
@@ -347,7 +347,7 @@ static int ds1374_probe(struct i2c_clien
 	struct ds1374 *ds1374;
 	int ret;
 
-	ds1374 = kzalloc(sizeof(struct ds1374), GFP_KERNEL);
+	ds1374 = devm_kzalloc(&client->dev, sizeof(struct ds1374), GFP_KERNEL);
 	if (!ds1374)
 		return -ENOMEM;
 
@@ -359,36 +359,27 @@ static int ds1374_probe(struct i2c_clien
 
 	ret = ds1374_check_rtc_status(client);
 	if (ret)
-		goto out_free;
+		return ret;
 
 	if (client->irq > 0) {
-		ret = request_irq(client->irq, ds1374_irq, 0,
+		ret = devm_request_irq(&client->dev, client->irq, ds1374_irq, 0,
 		                  "ds1374", client);
 		if (ret) {
 			dev_err(&client->dev, "unable to request IRQ\n");
-			goto out_free;
+			return ret;
 		}
 
 		device_set_wakeup_capable(&client->dev, 1);
 	}
 
-	ds1374->rtc = rtc_device_register(client->name, &client->dev,
+	ds1374->rtc = devm_rtc_device_register(&client->dev, client->name,
 	                                  &ds1374_rtc_ops, THIS_MODULE);
 	if (IS_ERR(ds1374->rtc)) {
-		ret = PTR_ERR(ds1374->rtc);
 		dev_err(&client->dev, "unable to register the class device\n");
-		goto out_irq;
+		return PTR_ERR(ds1374->rtc);
 	}
 
 	return 0;
-
-out_irq:
-	if (client->irq > 0)
-		free_irq(client->irq, client);
-
-out_free:
-	kfree(ds1374);
-	return ret;
 }
 
 static int ds1374_remove(struct i2c_client *client)
@@ -400,12 +391,10 @@ static int ds1374_remove(struct i2c_clie
 		ds1374->exiting = 1;
 		mutex_unlock(&ds1374->mutex);
 
-		free_irq(client->irq, client);
+		devm_free_irq(&client->dev, client->irq, client);
 		cancel_work_sync(&ds1374->work);
 	}
 
-	rtc_device_unregister(ds1374->rtc);
-	kfree(ds1374);
 	return 0;
 }
 
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

origin.patch
linux-next.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch

