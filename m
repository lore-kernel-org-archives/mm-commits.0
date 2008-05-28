From: akpm@linux-foundation.org
Subject: + fbcon-fix-wrong-vmode-bits-copied-on-console-switch.patch added to -mm tree
Date: Tue, 27 May 2008 20:46:47 -0700
Message-ID: <200805280346.m4S3kll4027475@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41872 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752128AbYE1Dqv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 23:46:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     fbcon: fix wrong vmode bits copied on console switch
has been added to the -mm tree.  Its filename is
     fbcon-fix-wrong-vmode-bits-copied-on-console-switch.patch

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
Subject: fbcon: fix wrong vmode bits copied on console switch
From: Krzysztof Helt <krzysztof.h1@wp.pl>

The interlaced and double line mode bits should not be copied to new
console when the console is switched.  Otherwise, the new console may be
set to incorrect refresh rate.

Also, the x and y offsets does not need to be copied.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/video/console/fbcon.c~fbcon-fix-wrong-vmode-bits-copied-on-console-switch drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbcon-fix-wrong-vmode-bits-copied-on-console-switch
+++ a/drivers/video/console/fbcon.c
@@ -2274,9 +2274,7 @@ static int fbcon_switch(struct vc_data *
 	 * in fb_set_var()
 	 */
 	info->var.activate = var.activate;
-	var.yoffset = info->var.yoffset;
-	var.xoffset = info->var.xoffset;
-	var.vmode = info->var.vmode;
+	var.vmode |= info->var.vmode & ~FB_VMODE_MASK;
 	fb_set_var(info, &var);
 	ops->var = info->var;
 
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
fbcon-fix-wrong-vmode-bits-copied-on-console-switch.patch
tdfxfb-add-mode_option-module-parameter.patch
vga16fb-source-code-improvement.patch

