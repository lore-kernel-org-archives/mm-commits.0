From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-ds3234-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:57:16 -0700
Message-ID: <20130430185716.691785A41E9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:57349 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933391Ab3D3S5R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:57:17 -0400
Received: by mail-vb0-f73.google.com with SMTP id p12so86909vbe.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:57:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-ds3234: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-ds3234-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-ds3234: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup paths
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds3234.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-ds3234.c~rtc-rtc-ds3234-use-devm_rtc_device_register drivers/rtc/rtc-ds3234.c
--- a/drivers/rtc/rtc-ds3234.c~rtc-rtc-ds3234-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-ds3234.c
@@ -146,8 +146,8 @@ static int ds3234_probe(struct spi_devic
 	ds3234_get_reg(&spi->dev, DS3234_REG_CONT_STAT, &tmp);
 	dev_info(&spi->dev, "Ctrl/Stat Reg: 0x%02x\n", tmp);
 
-	rtc = rtc_device_register("ds3234",
-				&spi->dev, &ds3234_rtc_ops, THIS_MODULE);
+	rtc = devm_rtc_device_register(&spi->dev, "ds3234",
+				&ds3234_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
 
@@ -158,9 +158,6 @@ static int ds3234_probe(struct spi_devic
 
 static int ds3234_remove(struct spi_device *spi)
 {
-	struct rtc_device *rtc = spi_get_drvdata(spi);
