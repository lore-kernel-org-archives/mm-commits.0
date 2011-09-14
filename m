From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-l4f00242t03c-use-gpio_request_one-to-simplify-error-handling.patch added to -mm tree
Date: Wed, 14 Sep 2011 13:42:45 -0700
Message-ID: <201109142042.p8EKgjH8029491@hpaq11.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:14348 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933143Ab1INUmz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Sep 2011 16:42:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: festevam@gmail.com, fabio.estevam@freescale.com, rpurdie@rpsys.net


The patch titled
     drivers/video/backlight/l4f00242t03.c: use gpio_request_one() to simplify error handling
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-l4f00242t03c-use-gpio_request_one-to-simplify-error-handling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video/backlight/l4f00242t03.c: use gpio_request_one() to simplify error handling
From: Fabio Estevam <festevam@gmail.com>

Using gpio_request_one can make the error handling simpler.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/l4f00242t03.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff -puN drivers/video/backlight/l4f00242t03.c~drivers-video-backlight-l4f00242t03c-use-gpio_request_one-to-simplify-error-handling drivers/video/backlight/l4f00242t03.c
--- a/drivers/video/backlight/l4f00242t03.c~drivers-video-backlight-l4f00242t03c-use-gpio_request_one-to-simplify-error-handling
+++ a/drivers/video/backlight/l4f00242t03.c
@@ -178,29 +178,22 @@ static int __devinit l4f00242t03_probe(s
 
 	priv->spi = spi;
 
-	ret = gpio_request(pdata->reset_gpio, "lcd l4f00242t03 reset");
+	ret = gpio_request_one(pdata->reset_gpio, GPIOF_OUT_INIT_HIGH,
+						"lcd l4f00242t03 reset");
 	if (ret) {
 		dev_err(&spi->dev,
 			"Unable to get the lcd l4f00242t03 reset gpio.\n");
 		goto err;
 	}
 
-	ret = gpio_direction_output(pdata->reset_gpio, 1);
-	if (ret)
-		goto err2;
-
-	ret = gpio_request(pdata->data_enable_gpio,
-				"lcd l4f00242t03 data enable");
+	ret = gpio_request_one(pdata->data_enable_gpio, GPIOF_OUT_INIT_LOW,
+						"lcd l4f00242t03 data enable");
 	if (ret) {
 		dev_err(&spi->dev,
 			"Unable to get the lcd l4f00242t03 data en gpio.\n");
 		goto err2;
 	}
 
-	ret = gpio_direction_output(pdata->data_enable_gpio, 0);
-	if (ret)
-		goto err3;
