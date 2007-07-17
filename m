From: akpm@linux-foundation.org
Subject: - omap-lcd-panel-support-for-the-palm-zire71.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:08:47 -0700
Message-ID: <200707172308.l6HN8ljO012311@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45704 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936498AbXGQXPt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marek.vasut@gmail.com, adaplas@pol.net, soni.trilok@gmail.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     OMAP: LCD panel support for the Palm Zire71
has been removed from the -mm tree.  Its filename was
     omap-lcd-panel-support-for-the-palm-zire71.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: OMAP: LCD panel support for the Palm Zire71
From: Marek Vasut <marek.vasut@gmail.com>

- Adds support for TFT LCD panel on Palm Zire71

Signed-off-by: Trilok Soni <soni.trilok@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/omap/Makefile      |    1 
 drivers/video/omap/lcd_palmz71.c |  123 +++++++++++++++++++++++++++++
 2 files changed, 124 insertions(+)

diff -puN drivers/video/omap/Makefile~omap-lcd-panel-support-for-the-palm-zire71 drivers/video/omap/Makefile
--- a/drivers/video/omap/Makefile~omap-lcd-panel-support-for-the-palm-zire71
+++ a/drivers/video/omap/Makefile
@@ -19,6 +19,7 @@ objs-y$(CONFIG_MACH_OMAP_H4) += lcd_h4.o
 objs-y$(CONFIG_MACH_OMAP_H3) += lcd_h3.o
 objs-y$(CONFIG_MACH_OMAP_PALMTE) += lcd_palmte.o
 objs-y$(CONFIG_MACH_OMAP_PALMTT) += lcd_palmtt.o
+objs-y$(CONFIG_MACH_OMAP_PALMZ71) += lcd_palmz71.o
 
 omapfb-objs := $(objs-yy)
 
diff -puN /dev/null drivers/video/omap/lcd_palmz71.c
--- /dev/null
+++ a/drivers/video/omap/lcd_palmz71.c
@@ -0,0 +1,123 @@
+/*
+ * LCD panel support for the Palm Zire71
+ *
+ * Original version : Romain Goyet
+ * Current version : Laurent Gonzalez
+ * Modified for zire71 : Marek Vasut
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
+
+#include <asm/arch/omapfb.h>
+
+static int palmz71_panel_init(struct lcd_panel *panel,
+			      struct omapfb_device *fbdev)
+{
+	return 0;
+}
+
+static void palmz71_panel_cleanup(struct lcd_panel *panel)
+{
+
+}
+
+static int palmz71_panel_enable(struct lcd_panel *panel)
+{
+	return 0;
+}
+
+static void palmz71_panel_disable(struct lcd_panel *panel)
+{
+}
+
+static unsigned long palmz71_panel_get_caps(struct lcd_panel *panel)
+{
+	return OMAPFB_CAPS_SET_BACKLIGHT;
+}
+
+struct lcd_panel palmz71_panel = {
+	.name		= "palmz71",
+	.config		= OMAP_LCDC_PANEL_TFT | OMAP_LCDC_INV_VSYNC |
+			  OMAP_LCDC_INV_HSYNC | OMAP_LCDC_HSVS_RISING_EDGE |
+			  OMAP_LCDC_HSVS_OPPOSITE,
+	.data_lines	= 16,
+	.bpp		= 16,
+	.pixel_clock	= 24000,
+	.x_res		= 320,
+	.y_res		= 320,
+	.hsw		= 4,
+	.hfp		= 8,
+	.hbp		= 28,
+	.vsw		= 1,
+	.vfp		= 8,
+	.vbp		= 7,
+	.pcd		= 0,
+
+	.init		= palmz71_panel_init,
+	.cleanup	= palmz71_panel_cleanup,
+	.enable		= palmz71_panel_enable,
+	.disable	= palmz71_panel_disable,
+	.get_caps	= palmz71_panel_get_caps,
+};
+
+static int palmz71_panel_probe(struct platform_device *pdev)
+{
+	omapfb_register_panel(&palmz71_panel);
+	return 0;
+}
+
+static int palmz71_panel_remove(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static int palmz71_panel_suspend(struct platform_device *pdev,
+				 pm_message_t mesg)
+{
+	return 0;
+}
+
+static int palmz71_panel_resume(struct platform_device *pdev)
+{
+	return 0;
+}
+
+struct platform_driver palmz71_panel_driver = {
+	.probe		= palmz71_panel_probe,
+	.remove		= palmz71_panel_remove,
+	.suspend	= palmz71_panel_suspend,
+	.resume		= palmz71_panel_resume,
+	.driver		= {
+		.name	= "lcd_palmz71",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int palmz71_panel_drv_init(void)
+{
+	return platform_driver_register(&palmz71_panel_driver);
+}
+
+static void palmz71_panel_drv_cleanup(void)
+{
+	platform_driver_unregister(&palmz71_panel_driver);
+}
+
+module_init(palmz71_panel_drv_init);
+module_exit(palmz71_panel_drv_cleanup);
_

Patches currently in -mm which might be from marek.vasut@gmail.com are

origin.patch
