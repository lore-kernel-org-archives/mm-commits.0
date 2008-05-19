From: akpm@linux-foundation.org
Subject: + tridentfb-acceleration-bug-fixes.patch added to -mm tree
Date: Mon, 19 May 2008 14:34:10 -0700
Message-ID: <200805192134.m4JLYAKj021627@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755902AbYESVeN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 May 2008 17:34:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     tridentfb: acceleration bug fixes
has been added to the -mm tree.  Its filename is
     tridentfb-acceleration-bug-fixes.patch

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
Subject: tridentfb: acceleration bug fixes
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch fixes two problems when acceleration is enabled:

 - bit for bitblt direction is corrected
   so scrolling down works as expected on 3DImage chips

 - initialization of acceleration is done later
   this helps with initial console malfuntion (on Blade3D
   chips) well documented here:
   http://marc.info/?l=linux-fbdev-users&m=111386953124478&w=2

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/video/tridentfb.c~tridentfb-acceleration-bug-fixes drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-acceleration-bug-fixes
+++ a/drivers/video/tridentfb.c
@@ -395,7 +395,7 @@ static void image_fill_rect(struct tride
 static void image_copy_rect(struct tridentfb_par *par,
 			    u32 x1, u32 y1, u32 x2, u32 y2, u32 w, u32 h)
 {
-	int direction = 2;
+	int direction = 0x4;
 	u32 s1 = point(x1, y1);
 	u32 s2 = point(x1 + w - 1, y1 + h - 1);
 	u32 d1 = point(x2, y2);
@@ -1075,10 +1075,6 @@ static int tridentfb_set_par(struct fb_i
 	/* enable GE for text acceleration */
 	write3X4(par, GraphEngReg, 0x80);
 
-#ifdef CONFIG_FB_TRIDENT_ACCEL
-	par->init_accel(par, info->var.xres_virtual, bpp);
-#endif
-
 	switch (bpp) {
 	case 8:
 		tmp = 0x00;
@@ -1173,6 +1169,10 @@ static int tridentfb_set_par(struct fb_i
 		set_number_of_lines(par, info->var.yres);
 	info->fix.line_length = info->var.xres_virtual * bpp / 8;
 	set_lwidth(par, info->fix.line_length / 8);
+#ifdef CONFIG_FB_TRIDENT_ACCEL
+	par->init_accel(par, info->var.xres_virtual, bpp);
+#endif
+
 	info->fix.visual = (bpp == 8) ? FB_VISUAL_PSEUDOCOLOR : FB_VISUAL_TRUECOLOR;
 	info->cmap.len = (bpp == 8) ? 256 : 16;
 	debug("exit\n");
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

tridentfb-replace-macros-with-functions.patch
tridentfb-convert-fb_info-into-allocated-one.patch
tridentfb-move-global-pseudo-palette-into-structure.patch
tridentfb-move-global-chip_id-into-structure.patch
tridentfb-move-global-flat-panel-variable-into-structure.patch
tridentfb-convert-is_blade-and-is_xp-macros-into-functions.patch
tridentfb-move-global-acceleration-hooks-into-structure.patch
tridentfb-make-use-of-functions-and-constants-from-the-vgah.patch
tridentfb-fix-timing-calculations.patch
tridentfb-use-mmio-access-for-clock-setting.patch
tridentfb-fix-clock-settings-for-older-trident-96xx-chips.patch
tridentfb-improve-probe-function.patch
tridentfb-improved-register-values-on-tgui-9680.patch
tridentfb-add-tgui-9440-support.patch
tridentfb-fix-unitialized-pseudo_palette.patch
tridentfb-improve-check_var-function.patch
tridentfb-preserve-memory-type-settings.patch
tridentfb-fix-hi-color-modes-for-tgui-9440.patch
tridentfb-add-acceleration-for-tgui-families.patch
tridentfb-acceleration-code-improvements.patch
tridentfb-acceleration-bug-fixes.patch
amifb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
atafb-test-virtual-screen-range-before-subtraction-on-unsigned.patch

