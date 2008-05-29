From: akpm@linux-foundation.org
Subject: + tridentfb-y-panning-fixes.patch added to -mm tree
Date: Thu, 29 May 2008 13:02:22 -0700
Message-ID: <200805292002.m4TK2Ogf019627@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50431 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753388AbYE2UDQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 May 2008 16:03:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     tridentfb: y-panning fixes
has been added to the -mm tree.  Its filename is
     tridentfb-y-panning-fixes.patch

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
Subject: tridentfb: y-panning fixes
From: Krzysztof Helt <krzysztof.h1@wp.pl>

The Trident cards uses only 20-bit address of screen start in double
words.  This allows addressing for only 4MB of video memory so check this.

Also remove some redundant checks and assignments.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/video/tridentfb.c~tridentfb-y-panning-fixes drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-y-panning-fixes
+++ a/drivers/video/tridentfb.c
@@ -870,8 +870,10 @@ static int tridentfb_check_var(struct fb
 		line_length = var->xres_virtual * bpp / 8;
 	}
 
-	if (var->yres > var->yres_virtual)
-		var->yres_virtual = var->yres;
+	/* datasheet specifies how to set panning only up to 4 MB */
+	if (line_length * (var->yres_virtual - var->yres) > (4 << 20))
+		var->yres_virtual = ((4 << 20) / line_length) + var->yres;
+
 	if (line_length * var->yres_virtual > info->fix.smem_len)
 		return -EINVAL;
 
@@ -944,8 +946,6 @@ static int tridentfb_pan_display(struct 
 	debug("enter\n");
 	offset = (var->xoffset + (var->yoffset * var->xres_virtual))
 		* var->bits_per_pixel / 32;
-	info->var.xoffset = var->xoffset;
-	info->var.yoffset = var->yoffset;
 	set_screen_start(par, offset);
 	debug("exit\n");
 	return 0;
@@ -1225,7 +1225,6 @@ static int tridentfb_setcolreg(unsigned 
 				((blue & 0xFF00) >> 8);
 	}
 
-/* 	debug("exit\n"); */
 	return 0;
 }
 
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

modedb-fix-incorrect-sync-and-vmode-flags-for-cvt-modes.patch
fbcon-fix-wrong-vmode-bits-copied-on-console-switch.patch
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
tridentfb-various-pixclock-and-timing-improvements.patch
tridentfb-acceleration-constants-change.patch
tridentfb-source-code-improvements.patch
tridentfb-fix-console-freeze-when-switching-from-x11.patch
tridentfb-fix-224-color-logo-at-8-bpp.patch
tridentfb-y-panning-fixes.patch
amifb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
atafb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
fbcon-make-logo_height-a-local-variable.patch
uvesafb-change-mode-parameter-to-mode_option.patch
tridentfb-documentation-update.patch
tdfxfb-add-mode_option-module-parameter.patch
vga16fb-source-code-improvement.patch
tdfxfb-remove-ypan-checks-done-by-a-higher-layer.patch

