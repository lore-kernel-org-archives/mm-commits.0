From: akpm@linux-foundation.org
Subject: - backlight-value-of-ili9320_rgb_if2-register-should-not-be-hardcoded.patch removed from -mm tree
Date: Mon, 08 Dec 2008 15:24:23 -0800
Message-ID: <200812082324.mB8NONCq006955@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753235AbYLHXZd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Dec 2008 18:25:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, ben-linux@fluff.org, mm-commits@vger.kernel.org


The patch titled
     backlight: value of ILI9320_RGB_IF2 register should not be hardcoded
has been removed from the -mm tree.  Its filename was
     backlight-value-of-ili9320_rgb_if2-register-should-not-be-hardcoded.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
ipc-do-not-goto-to-the-next-line.patch

