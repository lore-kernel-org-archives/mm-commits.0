From: akpm@linux-foundation.org
Subject: + backlight-tosa_bl-use-devm_gpio_request.patch added to -mm tree
Date: Wed, 13 Jun 2012 13:35:14 -0700
Message-ID: <20120613203514.D525CA001B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:32918 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706Ab2FMUfP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jun 2012 16:35:15 -0400
Received: by ggeh3 with SMTP id h3so88086gge.1
        for <mm-commits@vger.kernel.org>; Wed, 13 Jun 2012 13:35:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, dbaryshkov@gmail.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight: tosa_bl: use devm_gpio_request()
has been added to the -mm tree.  Its filename is
     backlight-tosa_bl-use-devm_gpio_request.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
