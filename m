From: akpm@linux-foundation.org
Subject: - omap-lcd-panel-support-for-palm-tungstent.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:08:45 -0700
Message-ID: <200707172308.l6HN8jLc012308@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58672 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936531AbXGQXPu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marek.vasut@gmail.com, adaplas@pol.net, soni.trilok@gmail.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     OMAP: LCD panel support for Palm Tungsten|T
has been removed from the -mm tree.  Its filename was
     omap-lcd-panel-support-for-palm-tungstent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: OMAP: LCD panel support for Palm Tungsten|T
From: Marek Vasut <marek.vasut@gmail.com>

- Add TFT LCD panel support for Palm Tungsten|T

Signed-off-by: Trilok Soni <soni.trilok@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/omap/Makefile     |    1 
 drivers/video/omap/lcd_palmtt.c |  127 ++++++++++++++++++++++++++++++
 2 files changed, 128 insertions(+)

diff -puN drivers/video/omap/Makefile~omap-lcd-panel-support-for-palm-tungstent drivers/video/omap/Makefile
--- a/drivers/video/omap/Makefile~omap-lcd-panel-support-for-palm-tungstent
+++ a/drivers/video/omap/Makefile
@@ -18,6 +18,7 @@ objs-y$(CONFIG_FB_OMAP_LCDC_BLIZZARD) +=
 objs-y$(CONFIG_MACH_OMAP_H4) += lcd_h4.o
 objs-y$(CONFIG_MACH_OMAP_H3) += lcd_h3.o
 objs-y$(CONFIG_MACH_OMAP_PALMTE) += lcd_palmte.o
+objs-y$(CONFIG_MACH_OMAP_PALMTT) += lcd_palmtt.o
 
 omapfb-objs := $(objs-yy)
 
diff -puN /dev/null drivers/video/omap/lcd_palmtt.c
--- /dev/null
+++ a/drivers/video/omap/lcd_palmtt.c
@@ -0,0 +1,127 @@
+/*
+ * LCD panel support for Palm Tungsten|T
+ * Current version : Marek Vasut <marek.vasut@gmail.com>
+ *
+ * Modified from lcd_inn1510.c
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
+/*
+GPIO11 - backlight
+GPIO12 - screen blanking
+GPIO13 - screen blanking
+*/
+
+#include <linux/platform_device.h>
+#include <linux/module.h>
+#include <linux/io.h>
+
+#include <asm/arch/gpio.h>
+#include <asm/arch/omapfb.h>
+
+static int palmtt_panel_init(struct lcd_panel *panel,
+	struct omapfb_device *fbdev)
+{
+	return 0;
+}
+
+static void palmtt_panel_cleanup(struct lcd_panel *panel)
+{
+}
+
+static int palmtt_panel_enable(struct lcd_panel *panel)
+{
+	return 0;
+}
+
+static void palmtt_panel_disable(struct lcd_panel *panel)
+{
+}
+
+static unsigned long palmtt_panel_get_caps(struct lcd_panel *panel)
+{
+	return OMAPFB_CAPS_SET_BACKLIGHT;
+}
+
+struct lcd_panel palmtt_panel = {
+	.name		= "palmtt",
+	.config		= OMAP_LCDC_PANEL_TFT | OMAP_LCDC_INV_VSYNC |
+			OMAP_LCDC_INV_HSYNC | OMAP_LCDC_HSVS_RISING_EDGE |
+			OMAP_LCDC_HSVS_OPPOSITE,
+	.bpp		= 16,
+	.data_lines	= 16,
+	.x_res		= 320,
+	.y_res		= 320,
+	.pixel_clock	= 10000,
+	.hsw		= 4,
+	.hfp		= 8,
+	.hbp		= 28,
+	.vsw		= 1,
+	.vfp		= 8,
+	.vbp		= 7,
+	.pcd		= 0,
+
+	.init		= palmtt_panel_init,
+	.cleanup	= palmtt_panel_cleanup,
+	.enable		= palmtt_panel_enable,
+	.disable	= palmtt_panel_disable,
+	.get_caps	= palmtt_panel_get_caps,
+};
+
+static int palmtt_panel_probe(struct platform_device *pdev)
+{
+	omapfb_register_panel(&palmtt_panel);
+	return 0;
+}
+
+static int palmtt_panel_remove(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static int palmtt_panel_suspend(struct platform_device *pdev, pm_message_t mesg)
+{
+	return 0;
+}
+
+static int palmtt_panel_resume(struct platform_device *pdev)
+{
+	return 0;
+}
+
+struct platform_driver palmtt_panel_driver = {
+	.probe		= palmtt_panel_probe,
+	.remove		= palmtt_panel_remove,
+	.suspend	= palmtt_panel_suspend,
+	.resume		= palmtt_panel_resume,
+	.driver		= {
+		.name	= "lcd_palmtt",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int palmtt_panel_drv_init(void)
+{
+	return platform_driver_register(&palmtt_panel_driver);
+}
+
+static void palmtt_panel_drv_cleanup(void)
+{
+	platform_driver_unregister(&palmtt_panel_driver);
+}
+
+module_init(palmtt_panel_drv_init);
+module_exit(palmtt_panel_drv_cleanup);
_

Patches currently in -mm which might be from marek.vasut@gmail.com are

origin.patch
