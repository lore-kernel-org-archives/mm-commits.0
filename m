From: akpm@linux-foundation.org
Subject: [merged] backlight-tosa_bl-use-devm_-functions.patch removed from -mm tree
Date: Thu, 31 May 2012 12:19:23 -0700
Message-ID: <20120531191923.573F5A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:59318 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933018Ab2EaTTZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:19:25 -0400
Received: by mail-lb0-f202.google.com with SMTP id gp10so85912lbb.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:19:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, dbaryshkov@gmail.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: tosa_bl: use devm_ functions
has been removed from the -mm tree.  Its filename was
     backlight-tosa_bl-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: tosa_bl: use devm_ functions

The devm_ functions allocate memory that is released when a driver
detaches.  This patch uses devm_kzalloc of these functions.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/tosa_bl.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN drivers/video/backlight/tosa_bl.c~backlight-tosa_bl-use-devm_-functions drivers/video/backlight/tosa_bl.c
--- a/drivers/video/backlight/tosa_bl.c~backlight-tosa_bl-use-devm_-functions
+++ a/drivers/video/backlight/tosa_bl.c
@@ -82,8 +82,11 @@ static int __devinit tosa_bl_probe(struc
 		const struct i2c_device_id *id)
 {
 	struct backlight_properties props;
-	struct tosa_bl_data *data = kzalloc(sizeof(struct tosa_bl_data), GFP_KERNEL);
+	struct tosa_bl_data *data;
 	int ret = 0;
+
+	data = devm_kzalloc(&client->dev, sizeof(struct tosa_bl_data),
+				GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
@@ -92,7 +95,7 @@ static int __devinit tosa_bl_probe(struc
 	ret = gpio_request(TOSA_GPIO_BL_C20MA, "backlight");
 	if (ret) {
 		dev_dbg(&data->bl->dev, "Unable to request gpio!\n");
-		goto err_gpio_bl;
+		return ret;
 	}
 	ret = gpio_direction_output(TOSA_GPIO_BL_C20MA, 0);
 	if (ret)
@@ -122,8 +125,6 @@ err_reg:
 	data->bl = NULL;
 err_gpio_dir:
 	gpio_free(TOSA_GPIO_BL_C20MA);
-err_gpio_bl:
-	kfree(data);
 	return ret;
 }
 
@@ -136,8 +137,6 @@ static int __devexit tosa_bl_remove(stru
 
 	gpio_free(TOSA_GPIO_BL_C20MA);
 
-	kfree(data);
