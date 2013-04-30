From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-r9701-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:57:41 -0700
Message-ID: <20130430185741.6FB7931C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:42016 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933428Ab3D3S5n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:57:43 -0400
Received: by mail-qe0-f74.google.com with SMTP id a11so86968qen.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:57:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-r9701: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-r9701-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-r9701: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup paths
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-r9701.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-r9701.c~rtc-rtc-r9701-use-devm_rtc_device_register drivers/rtc/rtc-r9701.c
--- a/drivers/rtc/rtc-r9701.c~rtc-rtc-r9701-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-r9701.c
@@ -154,8 +154,8 @@ static int r9701_probe(struct spi_device
 		}
 	}
 
-	rtc = rtc_device_register("r9701",
-				&spi->dev, &r9701_rtc_ops, THIS_MODULE);
+	rtc = devm_rtc_device_register(&spi->dev, "r9701",
+				&r9701_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
 
@@ -166,9 +166,6 @@ static int r9701_probe(struct spi_device
 
 static int r9701_remove(struct spi_device *spi)
 {
-	struct rtc_device *rtc = dev_get_drvdata(&spi->dev);
