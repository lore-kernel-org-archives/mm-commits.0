From: akpm@linux-foundation.org
Subject: [folded] cirrusfb-set-mclk-in-one-place-fix.patch removed from -mm tree
Date: Tue, 31 Mar 2009 15:09:58 -0700
Message-ID: <200903312209.n2VM9w26018303@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757301AbZCaWL5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Mar 2009 18:11:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     cirrusfb: fix compilation for Amiga
has been removed from the -mm tree.  Its filename was
     cirrusfb-set-mclk-in-one-place-fix.patch

This patch was dropped because it was folded into cirrusfb-set-mclk-in-one-place.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cirrusfb: fix compilation for Amiga
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Fix compilation for Amiga.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-set-mclk-in-one-place-fix drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-set-mclk-in-one-place-fix
+++ a/drivers/video/cirrusfb.c
@@ -2304,8 +2304,9 @@ static int __devinit cirrusfb_zorro_regi
 	zorro_set_drvdata(z, info);
 
 	/* MCLK select etc. */
-	if (bi->init_sr1f)
-		vga_wseq(cinfo->regbase, CL_SEQR1F, bi->sr1f);
+	if (cirrusfb_board_info[btype].init_sr1f)
+		vga_wseq(cinfo->regbase, CL_SEQR1F,
+			 cirrusfb_board_info[btype].sr1f);
 
 	ret = cirrusfb_register(info);
 	if (!ret)
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
cirrusfb-fix-laguna-chipset-memory-detection-and-clock-setting.patch
cirrusfb-add-laguna-additional-overflow-register.patch
cirrusfb-add-mmio-registers-for-laguna-chipsets.patch
cirrusfb-do-not-calculate-line-length-twice.patch
cirrusfb-use-5-6-5-rgb-for-16bpp-mode.patch
cirrusfb-various-improvements.patch
cirrusfb-laguna-chipset-8bpp-fix.patch
cirrusfb-check_var-improvements.patch
cirrusfb-various-laguna-fixes.patch
cirrusfb-acceleration-improvements.patch
cirrusfb-add-imageblit-function.patch
cirrusfb-fix-error-paths-in-cirrusfb_xxx_register.patch
cirrusfb-gd5446-fixes.patch
cirrusfb-use-24bpp-instead-of-32bpp.patch
cirrusfb-fix-clock-doubling.patch
cirrusfb-add-accelerator-constant.patch
cirrusfb-set-mclk-in-one-place.patch
cirrusfb-set-mclk-in-one-place-fix.patch
cirrusfb-gd5434-aka-sd64-support-fixed.patch
cirrusfb-fix-threshold-register-mask-for-laguna-chips.patch
cirrusfb-fix-interlaced-modes.patch
drivers-video-sgivwfbc-fix-memory-leaks-in-removal-path.patch
tdfxfb-fix-memory-leaks-in-removal-path.patch
tridentfb-fix-memory-leaks-in-removal-path.patch
vfb-fix-memory-leaks-in-removal-path.patch
sstfb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
stifb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
valkyriefb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
68328fb-fix-cmap-memory-leaks.patch
amba-clcd-fix-cmap-memory-leaks.patch
amifb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
asiliantfb-fix-cmap-memory-leaks.patch
asiliantfb-fix-cmap-memory-leaks-fix.patch
remove-cyblafb-driver.patch
nvidiafb-remove-open_lock-mutex.patch
fb-hide-hardware-cursor-in-graphics-mode-mach64.patch
atyfb-speed-up-mach64-cursor.patch
tridentfb-delete-acceleration-kconfig-option.patch
linux-next.patch

