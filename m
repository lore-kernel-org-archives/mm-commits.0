From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-fm3130-use-devm_-functions.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:00:15 -0700
Message-ID: <20130430190015.709C95A41E9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:41140 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932638Ab3D3TAQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:00:16 -0400
Received: by mail-qa0-f74.google.com with SMTP id bs12so88741qab.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:00:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-fm3130: use devm_*() functions
has been removed from the -mm tree.  Its filename was
     rtc-rtc-fm3130-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-fm3130: use devm_*() functions

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-fm3130.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN drivers/rtc/rtc-fm3130.c~rtc-rtc-fm3130-use-devm_-functions drivers/rtc/rtc-fm3130.c
--- a/drivers/rtc/rtc-fm3130.c~rtc-rtc-fm3130-use-devm_-functions
+++ a/drivers/rtc/rtc-fm3130.c
@@ -358,7 +358,7 @@ static int fm3130_probe(struct i2c_clien
 			I2C_FUNC_I2C | I2C_FUNC_SMBUS_WRITE_BYTE_DATA))
 		return -EIO;
 
-	fm3130 = kzalloc(sizeof(struct fm3130), GFP_KERNEL);
+	fm3130 = devm_kzalloc(&client->dev, sizeof(struct fm3130), GFP_KERNEL);
 
 	if (!fm3130)
 		return -ENOMEM;
@@ -507,7 +507,7 @@ bad_clock:
 
 	/* We won't bail out here because we just got invalid data.
 	   Time setting from u-boot doesn't work anyway */
-	fm3130->rtc = rtc_device_register(client->name, &client->dev,
+	fm3130->rtc = devm_rtc_device_register(&client->dev, client->name,
 				&fm3130_rtc_ops, THIS_MODULE);
 	if (IS_ERR(fm3130->rtc)) {
 		err = PTR_ERR(fm3130->rtc);
@@ -517,16 +517,11 @@ bad_clock:
 	}
 	return 0;
 exit_free:
-	kfree(fm3130);
 	return err;
 }
 
 static int fm3130_remove(struct i2c_client *client)
 {
-	struct fm3130 *fm3130 = i2c_get_clientdata(client);
