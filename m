From: akpm@linux-foundation.org
Subject: [merged] backlight-tosa-fix-checkpatch-error-and-warning.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:04:44 -0800
Message-ID: <20121218200444.B42DA82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:49102 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2LRUEp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:04:45 -0500
Received: by mail-ye0-f202.google.com with SMTP id l7so125361yen.5
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:04:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: tosa: fix checkpatch error and warning
has been removed from the -mm tree.  Its filename was
     backlight-tosa-fix-checkpatch-error-and-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -90,7 +90,8 @@ static int tosa_bl_probe(struct i2c_clie
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

origin.patch
backlight-locomolcd-fix-checkpatch-error-and-warning.patch

