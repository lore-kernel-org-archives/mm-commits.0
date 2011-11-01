From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-l4f00242t03c-use-gpio_request_one-to-simplify-error-handling.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:14:56 -0700
Message-ID: <201111012114.pA1LEuix012829@hpaq13.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:29917 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676Ab1KAVPF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:15:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: festevam@gmail.com, fabio.estevam@freescale.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/l4f00242t03.c: use gpio_request_one() to simplify error handling
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-l4f00242t03c-use-gpio_request_one-to-simplify-error-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Fabio Estevam <festevam@gmail.com>
Subject: drivers/video/backlight/l4f00242t03.c: use gpio_request_one() to simplify error handling

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
@@ -171,29 +171,22 @@ static int __devinit l4f00242t03_probe(s
 
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
