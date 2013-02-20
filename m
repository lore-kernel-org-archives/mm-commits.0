From: akpm@linux-foundation.org
Subject: + backlight-lp855x_bl-simplify-bl_get_brightness.patch added to -mm tree
Date: Wed, 20 Feb 2013 13:17:17 -0800
Message-ID: <20130220211718.26B6031C346@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:35909 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab3BTVRT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Feb 2013 16:17:19 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so835802yhz.5
        for <mm-commits@vger.kernel.org>; Wed, 20 Feb 2013 13:17:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Milo.Kim@ti.com, jg1.han@samsung.com, milo.kim@ti.com


The patch titled
     Subject: backlight: lp855x_bl: simplify bl_get_brightness()
has been added to the -mm tree.  Its filename is
     backlight-lp855x_bl-simplify-bl_get_brightness.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kim, Milo" <Milo.Kim@ti.com>
Subject: backlight: lp855x_bl: simplify bl_get_brightness()

Getting the brightness value is not critical, no need to read the actual
register value.  To simplify it, just return the 'bl->props.brightness'
value.  Then, lp855x_read_byte() can be removed, not used any more.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lp855x_bl.c |   24 ------------------------
 1 file changed, 24 deletions(-)

diff -puN drivers/video/backlight/lp855x_bl.c~backlight-lp855x_bl-simplify-bl_get_brightness drivers/video/backlight/lp855x_bl.c
--- a/drivers/video/backlight/lp855x_bl.c~backlight-lp855x_bl-simplify-bl_get_brightness
+++ a/drivers/video/backlight/lp855x_bl.c
@@ -66,20 +66,6 @@ struct lp855x {
 	struct pwm_device *pwm;
 };
 
-static int lp855x_read_byte(struct lp855x *lp, u8 reg, u8 *data)
-{
-	int ret;
-
-	ret = i2c_smbus_read_byte_data(lp->client, reg);
-	if (ret < 0) {
-		dev_err(lp->dev, "failed to read 0x%.2x\n", reg);
-		return ret;
-	}
-
-	*data = (u8)ret;
-	return 0;
-}
-
 static int lp855x_write_byte(struct lp855x *lp, u8 reg, u8 data)
 {
 	return i2c_smbus_write_byte_data(lp->client, reg, data);
@@ -274,16 +260,6 @@ static int lp855x_bl_update_status(struc
 
 static int lp855x_bl_get_brightness(struct backlight_device *bl)
 {
-	struct lp855x *lp = bl_get_data(bl);
-	enum lp855x_brightness_ctrl_mode mode = lp->pdata->mode;
-
-	if (mode == REGISTER_BASED) {
-		u8 val = 0;
-
-		lp855x_read_byte(lp, lp->cfg->reg_brightness, &val);
-		bl->props.brightness = val;
-	}
