From: akpm@linux-foundation.org
Subject: [merged] backlight-s6e63m0-remove-redundant-variable-before_power.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:40:38 -0800
Message-ID: <20130222204038.952A75A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:56797 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757763Ab3BVUkj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:40:39 -0500
Received: by mail-qe0-f74.google.com with SMTP id a11so104127qen.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:40:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: s6e63m0: remove redundant variable 'before_power'
has been removed from the -mm tree.  Its filename was
     backlight-s6e63m0-remove-redundant-variable-before_power.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: s6e63m0: remove redundant variable 'before_power'

'before_power' was used to check the previous status when resume() is
called.  However, FB_BLANK_POWERDOWN was used in suspend() all the time,
so there is no need to check the previous status.  Also, redundant return
variables are removed to reduce the code.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/s6e63m0.c |   24 +++---------------------
 1 file changed, 3 insertions(+), 21 deletions(-)

diff -puN drivers/video/backlight/s6e63m0.c~backlight-s6e63m0-remove-redundant-variable-before_power drivers/video/backlight/s6e63m0.c
--- a/drivers/video/backlight/s6e63m0.c~backlight-s6e63m0-remove-redundant-variable-before_power
+++ a/drivers/video/backlight/s6e63m0.c
@@ -827,44 +827,26 @@ static int s6e63m0_remove(struct spi_dev
 }
 
 #if defined(CONFIG_PM)
-static unsigned int before_power;
-
 static int s6e63m0_suspend(struct spi_device *spi, pm_message_t mesg)
 {
-	int ret = 0;
 	struct s6e63m0 *lcd = dev_get_drvdata(&spi->dev);
 
 	dev_dbg(&spi->dev, "lcd->power = %d\n", lcd->power);
 
-	before_power = lcd->power;
-
 	/*
 	 * when lcd panel is suspend, lcd panel becomes off
 	 * regardless of status.
 	 */
-	ret = s6e63m0_power(lcd, FB_BLANK_POWERDOWN);
-
-	return ret;
+	return s6e63m0_power(lcd, FB_BLANK_POWERDOWN);
 }
 
 static int s6e63m0_resume(struct spi_device *spi)
 {
-	int ret = 0;
 	struct s6e63m0 *lcd = dev_get_drvdata(&spi->dev);
 
-	/*
-	 * after suspended, if lcd panel status is FB_BLANK_UNBLANK
-	 * (at that time, before_power is FB_BLANK_UNBLANK) then
-	 * it changes that status to FB_BLANK_POWERDOWN to get lcd on.
-	 */
-	if (before_power == FB_BLANK_UNBLANK)
-		lcd->power = FB_BLANK_POWERDOWN;
-
-	dev_dbg(&spi->dev, "before_power = %d\n", before_power);
