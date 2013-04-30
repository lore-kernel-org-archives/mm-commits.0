From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-max6902-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:57:37 -0700
Message-ID: <20130430185737.6E62031C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:42806 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933401Ab3D3S5i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:57:38 -0400
Received: by mail-qa0-f74.google.com with SMTP id bs12so88246qab.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:57:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-max6902: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-max6902-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-max6902: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup paths
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max6902.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-max6902.c~rtc-rtc-max6902-use-devm_rtc_device_register drivers/rtc/rtc-max6902.c
--- a/drivers/rtc/rtc-max6902.c~rtc-rtc-max6902-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-max6902.c
@@ -134,8 +134,8 @@ static int max6902_probe(struct spi_devi
 	if (res != 0)
 		return res;
 
-	rtc = rtc_device_register("max6902",
-				&spi->dev, &max6902_rtc_ops, THIS_MODULE);
+	rtc = devm_rtc_device_register(&spi->dev, "max6902",
+				&max6902_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
 
@@ -145,9 +145,6 @@ static int max6902_probe(struct spi_devi
 
 static int max6902_remove(struct spi_device *spi)
 {
-	struct rtc_device *rtc = dev_get_drvdata(&spi->dev);
