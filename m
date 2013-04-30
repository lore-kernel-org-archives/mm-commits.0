From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-rx4581-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:57:51 -0700
Message-ID: <20130430185751.623D131C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:62179 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933391Ab3D3S5w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:57:52 -0400
Received: by mail-vc0-f202.google.com with SMTP id hr11so87039vcb.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:57:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-rx4581: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-rx4581-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-rx4581: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup paths
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rx4581.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-rx4581.c~rtc-rtc-rx4581-use-devm_rtc_device_register drivers/rtc/rtc-rx4581.c
--- a/drivers/rtc/rtc-rx4581.c~rtc-rtc-rx4581-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-rx4581.c
@@ -273,8 +273,8 @@ static int rx4581_probe(struct spi_devic
 	if (res != 0)
 		return res;
 
-	rtc = rtc_device_register("rx4581",
-				&spi->dev, &rx4581_rtc_ops, THIS_MODULE);
+	rtc = devm_rtc_device_register(&spi->dev, "rx4581",
+				&rx4581_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
 
@@ -284,9 +284,6 @@ static int rx4581_probe(struct spi_devic
 
 static int rx4581_remove(struct spi_device *spi)
 {
-	struct rtc_device *rtc = dev_get_drvdata(&spi->dev);
