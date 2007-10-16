From: akpm@linux-foundation.org
Subject: - atyfb-atyfb-unshare-pseudo_palette.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:43:31 -0700
Message-ID: <200710162043.l9GKhVfu016056@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46828 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935801AbXJPVHv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:07:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     atyfb: atyfb: Unshare pseudo_palette
has been removed from the -mm tree.  Its filename was
     atyfb-atyfb-unshare-pseudo_palette.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: atyfb: atyfb: Unshare pseudo_palette
From: Geert Uytterhoeven <geert@linux-m68k.org>

atyfb: Move the pseudo palette into the card-specific atyfb_par, so it's no
longer shared among multiple cards

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/atyfb.h      |    1 +
 drivers/video/aty/atyfb_base.c |    4 +---
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/video/aty/atyfb.h~atyfb-atyfb-unshare-pseudo_palette drivers/video/aty/atyfb.h
--- a/drivers/video/aty/atyfb.h~atyfb-atyfb-unshare-pseudo_palette
+++ a/drivers/video/aty/atyfb.h
@@ -126,6 +126,7 @@ union aty_pll {
      */
 
 struct atyfb_par {
+	u32 pseudo_palette[16];
 	struct { u8 red, green, blue; } palette[256];
 	const struct aty_dac_ops *dac_ops;
 	const struct aty_pll_ops *pll_ops;
diff -puN drivers/video/aty/atyfb_base.c~atyfb-atyfb-unshare-pseudo_palette drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~atyfb-atyfb-unshare-pseudo_palette
+++ a/drivers/video/aty/atyfb_base.c
@@ -541,8 +541,6 @@ static char ram_off[] __devinitdata = "O
 #endif /* CONFIG_FB_ATY_CT */
 
 
-static u32 pseudo_palette[16];
-
 #ifdef CONFIG_FB_ATY_GX
 static char *aty_gx_ram[8] __devinitdata = {
 	ram_dram, ram_vram, ram_vram, ram_dram,
@@ -2577,7 +2575,7 @@ static int __devinit aty_init(struct fb_
 #endif
 
 	info->fbops = &atyfb_ops;
-	info->pseudo_palette = pseudo_palette;
+	info->pseudo_palette = par->pseudo_palette;
 	info->flags = FBINFO_DEFAULT           |
 	              FBINFO_HWACCEL_IMAGEBLIT |
 	              FBINFO_HWACCEL_FILLRECT  |
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
move-preempt_notifiers-into-an-always-included-kconfig.patch
remove-final-traces-of-long-deprecated-ramdisk-kernel.patch
add-missing-newlines-to-some-uses-of-dev_level-messages.patch
bitops-introduce-lock-ops.patch
