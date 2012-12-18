From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-lp855x_blc-remove-unnecessary-mutex-code.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:05:01 -0800
Message-ID: <20121218200502.39D2620005C@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:53489 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2LRUFF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:05:05 -0500
Received: by mail-lb0-f202.google.com with SMTP id s4so69700lbc.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:05:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Milo.Kim@ti.com, bryan.wu@canonical.com, milo.kim@ti.com, rpurdie@rpsys.net, thierry.reding@avionic-design.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/lp855x_bl.c: remove unnecessary mutex code
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-lp855x_blc-remove-unnecessary-mutex-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kim, Milo" <Milo.Kim@ti.com>
Subject: drivers/video/backlight/lp855x_bl.c: remove unnecessary mutex code

The mutex for accessing lp855x registers is used in case of the user-space
interaction.  When the brightness is changed via sysfs, the mutex is
required.  But the backlight class device already provides it.  Thus, the
lp855x mutex is unnecessary.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Bryan Wu <bryan.wu@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lp855x_bl.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff -puN drivers/video/backlight/lp855x_bl.c~drivers-video-backlight-lp855x_blc-remove-unnecessary-mutex-code drivers/video/backlight/lp855x_bl.c
--- a/drivers/video/backlight/lp855x_bl.c~drivers-video-backlight-lp855x_blc-remove-unnecessary-mutex-code
+++ a/drivers/video/backlight/lp855x_bl.c
@@ -35,7 +35,6 @@ struct lp855x {
 	struct i2c_client *client;
 	struct backlight_device *bl;
 	struct device *dev;
-	struct mutex xfer_lock;
 	struct lp855x_platform_data *pdata;
 	struct pwm_device *pwm;
 };
@@ -44,14 +43,11 @@ static int lp855x_read_byte(struct lp855
 {
 	int ret;
 
-	mutex_lock(&lp->xfer_lock);
 	ret = i2c_smbus_read_byte_data(lp->client, reg);
 	if (ret < 0) {
-		mutex_unlock(&lp->xfer_lock);
 		dev_err(lp->dev, "failed to read 0x%.2x\n", reg);
 		return ret;
 	}
-	mutex_unlock(&lp->xfer_lock);
 
 	*data = (u8)ret;
 	return 0;
@@ -59,13 +55,7 @@ static int lp855x_read_byte(struct lp855
 
 static int lp855x_write_byte(struct lp855x *lp, u8 reg, u8 data)
 {
-	int ret;
-
-	mutex_lock(&lp->xfer_lock);
-	ret = i2c_smbus_write_byte_data(lp->client, reg, data);
-	mutex_unlock(&lp->xfer_lock);
-
-	return ret;
+	return i2c_smbus_write_byte_data(lp->client, reg, data);
 }
 
 static bool lp855x_is_valid_rom_area(struct lp855x *lp, u8 addr)
@@ -281,8 +271,6 @@ static int lp855x_probe(struct i2c_clien
 	lp->chip_id = id->driver_data;
 	i2c_set_clientdata(cl, lp);
 
-	mutex_init(&lp->xfer_lock);
