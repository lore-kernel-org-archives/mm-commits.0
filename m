From: akpm@linux-foundation.org
Subject: [merged] backlight-lm3649_backlight-remove-ret-=-eio-at-error-paths-of-probe.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:41:53 -0800
Message-ID: <20130222204153.A05A55A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:50914 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829Ab3BVUly (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:41:54 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so103862ggn.4
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:41:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: devendra.aaru@gmail.com, daniel.jeong@ti.com, gshark.jeong@gmail.com, jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/lm3639_bl.c: remove ret = -EIO at error paths of probe
has been removed from the -mm tree.  Its filename was
     backlight-lm3649_backlight-remove-ret-=-eio-at-error-paths-of-probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
backlight-add-new-lp8788-backlight-driver.patch

