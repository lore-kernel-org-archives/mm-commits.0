From: akpm@linux-foundation.org
Subject: [merged] viafb-remove-the-remaining-via_res_-uses.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:56:05 -0400
Message-ID: <201003150656.o2F6ucgg016297@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33222 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934451Ab0COG4p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:56:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     viafb: remove the remaining VIA_RES_* uses
has been removed from the -mm tree.  Its filename was
     viafb-remove-the-remaining-via_res_-uses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb: remove the remaining VIA_RES_* uses
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

Remove the rest of the VIA_RES_* use cases.  Obviously this was no longer
useful.  Keep the related infrastructure/functions for later use.

No runtime impact expected.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/chip.h  |    2 
 drivers/video/via/dvi.c   |   82 ++++--------------------------------
 drivers/video/via/lcd.c   |   42 ++----------------
 drivers/video/via/share.h |   55 ------------------------
 4 files changed, 15 insertions(+), 166 deletions(-)

diff -puN drivers/video/via/chip.h~viafb-remove-the-remaining-via_res_-uses drivers/video/via/chip.h
--- a/drivers/video/via/chip.h~viafb-remove-the-remaining-via_res_-uses
+++ a/drivers/video/via/chip.h
@@ -146,7 +146,6 @@ struct tmds_setting_information {
 	int refresh_rate;
 	int get_dvi_size_method;
 	int max_pixel_clock;
-	int dvi_panel_size;
 	int dvi_panel_hres;
 	int dvi_panel_vres;
 	int native_size;
@@ -160,7 +159,6 @@ struct lvds_setting_information {
 	int refresh_rate;
 	int get_lcd_size_method;
 	int lcd_panel_id;
-	int lcd_panel_size;
 	int lcd_panel_hres;
 	int lcd_panel_vres;
 	int display_method;
diff -puN drivers/video/via/dvi.c~viafb-remove-the-remaining-via_res_-uses drivers/video/via/dvi.c
--- a/drivers/video/via/dvi.c~viafb-remove-the-remaining-via_res_-uses
+++ a/drivers/video/via/dvi.c
@@ -23,9 +23,9 @@
 static void tmds_register_write(int index, u8 data);
 static int tmds_register_read(int index);
 static int tmds_register_read_bytes(int index, u8 *buff, int buff_len);
-static int dvi_get_panel_size_from_DDCv1(void);
-static int dvi_get_panel_size_from_DDCv2(void);
-static unsigned char dvi_get_panel_info(void);
+static void dvi_get_panel_size_from_DDCv1(void);
+static void dvi_get_panel_size_from_DDCv2(void);
+static void dvi_get_panel_info(void);
 static int viafb_dvi_query_EDID(void);
 
 static int check_tmds_chip(int device_id_subaddr, int device_id)
@@ -314,18 +314,13 @@ static int viafb_dvi_query_EDID(void)
 		return false;
 }
 
-/*
- *
- * int dvi_get_panel_size_from_DDCv1(void)
+/* void dvi_get_panel_size_from_DDCv1(void)
  *
  *     - Get Panel Size Using EDID1 Table
- *
- * Return Type:    int
- *
  */
-static int dvi_get_panel_size_from_DDCv1(void)
+static void dvi_get_panel_size_from_DDCv1(void)
 {
-	int i, max_h = 0, max_v = 0, tmp, restore;
+	int i, max_h = 0, tmp, restore;
 	unsigned char rData;
 	unsigned char EDID_DATA[18];
 
@@ -391,46 +386,23 @@ static int dvi_get_panel_size_from_DDCv1
 
 	switch (max_h) {
 	case 640:
-		viaparinfo->tmds_setting_info->dvi_panel_size =
-			VIA_RES_640X480;
 		break;
 	case 800:
-		viaparinfo->tmds_setting_info->dvi_panel_size =
-			VIA_RES_800X600;
 		break;
 	case 1024:
-		viaparinfo->tmds_setting_info->dvi_panel_size =
-			VIA_RES_1024X768;
 		break;
 	case 1280:
-		viaparinfo->tmds_setting_info->dvi_panel_size =
-			VIA_RES_1280X1024;
 		break;
 	case 1400:
-		viaparinfo->tmds_setting_info->dvi_panel_size =
-			VIA_RES_1400X1050;
 		break;
 	case 1440:
-		viaparinfo->tmds_setting_info->dvi_panel_size =
-			VIA_RES_1440X1050;
 		break;
 	case 1600:
-		viaparinfo->tmds_setting_info->dvi_panel_size =
-			VIA_RES_1600X1200;
 		break;
 	case 1920:
-		if (max_v == 1200) {
-			viaparinfo->tmds_setting_info->dvi_panel_size =
-				VIA_RES_1920X1200;
-		} else {
-			viaparinfo->tmds_setting_info->dvi_panel_size =
-				VIA_RES_1920X1080;
-		}
 
 		break;
 	default:
-		viaparinfo->tmds_setting_info->dvi_panel_size =
-			VIA_RES_1024X768;
 		DEBUG_MSG(KERN_INFO "Unknown panel size max resolution = %d !\
 					 set default panel size.\n", max_h);
 		break;
@@ -439,19 +411,13 @@ static int dvi_get_panel_size_from_DDCv1
 	DEBUG_MSG(KERN_INFO "DVI max pixelclock = %d\n",
 		  viaparinfo->tmds_setting_info->max_pixel_clock);
 	viaparinfo->chip_info->tmds_chip_info.tmds_chip_slave_addr = restore;
-	return viaparinfo->tmds_setting_info->dvi_panel_size;
 }
 
-/*
- *
- * int dvi_get_panel_size_from_DDCv2(void)
+/* void dvi_get_panel_size_from_DDCv2(void)
  *
  *     - Get Panel Size Using EDID2 Table
- *
- * Return Type:    int
- *
  */
-static int dvi_get_panel_size_from_DDCv2(void)
+static void dvi_get_panel_size_from_DDCv2(void)
 {
 	int HSize = 0, restore;
 	unsigned char R_Buffer[2];
@@ -468,56 +434,34 @@ static int dvi_get_panel_size_from_DDCv2
 
 	switch (HSize) {
 	case 640:
-		viaparinfo->tmds_setting_info->dvi_panel_size =
-			VIA_RES_640X480;
 		break;
 	case 800:
-		viaparinfo->tmds_setting_info->dvi_panel_size =
-			VIA_RES_800X600;
 		break;
 	case 1024:
-		viaparinfo->tmds_setting_info->dvi_panel_size =
-			VIA_RES_1024X768;
 		break;
 	case 1280:
-		viaparinfo->tmds_setting_info->dvi_panel_size =
-			VIA_RES_1280X1024;
 		break;
 	case 1400:
-		viaparinfo->tmds_setting_info->dvi_panel_size =
-			VIA_RES_1400X1050;
 		break;
 	case 1440:
-		viaparinfo->tmds_setting_info->dvi_panel_size =
-			VIA_RES_1440X1050;
 		break;
 	case 1600:
-		viaparinfo->tmds_setting_info->dvi_panel_size =
-			VIA_RES_1600X1200;
 		break;
 	default:
-		viaparinfo->tmds_setting_info->dvi_panel_size =
-			VIA_RES_1024X768;
 		DEBUG_MSG(KERN_INFO "Unknown panel size max resolution = %d!\
 					set default panel size.\n", HSize);
 		break;
 	}
 
 	viaparinfo->chip_info->tmds_chip_info.tmds_chip_slave_addr = restore;
-	return viaparinfo->tmds_setting_info->dvi_panel_size;
 }
 
-/*
- *
- * unsigned char dvi_get_panel_info(void)
+/* unsigned char dvi_get_panel_info(void)
  *
  *     - Get Panel Size
- *
- * Return Type:    unsigned char
  */
-static unsigned char dvi_get_panel_info(void)
+static void dvi_get_panel_info(void)
 {
-	unsigned char dvipanelsize;
 	DEBUG_MSG(KERN_INFO "dvi_get_panel_info! \n");
 
 	viafb_dvi_sense();
@@ -531,12 +475,6 @@ static unsigned char dvi_get_panel_info(
 	default:
 		break;
 	}
-
-	DEBUG_MSG(KERN_INFO "dvi panel size is %2d \n",
-		  viaparinfo->tmds_setting_info->dvi_panel_size);
-	dvipanelsize = (unsigned char)(viaparinfo->
-		tmds_setting_info->dvi_panel_size);
-	return dvipanelsize;
 }
 
 /* If Disable DVI, turn off pad */
diff -puN drivers/video/via/lcd.c~viafb-remove-the-remaining-via_res_-uses drivers/video/via/lcd.c
--- a/drivers/video/via/lcd.c~viafb-remove-the-remaining-via_res_-uses
+++ a/drivers/video/via/lcd.c
@@ -61,7 +61,7 @@ static struct _lcd_scaling_factor lcd_sc
 
 static int check_lvds_chip(int device_id_subaddr, int device_id);
 static bool lvds_identify_integratedlvds(void);
-static int fp_id_to_vindex(int panel_id);
+static void fp_id_to_vindex(int panel_id);
 static int lvds_register_read(int index);
 static void load_lcd_scaling(int set_hres, int set_vres, int panel_hres,
 		      int panel_vres);
@@ -127,33 +127,24 @@ void viafb_init_lcd_size(void)
 		break;
 	case GET_LCD_SIZE_BY_VGA_BIOS:
 		DEBUG_MSG(KERN_INFO "Get LCD Size method by VGA BIOS !!\n");
-		viaparinfo->lvds_setting_info->lcd_panel_size =
-		    fp_id_to_vindex(viafb_lcd_panel_id);
+		fp_id_to_vindex(viafb_lcd_panel_id);
 		DEBUG_MSG(KERN_INFO "LCD Panel_ID = %d\n",
 			  viaparinfo->lvds_setting_info->lcd_panel_id);
-		DEBUG_MSG(KERN_INFO "LCD Panel Size = %d\n",
-			  viaparinfo->lvds_setting_info->lcd_panel_size);
 		break;
 	case GET_LCD_SIZE_BY_USER_SETTING:
 		DEBUG_MSG(KERN_INFO "Get LCD Size method by user setting !!\n");
-		viaparinfo->lvds_setting_info->lcd_panel_size =
-		    fp_id_to_vindex(viafb_lcd_panel_id);
+		fp_id_to_vindex(viafb_lcd_panel_id);
 		DEBUG_MSG(KERN_INFO "LCD Panel_ID = %d\n",
 			  viaparinfo->lvds_setting_info->lcd_panel_id);
-		DEBUG_MSG(KERN_INFO "LCD Panel Size = %d\n",
-			  viaparinfo->lvds_setting_info->lcd_panel_size);
 		break;
 	default:
 		DEBUG_MSG(KERN_INFO "viafb_init_lcd_size fail\n");
 		viaparinfo->lvds_setting_info->lcd_panel_id =
 			LCD_PANEL_ID1_800X600;
-		viaparinfo->lvds_setting_info->lcd_panel_size =
-		    fp_id_to_vindex(LCD_PANEL_ID1_800X600);
+		fp_id_to_vindex(LCD_PANEL_ID1_800X600);
 	}
 	viaparinfo->lvds_setting_info2->lcd_panel_id =
 		viaparinfo->lvds_setting_info->lcd_panel_id;
-	viaparinfo->lvds_setting_info2->lcd_panel_size =
-		viaparinfo->lvds_setting_info->lcd_panel_size;
 	viaparinfo->lvds_setting_info2->lcd_panel_hres =
 		viaparinfo->lvds_setting_info->lcd_panel_hres;
 	viaparinfo->lvds_setting_info2->lcd_panel_vres =
@@ -250,7 +241,7 @@ int viafb_lvds_trasmitter_identify(void)
 	return FAIL;
 }
 
-static int fp_id_to_vindex(int panel_id)
+static void fp_id_to_vindex(int panel_id)
 {
 	DEBUG_MSG(KERN_INFO "fp_get_panel_id()\n");
 
@@ -266,7 +257,6 @@ static int fp_id_to_vindex(int panel_id)
 			LCD_PANEL_ID0_640X480;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 0;
 		viaparinfo->lvds_setting_info->LCDDithering = 1;
-		return VIA_RES_640X480;
 		break;
 	case 0x1:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 800;
@@ -275,7 +265,6 @@ static int fp_id_to_vindex(int panel_id)
 			LCD_PANEL_ID1_800X600;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 0;
 		viaparinfo->lvds_setting_info->LCDDithering = 1;
-		return VIA_RES_800X600;
 		break;
 	case 0x2:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 1024;
@@ -284,7 +273,6 @@ static int fp_id_to_vindex(int panel_id)
 			LCD_PANEL_ID2_1024X768;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 0;
 		viaparinfo->lvds_setting_info->LCDDithering = 1;
-		return VIA_RES_1024X768;
 		break;
 	case 0x3:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 1280;
@@ -293,7 +281,6 @@ static int fp_id_to_vindex(int panel_id)
 			LCD_PANEL_ID3_1280X768;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 0;
 		viaparinfo->lvds_setting_info->LCDDithering = 1;
-		return VIA_RES_1280X768;
 		break;
 	case 0x4:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 1280;
@@ -302,7 +289,6 @@ static int fp_id_to_vindex(int panel_id)
 			LCD_PANEL_ID4_1280X1024;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 1;
 		viaparinfo->lvds_setting_info->LCDDithering = 1;
-		return VIA_RES_1280X1024;
 		break;
 	case 0x5:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 1400;
@@ -311,7 +297,6 @@ static int fp_id_to_vindex(int panel_id)
 			LCD_PANEL_ID5_1400X1050;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 1;
 		viaparinfo->lvds_setting_info->LCDDithering = 1;
-		return VIA_RES_1400X1050;
 		break;
 	case 0x6:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 1600;
@@ -320,7 +305,6 @@ static int fp_id_to_vindex(int panel_id)
 			LCD_PANEL_ID6_1600X1200;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 1;
 		viaparinfo->lvds_setting_info->LCDDithering = 1;
-		return VIA_RES_1600X1200;
 		break;
 	case 0x8:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 800;
@@ -329,7 +313,6 @@ static int fp_id_to_vindex(int panel_id)
 			LCD_PANEL_IDA_800X480;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 0;
 		viaparinfo->lvds_setting_info->LCDDithering = 1;
-		return VIA_RES_800X480;
 		break;
 	case 0x9:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 1024;
@@ -338,7 +321,6 @@ static int fp_id_to_vindex(int panel_id)
 			LCD_PANEL_ID2_1024X768;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 1;
 		viaparinfo->lvds_setting_info->LCDDithering = 1;
-		return VIA_RES_1024X768;
 		break;
 	case 0xA:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 1024;
@@ -347,7 +329,6 @@ static int fp_id_to_vindex(int panel_id)
 			LCD_PANEL_ID2_1024X768;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 0;
 		viaparinfo->lvds_setting_info->LCDDithering = 0;
-		return VIA_RES_1024X768;
 		break;
 	case 0xB:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 1024;
@@ -356,7 +337,6 @@ static int fp_id_to_vindex(int panel_id)
 			LCD_PANEL_ID2_1024X768;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 1;
 		viaparinfo->lvds_setting_info->LCDDithering = 0;
-		return VIA_RES_1024X768;
 		break;
 	case 0xC:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 1280;
@@ -365,7 +345,6 @@ static int fp_id_to_vindex(int panel_id)
 			LCD_PANEL_ID3_1280X768;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 0;
 		viaparinfo->lvds_setting_info->LCDDithering = 0;
-		return VIA_RES_1280X768;
 		break;
 	case 0xD:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 1280;
@@ -374,7 +353,6 @@ static int fp_id_to_vindex(int panel_id)
 			LCD_PANEL_ID4_1280X1024;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 1;
 		viaparinfo->lvds_setting_info->LCDDithering = 0;
-		return VIA_RES_1280X1024;
 		break;
 	case 0xE:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 1400;
@@ -383,7 +361,6 @@ static int fp_id_to_vindex(int panel_id)
 			LCD_PANEL_ID5_1400X1050;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 1;
 		viaparinfo->lvds_setting_info->LCDDithering = 0;
-		return VIA_RES_1400X1050;
 		break;
 	case 0xF:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 1600;
@@ -392,7 +369,6 @@ static int fp_id_to_vindex(int panel_id)
 			LCD_PANEL_ID6_1600X1200;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 1;
 		viaparinfo->lvds_setting_info->LCDDithering = 0;
-		return VIA_RES_1600X1200;
 		break;
 	case 0x10:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 1366;
@@ -401,7 +377,6 @@ static int fp_id_to_vindex(int panel_id)
 			LCD_PANEL_ID7_1366X768;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 0;
 		viaparinfo->lvds_setting_info->LCDDithering = 0;
-		return VIA_RES_1368X768;
 		break;
 	case 0x11:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 1024;
@@ -410,7 +385,6 @@ static int fp_id_to_vindex(int panel_id)
 			LCD_PANEL_ID8_1024X600;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 0;
 		viaparinfo->lvds_setting_info->LCDDithering = 1;
-		return VIA_RES_1024X600;
 		break;
 	case 0x12:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 1280;
@@ -419,7 +393,6 @@ static int fp_id_to_vindex(int panel_id)
 			LCD_PANEL_ID3_1280X768;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 1;
 		viaparinfo->lvds_setting_info->LCDDithering = 1;
-		return VIA_RES_1280X768;
 		break;
 	case 0x13:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 1280;
@@ -428,7 +401,6 @@ static int fp_id_to_vindex(int panel_id)
 			LCD_PANEL_ID9_1280X800;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 0;
 		viaparinfo->lvds_setting_info->LCDDithering = 1;
-		return VIA_RES_1280X800;
 		break;
 	case 0x14:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 1360;
@@ -437,7 +409,6 @@ static int fp_id_to_vindex(int panel_id)
 			LCD_PANEL_IDB_1360X768;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 0;
 		viaparinfo->lvds_setting_info->LCDDithering = 0;
-		return VIA_RES_1360X768;
 		break;
 	case 0x15:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 1280;
@@ -446,7 +417,6 @@ static int fp_id_to_vindex(int panel_id)
 			LCD_PANEL_ID3_1280X768;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 1;
 		viaparinfo->lvds_setting_info->LCDDithering = 0;
-		return VIA_RES_1280X768;
 		break;
 	case 0x16:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 480;
@@ -455,7 +425,6 @@ static int fp_id_to_vindex(int panel_id)
 			LCD_PANEL_IDC_480X640;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 0;
 		viaparinfo->lvds_setting_info->LCDDithering = 1;
-		return VIA_RES_480X640;
 		break;
 	default:
 		viaparinfo->lvds_setting_info->lcd_panel_hres = 800;
@@ -464,7 +433,6 @@ static int fp_id_to_vindex(int panel_id)
 			LCD_PANEL_ID1_800X600;
 		viaparinfo->lvds_setting_info->device_lcd_dualedge = 0;
 		viaparinfo->lvds_setting_info->LCDDithering = 1;
-		return VIA_RES_800X600;
 	}
 }
 
diff -puN drivers/video/via/share.h~viafb-remove-the-remaining-via_res_-uses drivers/video/via/share.h
--- a/drivers/video/via/share.h~viafb-remove-the-remaining-via_res_-uses
+++ a/drivers/video/via/share.h
@@ -43,61 +43,6 @@
 /* Video Memory Size */
 #define VIDEO_MEMORY_SIZE_16M    0x1000000
 
-/* Definition Mode Index
-*/
-#define     VIA_RES_640X480                 	0
-#define     VIA_RES_800X600                 	1
-#define     VIA_RES_1024X768                	2
-#define     VIA_RES_1152X864                	3
-#define     VIA_RES_1280X1024               	4
-#define     VIA_RES_1600X1200               	5
-#define     VIA_RES_1440X1050               	6
-#define     VIA_RES_1280X768                	7
-#define     VIA_RES_1280X960                	8
-#define     VIA_RES_1920X1440               	9
-#define     VIA_RES_848X480                 	10
-#define     VIA_RES_1400X1050               	11
-#define     VIA_RES_720X480                 	12
-#define     VIA_RES_720X576                 	13
-#define     VIA_RES_1024X512                	14
-#define     VIA_RES_856X480                 	15
-#define     VIA_RES_1024X576                	16
-#define     VIA_RES_640X400                 	17
-#define     VIA_RES_1280X720                	18
-#define     VIA_RES_1920X1080               	19
-#define     VIA_RES_800X480                 	20
-#define     VIA_RES_1368X768                	21
-#define     VIA_RES_1024X600                	22
-#define     VIA_RES_1280X800                	23
-#define     VIA_RES_1680X1050               	24
-#define     VIA_RES_960X600			25
-#define     VIA_RES_1000X600               	26
-#define     VIA_RES_1088X612               	27
-#define     VIA_RES_1152X720               	28
-#define     VIA_RES_1200X720               	29
-#define     VIA_RES_1280X600               	30
-#define     VIA_RES_1360X768               	31
-#define     VIA_RES_1366X768               	32
-#define     VIA_RES_1440X900               	33
-#define     VIA_RES_1600X900               	34
-#define     VIA_RES_1600X1024              	35
-#define     VIA_RES_1792X1344              	36
-#define     VIA_RES_1856X1392              	37
-#define     VIA_RES_1920X1200              	38
-#define     VIA_RES_2048X1536              	39
-#define     VIA_RES_480X640                  	40
-
-/*Reduce Blanking*/
-#define     VIA_RES_1360X768_RB          	131
-#define     VIA_RES_1440X900_RB          	133
-#define     VIA_RES_1400X1050_RB        	111
-#define     VIA_RES_1600X900_RB          	134
-#define     VIA_RES_1680X1050_RB        	124
-#define     VIA_RES_1920X1080_RB        	119
-#define     VIA_RES_1920X1200_RB        	138
-
-#define     VIA_RES_INVALID                 	255
