From: akpm@linux-foundation.org
Subject: + backlight-lp855x_blc-check-platform-data-in-lp855x_probe.patch added to -mm tree
Date: Thu, 02 Feb 2012 15:47:11 -0800
Message-ID: <20120202234712.0DA0FA0291@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:58209 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272Ab2BBXrN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Feb 2012 18:47:13 -0500
Received: by yenl2 with SMTP id l2so332118yen.1
        for <mm-commits@vger.kernel.org>; Thu, 02 Feb 2012 15:47:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, milo.kim@ti.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight/lp855x_bl.c: check platform data in lp855x_probe()
has been added to the -mm tree.  Its filename is
     backlight-lp855x_blc-check-platform-data-in-lp855x_probe.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Axel Lin <axel.lin@gmail.com>
Subject: backlight/lp855x_bl.c: check platform data in lp855x_probe()

The reset of the code assumes pdata is not NULL.  Add checking for pdata
in lp855x_probe(), this prevents NULL dereference if pdata is NULL.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: "Milo(Woogyom) Kim" <milo.kim@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lp855x_bl.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/video/backlight/lp855x_bl.c~backlight-lp855x_blc-check-platform-data-in-lp855x_probe drivers/video/backlight/lp855x_bl.c
--- a/drivers/video/backlight/lp855x_bl.c~backlight-lp855x_blc-check-platform-data-in-lp855x_probe
+++ a/drivers/video/backlight/lp855x_bl.c
@@ -231,9 +231,14 @@ static int lp855x_probe(struct i2c_clien
 {
 	struct lp855x *lp;
 	struct lp855x_platform_data *pdata = cl->dev.platform_data;
-	enum lp855x_brightness_ctrl_mode mode = pdata->mode;
+	enum lp855x_brightness_ctrl_mode mode;
 	int ret;
 
+	if (!pdata) {
+		dev_err(&cl->dev, "no platform data supplied\n");
+		return -EINVAL;
+	}
+
 	if (!i2c_check_functionality(cl->adapter, I2C_FUNC_SMBUS_I2C_BLOCK))
 		return -EIO;
 
@@ -241,6 +246,7 @@ static int lp855x_probe(struct i2c_clien
 	if (!lp)
 		return -ENOMEM;
 
+	mode = pdata->mode;
 	lp->client = cl;
 	lp->dev = &cl->dev;
 	lp->pdata = pdata;
_
Subject: Subject: backlight/lp855x_bl.c: check platform data in lp855x_probe()

Patches currently in -mm which might be from axel.lin@gmail.com are

linux-next.patch
platform-drivers-x86-convert-drivers-platform-x86-to-use-module_platform_driver.patch
backlight-convert-backlight-i2c-drivers-to-module_i2c_driver.patch
backlight-convert-backlight-spi-drivers-to-module_spi_driver.patch
backlight-new-backlight-driver-for-lp855x-devices-fix.patch
backlight-lp855x_blc-check-platform-data-in-lp855x_probe.patch
backlight-lp855x_blc-small-cleanups.patch
rtc-convert-rtc-spi-drivers-to-module_spi_driver.patch
rtc-convert-rtc-i2c-drivers-to-module_i2c_driver.patch

