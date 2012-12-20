From: akpm@linux-foundation.org
Subject: + backlight-ams369fg06-remove-redundant-variable-before_power.patch added to -mm tree
Date: Thu, 20 Dec 2012 12:37:16 -0800
Message-ID: <20121220203717.7050E200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:60918 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab2LTUhU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Dec 2012 15:37:20 -0500
Received: by mail-bk0-f74.google.com with SMTP id je9so207752bkc.3
        for <mm-commits@vger.kernel.org>; Thu, 20 Dec 2012 12:37:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: backlight: ams369fg06: remove redundant variable 'before_power'
has been added to the -mm tree.  Its filename is
     backlight-ams369fg06-remove-redundant-variable-before_power.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
-
-	ret = ams369fg06_power(lcd, before_power);
+	lcd->power = FB_BLANK_POWERDOWN;
 
-	return ret;
+	return ams369fg06_power(lcd, FB_BLANK_UNBLANK);
 }
 #else
 #define ams369fg06_suspend	NULL
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
backlight-add-lms501kf03-lcd-driver.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
backlight-ld9040-use-sleep-instead-of-delay.patch
backlight-ld9040-remove-unnecessary-null-deference-check.patch
backlight-ld9040-replace-efault-with-einval.patch
backlight-ld9040-remove-redundant-return-variables.patch
backlight-ld9040-reorder-inclusions-of-linux-xxxh.patch
backlight-s6e63m0-use-lowercase-names-of-structs.patch
backlight-s6e63m0-use-sleep-instead-of-delay.patch
backlight-s6e63m0-remove-unnecessary-null-deference-check.patch
backlight-s6e63m0-replace-efault-with-einval.patch
backlight-s6e63m0-remove-redundant-variable-before_power.patch
backlight-s6e63m0-reorder-inclusions-of-linux-xxxh.patch
backlight-ams369fg06-use-sleep-instead-of-delay.patch
backlight-ams369fg06-remove-unnecessary-null-deference-check.patch
backlight-ams369fg06-replace-efault-with-einval.patch
backlight-ams369fg06-remove-redundant-variable-before_power.patch
backlight-ams369fg06-reorder-inclusions-of-linux-xxxh.patch

