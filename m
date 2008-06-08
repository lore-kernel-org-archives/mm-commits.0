From: akpm@linux-foundation.org
Subject: - modedb-fix-incorrect-sync-and-vmode-flags-for-cvt-modes.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:47:06 -0700
Message-ID: <200806081947.m58Jl6CS017396@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48427 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755211AbYFHTri (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:47:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     modedb: fix incorrect sync and vmode flags for CVT modes
has been removed from the -mm tree.  Its filename was
     modedb-fix-incorrect-sync-and-vmode-flags-for-cvt-modes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 
+	    memset(&cvt_mode, 0, sizeof(cvt_mode));
 	    cvt_mode.xres = xres;
 	    cvt_mode.yres = yres;
 	    cvt_mode.refresh = (refresh) ? refresh : 60;
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
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
tridentfb-blade3d-clock-fixes.patch
amifb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
atafb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
fbcon-make-logo_height-a-local-variable.patch
uvesafb-change-mode-parameter-to-mode_option.patch
tridentfb-documentation-update.patch
tdfxfb-add-mode_option-module-parameter.patch
vga16fb-source-code-improvement.patch
tdfxfb-remove-ypan-checks-done-by-a-higher-layer.patch
vfb-only-enable-if-explicitly-requested-when-compiled-in.patch
hgafb-convert-to-new-platform-driver-api-bugzilla-9689.patch
skeletonfb-update-to-correct-platform-driver-usage.patch

