From: akpm@linux-foundation.org
Subject: + viafb-fix-rmmod-bug.patch added to -mm tree
Date: Tue, 28 Jul 2009 14:34:23 -0700
Message-ID: <200907282134.n6SLYNkL031576@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57689 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755359AbZG1Ve2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Jul 2009 17:34:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn


The patch titled
     viafb: fix rmmod bug
has been added to the -mm tree.  Its filename is
     viafb-fix-rmmod-bug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb: fix rmmod bug
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

This fixes a bug caused by changing pointers (viafb_mode, viafb_mode1)
assigned by module_param.  It reduces driver complexity by not needlessly
changing these vars as they are only read once and removing now
superfluous code.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Joseph Chan <JosephChan@via.com.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/hw.c       |    4 -
 drivers/video/via/lcd.c      |   15 ----
 drivers/video/via/viafbdev.c |  101 +++++++++++++++------------------
 drivers/video/via/viafbdev.h |    3 
 4 files changed, 53 insertions(+), 70 deletions(-)

diff -puN drivers/video/via/hw.c~viafb-fix-rmmod-bug drivers/video/via/hw.c
--- a/drivers/video/via/hw.c~viafb-fix-rmmod-bug
+++ a/drivers/video/via/hw.c
@@ -2407,14 +2407,14 @@ int viafb_setmode(int vmode_index, int h
 			viafb_dvi_set_mode(viafb_get_mode_index
 				     (viaparinfo->tmds_setting_info->h_active,
 				      viaparinfo->tmds_setting_info->
-				      v_active, 1),
+				      v_active),
 				     video_bpp1, viaparinfo->
 				     tmds_setting_info->iga_path);
 		} else {
 			viafb_dvi_set_mode(viafb_get_mode_index
 				     (viaparinfo->tmds_setting_info->h_active,
 				      viaparinfo->
-				      tmds_setting_info->v_active, 0),
+				      tmds_setting_info->v_active),
 				     video_bpp, viaparinfo->
 				     tmds_setting_info->iga_path);
 		}
diff -puN drivers/video/via/lcd.c~viafb-fix-rmmod-bug drivers/video/via/lcd.c
--- a/drivers/video/via/lcd.c~viafb-fix-rmmod-bug
+++ a/drivers/video/via/lcd.c
@@ -580,10 +580,7 @@ static void load_lcd_k400_patch_tbl(int 
 	int reg_num = 0;
 	struct io_reg *lcd_patch_reg = NULL;
 
-	if (viaparinfo->lvds_setting_info->iga_path == IGA2)
-		vmode_index = viafb_get_mode_index(set_hres, set_vres, 1);
-	else
-		vmode_index = viafb_get_mode_index(set_hres, set_vres, 0);
+	vmode_index = viafb_get_mode_index(set_hres, set_vres);
 	switch (panel_id) {
 		/* LCD 800x600 */
 	case LCD_PANEL_ID1_800X600:
@@ -761,10 +758,7 @@ static void load_lcd_p880_patch_tbl(int 
 	int reg_num = 0;
 	struct io_reg *lcd_patch_reg = NULL;
 
-	if (viaparinfo->lvds_setting_info->iga_path == IGA2)
-		vmode_index = viafb_get_mode_index(set_hres, set_vres, 1);
-	else
-		vmode_index = viafb_get_mode_index(set_hres, set_vres, 0);
+	vmode_index = viafb_get_mode_index(set_hres, set_vres);
 
 	switch (panel_id) {
 	case LCD_PANEL_ID5_1400X1050:
@@ -832,10 +826,7 @@ static void load_lcd_patch_regs(int set_
 {
 	int vmode_index;
 
-	if (viaparinfo->lvds_setting_info->iga_path == IGA2)
-		vmode_index = viafb_get_mode_index(set_hres, set_vres, 1);
-	else
-		vmode_index = viafb_get_mode_index(set_hres, set_vres, 0);
+	vmode_index = viafb_get_mode_index(set_hres, set_vres);
 
 	viafb_unlock_crt();
 
diff -puN drivers/video/via/viafbdev.c~viafb-fix-rmmod-bug drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-fix-rmmod-bug
+++ a/drivers/video/via/viafbdev.c
@@ -32,7 +32,6 @@ static u32 pseudo_pal[17];
 /* video mode */
 static char *viafb_mode = "640x480";
 static char *viafb_mode1 = "640x480";
-static int viafb_resMode = VIA_RES_640X480;
 
 /* Added for specifying active devices.*/
 char *viafb_active_dev = "";
@@ -56,47 +55,47 @@ static void viafb_get_video_device(u32 *
 
 /* Mode information */
 static const struct viafb_modeinfo viafb_modentry[] = {
-	{480, 640, VIA_RES_480X640, "480x640"},
-	{640, 480, VIA_RES_640X480, "640x480"},
-	{800, 480, VIA_RES_800X480, "800x480"},
-	{800, 600, VIA_RES_800X600, "800x600"},
-	{1024, 768, VIA_RES_1024X768, "1024x768"},
-	{1152, 864, VIA_RES_1152X864, "1152x864"},
-	{1280, 1024, VIA_RES_1280X1024, "1280x1024"},
-	{1600, 1200, VIA_RES_1600X1200, "1600x1200"},
-	{1440, 1050, VIA_RES_1440X1050, "1440x1050"},
-	{1280, 768, VIA_RES_1280X768, "1280x768"},
-	{1280, 800, VIA_RES_1280X800, "1280x800"},
-	{1280, 960, VIA_RES_1280X960, "1280x960"},
-	{1920, 1440, VIA_RES_1920X1440, "1920x1440"},
-	{848, 480, VIA_RES_848X480, "848x480"},
-	{1400, 1050, VIA_RES_1400X1050, "1400x1050"},
-	{720, 480, VIA_RES_720X480, "720x480"},
-	{720, 576, VIA_RES_720X576, "720x576"},
-	{1024, 512, VIA_RES_1024X512, "1024x512"},
-	{1024, 576, VIA_RES_1024X576, "1024x576"},
-	{1024, 600, VIA_RES_1024X600, "1024x600"},
-	{1280, 720, VIA_RES_1280X720, "1280x720"},
-	{1920, 1080, VIA_RES_1920X1080, "1920x1080"},
-	{1366, 768, VIA_RES_1368X768, "1368x768"},
-	{1680, 1050, VIA_RES_1680X1050, "1680x1050"},
-	{960, 600, VIA_RES_960X600, "960x600"},
-	{1000, 600, VIA_RES_1000X600, "1000x600"},
-	{1024, 576, VIA_RES_1024X576, "1024x576"},
-	{1024, 600, VIA_RES_1024X600, "1024x600"},
-	{1088, 612, VIA_RES_1088X612, "1088x612"},
-	{1152, 720, VIA_RES_1152X720, "1152x720"},
-	{1200, 720, VIA_RES_1200X720, "1200x720"},
-	{1280, 600, VIA_RES_1280X600, "1280x600"},
-	{1360, 768, VIA_RES_1360X768, "1360x768"},
-	{1440, 900, VIA_RES_1440X900, "1440x900"},
-	{1600, 900, VIA_RES_1600X900, "1600x900"},
-	{1600, 1024, VIA_RES_1600X1024, "1600x1024"},
-	{1792, 1344, VIA_RES_1792X1344, "1792x1344"},
-	{1856, 1392, VIA_RES_1856X1392, "1856x1392"},
-	{1920, 1200, VIA_RES_1920X1200, "1920x1200"},
-	{2048, 1536, VIA_RES_2048X1536, "2048x1536"},
-	{0, 0, VIA_RES_INVALID, "640x480"}
+	{480, 640, VIA_RES_480X640},
+	{640, 480, VIA_RES_640X480},
+	{800, 480, VIA_RES_800X480},
+	{800, 600, VIA_RES_800X600},
+	{1024, 768, VIA_RES_1024X768},
+	{1152, 864, VIA_RES_1152X864},
+	{1280, 1024, VIA_RES_1280X1024},
+	{1600, 1200, VIA_RES_1600X1200},
+	{1440, 1050, VIA_RES_1440X1050},
+	{1280, 768, VIA_RES_1280X768,},
+	{1280, 800, VIA_RES_1280X800},
+	{1280, 960, VIA_RES_1280X960},
+	{1920, 1440, VIA_RES_1920X1440},
+	{848, 480, VIA_RES_848X480},
+	{1400, 1050, VIA_RES_1400X1050},
+	{720, 480, VIA_RES_720X480},
+	{720, 576, VIA_RES_720X576},
+	{1024, 512, VIA_RES_1024X512},
+	{1024, 576, VIA_RES_1024X576},
+	{1024, 600, VIA_RES_1024X600},
+	{1280, 720, VIA_RES_1280X720},
+	{1920, 1080, VIA_RES_1920X1080},
+	{1366, 768, VIA_RES_1368X768},
+	{1680, 1050, VIA_RES_1680X1050},
+	{960, 600, VIA_RES_960X600},
+	{1000, 600, VIA_RES_1000X600},
+	{1024, 576, VIA_RES_1024X576},
+	{1024, 600, VIA_RES_1024X600},
+	{1088, 612, VIA_RES_1088X612},
+	{1152, 720, VIA_RES_1152X720},
+	{1200, 720, VIA_RES_1200X720},
+	{1280, 600, VIA_RES_1280X600},
+	{1360, 768, VIA_RES_1360X768},
+	{1440, 900, VIA_RES_1440X900},
+	{1600, 900, VIA_RES_1600X900},
+	{1600, 1024, VIA_RES_1600X1024},
+	{1792, 1344, VIA_RES_1792X1344},
+	{1856, 1392, VIA_RES_1856X1392},
+	{1920, 1200, VIA_RES_1920X1200},
+	{2048, 1536, VIA_RES_2048X1536},
+	{0, 0, VIA_RES_INVALID}
 };
 
 static struct fb_ops viafb_ops;
@@ -177,7 +176,7 @@ static int viafb_check_var(struct fb_var
 	if (var->vmode & FB_VMODE_INTERLACED || var->vmode & FB_VMODE_DOUBLE)
 		return -EINVAL;
 
-	vmode_index = viafb_get_mode_index(var->xres, var->yres, 0);
+	vmode_index = viafb_get_mode_index(var->xres, var->yres);
 	if (vmode_index == VIA_RES_INVALID) {
 		DEBUG_MSG(KERN_INFO
 			  "viafb: Mode %dx%dx%d not supported!!\n",
@@ -233,14 +232,14 @@ static int viafb_set_par(struct fb_info 
 	viafb_update_device_setting(info->var.xres, info->var.yres,
 			      info->var.bits_per_pixel, viafb_refresh, 0);
 
-	vmode_index = viafb_get_mode_index(info->var.xres, info->var.yres, 0);
+	vmode_index = viafb_get_mode_index(info->var.xres, info->var.yres);
 
 	if (viafb_SAMM_ON == 1) {
 		DEBUG_MSG(KERN_INFO
 		"viafb_second_xres = %d, viafb_second_yres = %d, bpp = %d\n",
 			  viafb_second_xres, viafb_second_yres, viafb_bpp1);
 		vmode_index1 = viafb_get_mode_index(viafb_second_xres,
-			viafb_second_yres, 1);
+			viafb_second_yres);
 		DEBUG_MSG(KERN_INFO "->viafb_SAMM_ON: index=%d\n",
 			vmode_index1);
 
@@ -1262,7 +1261,7 @@ static int viafb_sync(struct fb_info *in
 	return 0;
 }
 
-int viafb_get_mode_index(int hres, int vres, int flag)
+int viafb_get_mode_index(int hres, int vres)
 {
 	u32 i;
 	DEBUG_MSG(KERN_INFO "viafb_get_mode_index!\n");
@@ -1272,13 +1271,7 @@ int viafb_get_mode_index(int hres, int v
 			viafb_modentry[i].yres == vres)
 			break;
 
-	viafb_resMode = viafb_modentry[i].mode_index;
-	if (flag)
-		viafb_mode1 = viafb_modentry[i].mode_res;
-	else
-		viafb_mode = viafb_modentry[i].mode_res;
-
-	return viafb_resMode;
+	return viafb_modentry[i].mode_index;
 }
 
 static void check_available_device_to_enable(int device_id)
@@ -2199,7 +2192,7 @@ static int __devinit via_pci_probe(void)
 	strict_strtoul(tmpc, 0, &default_xres);
 	strict_strtoul(tmpm, 0, &default_yres);
 
-	vmode_index = viafb_get_mode_index(default_xres, default_yres, 0);
+	vmode_index = viafb_get_mode_index(default_xres, default_yres);
 	DEBUG_MSG(KERN_INFO "0->index=%d\n", vmode_index);
 
 	if (viafb_SAMM_ON == 1) {
diff -puN drivers/video/via/viafbdev.h~viafb-fix-rmmod-bug drivers/video/via/viafbdev.h
--- a/drivers/video/via/viafbdev.h~viafb-fix-rmmod-bug
+++ a/drivers/video/via/viafbdev.h
@@ -81,7 +81,6 @@ struct viafb_modeinfo {
 	u32 xres;
 	u32 yres;
 	int mode_index;
-	char *mode_res;
 };
 extern unsigned int viafb_second_virtual_yres;
 extern unsigned int viafb_second_virtual_xres;
@@ -102,7 +101,7 @@ extern int strict_strtoul(const char *cp
 void viafb_memory_pitch_patch(struct fb_info *info);
 void viafb_fill_var_timing_info(struct fb_var_screeninfo *var, int refresh,
 			  int mode_index);
-int viafb_get_mode_index(int hres, int vres, int flag);
+int viafb_get_mode_index(int hres, int vres);
 u8 viafb_gpio_i2c_read_lvds(struct lvds_setting_information
 	*plvds_setting_info, struct lvds_chip_information
 	*plvds_chip_info, u8 index);
_

Patches currently in -mm which might be from FlorianSchandinat@gmx.de are

viafb-fix-rmmod-bug.patch

