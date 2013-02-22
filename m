From: akpm@linux-foundation.org
Subject: [merged] backlight-ams369fg06-replace-efault-with-einval.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:40:50 -0800
Message-ID: <20130222204050.AC9885A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:44827 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757543Ab3BVUkv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:40:51 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so103817ggi.3
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:40:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: ams369fg06: replace EFAULT with EINVAL
has been removed from the -mm tree.  Its filename was
     backlight-ams369fg06-replace-efault-with-einval.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: ams369fg06: replace EFAULT with EINVAL

Replace EFAULT with EINVAL, because EFAULT tends to be for the invalid
memory addresses.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ams369fg06.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/backlight/ams369fg06.c~backlight-ams369fg06-replace-efault-with-einval drivers/video/backlight/ams369fg06.c
--- a/drivers/video/backlight/ams369fg06.c~backlight-ams369fg06-replace-efault-with-einval
+++ a/drivers/video/backlight/ams369fg06.c
@@ -328,7 +328,7 @@ static int ams369fg06_power_on(struct am
 
 	if (!pd->power_on) {
 		dev_err(lcd->dev, "power_on is NULL.\n");
-		return -EFAULT;
+		return -EINVAL;
 	} else {
 		pd->power_on(lcd->ld, 1);
 		msleep(pd->power_on_delay);
@@ -336,7 +336,7 @@ static int ams369fg06_power_on(struct am
 
 	if (!pd->reset) {
 		dev_err(lcd->dev, "reset is NULL.\n");
-		return -EFAULT;
+		return -EINVAL;
 	} else {
 		pd->reset(lcd->ld);
 		msleep(pd->reset_delay);
@@ -485,7 +485,7 @@ static int ams369fg06_probe(struct spi_d
 	lcd->lcd_pd = spi->dev.platform_data;
 	if (!lcd->lcd_pd) {
 		dev_err(&spi->dev, "platform data is NULL\n");
-		return -EFAULT;
+		return -EINVAL;
 	}
 
 	ld = lcd_device_register("ams369fg06", &spi->dev, lcd,
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

