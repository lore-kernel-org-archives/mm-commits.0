From: akpm@linux-foundation.org
Subject: [merged] backlight-tosa_bl-use-devm_gpio_request.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:50:28 -0700
Message-ID: <20120731185028.C05341E007E@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:33060 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756300Ab2GaSu3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:50:29 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4676512obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:50:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, dbaryshkov@gmail.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: tosa_bl: use devm_gpio_request()
has been removed from the -mm tree.  Its filename was
     backlight-tosa_bl-use-devm_gpio_request.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: tosa_bl: use devm_gpio_request()

The devm_ functions allocate memory that is released when a driver
detaches.  This patch uses devm_gpio_request() for these functions.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/tosa_bl.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN drivers/video/backlight/tosa_bl.c~backlight-tosa_bl-use-devm_gpio_request drivers/video/backlight/tosa_bl.c
--- a/drivers/video/backlight/tosa_bl.c~backlight-tosa_bl-use-devm_gpio_request
+++ a/drivers/video/backlight/tosa_bl.c
@@ -92,14 +92,14 @@ static int __devinit tosa_bl_probe(struc
 
 	data->comadj = sharpsl_param.comadj == -1 ? COMADJ_DEFAULT : sharpsl_param.comadj;
 
-	ret = gpio_request(TOSA_GPIO_BL_C20MA, "backlight");
+	ret = devm_gpio_request(&client->dev, TOSA_GPIO_BL_C20MA, "backlight");
 	if (ret) {
 		dev_dbg(&data->bl->dev, "Unable to request gpio!\n");
 		return ret;
 	}
 	ret = gpio_direction_output(TOSA_GPIO_BL_C20MA, 0);
 	if (ret)
-		goto err_gpio_dir;
+		return ret;
 
 	i2c_set_clientdata(client, data);
 	data->i2c = client;
@@ -123,8 +123,6 @@ static int __devinit tosa_bl_probe(struc
 
 err_reg:
 	data->bl = NULL;
-err_gpio_dir:
-	gpio_free(TOSA_GPIO_BL_C20MA);
 	return ret;
 }
 
@@ -135,8 +133,6 @@ static int __devexit tosa_bl_remove(stru
 	backlight_device_unregister(data->bl);
 	data->bl = NULL;
 
-	gpio_free(TOSA_GPIO_BL_C20MA);
