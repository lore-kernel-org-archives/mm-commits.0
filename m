From: akpm@linux-foundation.org
Subject: - radeonfb-drop-redundant-rtrace-macro.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:58:20 -0700
Message-ID: <200804282158.m3SLwKkS018483@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56434 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965329AbYD1V6c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:58:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, adaplas@pol.net, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     radeonfb: drop redundant RTRACE macro
has been removed from the -mm tree.  Its filename was
     radeonfb-drop-redundant-rtrace-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: radeonfb: drop redundant RTRACE macro
From: Jean Delvare <khali@linux-fr.org>

RTRACE() does exactly the same thing as the standard pr_debug() call, so just
use the latter.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/radeon_base.c    |   34 ++++++++---------
 drivers/video/aty/radeon_i2c.c     |    8 ++--
 drivers/video/aty/radeon_monitor.c |   54 +++++++++++++--------------
 drivers/video/aty/radeonfb.h       |   10 -----
 4 files changed, 48 insertions(+), 58 deletions(-)

diff -puN drivers/video/aty/radeon_base.c~radeonfb-drop-redundant-rtrace-macro drivers/video/aty/radeon_base.c
--- a/drivers/video/aty/radeon_base.c~radeonfb-drop-redundant-rtrace-macro
+++ a/drivers/video/aty/radeon_base.c
@@ -1490,7 +1490,7 @@ static void radeon_calc_pll_regs(struct 
 		freq = rinfo->pll.ppll_max;
 	if (freq*12 < rinfo->pll.ppll_min)
 		freq = rinfo->pll.ppll_min / 12;
-	RTRACE("freq = %lu, PLL min = %u, PLL max = %u\n",
+	pr_debug("freq = %lu, PLL min = %u, PLL max = %u\n",
 	       freq, rinfo->pll.ppll_min, rinfo->pll.ppll_max);
 
 	for (post_div = &post_divs[0]; post_div->divider; ++post_div) {
@@ -1511,7 +1511,7 @@ static void radeon_calc_pll_regs(struct 
 		post_div = &post_divs[post_div->bitvalue];
 		pll_output_freq = post_div->divider * freq;
 	}
-	RTRACE("ref_div = %d, ref_clk = %d, output_freq = %d\n",
+	pr_debug("ref_div = %d, ref_clk = %d, output_freq = %d\n",
 	       rinfo->pll.ref_div, rinfo->pll.ref_clk,
 	       pll_output_freq);
 
@@ -1521,7 +1521,7 @@ static void radeon_calc_pll_regs(struct 
 		post_div = &post_divs[post_div->bitvalue];
 		pll_output_freq = post_div->divider * freq;
 	}
-	RTRACE("ref_div = %d, ref_clk = %d, output_freq = %d\n",
+	pr_debug("ref_div = %d, ref_clk = %d, output_freq = %d\n",
 	       rinfo->pll.ref_div, rinfo->pll.ref_clk,
 	       pll_output_freq);
 
@@ -1530,9 +1530,9 @@ static void radeon_calc_pll_regs(struct 
 	regs->ppll_ref_div = rinfo->pll.ref_div;
 	regs->ppll_div_3 = fb_div | (post_div->bitvalue << 16);
 
-	RTRACE("post div = 0x%x\n", post_div->bitvalue);
-	RTRACE("fb_div = 0x%x\n", fb_div);
-	RTRACE("ppll_div_3 = 0x%x\n", regs->ppll_div_3);
+	pr_debug("post div = 0x%x\n", post_div->bitvalue);
+	pr_debug("fb_div = 0x%x\n", fb_div);
+	pr_debug("ppll_div_3 = 0x%x\n", regs->ppll_div_3);
 }
 
 static int radeonfb_set_par(struct fb_info *info)
@@ -1604,9 +1604,9 @@ static int radeonfb_set_par(struct fb_in
 	dotClock = 1000000000 / pixClock;
 	freq = dotClock / 10; /* x100 */
 
-	RTRACE("hStart = %d, hEnd = %d, hTotal = %d\n",
+	pr_debug("hStart = %d, hEnd = %d, hTotal = %d\n",
 		hSyncStart, hSyncEnd, hTotal);
-	RTRACE("vStart = %d, vEnd = %d, vTotal = %d\n",
+	pr_debug("vStart = %d, vEnd = %d, vTotal = %d\n",
 		vSyncStart, vSyncEnd, vTotal);
 
 	hsync_wid = (hSyncEnd - hSyncStart) / 8;
@@ -1715,16 +1715,16 @@ static int radeonfb_set_par(struct fb_in
 		newmode->surf_info[i] = 0;
 	}
 
-	RTRACE("h_total_disp = 0x%x\t   hsync_strt_wid = 0x%x\n",
+	pr_debug("h_total_disp = 0x%x\t   hsync_strt_wid = 0x%x\n",
 		newmode->crtc_h_total_disp, newmode->crtc_h_sync_strt_wid);
-	RTRACE("v_total_disp = 0x%x\t   vsync_strt_wid = 0x%x\n",
+	pr_debug("v_total_disp = 0x%x\t   vsync_strt_wid = 0x%x\n",
 		newmode->crtc_v_total_disp, newmode->crtc_v_sync_strt_wid);
 
 	rinfo->bpp = mode->bits_per_pixel;
 	rinfo->depth = depth;
 
-	RTRACE("pixclock = %lu\n", (unsigned long)pixClock);
-	RTRACE("freq = %lu\n", (unsigned long)freq);
+	pr_debug("pixclock = %lu\n", (unsigned long)pixClock);
+	pr_debug("freq = %lu\n", (unsigned long)freq);
 
 	/* We use PPLL_DIV_3 */
 	newmode->clk_cntl_index = 0x300;
@@ -1988,7 +1988,7 @@ static void fixup_memory_mappings(struct
 	if (rinfo->has_CRTC2)
 		OUTREG(CRTC2_GEN_CNTL, save_crtc2_gen_cntl);	
 
-	RTRACE("aper_base: %08x MC_FB_LOC to: %08x, MC_AGP_LOC to: %08x\n",
+	pr_debug("aper_base: %08x MC_FB_LOC to: %08x, MC_AGP_LOC to: %08x\n",
 		aper_base,
 		((aper_base + aper_size - 1) & 0xffff0000) | (aper_base >> 16),
 		0xffff0000 | (agp_base >> 16));
@@ -2085,7 +2085,7 @@ static void radeon_identify_vram(struct 
 	 * ToDo: identify these cases
 	 */
 
-	RTRACE("radeonfb (%s): Found %ldk of %s %d bits wide videoram\n",
+	pr_debug("radeonfb (%s): Found %ldk of %s %d bits wide videoram\n",
 	       pci_name(rinfo->pdev),
 	       rinfo->video_ram / 1024,
 	       rinfo->vram_ddr ? "DDR" : "SDRAM",
@@ -2162,7 +2162,7 @@ static int __devinit radeonfb_pci_regist
 	int ret;
 	unsigned char c1, c2;
 
-	RTRACE("radeonfb_pci_register BEGIN\n");
+	pr_debug("radeonfb_pci_register BEGIN\n");
 	
 	/* Enable device in PCI config */
 	ret = pci_enable_device(pdev);
@@ -2287,7 +2287,7 @@ static int __devinit radeonfb_pci_regist
 		goto err_unmap_rom;
 	}
 
-	RTRACE("radeonfb (%s): mapped %ldk videoram\n", pci_name(rinfo->pdev),
+	pr_debug("radeonfb (%s): mapped %ldk videoram\n", pci_name(rinfo->pdev),
 	       rinfo->mapped_vram/1024);
 
 	/*
@@ -2382,7 +2382,7 @@ static int __devinit radeonfb_pci_regist
 
 	if (rinfo->bios_seg)
 		radeon_unmap_ROM(rinfo, pdev);
-	RTRACE("radeonfb_pci_register END\n");
+	pr_debug("radeonfb_pci_register END\n");
 
 	return 0;
 err_unmap_fb:
diff -puN drivers/video/aty/radeon_i2c.c~radeonfb-drop-redundant-rtrace-macro drivers/video/aty/radeon_i2c.c
--- a/drivers/video/aty/radeon_i2c.c~radeonfb-drop-redundant-rtrace-macro
+++ a/drivers/video/aty/radeon_i2c.c
@@ -149,21 +149,21 @@ int radeon_probe_i2c_connector(struct ra
 	if (out_edid)
 		*out_edid = edid;
 	if (!edid) {
-		RTRACE("radeonfb: I2C (port %d) ... not found\n", conn);
+		pr_debug("radeonfb: I2C (port %d) ... not found\n", conn);
 		return MT_NONE;
 	}
 	if (edid[0x14] & 0x80) {
 		/* Fix detection using BIOS tables */
 		if (rinfo->is_mobility /*&& conn == ddc_dvi*/ &&
 		    (INREG(LVDS_GEN_CNTL) & LVDS_ON)) {
-			RTRACE("radeonfb: I2C (port %d) ... found LVDS panel\n", conn);
+			pr_debug("radeonfb: I2C (port %d) ... found LVDS panel\n", conn);
 			return MT_LCD;
 		} else {
-			RTRACE("radeonfb: I2C (port %d) ... found TMDS panel\n", conn);
+			pr_debug("radeonfb: I2C (port %d) ... found TMDS panel\n", conn);
 			return MT_DFP;
 		}
 	}
-       	RTRACE("radeonfb: I2C (port %d) ... found CRT display\n", conn);
+	pr_debug("radeonfb: I2C (port %d) ... found CRT display\n", conn);
 	return MT_CRT;
 }
 
diff -puN drivers/video/aty/radeon_monitor.c~radeonfb-drop-redundant-rtrace-macro drivers/video/aty/radeon_monitor.c
--- a/drivers/video/aty/radeon_monitor.c~radeonfb-drop-redundant-rtrace-macro
+++ a/drivers/video/aty/radeon_monitor.c
@@ -69,11 +69,11 @@ static int __devinit radeon_parse_montyp
 	u8 *tmp;
         int i, mt = MT_NONE;  
 	
-	RTRACE("analyzing OF properties...\n");
+	pr_debug("analyzing OF properties...\n");
 	pmt = of_get_property(dp, "display-type", NULL);
 	if (!pmt)
 		return MT_NONE;
-	RTRACE("display-type: %s\n", pmt);
+	pr_debug("display-type: %s\n", pmt);
 	/* OF says "LCD" for DFP as well, we discriminate from the caller of this
 	 * function
 	 */
@@ -117,7 +117,7 @@ static int __devinit radeon_probe_OF_hea
 {
         struct device_node *dp;
 
-	RTRACE("radeon_probe_OF_head\n");
+	pr_debug("radeon_probe_OF_head\n");
 
         dp = rinfo->of_node;
         while (dp == NULL)
@@ -135,7 +135,7 @@ static int __devinit radeon_probe_OF_hea
 			if (!pname)
 				return MT_NONE;
 			len = strlen(pname);
-			RTRACE("head: %s (letter: %c, head_no: %d)\n",
+			pr_debug("head: %s (letter: %c, head_no: %d)\n",
 			       pname, pname[len-1], head_no);
 			if (pname[len-1] == 'A' && head_no == 0) {
 				int mt = radeon_parse_montype_prop(dp, out_EDID, 0);
@@ -185,7 +185,7 @@ static int __devinit radeon_get_panel_in
 		rinfo->panel_info.xres, rinfo->panel_info.yres);
 
 	rinfo->panel_info.pwr_delay = BIOS_IN16(tmp + 44);
-	RTRACE("BIOS provided panel power delay: %d\n", rinfo->panel_info.pwr_delay);
+	pr_debug("BIOS provided panel power delay: %d\n", rinfo->panel_info.pwr_delay);
 	if (rinfo->panel_info.pwr_delay > 2000 || rinfo->panel_info.pwr_delay <= 0)
 		rinfo->panel_info.pwr_delay = 2000;
 
@@ -199,16 +199,16 @@ static int __devinit radeon_get_panel_in
 	    rinfo->panel_info.fbk_divider > 3) {
 		rinfo->panel_info.use_bios_dividers = 1;
 		printk(KERN_INFO "radeondb: BIOS provided dividers will be used\n");
-		RTRACE("ref_divider = %x\n", rinfo->panel_info.ref_divider);
-		RTRACE("post_divider = %x\n", rinfo->panel_info.post_divider);
-		RTRACE("fbk_divider = %x\n", rinfo->panel_info.fbk_divider);
+		pr_debug("ref_divider = %x\n", rinfo->panel_info.ref_divider);
+		pr_debug("post_divider = %x\n", rinfo->panel_info.post_divider);
+		pr_debug("fbk_divider = %x\n", rinfo->panel_info.fbk_divider);
 	}
-	RTRACE("Scanning BIOS table ...\n");
+	pr_debug("Scanning BIOS table ...\n");
 	for(i=0; i<32; i++) {
 		tmp0 = BIOS_IN16(tmp+64+i*2);
 		if (tmp0 == 0)
 			break;
-		RTRACE(" %d x %d\n", BIOS_IN16(tmp0), BIOS_IN16(tmp0+2));
+		pr_debug(" %d x %d\n", BIOS_IN16(tmp0), BIOS_IN16(tmp0+2));
 		if ((BIOS_IN16(tmp0) == rinfo->panel_info.xres) &&
 		    (BIOS_IN16(tmp0+2) == rinfo->panel_info.yres)) {
 			rinfo->panel_info.hblank = (BIOS_IN16(tmp0+17) - BIOS_IN16(tmp0+19)) * 8;
@@ -227,19 +227,19 @@ static int __devinit radeon_get_panel_in
 			/* Mark panel infos valid */
 			rinfo->panel_info.valid = 1;
 
-			RTRACE("Found panel in BIOS table:\n");
-			RTRACE("  hblank: %d\n", rinfo->panel_info.hblank);
-			RTRACE("  hOver_plus: %d\n", rinfo->panel_info.hOver_plus);
-			RTRACE("  hSync_width: %d\n", rinfo->panel_info.hSync_width);
-			RTRACE("  vblank: %d\n", rinfo->panel_info.vblank);
-			RTRACE("  vOver_plus: %d\n", rinfo->panel_info.vOver_plus);
-			RTRACE("  vSync_width: %d\n", rinfo->panel_info.vSync_width);
-			RTRACE("  clock: %d\n", rinfo->panel_info.clock);
+			pr_debug("Found panel in BIOS table:\n");
+			pr_debug("  hblank: %d\n", rinfo->panel_info.hblank);
+			pr_debug("  hOver_plus: %d\n", rinfo->panel_info.hOver_plus);
+			pr_debug("  hSync_width: %d\n", rinfo->panel_info.hSync_width);
+			pr_debug("  vblank: %d\n", rinfo->panel_info.vblank);
+			pr_debug("  vOver_plus: %d\n", rinfo->panel_info.vOver_plus);
+			pr_debug("  vSync_width: %d\n", rinfo->panel_info.vSync_width);
+			pr_debug("  clock: %d\n", rinfo->panel_info.clock);
 				
 			return 1;
 		}
 	}
-	RTRACE("Didn't find panel in BIOS table !\n");
+	pr_debug("Didn't find panel in BIOS table !\n");
 
 	return 0;
 }
@@ -271,18 +271,18 @@ static void __devinit radeon_parse_conne
 	 * DEBUG is enabled
 	 */
 	chips = BIOS_IN8(offset++) >> 4;
-	RTRACE("%d chips in connector info\n", chips);
+	pr_debug("%d chips in connector info\n", chips);
 	for (i = 0; i < chips; i++) {
 		tmp = BIOS_IN8(offset++);
 		connectors = tmp & 0x0f;
-		RTRACE(" - chip %d has %d connectors\n", tmp >> 4, connectors);
+		pr_debug(" - chip %d has %d connectors\n", tmp >> 4, connectors);
 		for (conn = 0; ; conn++) {
 			tmp = BIOS_IN16(offset);
 			if (tmp == 0)
 				break;
 			offset += 2;
 			type = (tmp >> 12) & 0x0f;
-			RTRACE("  * connector %d of type %d (%s) : %04x\n",
+			pr_debug("  * connector %d of type %d (%s) : %04x\n",
 			       conn, type, __conn_type_table[type], tmp);
 		}
 	}
@@ -449,7 +449,7 @@ void __devinit radeon_probe_screens(stru
 		 * a layout for each card ?
 		 */
 
-		RTRACE("Using specified monitor layout: %s", monitor_layout);
+		pr_debug("Using specified monitor layout: %s", monitor_layout);
 #ifdef CONFIG_FB_RADEON_I2C
 		if (!ignore_edid) {
 			if (rinfo->mon1_type != MT_NONE)
@@ -479,7 +479,7 @@ void __devinit radeon_probe_screens(stru
 		 * Auto-detecting display type (well... trying to ...)
 		 */
 		
-		RTRACE("Starting monitor auto detection...\n");
+		pr_debug("Starting monitor auto detection...\n");
 
 #if defined(DEBUG) && defined(CONFIG_FB_RADEON_I2C)
 		{
@@ -756,7 +756,7 @@ void __devinit radeon_check_modes(struct
 	if (!rinfo->panel_info.use_bios_dividers && rinfo->mon1_type != MT_CRT
 	    && rinfo->mon1_EDID) {
 		struct fb_var_screeninfo var;
-		RTRACE("Parsing EDID data for panel info\n");
+		pr_debug("Parsing EDID data for panel info\n");
 		if (fb_parse_edid(rinfo->mon1_EDID, &var) == 0) {
 			if (var.xres >= rinfo->panel_info.xres &&
 			    var.yres >= rinfo->panel_info.yres)
@@ -776,7 +776,7 @@ void __devinit radeon_check_modes(struct
 	if (rinfo->mon1_type != MT_CRT && rinfo->panel_info.valid) {
 		struct fb_var_screeninfo *var = &info->var;
 
-		RTRACE("Setting up default mode based on panel info\n");
+		pr_debug("Setting up default mode based on panel info\n");
 		var->xres = rinfo->panel_info.xres;
 		var->yres = rinfo->panel_info.yres;
 		var->xres_virtual = rinfo->panel_info.xres;
@@ -824,7 +824,7 @@ void __devinit radeon_check_modes(struct
 		int			dbsize;
 		char			modename[32];
 
-		RTRACE("Guessing panel info...\n");
+		pr_debug("Guessing panel info...\n");
 		if (rinfo->panel_info.xres == 0 || rinfo->panel_info.yres == 0) {
 			u32 tmp = INREG(FP_HORZ_STRETCH) & HORZ_PANEL_SIZE;
 			rinfo->panel_info.xres = ((tmp >> HORZ_PANEL_SHIFT) + 1) * 8;
diff -puN drivers/video/aty/radeonfb.h~radeonfb-drop-redundant-rtrace-macro drivers/video/aty/radeonfb.h
--- a/drivers/video/aty/radeonfb.h~radeonfb-drop-redundant-rtrace-macro
+++ a/drivers/video/aty/radeonfb.h
@@ -369,16 +369,6 @@ struct radeonfb_info {
 
 
 /*
- * Debugging stuffs
- */
-#ifdef DEBUG
-#define RTRACE		printk
-#else
-#define RTRACE		if(0) printk
-#endif
-
