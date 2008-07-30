From: akpm@linux-foundation.org
Subject: - backlight-ensure-platform_lcd-on-by-default.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:14:27 -0700
Message-ID: <200807301914.m6UJER3F010907@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40699 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752579AbYG3TPj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:15:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     backlight: ensure platform_lcd on by default
has been removed from the -mm tree.  Its filename was
     backlight-ensure-platform_lcd-on-by-default.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: backlight: ensure platform_lcd on by default
From: Ben Dooks <ben-linux@fluff.org>

It seems that we need to ensure that the lcd is powered up at start,
otherwise we do not see a display.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/platform_lcd.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/video/backlight/platform_lcd.c~backlight-ensure-platform_lcd-on-by-default drivers/video/backlight/platform_lcd.c
--- a/drivers/video/backlight/platform_lcd.c~backlight-ensure-platform_lcd-on-by-default
+++ a/drivers/video/backlight/platform_lcd.c
@@ -101,6 +101,8 @@ static int __devinit platform_lcd_probe(
 	}
 
 	platform_set_drvdata(pdev, plcd);
+	platform_lcd_set_power(plcd->lcd, FB_BLANK_NORMAL);
+
 	return 0;
 
  err_mem:
_

Patches currently in -mm which might be from ben-linux@fluff.org are

origin.patch
linux-next.patch
backlight-add-more-information-output-to-pwm_backlight.patch
backlight-add-module_alias-to-pwm_backlight-driver.patch
resource-add-resource_type-and-ioresource_type_bits.patch
resource-add-new-ioresource_clk-type-v2.patch
i2c-sh_mobile-ioresource_clk-support.patch

