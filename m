From: akpm@linux-foundation.org
Subject: + backlight-ili9320-fix-checkpatch-error-and-warning.patch added to -mm tree
Date: Wed, 17 Oct 2012 16:13:46 -0700
Message-ID: <20121017231347.52786100049@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:64186 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab2JQXNs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Oct 2012 19:13:48 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so1006486ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 17 Oct 2012 16:13:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight: ili9320: fix checkpatch error and warning
has been added to the -mm tree.  Its filename is
     backlight-ili9320-fix-checkpatch-error-and-warning.patch

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
Subject: backlight: ili9320: fix checkpatch error and warning

This patch fixes the checkpatch error and warning as below:

WARNING: please, no space before tabs
WARNING: please, no spaces at the start of a line
WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
WARNING: braces {} are not necessary for single statement blocks
ERROR: code indent should use tabs where possible

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ili9320.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff -puN drivers/video/backlight/ili9320.c~backlight-ili9320-fix-checkpatch-error-and-warning drivers/video/backlight/ili9320.c
--- a/drivers/video/backlight/ili9320.c~backlight-ili9320-fix-checkpatch-error-and-warning
+++ a/drivers/video/backlight/ili9320.c
@@ -45,7 +45,7 @@ static inline int ili9320_write_spi(stru
 	/* second message is the data to transfer */
 
 	data[0] = spi->id | ILI9320_SPI_DATA  | ILI9320_SPI_WRITE;
- 	data[1] = value >> 8;
+	data[1] = value >> 8;
 	data[2] = value;
 
 	return spi_sync(spi->dev, &spi->message);
@@ -56,7 +56,6 @@ int ili9320_write(struct ili9320 *ili, u
 	dev_dbg(ili->dev, "write: reg=%02x, val=%04x\n", reg, value);
 	return ili->write(ili, reg, value);
 }
-
 EXPORT_SYMBOL_GPL(ili9320_write);
 
 int ili9320_write_regs(struct ili9320 *ili,
@@ -74,7 +73,6 @@ int ili9320_write_regs(struct ili9320 *i
 
 	return 0;
 }
-
 EXPORT_SYMBOL_GPL(ili9320_write_regs);
 
 static void ili9320_reset(struct ili9320 *lcd)
@@ -260,7 +258,6 @@ int __devinit ili9320_probe_spi(struct s
 
 	return ret;
 }
-
 EXPORT_SYMBOL_GPL(ili9320_probe_spi);
 
 int ili9320_remove(struct ili9320 *ili)
@@ -271,7 +268,6 @@ int ili9320_remove(struct ili9320 *ili)
 
 	return 0;
 }
-
 EXPORT_SYMBOL_GPL(ili9320_remove);
 
 #ifdef CONFIG_PM
@@ -296,20 +292,17 @@ int ili9320_suspend(struct ili9320 *lcd,
 
 	return 0;
 }
-
 EXPORT_SYMBOL_GPL(ili9320_suspend);
 
 int ili9320_resume(struct ili9320 *lcd)
 {
 	dev_info(lcd->dev, "resuming from power state %d\n", lcd->power);
 
-	if (lcd->platdata->suspend == ILI9320_SUSPEND_DEEP) {
+	if (lcd->platdata->suspend == ILI9320_SUSPEND_DEEP)
 		ili9320_write(lcd, ILI9320_POWER1, 0x00);
-	}
 
 	return ili9320_power(lcd, FB_BLANK_UNBLANK);
 }
-
 EXPORT_SYMBOL_GPL(ili9320_resume);
 #endif
 
@@ -318,7 +311,6 @@ void ili9320_shutdown(struct ili9320 *lc
 {
 	ili9320_power(lcd, FB_BLANK_POWERDOWN);
 }
-
 EXPORT_SYMBOL_GPL(ili9320_shutdown);
 
 MODULE_AUTHOR("Ben Dooks <ben-linux@fluff.org>");
_

Patches currently in -mm which might be from jg1.han@samsung.com are

backlight-da903x_bl-use-dev_get_drvdata-instead-of-platform_get_drvdata.patch
backlight-88pm860x_bl-fix-checkpatch-warning.patch
backlight-atmel-pwm-bl-fix-checkpatch-warning.patch
backlight-corgi_lcd-fix-checkpatch-error-and-warning.patch
backlight-da903x_bl-fix-checkpatch-warning.patch
backlight-generic_bl-fix-checkpatch-warning.patch
backlight-hp680_bl-fix-checkpatch-error-and-warning.patch
backlight-ili9320-fix-checkpatch-error-and-warning.patch
backlight-jornada720-fix-checkpatch-error-and-warning.patch
backlight-l4f00242t03-fix-checkpatch-warning.patch
backlight-lm3630-fix-checkpatch-warning.patch
backlight-locomolcd-fix-checkpatch-error-and-warning.patch
backlight-omap1-fix-checkpatch-warning.patch
backlight-pcf50633-fix-checkpatch-warning.patch
backlight-platform_lcd-fix-checkpatch-error.patch
backlight-tdo24m-fix-checkpatch-warning.patch
backlight-tosa-fix-checkpatch-error-and-warning.patch
backlight-vgg2432a4-fix-checkpatch-warning.patch

