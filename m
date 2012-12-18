From: akpm@linux-foundation.org
Subject: [merged] backlight-ili9320-fix-checkpatch-error-and-warning.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:04:15 -0800
Message-ID: <20121218200416.27E3F20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f201.google.com ([209.85.215.201]:45117 "EHLO
	mail-ea0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2LRUES (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:04:18 -0500
Received: by mail-ea0-f201.google.com with SMTP id b14so63366eaa.0
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:04:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: ili9320: fix checkpatch error and warning
has been removed from the -mm tree.  Its filename was
     backlight-ili9320-fix-checkpatch-error-and-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -260,7 +258,6 @@ int ili9320_probe_spi(struct spi_device 
 
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
