From: akpm@linux-foundation.org
Subject: + fbmon-cleanup-trailing-whitespaces.patch added to -mm tree
Date: Thu, 29 Nov 2007 12:32:02 -0800
Message-ID: <200711292032.lATKW2r4006014@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38834 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757820AbXK2UcR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 15:32:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andre@bitwigglers.org, adaplas@pol.net


The patch titled
     fbmon: cleanup trailing whitespaces
has been added to the -mm tree.  Its filename is
     fbmon-cleanup-trailing-whitespaces.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fbmon: cleanup trailing whitespaces
From: Andre Haupt <andre@bitwigglers.org>

Signed-off-by: Andre Haupt <andre@bitwigglers.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmon.c |  116 ++++++++++++++++++++--------------------
 1 file changed, 58 insertions(+), 58 deletions(-)

diff -puN drivers/video/fbmon.c~fbmon-cleanup-trailing-whitespaces drivers/video/fbmon.c
--- a/drivers/video/fbmon.c~fbmon-cleanup-trailing-whitespaces
+++ a/drivers/video/fbmon.c
@@ -4,7 +4,7 @@
  * Copyright (C) 2002 James Simmons <jsimmons@users.sf.net>
  *
  * Credits:
- * 
+ *
  * The EDID Parser is a conglomeration from the following sources:
  *
  *   1. SciTech SNAP Graphics Architecture
@@ -12,13 +12,13 @@
  *
  *   2. XFree86 4.3.0, interpret_edid.c
  *      Copyright 1998 by Egbert Eich <Egbert.Eich@Physik.TU-Darmstadt.DE>
- * 
- *   3. John Fremlin <vii@users.sourceforge.net> and 
+ *
+ *   3. John Fremlin <vii@users.sourceforge.net> and
  *      Ani Joshi <ajoshi@unixbox.com>
- *  
+ *
  * Generalized Timing Formula is derived from:
  *
- *      GTF Spreadsheet by Andy Morrish (1/5/97) 
+ *      GTF Spreadsheet by Andy Morrish (1/5/97)
  *      available at http://www.vesa.org
  *
  * This file is subject to the terms and conditions of the GNU General Public
@@ -36,7 +36,7 @@
 #endif
 #include "edid.h"
 
-/* 
+/*
  * EDID parser
  */
 
@@ -160,8 +160,8 @@ static int check_edid(unsigned char *edi
 	for (i = 0; i < ARRAY_SIZE(brokendb); i++) {
 		if (!strncmp(manufacturer, brokendb[i].manufacturer, 4) &&
 			brokendb[i].model == model) {
- 			fix = brokendb[i].fix;
- 			break;
+			fix = brokendb[i].fix;
+			break;
 		}
 	}
 
@@ -323,7 +323,7 @@ static void get_dpms_capabilities(unsign
 	       (flags & DPMS_SUSPEND)    ? "yes" : "no",
 	       (flags & DPMS_STANDBY)    ? "yes" : "no");
 }
-	
+
 static void get_chroma(unsigned char *block, struct fb_monspecs *specs)
 {
 	int tmp;
@@ -365,7 +365,7 @@ static void get_chroma(unsigned char *bl
 	tmp += 512;
 	specs->chroma.bluey = tmp/1024;
 	DPRINTK("BlueY:    0.%03d\n", specs->chroma.bluey);
-	
+
 	tmp = ((block[6] & (3 << 2)) >> 2) | (block[0xd] << 2);
 	tmp *= 1000;
 	tmp += 512;
@@ -383,7 +383,7 @@ static void calc_mode_timings(int xres, 
 			      struct fb_videomode *mode)
 {
 	struct fb_var_screeninfo *var;
-	
+
 	var = kzalloc(sizeof(struct fb_var_screeninfo), GFP_KERNEL);
 
 	if (var) {
@@ -451,11 +451,11 @@ static int get_est_timing(unsigned char 
 
 	c = block[1];
 	if (c&0x80) {
- 		mode[num++] = vesa_modes[9];
+		mode[num++] = vesa_modes[9];
 		DPRINTK("      800x600@72Hz\n");
 	}
 	if (c&0x40) {
- 		mode[num++] = vesa_modes[10];
+		mode[num++] = vesa_modes[10];
 		DPRINTK("      800x600@75Hz\n");
 	}
 	if (c&0x20) {
@@ -495,7 +495,7 @@ static int get_est_timing(unsigned char 
 static int get_std_timing(unsigned char *block, struct fb_videomode *mode)
 {
 	int xres, yres = 0, refresh, ratio, i;
-	
+
 	xres = (block[0] + 31) * 8;
 	if (xres <= 256)
 		return 0;
@@ -519,7 +519,7 @@ static int get_std_timing(unsigned char 
 
 	DPRINTK("      %dx%d@%dHz\n", xres, yres, refresh);
 	for (i = 0; i < VESA_MODEDB_SIZE; i++) {
-		if (vesa_modes[i].xres == xres && 
+		if (vesa_modes[i].xres == xres &&
 		    vesa_modes[i].yres == yres &&
 		    vesa_modes[i].refresh == refresh) {
 			*mode = vesa_modes[i];
@@ -536,13 +536,13 @@ static int get_dst_timing(unsigned char 
 {
 	int j, num = 0;
 
-	for (j = 0; j < 6; j++, block+= STD_TIMING_DESCRIPTION_SIZE) 
+	for (j = 0; j < 6; j++, block+= STD_TIMING_DESCRIPTION_SIZE)
 		num += get_std_timing(block, &mode[num]);
 
 	return num;
 }
 
-static void get_detailed_timing(unsigned char *block, 
+static void get_detailed_timing(unsigned char *block,
 				struct fb_videomode *mode)
 {
 	mode->xres = H_ACTIVE;
@@ -553,7 +553,7 @@ static void get_detailed_timing(unsigned
 	mode->right_margin = H_SYNC_OFFSET;
 	mode->left_margin = (H_ACTIVE + H_BLANKING) -
 		(H_ACTIVE + H_SYNC_OFFSET + H_SYNC_WIDTH);
-	mode->upper_margin = V_BLANKING - V_SYNC_OFFSET - 
+	mode->upper_margin = V_BLANKING - V_SYNC_OFFSET -
 		V_SYNC_WIDTH;
 	mode->lower_margin = V_SYNC_OFFSET;
 	mode->hsync_len = H_SYNC_WIDTH;
@@ -597,7 +597,7 @@ static struct fb_videomode *fb_create_mo
 	if (mode == NULL)
 		return NULL;
 
-	if (edid == NULL || !edid_checksum(edid) || 
+	if (edid == NULL || !edid_checksum(edid) ||
 	    !edid_check_header(edid)) {
 		kfree(mode);
 		return NULL;
@@ -632,7 +632,7 @@ static struct fb_videomode *fb_create_mo
 		if (block[0] == 0x00 && block[1] == 0x00 && block[3] == 0xfa)
 			num += get_dst_timing(block + 5, &mode[num]);
 	}
-	
+
 	/* Yikes, EDID data is totally useless */
 	if (!num) {
 		kfree(mode);
@@ -713,7 +713,7 @@ static int fb_get_monitor_limits(unsigne
 			hscan = (pixclock + htotal / 2) / htotal;
 			hscan = (hscan + 500) / 1000 * 1000;
 			hz = (hscan + vtotal / 2) / vtotal;
-			
+
 			if (specs->dclkmax == 0 || specs->dclkmax < pixclock)
 				specs->dclkmax = pixclock;
 
@@ -966,8 +966,8 @@ void fb_edid_to_monspecs(unsigned char *
 	DPRINTK("========================================\n");
 }
 
-/* 
- * VESA Generalized Timing Formula (GTF) 
+/*
+ * VESA Generalized Timing Formula (GTF)
  */
 
 #define FLYBACK                     550
@@ -996,7 +996,7 @@ struct __fb_timings {
  * @hfreq: horizontal freq
  *
  * DESCRIPTION:
- * vblank = right_margin + vsync_len + left_margin 
+ * vblank = right_margin + vsync_len + left_margin
  *
  *    given: right_margin = 1 (V_FRONTPORCH)
  *           vsync_len    = 3
@@ -1010,12 +1010,12 @@ static u32 fb_get_vblank(u32 hfreq)
 {
 	u32 vblank;
 
-	vblank = (hfreq * FLYBACK)/1000; 
+	vblank = (hfreq * FLYBACK)/1000;
 	vblank = (vblank + 500)/1000;
 	return (vblank + V_FRONTPORCH);
 }
 
-/** 
+/**
  * fb_get_hblank_by_freq - get horizontal blank time given hfreq
  * @hfreq: horizontal freq
  * @xres: horizontal resolution in pixels
@@ -1031,7 +1031,7 @@ static u32 fb_get_vblank(u32 hfreq)
  *
  * where: C = ((offset - scale factor) * blank_scale)
  *            -------------------------------------- + scale factor
- *                        256 
+ *                        256
  *        M = blank_scale * gradient
  *
  */
@@ -1039,7 +1039,7 @@ static u32 fb_get_hblank_by_hfreq(u32 hf
 {
 	u32 c_val, m_val, duty_cycle, hblank;
 
-	c_val = (((H_OFFSET - H_SCALEFACTOR) * H_BLANKSCALE)/256 + 
+	c_val = (((H_OFFSET - H_SCALEFACTOR) * H_BLANKSCALE)/256 +
 		 H_SCALEFACTOR) * 1000;
 	m_val = (H_BLANKSCALE * H_GRADIENT)/256;
 	m_val = (m_val * 1000000)/hfreq;
@@ -1048,7 +1048,7 @@ static u32 fb_get_hblank_by_hfreq(u32 hf
 	return (hblank);
 }
 
-/** 
+/**
  * fb_get_hblank_by_dclk - get horizontal blank time given pixelclock
  * @dclk: pixelclock in Hz
  * @xres: horizontal resolution in pixels
@@ -1061,7 +1061,7 @@ static u32 fb_get_hblank_by_hfreq(u32 hf
  *
  * duty cycle = percent of htotal assigned to inactive display
  * duty cycle = C - (M * h_period)
- * 
+ *
  * where: h_period = SQRT(100 - C + (0.4 * xres * M)/dclk) + C - 100
  *                   -----------------------------------------------
  *                                    2 * M
@@ -1077,11 +1077,11 @@ static u32 fb_get_hblank_by_dclk(u32 dcl
 	h_period = 100 - C_VAL;
 	h_period *= h_period;
 	h_period += (M_VAL * xres * 2 * 1000)/(5 * dclk);
-	h_period *=10000; 
+	h_period *=10000;
 
 	h_period = int_sqrt(h_period);
 	h_period -= (100 - C_VAL) * 100;
-	h_period *= 1000; 
+	h_period *= 1000;
 	h_period /= 2 * M_VAL;
 
 	duty_cycle = C_VAL * 1000 - (M_VAL * h_period)/100;
@@ -1089,7 +1089,7 @@ static u32 fb_get_hblank_by_dclk(u32 dcl
 	hblank &= ~15;
 	return (hblank);
 }
-	
+
 /**
  * fb_get_hfreq - estimate hsync
  * @vfreq: vertical refresh rate
@@ -1100,13 +1100,13 @@ static u32 fb_get_hblank_by_dclk(u32 dcl
  *          (yres + front_port) * vfreq * 1000000
  * hfreq = -------------------------------------
  *          (1000000 - (vfreq * FLYBACK)
- * 
+ *
  */
 
 static u32 fb_get_hfreq(u32 vfreq, u32 yres)
 {
 	u32 divisor, hfreq;
-	
+
 	divisor = (1000000 - (vfreq * FLYBACK))/1000;
 	hfreq = (yres + V_FRONTPORCH) * vfreq  * 1000;
 	return (hfreq/divisor);
@@ -1117,7 +1117,7 @@ static void fb_timings_vfreq(struct __fb
 	timings->hfreq = fb_get_hfreq(timings->vfreq, timings->vactive);
 	timings->vblank = fb_get_vblank(timings->hfreq);
 	timings->vtotal = timings->vactive + timings->vblank;
-	timings->hblank = fb_get_hblank_by_hfreq(timings->hfreq, 
+	timings->hblank = fb_get_hblank_by_hfreq(timings->hfreq,
 						 timings->hactive);
 	timings->htotal = timings->hactive + timings->hblank;
 	timings->dclk = timings->htotal * timings->hfreq;
@@ -1128,7 +1128,7 @@ static void fb_timings_hfreq(struct __fb
 	timings->vblank = fb_get_vblank(timings->hfreq);
 	timings->vtotal = timings->vactive + timings->vblank;
 	timings->vfreq = timings->hfreq/timings->vtotal;
-	timings->hblank = fb_get_hblank_by_hfreq(timings->hfreq, 
+	timings->hblank = fb_get_hblank_by_hfreq(timings->hfreq,
 						 timings->hactive);
 	timings->htotal = timings->hactive + timings->hblank;
 	timings->dclk = timings->htotal * timings->hfreq;
@@ -1136,7 +1136,7 @@ static void fb_timings_hfreq(struct __fb
 
 static void fb_timings_dclk(struct __fb_timings *timings)
 {
-	timings->hblank = fb_get_hblank_by_dclk(timings->dclk, 
+	timings->hblank = fb_get_hblank_by_dclk(timings->dclk,
 						timings->hactive);
 	timings->htotal = timings->hactive + timings->hblank;
 	timings->hfreq = timings->dclk/timings->htotal;
@@ -1156,29 +1156,29 @@ static void fb_timings_dclk(struct __fb_
  * @info: pointer to fb_info
  *
  * DESCRIPTION:
- * Calculates video mode based on monitor specs using VESA GTF. 
- * The GTF is best for VESA GTF compliant monitors but is 
+ * Calculates video mode based on monitor specs using VESA GTF.
+ * The GTF is best for VESA GTF compliant monitors but is
  * specifically formulated to work for older monitors as well.
  *
- * If @flag==0, the function will attempt to maximize the 
+ * If @flag==0, the function will attempt to maximize the
  * refresh rate.  Otherwise, it will calculate timings based on
- * the flag and accompanying value.  
+ * the flag and accompanying value.
  *
- * If FB_IGNOREMON bit is set in @flags, monitor specs will be 
+ * If FB_IGNOREMON bit is set in @flags, monitor specs will be
  * ignored and @var will be filled with the calculated timings.
  *
  * All calculations are based on the VESA GTF Spreadsheet
  * available at VESA's public ftp (http://www.vesa.org).
- * 
+ *
  * NOTES:
  * The timings generated by the GTF will be different from VESA
  * DMT.  It might be a good idea to keep a table of standard
  * VESA modes as well.  The GTF may also not work for some displays,
  * such as, and especially, analog TV.
- *   
+ *
  * REQUIRES:
  * A valid info->monspecs, otherwise 'safe numbers' will be used.
- */ 
+ */
 int fb_get_mode(int flags, u32 val, struct fb_var_screeninfo *var, struct fb_info *info)
 {
 	struct __fb_timings *timings;
@@ -1191,7 +1191,7 @@ int fb_get_mode(int flags, u32 val, stru
 	if (!timings)
 		return -ENOMEM;
 
-	/* 
+	/*
 	 * If monspecs are invalid, use values that are enough
 	 * for 640x480@60
 	 */
@@ -1214,7 +1214,7 @@ int fb_get_mode(int flags, u32 val, stru
 
 	timings->hactive = var->xres;
 	timings->vactive = var->yres;
-	if (var->vmode & FB_VMODE_INTERLACED) { 
+	if (var->vmode & FB_VMODE_INTERLACED) {
 		timings->vactive /= 2;
 		interlace = 2;
 	}
@@ -1250,9 +1250,9 @@ int fb_get_mode(int flags, u32 val, stru
 		break;
 	default:
 		err = -EINVAL;
-		
-	} 
-	
+
+	}
+
 	if (err || (!(flags & FB_IGNOREMON) &&
 	    (timings->vfreq < vfmin || timings->vfreq > vfmax ||
 	     timings->hfreq < hfmin || timings->hfreq > hfmax ||
@@ -1269,7 +1269,7 @@ int fb_get_mode(int flags, u32 val, stru
 		var->upper_margin = (timings->vblank * interlace)/dscan -
 			(var->vsync_len + var->lower_margin);
 	}
-	
+
 	kfree(timings);
 	return err;
 }
@@ -1291,7 +1291,7 @@ int fb_get_mode(int flags, u32 val, stru
 	return -EINVAL;
 }
 #endif /* CONFIG_FB_MODE_HELPERS */
-	
+
 /*
  * fb_validate_mode - validates var against monitor capabilities
  * @var: pointer to fb_var_screeninfo
@@ -1309,7 +1309,7 @@ int fb_validate_mode(const struct fb_var
 	u32 hfreq, vfreq, htotal, vtotal, pixclock;
 	u32 hfmin, hfmax, vfmin, vfmax, dclkmin, dclkmax;
 
-	/* 
+	/*
 	 * If monspecs are invalid, use values that are enough
 	 * for 640x480@60
 	 */
@@ -1333,10 +1333,10 @@ int fb_validate_mode(const struct fb_var
 	if (!var->pixclock)
 		return -EINVAL;
 	pixclock = PICOS2KHZ(var->pixclock) * 1000;
-	   
-	htotal = var->xres + var->right_margin + var->hsync_len + 
+
+	htotal = var->xres + var->right_margin + var->hsync_len +
 		var->left_margin;
-	vtotal = var->yres + var->lower_margin + var->vsync_len + 
+	vtotal = var->yres + var->lower_margin + var->vsync_len +
 		var->upper_margin;
 
 	if (var->vmode & FB_VMODE_INTERLACED)
@@ -1349,7 +1349,7 @@ int fb_validate_mode(const struct fb_var
 
 	vfreq = hfreq/vtotal;
 
-	return (vfreq < vfmin || vfreq > vfmax || 
+	return (vfreq < vfmin || vfreq > vfmax ||
 		hfreq < hfmin || hfreq > hfmax ||
 		pixclock < dclkmin || pixclock > dclkmax) ?
 		-EINVAL : 0;
_

Patches currently in -mm which might be from andre@bitwigglers.org are

git-arm.patch
sdio_uart-fix-sign-of-paramter-status-in-sdio_uart_receive_chars.patch
fbmon-remove-unnecessary-local-variable.patch
fbmon-cleanup-trailing-whitespaces.patch
