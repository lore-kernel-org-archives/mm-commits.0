From: akpm@linux-foundation.org
Subject: [merged] backlight-lp855x_bl-simplify-bl_get_brightness.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:42:30 -0800
Message-ID: <20130222204230.B17CC5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:63476 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829Ab3BVUmb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:42:31 -0500
Received: by mail-qa0-f74.google.com with SMTP id o13so119085qaj.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:42:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Milo.Kim@ti.com, jg1.han@samsung.com, milo.kim@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: lp855x_bl: simplify bl_get_brightness()
has been removed from the -mm tree.  Its filename was
     backlight-lp855x_bl-simplify-bl_get_brightness.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
