From: akpm@linux-foundation.org
Subject: [merged] backlight-ili9320-use-spi_set_drvdata.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:52:38 -0700
Message-ID: <20130430185238.6F05D5A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:44106 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933102Ab3D3Swj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:52:39 -0400
Received: by mail-qc0-f201.google.com with SMTP id o22so86477qcr.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:52:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: ili9320: use spi_set_drvdata()
has been removed from the -mm tree.  Its filename was
     backlight-ili9320-use-spi_set_drvdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: ili9320: use spi_set_drvdata()

Use the wrapper functions for getting and setting the driver data using
spi_device instead of using dev_{get|set}_drvdata with &spi->dev, so we
can directly pass a struct spi_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ili9320.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/ili9320.c~backlight-ili9320-use-spi_set_drvdata drivers/video/backlight/ili9320.c
--- a/drivers/video/backlight/ili9320.c~backlight-ili9320-use-spi_set_drvdata
+++ a/drivers/video/backlight/ili9320.c
@@ -231,7 +231,7 @@ int ili9320_probe_spi(struct spi_device
 	ili->power = FB_BLANK_POWERDOWN;
 	ili->platdata = cfg;
 
-	dev_set_drvdata(&spi->dev, ili);
+	spi_set_drvdata(spi, ili);
 
 	ili9320_setup_spi(ili, spi);
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

