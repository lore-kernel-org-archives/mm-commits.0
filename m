From: akpm@linux-foundation.org
Subject: + modedb-fix-incorrect-sync-and-vmode-flags-for-cvt-modes.patch added to -mm tree
Date: Wed, 28 May 2008 13:56:38 -0700
Message-ID: <200805282056.m4SKucdv032195@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44439 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752738AbYE1U5A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 May 2008 16:57:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     modedb: fix incorrect sync and vmode flags for CVT modes
has been added to the -mm tree.  Its filename is
     modedb-fix-incorrect-sync-and-vmode-flags-for-cvt-modes.patch

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
Subject: modedb: fix incorrect sync and vmode flags for CVT modes
From: Krzysztof Helt <krzysztof.h1@wp.pl>

The temporary structure for calculated CVT mode is not initialized.  Few
fields have only bits or-ed or and-ed so they may be left in incorrect
(random) state.

Testing of the tridentfb seems like a good exercise for the fbdev layer.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/modedb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/modedb.c~modedb-fix-incorrect-sync-and-vmode-flags-for-cvt-modes drivers/video/modedb.c
--- a/drivers/video/modedb.c~modedb-fix-incorrect-sync-and-vmode-flags-for-cvt-modes
+++ a/drivers/video/modedb.c
@@ -590,6 +590,7 @@ done:
 		    "", (margins) ? " with margins" : "", (interlace) ?
 		    " interlaced" : "");
 
+	    memset(&cvt_mode, 0, sizeof(struct fb_videomode));
 	    cvt_mode.xres = xres;
 	    cvt_mode.yres = yres;
 	    cvt_mode.refresh = (refresh) ? refresh : 60;
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

