From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-rs5c372-use-devm_-functions.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:00:54 -0700
Message-ID: <20130430190054.700515A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:60853 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933292Ab3D3TAz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:00:55 -0400
Received: by mail-qc0-f201.google.com with SMTP id o22so87439qcr.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:00:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-rs5c372: use devm_*() functions
has been removed from the -mm tree.  Its filename was
     rtc-rtc-rs5c372-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-rs5c372: use devm_*() functions

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rs5c372.c |   30 +++++++++++-------------------
 1 file changed, 11 insertions(+), 19 deletions(-)

diff -puN drivers/rtc/rtc-rs5c372.c~rtc-rtc-rs5c372-use-devm_-functions drivers/rtc/rtc-rs5c372.c
--- a/drivers/rtc/rtc-rs5c372.c~rtc-rtc-rs5c372-use-devm_-functions
+++ a/drivers/rtc/rtc-rs5c372.c
@@ -579,7 +579,9 @@ static int rs5c372_probe(struct i2c_clie
 		}
 	}
 
-	if (!(rs5c372 = kzalloc(sizeof(struct rs5c372), GFP_KERNEL))) {
+	rs5c372 = devm_kzalloc(&client->dev, sizeof(struct rs5c372),
+				GFP_KERNEL);
+	if (!rs5c372) {
 		err = -ENOMEM;
 		goto exit;
 	}
@@ -594,7 +596,7 @@ static int rs5c372_probe(struct i2c_clie
 
 	err = rs5c_get_regs(rs5c372);
 	if (err < 0)
-		goto exit_kfree;
+		goto exit;
 
 	/* clock may be set for am/pm or 24 hr time */
 	switch (rs5c372->type) {
@@ -617,7 +619,7 @@ static int rs5c372_probe(struct i2c_clie
 		break;
 	default:
 		dev_err(&client->dev, "unknown RTC type\n");
-		goto exit_kfree;
+		goto exit;
 	}
 
 	/* if the oscillator lost power and no other software (like
@@ -629,7 +631,7 @@ static int rs5c372_probe(struct i2c_clie
 	err = rs5c_oscillator_setup(rs5c372);
 	if (unlikely(err < 0)) {
 		dev_err(&client->dev, "setup error\n");
-		goto exit_kfree;
+		goto exit;
 	}
 
 	if (rs5c372_get_datetime(client, &tm) < 0)
@@ -648,38 +650,28 @@ static int rs5c372_probe(struct i2c_clie
 			);
 
 	/* REVISIT use client->irq to register alarm irq ... */
-
-	rs5c372->rtc = rtc_device_register(rs5c372_driver.driver.name,
-				&client->dev, &rs5c372_rtc_ops, THIS_MODULE);
+	rs5c372->rtc = devm_rtc_device_register(&client->dev,
+					rs5c372_driver.driver.name,
+					&rs5c372_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(rs5c372->rtc)) {
 		err = PTR_ERR(rs5c372->rtc);
-		goto exit_kfree;
+		goto exit;
 	}
 
 	err = rs5c_sysfs_register(&client->dev);
 	if (err)
-		goto exit_devreg;
+		goto exit;
 
 	return 0;
 
-exit_devreg:
-	rtc_device_unregister(rs5c372->rtc);
-
-exit_kfree:
-	kfree(rs5c372);
-
 exit:
 	return err;
 }
 
 static int rs5c372_remove(struct i2c_client *client)
 {
-	struct rs5c372 *rs5c372 = i2c_get_clientdata(client);
