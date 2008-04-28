From: akpm@linux-foundation.org
Subject: - video-replace-remaining-__function__-occurrences.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:59:48 -0700
Message-ID: <200804282159.m3SLxmfc018619@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57552 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965770AbYD1WBb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 18:01:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, adaplas@gmail.com, adaplas@pol.net, ben-linux@fluff.org, benh@kernel.crashing.org, bunk@stusta.de, khali@linux-fr.org, krzysztof.h1@wp.pl, rmk+kernel@arm.li


The patch titled
     video: replace remaining __FUNCTION__ occurrences
has been removed from the -mm tree.  Its filename was
     video-replace-remaining-__function__-occurrences.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: video: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Antonino Daplas <adaplas@gmail.com>
Cc: Antonino A. Daplas <adaplas@gmail.com>
Cc: Antonino Daplas <adaplas@pol.net>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Adrian Bunk <bunk@stusta.de>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/amifb.c                   |    2 -
 drivers/video/aty/aty128fb.c            |    2 -
 drivers/video/aty/mach64_ct.c           |   16 ++++----
 drivers/video/bf54x-lq043fb.c           |    6 +--
 drivers/video/cfbimgblt.c               |    2 -
 drivers/video/cirrusfb.c                |    4 +-
 drivers/video/console/fbcon.c           |    2 -
 drivers/video/imsttfb.c                 |    2 -
 drivers/video/imxfb.c                   |    6 +--
 drivers/video/matrox/matroxfb_DAC1064.c |   36 +++++++++---------
 drivers/video/matrox/matroxfb_Ti3026.c  |   16 ++++----
 drivers/video/matrox/matroxfb_accel.c   |   14 +++----
 drivers/video/matrox/matroxfb_base.c    |   42 +++++++++++-----------
 drivers/video/matrox/matroxfb_crtc2.c   |    2 -
 drivers/video/matrox/matroxfb_maven.c   |    2 -
 drivers/video/matrox/matroxfb_misc.c    |   12 +++---
 drivers/video/modedb.c                  |    2 -
 drivers/video/nvidia/nvidia.c           |    6 +--
 drivers/video/pm2fb.c                   |    2 -
 drivers/video/pm3fb.c                   |    2 -
 drivers/video/riva/fbdev.c              |    6 +--
 drivers/video/s3c2410fb.c               |    6 +--
 drivers/video/sa1100fb.h                |    2 -
 drivers/video/sis/sis.h                 |    2 -
 drivers/video/sstfb.c                   |   10 ++---
 drivers/video/stifb.c                   |    4 +-
 drivers/video/sysimgblt.c               |    2 -
 drivers/video/tdfxfb.c                  |    2 -
 28 files changed, 106 insertions(+), 106 deletions(-)

diff -puN drivers/video/amifb.c~video-replace-remaining-__function__-occurrences drivers/video/amifb.c
--- a/drivers/video/amifb.c~video-replace-remaining-__function__-occurrences
+++ a/drivers/video/amifb.c
@@ -96,7 +96,7 @@
 #endif
 
 #ifdef DEBUG
-#  define DPRINTK(fmt, args...)	printk(KERN_DEBUG "%s: " fmt, __FUNCTION__ , ## args)
+#  define DPRINTK(fmt, args...)	printk(KERN_DEBUG "%s: " fmt, __func__ , ## args)
 #else
 #  define DPRINTK(fmt, args...)
 #endif
diff -puN drivers/video/aty/aty128fb.c~video-replace-remaining-__function__-occurrences drivers/video/aty/aty128fb.c
--- a/drivers/video/aty/aty128fb.c~video-replace-remaining-__function__-occurrences
+++ a/drivers/video/aty/aty128fb.c
@@ -91,7 +91,7 @@
 #undef DEBUG
 
 #ifdef DEBUG
-#define DBG(fmt, args...)		printk(KERN_DEBUG "aty128fb: %s " fmt, __FUNCTION__, ##args);
+#define DBG(fmt, args...)		printk(KERN_DEBUG "aty128fb: %s " fmt, __func__, ##args);
 #else
 #define DBG(fmt, args...)
 #endif
diff -puN drivers/video/aty/mach64_ct.c~video-replace-remaining-__function__-occurrences drivers/video/aty/mach64_ct.c
--- a/drivers/video/aty/mach64_ct.c~video-replace-remaining-__function__-occurrences
+++ a/drivers/video/aty/mach64_ct.c
@@ -197,7 +197,7 @@ static int aty_dsp_gt(const struct fb_in
 	pll->dsp_config = (dsp_precision << 20) | (pll->dsp_loop_latency << 16) | dsp_xclks;
 #ifdef DEBUG
 	printk("atyfb(%s): dsp_config 0x%08x, dsp_on_off 0x%08x\n",
-		__FUNCTION__, pll->dsp_config, pll->dsp_on_off);
+		__func__, pll->dsp_config, pll->dsp_on_off);
 #endif
 	return 0;
 }
@@ -225,7 +225,7 @@ static int aty_valid_pll_ct(const struct
 		(par->ref_clk_per * pll->pll_ref_div);
 #ifdef DEBUG
 	printk("atyfb(%s): pllvclk=%d MHz, vclk=%d MHz\n",
-		__FUNCTION__, pllvclk, pllvclk / pll->vclk_post_div_real);
+		__func__, pllvclk, pllvclk / pll->vclk_post_div_real);
 #endif
 	pll->pll_vclk_cntl = 0x03; /* VCLK = PLL_VCLK/VCLKx_POST */
 
@@ -269,7 +269,7 @@ static u32 aty_pll_to_var_ct(const struc
 	}
 #endif
 #ifdef DEBUG
-	printk("atyfb(%s): calculated 0x%08X(%i)\n", __FUNCTION__, ret, ret);
+	printk("atyfb(%s): calculated 0x%08X(%i)\n", __func__, ret, ret);
 #endif
 	return ret;
 }
@@ -284,11 +284,11 @@ void aty_set_pll_ct(const struct fb_info
 #ifdef DEBUG
 	printk("atyfb(%s): about to program:\n"
 		"pll_ext_cntl=0x%02x pll_gen_cntl=0x%02x pll_vclk_cntl=0x%02x\n",
-		__FUNCTION__,
+		__func__,
 		pll->ct.pll_ext_cntl, pll->ct.pll_gen_cntl, pll->ct.pll_vclk_cntl);
 
 	printk("atyfb(%s): setting clock %lu for FeedBackDivider %i, ReferenceDivider %i, PostDivider %i(%i)\n",
-		__FUNCTION__,
+		__func__,
 		par->clk_wr_offset, pll->ct.vclk_fb_div,
 		pll->ct.pll_ref_div, pll->ct.vclk_post_div, pll->ct.vclk_post_div_real);
 #endif
@@ -428,7 +428,7 @@ static int __devinit aty_init_pll_ct(con
 
 #ifdef DEBUG
 	printk("atyfb(%s): mclk_fb_mult=%d, xclk_post_div=%d\n",
-		__FUNCTION__, pll->ct.mclk_fb_mult, pll->ct.xclk_post_div);
+		__func__, pll->ct.mclk_fb_mult, pll->ct.xclk_post_div);
 #endif
 
 	memcntl = aty_ld_le32(MEM_CNTL, par);
@@ -540,7 +540,7 @@ static int __devinit aty_init_pll_ct(con
 	pllmclk = (1000000 * pll->ct.mclk_fb_mult * pll->ct.mclk_fb_div) /
 			(par->ref_clk_per * pll->ct.pll_ref_div);
 	printk("atyfb(%s): pllmclk=%d MHz, xclk=%d MHz\n",
-		__FUNCTION__, pllmclk, pllmclk / pll->ct.xclk_post_div_real);
+		__func__, pllmclk, pllmclk / pll->ct.xclk_post_div_real);
 #endif
 
 	if (M64_HAS(SDRAM_MAGIC_PLL) && (par->ram_type >= SDRAM))
@@ -581,7 +581,7 @@ static int __devinit aty_init_pll_ct(con
 		pllsclk = (1000000 * 2 * pll->ct.sclk_fb_div) /
 			(par->ref_clk_per * pll->ct.pll_ref_div);
 		printk("atyfb(%s): use sclk, pllsclk=%d MHz, sclk=mclk=%d MHz\n",
-			__FUNCTION__, pllsclk, pllsclk / sclk_post_div_real);
+			__func__, pllsclk, pllsclk / sclk_post_div_real);
 #endif
 	}
 
diff -puN drivers/video/bf54x-lq043fb.c~video-replace-remaining-__function__-occurrences drivers/video/bf54x-lq043fb.c
--- a/drivers/video/bf54x-lq043fb.c~video-replace-remaining-__function__-occurrences
+++ a/drivers/video/bf54x-lq043fb.c
@@ -336,7 +336,7 @@ static int bfin_bf54x_fb_check_var(struc
 {
 
 	if (var->bits_per_pixel != LCD_BPP) {
-		pr_debug("%s: depth not supported: %u BPP\n", __FUNCTION__,
+		pr_debug("%s: depth not supported: %u BPP\n", __func__,
 			 var->bits_per_pixel);
 		return -EINVAL;
 	}
@@ -345,7 +345,7 @@ static int bfin_bf54x_fb_check_var(struc
 	    info->var.xres_virtual != var->xres_virtual ||
 	    info->var.yres_virtual != var->yres_virtual) {
 		pr_debug("%s: Resolution not supported: X%u x Y%u \n",
-			 __FUNCTION__, var->xres, var->yres);
+			 __func__, var->xres, var->yres);
 		return -EINVAL;
 	}
 
@@ -355,7 +355,7 @@ static int bfin_bf54x_fb_check_var(struc
 
 	if ((info->fix.line_length * var->yres_virtual) > info->fix.smem_len) {
 		pr_debug("%s: Memory Limit requested yres_virtual = %u\n",
-			 __FUNCTION__, var->yres_virtual);
+			 __func__, var->yres_virtual);
 		return -ENOMEM;
 	}
 
diff -puN drivers/video/cfbimgblt.c~video-replace-remaining-__function__-occurrences drivers/video/cfbimgblt.c
--- a/drivers/video/cfbimgblt.c~video-replace-remaining-__function__-occurrences
+++ a/drivers/video/cfbimgblt.c
@@ -38,7 +38,7 @@
 #define DEBUG
 
 #ifdef DEBUG
-#define DPRINTK(fmt, args...) printk(KERN_DEBUG "%s: " fmt,__FUNCTION__,## args)
+#define DPRINTK(fmt, args...) printk(KERN_DEBUG "%s: " fmt,__func__,## args)
 #else
 #define DPRINTK(fmt, args...)
 #endif
diff -puN drivers/video/cirrusfb.c~video-replace-remaining-__function__-occurrences drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~video-replace-remaining-__function__-occurrences
+++ a/drivers/video/cirrusfb.c
@@ -81,7 +81,7 @@
 /* debug output */
 #ifdef CIRRUSFB_DEBUG
 #define DPRINTK(fmt, args...) \
-	printk(KERN_DEBUG "%s: " fmt, __FUNCTION__ , ## args)
+	printk(KERN_DEBUG "%s: " fmt, __func__ , ## args)
 #else
 #define DPRINTK(fmt, args...)
 #endif
@@ -91,7 +91,7 @@
 #define assert(expr) \
 	if (!(expr)) { \
 		printk("Assertion failed! %s,%s,%s,line=%d\n", \
-		#expr, __FILE__, __FUNCTION__, __LINE__); \
+		#expr, __FILE__, __func__, __LINE__); \
 	}
 #else
 #define assert(expr)
diff -puN drivers/video/console/fbcon.c~video-replace-remaining-__function__-occurrences drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~video-replace-remaining-__function__-occurrences
+++ a/drivers/video/console/fbcon.c
@@ -92,7 +92,7 @@
 #include "fbcon.h"
 
 #ifdef FBCONDEBUG
-#  define DPRINTK(fmt, args...) printk(KERN_DEBUG "%s: " fmt, __FUNCTION__ , ## args)
+#  define DPRINTK(fmt, args...) printk(KERN_DEBUG "%s: " fmt, __func__ , ## args)
 #else
 #  define DPRINTK(fmt, args...)
 #endif
diff -puN drivers/video/imsttfb.c~video-replace-remaining-__function__-occurrences drivers/video/imsttfb.c
--- a/drivers/video/imsttfb.c~video-replace-remaining-__function__-occurrences
+++ a/drivers/video/imsttfb.c
@@ -1478,7 +1478,7 @@ imsttfb_probe(struct pci_dev *pdev, cons
 	
 	dp = pci_device_to_OF_node(pdev);
 	if(dp)
-		printk(KERN_INFO "%s: OF name %s\n",__FUNCTION__, dp->name);
+		printk(KERN_INFO "%s: OF name %s\n",__func__, dp->name);
 	else
 		printk(KERN_ERR "imsttfb: no OF node for pci device\n");
 #endif /* CONFIG_PPC_OF */
diff -puN drivers/video/imxfb.c~video-replace-remaining-__function__-occurrences drivers/video/imxfb.c
--- a/drivers/video/imxfb.c~video-replace-remaining-__function__-occurrences
+++ a/drivers/video/imxfb.c
@@ -415,7 +415,7 @@ static void imxfb_setup_gpio(struct imxf
 static int imxfb_suspend(struct platform_device *dev, pm_message_t state)
 {
 	struct imxfb_info *fbi = platform_get_drvdata(dev);
-	pr_debug("%s\n",__FUNCTION__);
+	pr_debug("%s\n",__func__);
 
 	imxfb_disable_controller(fbi);
 	return 0;
@@ -424,7 +424,7 @@ static int imxfb_suspend(struct platform
 static int imxfb_resume(struct platform_device *dev)
 {
 	struct imxfb_info *fbi = platform_get_drvdata(dev);
-	pr_debug("%s\n",__FUNCTION__);
+	pr_debug("%s\n",__func__);
 
 	imxfb_enable_controller(fbi);
 	return 0;
@@ -440,7 +440,7 @@ static int __init imxfb_init_fbinfo(stru
 	struct fb_info *info = dev_get_drvdata(dev);
 	struct imxfb_info *fbi = info->par;
 
-	pr_debug("%s\n",__FUNCTION__);
+	pr_debug("%s\n",__func__);
 
 	info->pseudo_palette = kmalloc( sizeof(u32) * 16, GFP_KERNEL);
 	if (!info->pseudo_palette)
diff -puN drivers/video/matrox/matroxfb_DAC1064.c~video-replace-remaining-__function__-occurrences drivers/video/matrox/matroxfb_DAC1064.c
--- a/drivers/video/matrox/matroxfb_DAC1064.c~video-replace-remaining-__function__-occurrences
+++ a/drivers/video/matrox/matroxfb_DAC1064.c
@@ -37,7 +37,7 @@ static void DAC1064_calcclock(CPMINFO un
 	unsigned int fvco;
 	unsigned int p;
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 	
 	/* only for devices older than G450 */
 
@@ -83,7 +83,7 @@ static const unsigned char MGA1064_DAC[]
 static void DAC1064_setpclk(WPMINFO unsigned long fout) {
 	unsigned int m, n, p;
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	DAC1064_calcclock(PMINFO fout, ACCESS_FBINFO(max_pixel_clock), &m, &n, &p);
 	ACCESS_FBINFO(hw).DACclk[0] = m;
@@ -95,7 +95,7 @@ static void DAC1064_setmclk(WPMINFO int 
 	u_int32_t mx;
 	struct matrox_hw_state* hw = &ACCESS_FBINFO(hw);
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	if (ACCESS_FBINFO(devflags.noinit)) {
 		/* read MCLK and give up... */
@@ -338,7 +338,7 @@ void DAC1064_global_restore(WPMINFO2) {
 static int DAC1064_init_1(WPMINFO struct my_timming* m) {
 	struct matrox_hw_state* hw = &ACCESS_FBINFO(hw);
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	memcpy(hw->DACreg, MGA1064_DAC, sizeof(MGA1064_DAC_regs));
 	switch (ACCESS_FBINFO(fbcon).var.bits_per_pixel) {
@@ -374,7 +374,7 @@ static int DAC1064_init_1(WPMINFO struct
 static int DAC1064_init_2(WPMINFO struct my_timming* m) {
 	struct matrox_hw_state* hw = &ACCESS_FBINFO(hw);
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	if (ACCESS_FBINFO(fbcon).var.bits_per_pixel > 16) {	/* 256 entries */
 		int i;
@@ -418,7 +418,7 @@ static void DAC1064_restore_1(WPMINFO2) 
 
 	CRITFLAGS
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	CRITBEGIN
 
@@ -448,7 +448,7 @@ static void DAC1064_restore_2(WPMINFO2) 
 	unsigned int i;
 #endif
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 #ifdef DEBUG
 	dprintk(KERN_DEBUG "DAC1064regs ");
@@ -521,7 +521,7 @@ static struct matrox_altout g450out = {
 static int MGA1064_init(WPMINFO struct my_timming* m) {
 	struct matrox_hw_state* hw = &ACCESS_FBINFO(hw);
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	if (DAC1064_init_1(PMINFO m)) return 1;
 	if (matroxfb_vgaHWinit(PMINFO m)) return 1;
@@ -543,7 +543,7 @@ static int MGA1064_init(WPMINFO struct m
 static int MGAG100_init(WPMINFO struct my_timming* m) {
 	struct matrox_hw_state* hw = &ACCESS_FBINFO(hw);
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	if (DAC1064_init_1(PMINFO m)) return 1;
 	hw->MXoptionReg &= ~0x2000;
@@ -565,7 +565,7 @@ static int MGAG100_init(WPMINFO struct m
 #ifdef CONFIG_FB_MATROX_MYSTIQUE
 static void MGA1064_ramdac_init(WPMINFO2) {
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	/* ACCESS_FBINFO(features.DAC1064.vco_freq_min) = 120000; */
 	ACCESS_FBINFO(features.pll.vco_freq_min) = 62000;
@@ -594,7 +594,7 @@ static void MGAG100_progPixClock(CPMINFO
 	int selClk;
 	int clk;
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	outDAC1064(PMINFO M1064_XPIXCLKCTRL, inDAC1064(PMINFO M1064_XPIXCLKCTRL) | M1064_XPIXCLKCTRL_DIS |
 		   M1064_XPIXCLKCTRL_PLL_UP);
@@ -636,7 +636,7 @@ static void MGAG100_progPixClock(CPMINFO
 static void MGAG100_setPixClock(CPMINFO int flags, int freq) {
 	unsigned int m, n, p;
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	DAC1064_calcclock(PMINFO freq, ACCESS_FBINFO(max_pixel_clock), &m, &n, &p);
 	MGAG100_progPixClock(PMINFO flags, m, n, p);
@@ -650,7 +650,7 @@ static int MGA1064_preinit(WPMINFO2) {
 					     2048,    0};
 	struct matrox_hw_state* hw = &ACCESS_FBINFO(hw);
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	/* ACCESS_FBINFO(capable.cfb4) = 0; ... preinitialized by 0 */
 	ACCESS_FBINFO(capable.text) = 1;
@@ -683,7 +683,7 @@ static int MGA1064_preinit(WPMINFO2) {
 
 static void MGA1064_reset(WPMINFO2) {
 
-	DBG(__FUNCTION__);
+	DBG(__func__);
 
 	MGA1064_ramdac_init(PMINFO2);
 }
@@ -819,7 +819,7 @@ static int MGAG100_preinit(WPMINFO2) {
 	u_int32_t q;
 #endif
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	/* there are some instabilities if in_div > 19 && vco < 61000 */
 	if (ACCESS_FBINFO(devflags.g450dac)) {
@@ -956,7 +956,7 @@ static void MGAG100_reset(WPMINFO2) {
 	u_int8_t b;
 	struct matrox_hw_state* hw = &ACCESS_FBINFO(hw);
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	{
 #ifdef G100_BROKEN_IBM_82351
@@ -1015,7 +1015,7 @@ static void MGA1064_restore(WPMINFO2) {
 
 	CRITFLAGS
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	CRITBEGIN
 
@@ -1041,7 +1041,7 @@ static void MGAG100_restore(WPMINFO2) {
 
 	CRITFLAGS
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	CRITBEGIN
 
diff -puN drivers/video/matrox/matroxfb_Ti3026.c~video-replace-remaining-__function__-occurrences drivers/video/matrox/matroxfb_Ti3026.c
--- a/drivers/video/matrox/matroxfb_Ti3026.c~video-replace-remaining-__function__-occurrences
+++ a/drivers/video/matrox/matroxfb_Ti3026.c
@@ -283,7 +283,7 @@ static int Ti3026_calcclock(CPMINFO unsi
 	unsigned int fvco;
 	unsigned int lin, lfeed, lpost;
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	fvco = PLL_calcclock(PMINFO freq, fmax, &lin, &lfeed, &lpost);
 	fvco >>= (*post = lpost);
@@ -297,7 +297,7 @@ static int Ti3026_setpclk(WPMINFO int cl
 	unsigned int pixfeed, pixin, pixpost;
 	struct matrox_hw_state* hw = &ACCESS_FBINFO(hw);
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	f_pll = Ti3026_calcclock(PMINFO clk, ACCESS_FBINFO(max_pixel_clock), &pixin, &pixfeed, &pixpost);
 
@@ -365,7 +365,7 @@ static int Ti3026_init(WPMINFO struct my
 	u_int8_t muxctrl = isInterleave(MINFO) ? TVP3026_XMUXCTRL_MEMORY_64BIT : TVP3026_XMUXCTRL_MEMORY_32BIT;
 	struct matrox_hw_state* hw = &ACCESS_FBINFO(hw);
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	memcpy(hw->DACreg, MGADACbpp32, sizeof(hw->DACreg));
 	switch (ACCESS_FBINFO(fbcon).var.bits_per_pixel) {
@@ -440,7 +440,7 @@ static void ti3026_setMCLK(WPMINFO int f
 	unsigned int rfhcnt, mclk_ctl;
 	int tmout;
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	f_pll = Ti3026_calcclock(PMINFO fout, ACCESS_FBINFO(max_pixel_clock), &mclk_n, &mclk_m, &mclk_p);
 
@@ -534,7 +534,7 @@ static void ti3026_setMCLK(WPMINFO int f
 
 static void ti3026_ramdac_init(WPMINFO2) {
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	ACCESS_FBINFO(features.pll.vco_freq_min) = 110000;
 	ACCESS_FBINFO(features.pll.ref_freq)	 = 114545;
@@ -554,7 +554,7 @@ static void Ti3026_restore(WPMINFO2) {
 	struct matrox_hw_state* hw = &ACCESS_FBINFO(hw);
 	CRITFLAGS
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 #ifdef DEBUG
 	dprintk(KERN_INFO "EXTVGA regs: ");
@@ -662,7 +662,7 @@ static void Ti3026_restore(WPMINFO2) {
 
 static void Ti3026_reset(WPMINFO2) {
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	ti3026_ramdac_init(PMINFO2);
 }
@@ -680,7 +680,7 @@ static int Ti3026_preinit(WPMINFO2) {
 					  2048, 0};
 	struct matrox_hw_state* hw = &ACCESS_FBINFO(hw);
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	ACCESS_FBINFO(millenium) = 1;
 	ACCESS_FBINFO(milleniumII) = (ACCESS_FBINFO(pcidev)->device != PCI_DEVICE_ID_MATROX_MIL);
diff -puN drivers/video/matrox/matroxfb_accel.c~video-replace-remaining-__function__-occurrences drivers/video/matrox/matroxfb_accel.c
--- a/drivers/video/matrox/matroxfb_accel.c~video-replace-remaining-__function__-occurrences
+++ a/drivers/video/matrox/matroxfb_accel.c
@@ -113,7 +113,7 @@ void matrox_cfbX_init(WPMINFO2) {
 	u_int32_t mopmode;
 	int accel;
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	mpitch = ACCESS_FBINFO(fbcon).var.xres_virtual;
 
@@ -199,7 +199,7 @@ static void matrox_accel_bmove(WPMINFO i
 	int start, end;
 	CRITFLAGS
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	CRITBEGIN
 
@@ -235,7 +235,7 @@ static void matrox_accel_bmove_lin(WPMIN
 	int start, end;
 	CRITFLAGS
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	CRITBEGIN
 
@@ -287,7 +287,7 @@ static void matroxfb_accel_clear(WPMINFO
 		int width) {
 	CRITFLAGS
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	CRITBEGIN
 
@@ -315,7 +315,7 @@ static void matroxfb_cfb4_clear(WPMINFO 
 	int whattodo;
 	CRITFLAGS
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	CRITBEGIN
 
@@ -388,7 +388,7 @@ static void matroxfb_1bpp_imageblit(WPMI
 	int easy;
 	CRITFLAGS
 
-	DBG_HEAVY(__FUNCTION__);
+	DBG_HEAVY(__func__);
 
 	step = (width + 7) >> 3;
 	charcell = height * step;
@@ -469,7 +469,7 @@ static void matroxfb_1bpp_imageblit(WPMI
 static void matroxfb_imageblit(struct fb_info* info, const struct fb_image* image) {
 	MINFO_FROM_INFO(info);
 
-	DBG_HEAVY(__FUNCTION__);
+	DBG_HEAVY(__func__);
 
 	if (image->depth == 1) {
 		u_int32_t fgx, bgx;
diff -puN drivers/video/matrox/matroxfb_base.c~video-replace-remaining-__function__-occurrences drivers/video/matrox/matroxfb_base.c
--- a/drivers/video/matrox/matroxfb_base.c~video-replace-remaining-__function__-occurrences
+++ a/drivers/video/matrox/matroxfb_base.c
@@ -312,7 +312,7 @@ static void matrox_pan_var(WPMINFO struc
 
 	CRITFLAGS
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	if (ACCESS_FBINFO(dead))
 		return;
@@ -392,7 +392,7 @@ static int matroxfb_open(struct fb_info 
 {
 	MINFO_FROM_INFO(info);
 
-	DBG_LOOP(__FUNCTION__)
+	DBG_LOOP(__func__)
 
 	if (ACCESS_FBINFO(dead)) {
 		return -ENXIO;
@@ -408,7 +408,7 @@ static int matroxfb_release(struct fb_in
 {
 	MINFO_FROM_INFO(info);
 
-	DBG_LOOP(__FUNCTION__)
+	DBG_LOOP(__func__)
 
 	if (user) {
 		if (0 == --ACCESS_FBINFO(userusecount)) {
@@ -425,7 +425,7 @@ static int matroxfb_pan_display(struct f
 		struct fb_info* info) {
 	MINFO_FROM_INFO(info);
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	matrox_pan_var(PMINFO var);
 	return 0;
@@ -434,7 +434,7 @@ static int matroxfb_pan_display(struct f
 static int matroxfb_get_final_bppShift(CPMINFO int bpp) {
 	int bppshft2;
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	bppshft2 = bpp;
 	if (!bppshft2) {
@@ -451,7 +451,7 @@ static int matroxfb_test_and_set_roundin
 	int over;
 	int rounding;
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	switch (bpp) {
 		case 0:		return xres;
@@ -482,7 +482,7 @@ static int matroxfb_pitch_adjust(CPMINFO
 	const int* width;
 	int xres_new;
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	if (!bpp) return xres;
 
@@ -504,7 +504,7 @@ static int matroxfb_pitch_adjust(CPMINFO
 
 static int matroxfb_get_cmap_len(struct fb_var_screeninfo *var) {
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	switch (var->bits_per_pixel) {
 		case 4:
@@ -548,7 +548,7 @@ static int matroxfb_decode_var(CPMINFO s
 	unsigned int vramlen;
 	unsigned int memlen;
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	switch (bpp) {
 		case 4:	 if (!ACCESS_FBINFO(capable.cfb4)) return -EINVAL;
@@ -648,7 +648,7 @@ static int matroxfb_setcolreg(unsigned r
 	struct matrox_fb_info* minfo = container_of(fb_info, struct matrox_fb_info, fbcon);
 #endif
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	/*
 	 *  Set a single color register. The values supplied are
@@ -707,7 +707,7 @@ static int matroxfb_setcolreg(unsigned r
 static void matroxfb_init_fix(WPMINFO2)
 {
 	struct fb_fix_screeninfo *fix = &ACCESS_FBINFO(fbcon).fix;
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	strcpy(fix->id,"MATROX");
 
@@ -722,7 +722,7 @@ static void matroxfb_init_fix(WPMINFO2)
 static void matroxfb_update_fix(WPMINFO2)
 {
 	struct fb_fix_screeninfo *fix = &ACCESS_FBINFO(fbcon).fix;
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	fix->smem_start = ACCESS_FBINFO(video.base) + ACCESS_FBINFO(curr.ydstorg.bytes);
 	fix->smem_len = ACCESS_FBINFO(video.len_usable) - ACCESS_FBINFO(curr.ydstorg.bytes);
@@ -753,7 +753,7 @@ static int matroxfb_set_par(struct fb_in
 	struct fb_var_screeninfo *var;
 	MINFO_FROM_INFO(info);
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	if (ACCESS_FBINFO(dead)) {
 		return -ENXIO;
@@ -876,7 +876,7 @@ static int matroxfb_ioctl(struct fb_info
 	void __user *argp = (void __user *)arg;
 	MINFO_FROM_INFO(info);
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	if (ACCESS_FBINFO(dead)) {
 		return -ENXIO;
@@ -1175,7 +1175,7 @@ static int matroxfb_blank(int blank, str
 	CRITFLAGS
 	MINFO_FROM_INFO(info);
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	if (ACCESS_FBINFO(dead))
 		return 1;
@@ -1287,7 +1287,7 @@ static int matroxfb_getmemory(WPMINFO un
 	unsigned char bytes[32];
 	unsigned char* tmp;
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	vm = ACCESS_FBINFO(video.vbase);
 	maxSize &= ~0x1FFFFF;	/* must be X*2MB (really it must be 2 or X*4MB) */
@@ -1593,7 +1593,7 @@ static int initMatrox2(WPMINFO struct bo
 		{ },
 	};
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	/* set default values... */
 	vesafb_defined.accel_flags = FB_ACCELF_TEXT;
@@ -2006,7 +2006,7 @@ static int matroxfb_probe(struct pci_dev
 #ifndef CONFIG_FB_MATROX_MULTIHEAD
 	static int registered = 0;
 #endif
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	svid = pdev->subsystem_vendor;
 	sid = pdev->subsystem_device;
@@ -2301,7 +2301,7 @@ static void __exit matrox_done(void) {
 static int __init matroxfb_setup(char *options) {
 	char *this_opt;
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	if (!options || !*options)
 		return 0;
@@ -2444,7 +2444,7 @@ static int __init matroxfb_init(void)
 	char *option = NULL;
 	int err = 0;
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	if (fb_get_options("matroxfb", &option))
 		return -ENODEV;
@@ -2556,7 +2556,7 @@ MODULE_PARM_DESC(cmode, "Specify the vid
 
 int __init init_module(void){
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	if (disabled)
 		return -ENXIO;
diff -puN drivers/video/matrox/matroxfb_crtc2.c~video-replace-remaining-__function__-occurrences drivers/video/matrox/matroxfb_crtc2.c
--- a/drivers/video/matrox/matroxfb_crtc2.c~video-replace-remaining-__function__-occurrences
+++ a/drivers/video/matrox/matroxfb_crtc2.c
@@ -420,7 +420,7 @@ static int matroxfb_dh_ioctl(struct fb_i
 #define m2info (container_of(info, struct matroxfb_dh_fb_info, fbcon))
 	MINFO_FROM(m2info->primary_dev);
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	switch (cmd) {
 		case FBIOGET_VBLANK:
diff -puN drivers/video/matrox/matroxfb_maven.c~video-replace-remaining-__function__-occurrences drivers/video/matrox/matroxfb_maven.c
--- a/drivers/video/matrox/matroxfb_maven.c~video-replace-remaining-__function__-occurrences
+++ a/drivers/video/matrox/matroxfb_maven.c
@@ -220,7 +220,7 @@ static int matroxfb_PLL_mavenclock(const
 	unsigned int scrlen;
 	unsigned int fmax;
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	scrlen = htotal * (vtotal - 1);
 	fwant = htotal * vtotal;
diff -puN drivers/video/matrox/matroxfb_misc.c~video-replace-remaining-__function__-occurrences drivers/video/matrox/matroxfb_misc.c
--- a/drivers/video/matrox/matroxfb_misc.c~video-replace-remaining-__function__-occurrences
+++ a/drivers/video/matrox/matroxfb_misc.c
@@ -90,13 +90,13 @@
 #include <linux/matroxfb.h>
 
 void matroxfb_DAC_out(CPMINFO int reg, int val) {
-	DBG_REG(__FUNCTION__)
+	DBG_REG(__func__)
 	mga_outb(M_RAMDAC_BASE+M_X_INDEX, reg);
 	mga_outb(M_RAMDAC_BASE+M_X_DATAREG, val);
 }
 
 int matroxfb_DAC_in(CPMINFO int reg) {
-	DBG_REG(__FUNCTION__)
+	DBG_REG(__func__)
 	mga_outb(M_RAMDAC_BASE+M_X_INDEX, reg);
 	return mga_inb(M_RAMDAC_BASE+M_X_DATAREG);
 }
@@ -104,7 +104,7 @@ int matroxfb_DAC_in(CPMINFO int reg) {
 void matroxfb_var2my(struct fb_var_screeninfo* var, struct my_timming* mt) {
 	unsigned int pixclock = var->pixclock;
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	if (!pixclock) pixclock = 10000;	/* 10ns = 100MHz */
 	mt->pixclock = 1000000000 / pixclock;
@@ -131,7 +131,7 @@ int matroxfb_PLL_calcclock(const struct 
 	unsigned int fwant;
 	unsigned int p;
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	fwant = freq;
 
@@ -192,7 +192,7 @@ int matroxfb_vgaHWinit(WPMINFO struct my
 	int i;
 	struct matrox_hw_state * const hw = &ACCESS_FBINFO(hw);
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	hw->SEQ[0] = 0x00;
 	hw->SEQ[1] = 0x01;	/* or 0x09 */
@@ -336,7 +336,7 @@ void matroxfb_vgaHWrestore(WPMINFO2) {
 	struct matrox_hw_state * const hw = &ACCESS_FBINFO(hw);
 	CRITFLAGS
 
-	DBG(__FUNCTION__)
+	DBG(__func__)
 
 	dprintk(KERN_INFO "MiscOutReg: %02X\n", hw->MiscOutReg);
 	dprintk(KERN_INFO "SEQ regs:   ");
diff -puN drivers/video/modedb.c~video-replace-remaining-__function__-occurrences drivers/video/modedb.c
--- a/drivers/video/modedb.c~video-replace-remaining-__function__-occurrences
+++ a/drivers/video/modedb.c
@@ -22,7 +22,7 @@
     ((v).xres == (x) && (v).yres == (y))
 
 #ifdef DEBUG
-#define DPRINTK(fmt, args...)	printk("modedb %s: " fmt, __FUNCTION__ , ## args)
+#define DPRINTK(fmt, args...)	printk("modedb %s: " fmt, __func__ , ## args)
 #else
 #define DPRINTK(fmt, args...)
 #endif
diff -puN drivers/video/nvidia/nvidia.c~video-replace-remaining-__function__-occurrences drivers/video/nvidia/nvidia.c
--- a/drivers/video/nvidia/nvidia.c~video-replace-remaining-__function__-occurrences
+++ a/drivers/video/nvidia/nvidia.c
@@ -43,14 +43,14 @@
 #define NVTRACE          if (0) printk
 #endif
 
-#define NVTRACE_ENTER(...)  NVTRACE("%s START\n", __FUNCTION__)
-#define NVTRACE_LEAVE(...)  NVTRACE("%s END\n", __FUNCTION__)
+#define NVTRACE_ENTER(...)  NVTRACE("%s START\n", __func__)
+#define NVTRACE_LEAVE(...)  NVTRACE("%s END\n", __func__)
 
 #ifdef CONFIG_FB_NVIDIA_DEBUG
 #define assert(expr) \
 	if (!(expr)) { \
 	printk( "Assertion failed! %s,%s,%s,line=%d\n",\
-	#expr,__FILE__,__FUNCTION__,__LINE__); \
+	#expr,__FILE__,__func__,__LINE__); \
 	BUG(); \
 	}
 #else
diff -puN drivers/video/pm2fb.c~video-replace-remaining-__function__-occurrences drivers/video/pm2fb.c
--- a/drivers/video/pm2fb.c~video-replace-remaining-__function__-occurrences
+++ a/drivers/video/pm2fb.c
@@ -56,7 +56,7 @@
 #undef PM2FB_MASTER_DEBUG
 #ifdef PM2FB_MASTER_DEBUG
 #define DPRINTK(a, b...)	\
-	printk(KERN_DEBUG "pm2fb: %s: " a, __FUNCTION__ , ## b)
+	printk(KERN_DEBUG "pm2fb: %s: " a, __func__ , ## b)
 #else
 #define DPRINTK(a, b...)
 #endif
diff -puN drivers/video/pm3fb.c~video-replace-remaining-__function__-occurrences drivers/video/pm3fb.c
--- a/drivers/video/pm3fb.c~video-replace-remaining-__function__-occurrences
+++ a/drivers/video/pm3fb.c
@@ -45,7 +45,7 @@
 #undef PM3FB_MASTER_DEBUG
 #ifdef PM3FB_MASTER_DEBUG
 #define DPRINTK(a, b...)	\
-	printk(KERN_DEBUG "pm3fb: %s: " a, __FUNCTION__ , ## b)
+	printk(KERN_DEBUG "pm3fb: %s: " a, __func__ , ## b)
 #else
 #define DPRINTK(a, b...)
 #endif
diff -puN drivers/video/riva/fbdev.c~video-replace-remaining-__function__-occurrences drivers/video/riva/fbdev.c
--- a/drivers/video/riva/fbdev.c~video-replace-remaining-__function__-occurrences
+++ a/drivers/video/riva/fbdev.c
@@ -70,14 +70,14 @@
 #define NVTRACE          if(0) printk
 #endif
 
-#define NVTRACE_ENTER(...)  NVTRACE("%s START\n", __FUNCTION__)
-#define NVTRACE_LEAVE(...)  NVTRACE("%s END\n", __FUNCTION__)
+#define NVTRACE_ENTER(...)  NVTRACE("%s START\n", __func__)
+#define NVTRACE_LEAVE(...)  NVTRACE("%s END\n", __func__)
 
 #ifdef CONFIG_FB_RIVA_DEBUG
 #define assert(expr) \
 	if(!(expr)) { \
 	printk( "Assertion failed! %s,%s,%s,line=%d\n",\
-	#expr,__FILE__,__FUNCTION__,__LINE__); \
+	#expr,__FILE__,__func__,__LINE__); \
 	BUG(); \
 	}
 #else
diff -puN drivers/video/s3c2410fb.c~video-replace-remaining-__function__-occurrences drivers/video/s3c2410fb.c
--- a/drivers/video/s3c2410fb.c~video-replace-remaining-__function__-occurrences
+++ a/drivers/video/s3c2410fb.c
@@ -430,9 +430,9 @@ static void s3c2410fb_activate_var(struc
 	struct fb_var_screeninfo *var = &info->var;
 	int clkdiv = s3c2410fb_calc_pixclk(fbi, var->pixclock) / 2;
 
-	dprintk("%s: var->xres  = %d\n", __FUNCTION__, var->xres);
-	dprintk("%s: var->yres  = %d\n", __FUNCTION__, var->yres);
-	dprintk("%s: var->bpp   = %d\n", __FUNCTION__, var->bits_per_pixel);
+	dprintk("%s: var->xres  = %d\n", __func__, var->xres);
+	dprintk("%s: var->yres  = %d\n", __func__, var->yres);
+	dprintk("%s: var->bpp   = %d\n", __func__, var->bits_per_pixel);
 
 	if (type == S3C2410_LCDCON1_TFT) {
 		s3c2410fb_calculate_tft_lcd_regs(info, &fbi->regs);
diff -puN drivers/video/sa1100fb.h~video-replace-remaining-__function__-occurrences drivers/video/sa1100fb.h
--- a/drivers/video/sa1100fb.h~video-replace-remaining-__function__-occurrences
+++ a/drivers/video/sa1100fb.h
@@ -132,7 +132,7 @@ struct sa1100fb_info {
  *  Debug macros 
  */
 #if DEBUG
-#  define DPRINTK(fmt, args...)	printk("%s: " fmt, __FUNCTION__ , ## args)
+#  define DPRINTK(fmt, args...)	printk("%s: " fmt, __func__ , ## args)
 #else
 #  define DPRINTK(fmt, args...)
 #endif
diff -puN drivers/video/sis/sis.h~video-replace-remaining-__function__-occurrences drivers/video/sis/sis.h
--- a/drivers/video/sis/sis.h~video-replace-remaining-__function__-occurrences
+++ a/drivers/video/sis/sis.h
@@ -55,7 +55,7 @@
 #undef SISFBDEBUG
 
 #ifdef SISFBDEBUG
-#define DPRINTK(fmt, args...) printk(KERN_DEBUG "%s: " fmt, __FUNCTION__ , ## args)
+#define DPRINTK(fmt, args...) printk(KERN_DEBUG "%s: " fmt, __func__ , ## args)
 #define TWDEBUG(x) printk(KERN_INFO x "\n");
 #else
 #define DPRINTK(fmt, args...)
diff -puN drivers/video/sstfb.c~video-replace-remaining-__function__-occurrences drivers/video/sstfb.c
--- a/drivers/video/sstfb.c~video-replace-remaining-__function__-occurrences
+++ a/drivers/video/sstfb.c
@@ -1006,7 +1006,7 @@ static int sst_set_pll_att_ti(struct fb_
 		break;
 	default:
 		dprintk("%s: wrong clock code '%d'\n",
-		        __FUNCTION__, clock);
+		        __func__, clock);
 		return 0;
 		}
 	udelay(300);
@@ -1048,7 +1048,7 @@ static int sst_set_pll_ics(struct fb_inf
 		break;
 	default:
 		dprintk("%s: wrong clock code '%d'\n",
-		        __FUNCTION__, clock);
+		        __func__, clock);
 		return 0;
 		}
 	udelay(300);
@@ -1079,7 +1079,7 @@ static void sst_set_vidmod_att_ti(struct
 		sst_dac_write(DACREG_RMR, (cr0 & 0x0f) | DACREG_CR0_16BPP);
 		break;
 	default:
-		dprintk("%s: bad depth '%u'\n", __FUNCTION__, bpp);
+		dprintk("%s: bad depth '%u'\n", __func__, bpp);
 		break;
 	}
 }
@@ -1093,7 +1093,7 @@ static void sst_set_vidmod_ics(struct fb
 		sst_dac_write(DACREG_ICS_CMD, DACREG_ICS_CMD_16BPP);
 		break;
 	default:
-		dprintk("%s: bad depth '%u'\n", __FUNCTION__, bpp);
+		dprintk("%s: bad depth '%u'\n", __func__, bpp);
 		break;
 	}
 }
@@ -1133,7 +1133,7 @@ static int __devinit sst_detect_dactype(
 	}
 	if (!ret)
 		return 0;
-	f_dprintk("%s found %s\n", __FUNCTION__, dacs[i].name);
+	f_dprintk("%s found %s\n", __func__, dacs[i].name);
 	par->dac_sw = dacs[i];
 	return 1;
 }
diff -puN drivers/video/stifb.c~video-replace-remaining-__function__-occurrences drivers/video/stifb.c
--- a/drivers/video/stifb.c~video-replace-remaining-__function__-occurrences
+++ a/drivers/video/stifb.c
@@ -164,11 +164,11 @@ static int __initdata stifb_bpp_pref[MAX
 # define  DEBUG_ON()  debug_on=1
 # define WRITE_BYTE(value,fb,reg)	do { if (debug_on) \
 						printk(KERN_DEBUG "%30s: WRITE_BYTE(0x%06x) = 0x%02x (old=0x%02x)\n", \
-							__FUNCTION__, reg, value, READ_BYTE(fb,reg)); 		  \
+							__func__, reg, value, READ_BYTE(fb,reg)); 		  \
 					gsc_writeb((value),(fb)->info.fix.mmio_start + (reg)); } while (0)
 # define WRITE_WORD(value,fb,reg)	do { if (debug_on) \
 						printk(KERN_DEBUG "%30s: WRITE_WORD(0x%06x) = 0x%08x (old=0x%08x)\n", \
-							__FUNCTION__, reg, value, READ_WORD(fb,reg)); 		  \
+							__func__, reg, value, READ_WORD(fb,reg)); 		  \
 					gsc_writel((value),(fb)->info.fix.mmio_start + (reg)); } while (0)
 #endif /* DEBUG_STIFB_REGS */
 
diff -puN drivers/video/sysimgblt.c~video-replace-remaining-__function__-occurrences drivers/video/sysimgblt.c
--- a/drivers/video/sysimgblt.c~video-replace-remaining-__function__-occurrences
+++ a/drivers/video/sysimgblt.c
@@ -18,7 +18,7 @@
 #define DEBUG
 
 #ifdef DEBUG
-#define DPRINTK(fmt, args...) printk(KERN_DEBUG "%s: " fmt,__FUNCTION__,## args)
+#define DPRINTK(fmt, args...) printk(KERN_DEBUG "%s: " fmt,__func__,## args)
 #else
 #define DPRINTK(fmt, args...)
 #endif
diff -puN drivers/video/tdfxfb.c~video-replace-remaining-__function__-occurrences drivers/video/tdfxfb.c
--- a/drivers/video/tdfxfb.c~video-replace-remaining-__function__-occurrences
+++ a/drivers/video/tdfxfb.c
@@ -70,7 +70,7 @@
 
 #include <video/tdfx.h>
 
-#define DPRINTK(a, b...) pr_debug("fb: %s: " a, __FUNCTION__ , ## b)
+#define DPRINTK(a, b...) pr_debug("fb: %s: " a, __func__ , ## b)
 
 #ifdef CONFIG_MTRR
 #include <asm/mtrr.h>
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
git-kvm.patch
git-mips.patch
git-nfsd.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
git-watchdog.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
power-replace-remaining-__function__-occurrences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
firmware-replace-remaining-__function__-occurrences.patch
drivers-misc-replace-remaining-__function__-occurrences.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
ext4-replace-remaining-__function__-occurrences.patch
jdb2-replace-remaining-__function__-occurrences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
add-macros-similar-to-min-max-min_t-max_t.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
drivers-replace-remaining-__function__-occurrences.patch
kernel-add-common-infrastructure-for-unaligned-access.patch
kernel-move-arches-to-use-common-unaligned-access.patch
drivers-block-use-get_unaligned_-helpers.patch
hid-core-use-get_unaligned_-helpers.patch
char-use-get_unaligned_-helpers.patch
input-use-get_unaligned_-helpers.patch
mmc-use-get-put_unaligned_-helpers.patch
net-use-get-put_unaligned_-helpers.patch
wireless-use-get-put_unaligned_-helpers.patch
pcmcia-use-get-put_unaligned_-helpers.patch
usb-use-get-put_unaligned_-helpers.patch
video-use-get-put_unaligned_-helpers.patch
fat-use-get-put_unaligned_-helpers.patch
hfsplus-use-get-put_unaligned_-helpers.patch
isofs-use-get-put_unaligned_-helpers.patch
ncpfs-use-get-put_unaligned_-helpers.patch
ncpfs-use-get-put_unaligned_-helpers-checkpatch-fixes.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

