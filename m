From: akpm@linux-foundation.org
Subject: - tridentfb-remove-misplaced-enable_mmio.patch removed from -mm tree
Date: Tue, 13 May 2008 14:33:19 -0700
Message-ID: <200805132133.m4DLXJjB000807@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38351 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760783AbYEMVdW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:33:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     tridentfb: remove misplaced enable_mmio()
has been removed from the -mm tree.  Its filename was
     tridentfb-remove-misplaced-enable_mmio.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tridentfb: remove misplaced enable_mmio()
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Remove redundant enable_mmio() call as the mmio mode is enabled in the probe
function earlier.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/video/tridentfb.c~tridentfb-remove-misplaced-enable_mmio drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-remove-misplaced-enable_mmio
+++ a/drivers/video/tridentfb.c
@@ -905,7 +905,6 @@ static int tridentfb_set_par(struct fb_i
 	vblankstart = var->yres;
 	vblankend = vtotal + 2;
 
-	enable_mmio();
 	crtc_unlock();
 	write3CE(CyberControl, 8);
 
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
amifb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
atafb-test-virtual-screen-range-before-subtraction-on-unsigned.patch

