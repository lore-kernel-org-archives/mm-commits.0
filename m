From: akpm@linux-foundation.org
Subject: + backlight-lm3649_backlight-remove-ret-=-eio-at-error-paths-of-probe.patch added to -mm tree
Date: Wed, 02 Jan 2013 13:31:26 -0800
Message-ID: <20130102213127.0FF1F20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:53164 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747Ab3ABVb3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jan 2013 16:31:29 -0500
Received: by mail-wi0-f202.google.com with SMTP id hn17so907031wib.3
        for <mm-commits@vger.kernel.org>; Wed, 02 Jan 2013 13:31:28 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: devendra.aaru@gmail.com, daniel.jeong@ti.com, gshark.jeong@gmail.com, jg1.han@samsung.com


The patch titled
     Subject: drivers/video/backlight/lm3639_bl.c: remove ret = -EIO at error paths of probe
has been added to the -mm tree.  Its filename is
     backlight-lm3649_backlight-remove-ret-=-eio-at-error-paths-of-probe.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Devendra Naga <devendra.aaru@gmail.com>
Subject: drivers/video/backlight/lm3639_bl.c: remove ret = -EIO at error paths of probe

The APIs are returning correctly the err codes, no need to assign -EIO
to the ret again.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
Acked-by: Daniel Jeong <daniel.jeong@ti.com>
Cc: G.Shark Jeong <gshark.jeong@gmail.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lm3639_bl.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/video/backlight/lm3639_bl.c~backlight-lm3649_backlight-remove-ret-=-eio-at-error-paths-of-probe drivers/video/backlight/lm3639_bl.c
--- a/drivers/video/backlight/lm3639_bl.c~backlight-lm3649_backlight-remove-ret-=-eio-at-error-paths-of-probe
+++ a/drivers/video/backlight/lm3639_bl.c
@@ -350,14 +350,13 @@ static int lm3639_probe(struct i2c_clien
 				      &lm3639_bled_ops, &props);
 	if (IS_ERR(pchip->bled)) {
 		dev_err(&client->dev, "fail : backlight register\n");
-		ret = -EIO;
+		ret = PTR_ERR(pchip->bled);
 		goto err_out;
 	}
 
 	ret = device_create_file(&(pchip->bled->dev), &dev_attr_bled_mode);
 	if (ret < 0) {
 		dev_err(&client->dev, "failed : add sysfs entries\n");
-		ret = -EIO;
 		goto err_bled_mode;
 	}
 
@@ -369,7 +368,6 @@ static int lm3639_probe(struct i2c_clien
 				    &client->dev, &pchip->cdev_flash);
 	if (ret < 0) {
 		dev_err(&client->dev, "fail : flash register\n");
-		ret = -EIO;
 		goto err_flash;
 	}
 
@@ -381,7 +379,6 @@ static int lm3639_probe(struct i2c_clien
 				    &client->dev, &pchip->cdev_torch);
 	if (ret < 0) {
 		dev_err(&client->dev, "fail : torch register\n");
-		ret = -EIO;
 		goto err_torch;
 	}
 
_

Patches currently in -mm which might be from devendra.aaru@gmail.com are

backlight-add-lms501kf03-lcd-driver.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
backlight-add-new-lp8788-backlight-driver.patch
backlight-lm3649_backlight-remove-ret-=-eio-at-error-paths-of-probe.patch
rtc-add-new-lp8788-rtc-driver.patch

