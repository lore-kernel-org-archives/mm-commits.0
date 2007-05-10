From: akpm@linux-foundation.org
Subject: + pm2fb-fb_sync-added.patch added to -mm tree
Date: Wed, 09 May 2007 21:37:39 -0700
Message-ID: <200705100437.l4A4bdD6012127@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33903 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754833AbXEJEhx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 00:37:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com, krzysztof.h1@wp.pl


The patch titled
     pm2fb: fb_sync added
has been added to the -mm tree.  Its filename is
     pm2fb-fb_sync-added.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pm2fb: fb_sync added
From: "Antonino A. Daplas" <adaplas@gmail.com>

Convert internal wait_pm2() function to fb API fb_sync() method.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm2fb.c |   38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff -puN drivers/video/pm2fb.c~pm2fb-fb_sync-added drivers/video/pm2fb.c
--- a/drivers/video/pm2fb.c~pm2fb-fb_sync-added
+++ a/drivers/video/pm2fb.c
@@ -204,17 +204,6 @@ static inline void WAIT_FIFO(struct pm2f
 }
 #endif
 
-static void wait_pm2(struct pm2fb_par* par) {
-
-	WAIT_FIFO(par, 1);
-	pm2_WR(par, PM2R_SYNC, 0);
-	mb();
-	do {
-		while (pm2_RD(par, PM2R_OUT_FIFO_WORDS) == 0);
-		rmb();
-	} while (pm2_RD(par, PM2R_OUT_FIFO) != PM2TAG(PM2R_SYNC));
-}
-
 /*
  * partial products for the supported horizontal resolutions.
  */
@@ -1050,13 +1039,30 @@ static int pm2fb_blank(int blank_mode, s
 	return 0;
 }
 
+static int pm2fb_sync(struct fb_info *info)
+{
+	struct pm2fb_par *par = info->par;
+
+	WAIT_FIFO(par, 1);
+	pm2_WR(par, PM2R_SYNC, 0);
+	mb();
+	do {
+		while (pm2_RD(par, PM2R_OUT_FIFO_WORDS) == 0)
+			udelay(10);
+		rmb();
+	} while (pm2_RD(par, PM2R_OUT_FIFO) != PM2TAG(PM2R_SYNC));
+
+	return 0;
+}
+
 /*
  * block operation. copy=0: rectangle fill, copy=1: rectangle copy.
  */
-static void pm2fb_block_op(struct pm2fb_par* par, int copy,
+static void pm2fb_block_op(struct fb_info* info, int copy,
 				s32 xsrc, s32 ysrc,
 				s32 x, s32 y, s32 w, s32 h,
 				u32 color) {
+	struct pm2fb_par *par = info->par;
 
 	if (!w || !h)
 		return;
@@ -1076,13 +1082,11 @@ static void pm2fb_block_op(struct pm2fb_
 				(x<xsrc ? PM2F_INCREASE_X : 0) |
 				(y<ysrc ? PM2F_INCREASE_Y : 0) |
 				(copy ? 0 : PM2F_RENDER_FASTFILL));
-	wait_pm2(par);
 }
 
 static void pm2fb_fillrect (struct fb_info *info,
 				const struct fb_fillrect *region)
 {
-	struct pm2fb_par *par = info->par;
 	struct fb_fillrect modded;
 	int vxres, vyres;
 	u32 color = (info->fix.visual == FB_VISUAL_TRUECOLOR) ?
@@ -1116,7 +1120,7 @@ static void pm2fb_fillrect (struct fb_in
 		color |= color << 16;
 
 	if(info->var.bits_per_pixel != 24)
-		pm2fb_block_op(par, 0, 0, 0,
+		pm2fb_block_op(info, 0, 0, 0,
 				modded.dx, modded.dy,
 				modded.width, modded.height, color);
 	else
@@ -1126,7 +1130,6 @@ static void pm2fb_fillrect (struct fb_in
 static void pm2fb_copyarea(struct fb_info *info,
 				const struct fb_copyarea *area)
 {
-	struct pm2fb_par *par = info->par;
 	struct fb_copyarea modded;
 	u32 vxres, vyres;
 
@@ -1156,7 +1159,7 @@ static void pm2fb_copyarea(struct fb_inf
 	if(modded.dy + modded.height > vyres)
 		modded.height = vyres - modded.dy;
 
-	pm2fb_block_op(par, 1, modded.sx, modded.sy,
+	pm2fb_block_op(info, 1, modded.sx, modded.sy,
 			modded.dx, modded.dy,
 			modded.width, modded.height, 0);
 }
@@ -1177,6 +1180,7 @@ static struct fb_ops pm2fb_ops = {
 	.fb_fillrect	= pm2fb_fillrect,
 	.fb_copyarea	= pm2fb_copyarea,
 	.fb_imageblit	= cfb_imageblit,
+	.fb_sync	= pm2fb_sync,
 };
 
 /*
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
pm3fb-preliminary-24-to-26-port.patch
atmel_lcdfb-at91-at32-lcd-controller-framebuffer-driver.patch
rivafb-fix-i2c-getscl-callback-function.patch
nvidiafb-enable-debugging-messages-a-kconfig-option.patch
pm2fb-fb_sync-added.patch
