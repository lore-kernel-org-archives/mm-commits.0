From: akpm@linux-foundation.org
Subject: + backlight-ensure-platform_lcd-on-by-default.patch added to -mm tree
Date: Mon, 28 Jul 2008 16:20:07 -0700
Message-ID: <200807282320.m6SNK76W001240@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39974 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751454AbYG1XUx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 19:20:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-linux@fluff.org, rpurdie@rpsys.net


The patch titled
     backlight: ensure platform_lcd on by default
has been added to the -mm tree.  Its filename is
     backlight-ensure-platform_lcd-on-by-default.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
spi_s3c24xx-really-assign-busnum.patch
backlight-give-platform_lcd-the-same-name-as-the-platform-device.patch
resource-add-resource_size.patch
backlight-ensure-platform_lcd-on-by-default.patch
linux-next.patch
resource-add-resource_type-and-ioresource_type_bits.patch
resource-add-new-ioresource_clk-type-v2.patch
i2c-sh_mobile-ioresource_clk-support.patch

