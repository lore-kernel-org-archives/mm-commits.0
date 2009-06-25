From: akpm@linux-foundation.org
Subject: + omapfb-add-support-for-the-gumstix-overo-lcd.patch added to -mm tree
Date: Wed, 24 Jun 2009 17:07:57 -0700
Message-ID: <200906250007.n5P07vPZ004753@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56697 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753619AbZFYALW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jun 2009 20:11:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steve@sakoman.com, imre.deak@nokia.com, krzysztof.h1@wp.pl, tony@atomide.com


The patch titled
     omapfb: add support for the Gumstix Overo LCD
has been added to the -mm tree.  Its filename is
     omapfb-add-support-for-the-gumstix-overo-lcd.patch

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
Subject: omapfb: add support for the Gumstix Overo LCD
From: Steve Sakoman <steve@sakoman.com>

Signed-off-by: Steve Sakoman <steve@sakoman.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Imre Deak <imre.deak@nokia.com>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/omap/Kconfig     |   21 +++
 drivers/video/omap/Makefile    |    1 
 drivers/video/omap/lcd_overo.c |  179 +++++++++++++++++++++++++++++++
 3 files changed, 201 insertions(+)

diff -puN drivers/video/omap/Kconfig~omapfb-add-support-for-the-gumstix-overo-lcd drivers/video/omap/Kconfig
--- a/drivers/video/omap/Kconfig~omapfb-add-support-for-the-gumstix-overo-lcd
+++ a/drivers/video/omap/Kconfig
@@ -7,6 +7,27 @@ config FB_OMAP
 	help
           Frame buffer driver for OMAP based boards.
 
+choice
+	depends on FB_OMAP && MACH_OVERO
+	prompt "Screen resolution"
+	default FB_OMAP_079M3R
+	help
+	  Selected desired screen resolution
+
+config FB_OMAP_031M3R
+	boolean "640 x 480 @ 60 Hz Reduced blanking"
+
+config FB_OMAP_048M3R
+	boolean "800 x 600 @ 60 Hz Reduced blanking"
+
+config FB_OMAP_079M3R
+	boolean "1024 x 768 @ 60 Hz Reduced blanking"
+
+config FB_OMAP_092M9R
+	boolean "1280 x 720 @ 60 Hz Reduced blanking"
+
+endchoice
+
 config FB_OMAP_LCD_MIPID
 	bool "MIPI DBI-C/DCS compatible LCD support"
 	depends on FB_OMAP && SPI_MASTER
diff -puN drivers/video/omap/Makefile~omapfb-add-support-for-the-gumstix-overo-lcd drivers/video/omap/Makefile
--- a/drivers/video/omap/Makefile~omapfb-add-support-for-the-gumstix-overo-lcd
+++ a/drivers/video/omap/Makefile
@@ -33,6 +33,7 @@ objs-y$(CONFIG_MACH_OMAP2EVM) += lcd_oma
 objs-y$(CONFIG_MACH_OMAP3EVM) += lcd_omap3evm.o
 objs-y$(CONFIG_MACH_OMAP3_BEAGLE) += lcd_omap3beagle.o
 objs-y$(CONFIG_FB_OMAP_LCD_MIPID) += lcd_mipid.o
+objs-y$(CONFIG_MACH_OVERO) += lcd_overo.o
 
 omapfb-objs := $(objs-yy)
 
diff -puN /dev/null drivers/video/omap/lcd_overo.c
--- /dev/null
+++ a/drivers/video/omap/lcd_overo.c
@@ -0,0 +1,179 @@
+/*
+ * LCD panel support for the Gumstix Overo
+ *
+ * Author: Steve Sakoman <steve@sakoman.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/i2c/twl4030.h>
+
+#include <mach/gpio.h>
+#include <mach/mux.h>
+#include <mach/omapfb.h>
+#include <asm/mach-types.h>
+
+#define LCD_ENABLE       144
+
+static int overo_panel_init(struct lcd_panel *panel,
+				struct omapfb_device *fbdev)
+{
+	if ((gpio_request(LCD_ENABLE, "LCD_ENABLE") == 0) &&
+	    (gpio_direction_output(LCD_ENABLE, 1) == 0))
+		gpio_export(LCD_ENABLE, 0);
+	else
+		printk(KERN_ERR "could not obtain gpio for LCD_ENABLE\n");
+
+	return 0;
+}
+
+static void overo_panel_cleanup(struct lcd_panel *panel)
+{
+	gpio_free(LCD_ENABLE);
+}
+
+static int overo_panel_enable(struct lcd_panel *panel)
+{
+	gpio_set_value(LCD_ENABLE, 1);
+	return 0;
+}
+
+static void overo_panel_disable(struct lcd_panel *panel)
+{
+	gpio_set_value(LCD_ENABLE, 0);
+}
+
+static unsigned long overo_panel_get_caps(struct lcd_panel *panel)
+{
+	return 0;
+}
+
+struct lcd_panel overo_panel = {
+	.name		= "overo",
+	.config		= OMAP_LCDC_PANEL_TFT,
+	.bpp		= 16,
+	.data_lines	= 24,
+
+#if defined CONFIG_FB_OMAP_031M3R
+
+	/* 640 x 480 @ 60 Hz  Reduced blanking VESA CVT 0.31M3-R */
+	.x_res		= 640,
+	.y_res		= 480,
+	.hfp		= 48,
+	.hsw		= 32,
+	.hbp		= 80,
+	.vfp		= 3,
+	.vsw		= 4,
+	.vbp		= 7,
+	.pixel_clock	= 23500,
+
+#elif defined CONFIG_FB_OMAP_048M3R
+
+	/* 800 x 600 @ 60 Hz  Reduced blanking VESA CVT 0.48M3-R */
+	.x_res		= 800,
+	.y_res		= 600,
+	.hfp		= 48,
+	.hsw		= 32,
+	.hbp		= 80,
+	.vfp		= 3,
+	.vsw		= 4,
+	.vbp		= 11,
+	.pixel_clock	= 35500,
+
+#elif defined CONFIG_FB_OMAP_079M3R
+
+	/* 1024 x 768 @ 60 Hz  Reduced blanking VESA CVT 0.79M3-R */
+	.x_res		= 1024,
+	.y_res		= 768,
+	.hfp		= 48,
+	.hsw		= 32,
+	.hbp		= 80,
+	.vfp		= 3,
+	.vsw		= 4,
+	.vbp		= 15,
+	.pixel_clock	= 56000,
+
+#elif defined CONFIG_FB_OMAP_092M9R
+
+	/* 1280 x 720 @ 60 Hz  Reduced blanking VESA CVT 0.92M9-R */
+	.x_res		= 1280,
+	.y_res		= 720,
+	.hfp		= 48,
+	.hsw		= 32,
+	.hbp		= 80,
+	.vfp		= 3,
+	.vsw		= 5,
+	.vbp		= 13,
+	.pixel_clock	= 64000,
+
+#else
+
+	/* use 640 x 480 if no config option */
+	/* 640 x 480 @ 60 Hz  Reduced blanking VESA CVT 0.31M3-R */
+	.x_res		= 640,
+	.y_res		= 480,
+	.hfp		= 48,
+	.hsw		= 32,
+	.hbp		= 80,
+	.vfp		= 3,
+	.vsw		= 4,
+	.vbp		= 7,
+	.pixel_clock	= 23500,
+
+#endif
+
+	.init		= overo_panel_init,
+	.cleanup	= overo_panel_cleanup,
+	.enable		= overo_panel_enable,
+	.disable	= overo_panel_disable,
+	.get_caps	= overo_panel_get_caps,
+};
+
+static int overo_panel_probe(struct platform_device *pdev)
+{
+	omapfb_register_panel(&overo_panel);
+	return 0;
+}
+
+static int overo_panel_remove(struct platform_device *pdev)
+{
+	/* omapfb does not have unregister_panel */
+	return 0;
+}
+
+static struct platform_driver overo_panel_driver = {
+	.probe		= overo_panel_probe,
+	.remove		= overo_panel_remove,
+	.driver		= {
+		.name	= "overo_lcd",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init overo_panel_drv_init(void)
+{
+	return platform_driver_register(&overo_panel_driver);
+}
+
+static void __exit overo_panel_drv_exit(void)
+{
+	platform_driver_unregister(&overo_panel_driver);
+}
+
+module_init(overo_panel_drv_init);
+module_exit(overo_panel_drv_exit);
_

Patches currently in -mm which might be from steve@sakoman.com are

omapfb-add-support-for-the-omap3-evm-lcd.patch
omapfb-add-support-for-the-omap3-beagle-dvi-output.patch
omapfb-add-support-for-the-gumstix-overo-lcd.patch

