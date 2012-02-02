From: akpm@linux-foundation.org
Subject: + backlight-lp855x_blc-small-cleanups.patch added to -mm tree
Date: Thu, 02 Feb 2012 15:47:13 -0800
Message-ID: <20120202234713.D41E3A0291@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:43898 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932190Ab2BBXrQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Feb 2012 18:47:16 -0500
Received: by eekb15 with SMTP id b15so93091eek.1
        for <mm-commits@vger.kernel.org>; Thu, 02 Feb 2012 15:47:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, milo.kim@ti.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight/lp855x_bl.c: small cleanups
has been added to the -mm tree.  Its filename is
     backlight-lp855x_blc-small-cleanups.patch

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
Subject: backlight/lp855x_bl.c: small cleanups

- Make lp855x_bl_update_status() return 0 instead of
  bl->props.brightness.  It looks pointless to return bl->props.brightness
  for lp855x_bl_update_status.  Make it return 0 on success.

- Use devm_kzalloc to save a few error handling code.

- Use module_i2c_driver

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: "Milo(Woogyom) Kim" <milo.kim@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lp855x_bl.c |   25 +++++--------------------
 1 file changed, 5 insertions(+), 20 deletions(-)

diff -puN drivers/video/backlight/lp855x_bl.c~backlight-lp855x_blc-small-cleanups drivers/video/backlight/lp855x_bl.c
--- a/drivers/video/backlight/lp855x_bl.c~backlight-lp855x_blc-small-cleanups
+++ a/drivers/video/backlight/lp855x_bl.c
@@ -132,7 +132,7 @@ static int lp855x_bl_update_status(struc
 		lp855x_write_byte(lp, BRIGHTNESS_CTRL, val);
 	}
 
-	return bl->props.brightness;
+	return 0;
 }
 
 static int lp855x_bl_get_brightness(struct backlight_device *bl)
@@ -242,7 +242,7 @@ static int lp855x_probe(struct i2c_clien
 	if (!i2c_check_functionality(cl->adapter, I2C_FUNC_SMBUS_I2C_BLOCK))
 		return -EIO;
 
-	lp = kzalloc(sizeof(struct lp855x), GFP_KERNEL);
+	lp = devm_kzalloc(&cl->dev, sizeof(struct lp855x), GFP_KERNEL);
 	if (!lp)
 		return -ENOMEM;
 
@@ -276,14 +276,11 @@ static int lp855x_probe(struct i2c_clien
 	}
 
 	backlight_update_status(lp->bl);
-	return ret;
+	return 0;
 
-err_dev:
-	kfree(lp);
-	return ret;
 err_sysfs:
 	lp855x_backlight_unregister(lp);
-	kfree(lp);
+err_dev:
 	return ret;
 }
 
@@ -295,7 +292,6 @@ static int __devexit lp855x_remove(struc
 	backlight_update_status(lp->bl);
 	sysfs_remove_group(&lp->dev->kobj, &lp855x_attr_group);
 	lp855x_backlight_unregister(lp);
-	kfree(lp);
 
 	return 0;
 }
@@ -319,18 +315,7 @@ static struct i2c_driver lp855x_driver =
 	.id_table = lp855x_ids,
 };
 
-static int __init lp855x_init(void)
-{
-	return i2c_add_driver(&lp855x_driver);
-}
-
-static void __exit lp855x_exit(void)
-{
-	i2c_del_driver(&lp855x_driver);
-}
