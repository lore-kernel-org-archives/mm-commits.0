From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-isl1208c-use-devm_-apis.patch added to -mm tree
Date: Thu, 19 Sep 2013 15:10:14 -0700
Message-ID: <523b7646.aYkY0mm/ezgjeLJP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57797 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab3ISWKP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Sep 2013 18:10:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com, hvr@gnu.org, sachin.kamat@linaro.org

Subject: + drivers-rtc-rtc-isl1208c-use-devm_-apis.patch added to -mm tree
To: sachin.kamat@linaro.org,hvr@gnu.org,jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Thu, 19 Sep 2013 15:10:14 -0700


The patch titled
     Subject: drivers/rtc/rtc-isl1208.c: use devm_* APIs
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-isl1208c-use-devm_-apis.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-isl1208c-use-devm_-apis.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-isl1208c-use-devm_-apis.patch

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
Subject: drivers/rtc/rtc-isl1208.c: use devm_* APIs

devm_* APIs are device managed and make code simpler.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Herbert Valerio Riedel <hvr@gnu.org>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-isl1208.c |   36 +++++++++++-------------------------
 1 file changed, 11 insertions(+), 25 deletions(-)

diff -puN drivers/rtc/rtc-isl1208.c~drivers-rtc-rtc-isl1208c-use-devm_-apis drivers/rtc/rtc-isl1208.c
--- a/drivers/rtc/rtc-isl1208.c~drivers-rtc-rtc-isl1208c-use-devm_-apis
+++ a/drivers/rtc/rtc-isl1208.c
@@ -643,10 +643,11 @@ isl1208_probe(struct i2c_client *client,
 		 "chip found, driver version " DRV_VERSION "\n");
 
 	if (client->irq > 0) {
-		rc = request_threaded_irq(client->irq, NULL,
-					  isl1208_rtc_interrupt,
-					  IRQF_SHARED,
-					  isl1208_driver.driver.name, client);
+		rc = devm_request_threaded_irq(&client->dev, client->irq, NULL,
+					       isl1208_rtc_interrupt,
+					       IRQF_SHARED,
+					       isl1208_driver.driver.name,
+					       client);
 		if (!rc) {
 			device_init_wakeup(&client->dev, 1);
 			enable_irq_wake(client->irq);
@@ -658,20 +659,18 @@ isl1208_probe(struct i2c_client *client,
 		}
 	}
 
-	rtc = rtc_device_register(isl1208_driver.driver.name,
-				  &client->dev, &isl1208_rtc_ops,
+	rtc = devm_rtc_device_register(&client->dev, isl1208_driver.driver.name,
+				  &isl1208_rtc_ops,
 				  THIS_MODULE);
-	if (IS_ERR(rtc)) {
-		rc = PTR_ERR(rtc);
-		goto exit_free_irq;
-	}
+	if (IS_ERR(rtc))
+		return PTR_ERR(rtc);
 
 	i2c_set_clientdata(client, rtc);
 
 	rc = isl1208_i2c_get_sr(client);
 	if (rc < 0) {
 		dev_err(&client->dev, "reading status failed\n");
-		goto exit_unregister;
+		return rc;
 	}
 
 	if (rc & ISL1208_REG_SR_RTCF)
@@ -680,28 +679,15 @@ isl1208_probe(struct i2c_client *client,
 
 	rc = sysfs_create_group(&client->dev.kobj, &isl1208_rtc_sysfs_files);
 	if (rc)
-		goto exit_unregister;
+		return rc;
 
 	return 0;
-
-exit_unregister:
-	rtc_device_unregister(rtc);
-exit_free_irq:
-	if (client->irq)
-		free_irq(client->irq, client);
-
-	return rc;
 }
 
 static int
 isl1208_remove(struct i2c_client *client)
 {
-	struct rtc_device *rtc = i2c_get_clientdata(client);
