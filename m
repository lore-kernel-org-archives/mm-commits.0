From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-ds3234-use-spi_set_drvdata.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:59:13 -0700
Message-ID: <20130430185913.689E831C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:42039 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933454Ab3D3S7O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:59:14 -0400
Received: by mail-yh0-f74.google.com with SMTP id z12so86791yhz.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:59:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-ds3234: use spi_set_drvdata()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-ds3234-use-spi_set_drvdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-ds3234: use spi_set_drvdata()

Use the wrapper functions for getting and setting the driver data using
spi_device instead of using dev_{get|set}_drvdata with &spi->dev, so we
can directly pass a struct spi_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds3234.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-ds3234.c~rtc-rtc-ds3234-use-spi_set_drvdata drivers/rtc/rtc-ds3234.c
--- a/drivers/rtc/rtc-ds3234.c~rtc-rtc-ds3234-use-spi_set_drvdata
+++ a/drivers/rtc/rtc-ds3234.c
@@ -151,7 +151,7 @@ static int ds3234_probe(struct spi_devic
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

