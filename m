From: akpm@linux-foundation.org
Subject: + backlight-s6e63m0-remove-redundant-variable-before_power.patch added to -mm tree
Date: Thu, 20 Dec 2012 12:36:00 -0800
Message-ID: <20121220203601.39914100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:63304 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab2LTUgC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Dec 2012 15:36:02 -0500
Received: by mail-gg0-f201.google.com with SMTP id o6so406174ggm.2
        for <mm-commits@vger.kernel.org>; Thu, 20 Dec 2012 12:36:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: backlight: s6e63m0: remove redundant variable 'before_power'
has been added to the -mm tree.  Its filename is
     backlight-s6e63m0-remove-redundant-variable-before_power.patch

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
-
-	ret = s6e63m0_power(lcd, before_power);
+	lcd->power = FB_BLANK_POWERDOWN;
 
-	return ret;
+	return s6e63m0_power(lcd, FB_BLANK_UNBLANK);
 }
 #else
 #define s6e63m0_suspend		NULL
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

