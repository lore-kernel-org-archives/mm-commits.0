From: akpm@linux-foundation.org
Subject: + davinci-fb-add-cpufreq-support.patch added to -mm tree
Date: Tue, 10 Nov 2009 12:05:13 -0800
Message-ID: <200911102005.nAAK5DeM007079@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51710 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757973AbZKJUF2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Nov 2009 15:05:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chaithrika@ti.com, davej@codemonkey.org.uk, khilman@deeprootsystems.com, krzysztof.h1@poczta.fm


The patch titled
     davinci: fb: add cpufreq support
has been added to the -mm tree.  Its filename is
     davinci-fb-add-cpufreq-support.patch

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
Subject: davinci: fb: add cpufreq support
From: Chaithrika U S <chaithrika@ti.com>

Add cpufreq support for DA8xx/OMAP-L1xx frame buffer driver

Signed-off-by: Chaithrika U S <chaithrika@ti.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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
@@ -113,6 +114,9 @@ struct da8xx_fb_par {
 	unsigned short pseudo_palette[16];
 	unsigned int databuf_sz;
 	unsigned int palette_sz;
+#ifdef CONFIG_CPU_FREQ
+	struct notifier_block	freq_transition;
+#endif
 };
 
 /* Variable Screen Information */
@@ -574,6 +578,41 @@ static int fb_check_var(struct fb_var_sc
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
@@ -581,6 +620,9 @@ static int __devexit fb_remove(struct pl
 	if (info) {
 		struct da8xx_fb_par *par = info->par;
 
+#ifdef CONFIG_CPU_FREQ
+		lcd_da8xx_cpufreq_deregister(par);
+#endif
 		if (lcdc_read(LCD_RASTER_CTRL_REG) & LCD_RASTER_ENABLE)
 			lcd_disable_raster(par);
 		lcdc_write(0, LCD_RASTER_CTRL_REG);
@@ -811,12 +853,25 @@ static int __init fb_probe(struct platfo
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

linux-next.patch
davinci-fb-add-cpufreq-support.patch

