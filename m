From: akpm@linux-foundation.org
Subject: [merged] davinci-fb-add-cpufreq-support.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:35:54 -0800
Message-ID: <200912162035.nBGKZsZg013127@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935405AbZLPUgL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:36:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chaithrika@ti.com, davej@codemonkey.org.uk, khilman@deeprootsystems.com, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     davinci: fb: add cpufreq support
has been removed from the -mm tree.  Its filename was
     davinci-fb-add-cpufreq-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: davinci: fb: add cpufreq support
From: Chaithrika U S <chaithrika@ti.com>

Add cpufreq support for DA8xx/OMAP-L1xx frame buffer driver

Signed-off-by: Chaithrika U S <chaithrika@ti.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/da8xx-fb.c |   55 +++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff -puN drivers/video/da8xx-fb.c~davinci-fb-add-cpufreq-support drivers/video/da8xx-fb.c
--- a/drivers/video/da8xx-fb.c~davinci-fb-add-cpufreq-support
+++ a/drivers/video/da8xx-fb.c
@@ -28,6 +28,7 @@
 #include <linux/uaccess.h>
 #include <linux/interrupt.h>
 #include <linux/clk.h>
+#include <linux/cpufreq.h>
 #include <video/da8xx-fb.h>
 
 #define DRIVER_NAME "da8xx_lcdc"
@@ -114,6 +115,9 @@ struct da8xx_fb_par {
 	unsigned int databuf_sz;
 	unsigned int palette_sz;
 	unsigned int pxl_clk;
+#ifdef CONFIG_CPU_FREQ
+	struct notifier_block	freq_transition;
+#endif
 };
 
 /* Variable Screen Information */
@@ -586,6 +590,41 @@ static int fb_check_var(struct fb_var_sc
 	return err;
 }
 
+#ifdef CONFIG_CPU_FREQ
+static int lcd_da8xx_cpufreq_transition(struct notifier_block *nb,
+				     unsigned long val, void *data)
+{
+	struct da8xx_fb_par *par;
+	unsigned int reg;
+
+	par = container_of(nb, struct da8xx_fb_par, freq_transition);
+	if (val == CPUFREQ_PRECHANGE) {
+		reg = lcdc_read(LCD_RASTER_CTRL_REG);
+		lcdc_write(reg & ~LCD_RASTER_ENABLE, LCD_RASTER_CTRL_REG);
+	} else if (val == CPUFREQ_POSTCHANGE) {
+		lcd_calc_clk_divider(par);
+		reg = lcdc_read(LCD_RASTER_CTRL_REG);
+		lcdc_write(reg | LCD_RASTER_ENABLE, LCD_RASTER_CTRL_REG);
+	}
+
+	return 0;
+}
+
+static inline int lcd_da8xx_cpufreq_register(struct da8xx_fb_par *par)
+{
+	par->freq_transition.notifier_call = lcd_da8xx_cpufreq_transition;
+
+	return cpufreq_register_notifier(&par->freq_transition,
+					 CPUFREQ_TRANSITION_NOTIFIER);
+}
+
+static inline void lcd_da8xx_cpufreq_deregister(struct da8xx_fb_par *par)
+{
+	cpufreq_unregister_notifier(&par->freq_transition,
+				    CPUFREQ_TRANSITION_NOTIFIER);
+}
+#endif
+
 static int __devexit fb_remove(struct platform_device *dev)
 {
 	struct fb_info *info = dev_get_drvdata(&dev->dev);
@@ -593,6 +632,9 @@ static int __devexit fb_remove(struct pl
 	if (info) {
 		struct da8xx_fb_par *par = info->par;
 
+#ifdef CONFIG_CPU_FREQ
+		lcd_da8xx_cpufreq_deregister(par);
+#endif
 		if (lcdc_read(LCD_RASTER_CTRL_REG) & LCD_RASTER_ENABLE)
 			lcd_disable_raster(par);
 		lcdc_write(0, LCD_RASTER_CTRL_REG);
@@ -826,12 +868,25 @@ static int __init fb_probe(struct platfo
 		goto err_dealloc_cmap;
 	}
 
+#ifdef CONFIG_CPU_FREQ
+	ret = lcd_da8xx_cpufreq_register(par);
+	if (ret) {
+		dev_err(&device->dev, "failed to register cpufreq\n");
+		goto err_cpu_freq;
+	}
+#endif
+
 	/* enable raster engine */
 	lcdc_write(lcdc_read(LCD_RASTER_CTRL_REG) |
 			LCD_RASTER_ENABLE, LCD_RASTER_CTRL_REG);
 
 	return 0;
 
+#ifdef CONFIG_CPU_FREQ
+err_cpu_freq:
+	unregister_framebuffer(da8xx_fb_info);
+#endif
+
 err_dealloc_cmap:
 	fb_dealloc_cmap(&da8xx_fb_info->cmap);
 
_

Patches currently in -mm which might be from chaithrika@ti.com are

origin.patch

