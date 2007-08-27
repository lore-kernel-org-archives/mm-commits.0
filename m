From: akpm@linux-foundation.org
Subject: + atyfb-atyfb-unshare-pseudo_palette.patch added to -mm tree
Date: Mon, 27 Aug 2007 15:23:18 -0700
Message-ID: <200708272223.l7RMNIUr031620@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47626 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752587AbXH0WXa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Aug 2007 18:23:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, adaplas@gmail.com


The patch titled
     atyfb: atyfb: Unshare pseudo_palette
has been added to the -mm tree.  Its filename is
     atyfb-atyfb-unshare-pseudo_palette.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
mips-add-gpio-support-to-the-bcm947xx-platform.patch
mips-gpio-led-driver-for-the-wgt634u-machine.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
move-preempt_notifiers-into-an-always-included-kconfig.patch
atyfb-atyfb-unshare-pseudo_palette.patch
cirrusfb-checkpatchpl-cleanup-ppc-fix.patch
add-missing-newlines-to-some-uses-of-dev_level-messages.patch
