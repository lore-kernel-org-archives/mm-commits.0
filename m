From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-ds1374c-use-devm_-apis.patch added to -mm tree
Date: Thu, 11 Apr 2013 16:01:45 -0700
Message-ID: <20130411230145.CD7B931C10E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:36798 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765445Ab3DKXBr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Apr 2013 19:01:47 -0400
Received: by mail-qa0-f73.google.com with SMTP id i20so101240qad.2
        for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2013 16:01:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org, jg1.han@samsung.com, scottwood@freescale.com


The patch titled
     Subject: drivers/rtc/rtc-ds1374.c: use devm_* APIs
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-ds1374c-use-devm_-apis.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
drivers-video-exynos-exynos_mipi_dsic-convert-to-devm_ioremap_resource.patch
drivers-rtc-rtc-tps6586xc-remove-incorrect-use-of-rtc_device_unregister.patch
drivers-rtc-rtc-tps65910c-fix-incorrect-return-value-on-error.patch
drivers-rtc-rtc-max8997c-fix-incorrect-return-value-on-error.patch
drivers-rtc-rtc-max77686c-fix-incorrect-return-value-on-error.patch
drivers-rtc-rtc-max8907c-remove-redundant-code.patch
drivers-rtc-rtc-max77686c-use-devm_regmap_init_i2c.patch
drivers-rtc-rtc-88pm860xc-use-devm_-apis.patch
drivers-rtc-rtc-at32ap700xc-use-devm_-apis.patch
drivers-rtc-rtc-ds1305c-use-devm_-apis.patch
drivers-rtc-rtc-ds1374c-use-devm_-apis.patch
drivers-rtc-rtc-ds3232c-use-devm_-apis.patch
drivers-rtc-rtc-m48t35c-use-devm_-apis.patch
drivers-rtc-rtc-max8925c-use-devm_-apis.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch

