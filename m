From: akpm@linux-foundation.org
Subject: [merged] backlight-s6e63m0-replace-efault-with-einval.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:40:35 -0800
Message-ID: <20130222204035.90F945A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:61248 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757208Ab3BVUkg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:40:36 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so103896vch.2
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:40:36 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: s6e63m0: replace EFAULT with EINVAL
has been removed from the -mm tree.  Its filename was
     backlight-s6e63m0-replace-efault-with-einval.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: s6e63m0: replace EFAULT with EINVAL

Replace EFAULT with EINVAL, because EFAULT tends to be for the invalid
memory addresses.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/s6e63m0.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/backlight/s6e63m0.c~backlight-s6e63m0-replace-efault-with-einval drivers/video/backlight/s6e63m0.c
--- a/drivers/video/backlight/s6e63m0.c~backlight-s6e63m0-replace-efault-with-einval
+++ a/drivers/video/backlight/s6e63m0.c
@@ -515,7 +515,7 @@ static int s6e63m0_power_on(struct s6e63
 
 	if (!pd->power_on) {
 		dev_err(lcd->dev, "power_on is NULL.\n");
-		return -EFAULT;
+		return -EINVAL;
 	} else {
 		pd->power_on(lcd->ld, 1);
 		msleep(pd->power_on_delay);
@@ -523,7 +523,7 @@ static int s6e63m0_power_on(struct s6e63
 
 	if (!pd->reset) {
 		dev_err(lcd->dev, "reset is NULL.\n");
-		return -EFAULT;
+		return -EINVAL;
 	} else {
 		pd->reset(lcd->ld);
 		msleep(pd->reset_delay);
@@ -747,7 +747,7 @@ static int s6e63m0_probe(struct spi_devi
 	lcd->lcd_pd = spi->dev.platform_data;
 	if (!lcd->lcd_pd) {
 		dev_err(&spi->dev, "platform data is NULL.\n");
-		return -EFAULT;
+		return -EINVAL;
 	}
 
 	ld = lcd_device_register("s6e63m0", &spi->dev, lcd, &s6e63m0_lcd_ops);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

