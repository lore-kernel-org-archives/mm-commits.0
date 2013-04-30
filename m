From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-ds2404-use-devm_-functions.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:00:13 -0700
Message-ID: <20130430190013.6EC1931C27C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:40151 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933503Ab3D3TAO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:00:14 -0400
Received: by mail-ye0-f202.google.com with SMTP id r11so87285yen.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:00:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-ds2404: use devm_*() functions
has been removed from the -mm tree.  Its filename was
     rtc-rtc-ds2404-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-ds2404: use devm_*() functions

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds2404.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff -puN drivers/rtc/rtc-ds2404.c~rtc-rtc-ds2404-use-devm_-functions drivers/rtc/rtc-ds2404.c
--- a/drivers/rtc/rtc-ds2404.c~rtc-rtc-ds2404-use-devm_-functions
+++ a/drivers/rtc/rtc-ds2404.c
@@ -228,7 +228,7 @@ static int rtc_probe(struct platform_dev
 	struct ds2404 *chip;
 	int retval = -EBUSY;
 
-	chip = kzalloc(sizeof(struct ds2404), GFP_KERNEL);
+	chip = devm_kzalloc(&pdev->dev, sizeof(struct ds2404), GFP_KERNEL);
 	if (!chip)
 		return -ENOMEM;
 
@@ -244,8 +244,8 @@ static int rtc_probe(struct platform_dev
 
 	platform_set_drvdata(pdev, chip);
 
-	chip->rtc = rtc_device_register("ds2404",
-				&pdev->dev, &ds2404_rtc_ops, THIS_MODULE);
+	chip->rtc = devm_rtc_device_register(&pdev->dev, "ds2404",
+					&ds2404_rtc_ops, THIS_MODULE);
 	if (IS_ERR(chip->rtc)) {
 		retval = PTR_ERR(chip->rtc);
 		goto err_io;
@@ -257,20 +257,14 @@ static int rtc_probe(struct platform_dev
 err_io:
 	chip->ops->unmap_io(chip);
 err_chip:
-	kfree(chip);
 	return retval;
 }
 
 static int rtc_remove(struct platform_device *dev)
 {
 	struct ds2404 *chip = platform_get_drvdata(dev);
-	struct rtc_device *rtc = chip->rtc;
