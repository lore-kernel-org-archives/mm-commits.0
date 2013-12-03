From: akpm@linux-foundation.org
Subject: + backlight-l4f00242t03-use-devm_lcd_device_register.patch added
 to -mm tree
Date: Mon, 02 Dec 2013 17:00:37 -0800
Message-ID: <529d2d35.PSl7k46/e2WGkiAc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43581 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972Ab3LCBAi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Dec 2013 20:00:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tomi.valkeinen@ti.com, jg1.han@samsung.com

Subject: + backlight-l4f00242t03-use-devm_lcd_device_register.patch added to -mm tree
To: jg1.han@samsung.com,tomi.valkeinen@ti.com
From: akpm@linux-foundation.org
Date: Mon, 02 Dec 2013 17:00:37 -0800


The patch titled
     Subject: backlight: l4f00242t03: use devm_lcd_device_register()
has been added to the -mm tree.  Its filename is
     backlight-l4f00242t03-use-devm_lcd_device_register.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/backlight-l4f00242t03-use-devm_lcd_device_register.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/backlight-l4f00242t03-use-devm_lcd_device_register.patch

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
Subject: backlight: l4f00242t03: use devm_lcd_device_register()

Use devm_lcd_device_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/l4f00242t03.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/video/backlight/l4f00242t03.c~backlight-l4f00242t03-use-devm_lcd_device_register drivers/video/backlight/l4f00242t03.c
--- a/drivers/video/backlight/l4f00242t03.c~backlight-l4f00242t03-use-devm_lcd_device_register
+++ a/drivers/video/backlight/l4f00242t03.c
@@ -223,8 +223,8 @@ static int l4f00242t03_probe(struct spi_
 		return PTR_ERR(priv->core_reg);
 	}
 
-	priv->ld = lcd_device_register("l4f00242t03",
-					&spi->dev, priv, &l4f_ops);
+	priv->ld = devm_lcd_device_register(&spi->dev, "l4f00242t03", &spi->dev,
+					priv, &l4f_ops);
 	if (IS_ERR(priv->ld))
 		return PTR_ERR(priv->ld);
 
@@ -243,8 +243,6 @@ static int l4f00242t03_remove(struct spi
 	struct l4f00242t03_priv *priv = spi_get_drvdata(spi);
 
 	l4f00242t03_lcd_power_set(priv->ld, FB_BLANK_POWERDOWN);
-	lcd_device_unregister(priv->ld);
