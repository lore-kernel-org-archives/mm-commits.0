From: akpm@linux-foundation.org
Subject: [merged] viafb-some-virtual_xres-handling-fixes.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:56:43 -0400
Message-ID: <201003150657.o2F6vGcV016360@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42259 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934519Ab0COG5U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:57:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn, mm-commits@vger.kernel.org


The patch titled
     viafb: some virtual_xres handling fixes
has been removed from the -mm tree.  Its filename was
     viafb-some-virtual_xres-handling-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb: some virtual_xres handling fixes
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

Do not require the virtual_xres to be aligned as line length is for such
purposes.  Calculate always the smallest line length required.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/viafbdev.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN drivers/video/via/viafbdev.c~viafb-some-virtual_xres-handling-fixes drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-some-virtual_xres-handling-fixes
+++ a/drivers/video/via/viafbdev.c
@@ -107,8 +107,7 @@ static void viafb_update_fix(struct fb_i
 
 	info->fix.visual =
 		bpp == 8 ? FB_VISUAL_PSEUDOCOLOR : FB_VISUAL_TRUECOLOR;
-	info->fix.line_length =
-		((info->var.xres_virtual + 7) & ~7) * bpp / 8;
+	info->fix.line_length = (info->var.xres_virtual * bpp / 8 + 7) & ~7;
 }
 
 static void viafb_setup_fixinfo(struct fb_fix_screeninfo *fix,
@@ -148,7 +147,7 @@ static int viafb_check_var(struct fb_var
 	int htotal, vtotal, depth;
 	struct VideoModeTable *vmode_entry;
 	struct viafb_par *ppar = info->par;
-	u32 long_refresh;
+	u32 long_refresh, line;
 
 	DEBUG_MSG(KERN_INFO "viafb_check_var!\n");
 	/* Sanity check */
@@ -180,11 +179,8 @@ static int viafb_check_var(struct fb_var
 		depth = 24;
 
 	viafb_fill_var_color_info(var, depth);
-	if ((var->xres_virtual * (var->bits_per_pixel >> 3)) & 0x1F)
-		/*32 pixel alignment */
-		var->xres_virtual = (var->xres_virtual + 31) & ~31;
-	if (var->xres_virtual * var->yres_virtual * var->bits_per_pixel / 8 >
-		ppar->memsize)
+	line = (var->xres_virtual * var->bits_per_pixel / 8 + 7) & ~7;
+	if (line * var->yres_virtual > ppar->memsize)
 		return -EINVAL;
 
 	/* Based on var passed in to calculate the refresh,
_

Patches currently in -mm which might be from FlorianSchandinat@gmx.de are

origin.patch

