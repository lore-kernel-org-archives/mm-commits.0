From: akpm@linux-foundation.org
Subject: [merged] viafb-split-color-mode-setting-up.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:56:31 -0400
Message-ID: <201003150657.o2F6v4w9016343@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47002 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934519Ab0COG5I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:57:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn, mm-commits@vger.kernel.org


The patch titled
     viafb: split color mode setting up
has been removed from the -mm tree.  Its filename was
     viafb-split-color-mode-setting-up.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb: split color mode setting up
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

This patch splits color mode setting up in seperate functions.  Some
hardware initialization that was previously mixed with it is moved to
viafb_setmode.  As are the calls to the newly created function.  This is
yet another little step towards controlling each IGA on its own.

As this patch really aims too mimic the old behaviour no regressions are
expected.  However I noticed that 8bpp (or 6bpp?) seems actually a bit
broken before and after the patch.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Joseph Chan <JosephChan@via.com.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/hw.c  |   85 +++++++++++++++++++++++---------------
 drivers/video/via/hw.h  |    1 
 drivers/video/via/lcd.c |    2 
 3 files changed, 53 insertions(+), 35 deletions(-)

diff -puN drivers/video/via/hw.c~viafb-split-color-mode-setting-up drivers/video/via/hw.c
--- a/drivers/video/via/hw.c~viafb-split-color-mode-setting-up
+++ a/drivers/video/via/hw.c
@@ -685,6 +685,54 @@ void viafb_set_secondary_pitch(u32 pitch
 	viafb_write_reg_mask(0x71, VIACR, (pitch >> (10 - 7)) & 0x80, 0x80);
 }
 
+void viafb_set_primary_color_depth(u8 depth)
+{
+	u8 value;
+
+	DEBUG_MSG(KERN_DEBUG "viafb_set_primary_color_depth(%d)\n", depth);
+	switch (depth) {
+	case 6:
+		value = 0x00;
+		break;
+	case 16:
+		value = 0x14;
+		break;
+	case 24:
+		value = 0x0C;
+		break;
+	default:
+		printk(KERN_WARNING "viafb_set_primary_color_depth: "
+			"Unsupported depth: %d\n", depth);
+		return;
+	}
+
+	viafb_write_reg_mask(0x15, VIASR, value, 0x1C);
+}
+
+void viafb_set_secondary_color_depth(u8 depth)
+{
+	u8 value;
+
+	DEBUG_MSG(KERN_DEBUG "viafb_set_secondary_color_depth(%d)\n", depth);
+	switch (depth) {
+	case 6:
+		value = 0x00;
+		break;
+	case 16:
+		value = 0x40;
+		break;
+	case 24:
+		value = 0xC0;
+		break;
+	default:
+		printk(KERN_WARNING "viafb_set_secondary_color_depth: "
+			"Unsupported depth: %d\n", depth);
+		return;
+	}
+
+	viafb_write_reg_mask(0x67, VIACR, value, 0xC0);
+}
+
 void viafb_set_output_path(int device, int set_iga, int output_interface)
 {
 	switch (device) {
@@ -1761,35 +1809,6 @@ void viafb_load_crtc_timing(struct displ
 	viafb_lock_crt();
 }
 
-void viafb_set_color_depth(int bpp_byte, int set_iga)
-{
-	if (set_iga == IGA1) {
-		switch (bpp_byte) {
-		case MODE_8BPP:
-			viafb_write_reg_mask(SR15, VIASR, 0x22, 0x7E);
-			break;
-		case MODE_16BPP:
-			viafb_write_reg_mask(SR15, VIASR, 0xB6, 0xFE);
-			break;
-		case MODE_32BPP:
-			viafb_write_reg_mask(SR15, VIASR, 0xAE, 0xFE);
-			break;
-		}
-	} else {
-		switch (bpp_byte) {
-		case MODE_8BPP:
-			viafb_write_reg_mask(CR67, VIACR, 0x00, BIT6 + BIT7);
-			break;
-		case MODE_16BPP:
-			viafb_write_reg_mask(CR67, VIACR, 0x40, BIT6 + BIT7);
-			break;
-		case MODE_32BPP:
-			viafb_write_reg_mask(CR67, VIACR, 0xC0, BIT6 + BIT7);
-			break;
-		}
-	}
-}
-
 void viafb_fill_crtc_timing(struct crt_mode_table *crt_table,
 	struct VideoModeTable *video_mode, int bpp_byte, int set_iga)
 {
@@ -1867,9 +1886,6 @@ void viafb_fill_crtc_timing(struct crt_m
 	    && (viaparinfo->chip_info->gfx_chip_name != UNICHROME_K400))
 		viafb_load_FIFO_reg(set_iga, h_addr, v_addr);
 
-	/* load SR Register About Memory and Color part */
-	viafb_set_color_depth(bpp_byte, set_iga);
-
 	pll_D_N = viafb_get_clk_value(crt_table[index].clk);
 	DEBUG_MSG(KERN_INFO "PLL=%x", pll_D_N);
 	viafb_set_vclock(pll_D_N, set_iga);
@@ -2206,6 +2222,8 @@ int viafb_setmode(struct VideoModeTable 
 		outb(VPIT.SR[i - 1], VIASR + 1);
 	}
 
+	viafb_write_reg_mask(0x15, VIASR, viafbinfo->fix.visual
+		== FB_VISUAL_PSEUDOCOLOR ? 0x22 : 0xA2, 0xA2);
 	viafb_set_iga_path();
 
 	/* Write CRTC */
@@ -2245,6 +2263,9 @@ int viafb_setmode(struct VideoModeTable 
 	viafb_set_primary_pitch(viafbinfo->fix.line_length);
 	viafb_set_secondary_pitch(viafb_dual_fb ? viafbinfo1->fix.line_length
 		: viafbinfo->fix.line_length);
+	viafb_set_primary_color_depth(viaparinfo->depth);
+	viafb_set_secondary_color_depth(viafb_dual_fb ? viaparinfo1->depth
+		: viaparinfo->depth);
 	/* Update Refresh Rate Setting */
 
 	/* Clear On Screen */
diff -puN drivers/video/via/hw.h~viafb-split-color-mode-setting-up drivers/video/via/hw.h
--- a/drivers/video/via/hw.h~viafb-split-color-mode-setting-up
+++ a/drivers/video/via/hw.h
@@ -895,7 +895,6 @@ void viafb_load_fetch_count_reg(int h_ad
 void viafb_write_regx(struct io_reg RegTable[], int ItemNum);
 u32 viafb_get_clk_value(int clk);
 void viafb_load_FIFO_reg(int set_iga, int hor_active, int ver_active);
-void viafb_set_color_depth(int bpp_byte, int set_iga);
 void viafb_set_dpa_gfx(int output_interface, struct GFX_DPA_SETTING\
 					*p_gfx_dpa_setting);
 
diff -puN drivers/video/via/lcd.c~viafb-split-color-mode-setting-up drivers/video/via/lcd.c
--- a/drivers/video/via/lcd.c~viafb-split-color-mode-setting-up
+++ a/drivers/video/via/lcd.c
@@ -1006,8 +1006,6 @@ void viafb_lcd_set_mode(struct crt_mode_
 		if ((viaparinfo->chip_info->gfx_chip_name != UNICHROME_CLE266)
 		    && (viaparinfo->chip_info->gfx_chip_name != UNICHROME_K400))
 			viafb_load_FIFO_reg(set_iga, set_hres, set_vres);
