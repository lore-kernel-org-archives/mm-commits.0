From: akpm@linux-foundation.org
Subject: + backlight-tosa-fix-checkpatch-error-and-warning.patch added to -mm tree
Date: Wed, 17 Oct 2012 16:14:14 -0700
Message-ID: <20121017231415.B200F20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:45428 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab2JQXOR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Oct 2012 19:14:17 -0400
Received: by mail-fa0-f74.google.com with SMTP id t1so487201fae.1
        for <mm-commits@vger.kernel.org>; Wed, 17 Oct 2012 16:14:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight: tosa: fix checkpatch error and warning
has been added to the -mm tree.  Its filename is
     backlight-tosa-fix-checkpatch-error-and-warning.patch

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
Subject: backlight: tosa: fix checkpatch error and warning

This patch fixes the checkpatch error and warning as below:

WARNING: line over 80 characters
ERROR: spaces required around that '?' (ctx:VxW)
ERROR: space required after that ',' (ctx:VxV)

Also, unnecessary lines are removed.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/tosa_bl.c  |    4 ++--
 drivers/video/backlight/tosa_lcd.c |   16 +++++++++-------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff -puN drivers/video/backlight/tosa_bl.c~backlight-tosa-fix-checkpatch-error-and-warning drivers/video/backlight/tosa_bl.c
--- a/drivers/video/backlight/tosa_bl.c~backlight-tosa-fix-checkpatch-error-and-warning
+++ a/drivers/video/backlight/tosa_bl.c
@@ -90,7 +90,8 @@ static int __devinit tosa_bl_probe(struc
 	if (!data)
 		return -ENOMEM;
 
-	data->comadj = sharpsl_param.comadj == -1 ? COMADJ_DEFAULT : sharpsl_param.comadj;
+	data->comadj = sharpsl_param.comadj == -1 ?
+			COMADJ_DEFAULT : sharpsl_param.comadj;
 
 	ret = devm_gpio_request(&client->dev, TOSA_GPIO_BL_C20MA, "backlight");
 	if (ret) {
@@ -163,7 +164,6 @@ static const struct i2c_device_id tosa_b
 	{ },
 };
 
-
 static struct i2c_driver tosa_bl_driver = {
 	.driver = {
 		.name		= "tosa-bl",
diff -puN drivers/video/backlight/tosa_lcd.c~backlight-tosa-fix-checkpatch-error-and-warning drivers/video/backlight/tosa_lcd.c
--- a/drivers/video/backlight/tosa_lcd.c~backlight-tosa-fix-checkpatch-error-and-warning
+++ a/drivers/video/backlight/tosa_lcd.c
@@ -63,7 +63,7 @@ static int tosa_tg_send(struct spi_devic
 int tosa_bl_enable(struct spi_device *spi, int enable)
 {
 	/* bl_enable GP04=1 otherwise GP04=0*/
-	return tosa_tg_send(spi, TG_GPODR2, enable? 0x01 : 0x00);
+	return tosa_tg_send(spi, TG_GPODR2, enable ? 0x01 : 0x00);
 }
 EXPORT_SYMBOL(tosa_bl_enable);
 
@@ -91,15 +91,17 @@ static void tosa_lcd_tg_on(struct tosa_l
 	tosa_tg_send(spi, TG_PNLCTL, value);
 
 	/* TG LCD pannel power up */
-	tosa_tg_send(spi, TG_PINICTL,0x4);
+	tosa_tg_send(spi, TG_PINICTL, 0x4);
 	mdelay(50);
 
 	/* TG LCD GVSS */
-	tosa_tg_send(spi, TG_PINICTL,0x0);
+	tosa_tg_send(spi, TG_PINICTL, 0x0);
 
 	if (!data->i2c) {
-		/* after the pannel is powered up the first time, we can access the i2c bus */
-		/* so probe for the DAC */
+		/*
+		 * after the pannel is powered up the first time,
+		 * we can access the i2c bus so probe for the DAC
+		 */
 		struct i2c_adapter *adap = i2c_get_adapter(0);
 		struct i2c_board_info info = {
 			.type	= "tosa-bl",
@@ -115,11 +117,11 @@ static void tosa_lcd_tg_off(struct tosa_
 	struct spi_device *spi = data->spi;
 
 	/* TG LCD VHSA off */
-	tosa_tg_send(spi, TG_PINICTL,0x4);
+	tosa_tg_send(spi, TG_PINICTL, 0x4);
 	mdelay(50);
 
 	/* TG LCD signal off */
-	tosa_tg_send(spi, TG_PINICTL,0x6);
+	tosa_tg_send(spi, TG_PINICTL, 0x6);
 	mdelay(50);
 
 	/* TG Off */
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

