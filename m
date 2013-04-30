From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-pcf2123-use-devm_-functions.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:00:37 -0700
Message-ID: <20130430190037.6F3ED31C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:42727 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933483Ab3D3TAi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:00:38 -0400
Received: by mail-qc0-f202.google.com with SMTP id k26so87340qcs.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:00:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-pcf2123: use devm_*() functions
has been removed from the -mm tree.  Its filename was
     rtc-rtc-pcf2123-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-pcf2123: use devm_*() functions

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf2123.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff -puN drivers/rtc/rtc-pcf2123.c~rtc-rtc-pcf2123-use-devm_-functions drivers/rtc/rtc-pcf2123.c
--- a/drivers/rtc/rtc-pcf2123.c~rtc-rtc-pcf2123-use-devm_-functions
+++ a/drivers/rtc/rtc-pcf2123.c
@@ -226,7 +226,8 @@ static int pcf2123_probe(struct spi_devi
 	u8 txbuf[2], rxbuf[2];
 	int ret, i;
 
-	pdata = kzalloc(sizeof(struct pcf2123_plat_data), GFP_KERNEL);
+	pdata = devm_kzalloc(&spi->dev, sizeof(struct pcf2123_plat_data),
+				GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;
 	spi->dev.platform_data = pdata;
@@ -281,7 +282,7 @@ static int pcf2123_probe(struct spi_devi
 	pcf2123_delay_trec();
 
 	/* Finalize the initialization */
-	rtc = rtc_device_register(pcf2123_driver.driver.name, &spi->dev,
+	rtc = devm_rtc_device_register(&spi->dev, pcf2123_driver.driver.name,
 			&pcf2123_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(rtc)) {
@@ -314,7 +315,6 @@ sysfs_exit:
 		device_remove_file(&spi->dev, &pdata->regs[i].attr);
 
 kfree_exit:
-	kfree(pdata);
 	spi->dev.platform_data = NULL;
 	return ret;
 }
@@ -325,15 +325,10 @@ static int pcf2123_remove(struct spi_dev
 	int i;
 
 	if (pdata) {
-		struct rtc_device *rtc = pdata->rtc;
