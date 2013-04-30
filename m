From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-pcf8523-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:56:08 -0700
Message-ID: <20130430185608.6F0F95A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:33421 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933263Ab3D3S4J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:56:09 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so86683ggm.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:56:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-pcf8523: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-pcf8523-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-pcf8523: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf8523.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-pcf8523.c~rtc-rtc-pcf8523-use-devm_rtc_device_register drivers/rtc/rtc-pcf8523.c
--- a/drivers/rtc/rtc-pcf8523.c~rtc-rtc-pcf8523-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-pcf8523.c
@@ -307,7 +307,7 @@ static int pcf8523_probe(struct i2c_clie
 	if (err < 0)
 		return err;
 
-	pcf->rtc = rtc_device_register(DRIVER_NAME, &client->dev,
+	pcf->rtc = devm_rtc_device_register(&client->dev, DRIVER_NAME,
 				       &pcf8523_rtc_ops, THIS_MODULE);
 	if (IS_ERR(pcf->rtc))
 		return PTR_ERR(pcf->rtc);
@@ -319,10 +319,6 @@ static int pcf8523_probe(struct i2c_clie
 
 static int pcf8523_remove(struct i2c_client *client)
 {
-	struct pcf8523 *pcf = i2c_get_clientdata(client);
-
-	rtc_device_unregister(pcf->rtc);
