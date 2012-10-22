From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-lp855x_blc-remove-unnecessary-mutex-code.patch added to -mm tree
Date: Mon, 22 Oct 2012 15:30:53 -0700
Message-ID: <20121022223054.2B81E1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:45476 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241Ab2JVWaz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Oct 2012 18:30:55 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so405274qcq.1
        for <mm-commits@vger.kernel.org>; Mon, 22 Oct 2012 15:30:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Milo.Kim@ti.com, bryan.wu@canonical.com, milo.kim@ti.com, rpurdie@rpsys.net, thierry.reding@avionic-design.de


The patch titled
     Subject: drivers/video/backlight/lp855x_bl.c: remove unnecessary mutex code
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-lp855x_blc-remove-unnecessary-mutex-code.patch

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
