From: akpm@linux-foundation.org
Subject: [merged] viafb-improve-pitch-handling.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:02:16 -0700
Message-ID: <200909232002.n8NK2GKR016876@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51525 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752865AbZIWUKP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:10:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn, corbet@lwn.net, laforge@gnumonks.org, mm-commits@vger.kernel.org


The patch titled
     viafb: improve pitch handling
has been removed from the -mm tree.  Its filename was
     viafb-improve-pitch-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb: improve pitch handling
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

Split the pitch handling up and replaces the calculation from virtual xres
and bpp with fix.line_length which already contains the pitch and does not
add any constrains for the virtual resolution.

Also add a bit to the second pitch which the documentation mentions but
which was ignored by the driver.

Although it is a bit unclear what the right pitch for some LCD modes is
this patch should have no negative runtime impact.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Harald Welte <laforge@gnumonks.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/hw.c       |   73 ++++++++++-----------------------
 drivers/video/via/hw.h       |   33 +-------------
 drivers/video/via/lcd.c      |   10 ----
 drivers/video/via/viafbdev.c |    3 -
 drivers/video/via/viafbdev.h |    1 
 5 files changed, 27 insertions(+), 93 deletions(-)

diff -puN drivers/video/via/hw.c~viafb-improve-pitch-handling drivers/video/via/hw.c
--- a/drivers/video/via/hw.c~viafb-improve-pitch-handling
+++ a/drivers/video/via/hw.c
@@ -36,13 +36,6 @@ static const struct pci_device_id_info p
 	{0, 0, 0}
 };
 
-struct offset offset_reg = {
-	/* IGA1 Offset Register */
-	{IGA1_OFFSET_REG_NUM, {{CR13, 0, 7}, {CR35, 5, 7} } },
-	/* IGA2 Offset Register */
-	{IGA2_OFFSET_REG_NUM, {{CR66, 0, 7}, {CR67, 0, 1} } }
-};
-
 static struct pll_map pll_value[] = {
 	{CLK_25_175M, CLE266_PLL_25_175M, K800_PLL_25_175M, CX700_25_175M},
 	{CLK_29_581M, CLE266_PLL_29_581M, K800_PLL_29_581M, CX700_29_581M},
@@ -648,6 +641,26 @@ void viafb_set_secondary_address(u32 add
 	viafb_write_reg_mask(CRA3, VIACR, (addr >> 26) & 0x07, 0x07);
 }
 
+void viafb_set_primary_pitch(u32 pitch)
+{
+	DEBUG_MSG(KERN_DEBUG "viafb_set_primary_pitch(0x%08X)\n", pitch);
+	/* spec does not say that first adapter skips 3 bits but old
+	 * code did it and seems to be reasonable in analogy to 2nd adapter
+	 */
+	pitch = pitch >> 3;
+	viafb_write_reg(0x13, VIACR, pitch & 0xFF);
+	viafb_write_reg_mask(0x35, VIACR, (pitch >> (8 - 5)) & 0xE0, 0xE0);
+}
+
+void viafb_set_secondary_pitch(u32 pitch)
+{
+	DEBUG_MSG(KERN_DEBUG "viafb_set_secondary_pitch(0x%08X)\n", pitch);
+	pitch = pitch >> 3;
+	viafb_write_reg(0x66, VIACR, pitch & 0xFF);
+	viafb_write_reg_mask(0x67, VIACR, (pitch >> 8) & 0x03, 0x03);
+	viafb_write_reg_mask(0x71, VIACR, (pitch >> (10 - 7)) & 0x80, 0x80);
+}
+
 void viafb_set_output_path(int device, int set_iga, int output_interface)
 {
 	switch (device) {
@@ -1076,30 +1089,6 @@ void viafb_write_regx(struct io_reg RegT
 	}
 }
 
-void viafb_load_offset_reg(int h_addr, int bpp_byte, int set_iga)
-{
-	int reg_value;
-	int viafb_load_reg_num;
-	struct io_register *reg;
-
-	switch (set_iga) {
-	case IGA1_IGA2:
-	case IGA1:
-		reg_value = IGA1_OFFSET_FORMULA(h_addr, bpp_byte);
-		viafb_load_reg_num = offset_reg.iga1_offset_reg.reg_num;
-		reg = offset_reg.iga1_offset_reg.reg;
-		viafb_load_reg(reg_value, viafb_load_reg_num, reg, VIACR);
-		if (set_iga == IGA1)
-			break;
-	case IGA2:
-		reg_value = IGA2_OFFSET_FORMULA(h_addr, bpp_byte);
-		viafb_load_reg_num = offset_reg.iga2_offset_reg.reg_num;
-		reg = offset_reg.iga2_offset_reg.reg;
-		viafb_load_reg(reg_value, viafb_load_reg_num, reg, VIACR);
-		break;
-	}
-}
-
 void viafb_load_fetch_count_reg(int h_addr, int bpp_byte, int set_iga)
 {
 	int reg_value;
@@ -1869,7 +1858,6 @@ void viafb_fill_crtc_timing(struct crt_m
 	load_fix_bit_crtc_reg();
 	viafb_lock_crt();
 	viafb_write_reg_mask(CR17, VIACR, 0x80, BIT7);
-	viafb_load_offset_reg(h_addr, bpp_byte, set_iga);
 	viafb_load_fetch_count_reg(h_addr, bpp_byte, set_iga);
 
 	/* load FIFO */
@@ -2322,6 +2310,9 @@ int viafb_setmode(int vmode_index, int h
 		}
 	}
 
+	viafb_set_primary_pitch(viafbinfo->fix.line_length);
+	viafb_set_secondary_pitch(viafb_dual_fb ? viafbinfo1->fix.line_length
+		: viafbinfo->fix.line_length);
 	/* Update Refresh Rate Setting */
 
 	/* Clear On Screen */
@@ -2738,24 +2729,6 @@ void viafb_set_dpa_gfx(int output_interf
 	}
 }
 
-void viafb_memory_pitch_patch(struct fb_info *info)
-{
-	if (info->var.xres != info->var.xres_virtual) {
-		viafb_load_offset_reg(info->var.xres_virtual,
-				info->var.bits_per_pixel >> 3, IGA1);
-
-		if (viafb_SAMM_ON) {
-			viafb_load_offset_reg(viafb_second_virtual_xres,
-				viafb_bpp1 >> 3,
-					IGA2);
-		} else {
-			viafb_load_offset_reg(info->var.xres_virtual,
-					info->var.bits_per_pixel >> 3, IGA2);
-		}
-
-	}
-}
-
 /*According var's xres, yres fill var's other timing information*/
 void viafb_fill_var_timing_info(struct fb_var_screeninfo *var, int refresh,
 			  int mode_index)
diff -puN drivers/video/via/hw.h~viafb-improve-pitch-handling drivers/video/via/hw.h
--- a/drivers/video/via/hw.h~viafb-improve-pitch-handling
+++ a/drivers/video/via/hw.h
@@ -147,14 +147,8 @@ is reserved, so it may have problem to s
 /* location: {CR5F,0,4} */
 #define IGA2_VER_SYNC_END_REG_NUM       1
 
-/* Define Offset and Fetch Count Register*/
+/* Define Fetch Count Register*/
 
-/* location: {CR13,0,7},{CR35,5,7} */
-#define IGA1_OFFSET_REG_NUM             2
-/* 8 bytes alignment. */
-#define IGA1_OFFSER_ALIGN_BYTE          8
-/* x: H resolution, y: color depth */
-#define IGA1_OFFSET_FORMULA(x, y)        ((x*y)/IGA1_OFFSER_ALIGN_BYTE)
 /* location: {SR1C,0,7},{SR1D,0,1} */
 #define IGA1_FETCH_COUNT_REG_NUM        2
 /* 16 bytes alignment. */
@@ -164,11 +158,6 @@ is reserved, so it may have problem to s
 #define IGA1_FETCH_COUNT_FORMULA(x, y)   \
 	(((x*y)/IGA1_FETCH_COUNT_ALIGN_BYTE) + IGA1_FETCH_COUNT_PATCH_VALUE)
 
-/* location: {CR66,0,7},{CR67,0,1} */
-#define IGA2_OFFSET_REG_NUM             2
-#define IGA2_OFFSET_ALIGN_BYTE          8
-/* x: H resolution, y: color depth */
-#define IGA2_OFFSET_FORMULA(x, y)        ((x*y)/IGA2_OFFSET_ALIGN_BYTE)
 /* location: {CR65,0,7},{CR67,2,3} */
 #define IGA2_FETCH_COUNT_REG_NUM        2
 #define IGA2_FETCH_COUNT_ALIGN_BYTE     16
@@ -617,23 +606,6 @@ struct iga2_ver_sync_end {
 	struct io_register reg[IGA2_VER_SYNC_END_REG_NUM];
 };
 
-/* IGA1 Offset Register */
-struct iga1_offset {
-	int reg_num;
-	struct io_register reg[IGA1_OFFSET_REG_NUM];
-};
-
-/* IGA2 Offset Register */
-struct iga2_offset {
-	int reg_num;
-	struct io_register reg[IGA2_OFFSET_REG_NUM];
-};
-
-struct offset {
-	struct iga1_offset iga1_offset_reg;
-	struct iga2_offset iga2_offset_reg;
-};
-
 /* IGA1 Fetch Count Register */
 struct iga1_fetch_count {
 	int reg_num;
@@ -904,7 +876,6 @@ void viafb_write_reg(u8 index, u16 io_po
 u8 viafb_read_reg(int io_port, u8 index);
 void viafb_lock_crt(void);
 void viafb_unlock_crt(void);
-void viafb_load_offset_reg(int h_addr, int bpp_byte, int set_iga);
 void viafb_load_fetch_count_reg(int h_addr, int bpp_byte, int set_iga);
 void viafb_write_regx(struct io_reg RegTable[], int ItemNum);
 struct VideoModeTable *viafb_get_modetbl_pointer(int Index);
@@ -928,6 +899,8 @@ void viafb_get_mmio_info(unsigned long *
 void viafb_set_iga_path(void);
 void viafb_set_primary_address(u32 addr);
 void viafb_set_secondary_address(u32 addr);
+void viafb_set_primary_pitch(u32 pitch);
+void viafb_set_secondary_pitch(u32 pitch);
 void viafb_get_fb_info(unsigned int *fb_base, unsigned int *fb_len);
 
 #endif /* __HW_H__ */
diff -puN drivers/video/via/lcd.c~viafb-improve-pitch-handling drivers/video/via/lcd.c
--- a/drivers/video/via/lcd.c~viafb-improve-pitch-handling
+++ a/drivers/video/via/lcd.c
@@ -952,13 +952,10 @@ void viafb_lcd_set_mode(struct crt_mode_
 	int video_index = plvds_setting_info->lcd_panel_size;
 	int set_iga = plvds_setting_info->iga_path;
 	int mode_bpp = plvds_setting_info->bpp;
-	int viafb_load_reg_num = 0;
-	int reg_value = 0;
 	int set_hres, set_vres;
 	int panel_hres, panel_vres;
 	u32 pll_D_N;
 	int offset;
-	struct io_register *reg = NULL;
 	struct display_timing mode_crt_reg, panel_crt_reg;
 	struct crt_mode_table *panel_crt_table = NULL;
 	struct VideoModeTable *vmode_tbl = NULL;
@@ -1038,16 +1035,11 @@ void viafb_lcd_set_mode(struct crt_mode_
 		}
 
 		/* Offset for simultaneous */
-		reg_value = offset;
-		viafb_load_reg_num = offset_reg.iga2_offset_reg.reg_num;
-		reg = offset_reg.iga2_offset_reg.reg;
-		viafb_load_reg(reg_value, viafb_load_reg_num, reg, VIACR);
+		viafb_set_secondary_pitch(offset << 3);
 		DEBUG_MSG(KERN_INFO "viafb_load_reg!!\n");
 		viafb_load_fetch_count_reg(set_hres, 4, IGA2);
 		/* Fetch count for simultaneous */
 	} else {		/* SAMM */
-		/* Offset for IGA2 only */
-		viafb_load_offset_reg(set_hres, mode_bpp / 8, set_iga);
 		/* Fetch count for IGA2 only */
 		viafb_load_fetch_count_reg(set_hres, mode_bpp / 8, set_iga);
 
diff -puN drivers/video/via/viafbdev.c~viafb-improve-pitch-handling drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-improve-pitch-handling
+++ a/drivers/video/via/viafbdev.c
@@ -175,9 +175,6 @@ static int viafb_set_par(struct fb_info 
 			info->var.bits_per_pixel, vmode_index1,
 			viafb_second_xres, viafb_second_yres, viafb_bpp1);
 
-		/*We should set memory offset according virtual_x */
-		/*Fix me:put this function into viafb_setmode */
-		viafb_memory_pitch_patch(info);
 		viafb_update_fix(info);
 		viafb_bpp = info->var.bits_per_pixel;
 		/* Update viafb_accel, it is necessary to our 2D accelerate */
diff -puN drivers/video/via/viafbdev.h~viafb-improve-pitch-handling drivers/video/via/viafbdev.h
--- a/drivers/video/via/viafbdev.h~viafb-improve-pitch-handling
+++ a/drivers/video/via/viafbdev.h
@@ -97,7 +97,6 @@ extern int viafb_memsize;
 extern int strict_strtoul(const char *cp, unsigned int base,
 	unsigned long *res);
 
-void viafb_memory_pitch_patch(struct fb_info *info);
 void viafb_fill_var_timing_info(struct fb_var_screeninfo *var, int refresh,
 			  int mode_index);
 int viafb_get_mode_index(int hres, int vres);
_

Patches currently in -mm which might be from FlorianSchandinat@gmx.de are

origin.patch

