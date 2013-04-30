From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-m41t93-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:57:29 -0700
Message-ID: <20130430185729.6BDA75A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:45764 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933391Ab3D3S5a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:57:30 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so86800ggm.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:57:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-m41t93: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-m41t93-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-m41t93: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup paths
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-m41t93.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN drivers/rtc/rtc-m41t93.c~rtc-rtc-m41t93-use-devm_rtc_device_register drivers/rtc/rtc-m41t93.c
--- a/drivers/rtc/rtc-m41t93.c~rtc-rtc-m41t93-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-m41t93.c
@@ -184,8 +184,8 @@ static int m41t93_probe(struct spi_devic
 		return -ENODEV;
 	}
 
-	rtc = rtc_device_register(m41t93_driver.driver.name,
-		&spi->dev, &m41t93_rtc_ops, THIS_MODULE);
+	rtc = devm_rtc_device_register(&spi->dev, m41t93_driver.driver.name,
+					&m41t93_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
 
@@ -197,11 +197,6 @@ static int m41t93_probe(struct spi_devic
 
 static int m41t93_remove(struct spi_device *spi)
 {
-	struct rtc_device *rtc = spi_get_drvdata(spi);
-
-	if (rtc)
-		rtc_device_unregister(rtc);
