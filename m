From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-rx8025-use-devm_-functions.patch removed from
 -mm tree
Date: Mon, 08 Jul 2013 12:33:34 -0700
Message-ID: <51db140e.LnBMHywLxCQOSB+R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51231 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945Ab3GHTde (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:33:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] rtc-rtc-rx8025-use-devm_-functions.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:33:34 -0700


The patch titled
     Subject: rtc: rtc-rx8025: use devm_*() functions
has been removed from the -mm tree.  Its filename was
     rtc-rtc-rx8025-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-rx8025: use devm_*() functions

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rx8025.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff -puN drivers/rtc/rtc-rx8025.c~rtc-rtc-rx8025-use-devm_-functions drivers/rtc/rtc-rx8025.c
--- a/drivers/rtc/rtc-rx8025.c~rtc-rtc-rx8025-use-devm_-functions
+++ a/drivers/rtc/rtc-rx8025.c
@@ -549,7 +549,7 @@ static int rx8025_probe(struct i2c_clien
 		goto errout;
 	}
 
-	rx8025 = kzalloc(sizeof(*rx8025), GFP_KERNEL);
+	rx8025 = devm_kzalloc(&client->dev, sizeof(*rx8025), GFP_KERNEL);
 	if (!rx8025) {
 		dev_err(&adapter->dev, "failed to alloc memory\n");
 		err = -ENOMEM;
@@ -562,7 +562,7 @@ static int rx8025_probe(struct i2c_clien
 
 	err = rx8025_init_client(client, &need_reset);
 	if (err)
-		goto errout_free;
+		goto errout;
 
 	if (need_reset) {
 		struct rtc_time tm;
@@ -572,12 +572,12 @@ static int rx8025_probe(struct i2c_clien
 		rx8025_set_time(&client->dev, &tm);
 	}
 
-	rx8025->rtc = rtc_device_register(client->name, &client->dev,
+	rx8025->rtc = devm_rtc_device_register(&client->dev, client->name,
 					  &rx8025_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rx8025->rtc)) {
 		err = PTR_ERR(rx8025->rtc);
 		dev_err(&client->dev, "unable to register the class device\n");
-		goto errout_free;
+		goto errout;
 	}
 
 	if (client->irq > 0) {
@@ -586,7 +586,7 @@ static int rx8025_probe(struct i2c_clien
 				  0, "rx8025", client);
 		if (err) {
 			dev_err(&client->dev, "unable to request IRQ\n");
-			goto errout_reg;
+			goto errout;
 		}
 	}
 
@@ -603,12 +603,6 @@ errout_irq:
 	if (client->irq > 0)
 		free_irq(client->irq, client);
 
-errout_reg:
-	rtc_device_unregister(rx8025->rtc);
-
-errout_free:
-	kfree(rx8025);
