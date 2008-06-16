From: akpm@linux-foundation.org
Subject: - hgafb-resource-management-fix.patch removed from -mm tree
Date: Sun, 15 Jun 2008 23:03:10 -0700
Message-ID: <200806160603.m5G63A3j010578@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57806 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753972AbYFPGDZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jun 2008 02:03:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     hgafb: resource management fix
has been removed from the -mm tree.  Its filename was
     hgafb-resource-management-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hgafb: resource management fix
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Release ports which are requested during detection which are not freed if
there is no hga card.  Otherwise there is a crash during cat /proc/ioports
command.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/hgafb.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff -puN drivers/video/hgafb.c~hgafb-resource-management-fix drivers/video/hgafb.c
--- a/drivers/video/hgafb.c~hgafb-resource-management-fix
+++ a/drivers/video/hgafb.c
@@ -279,7 +279,7 @@ static void hga_blank(int blank_mode)
 
 static int __init hga_card_detect(void)
 {
-	int count=0;
+	int count = 0;
 	void __iomem *p, *q;
 	unsigned short p_save, q_save;
 
@@ -303,20 +303,18 @@ static int __init hga_card_detect(void)
 	writew(0x55aa, p); if (readw(p) == 0x55aa) count++;
 	writew(p_save, p);
 
-	if (count != 2) {
-		return 0;
-	}
+	if (count != 2)
+		goto error;
 
 	/* Ok, there is definitely a card registering at the correct
 	 * memory location, so now we do an I/O port test.
 	 */
 	
-	if (!test_hga_b(0x66, 0x0f)) {	    /* cursor low register */
-		return 0;
-	}
-	if (!test_hga_b(0x99, 0x0f)) {     /* cursor low register */
-		return 0;
-	}
+	if (!test_hga_b(0x66, 0x0f))	    /* cursor low register */
+		goto error;
+
+	if (!test_hga_b(0x99, 0x0f))     /* cursor low register */
+		goto error;
 
 	/* See if the card is a Hercules, by checking whether the vsync
 	 * bit of the status register is changing.  This test lasts for
@@ -331,7 +329,7 @@ static int __init hga_card_detect(void)
 	}
 
 	if (p_save == q_save) 
-		return 0;
+		goto error;
 
 	switch (inb_p(HGA_STATUS_PORT) & 0x70) {
 		case 0x10:
@@ -348,6 +346,12 @@ static int __init hga_card_detect(void)
 			break;
 	}
 	return 1;
+error:
+	if (release_io_ports)
+		release_region(0x3b0, 12);
+	if (release_io_port)
+		release_region(0x3bf, 1);
+	return 0;
 }
 
 /**
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
linux-next.patch
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

