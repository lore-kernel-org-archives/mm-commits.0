From: akpm@linux-foundation.org
Subject: + omapfb-add-support-for-the-amstrad-delta-lcd.patch added to -mm tree
Date: Wed, 24 Jun 2009 17:07:38 -0700
Message-ID: <200906250007.n5P07cve004449@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38710 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752147AbZFYAIR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jun 2009 20:08:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: noodles@earth.li, imre.deak@nokia.com, krzysztof.h1@wp.pl, tony@atomide.com


The patch titled
     omapfb: add support for the Amstrad Delta LCD
has been added to the -mm tree.  Its filename is
     omapfb-add-support-for-the-amstrad-delta-lcd.patch

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
Subject: omapfb: add support for the Amstrad Delta LCD
From: Jonathan McDowell <noodles@earth.li>

This is an updated version of the LCD driver for the Amstrad Delta to take
into account the recent changes to the omapfb infrastructure.  The Delta
features a 480x320 12 bit DSTN panel.

Signed-off-by: Jonathan McDowell <noodles@earth.li>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Imre Deak <imre.deak@nokia.com>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/omap/Makefile        |    1 
 drivers/video/omap/lcd_ams_delta.c |  137 +++++++++++++++++++++++++++
 2 files changed, 138 insertions(+)

diff -puN drivers/video/omap/Makefile~omapfb-add-support-for-the-amstrad-delta-lcd drivers/video/omap/Makefile
--- a/drivers/video/omap/Makefile~omapfb-add-support-for-the-amstrad-delta-lcd
+++ a/drivers/video/omap/Makefile
@@ -15,6 +15,7 @@ objs-$(CONFIG_ARCH_OMAP2)$(CONFIG_FB_OMA
 objs-y$(CONFIG_FB_OMAP_LCDC_HWA742) += hwa742.o
 objs-y$(CONFIG_FB_OMAP_LCDC_BLIZZARD) += blizzard.o
 
+objs-y$(CONFIG_MACH_AMS_DELTA) += lcd_ams_delta.o
 objs-y$(CONFIG_MACH_OMAP_H4) += lcd_h4.o
 objs-y$(CONFIG_MACH_OMAP_H3) += lcd_h3.o
 objs-y$(CONFIG_MACH_OMAP_PALMTE) += lcd_palmte.o
diff -puN /dev/null drivers/video/omap/lcd_ams_delta.c
--- /dev/null
+++ a/drivers/video/omap/lcd_ams_delta.c
@@ -0,0 +1,137 @@
+/*
+ * Based on drivers/video/omap/lcd_inn1510.c
+ *
+ * LCD panel support for the Amstrad E3 (Delta) videophone.
+ *
+ * Copyright (C) 2006 Jonathan McDowell <noodles@earth.li>
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
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/delay.h>
+
+#include <mach/board-ams-delta.h>
+#include <mach/hardware.h>
+#include <mach/omapfb.h>
+
+#define AMS_DELTA_DEFAULT_CONTRAST	112
+
+static int ams_delta_panel_init(struct lcd_panel *panel,
+		struct omapfb_device *fbdev)
+{
+	return 0;
+}
+
+static void ams_delta_panel_cleanup(struct lcd_panel *panel)
+{
+}
+
+static int ams_delta_panel_enable(struct lcd_panel *panel)
+{
+	ams_delta_latch2_write(AMS_DELTA_LATCH2_LCD_NDISP,
+			AMS_DELTA_LATCH2_LCD_NDISP);
+	ams_delta_latch2_write(AMS_DELTA_LATCH2_LCD_VBLEN,
+			AMS_DELTA_LATCH2_LCD_VBLEN);
+
+	omap_writeb(1, OMAP_PWL_CLK_ENABLE);
+	omap_writeb(AMS_DELTA_DEFAULT_CONTRAST, OMAP_PWL_ENABLE);
+
+	return 0;
+}
+
+static void ams_delta_panel_disable(struct lcd_panel *panel)
+{
+	ams_delta_latch2_write(AMS_DELTA_LATCH2_LCD_VBLEN, 0);
+	ams_delta_latch2_write(AMS_DELTA_LATCH2_LCD_NDISP, 0);
+}
+
+static unsigned long ams_delta_panel_get_caps(struct lcd_panel *panel)
+{
+	return 0;
+}
+
+static struct lcd_panel ams_delta_panel = {
+	.name		= "ams-delta",
+	.config		= 0,
+
+	.bpp		= 12,
+	.data_lines	= 16,
+	.x_res		= 480,
+	.y_res		= 320,
+	.pixel_clock	= 4687,
+	.hsw		= 3,
+	.hfp		= 1,
+	.hbp		= 1,
+	.vsw		= 1,
+	.vfp		= 0,
+	.vbp		= 0,
+	.pcd		= 0,
+	.acb		= 37,
+
+	.init		= ams_delta_panel_init,
+	.cleanup	= ams_delta_panel_cleanup,
+	.enable		= ams_delta_panel_enable,
+	.disable	= ams_delta_panel_disable,
+	.get_caps	= ams_delta_panel_get_caps,
+};
+
+static int ams_delta_panel_probe(struct platform_device *pdev)
+{
+	omapfb_register_panel(&ams_delta_panel);
+	return 0;
+}
+
+static int ams_delta_panel_remove(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static int ams_delta_panel_suspend(struct platform_device *pdev,
+		pm_message_t mesg)
+{
+	return 0;
+}
+
+static int ams_delta_panel_resume(struct platform_device *pdev)
+{
+	return 0;
+}
+
+struct platform_driver ams_delta_panel_driver = {
+	.probe		= ams_delta_panel_probe,
+	.remove		= ams_delta_panel_remove,
+	.suspend	= ams_delta_panel_suspend,
+	.resume		= ams_delta_panel_resume,
+	.driver		= {
+		.name	= "lcd_ams_delta",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int ams_delta_panel_drv_init(void)
+{
+	return platform_driver_register(&ams_delta_panel_driver);
+}
+
+static void ams_delta_panel_drv_cleanup(void)
+{
+	platform_driver_unregister(&ams_delta_panel_driver);
+}
+
+module_init(ams_delta_panel_drv_init);
+module_exit(ams_delta_panel_drv_cleanup);
_

Patches currently in -mm which might be from noodles@earth.li are

omapfb-add-support-for-the-amstrad-delta-lcd.patch

