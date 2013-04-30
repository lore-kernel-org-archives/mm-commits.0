From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-s35390a-use-devm_-functions.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:00:57 -0700
Message-ID: <20130430190057.6F30A5A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:41681 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933263Ab3D3TA6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:00:58 -0400
Received: by mail-yh0-f74.google.com with SMTP id z12so87176yhz.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:00:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-s35390a: use devm_*() functions
has been removed from the -mm tree.  Its filename was
     rtc-rtc-s35390a-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-s35390a: use devm_*() functions

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s35390a.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN drivers/rtc/rtc-s35390a.c~rtc-rtc-s35390a-use-devm_-functions drivers/rtc/rtc-s35390a.c
--- a/drivers/rtc/rtc-s35390a.c~rtc-rtc-s35390a-use-devm_-functions
+++ a/drivers/rtc/rtc-s35390a.c
@@ -338,7 +338,8 @@ static int s35390a_probe(struct i2c_clie
 		goto exit;
 	}
 
-	s35390a = kzalloc(sizeof(struct s35390a), GFP_KERNEL);
+	s35390a = devm_kzalloc(&client->dev, sizeof(struct s35390a),
+				GFP_KERNEL);
 	if (!s35390a) {
 		err = -ENOMEM;
 		goto exit;
@@ -386,8 +387,9 @@ static int s35390a_probe(struct i2c_clie
 
 	device_set_wakeup_capable(&client->dev, 1);
 
-	s35390a->rtc = rtc_device_register(s35390a_driver.driver.name,
-				&client->dev, &s35390a_rtc_ops, THIS_MODULE);
+	s35390a->rtc = devm_rtc_device_register(&client->dev,
+					s35390a_driver.driver.name,
+					&s35390a_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(s35390a->rtc)) {
 		err = PTR_ERR(s35390a->rtc);
@@ -399,7 +401,6 @@ exit_dummy:
 	for (i = 1; i < 8; ++i)
 		if (s35390a->client[i])
 			i2c_unregister_device(s35390a->client[i]);
-	kfree(s35390a);
 
 exit:
 	return err;
@@ -408,15 +409,12 @@ exit:
 static int s35390a_remove(struct i2c_client *client)
 {
 	unsigned int i;
-
 	struct s35390a *s35390a = i2c_get_clientdata(client);
+
 	for (i = 1; i < 8; ++i)
 		if (s35390a->client[i])
 			i2c_unregister_device(s35390a->client[i]);
 
-	rtc_device_unregister(s35390a->rtc);
-	kfree(s35390a);
