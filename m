From: akpm@linux-foundation.org
Subject: [merged] viafb-some-dvi-cleanup.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:56:12 -0400
Message-ID: <201003150656.o2F6ukSE016320@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34016 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934463Ab0COG4w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:56:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     viafb: some dvi cleanup
has been removed from the -mm tree.  Its filename was
     viafb-some-dvi-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb: some dvi cleanup
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

Remove some unused variables, move some dvi code around and store the
detected maximum resolution for later use.  The vertical resolution is
handled as the old code did it but I hope it can be read from the hardware
some day.

No runtime change expected.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/chip.h |    9 ---
 drivers/video/via/dvi.c  |  107 ++++++++++++++++---------------------
 drivers/video/via/dvi.h  |    3 -
 drivers/video/via/hw.c   |   11 ---
 4 files changed, 55 insertions(+), 75 deletions(-)

diff -puN drivers/video/via/chip.h~viafb-some-dvi-cleanup drivers/video/via/chip.h
--- a/drivers/video/via/chip.h~viafb-some-dvi-cleanup
+++ a/drivers/video/via/chip.h
@@ -107,7 +107,6 @@
 struct tmds_chip_information {
 	int tmds_chip_name;
 	int tmds_chip_slave_addr;
-	int dvi_panel_id;
 	int data_mode;
 	int output_interface;
 	int i2c_port;
@@ -142,13 +141,9 @@ struct tmds_setting_information {
 	int iga_path;
 	int h_active;
 	int v_active;
-	int bpp;
-	int refresh_rate;
-	int get_dvi_size_method;
 	int max_pixel_clock;
-	int dvi_panel_hres;
-	int dvi_panel_vres;
-	int native_size;
+	int max_hres;
+	int max_vres;
 };
 
 struct lvds_setting_information {
diff -puN drivers/video/via/dvi.c~viafb-some-dvi-cleanup drivers/video/via/dvi.c
--- a/drivers/video/via/dvi.c~viafb-some-dvi-cleanup
+++ a/drivers/video/via/dvi.c
@@ -23,9 +23,10 @@
 static void tmds_register_write(int index, u8 data);
 static int tmds_register_read(int index);
 static int tmds_register_read_bytes(int index, u8 *buff, int buff_len);
-static void dvi_get_panel_size_from_DDCv1(void);
-static void dvi_get_panel_size_from_DDCv2(void);
-static void dvi_get_panel_info(void);
+static void dvi_get_panel_size_from_DDCv1(struct tmds_chip_information
+	*tmds_chip, struct tmds_setting_information *tmds_setting);
+static void dvi_get_panel_size_from_DDCv2(struct tmds_chip_information
+	*tmds_chip, struct tmds_setting_information *tmds_setting);
 static int viafb_dvi_query_EDID(void);
 
 static int check_tmds_chip(int device_id_subaddr, int device_id)
@@ -36,23 +37,24 @@ static int check_tmds_chip(int device_id
 		return FAIL;
 }
 
-void viafb_init_dvi_size(void)
+void viafb_init_dvi_size(struct tmds_chip_information *tmds_chip,
+	struct tmds_setting_information *tmds_setting)
 {
 	DEBUG_MSG(KERN_INFO "viafb_init_dvi_size()\n");
-	DEBUG_MSG(KERN_INFO
-		"viaparinfo->tmds_setting_info->get_dvi_size_method %d\n",
-		  viaparinfo->tmds_setting_info->get_dvi_size_method);
 
-	switch (viaparinfo->tmds_setting_info->get_dvi_size_method) {
-	case GET_DVI_SIZE_BY_SYSTEM_BIOS:
+	viafb_dvi_sense();
+	switch (viafb_dvi_query_EDID()) {
+	case 1:
+		dvi_get_panel_size_from_DDCv1(tmds_chip, tmds_setting);
 		break;
-	case GET_DVI_SZIE_BY_HW_STRAPPING:
+	case 2:
+		dvi_get_panel_size_from_DDCv2(tmds_chip, tmds_setting);
 		break;
-	case GET_DVI_SIZE_BY_VGA_BIOS:
 	default:
-		dvi_get_panel_info();
+		printk(KERN_WARNING "viafb_init_dvi_size: DVI panel size undetected!\n");
 		break;
 	}
+
 	return;
 }
 
@@ -314,11 +316,9 @@ static int viafb_dvi_query_EDID(void)
 		return false;
 }
 
-/* void dvi_get_panel_size_from_DDCv1(void)
- *
- *     - Get Panel Size Using EDID1 Table
- */
-static void dvi_get_panel_size_from_DDCv1(void)
+/* Get Panel Size Using EDID1 Table */
+static void dvi_get_panel_size_from_DDCv1(struct tmds_chip_information
+	*tmds_chip, struct tmds_setting_information *tmds_setting)
 {
 	int i, max_h = 0, tmp, restore;
 	unsigned char rData;
@@ -326,8 +326,8 @@ static void dvi_get_panel_size_from_DDCv
 
 	DEBUG_MSG(KERN_INFO "\n dvi_get_panel_size_from_DDCv1 \n");
 
-	restore = viaparinfo->chip_info->tmds_chip_info.tmds_chip_slave_addr;
-	viaparinfo->chip_info->tmds_chip_info.tmds_chip_slave_addr = 0xA0;
+	restore = tmds_chip->tmds_chip_slave_addr;
+	tmds_chip->tmds_chip_slave_addr = 0xA0;
 
 	rData = tmds_register_read(0x23);
 	if (rData & 0x3C)
@@ -373,8 +373,8 @@ static void dvi_get_panel_size_from_DDCv
 				/* The first two byte must be zero. */
 				if (EDID_DATA[3] == 0xFD) {
 					/* To get max pixel clock. */
-					viaparinfo->tmds_setting_info->
-					max_pixel_clock = EDID_DATA[9] * 10;
+					tmds_setting->max_pixel_clock =
+						EDID_DATA[9] * 10;
 				}
 			}
 			break;
@@ -384,23 +384,31 @@ static void dvi_get_panel_size_from_DDCv
 		}
 	}
 
+	tmds_setting->max_hres = max_h;
 	switch (max_h) {
 	case 640:
+		tmds_setting->max_vres = 480;
 		break;
 	case 800:
+		tmds_setting->max_vres = 600;
 		break;
 	case 1024:
+		tmds_setting->max_vres = 768;
 		break;
 	case 1280:
+		tmds_setting->max_vres = 1024;
 		break;
 	case 1400:
+		tmds_setting->max_vres = 1050;
 		break;
 	case 1440:
+		tmds_setting->max_vres = 1050;
 		break;
 	case 1600:
+		tmds_setting->max_vres = 1200;
 		break;
 	case 1920:
-
+		tmds_setting->max_vres = 1080;
 		break;
 	default:
 		DEBUG_MSG(KERN_INFO "Unknown panel size max resolution = %d !\
@@ -409,72 +417,55 @@ static void dvi_get_panel_size_from_DDCv
 	}
 
 	DEBUG_MSG(KERN_INFO "DVI max pixelclock = %d\n",
-		  viaparinfo->tmds_setting_info->max_pixel_clock);
-	viaparinfo->chip_info->tmds_chip_info.tmds_chip_slave_addr = restore;
+		tmds_setting->max_pixel_clock);
+	tmds_chip->tmds_chip_slave_addr = restore;
 }
 
-/* void dvi_get_panel_size_from_DDCv2(void)
- *
- *     - Get Panel Size Using EDID2 Table
- */
-static void dvi_get_panel_size_from_DDCv2(void)
+/* Get Panel Size Using EDID2 Table */
+static void dvi_get_panel_size_from_DDCv2(struct tmds_chip_information
+	*tmds_chip, struct tmds_setting_information *tmds_setting)
 {
-	int HSize = 0, restore;
+	int restore;
 	unsigned char R_Buffer[2];
 
 	DEBUG_MSG(KERN_INFO "\n dvi_get_panel_size_from_DDCv2 \n");
 
-	restore = viaparinfo->chip_info->tmds_chip_info.tmds_chip_slave_addr;
-	viaparinfo->chip_info->tmds_chip_info.tmds_chip_slave_addr = 0xA2;
+	restore = tmds_chip->tmds_chip_slave_addr;
+	tmds_chip->tmds_chip_slave_addr = 0xA2;
 
 	/* Horizontal: 0x76, 0x77 */
 	tmds_register_read_bytes(0x76, R_Buffer, 2);
-	HSize = R_Buffer[0];
-	HSize += R_Buffer[1] << 8;
+	tmds_setting->max_hres = R_Buffer[0] + (R_Buffer[1] << 8);
 
-	switch (HSize) {
+	switch (tmds_setting->max_hres) {
 	case 640:
+		tmds_setting->max_vres = 480;
 		break;
 	case 800:
+		tmds_setting->max_vres = 600;
 		break;
 	case 1024:
+		tmds_setting->max_vres = 768;
 		break;
 	case 1280:
+		tmds_setting->max_vres = 1024;
 		break;
 	case 1400:
+		tmds_setting->max_vres = 1050;
 		break;
 	case 1440:
+		tmds_setting->max_vres = 1050;
 		break;
 	case 1600:
+		tmds_setting->max_vres = 1200;
 		break;
 	default:
 		DEBUG_MSG(KERN_INFO "Unknown panel size max resolution = %d!\
-					set default panel size.\n", HSize);
+			set default panel size.\n", tmds_setting->max_hres);
 		break;
 	}
 
-	viaparinfo->chip_info->tmds_chip_info.tmds_chip_slave_addr = restore;
-}
-
-/* unsigned char dvi_get_panel_info(void)
- *
- *     - Get Panel Size
- */
-static void dvi_get_panel_info(void)
-{
-	DEBUG_MSG(KERN_INFO "dvi_get_panel_info! \n");
-
-	viafb_dvi_sense();
-	switch (viafb_dvi_query_EDID()) {
-	case 1:
-		dvi_get_panel_size_from_DDCv1();
-		break;
-	case 2:
-		dvi_get_panel_size_from_DDCv2();
-		break;
-	default:
-		break;
-	}
+	tmds_chip->tmds_chip_slave_addr = restore;
 }
 
 /* If Disable DVI, turn off pad */
diff -puN drivers/video/via/dvi.h~viafb-some-dvi-cleanup drivers/video/via/dvi.h
--- a/drivers/video/via/dvi.h~viafb-some-dvi-cleanup
+++ a/drivers/video/via/dvi.h
@@ -57,7 +57,8 @@ int viafb_dvi_sense(void);
 void viafb_dvi_disable(void);
 void viafb_dvi_enable(void);
 int viafb_tmds_trasmitter_identify(void);
-void viafb_init_dvi_size(void);
+void viafb_init_dvi_size(struct tmds_chip_information *tmds_chip,
+	struct tmds_setting_information *tmds_setting);
 void viafb_dvi_set_mode(struct VideoModeTable *videoMode, int mode_bpp,
 	int set_iga);
 
diff -puN drivers/video/via/hw.c~viafb-some-dvi-cleanup drivers/video/via/hw.c
--- a/drivers/video/via/hw.c~viafb-some-dvi-cleanup
+++ a/drivers/video/via/hw.c
@@ -1911,9 +1911,6 @@ void viafb_update_device_setting(int hre
 
 		viaparinfo->tmds_setting_info->h_active = hres;
 		viaparinfo->tmds_setting_info->v_active = vres;
-		viaparinfo->tmds_setting_info->bpp = bpp;
-		viaparinfo->tmds_setting_info->refresh_rate =
-			vmode_refresh;
 
 		viaparinfo->lvds_setting_info->h_active = hres;
 		viaparinfo->lvds_setting_info->v_active = vres;
@@ -1930,9 +1927,6 @@ void viafb_update_device_setting(int hre
 		if (viaparinfo->tmds_setting_info->iga_path == IGA2) {
 			viaparinfo->tmds_setting_info->h_active = hres;
 			viaparinfo->tmds_setting_info->v_active = vres;
-			viaparinfo->tmds_setting_info->bpp = bpp;
-			viaparinfo->tmds_setting_info->refresh_rate =
-				vmode_refresh;
 		}
 
 		if (viaparinfo->lvds_setting_info->iga_path == IGA2) {
@@ -2031,9 +2025,8 @@ static void init_tmds_chip_info(void)
 
 	DEBUG_MSG(KERN_INFO "TMDS Chip = %d\n",
 		  viaparinfo->chip_info->tmds_chip_info.tmds_chip_name);
-	viaparinfo->tmds_setting_info->get_dvi_size_method =
-		GET_DVI_SIZE_BY_VGA_BIOS;
-	viafb_init_dvi_size();
+	viafb_init_dvi_size(&viaparinfo->shared->chip_info.tmds_chip_info,
+		&viaparinfo->shared->tmds_setting_info);
 }
 
 static void init_lvds_chip_info(void)
_

Patches currently in -mm which might be from FlorianSchandinat@gmx.de are

origin.patch

