From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-m41t94-use-spi_set_drvdata.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:59:08 -0700
Message-ID: <20130430185908.6ECDE31C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:61508 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933317Ab3D3S7J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:59:09 -0400
Received: by mail-vb0-f73.google.com with SMTP id p12so87077vbe.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:59:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-m41t94: use spi_set_drvdata()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-m41t94-use-spi_set_drvdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-m41t94: use spi_set_drvdata()

Use the wrapper functions for getting and setting the driver data using
spi_device instead of using dev_{get|set}_drvdata with &spi->dev, so we
can directly pass a struct spi_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-m41t94.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-m41t94.c~rtc-rtc-m41t94-use-spi_set_drvdata drivers/rtc/rtc-m41t94.c
--- a/drivers/rtc/rtc-m41t94.c~rtc-rtc-m41t94-use-spi_set_drvdata
+++ a/drivers/rtc/rtc-m41t94.c
@@ -129,7 +129,7 @@ static int m41t94_probe(struct spi_devic
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
 
-	dev_set_drvdata(&spi->dev, rtc);
+	spi_set_drvdata(spi, rtc);
 
 	return 0;
 }
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

