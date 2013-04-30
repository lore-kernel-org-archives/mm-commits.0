From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-rs5c348-use-devm_-functions.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:00:51 -0700
Message-ID: <20130430190051.6F4175A41E9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:37166 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933263Ab3D3TAx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:00:53 -0400
Received: by mail-qe0-f74.google.com with SMTP id a11so87410qen.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:00:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-rs5c348: use devm_*() functions
has been removed from the -mm tree.  Its filename was
     rtc-rtc-rs5c348-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-rs5c348: use devm_*() functions

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rs5c348.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff -puN drivers/rtc/rtc-rs5c348.c~rtc-rtc-rs5c348-use-devm_-functions drivers/rtc/rtc-rs5c348.c
--- a/drivers/rtc/rtc-rs5c348.c~rtc-rtc-rs5c348-use-devm_-functions
+++ a/drivers/rtc/rtc-rs5c348.c
@@ -158,7 +158,8 @@ static int rs5c348_probe(struct spi_devi
 	struct rtc_device *rtc;
 	struct rs5c348_plat_data *pdata;
 
-	pdata = kzalloc(sizeof(struct rs5c348_plat_data), GFP_KERNEL);
+	pdata = devm_kzalloc(&spi->dev, sizeof(struct rs5c348_plat_data),
+				GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;
 	spi->dev.platform_data = pdata;
@@ -202,7 +203,7 @@ static int rs5c348_probe(struct spi_devi
 	if (ret & RS5C348_BIT_24H)
 		pdata->rtc_24h = 1;
 
-	rtc = rtc_device_register(rs5c348_driver.driver.name, &spi->dev,
+	rtc = devm_rtc_device_register(&spi->dev, rs5c348_driver.driver.name,
 				  &rs5c348_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(rtc)) {
@@ -214,18 +215,11 @@ static int rs5c348_probe(struct spi_devi
 
 	return 0;
  kfree_exit:
-	kfree(pdata);
 	return ret;
 }
 
 static int rs5c348_remove(struct spi_device *spi)
 {
-	struct rs5c348_plat_data *pdata = spi->dev.platform_data;
-	struct rtc_device *rtc = pdata->rtc;
