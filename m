From: akpm@linux-foundation.org
Subject: + tdfxfb-remove-ypan-checks-done-by-a-higher-layer.patch added to -mm tree
Date: Wed, 28 May 2008 14:06:01 -0700
Message-ID: <200805282106.m4SL611Y032565@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33979 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752862AbYE1VGD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 May 2008 17:06:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     tdfxfb: remove ypan checks done by a higher layer
has been added to the -mm tree.  Its filename is
     tdfxfb-remove-ypan-checks-done-by-a-higher-layer.patch

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
Subject: tdfxfb: remove ypan checks done by a higher layer
From: Krzysztof Helt <krzysztof.h1@wp.pl>

These checks and assignments are done by a higher layer so remove them
from the driver.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tdfxfb.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN drivers/video/tdfxfb.c~tdfxfb-remove-ypan-checks-done-by-a-higher-layer drivers/video/tdfxfb.c
--- a/drivers/video/tdfxfb.c~tdfxfb-remove-ypan-checks-done-by-a-higher-layer
+++ a/drivers/video/tdfxfb.c
@@ -836,16 +836,12 @@ static int tdfxfb_pan_display(struct fb_
 	struct tdfx_par *par = info->par;
 	u32 addr = var->yoffset * info->fix.line_length;
 
-	if (nopan || var->xoffset || (var->yoffset > var->yres_virtual))
-		return -EINVAL;
-	if ((var->yoffset + var->yres > var->yres_virtual && nowrap))
+	if (nopan || var->xoffset)
 		return -EINVAL;
 
 	banshee_make_room(par, 1);
 	tdfx_outl(par, VIDDESKSTART, addr);
 
-	info->var.xoffset = var->xoffset;
-	info->var.yoffset = var->yoffset;
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
amifb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
atafb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
fbcon-make-logo_height-a-local-variable.patch
uvesafb-change-mode-parameter-to-mode_option.patch
tridentfb-documentation-update.patch
tdfxfb-add-mode_option-module-parameter.patch
vga16fb-source-code-improvement.patch
tdfxfb-remove-ypan-checks-done-by-a-higher-layer.patch

