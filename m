From: akpm@linux-foundation.org
Subject: [merged] backlight-ams369fg06-remove-redundant-variable-before_power.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:40:53 -0800
Message-ID: <20130222204053.A736331C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:61045 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757788Ab3BVUky (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:40:54 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so118871qah.4
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:40:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: ams369fg06: remove redundant variable 'before_power'
has been removed from the -mm tree.  Its filename was
     backlight-ams369fg06-remove-redundant-variable-before_power.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: ams369fg06: remove redundant variable 'before_power'

'before_power' was used to check the previous status when resume() is
called.  However, FB_BLANK_POWERDOWN was used in suspend() all the time,
so there is no need to check the previous status.  Also, redundant return
variables are removed to reduce the code.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ams369fg06.c |   24 +++---------------------
 1 file changed, 3 insertions(+), 21 deletions(-)

diff -puN drivers/video/backlight/ams369fg06.c~backlight-ams369fg06-remove-redundant-variable-before_power drivers/video/backlight/ams369fg06.c
--- a/drivers/video/backlight/ams369fg06.c~backlight-ams369fg06-remove-redundant-variable-before_power
+++ a/drivers/video/backlight/ams369fg06.c
@@ -545,44 +545,26 @@ static int ams369fg06_remove(struct spi_
 }
 
 #if defined(CONFIG_PM)
-static unsigned int before_power;
-
 static int ams369fg06_suspend(struct spi_device *spi, pm_message_t mesg)
 {
-	int ret = 0;
 	struct ams369fg06 *lcd = dev_get_drvdata(&spi->dev);
 
 	dev_dbg(&spi->dev, "lcd->power = %d\n", lcd->power);
 
-	before_power = lcd->power;
-
 	/*
 	 * when lcd panel is suspend, lcd panel becomes off
 	 * regardless of status.
 	 */
-	ret = ams369fg06_power(lcd, FB_BLANK_POWERDOWN);
-
-	return ret;
+	return ams369fg06_power(lcd, FB_BLANK_POWERDOWN);
 }
 
 static int ams369fg06_resume(struct spi_device *spi)
 {
-	int ret = 0;
 	struct ams369fg06 *lcd = dev_get_drvdata(&spi->dev);
 
-	/*
-	 * after suspended, if lcd panel status is FB_BLANK_UNBLANK
-	 * (at that time, before_power is FB_BLANK_UNBLANK) then
-	 * it changes that status to FB_BLANK_POWERDOWN to get lcd on.
-	 */
-	if (before_power == FB_BLANK_UNBLANK)
-		lcd->power = FB_BLANK_POWERDOWN;
-
-	dev_dbg(&spi->dev, "before_power = %d\n", before_power);
