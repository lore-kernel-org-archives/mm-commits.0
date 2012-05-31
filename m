From: akpm@linux-foundation.org
Subject: [merged] backlight-tdo24m-use-devm_-functions.patch removed from -mm tree
Date: Thu, 31 May 2012 12:19:21 -0700
Message-ID: <20120531191921.4100DA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:45351 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933019Ab2EaTTV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:19:21 -0400
Received: by mail-yx0-f202.google.com with SMTP id l3so138243yen.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:19:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, eric.y.miao@gmail.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: tdo24m: use devm_ functions
has been removed from the -mm tree.  Its filename was
     backlight-tdo24m-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: tdo24m: use devm_ functions

The devm_ functions allocate memory that is released when a driver
detaches.  This patch uses devm_kzalloc of these functions.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/tdo24m.c |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff -puN drivers/video/backlight/tdo24m.c~backlight-tdo24m-use-devm_-functions drivers/video/backlight/tdo24m.c
--- a/drivers/video/backlight/tdo24m.c~backlight-tdo24m-use-devm_-functions
+++ a/drivers/video/backlight/tdo24m.c
@@ -349,7 +349,7 @@ static int __devinit tdo24m_probe(struct
 	if (err)
 		return err;
 
-	lcd = kzalloc(sizeof(struct tdo24m), GFP_KERNEL);
+	lcd = devm_kzalloc(&spi->dev, sizeof(struct tdo24m), GFP_KERNEL);
 	if (!lcd)
 		return -ENOMEM;
 
@@ -357,11 +357,9 @@ static int __devinit tdo24m_probe(struct
 	lcd->power = FB_BLANK_POWERDOWN;
 	lcd->mode = MODE_VGA;	/* default to VGA */
 
-	lcd->buf = kmalloc(TDO24M_SPI_BUFF_SIZE, GFP_KERNEL);
-	if (lcd->buf == NULL) {
-		kfree(lcd);
+	lcd->buf = devm_kzalloc(&spi->dev, TDO24M_SPI_BUFF_SIZE, GFP_KERNEL);
+	if (lcd->buf == NULL)
 		return -ENOMEM;
-	}
 
 	m = &lcd->msg;
 	x = &lcd->xfer;
@@ -383,15 +381,13 @@ static int __devinit tdo24m_probe(struct
 		break;
 	default:
 		dev_err(&spi->dev, "Unsupported model");
-		goto out_free;
+		return -EINVAL;
 	}
 
 	lcd->lcd_dev = lcd_device_register("tdo24m", &spi->dev,
 					lcd, &tdo24m_ops);
-	if (IS_ERR(lcd->lcd_dev)) {
-		err = PTR_ERR(lcd->lcd_dev);
-		goto out_free;
-	}
+	if (IS_ERR(lcd->lcd_dev))
+		return PTR_ERR(lcd->lcd_dev);
 
 	dev_set_drvdata(&spi->dev, lcd);
 	err = tdo24m_power(lcd, FB_BLANK_UNBLANK);
@@ -402,9 +398,6 @@ static int __devinit tdo24m_probe(struct
 
 out_unregister:
 	lcd_device_unregister(lcd->lcd_dev);
-out_free:
-	kfree(lcd->buf);
-	kfree(lcd);
 	return err;
 }
 
@@ -414,8 +407,6 @@ static int __devexit tdo24m_remove(struc
 
 	tdo24m_power(lcd, FB_BLANK_POWERDOWN);
 	lcd_device_unregister(lcd->lcd_dev);
-	kfree(lcd->buf);
-	kfree(lcd);
 
 	return 0;
 }
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch

