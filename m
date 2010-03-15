From: akpm@linux-foundation.org
Subject: [merged] viafb-split-global-index-up.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:56:02 -0400
Message-ID: <201003150656.o2F6uZl4016294@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40573 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934451Ab0COG4n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:56:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     viafb: split global index up
has been removed from the -mm tree.  Its filename was
     viafb-split-global-index-up.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb: split global index up
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

This is the first step to remove an artificial global index that was used
in two ways:

1. As a pseudo index in the mode table.  Pseudo as you had to search
   through the table to find the referenced entry.  This was replaced by
   using a pointer to the entry.

2. As a shortcut to compare a combination of horizontal and vertical
   resolution at the same time.

   This was replaced by a "(hres<<16) | vres" which is good enough for
   now and the near future.  If vres or hres become greater than 2^16 this
   might indeed cause problems but this solution allows to split this
   indexing mess up without the requirement to do even more code changes.

This is a big change that will allow more clean ups.  It should be a bit
faster but that is probably not relevant for normal operation.  No
regressions expected but as this is a relatively big step heavy testing is
appreciated.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/dvi.c      |   56 +---------
 drivers/video/via/dvi.h      |    4 
 drivers/video/via/hw.c       |  151 ++++-----------------------
 drivers/video/via/hw.h       |   12 +-
 drivers/video/via/lcd.c      |  148 ++++++++++++---------------
 drivers/video/via/viafbdev.c |   49 ++------
 drivers/video/via/viafbdev.h |    3 
 drivers/video/via/viamode.c  |  180 +++++++++++++++++----------------
 drivers/video/via/viamode.h  |    8 -
 9 files changed, 225 insertions(+), 386 deletions(-)

diff -puN drivers/video/via/dvi.c~viafb-split-global-index-up drivers/video/via/dvi.c
--- a/drivers/video/via/dvi.c~viafb-split-global-index-up
+++ a/drivers/video/via/dvi.c
@@ -23,8 +23,6 @@
 static void tmds_register_write(int index, u8 data);
 static int tmds_register_read(int index);
 static int tmds_register_read_bytes(int index, u8 *buff, int buff_len);
-static int check_reduce_blanking_mode(int mode_index,
-	int refresh_rate);
 static int dvi_get_panel_size_from_DDCv1(void);
 static int dvi_get_panel_size_from_DDCv2(void);
 static unsigned char dvi_get_panel_info(void);
@@ -189,42 +187,14 @@ static int tmds_register_read_bytes(int 
 	return 0;
 }
 
-static int check_reduce_blanking_mode(int mode_index,
-	int refresh_rate)
-{
-	if (refresh_rate != 60)
-		return false;
-
-	switch (mode_index) {
-		/* Following modes have reduce blanking mode. */
-	case VIA_RES_1360X768:
-	case VIA_RES_1400X1050:
-	case VIA_RES_1440X900:
-	case VIA_RES_1600X900:
-	case VIA_RES_1680X1050:
-	case VIA_RES_1920X1080:
-	case VIA_RES_1920X1200:
-		break;
-
-	default:
-		DEBUG_MSG(KERN_INFO
-			  "This dvi mode %d have no reduce blanking mode!\n",
-			  mode_index);
-		return false;
-	}
-
-	return true;
-}
-
 /* DVI Set Mode */
-void viafb_dvi_set_mode(int video_index, int mode_bpp, int set_iga)
+void viafb_dvi_set_mode(struct VideoModeTable *mode, int mode_bpp,
+	int set_iga)
 {
-	struct VideoModeTable *videoMode = NULL;
+	struct VideoModeTable *rb_mode;
 	struct crt_mode_table *pDviTiming;
 	unsigned long desirePixelClock, maxPixelClock;
-	int status = 0;
-	videoMode = viafb_get_modetbl_pointer(video_index);
-	pDviTiming = videoMode->crtc;
+	pDviTiming = mode->crtc;
 	desirePixelClock = pDviTiming->clk / 1000000;
 	maxPixelClock = (unsigned long)viaparinfo->
 		tmds_setting_info->max_pixel_clock;
@@ -232,20 +202,14 @@ void viafb_dvi_set_mode(int video_index,
 	DEBUG_MSG(KERN_INFO "\nDVI_set_mode!!\n");
 
 	if ((maxPixelClock != 0) && (desirePixelClock > maxPixelClock)) {
-		/*Check if reduce-blanking mode is exist */
-		status =
-		    check_reduce_blanking_mode(video_index,
-					       pDviTiming->refresh_rate);
-		if (status) {
-			video_index += 100;	/*Use reduce-blanking mode */
-			videoMode = viafb_get_modetbl_pointer(video_index);
-			pDviTiming = videoMode->crtc;
-			DEBUG_MSG(KERN_INFO
-				  "DVI use reduce blanking mode %d!!\n",
-				  video_index);
+		rb_mode = viafb_get_rb_mode(mode->crtc[0].crtc.hor_addr,
+			mode->crtc[0].crtc.ver_addr);
+		if (rb_mode) {
+			mode = rb_mode;
+			pDviTiming = rb_mode->crtc;
 		}
 	}
-	viafb_fill_crtc_timing(pDviTiming, video_index, mode_bpp / 8, set_iga);
+	viafb_fill_crtc_timing(pDviTiming, mode, mode_bpp / 8, set_iga);
 	viafb_set_output_path(DEVICE_DVI, set_iga,
 			viaparinfo->chip_info->tmds_chip_info.output_interface);
 }
diff -puN drivers/video/via/dvi.h~viafb-split-global-index-up drivers/video/via/dvi.h
--- a/drivers/video/via/dvi.h~viafb-split-global-index-up
+++ a/drivers/video/via/dvi.h
@@ -53,12 +53,12 @@
 #define     DEV_CONNECT_DVI     0x01
 #define     DEV_CONNECT_HDMI    0x02
 
-struct VideoModeTable *viafb_get_cea_mode_tbl_pointer(int Index);
 int viafb_dvi_sense(void);
 void viafb_dvi_disable(void);
 void viafb_dvi_enable(void);
 int viafb_tmds_trasmitter_identify(void);
 void viafb_init_dvi_size(void);
-void viafb_dvi_set_mode(int video_index, int mode_bpp, int set_iga);
+void viafb_dvi_set_mode(struct VideoModeTable *videoMode, int mode_bpp,
+	int set_iga);
 
 #endif /* __DVI_H__ */
diff -puN drivers/video/via/hw.c~viafb-split-global-index-up drivers/video/via/hw.c
--- a/drivers/video/via/hw.c~viafb-split-global-index-up
+++ a/drivers/video/via/hw.c
@@ -524,7 +524,6 @@ static void dvi_patch_skew_dvp1(void);
 static void dvi_patch_skew_dvp_low(void);
 static void set_dvi_output_path(int set_iga, int output_interface);
 static void set_lcd_output_path(int set_iga, int output_interface);
-static int search_mode_setting(int ModeInfoIndex);
 static void load_fix_bit_crtc_reg(void);
 static void init_gfx_chip_info(struct pci_dev *pdev,
 				const struct pci_device_id *pdi);
@@ -987,49 +986,6 @@ static void set_lcd_output_path(int set_
 	}
 }
 
-/* Search Mode Index */
-static int search_mode_setting(int ModeInfoIndex)
-{
-	int i = 0;
-
-	while ((i < NUM_TOTAL_MODETABLE) &&
-			(ModeInfoIndex != CLE266Modes[i].ModeIndex))
-		i++;
-	if (i >= NUM_TOTAL_MODETABLE)
-		i = 0;
-	return i;
-
-}
-
-struct VideoModeTable *viafb_get_modetbl_pointer(int Index)
-{
-	struct VideoModeTable *TmpTbl = NULL;
-	TmpTbl = &CLE266Modes[search_mode_setting(Index)];
-	return TmpTbl;
-}
-
-struct VideoModeTable *viafb_get_cea_mode_tbl_pointer(int Index)
-{
-	struct VideoModeTable *TmpTbl = NULL;
-	int i = 0;
-	while ((i < NUM_TOTAL_CEA_MODES) &&
-			(Index != CEA_HDMI_Modes[i].ModeIndex))
-		i++;
-	if ((i < NUM_TOTAL_CEA_MODES))
-		TmpTbl = &CEA_HDMI_Modes[i];
-	 else {
-		/*Still use general timing if don't find CEA timing */
-		i = 0;
-		while ((i < NUM_TOTAL_MODETABLE) &&
-				(Index != CLE266Modes[i].ModeIndex))
-		       i++;
-		if (i >= NUM_TOTAL_MODETABLE)
-			i = 0;
-		TmpTbl = &CLE266Modes[i];
-	}
-	return TmpTbl;
-}
-
 static void load_fix_bit_crtc_reg(void)
 {
 	/* always set to 1 */
@@ -1835,17 +1791,14 @@ void viafb_set_color_depth(int bpp_byte,
 }
 
 void viafb_fill_crtc_timing(struct crt_mode_table *crt_table,
-	int mode_index, int bpp_byte, int set_iga)
+	struct VideoModeTable *video_mode, int bpp_byte, int set_iga)
 {
-	struct VideoModeTable *video_mode;
 	struct display_timing crt_reg;
 	int i;
 	int index = 0;
 	int h_addr, v_addr;
 	u32 pll_D_N;
 
-	video_mode = &CLE266Modes[search_mode_setting(mode_index)];
-
 	for (i = 0; i < video_mode->mode_array; i++) {
 		index = i;
 
@@ -1858,8 +1811,10 @@ void viafb_fill_crtc_timing(struct crt_m
 
 	/* Mode 640x480 has border, but LCD/DFP didn't have border. */
 	/* So we would delete border. */
-	if ((viafb_LCD_ON | viafb_DVI_ON) && (mode_index == VIA_RES_640X480)
-	    && (viaparinfo->crt_setting_info->refresh_rate == 60)) {
+	if ((viafb_LCD_ON | viafb_DVI_ON)
+	    && video_mode->crtc[0].crtc.hor_addr == 640
+	    && video_mode->crtc[0].crtc.ver_addr == 480
+	    && viaparinfo->crt_setting_info->refresh_rate == 60) {
 		/* The border is 8 pixels. */
 		crt_reg.hor_blank_start = crt_reg.hor_blank_start - 8;
 
@@ -2195,28 +2150,19 @@ static void set_display_channel(void)
 	}
 }
 
-int viafb_setmode(int vmode_index, int hor_res, int ver_res, int video_bpp,
-	int vmode_index1, int hor_res1, int ver_res1, int video_bpp1)
+int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
+	struct VideoModeTable *vmode_tbl1, int video_bpp1)
 {
 	int i, j;
 	int port;
 	u8 value, index, mask;
-	struct VideoModeTable *vmode_tbl;
 	struct crt_mode_table *crt_timing;
-	struct VideoModeTable *vmode_tbl1 = NULL;
 	struct crt_mode_table *crt_timing1 = NULL;
 
-	DEBUG_MSG(KERN_INFO "Set Mode!!\n");
-	DEBUG_MSG(KERN_INFO
-		  "vmode_index=%d hor_res=%d ver_res=%d video_bpp=%d\n",
-		  vmode_index, hor_res, ver_res, video_bpp);
-
 	device_screen_off();
-	vmode_tbl = &CLE266Modes[search_mode_setting(vmode_index)];
 	crt_timing = vmode_tbl->crtc;
 
 	if (viafb_SAMM_ON == 1) {
-		vmode_tbl1 = &CLE266Modes[search_mode_setting(vmode_index1)];
 		crt_timing1 = vmode_tbl1->crtc;
 	}
 
@@ -2272,7 +2218,7 @@ int viafb_setmode(int vmode_index, int h
 	viafb_set_iga_path();
 
 	/* Write CRTC */
-	viafb_fill_crtc_timing(crt_timing, vmode_index, video_bpp / 8, IGA1);
+	viafb_fill_crtc_timing(crt_timing, vmode_tbl, video_bpp / 8, IGA1);
 
 	/* Write Graphic Controller */
 	for (i = 0; i < StdGR; i++) {
@@ -2292,59 +2238,16 @@ int viafb_setmode(int vmode_index, int h
 
 	/* Update Patch Register */
 
-	if ((viaparinfo->chip_info->gfx_chip_name == UNICHROME_CLE266)
-	    || (viaparinfo->chip_info->gfx_chip_name == UNICHROME_K400)) {
-		for (i = 0; i < NUM_TOTAL_PATCH_MODE; i++) {
-			if (res_patch_table[i].mode_index == vmode_index) {
-				for (j = 0;
-				     j < res_patch_table[i].table_length; j++) {
-					index =
-					    res_patch_table[i].
-					    io_reg_table[j].index;
-					port =
-					    res_patch_table[i].
-					    io_reg_table[j].port;
-					value =
-					    res_patch_table[i].
-					    io_reg_table[j].value;
-					mask =
-					    res_patch_table[i].
-					    io_reg_table[j].mask;
-					viafb_write_reg_mask(index, port, value,
-						       mask);
-				}
-			}
-		}
-	}
-
-	if (viafb_SAMM_ON == 1) {
-		if ((viaparinfo->chip_info->gfx_chip_name == UNICHROME_CLE266)
-		    || (viaparinfo->chip_info->gfx_chip_name ==
-		    UNICHROME_K400)) {
-			for (i = 0; i < NUM_TOTAL_PATCH_MODE; i++) {
-				if (res_patch_table[i].mode_index ==
-				    vmode_index1) {
-					for (j = 0;
-					     j <
-					     res_patch_table[i].
-					     table_length; j++) {
-						index =
-						    res_patch_table[i].
-						    io_reg_table[j].index;
-						port =
-						    res_patch_table[i].
-						    io_reg_table[j].port;
-						value =
-						    res_patch_table[i].
-						    io_reg_table[j].value;
-						mask =
-						    res_patch_table[i].
-						    io_reg_table[j].mask;
-						viafb_write_reg_mask(index,
-							port, value, mask);
-					}
-				}
-			}
+	if ((viaparinfo->chip_info->gfx_chip_name == UNICHROME_CLE266
+	    || viaparinfo->chip_info->gfx_chip_name == UNICHROME_K400)
+	    && vmode_tbl->crtc[0].crtc.hor_addr == 1024
+	    && vmode_tbl->crtc[0].crtc.ver_addr == 768) {
+		for (j = 0; j < res_patch_table[0].table_length; j++) {
+			index = res_patch_table[0].io_reg_table[j].index;
+			port = res_patch_table[0].io_reg_table[j].port;
+			value = res_patch_table[0].io_reg_table[j].value;
+			mask = res_patch_table[0].io_reg_table[j].mask;
+			viafb_write_reg_mask(index, port, value, mask);
 		}
 	}
 
@@ -2359,11 +2262,11 @@ int viafb_setmode(int vmode_index, int h
 	if (viafb_CRT_ON) {
 		if (viafb_SAMM_ON && (viaparinfo->crt_setting_info->iga_path ==
 			IGA2)) {
-			viafb_fill_crtc_timing(crt_timing1, vmode_index1,
+			viafb_fill_crtc_timing(crt_timing1, vmode_tbl1,
 				video_bpp1 / 8,
 				viaparinfo->crt_setting_info->iga_path);
 		} else {
-			viafb_fill_crtc_timing(crt_timing, vmode_index,
+			viafb_fill_crtc_timing(crt_timing, vmode_tbl,
 				video_bpp / 8,
 				viaparinfo->crt_setting_info->iga_path);
 		}
@@ -2373,7 +2276,7 @@ int viafb_setmode(int vmode_index, int h
 		/* Patch if set_hres is not 8 alignment (1366) to viafb_setmode
 		to 8 alignment (1368),there is several pixels (2 pixels)
 		on right side of screen. */
-		if (hor_res % 8) {
+		if (vmode_tbl->crtc[0].crtc.hor_addr % 8) {
 			viafb_unlock_crt();
 			viafb_write_reg(CR02, VIACR,
 				viafb_read_reg(VIACR, CR02) - 1);
@@ -2384,14 +2287,14 @@ int viafb_setmode(int vmode_index, int h
 	if (viafb_DVI_ON) {
 		if (viafb_SAMM_ON &&
 			(viaparinfo->tmds_setting_info->iga_path == IGA2)) {
-			viafb_dvi_set_mode(viafb_get_mode_index
+			viafb_dvi_set_mode(viafb_get_mode
 				     (viaparinfo->tmds_setting_info->h_active,
 				      viaparinfo->tmds_setting_info->
 				      v_active),
 				     video_bpp1, viaparinfo->
 				     tmds_setting_info->iga_path);
 		} else {
-			viafb_dvi_set_mode(viafb_get_mode_index
+			viafb_dvi_set_mode(viafb_get_mode
 				     (viaparinfo->tmds_setting_info->h_active,
 				      viaparinfo->
 				      tmds_setting_info->v_active),
@@ -2445,8 +2348,8 @@ int viafb_setmode(int vmode_index, int h
 
 	/* If set mode normally, save resolution information for hot-plug . */
 	if (!viafb_hotplug) {
-		viafb_hotplug_Xres = hor_res;
-		viafb_hotplug_Yres = ver_res;
+		viafb_hotplug_Xres = vmode_tbl->crtc[0].crtc.hor_addr;
+		viafb_hotplug_Yres = vmode_tbl->crtc[0].crtc.ver_addr;
 		viafb_hotplug_bpp = video_bpp;
 		viafb_hotplug_refresh = viafb_refresh;
 
@@ -2706,13 +2609,11 @@ void viafb_set_dpa_gfx(int output_interf
 
 /*According var's xres, yres fill var's other timing information*/
 void viafb_fill_var_timing_info(struct fb_var_screeninfo *var, int refresh,
-			  int mode_index)
+	struct VideoModeTable *vmode_tbl)
 {
-	struct VideoModeTable *vmode_tbl = NULL;
 	struct crt_mode_table *crt_timing = NULL;
 	struct display_timing crt_reg;
 	int i = 0, index = 0;
-	vmode_tbl = &CLE266Modes[search_mode_setting(mode_index)];
 	crt_timing = vmode_tbl->crtc;
 	for (i = 0; i < vmode_tbl->mode_array; i++) {
 		index = i;
diff -puN drivers/video/via/hw.h~viafb-split-global-index-up drivers/video/via/hw.h
--- a/drivers/video/via/hw.h~viafb-split-global-index-up
+++ a/drivers/video/via/hw.h
@@ -22,6 +22,7 @@
 #ifndef __HW_H__
 #define __HW_H__
 
+#include "viamode.h"
 #include "global.h"
 
 /***************************************************
@@ -874,8 +875,9 @@ extern int viafb_hotplug;
 void viafb_write_reg_mask(u8 index, int io_port, u8 data, u8 mask);
 void viafb_set_output_path(int device, int set_iga,
 	int output_interface);
+
 void viafb_fill_crtc_timing(struct crt_mode_table *crt_table,
-		      int mode_index, int bpp_byte, int set_iga);
+	struct VideoModeTable *video_mode, int bpp_byte, int set_iga);
 
 void viafb_set_vclock(u32 CLK, int set_iga);
 void viafb_load_reg(int timing_value, int viafb_load_reg_num,
@@ -891,16 +893,16 @@ void viafb_lock_crt(void);
 void viafb_unlock_crt(void);
 void viafb_load_fetch_count_reg(int h_addr, int bpp_byte, int set_iga);
 void viafb_write_regx(struct io_reg RegTable[], int ItemNum);
-struct VideoModeTable *viafb_get_modetbl_pointer(int Index);
 u32 viafb_get_clk_value(int clk);
 void viafb_load_FIFO_reg(int set_iga, int hor_active, int ver_active);
 void viafb_set_color_depth(int bpp_byte, int set_iga);
 void viafb_set_dpa_gfx(int output_interface, struct GFX_DPA_SETTING\
 					*p_gfx_dpa_setting);
 
-int viafb_setmode(int vmode_index, int hor_res, int ver_res,
-	    int video_bpp, int vmode_index1, int hor_res1,
-	    int ver_res1, int video_bpp1);
+int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
+	struct VideoModeTable *vmode_tbl1, int video_bpp1);
+void viafb_fill_var_timing_info(struct fb_var_screeninfo *var, int refresh,
+	struct VideoModeTable *vmode_tbl);
 void viafb_init_chip_info(struct pci_dev *pdev,
 			  const struct pci_device_id *pdi);
 void viafb_init_dac(int set_iga);
diff -puN drivers/video/via/lcd.c~viafb-split-global-index-up drivers/video/via/lcd.c
--- a/drivers/video/via/lcd.c~viafb-split-global-index-up
+++ a/drivers/video/via/lcd.c
@@ -22,6 +22,8 @@
 #include "global.h"
 #include "lcdtbl.h"
 
+#define viafb_compact_res(x, y) (((x)<<16)|(y))
+
 static struct iga2_shadow_crtc_timing iga2_shadow_crtc_reg = {
 	/* IGA2 Shadow Horizontal Total */
 	{IGA2_SHADOW_HOR_TOTAL_REG_NUM, {{CR6D, 0, 7}, {CR71, 3, 3} } },
@@ -576,22 +578,21 @@ static void load_lcd_scaling(int set_hre
 static void load_lcd_k400_patch_tbl(int set_hres, int set_vres,
 	int panel_id)
 {
-	int vmode_index;
+	u32 compact_mode = viafb_compact_res(set_hres, set_vres);
 	int reg_num = 0;
 	struct io_reg *lcd_patch_reg = NULL;
 
-	vmode_index = viafb_get_mode_index(set_hres, set_vres);
 	switch (panel_id) {
 		/* LCD 800x600 */
 	case LCD_PANEL_ID1_800X600:
-		switch (vmode_index) {
-		case VIA_RES_640X400:
-		case VIA_RES_640X480:
+		switch (compact_mode) {
+		case viafb_compact_res(640, 400):
+		case viafb_compact_res(640, 480):
 			reg_num = NUM_TOTAL_K400_LCD_RES_6X4_8X6;
 			lcd_patch_reg = K400_LCD_RES_6X4_8X6;
 			break;
-		case VIA_RES_720X480:
-		case VIA_RES_720X576:
+		case viafb_compact_res(720, 480):
+		case viafb_compact_res(720, 576):
 			reg_num = NUM_TOTAL_K400_LCD_RES_7X4_8X6;
 			lcd_patch_reg = K400_LCD_RES_7X4_8X6;
 			break;
@@ -600,18 +601,18 @@ static void load_lcd_k400_patch_tbl(int 
 
 		/* LCD 1024x768 */
 	case LCD_PANEL_ID2_1024X768:
-		switch (vmode_index) {
-		case VIA_RES_640X400:
-		case VIA_RES_640X480:
+		switch (compact_mode) {
+		case viafb_compact_res(640, 400):
+		case viafb_compact_res(640, 480):
 			reg_num = NUM_TOTAL_K400_LCD_RES_6X4_10X7;
 			lcd_patch_reg = K400_LCD_RES_6X4_10X7;
 			break;
-		case VIA_RES_720X480:
-		case VIA_RES_720X576:
+		case viafb_compact_res(720, 480):
+		case viafb_compact_res(720, 576):
 			reg_num = NUM_TOTAL_K400_LCD_RES_7X4_10X7;
 			lcd_patch_reg = K400_LCD_RES_7X4_10X7;
 			break;
-		case VIA_RES_800X600:
+		case viafb_compact_res(800, 600):
 			reg_num = NUM_TOTAL_K400_LCD_RES_8X6_10X7;
 			lcd_patch_reg = K400_LCD_RES_8X6_10X7;
 			break;
@@ -620,22 +621,22 @@ static void load_lcd_k400_patch_tbl(int 
 
 		/* LCD 1280x1024 */
 	case LCD_PANEL_ID4_1280X1024:
-		switch (vmode_index) {
-		case VIA_RES_640X400:
-		case VIA_RES_640X480:
+		switch (compact_mode) {
+		case viafb_compact_res(640, 400):
+		case viafb_compact_res(640, 480):
 			reg_num = NUM_TOTAL_K400_LCD_RES_6X4_12X10;
 			lcd_patch_reg = K400_LCD_RES_6X4_12X10;
 			break;
-		case VIA_RES_720X480:
-		case VIA_RES_720X576:
+		case viafb_compact_res(720, 480):
+		case viafb_compact_res(720, 576):
 			reg_num = NUM_TOTAL_K400_LCD_RES_7X4_12X10;
 			lcd_patch_reg = K400_LCD_RES_7X4_12X10;
 			break;
-		case VIA_RES_800X600:
+		case viafb_compact_res(800, 600):
 			reg_num = NUM_TOTAL_K400_LCD_RES_8X6_12X10;
 			lcd_patch_reg = K400_LCD_RES_8X6_12X10;
 			break;
-		case VIA_RES_1024X768:
+		case viafb_compact_res(1024, 768):
 			reg_num = NUM_TOTAL_K400_LCD_RES_10X7_12X10;
 			lcd_patch_reg = K400_LCD_RES_10X7_12X10;
 			break;
@@ -645,23 +646,23 @@ static void load_lcd_k400_patch_tbl(int 
 
 		/* LCD 1400x1050 */
 	case LCD_PANEL_ID5_1400X1050:
-		switch (vmode_index) {
-		case VIA_RES_640X480:
+		switch (compact_mode) {
+		case viafb_compact_res(640, 480):
 			reg_num = NUM_TOTAL_K400_LCD_RES_6X4_14X10;
 			lcd_patch_reg = K400_LCD_RES_6X4_14X10;
 			break;
-		case VIA_RES_800X600:
+		case viafb_compact_res(800, 600):
 			reg_num = NUM_TOTAL_K400_LCD_RES_8X6_14X10;
 			lcd_patch_reg = K400_LCD_RES_8X6_14X10;
 			break;
-		case VIA_RES_1024X768:
+		case viafb_compact_res(1024, 768):
 			reg_num = NUM_TOTAL_K400_LCD_RES_10X7_14X10;
 			lcd_patch_reg = K400_LCD_RES_10X7_14X10;
 			break;
-		case VIA_RES_1280X768:
-		case VIA_RES_1280X800:
-		case VIA_RES_1280X960:
-		case VIA_RES_1280X1024:
+		case viafb_compact_res(1280, 768):
+		case viafb_compact_res(1280, 800):
+		case viafb_compact_res(1280, 960):
+		case viafb_compact_res(1280, 1024):
 			reg_num = NUM_TOTAL_K400_LCD_RES_12X10_14X10;
 			lcd_patch_reg = K400_LCD_RES_12X10_14X10;
 			break;
@@ -670,29 +671,29 @@ static void load_lcd_k400_patch_tbl(int 
 
 		/* LCD 1600x1200 */
 	case LCD_PANEL_ID6_1600X1200:
-		switch (vmode_index) {
-		case VIA_RES_640X400:
-		case VIA_RES_640X480:
+		switch (compact_mode) {
+		case viafb_compact_res(640, 400):
+		case viafb_compact_res(640, 480):
 			reg_num = NUM_TOTAL_K400_LCD_RES_6X4_16X12;
 			lcd_patch_reg = K400_LCD_RES_6X4_16X12;
 			break;
-		case VIA_RES_720X480:
-		case VIA_RES_720X576:
+		case viafb_compact_res(720, 480):
+		case viafb_compact_res(720, 576):
 			reg_num = NUM_TOTAL_K400_LCD_RES_7X4_16X12;
 			lcd_patch_reg = K400_LCD_RES_7X4_16X12;
 			break;
-		case VIA_RES_800X600:
+		case viafb_compact_res(800, 600):
 			reg_num = NUM_TOTAL_K400_LCD_RES_8X6_16X12;
 			lcd_patch_reg = K400_LCD_RES_8X6_16X12;
 			break;
-		case VIA_RES_1024X768:
+		case viafb_compact_res(1024, 768):
 			reg_num = NUM_TOTAL_K400_LCD_RES_10X7_16X12;
 			lcd_patch_reg = K400_LCD_RES_10X7_16X12;
 			break;
-		case VIA_RES_1280X768:
-		case VIA_RES_1280X800:
-		case VIA_RES_1280X960:
-		case VIA_RES_1280X1024:
+		case viafb_compact_res(1280, 768):
+		case viafb_compact_res(1280, 800):
+		case viafb_compact_res(1280, 960):
+		case viafb_compact_res(1280, 1024):
 			reg_num = NUM_TOTAL_K400_LCD_RES_12X10_16X12;
 			lcd_patch_reg = K400_LCD_RES_12X10_16X12;
 			break;
@@ -701,28 +702,28 @@ static void load_lcd_k400_patch_tbl(int 
 
 		/* LCD 1366x768 */
 	case LCD_PANEL_ID7_1366X768:
-		switch (vmode_index) {
-		case VIA_RES_640X480:
+		switch (compact_mode) {
+		case viafb_compact_res(640, 480):
 			reg_num = NUM_TOTAL_K400_LCD_RES_6X4_1366X7;
 			lcd_patch_reg = K400_LCD_RES_6X4_1366X7;
 			break;
-		case VIA_RES_720X480:
-		case VIA_RES_720X576:
+		case viafb_compact_res(720, 480):
+		case viafb_compact_res(720, 576):
 			reg_num = NUM_TOTAL_K400_LCD_RES_7X4_1366X7;
 			lcd_patch_reg = K400_LCD_RES_7X4_1366X7;
 			break;
-		case VIA_RES_800X600:
+		case viafb_compact_res(800, 600):
 			reg_num = NUM_TOTAL_K400_LCD_RES_8X6_1366X7;
 			lcd_patch_reg = K400_LCD_RES_8X6_1366X7;
 			break;
-		case VIA_RES_1024X768:
+		case viafb_compact_res(1024, 768):
 			reg_num = NUM_TOTAL_K400_LCD_RES_10X7_1366X7;
 			lcd_patch_reg = K400_LCD_RES_10X7_1366X7;
 			break;
-		case VIA_RES_1280X768:
-		case VIA_RES_1280X800:
-		case VIA_RES_1280X960:
-		case VIA_RES_1280X1024:
+		case viafb_compact_res(1280, 768):
+		case viafb_compact_res(1280, 800):
+		case viafb_compact_res(1280, 960):
+		case viafb_compact_res(1280, 1024):
 			reg_num = NUM_TOTAL_K400_LCD_RES_12X10_1366X7;
 			lcd_patch_reg = K400_LCD_RES_12X10_1366X7;
 			break;
@@ -754,48 +755,46 @@ static void load_lcd_k400_patch_tbl(int 
 static void load_lcd_p880_patch_tbl(int set_hres, int set_vres,
 	int panel_id)
 {
-	int vmode_index;
+	u32 compact_mode = viafb_compact_res(set_hres, set_vres);
 	int reg_num = 0;
 	struct io_reg *lcd_patch_reg = NULL;
 
-	vmode_index = viafb_get_mode_index(set_hres, set_vres);
-
 	switch (panel_id) {
 	case LCD_PANEL_ID5_1400X1050:
-		switch (vmode_index) {
-		case VIA_RES_640X480:
+		switch (compact_mode) {
+		case viafb_compact_res(640, 480):
 			reg_num = NUM_TOTAL_P880_LCD_RES_6X4_14X10;
 			lcd_patch_reg = P880_LCD_RES_6X4_14X10;
 			break;
-		case VIA_RES_800X600:
+		case viafb_compact_res(800, 600):
 			reg_num = NUM_TOTAL_P880_LCD_RES_8X6_14X10;
 			lcd_patch_reg = P880_LCD_RES_8X6_14X10;
 			break;
 		}
 		break;
 	case LCD_PANEL_ID6_1600X1200:
-		switch (vmode_index) {
-		case VIA_RES_640X400:
-		case VIA_RES_640X480:
+		switch (compact_mode) {
+		case viafb_compact_res(640, 400):
+		case viafb_compact_res(640, 480):
 			reg_num = NUM_TOTAL_P880_LCD_RES_6X4_16X12;
 			lcd_patch_reg = P880_LCD_RES_6X4_16X12;
 			break;
-		case VIA_RES_720X480:
-		case VIA_RES_720X576:
+		case viafb_compact_res(720, 480):
+		case viafb_compact_res(720, 576):
 			reg_num = NUM_TOTAL_P880_LCD_RES_7X4_16X12;
 			lcd_patch_reg = P880_LCD_RES_7X4_16X12;
 			break;
-		case VIA_RES_800X600:
+		case viafb_compact_res(800, 600):
 			reg_num = NUM_TOTAL_P880_LCD_RES_8X6_16X12;
 			lcd_patch_reg = P880_LCD_RES_8X6_16X12;
 			break;
-		case VIA_RES_1024X768:
+		case viafb_compact_res(1024, 768):
 			reg_num = NUM_TOTAL_P880_LCD_RES_10X7_16X12;
 			lcd_patch_reg = P880_LCD_RES_10X7_16X12;
 			break;
-		case VIA_RES_1280X768:
-		case VIA_RES_1280X960:
-		case VIA_RES_1280X1024:
+		case viafb_compact_res(1280, 768):
+		case viafb_compact_res(1280, 960):
+		case viafb_compact_res(1280, 1024):
 			reg_num = NUM_TOTAL_P880_LCD_RES_12X10_16X12;
 			lcd_patch_reg = P880_LCD_RES_12X10_16X12;
 			break;
@@ -824,10 +823,6 @@ static void load_lcd_p880_patch_tbl(int 
 static void load_lcd_patch_regs(int set_hres, int set_vres,
 	int panel_id, int set_iga)
 {
-	int vmode_index;
-
-	vmode_index = viafb_get_mode_index(set_hres, set_vres);
-
 	viafb_unlock_crt();
 
 	/* Patch for simultaneous & Expansion */
@@ -949,29 +944,26 @@ void viafb_lcd_set_mode(struct crt_mode_
 		  struct lvds_setting_information *plvds_setting_info,
 		  struct lvds_chip_information *plvds_chip_info)
 {
-	int video_index = plvds_setting_info->lcd_panel_size;
 	int set_iga = plvds_setting_info->iga_path;
 	int mode_bpp = plvds_setting_info->bpp;
-	int set_hres, set_vres;
-	int panel_hres, panel_vres;
+	int set_hres = plvds_setting_info->h_active;
+	int set_vres = plvds_setting_info->v_active;
+	int panel_hres = plvds_setting_info->lcd_panel_hres;
+	int panel_vres = plvds_setting_info->lcd_panel_vres;
 	u32 pll_D_N;
 	int offset;
 	struct display_timing mode_crt_reg, panel_crt_reg;
 	struct crt_mode_table *panel_crt_table = NULL;
-	struct VideoModeTable *vmode_tbl = NULL;
+	struct VideoModeTable *vmode_tbl = viafb_get_mode(panel_hres,
+		panel_vres);
 
 	DEBUG_MSG(KERN_INFO "viafb_lcd_set_mode!!\n");
 	/* Get mode table */
 	mode_crt_reg = mode_crt_table->crtc;
 	/* Get panel table Pointer */
-	vmode_tbl = viafb_get_modetbl_pointer(video_index);
 	panel_crt_table = vmode_tbl->crtc;
 	panel_crt_reg = panel_crt_table->crtc;
 	DEBUG_MSG(KERN_INFO "bellow viafb_lcd_set_mode!!\n");
-	set_hres = plvds_setting_info->h_active;
-	set_vres = plvds_setting_info->v_active;
-	panel_hres = plvds_setting_info->lcd_panel_hres;
-	panel_vres = plvds_setting_info->lcd_panel_vres;
 	if (VT1636_LVDS == plvds_chip_info->lvds_chip_name)
 		viafb_init_lvds_vt1636(plvds_setting_info, plvds_chip_info);
 	plvds_setting_info->vclk = panel_crt_table->clk;
diff -puN drivers/video/via/viafbdev.c~viafb-split-global-index-up drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-split-global-index-up
+++ a/drivers/video/via/viafbdev.c
@@ -97,7 +97,8 @@ static int viafb_release(struct fb_info 
 static int viafb_check_var(struct fb_var_screeninfo *var,
 	struct fb_info *info)
 {
-	int vmode_index, htotal, vtotal;
+	int htotal, vtotal;
+	struct VideoModeTable *vmode_entry;
 	struct viafb_par *ppar = info->par;
 	u32 long_refresh;
 
@@ -107,8 +108,8 @@ static int viafb_check_var(struct fb_var
 	if (var->vmode & FB_VMODE_INTERLACED || var->vmode & FB_VMODE_DOUBLE)
 		return -EINVAL;
 
-	vmode_index = viafb_get_mode_index(var->xres, var->yres);
-	if (vmode_index == VIA_RES_INVALID) {
+	vmode_entry = viafb_get_mode(var->xres, var->yres);
+	if (!vmode_entry) {
 		DEBUG_MSG(KERN_INFO
 			  "viafb: Mode %dx%dx%d not supported!!\n",
 			  var->xres, var->yres, var->bits_per_pixel);
@@ -142,7 +143,7 @@ static int viafb_check_var(struct fb_var
 	viafb_refresh = viafb_get_refresh(var->xres, var->yres, long_refresh);
 
 	/* Adjust var according to our driver's own table */
-	viafb_fill_var_timing_info(var, viafb_refresh, vmode_index);
+	viafb_fill_var_timing_info(var, viafb_refresh, vmode_entry);
 	if (info->var.accel_flags & FB_ACCELF_TEXT &&
 		!ppar->shared->engine_mmio)
 		info->var.accel_flags = 0;
@@ -153,39 +154,34 @@ static int viafb_check_var(struct fb_var
 static int viafb_set_par(struct fb_info *info)
 {
 	struct viafb_par *viapar = info->par;
-	int vmode_index;
-	int vmode_index1 = 0;
+	struct VideoModeTable *vmode_entry, *vmode_entry1 = NULL;
 	DEBUG_MSG(KERN_INFO "viafb_set_par!\n");
 
 	viapar->depth = fb_get_color_depth(&info->var, &info->fix);
 	viafb_update_device_setting(info->var.xres, info->var.yres,
 			      info->var.bits_per_pixel, viafb_refresh, 0);
 
-	vmode_index = viafb_get_mode_index(info->var.xres, info->var.yres);
-
+	vmode_entry = viafb_get_mode(info->var.xres, info->var.yres);
 	if (viafb_SAMM_ON == 1) {
 		DEBUG_MSG(KERN_INFO
 		"viafb_second_xres = %d, viafb_second_yres = %d, bpp = %d\n",
 			  viafb_second_xres, viafb_second_yres, viafb_bpp1);
-		vmode_index1 = viafb_get_mode_index(viafb_second_xres,
+		vmode_entry1 = viafb_get_mode(viafb_second_xres,
 			viafb_second_yres);
-		DEBUG_MSG(KERN_INFO "->viafb_SAMM_ON: index=%d\n",
-			vmode_index1);
 
 		viafb_update_device_setting(viafb_second_xres,
 			viafb_second_yres, viafb_bpp1, viafb_refresh1, 1);
 	}
 
-	if (vmode_index != VIA_RES_INVALID) {
+	if (vmode_entry) {
 		viafb_update_fix(info);
 		viafb_bpp = info->var.bits_per_pixel;
 		if (info->var.accel_flags & FB_ACCELF_TEXT)
 			info->flags &= ~FBINFO_HWACCEL_DISABLED;
 		else
 			info->flags |= FBINFO_HWACCEL_DISABLED;
-		viafb_setmode(vmode_index, info->var.xres, info->var.yres,
-			info->var.bits_per_pixel, vmode_index1,
-			viafb_second_xres, viafb_second_yres, viafb_bpp1);
+		viafb_setmode(vmode_entry, info->var.bits_per_pixel,
+			vmode_entry1, viafb_bpp1);
 	}
 
 	return 0;
@@ -1016,23 +1012,6 @@ static int viafb_sync(struct fb_info *in
 	return 0;
 }
 
-int viafb_get_mode_index(int hres, int vres)
-{
-	u32 i;
-	DEBUG_MSG(KERN_INFO "viafb_get_mode_index!\n");
-
-	for (i = 0; i < NUM_TOTAL_MODETABLE; i++)
-		if (CLE266Modes[i].mode_array &&
-			CLE266Modes[i].crtc[0].crtc.hor_addr == hres &&
-			CLE266Modes[i].crtc[0].crtc.ver_addr == vres)
-			break;
-
-	if (i == NUM_TOTAL_MODETABLE)
-		return VIA_RES_INVALID;
-
-	return CLE266Modes[i].ModeIndex;
-}
-
 static void check_available_device_to_enable(int device_id)
 {
 	int device_num = 0;
@@ -1848,7 +1827,7 @@ static int __devinit via_pci_probe(struc
 				   const struct pci_device_id *ent)
 {
 	u32 default_xres, default_yres;
-	int vmode_index;
+	struct VideoModeTable *vmode_entry;
 	u32 viafb_par_length;
 
 	DEBUG_MSG(KERN_INFO "VIAFB PCI Probe!!\n");
@@ -1927,9 +1906,7 @@ static int __devinit via_pci_probe(struc
 	}
 
 	parse_mode(viafb_mode, &default_xres, &default_yres);
-	vmode_index = viafb_get_mode_index(default_xres, default_yres);
-	DEBUG_MSG(KERN_INFO "0->index=%d\n", vmode_index);
-
+	vmode_entry = viafb_get_mode(default_xres, default_yres);
 	if (viafb_SAMM_ON == 1) {
 		parse_mode(viafb_mode1, &viafb_second_xres,
 			&viafb_second_yres);
diff -puN drivers/video/via/viafbdev.h~viafb-split-global-index-up drivers/video/via/viafbdev.h
--- a/drivers/video/via/viafbdev.h~viafb-split-global-index-up
+++ a/drivers/video/via/viafbdev.h
@@ -96,9 +96,6 @@ extern int viafb_memsize;
 extern int strict_strtoul(const char *cp, unsigned int base,
 	unsigned long *res);
 
-void viafb_fill_var_timing_info(struct fb_var_screeninfo *var, int refresh,
-			  int mode_index);
-int viafb_get_mode_index(int hres, int vres);
 u8 viafb_gpio_i2c_read_lvds(struct lvds_setting_information
 	*plvds_setting_info, struct lvds_chip_information
 	*plvds_chip_info, u8 index);
diff -puN drivers/video/via/viamode.c~viafb-split-global-index-up drivers/video/via/viamode.c
--- a/drivers/video/via/viamode.c~viafb-split-global-index-up
+++ a/drivers/video/via/viamode.c
@@ -412,7 +412,7 @@ struct io_reg PM1024x768[] = { {VIASR, 0
 };
 
 struct patch_table res_patch_table[] = {
-	{VIA_RES_1024X768, ARRAY_SIZE(PM1024x768), PM1024x768}
+	{ARRAY_SIZE(PM1024x768), PM1024x768}
 };
 
 /* struct VPITTable {
@@ -879,169 +879,151 @@ struct crt_mode_table CRTM2048x1536[] = 
 	 {2800, 2048, 2048, 752, 2200, 224, 1592, 1536, 1536, 56, 1539, 4} }
 };
 
-/* Video Mode Table */
-/* struct VideoModeTable {*/
-/*  int                               ModeIndex;*/
-/*  struct crt_mode_table             *crtc;*/
-/*  int                               mode_array;*/
-/* };*/
-struct VideoModeTable CLE266Modes[] = {
+struct VideoModeTable viafb_modes[] = {
 	/* Display : 480x640 (GTF) */
-	{VIA_RES_480X640, CRTM480x640, ARRAY_SIZE(CRTM480x640)},
+	{CRTM480x640, ARRAY_SIZE(CRTM480x640)},
 
 	/* Display : 640x480 */
-	{VIA_RES_640X480, CRTM640x480, ARRAY_SIZE(CRTM640x480)},
+	{CRTM640x480, ARRAY_SIZE(CRTM640x480)},
 
 	/* Display : 720x480 (GTF) */
-	{VIA_RES_720X480, CRTM720x480, ARRAY_SIZE(CRTM720x480)},
+	{CRTM720x480, ARRAY_SIZE(CRTM720x480)},
 
 	/* Display : 720x576 (GTF) */
-	{VIA_RES_720X576, CRTM720x576, ARRAY_SIZE(CRTM720x576)},
+	{CRTM720x576, ARRAY_SIZE(CRTM720x576)},
 
 	/* Display : 800x600 */
-	{VIA_RES_800X600, CRTM800x600, ARRAY_SIZE(CRTM800x600)},
+	{CRTM800x600, ARRAY_SIZE(CRTM800x600)},
 
 	/* Display : 800x480 (CVT) */
-	{VIA_RES_800X480, CRTM800x480, ARRAY_SIZE(CRTM800x480)},
+	{CRTM800x480, ARRAY_SIZE(CRTM800x480)},
 
 	/* Display : 848x480 (CVT) */
-	{VIA_RES_848X480, CRTM848x480, ARRAY_SIZE(CRTM848x480)},
+	{CRTM848x480, ARRAY_SIZE(CRTM848x480)},
 
 	/* Display : 852x480 (GTF) */
-	{VIA_RES_856X480, CRTM852x480, ARRAY_SIZE(CRTM852x480)},
+	{CRTM852x480, ARRAY_SIZE(CRTM852x480)},
 
 	/* Display : 1024x512 (GTF) */
-	{VIA_RES_1024X512, CRTM1024x512, ARRAY_SIZE(CRTM1024x512)},
+	{CRTM1024x512, ARRAY_SIZE(CRTM1024x512)},
 
 	/* Display : 1024x600 */
-	{VIA_RES_1024X600, CRTM1024x600, ARRAY_SIZE(CRTM1024x600)},
-
-	/* Display : 1024x576 (GTF) */
-	/*{ VIA_RES_1024X576, CRTM1024x576, ARRAY_SIZE(CRTM1024x576)}, */
+	{CRTM1024x600, ARRAY_SIZE(CRTM1024x600)},
 
 	/* Display : 1024x768 */
-	{VIA_RES_1024X768, CRTM1024x768, ARRAY_SIZE(CRTM1024x768)},
+	{CRTM1024x768, ARRAY_SIZE(CRTM1024x768)},
 
 	/* Display : 1152x864 */
-	{VIA_RES_1152X864, CRTM1152x864, ARRAY_SIZE(CRTM1152x864)},
+	{CRTM1152x864, ARRAY_SIZE(CRTM1152x864)},
 
 	/* Display : 1280x768 (GTF) */
-	{VIA_RES_1280X768, CRTM1280x768, ARRAY_SIZE(CRTM1280x768)},
+	{CRTM1280x768, ARRAY_SIZE(CRTM1280x768)},
 
 	/* Display : 960x600 (CVT) */
-	{VIA_RES_960X600, CRTM960x600, ARRAY_SIZE(CRTM960x600)},
+	{CRTM960x600, ARRAY_SIZE(CRTM960x600)},
 
 	/* Display : 1000x600 (GTF) */
-	{VIA_RES_1000X600, CRTM1000x600, ARRAY_SIZE(CRTM1000x600)},
+	{CRTM1000x600, ARRAY_SIZE(CRTM1000x600)},
 
 	/* Display : 1024x576 (GTF) */
-	{VIA_RES_1024X576, CRTM1024x576, ARRAY_SIZE(CRTM1024x576)},
+	{CRTM1024x576, ARRAY_SIZE(CRTM1024x576)},
 
 	/* Display : 1088x612 (GTF) */
-	{VIA_RES_1088X612, CRTM1088x612, ARRAY_SIZE(CRTM1088x612)},
+	{CRTM1088x612, ARRAY_SIZE(CRTM1088x612)},
 
 	/* Display : 1152x720 (CVT) */
-	{VIA_RES_1152X720, CRTM1152x720, ARRAY_SIZE(CRTM1152x720)},
+	{CRTM1152x720, ARRAY_SIZE(CRTM1152x720)},
 
 	/* Display : 1200x720 (GTF) */
-	{VIA_RES_1200X720, CRTM1200x720, ARRAY_SIZE(CRTM1200x720)},
+	{CRTM1200x720, ARRAY_SIZE(CRTM1200x720)},
 
 	/* Display : 1280x600 (GTF) */
-	{VIA_RES_1280X600, CRTM1280x600, ARRAY_SIZE(CRTM1280x600)},
+	{CRTM1280x600, ARRAY_SIZE(CRTM1280x600)},
 
 	/* Display : 1280x800 (CVT) */
-	{VIA_RES_1280X800, CRTM1280x800, ARRAY_SIZE(CRTM1280x800)},
-
-	/* Display : 1280x800 (GTF) */
-	/*{ M1280x800, CRTM1280x800, ARRAY_SIZE(CRTM1280x800)}, */
+	{CRTM1280x800, ARRAY_SIZE(CRTM1280x800)},
 
 	/* Display : 1280x960 */
-	{VIA_RES_1280X960, CRTM1280x960, ARRAY_SIZE(CRTM1280x960)},
+	{CRTM1280x960, ARRAY_SIZE(CRTM1280x960)},
 
 	/* Display : 1280x1024 */
-	{VIA_RES_1280X1024, CRTM1280x1024, ARRAY_SIZE(CRTM1280x1024)},
+	{CRTM1280x1024, ARRAY_SIZE(CRTM1280x1024)},
 
 	/* Display : 1360x768 (CVT) */
-	{VIA_RES_1360X768, CRTM1360x768, ARRAY_SIZE(CRTM1360x768)},
-
-	/* Display : 1360x768 (CVT Reduce Blanking) */
-	{VIA_RES_1360X768_RB, CRTM1360x768_RB,
-	 ARRAY_SIZE(CRTM1360x768_RB)},
+	{CRTM1360x768, ARRAY_SIZE(CRTM1360x768)},
 
 	/* Display : 1366x768 */
-	{VIA_RES_1366X768, CRTM1366x768, ARRAY_SIZE(CRTM1366x768)},
+	{CRTM1366x768, ARRAY_SIZE(CRTM1366x768)},
 
 	/* Display : 1368x768 (GTF) */
-	/*{ M1368x768,CRTM1368x768,ARRAY_SIZE(CRTM1368x768)}, */
-	/* Display : 1368x768 (GTF) */
-	{VIA_RES_1368X768, CRTM1368x768, ARRAY_SIZE(CRTM1368x768)},
+	{CRTM1368x768, ARRAY_SIZE(CRTM1368x768)},
 
 	/* Display : 1440x900 (CVT) */
-	{VIA_RES_1440X900, CRTM1440x900, ARRAY_SIZE(CRTM1440x900)},
-
-	/* Display : 1440x900 (CVT Reduce Blanking) */
-	{VIA_RES_1440X900_RB, CRTM1440x900_RB,
-	 ARRAY_SIZE(CRTM1440x900_RB)},
+	{CRTM1440x900, ARRAY_SIZE(CRTM1440x900)},
 
 	/* Display : 1440x1050 (GTF) */
-	{VIA_RES_1440X1050, CRTM1440x1050, ARRAY_SIZE(CRTM1440x1050)},
-
-	/* Display : 1400x1050 (CVT Reduce Blanking) */
-	{VIA_RES_1400X1050_RB, CRTM1400x1050_RB,
-	 ARRAY_SIZE(CRTM1400x1050_RB)},
+	{CRTM1440x1050, ARRAY_SIZE(CRTM1440x1050)},
 
 	/* Display : 1600x900 (CVT) */
-	{VIA_RES_1600X900, CRTM1600x900, ARRAY_SIZE(CRTM1600x900)},
-
-	/* Display : 1600x900 (CVT Reduce Blanking) */
-	{VIA_RES_1600X900_RB, CRTM1600x900_RB,
-	 ARRAY_SIZE(CRTM1600x900_RB)},
+	{CRTM1600x900, ARRAY_SIZE(CRTM1600x900)},
 
 	/* Display : 1600x1024 (GTF) */
-	{VIA_RES_1600X1024, CRTM1600x1024, ARRAY_SIZE(CRTM1600x1024)},
+	{CRTM1600x1024, ARRAY_SIZE(CRTM1600x1024)},
 
 	/* Display : 1600x1200 */
-	{VIA_RES_1600X1200, CRTM1600x1200, ARRAY_SIZE(CRTM1600x1200)},
+	{CRTM1600x1200, ARRAY_SIZE(CRTM1600x1200)},
 
 	/* Display : 1680x1050 (CVT) */
-	{VIA_RES_1680X1050, CRTM1680x1050, ARRAY_SIZE(CRTM1680x1050)},
-
-	/* Display : 1680x1050 (CVT Reduce Blanking) */
-	{VIA_RES_1680X1050_RB, CRTM1680x1050_RB,
-	 ARRAY_SIZE(CRTM1680x1050_RB)},
+	{CRTM1680x1050, ARRAY_SIZE(CRTM1680x1050)},
 
 	/* Display : 1792x1344 (DMT) */
-	{VIA_RES_1792X1344, CRTM1792x1344, ARRAY_SIZE(CRTM1792x1344)},
+	{CRTM1792x1344, ARRAY_SIZE(CRTM1792x1344)},
 
 	/* Display : 1856x1392 (DMT) */
-	{VIA_RES_1856X1392, CRTM1856x1392, ARRAY_SIZE(CRTM1856x1392)},
+	{CRTM1856x1392, ARRAY_SIZE(CRTM1856x1392)},
 
 	/* Display : 1920x1440 */
-	{VIA_RES_1920X1440, CRTM1920x1440, ARRAY_SIZE(CRTM1920x1440)},
+	{CRTM1920x1440, ARRAY_SIZE(CRTM1920x1440)},
 
 	/* Display : 2048x1536 */
-	{VIA_RES_2048X1536, CRTM2048x1536, ARRAY_SIZE(CRTM2048x1536)},
+	{CRTM2048x1536, ARRAY_SIZE(CRTM2048x1536)},
 
 	/* Display : 1280x720 */
-	{VIA_RES_1280X720, CRTM1280x720, ARRAY_SIZE(CRTM1280x720)},
+	{CRTM1280x720, ARRAY_SIZE(CRTM1280x720)},
 
 	/* Display : 1920x1080 (CVT) */
-	{VIA_RES_1920X1080, CRTM1920x1080, ARRAY_SIZE(CRTM1920x1080)},
-
-	/* Display : 1920x1080 (CVT Reduce Blanking) */
-	{VIA_RES_1920X1080_RB, CRTM1920x1080_RB,
-	 ARRAY_SIZE(CRTM1920x1080_RB)},
+	{CRTM1920x1080, ARRAY_SIZE(CRTM1920x1080)},
 
 	/* Display : 1920x1200 (CVT) */
-	{VIA_RES_1920X1200, CRTM1920x1200, ARRAY_SIZE(CRTM1920x1200)},
-
-	/* Display : 1920x1200 (CVT Reduce Blanking) */
-	{VIA_RES_1920X1200_RB, CRTM1920x1200_RB,
-	 ARRAY_SIZE(CRTM1920x1200_RB)},
+	{CRTM1920x1200, ARRAY_SIZE(CRTM1920x1200)},
 
 	/* Display : 1400x1050 (CVT) */
-	{VIA_RES_1400X1050, CRTM1400x1050, ARRAY_SIZE(CRTM1400x1050)}
+	{CRTM1400x1050, ARRAY_SIZE(CRTM1400x1050)}
 };
+
+struct VideoModeTable viafb_rb_modes[] = {
+	/* Display : 1360x768 (CVT Reduce Blanking) */
+	{CRTM1360x768_RB, ARRAY_SIZE(CRTM1360x768_RB)},
+
+	/* Display : 1440x900 (CVT Reduce Blanking) */
+	{CRTM1440x900_RB, ARRAY_SIZE(CRTM1440x900_RB)},
+
+	/* Display : 1400x1050 (CVT Reduce Blanking) */
+	{CRTM1400x1050_RB, ARRAY_SIZE(CRTM1400x1050_RB)},
+
+	/* Display : 1600x900 (CVT Reduce Blanking) */
+	{CRTM1600x900_RB, ARRAY_SIZE(CRTM1600x900_RB)},
+
+	/* Display : 1680x1050 (CVT Reduce Blanking) */
+	{CRTM1680x1050_RB, ARRAY_SIZE(CRTM1680x1050_RB)},
+
+	/* Display : 1920x1080 (CVT Reduce Blanking) */
+	{CRTM1920x1080_RB, ARRAY_SIZE(CRTM1920x1080_RB)},
+
+	/* Display : 1920x1200 (CVT Reduce Blanking) */
+	{CRTM1920x1200_RB, ARRAY_SIZE(CRTM1920x1200_RB)}
+};
+
 struct crt_mode_table CEAM1280x720[] = {
 	{REFRESH_60, CLK_74_270M, M1280X720_CEA_R60_HSP,
 	 M1280X720_CEA_R60_VSP,
@@ -1056,8 +1038,8 @@ struct crt_mode_table CEAM1920x1080[] = 
 };
 struct VideoModeTable CEA_HDMI_Modes[] = {
 	/* Display : 1280x720 */
-	{VIA_RES_1280X720, CEAM1280x720, ARRAY_SIZE(CEAM1280x720)},
-	{VIA_RES_1920X1080, CEAM1920x1080, ARRAY_SIZE(CEAM1920x1080)}
+	{CEAM1280x720, ARRAY_SIZE(CEAM1280x720)},
+	{CEAM1920x1080, ARRAY_SIZE(CEAM1920x1080)}
 };
 
 int NUM_TOTAL_RES_MAP_REFRESH = ARRAY_SIZE(res_map_refresh_tbl);
@@ -1069,4 +1051,28 @@ int NUM_TOTAL_CX700_ModeXregs = ARRAY_SI
 int NUM_TOTAL_VX855_ModeXregs = ARRAY_SIZE(VX855_ModeXregs);
 int NUM_TOTAL_CLE266_ModeXregs = ARRAY_SIZE(CLE266_ModeXregs);
 int NUM_TOTAL_PATCH_MODE = ARRAY_SIZE(res_patch_table);
-int NUM_TOTAL_MODETABLE = ARRAY_SIZE(CLE266Modes);
+
+
+struct VideoModeTable *viafb_get_mode(int hres, int vres)
+{
+	u32 i;
+	for (i = 0; i < ARRAY_SIZE(viafb_modes); i++)
+		if (viafb_modes[i].mode_array &&
+			viafb_modes[i].crtc[0].crtc.hor_addr == hres &&
+			viafb_modes[i].crtc[0].crtc.ver_addr == vres)
+			return &viafb_modes[i];
+
+	return NULL;
+}
+
+struct VideoModeTable *viafb_get_rb_mode(int hres, int vres)
+{
+	u32 i;
+	for (i = 0; i < ARRAY_SIZE(viafb_rb_modes); i++)
+		if (viafb_rb_modes[i].mode_array &&
+			viafb_rb_modes[i].crtc[0].crtc.hor_addr == hres &&
+			viafb_rb_modes[i].crtc[0].crtc.ver_addr == vres)
+			return &viafb_rb_modes[i];
+
+	return NULL;
+}
diff -puN drivers/video/via/viamode.h~viafb-split-global-index-up drivers/video/via/viamode.h
--- a/drivers/video/via/viamode.h~viafb-split-global-index-up
+++ a/drivers/video/via/viamode.h
@@ -32,13 +32,11 @@ struct VPITTable {
 };
 
 struct VideoModeTable {
-	int ModeIndex;
 	struct crt_mode_table *crtc;
 	int mode_array;
 };
 
 struct patch_table {
-	int mode_index;
 	int table_length;
 	struct io_reg *io_reg_table;
 };
@@ -59,13 +57,11 @@ extern int NUM_TOTAL_CX700_ModeXregs;
 extern int NUM_TOTAL_VX855_ModeXregs;
 extern int NUM_TOTAL_CLE266_ModeXregs;
 extern int NUM_TOTAL_PATCH_MODE;
-extern int NUM_TOTAL_MODETABLE;
 
 /********************/
 /* Mode Table       */
 /********************/
 
-extern struct VideoModeTable CLE266Modes[];
 extern struct crt_mode_table CEAM1280x720[];
 extern struct crt_mode_table CEAM1920x1080[];
 extern struct VideoModeTable CEA_HDMI_Modes[];
@@ -81,4 +77,8 @@ extern struct io_reg CLE266_ModeXregs[];
 extern struct io_reg PM1024x768[];
 extern struct patch_table res_patch_table[];
 extern struct VPITTable VPIT;
+
+struct VideoModeTable *viafb_get_mode(int hres, int vres);
+struct VideoModeTable *viafb_get_rb_mode(int hres, int vres);
+
 #endif /* __VIAMODE_H__ */
_

Patches currently in -mm which might be from FlorianSchandinat@gmx.de are

origin.patch

