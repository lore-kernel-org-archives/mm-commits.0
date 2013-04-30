From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-rv3029c2-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:57:49 -0700
Message-ID: <20130430185749.716945A41E9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:60110 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933428Ab3D3S5u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:57:50 -0400
Received: by mail-yh0-f74.google.com with SMTP id z12so86732yhz.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:57:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-rv3029c2: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-rv3029c2-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-rv3029c2: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup paths
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rv3029c2.c |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff -puN drivers/rtc/rtc-rv3029c2.c~rtc-rtc-rv3029c2-use-devm_rtc_device_register drivers/rtc/rtc-rv3029c2.c
--- a/drivers/rtc/rtc-rv3029c2.c~rtc-rtc-rv3029c2-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-rv3029c2.c
@@ -395,9 +395,8 @@ static int rv3029c2_probe(struct i2c_cli
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_EMUL))
 		return -ENODEV;
 
-	rtc = rtc_device_register(client->name,
-				&client->dev, &rv3029c2_rtc_ops,
-				THIS_MODULE);
+	rtc = devm_rtc_device_register(&client->dev, client->name,
+					&rv3029c2_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
@@ -407,23 +406,14 @@ static int rv3029c2_probe(struct i2c_cli
 	rc = rv3029c2_i2c_get_sr(client, buf);
 	if (rc < 0) {
 		dev_err(&client->dev, "reading status failed\n");
-		goto exit_unregister;
+		return rc;
 	}
 
 	return 0;
-
-exit_unregister:
-	rtc_device_unregister(rtc);
-
-	return rc;
 }
 
 static int rv3029c2_remove(struct i2c_client *client)
 {
-	struct rtc_device *rtc = i2c_get_clientdata(client);
-
-	rtc_device_unregister(rtc);
