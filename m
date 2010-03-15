From: akpm@linux-foundation.org
Subject: [merged] viafb-remove-dead-code-due-to-iga1_iga2.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:56:34 -0400
Message-ID: <201003150657.o2F6v74U016351@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33565 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934519Ab0COG5M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:57:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn, mm-commits@vger.kernel.org


The patch titled
     viafb: remove dead code due to IGA1_IGA2
has been removed from the -mm tree.  Its filename was
     viafb-remove-dead-code-due-to-iga1_iga2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb: remove dead code due to IGA1_IGA2
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

Some code depended on IGA1_IGA2 which was never set (at least with the
symbolic name).  Remove this dead code although it might one day be useful
to get a hint on how some things might work.  However as this is dead it
is likely full of bugs and would prevent a clean structure (as it has some
very strange things).

Dead code -> no regressions, at least if VIA doesn't do anything very ugly.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Joseph Chan <JosephChan@via.com.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/hw.c    |   22 -
 drivers/video/via/lcd.c   |  562 ------------------------------------
 drivers/video/via/share.h |    1 
 3 files changed, 11 insertions(+), 574 deletions(-)

diff -puN drivers/video/via/hw.c~viafb-remove-dead-code-due-to-iga1_iga2 drivers/video/via/hw.c
--- a/drivers/video/via/hw.c~viafb-remove-dead-code-due-to-iga1_iga2
+++ a/drivers/video/via/hw.c
@@ -757,11 +757,8 @@ static void set_crt_output_path(int set_
 		viafb_write_reg_mask(SR16, VIASR, 0x00, BIT6);
 		break;
 	case IGA2:
-	case IGA1_IGA2:
 		viafb_write_reg_mask(CR6A, VIACR, 0xC0, BIT6 + BIT7);
 		viafb_write_reg_mask(SR16, VIASR, 0x40, BIT6);
-		if (set_iga == IGA1_IGA2)
-			viafb_write_reg_mask(CR6B, VIACR, 0x08, BIT3);
 		break;
 	}
 }
@@ -951,13 +948,6 @@ static void set_lcd_output_path(int set_
 
 		enable_second_display_channel();
 		break;
-
-	case IGA1_IGA2:
-		viafb_write_reg_mask(CR6B, VIACR, 0x08, BIT3);
-		viafb_write_reg_mask(CR6A, VIACR, 0x08, BIT3);
-
-		disable_second_display_channel();
-		break;
 	}
 
 	switch (output_interface) {
@@ -1125,15 +1115,13 @@ void viafb_load_fetch_count_reg(int h_ad
 	struct io_register *reg = NULL;
 
 	switch (set_iga) {
-	case IGA1_IGA2:
 	case IGA1:
 		reg_value = IGA1_FETCH_COUNT_FORMULA(h_addr, bpp_byte);
 		viafb_load_reg_num = fetch_count_reg.
 			iga1_fetch_count_reg.reg_num;
 		reg = fetch_count_reg.iga1_fetch_count_reg.reg;
 		viafb_load_reg(reg_value, viafb_load_reg_num, reg, VIASR);
-		if (set_iga == IGA1)
-			break;
+		break;
 	case IGA2:
 		reg_value = IGA2_FETCH_COUNT_FORMULA(h_addr, bpp_byte);
 		viafb_load_reg_num = fetch_count_reg.
@@ -1503,7 +1491,7 @@ void viafb_set_vclock(u32 CLK, int set_i
 	/* H.W. Reset : ON */
 	viafb_write_reg_mask(CR17, VIACR, 0x00, BIT7);
 
-	if ((set_iga == IGA1) || (set_iga == IGA1_IGA2)) {
+	if (set_iga == IGA1) {
 		/* Change D,N FOR VCLK */
 		switch (viaparinfo->chip_info->gfx_chip_name) {
 		case UNICHROME_CLE266:
@@ -1532,7 +1520,7 @@ void viafb_set_vclock(u32 CLK, int set_i
 		}
 	}
 
-	if ((set_iga == IGA2) || (set_iga == IGA1_IGA2)) {
+	if (set_iga == IGA2) {
 		/* Change D,N FOR LCK */
 		switch (viaparinfo->chip_info->gfx_chip_name) {
 		case UNICHROME_CLE266:
@@ -1561,12 +1549,12 @@ void viafb_set_vclock(u32 CLK, int set_i
 	viafb_write_reg_mask(CR17, VIACR, 0x80, BIT7);
 
 	/* Reset PLL */
-	if ((set_iga == IGA1) || (set_iga == IGA1_IGA2)) {
+	if (set_iga == IGA1) {
 		viafb_write_reg_mask(SR40, VIASR, 0x02, BIT1);
 		viafb_write_reg_mask(SR40, VIASR, 0x00, BIT1);
 	}
 
-	if ((set_iga == IGA2) || (set_iga == IGA1_IGA2)) {
+	if (set_iga == IGA2) {
 		viafb_write_reg_mask(SR40, VIASR, 0x01, BIT0);
 		viafb_write_reg_mask(SR40, VIASR, 0x00, BIT0);
 	}
diff -puN drivers/video/via/lcd.c~viafb-remove-dead-code-due-to-iga1_iga2 drivers/video/via/lcd.c
--- a/drivers/video/via/lcd.c~viafb-remove-dead-code-due-to-iga1_iga2
+++ a/drivers/video/via/lcd.c
@@ -24,26 +24,6 @@
 
 #define viafb_compact_res(x, y) (((x)<<16)|(y))
 
-static struct iga2_shadow_crtc_timing iga2_shadow_crtc_reg = {
-	/* IGA2 Shadow Horizontal Total */
-	{IGA2_SHADOW_HOR_TOTAL_REG_NUM, {{CR6D, 0, 7}, {CR71, 3, 3} } },
-	/* IGA2 Shadow Horizontal Blank End */
-	{IGA2_SHADOW_HOR_BLANK_END_REG_NUM, {{CR6E, 0, 7} } },
-	/* IGA2 Shadow Vertical Total */
-	{IGA2_SHADOW_VER_TOTAL_REG_NUM, {{CR6F, 0, 7}, {CR71, 0, 2} } },
-	/* IGA2 Shadow Vertical Addressable Video */
-	{IGA2_SHADOW_VER_ADDR_REG_NUM, {{CR70, 0, 7}, {CR71, 4, 6} } },
-	/* IGA2 Shadow Vertical Blank Start */
-	{IGA2_SHADOW_VER_BLANK_START_REG_NUM,
-	 {{CR72, 0, 7}, {CR74, 4, 6} } },
-	/* IGA2 Shadow Vertical Blank End */
-	{IGA2_SHADOW_VER_BLANK_END_REG_NUM, {{CR73, 0, 7}, {CR74, 0, 2} } },
-	/* IGA2 Shadow Vertical Sync Start */
-	{IGA2_SHADOW_VER_SYNC_START_REG_NUM, {{CR75, 0, 7}, {CR76, 4, 6} } },
-	/* IGA2 Shadow Vertical Sync End */
-	{IGA2_SHADOW_VER_SYNC_END_REG_NUM, {{CR76, 0, 3} } }
-};
-
 static struct _lcd_scaling_factor lcd_scaling_factor = {
 	/* LCD Horizontal Scaling Factor Register */
 	{LCD_HOR_SCALING_FACTOR_REG_NUM,
@@ -65,12 +45,6 @@ static void fp_id_to_vindex(int panel_id
 static int lvds_register_read(int index);
 static void load_lcd_scaling(int set_hres, int set_vres, int panel_hres,
 		      int panel_vres);
-static void load_lcd_k400_patch_tbl(int set_hres, int set_vres,
-	int panel_id);
-static void load_lcd_p880_patch_tbl(int set_hres, int set_vres,
-	int panel_id);
-static void load_lcd_patch_regs(int set_hres, int set_vres,
-	int panel_id, int set_iga);
 static void via_pitch_alignment_patch_lcd(
 	struct lvds_setting_information *plvds_setting_info,
 				   struct lvds_chip_information
@@ -100,8 +74,6 @@ static void check_diport_of_integrated_l
 static struct display_timing lcd_centering_timging(struct display_timing
 					    mode_crt_reg,
 					   struct display_timing panel_crt_reg);
-static void load_crtc_shadow_timing(struct display_timing mode_timing,
-			     struct display_timing panel_timing);
 static void viafb_load_scaling_factor_for_p4m900(int set_hres,
 	int set_vres, int panel_hres, int panel_vres);
 
@@ -543,277 +515,6 @@ static void load_lcd_scaling(int set_hre
 	}
 }
 
-static void load_lcd_k400_patch_tbl(int set_hres, int set_vres,
-	int panel_id)
-{
-	u32 compact_mode = viafb_compact_res(set_hres, set_vres);
-	int reg_num = 0;
-	struct io_reg *lcd_patch_reg = NULL;
-
-	switch (panel_id) {
-		/* LCD 800x600 */
-	case LCD_PANEL_ID1_800X600:
-		switch (compact_mode) {
-		case viafb_compact_res(640, 400):
-		case viafb_compact_res(640, 480):
-			reg_num = NUM_TOTAL_K400_LCD_RES_6X4_8X6;
-			lcd_patch_reg = K400_LCD_RES_6X4_8X6;
-			break;
-		case viafb_compact_res(720, 480):
-		case viafb_compact_res(720, 576):
-			reg_num = NUM_TOTAL_K400_LCD_RES_7X4_8X6;
-			lcd_patch_reg = K400_LCD_RES_7X4_8X6;
-			break;
-		}
-		break;
-
-		/* LCD 1024x768 */
-	case LCD_PANEL_ID2_1024X768:
-		switch (compact_mode) {
-		case viafb_compact_res(640, 400):
-		case viafb_compact_res(640, 480):
-			reg_num = NUM_TOTAL_K400_LCD_RES_6X4_10X7;
-			lcd_patch_reg = K400_LCD_RES_6X4_10X7;
-			break;
-		case viafb_compact_res(720, 480):
-		case viafb_compact_res(720, 576):
-			reg_num = NUM_TOTAL_K400_LCD_RES_7X4_10X7;
-			lcd_patch_reg = K400_LCD_RES_7X4_10X7;
-			break;
-		case viafb_compact_res(800, 600):
-			reg_num = NUM_TOTAL_K400_LCD_RES_8X6_10X7;
-			lcd_patch_reg = K400_LCD_RES_8X6_10X7;
-			break;
-		}
-		break;
-
-		/* LCD 1280x1024 */
-	case LCD_PANEL_ID4_1280X1024:
-		switch (compact_mode) {
-		case viafb_compact_res(640, 400):
-		case viafb_compact_res(640, 480):
-			reg_num = NUM_TOTAL_K400_LCD_RES_6X4_12X10;
-			lcd_patch_reg = K400_LCD_RES_6X4_12X10;
-			break;
-		case viafb_compact_res(720, 480):
-		case viafb_compact_res(720, 576):
-			reg_num = NUM_TOTAL_K400_LCD_RES_7X4_12X10;
-			lcd_patch_reg = K400_LCD_RES_7X4_12X10;
-			break;
-		case viafb_compact_res(800, 600):
-			reg_num = NUM_TOTAL_K400_LCD_RES_8X6_12X10;
-			lcd_patch_reg = K400_LCD_RES_8X6_12X10;
-			break;
-		case viafb_compact_res(1024, 768):
-			reg_num = NUM_TOTAL_K400_LCD_RES_10X7_12X10;
-			lcd_patch_reg = K400_LCD_RES_10X7_12X10;
-			break;
-
-		}
-		break;
-
-		/* LCD 1400x1050 */
-	case LCD_PANEL_ID5_1400X1050:
-		switch (compact_mode) {
-		case viafb_compact_res(640, 480):
-			reg_num = NUM_TOTAL_K400_LCD_RES_6X4_14X10;
-			lcd_patch_reg = K400_LCD_RES_6X4_14X10;
-			break;
-		case viafb_compact_res(800, 600):
-			reg_num = NUM_TOTAL_K400_LCD_RES_8X6_14X10;
-			lcd_patch_reg = K400_LCD_RES_8X6_14X10;
-			break;
-		case viafb_compact_res(1024, 768):
-			reg_num = NUM_TOTAL_K400_LCD_RES_10X7_14X10;
-			lcd_patch_reg = K400_LCD_RES_10X7_14X10;
-			break;
-		case viafb_compact_res(1280, 768):
-		case viafb_compact_res(1280, 800):
-		case viafb_compact_res(1280, 960):
-		case viafb_compact_res(1280, 1024):
-			reg_num = NUM_TOTAL_K400_LCD_RES_12X10_14X10;
-			lcd_patch_reg = K400_LCD_RES_12X10_14X10;
-			break;
-		}
-		break;
-
-		/* LCD 1600x1200 */
-	case LCD_PANEL_ID6_1600X1200:
-		switch (compact_mode) {
-		case viafb_compact_res(640, 400):
-		case viafb_compact_res(640, 480):
-			reg_num = NUM_TOTAL_K400_LCD_RES_6X4_16X12;
-			lcd_patch_reg = K400_LCD_RES_6X4_16X12;
-			break;
-		case viafb_compact_res(720, 480):
-		case viafb_compact_res(720, 576):
-			reg_num = NUM_TOTAL_K400_LCD_RES_7X4_16X12;
-			lcd_patch_reg = K400_LCD_RES_7X4_16X12;
-			break;
-		case viafb_compact_res(800, 600):
-			reg_num = NUM_TOTAL_K400_LCD_RES_8X6_16X12;
-			lcd_patch_reg = K400_LCD_RES_8X6_16X12;
-			break;
-		case viafb_compact_res(1024, 768):
-			reg_num = NUM_TOTAL_K400_LCD_RES_10X7_16X12;
-			lcd_patch_reg = K400_LCD_RES_10X7_16X12;
-			break;
-		case viafb_compact_res(1280, 768):
-		case viafb_compact_res(1280, 800):
-		case viafb_compact_res(1280, 960):
-		case viafb_compact_res(1280, 1024):
-			reg_num = NUM_TOTAL_K400_LCD_RES_12X10_16X12;
-			lcd_patch_reg = K400_LCD_RES_12X10_16X12;
-			break;
-		}
-		break;
-
-		/* LCD 1366x768 */
-	case LCD_PANEL_ID7_1366X768:
-		switch (compact_mode) {
-		case viafb_compact_res(640, 480):
-			reg_num = NUM_TOTAL_K400_LCD_RES_6X4_1366X7;
-			lcd_patch_reg = K400_LCD_RES_6X4_1366X7;
-			break;
-		case viafb_compact_res(720, 480):
-		case viafb_compact_res(720, 576):
-			reg_num = NUM_TOTAL_K400_LCD_RES_7X4_1366X7;
-			lcd_patch_reg = K400_LCD_RES_7X4_1366X7;
-			break;
-		case viafb_compact_res(800, 600):
-			reg_num = NUM_TOTAL_K400_LCD_RES_8X6_1366X7;
-			lcd_patch_reg = K400_LCD_RES_8X6_1366X7;
-			break;
-		case viafb_compact_res(1024, 768):
-			reg_num = NUM_TOTAL_K400_LCD_RES_10X7_1366X7;
-			lcd_patch_reg = K400_LCD_RES_10X7_1366X7;
-			break;
-		case viafb_compact_res(1280, 768):
-		case viafb_compact_res(1280, 800):
-		case viafb_compact_res(1280, 960):
-		case viafb_compact_res(1280, 1024):
-			reg_num = NUM_TOTAL_K400_LCD_RES_12X10_1366X7;
-			lcd_patch_reg = K400_LCD_RES_12X10_1366X7;
-			break;
-		}
-		break;
-
-		/* LCD 1360x768 */
-	case LCD_PANEL_IDB_1360X768:
-		break;
-	}
-	if (reg_num != 0) {
-		/* H.W. Reset : ON */
-		viafb_write_reg_mask(CR17, VIACR, 0x00, BIT7);
-
-		viafb_write_regx(lcd_patch_reg, reg_num);
-
-		/* H.W. Reset : OFF */
-		viafb_write_reg_mask(CR17, VIACR, 0x80, BIT7);
-
-		/* Reset PLL */
-		viafb_write_reg_mask(SR40, VIASR, 0x02, BIT1);
-		viafb_write_reg_mask(SR40, VIASR, 0x00, BIT1);
-
-		/* Fire! */
-		outb(inb(VIARMisc) | (BIT2 + BIT3), VIAWMisc);
-	}
-}
-
-static void load_lcd_p880_patch_tbl(int set_hres, int set_vres,
-	int panel_id)
-{
-	u32 compact_mode = viafb_compact_res(set_hres, set_vres);
-	int reg_num = 0;
-	struct io_reg *lcd_patch_reg = NULL;
-
-	switch (panel_id) {
-	case LCD_PANEL_ID5_1400X1050:
-		switch (compact_mode) {
-		case viafb_compact_res(640, 480):
-			reg_num = NUM_TOTAL_P880_LCD_RES_6X4_14X10;
-			lcd_patch_reg = P880_LCD_RES_6X4_14X10;
-			break;
-		case viafb_compact_res(800, 600):
-			reg_num = NUM_TOTAL_P880_LCD_RES_8X6_14X10;
-			lcd_patch_reg = P880_LCD_RES_8X6_14X10;
-			break;
-		}
-		break;
-	case LCD_PANEL_ID6_1600X1200:
-		switch (compact_mode) {
-		case viafb_compact_res(640, 400):
-		case viafb_compact_res(640, 480):
-			reg_num = NUM_TOTAL_P880_LCD_RES_6X4_16X12;
-			lcd_patch_reg = P880_LCD_RES_6X4_16X12;
-			break;
-		case viafb_compact_res(720, 480):
-		case viafb_compact_res(720, 576):
-			reg_num = NUM_TOTAL_P880_LCD_RES_7X4_16X12;
-			lcd_patch_reg = P880_LCD_RES_7X4_16X12;
-			break;
-		case viafb_compact_res(800, 600):
-			reg_num = NUM_TOTAL_P880_LCD_RES_8X6_16X12;
-			lcd_patch_reg = P880_LCD_RES_8X6_16X12;
-			break;
-		case viafb_compact_res(1024, 768):
-			reg_num = NUM_TOTAL_P880_LCD_RES_10X7_16X12;
-			lcd_patch_reg = P880_LCD_RES_10X7_16X12;
-			break;
-		case viafb_compact_res(1280, 768):
-		case viafb_compact_res(1280, 960):
-		case viafb_compact_res(1280, 1024):
-			reg_num = NUM_TOTAL_P880_LCD_RES_12X10_16X12;
-			lcd_patch_reg = P880_LCD_RES_12X10_16X12;
-			break;
-		}
-		break;
-
-	}
-	if (reg_num != 0) {
-		/* H.W. Reset : ON */
-		viafb_write_reg_mask(CR17, VIACR, 0x00, BIT7);
-
-		viafb_write_regx(lcd_patch_reg, reg_num);
-
-		/* H.W. Reset : OFF */
-		viafb_write_reg_mask(CR17, VIACR, 0x80, BIT7);
-
-		/* Reset PLL */
-		viafb_write_reg_mask(SR40, VIASR, 0x02, BIT1);
-		viafb_write_reg_mask(SR40, VIASR, 0x00, BIT1);
-
-		/* Fire! */
-		outb(inb(VIARMisc) | (BIT2 + BIT3), VIAWMisc);
-	}
-}
-
-static void load_lcd_patch_regs(int set_hres, int set_vres,
-	int panel_id, int set_iga)
-{
-	viafb_unlock_crt();
-
-	/* Patch for simultaneous & Expansion */
-	if ((set_iga == IGA1_IGA2) &&
-		(viaparinfo->lvds_setting_info->display_method ==
-	    LCD_EXPANDSION)) {
-		switch (viaparinfo->chip_info->gfx_chip_name) {
-		case UNICHROME_CLE266:
-		case UNICHROME_K400:
-			load_lcd_k400_patch_tbl(set_hres, set_vres, panel_id);
-			break;
-		case UNICHROME_K800:
-			break;
-		case UNICHROME_PM800:
-		case UNICHROME_CN700:
-		case UNICHROME_CX700:
-			load_lcd_p880_patch_tbl(set_hres, set_vres, panel_id);
-		}
-	}
-
-	viafb_lock_crt();
-}
-
 static void via_pitch_alignment_patch_lcd(
 	struct lvds_setting_information *plvds_setting_info,
 				   struct lvds_chip_information
@@ -919,7 +620,6 @@ void viafb_lcd_set_mode(struct crt_mode_
 	int panel_hres = plvds_setting_info->lcd_panel_hres;
 	int panel_vres = plvds_setting_info->lcd_panel_vres;
 	u32 pll_D_N;
-	int offset;
 	struct display_timing mode_crt_reg, panel_crt_reg;
 	struct crt_mode_table *panel_crt_table = NULL;
 	struct VideoModeTable *vmode_tbl = viafb_get_mode(panel_hres,
@@ -961,52 +661,12 @@ void viafb_lcd_set_mode(struct crt_mode_
 		}
 	}
 
-	if (set_iga == IGA1_IGA2) {
-		load_crtc_shadow_timing(mode_crt_reg, panel_crt_reg);
-		/* Fill shadow registers */
-
-		switch (plvds_setting_info->lcd_panel_id) {
-		case LCD_PANEL_ID0_640X480:
-			offset = 80;
-			break;
-		case LCD_PANEL_ID1_800X600:
-		case LCD_PANEL_IDA_800X480:
-			offset = 110;
-			break;
-		case LCD_PANEL_ID2_1024X768:
-			offset = 150;
-			break;
-		case LCD_PANEL_ID3_1280X768:
-		case LCD_PANEL_ID4_1280X1024:
-		case LCD_PANEL_ID5_1400X1050:
-		case LCD_PANEL_ID9_1280X800:
-			offset = 190;
-			break;
-		case LCD_PANEL_ID6_1600X1200:
-			offset = 250;
-			break;
-		case LCD_PANEL_ID7_1366X768:
-		case LCD_PANEL_IDB_1360X768:
-			offset = 212;
-			break;
-		default:
-			offset = 140;
-			break;
-		}
+	/* Fetch count for IGA2 only */
+	viafb_load_fetch_count_reg(set_hres, mode_bpp / 8, set_iga);
 
-		/* Offset for simultaneous */
-		viafb_set_secondary_pitch(offset << 3);
-		DEBUG_MSG(KERN_INFO "viafb_load_reg!!\n");
-		viafb_load_fetch_count_reg(set_hres, 4, IGA2);
-		/* Fetch count for simultaneous */
-	} else {		/* SAMM */
-		/* Fetch count for IGA2 only */
-		viafb_load_fetch_count_reg(set_hres, mode_bpp / 8, set_iga);
-
-		if ((viaparinfo->chip_info->gfx_chip_name != UNICHROME_CLE266)
-		    && (viaparinfo->chip_info->gfx_chip_name != UNICHROME_K400))
-			viafb_load_FIFO_reg(set_iga, set_hres, set_vres);
-	}
+	if ((viaparinfo->chip_info->gfx_chip_name != UNICHROME_CLE266)
+		&& (viaparinfo->chip_info->gfx_chip_name != UNICHROME_K400))
+		viafb_load_FIFO_reg(set_iga, set_hres, set_vres);
 
 	fill_lcd_format();
 
@@ -1023,11 +683,6 @@ void viafb_lcd_set_mode(struct crt_mode_
 	    || (UNICHROME_K8M890 == viaparinfo->chip_info->gfx_chip_name))
 		viafb_write_reg_mask(CR6A, VIACR, 0x01, BIT0);
 
-	load_lcd_patch_regs(set_hres, set_vres,
-			    plvds_setting_info->lcd_panel_id, set_iga);
-
-	DEBUG_MSG(KERN_INFO "load_lcd_patch_regs!!\n");
-
 	/* Patch for non 32bit alignment mode */
 	via_pitch_alignment_patch_lcd(plvds_setting_info, plvds_chip_info);
 }
@@ -1241,8 +896,7 @@ void viafb_lcd_enable(void)
 		viafb_write_reg_mask(CR6A, VIACR, 0x48, 0x48);
 	}
 
-	if ((viaparinfo->lvds_setting_info->iga_path == IGA1)
-	    || (viaparinfo->lvds_setting_info->iga_path == IGA1_IGA2)) {
+	if (viaparinfo->lvds_setting_info->iga_path == IGA1) {
 		/* CRT path set to IGA2    */
 		viafb_write_reg_mask(SR16, VIASR, 0x40, 0x40);
 		/* IGA2 path disabled      */
@@ -1434,210 +1088,6 @@ static struct display_timing lcd_centeri
 	return crt_reg;
 }
 
-static void load_crtc_shadow_timing(struct display_timing mode_timing,
-			     struct display_timing panel_timing)
-{
-	struct io_register *reg = NULL;
-	int i;
-	int viafb_load_reg_Num = 0;
-	int reg_value = 0;
-
-	if (viaparinfo->lvds_setting_info->display_method == LCD_EXPANDSION) {
-		/* Expansion */
-		for (i = 12; i < 20; i++) {
-			switch (i) {
-			case H_TOTAL_SHADOW_INDEX:
-				reg_value =
-				    IGA2_HOR_TOTAL_SHADOW_FORMULA
-				    (panel_timing.hor_total);
-				viafb_load_reg_Num =
-				    iga2_shadow_crtc_reg.hor_total_shadow.
-				    reg_num;
-				reg = iga2_shadow_crtc_reg.hor_total_shadow.reg;
-				break;
-			case H_BLANK_END_SHADOW_INDEX:
-				reg_value =
-				    IGA2_HOR_BLANK_END_SHADOW_FORMULA
-				    (panel_timing.hor_blank_start,
-				     panel_timing.hor_blank_end);
-				viafb_load_reg_Num =
-				    iga2_shadow_crtc_reg.
-				    hor_blank_end_shadow.reg_num;
-				reg =
-				    iga2_shadow_crtc_reg.
-				    hor_blank_end_shadow.reg;
-				break;
-			case V_TOTAL_SHADOW_INDEX:
-				reg_value =
-				    IGA2_VER_TOTAL_SHADOW_FORMULA
-				    (panel_timing.ver_total);
-				viafb_load_reg_Num =
-				    iga2_shadow_crtc_reg.ver_total_shadow.
-				    reg_num;
-				reg = iga2_shadow_crtc_reg.ver_total_shadow.reg;
-				break;
-			case V_ADDR_SHADOW_INDEX:
-				reg_value =
-				    IGA2_VER_ADDR_SHADOW_FORMULA
-				    (panel_timing.ver_addr);
-				viafb_load_reg_Num =
-				    iga2_shadow_crtc_reg.ver_addr_shadow.
-				    reg_num;
-				reg = iga2_shadow_crtc_reg.ver_addr_shadow.reg;
-				break;
-			case V_BLANK_SATRT_SHADOW_INDEX:
-				reg_value =
-				    IGA2_VER_BLANK_START_SHADOW_FORMULA
-				    (panel_timing.ver_blank_start);
-				viafb_load_reg_Num =
-				    iga2_shadow_crtc_reg.
-				    ver_blank_start_shadow.reg_num;
-				reg =
-				    iga2_shadow_crtc_reg.
-				    ver_blank_start_shadow.reg;
-				break;
-			case V_BLANK_END_SHADOW_INDEX:
-				reg_value =
-				    IGA2_VER_BLANK_END_SHADOW_FORMULA
-				    (panel_timing.ver_blank_start,
-				     panel_timing.ver_blank_end);
-				viafb_load_reg_Num =
-				    iga2_shadow_crtc_reg.
-				    ver_blank_end_shadow.reg_num;
-				reg =
-				    iga2_shadow_crtc_reg.
-				    ver_blank_end_shadow.reg;
-				break;
-			case V_SYNC_SATRT_SHADOW_INDEX:
-				reg_value =
-				    IGA2_VER_SYNC_START_SHADOW_FORMULA
-				    (panel_timing.ver_sync_start);
-				viafb_load_reg_Num =
-				    iga2_shadow_crtc_reg.
-				    ver_sync_start_shadow.reg_num;
-				reg =
-				    iga2_shadow_crtc_reg.
-				    ver_sync_start_shadow.reg;
-				break;
-			case V_SYNC_END_SHADOW_INDEX:
-				reg_value =
-				    IGA2_VER_SYNC_END_SHADOW_FORMULA
-				    (panel_timing.ver_sync_start,
-				     panel_timing.ver_sync_end);
-				viafb_load_reg_Num =
-				    iga2_shadow_crtc_reg.
-				    ver_sync_end_shadow.reg_num;
-				reg =
-				    iga2_shadow_crtc_reg.
-				    ver_sync_end_shadow.reg;
-				break;
-			}
-			viafb_load_reg(reg_value,
-				viafb_load_reg_Num, reg, VIACR);
-		}
-	} else {		/* Centering */
-		for (i = 12; i < 20; i++) {
-			switch (i) {
-			case H_TOTAL_SHADOW_INDEX:
-				reg_value =
-				    IGA2_HOR_TOTAL_SHADOW_FORMULA
-				    (panel_timing.hor_total);
-				viafb_load_reg_Num =
-				    iga2_shadow_crtc_reg.hor_total_shadow.
-				    reg_num;
-				reg = iga2_shadow_crtc_reg.hor_total_shadow.reg;
-				break;
-			case H_BLANK_END_SHADOW_INDEX:
-				reg_value =
-				    IGA2_HOR_BLANK_END_SHADOW_FORMULA
-				    (panel_timing.hor_blank_start,
-				     panel_timing.hor_blank_end);
-				viafb_load_reg_Num =
-				    iga2_shadow_crtc_reg.
-				    hor_blank_end_shadow.reg_num;
-				reg =
-				    iga2_shadow_crtc_reg.
-				    hor_blank_end_shadow.reg;
-				break;
-			case V_TOTAL_SHADOW_INDEX:
-				reg_value =
-				    IGA2_VER_TOTAL_SHADOW_FORMULA
-				    (panel_timing.ver_total);
-				viafb_load_reg_Num =
-				    iga2_shadow_crtc_reg.ver_total_shadow.
-				    reg_num;
-				reg = iga2_shadow_crtc_reg.ver_total_shadow.reg;
-				break;
-			case V_ADDR_SHADOW_INDEX:
-				reg_value =
-				    IGA2_VER_ADDR_SHADOW_FORMULA
-				    (mode_timing.ver_addr);
-				viafb_load_reg_Num =
-				    iga2_shadow_crtc_reg.ver_addr_shadow.
-				    reg_num;
-				reg = iga2_shadow_crtc_reg.ver_addr_shadow.reg;
-				break;
-			case V_BLANK_SATRT_SHADOW_INDEX:
-				reg_value =
-				    IGA2_VER_BLANK_START_SHADOW_FORMULA
-				    (mode_timing.ver_blank_start);
-				viafb_load_reg_Num =
-				    iga2_shadow_crtc_reg.
-				    ver_blank_start_shadow.reg_num;
-				reg =
-				    iga2_shadow_crtc_reg.
-				    ver_blank_start_shadow.reg;
-				break;
-			case V_BLANK_END_SHADOW_INDEX:
-				reg_value =
-				    IGA2_VER_BLANK_END_SHADOW_FORMULA
-				    (panel_timing.ver_blank_start,
-				     panel_timing.ver_blank_end);
-				viafb_load_reg_Num =
-				    iga2_shadow_crtc_reg.
-				    ver_blank_end_shadow.reg_num;
-				reg =
-				    iga2_shadow_crtc_reg.
-				    ver_blank_end_shadow.reg;
-				break;
-			case V_SYNC_SATRT_SHADOW_INDEX:
-				reg_value =
-				    IGA2_VER_SYNC_START_SHADOW_FORMULA(
-				    (panel_timing.ver_sync_start -
-				    panel_timing.ver_blank_start) +
-				    (panel_timing.ver_addr -
-				    mode_timing.ver_addr) / 2 +
-				    mode_timing.ver_addr);
-				viafb_load_reg_Num =
-				    iga2_shadow_crtc_reg.ver_sync_start_shadow.
-				    reg_num;
-				reg =
-				    iga2_shadow_crtc_reg.ver_sync_start_shadow.
-				    reg;
-				break;
-			case V_SYNC_END_SHADOW_INDEX:
-				reg_value =
-				    IGA2_VER_SYNC_END_SHADOW_FORMULA(
-				    (panel_timing.ver_sync_start -
-				    panel_timing.ver_blank_start) +
-				    (panel_timing.ver_addr -
-				    mode_timing.ver_addr) / 2 +
-				    mode_timing.ver_addr,
-				    panel_timing.ver_sync_end);
-				viafb_load_reg_Num =
-				    iga2_shadow_crtc_reg.ver_sync_end_shadow.
-				    reg_num;
-				reg =
-				    iga2_shadow_crtc_reg.ver_sync_end_shadow.
-				    reg;
-				break;
-			}
-			viafb_load_reg(reg_value,
-				viafb_load_reg_Num, reg, VIACR);
-		}
-	}
-}
