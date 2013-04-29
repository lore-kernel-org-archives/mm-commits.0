From: akpm@linux-foundation.org
Subject: [folded-merged] drivers-video-backlight-l4f00242t03c-check-return-value-of-regulator_enable-fix.patch removed from -mm tree
Date: Mon, 29 Apr 2013 16:01:20 -0700
Message-ID: <20130429230121.4855731C022@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:41855 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758875Ab3D2XBW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Apr 2013 19:01:22 -0400
Received: by mail-vc0-f202.google.com with SMTP id hr11so484223vcb.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2013 16:01:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers-video-backlight-l4f00242t03c-check-return-value-of-regulator_enable-fix
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-l4f00242t03c-check-return-value-of-regulator_enable-fix.patch

This patch was dropped because it was folded into drivers-video-backlight-l4f00242t03c-check-return-value-of-regulator_enable.patch

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers-video-backlight-l4f00242t03c-check-return-value-of-regulator_enable-fix

- Added regulator_disable() for IO regulator before returning

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/l4f00242t03.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/video/backlight/l4f00242t03.c~drivers-video-backlight-l4f00242t03c-check-return-value-of-regulator_enable-fix drivers/video/backlight/l4f00242t03.c
--- a/drivers/video/backlight/l4f00242t03.c~drivers-video-backlight-l4f00242t03c-check-return-value-of-regulator_enable-fix
+++ a/drivers/video/backlight/l4f00242t03.c
@@ -69,11 +69,13 @@ static void l4f00242t03_lcd_init(struct
 	ret = regulator_set_voltage(priv->core_reg, 2800000, 2800000);
 	if (ret) {
 		dev_err(&spi->dev, "failed to set the core regulator voltage.\n");
+		regulator_disable(priv->io_reg);
 		return;
 	}
 	ret = regulator_enable(priv->core_reg);
 	if (ret) {
 		dev_err(&spi->dev, "failed to enable the core regulator.\n");
+		regulator_disable(priv->io_reg);
 		return;
 	}
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are


