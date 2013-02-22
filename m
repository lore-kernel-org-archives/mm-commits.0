From: akpm@linux-foundation.org
Subject: [merged] backlight-ld9040-replace-efault-with-einval.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:40:17 -0800
Message-ID: <20130222204017.97E0B31C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:46645 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757694Ab3BVUkS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:40:18 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so103678yen.3
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:40:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: ld9040: replace EFAULT with EINVAL
has been removed from the -mm tree.  Its filename was
     backlight-ld9040-replace-efault-with-einval.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: ld9040: replace EFAULT with EINVAL

Replace EFAULT with EINVAL, because EFAULT tends to be for the invalid
memory addresses.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ld9040.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/ld9040.c~backlight-ld9040-replace-efault-with-einval drivers/video/backlight/ld9040.c
--- a/drivers/video/backlight/ld9040.c~backlight-ld9040-replace-efault-with-einval
+++ a/drivers/video/backlight/ld9040.c
@@ -583,7 +583,7 @@ static int ld9040_power_on(struct ld9040
 
 	if (!pd->reset) {
 		dev_err(lcd->dev, "reset is NULL.\n");
-		return -EFAULT;
+		return -EINVAL;
 	} else {
 		pd->reset(lcd->ld);
 		msleep(pd->reset_delay);
@@ -724,7 +724,7 @@ static int ld9040_probe(struct spi_devic
 	lcd->lcd_pd = spi->dev.platform_data;
 	if (!lcd->lcd_pd) {
 		dev_err(&spi->dev, "platform data is NULL.\n");
-		return -EFAULT;
+		return -EINVAL;
 	}
 
 	mutex_init(&lcd->lock);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

