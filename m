From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-s6e63m0c-remove-unnecessary-cast-of-void-pointer.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:05:21 -0800
Message-ID: <20121218200521.9B4B582004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:40651 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2LRUFW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:05:22 -0500
Received: by mail-vb0-f73.google.com with SMTP id l1so125638vba.0
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:05:22 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/s6e63m0.c: remove unnecessary cast of void pointer
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-s6e63m0c-remove-unnecessary-cast-of-void-pointer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/video/backlight/s6e63m0.c: remove unnecessary cast of void pointer

Remove unnecessary cast of void pointer for platform data in probe
function.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/s6e63m0.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/s6e63m0.c~drivers-video-backlight-s6e63m0c-remove-unnecessary-cast-of-void-pointer drivers/video/backlight/s6e63m0.c
--- a/drivers/video/backlight/s6e63m0.c~drivers-video-backlight-s6e63m0c-remove-unnecessary-cast-of-void-pointer
+++ a/drivers/video/backlight/s6e63m0.c
@@ -757,7 +757,7 @@ static int s6e63m0_probe(struct spi_devi
 	lcd->spi = spi;
 	lcd->dev = &spi->dev;
 
-	lcd->lcd_pd = (struct lcd_platform_data *)spi->dev.platform_data;
+	lcd->lcd_pd = spi->dev.platform_data;
 	if (!lcd->lcd_pd) {
 		dev_err(&spi->dev, "platform data is NULL.\n");
 		return -EFAULT;
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
backlight-locomolcd-fix-checkpatch-error-and-warning.patch

