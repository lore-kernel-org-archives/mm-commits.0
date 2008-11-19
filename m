From: akpm@linux-foundation.org
Subject: + backlight-value-of-ili9320_rgb_if2-register-should-not-be-hardcoded.patch added to -mm tree
Date: Tue, 18 Nov 2008 16:43:13 -0800
Message-ID: <200811190043.mAJ0hDjd030924@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36896 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750990AbYKSAoT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Nov 2008 19:44:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: den@openvz.org, ben-linux@fluff.org


The patch titled
     backlight: value of ILI9320_RGB_IF2 register should not be hardcoded
has been added to the -mm tree.  Its filename is
     backlight-value-of-ili9320_rgb_if2-register-should-not-be-hardcoded.patch

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
Subject: backlight: value of ILI9320_RGB_IF2 register should not be hardcoded
From: "Denis V. Lunev" <den@openvz.org>

It is stored in the board specific file
  ./arch/arm/mach-s3c2412/mach-jive.c
as .rgb_if2.

Actually, the value is correct, only semantic is wrong.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/vgg2432a4.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/vgg2432a4.c~backlight-value-of-ili9320_rgb_if2-register-should-not-be-hardcoded drivers/video/backlight/vgg2432a4.c
--- a/drivers/video/backlight/vgg2432a4.c~backlight-value-of-ili9320_rgb_if2-register-should-not-be-hardcoded
+++ a/drivers/video/backlight/vgg2432a4.c
@@ -137,7 +137,7 @@ static int vgg2432a4_lcd_init(struct ili
 
 	ili9320_write(lcd, ILI9320_RGB_IF1, cfg->rgb_if1);
 	ili9320_write(lcd, ILI9320_FRAMEMAKER, 0x0);
-	ili9320_write(lcd, ILI9320_RGB_IF2, ILI9320_RGBIF2_DPL);
+	ili9320_write(lcd, ILI9320_RGB_IF2, cfg->rgb_if2);
 
 	ret = ili9320_write_regs(lcd, vgg_init1, ARRAY_SIZE(vgg_init1));
 	if (ret != 0)
_

Patches currently in -mm which might be from den@openvz.org are

backlight-value-of-ili9320_rgb_if2-register-should-not-be-hardcoded.patch

