From: akpm@linux-foundation.org
Subject: + neofb-reduce-panning-function.patch added to -mm tree
Date: Mon, 11 Aug 2008 13:55:38 -0700
Message-ID: <200808112055.m7BKtcwv020947@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43146 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754208AbYHKU4J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Aug 2008 16:56:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     neofb: reduce panning function
has been added to the -mm tree.  Its filename is
     neofb-reduce-panning-function.patch

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
Subject: neofb: reduce panning function
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Reduce panning function by deleting checks done by higher layer and
folding remaining function into the called one.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/neofb.c |   35 +++++------------------------------
 1 file changed, 5 insertions(+), 30 deletions(-)

diff -puN drivers/video/neofb.c~neofb-reduce-panning-function drivers/video/neofb.c
--- a/drivers/video/neofb.c~neofb-reduce-panning-function
+++ a/drivers/video/neofb.c
@@ -1186,8 +1186,11 @@ static int neofb_set_par(struct fb_info 
 	return 0;
 }
 
-static void neofb_update_start(struct fb_info *info,
-			       struct fb_var_screeninfo *var)
+/*
+ *    Pan or Wrap the Display
+ */
+static int neofb_pan_display(struct fb_var_screeninfo *var,
+			     struct fb_info *info)
 {
 	struct neofb_par *par = info->par;
 	struct vgastate *state = &par->state;
@@ -1216,35 +1219,7 @@ static void neofb_update_start(struct fb
 	vga_wgfx(state->vgabase, 0x0E, (((Base >> 16) & 0x0f) | (oldExtCRTDispAddr & 0xf0)));
 
 	neoLock(state);
-}
-
-/*
- *    Pan or Wrap the Display
- */
-static int neofb_pan_display(struct fb_var_screeninfo *var,
-			     struct fb_info *info)
-{
-	u_int y_bottom;
-
-	y_bottom = var->yoffset;
-
-	if (!(var->vmode & FB_VMODE_YWRAP))
-		y_bottom += var->yres;
-
-	if (var->xoffset > (var->xres_virtual - var->xres))
-		return -EINVAL;
-	if (y_bottom > info->var.yres_virtual)
-		return -EINVAL;
-
-	neofb_update_start(info, var);
-
-	info->var.xoffset = var->xoffset;
-	info->var.yoffset = var->yoffset;
 
-	if (var->vmode & FB_VMODE_YWRAP)
-		info->var.vmode |= FB_VMODE_YWRAP;
-	else
-		info->var.vmode &= ~FB_VMODE_YWRAP;
 	return 0;
 }
 
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
sm501-update-debugging-low-information-messages.patch
matrox-maven-fix-a-broken-error-path.patch
matroxfb-i2c-structure-templates-clean-up.patch
matrox-maven-convert-to-a-new-style-i2c-driver.patch
atmel_lcdfb-set-ypanstep-to-1-and-enable-y-panning-on-at91.patch
atmel_lcdfb-add-board-parameter-specify-framebuffer-memory-size.patch
fbcon-prevent-cursor-disappearance-after-switching-to-512-character-font.patch
linux-next.patch
rtc-m48t59-reduce-structure-m48t59_private.patch
x86-fdiv-bug-detection-fix.patch
fb-convert-lock-unlock_kernel-into-local-fb-mutex.patch
neofb-reduce-panning-function.patch

