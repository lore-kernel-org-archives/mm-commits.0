From: akpm@linux-foundation.org
Subject: [merged] backlight-lms283gf05-use-devm_lcd_device_register.patch
 removed from -mm tree
Date: Wed, 13 Nov 2013 12:41:36 -0800
Message-ID: <5283e400.0A9RtegAdo5H6CCz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43033 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab3KMUlg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:41:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] backlight-lms283gf05-use-devm_lcd_device_register.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:41:36 -0800


The patch titled
     Subject: backlight: lms283gf05: use devm_lcd_device_register()
has been removed from the -mm tree.  Its filename was
     backlight-lms283gf05-use-devm_lcd_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: lms283gf05: use devm_lcd_device_register()

Use devm_lcd_device_register() to make cleanup paths simpler, and remove
unnecessary remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lms283gf05.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff -puN drivers/video/backlight/lms283gf05.c~backlight-lms283gf05-use-devm_lcd_device_register drivers/video/backlight/lms283gf05.c
--- a/drivers/video/backlight/lms283gf05.c~backlight-lms283gf05-use-devm_lcd_device_register
+++ a/drivers/video/backlight/lms283gf05.c
@@ -173,7 +173,8 @@ static int lms283gf05_probe(struct spi_d
 		return -ENOMEM;
 	}
 
-	ld = lcd_device_register("lms283gf05", &spi->dev, st, &lms_ops);
+	ld = devm_lcd_device_register(&spi->dev, "lms283gf05", &spi->dev, st,
+					&lms_ops);
 	if (IS_ERR(ld))
 		return PTR_ERR(ld);
 
@@ -190,22 +191,12 @@ static int lms283gf05_probe(struct spi_d
 	return 0;
 }
 
-static int lms283gf05_remove(struct spi_device *spi)
-{
-	struct lms283gf05_state *st = spi_get_drvdata(spi);
-
-	lcd_device_unregister(st->ld);
-
-	return 0;
-}
