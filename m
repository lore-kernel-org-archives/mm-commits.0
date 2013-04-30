From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-bq32k-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:57:05 -0700
Message-ID: <20130430185705.6F3A15A426B@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:52121 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933350Ab3D3S5G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:57:06 -0400
Received: by mail-vc0-f201.google.com with SMTP id gf12so87034vcb.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:57:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-bq32k: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-bq32k-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-bq32k: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup paths
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-bq32k.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-bq32k.c~rtc-rtc-bq32k-use-devm_rtc_device_register drivers/rtc/rtc-bq32k.c
--- a/drivers/rtc/rtc-bq32k.c~rtc-rtc-bq32k-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-bq32k.c
@@ -153,7 +153,7 @@ static int bq32k_probe(struct i2c_client
 	if (error)
 		return error;
 
-	rtc = rtc_device_register(bq32k_driver.driver.name, &client->dev,
+	rtc = devm_rtc_device_register(&client->dev, bq32k_driver.driver.name,
 						&bq32k_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
@@ -165,9 +165,6 @@ static int bq32k_probe(struct i2c_client
 
 static int bq32k_remove(struct i2c_client *client)
 {
-	struct rtc_device *rtc = i2c_get_clientdata(client);
