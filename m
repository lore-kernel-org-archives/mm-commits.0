From: akpm@linux-foundation.org
Subject: [merged] backlight-ili9320-use-devm_-functions.patch removed from -mm tree
Date: Thu, 31 May 2012 12:19:08 -0700
Message-ID: <20120531191908.551A3A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:59318 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933019Ab2EaTTK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:19:10 -0400
Received: by mail-lb0-f202.google.com with SMTP id gp10so85912lbb.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:19:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, ben-linux@fluff.org, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: ili9320: use devm_ functions
has been removed from the -mm tree.  Its filename was
     backlight-ili9320-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: ili9320: use devm_ functions

The devm_ functions allocate memory that is released when a driver
detaches.  This patch uses devm_kzalloc of these functions.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ili9320.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN drivers/video/backlight/ili9320.c~backlight-ili9320-use-devm_-functions drivers/video/backlight/ili9320.c
--- a/drivers/video/backlight/ili9320.c~backlight-ili9320-use-devm_-functions
+++ a/drivers/video/backlight/ili9320.c
@@ -220,7 +220,7 @@ int __devinit ili9320_probe_spi(struct s
 
 	/* allocate and initialse our state */
 
-	ili = kzalloc(sizeof(struct ili9320), GFP_KERNEL);
+	ili = devm_kzalloc(&spi->dev, sizeof(struct ili9320), GFP_KERNEL);
 	if (ili == NULL) {
 		dev_err(dev, "no memory for device\n");
 		return -ENOMEM;
@@ -240,8 +240,7 @@ int __devinit ili9320_probe_spi(struct s
 	lcd = lcd_device_register("ili9320", dev, ili, &ili9320_ops);
 	if (IS_ERR(lcd)) {
 		dev_err(dev, "failed to register lcd device\n");
-		ret = PTR_ERR(lcd);
-		goto err_free;
+		return PTR_ERR(lcd);
 	}
 
 	ili->lcd = lcd;
@@ -259,9 +258,6 @@ int __devinit ili9320_probe_spi(struct s
  err_unregister:
 	lcd_device_unregister(lcd);
 
- err_free:
-	kfree(ili);
