From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-v3020-use-devm_-functions.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:01:04 -0700
Message-ID: <20130430190104.6E7E131C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:49776 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933582Ab3D3TBF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:01:05 -0400
Received: by mail-qa0-f74.google.com with SMTP id bs12so88766qab.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:01:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-v3020: use devm_*() functions
has been removed from the -mm tree.  Its filename was
     rtc-rtc-v3020-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-v3020: use devm_*() functions

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-v3020.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff -puN drivers/rtc/rtc-v3020.c~rtc-rtc-v3020-use-devm_-functions drivers/rtc/rtc-v3020.c
--- a/drivers/rtc/rtc-v3020.c~rtc-rtc-v3020-use-devm_-functions
+++ a/drivers/rtc/rtc-v3020.c
@@ -296,7 +296,7 @@ static int rtc_probe(struct platform_dev
 	int i;
 	int temp;
 
-	chip = kzalloc(sizeof *chip, GFP_KERNEL);
+	chip = devm_kzalloc(&pdev->dev, sizeof(*chip), GFP_KERNEL);
 	if (!chip)
 		return -ENOMEM;
 
@@ -340,8 +340,8 @@ static int rtc_probe(struct platform_dev
 
 	platform_set_drvdata(pdev, chip);
 
-	chip->rtc = rtc_device_register("v3020",
-				&pdev->dev, &v3020_rtc_ops, THIS_MODULE);
+	chip->rtc = devm_rtc_device_register(&pdev->dev, "v3020",
+					&v3020_rtc_ops, THIS_MODULE);
 	if (IS_ERR(chip->rtc)) {
 		retval = PTR_ERR(chip->rtc);
 		goto err_io;
@@ -352,21 +352,14 @@ static int rtc_probe(struct platform_dev
 err_io:
 	chip->ops->unmap_io(chip);
 err_chip:
-	kfree(chip);
-
 	return retval;
 }
 
 static int rtc_remove(struct platform_device *dev)
 {
 	struct v3020 *chip = platform_get_drvdata(dev);
-	struct rtc_device *rtc = chip->rtc;
