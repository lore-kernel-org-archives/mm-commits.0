From: akpm@linux-foundation.org
Subject: + omap-lcd-panel-support-for-the-palm-tungsten-e.patch added to -mm tree
Date: Tue, 26 Jun 2007 17:29:43 -0700
Message-ID: <200706270029.l5R0Thqa006366@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38511 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753662AbXF0A3w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 20:29:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: r.goyet@gmail.com, adaplas@pol.net, soni.trilok@gmail.com, tony@atomide.com


The patch titled
     OMAP: LCD panel support for the Palm Tungsten E
has been added to the -mm tree.  Its filename is
     omap-lcd-panel-support-for-the-palm-tungsten-e.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: OMAP: LCD panel support for the Palm Tungsten E
From: Romain Goyet <r.goyet@gmail.com>

- Adds TFT LCD panel support for Palm Tungsten E.

Signed-off-by: Trilok Soni <soni.trilok@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/omap/Makefile     |    1 
 drivers/video/omap/lcd_palmte.c |  123 ++++++++++++++++++++++++++++++
 2 files changed, 124 insertions(+)

diff -puN drivers/video/omap/Makefile~omap-lcd-panel-support-for-the-palm-tungsten-e drivers/video/omap/Makefile
--- a/drivers/video/omap/Makefile~omap-lcd-panel-support-for-the-palm-tungsten-e
+++ a/drivers/video/omap/Makefile
@@ -17,6 +17,7 @@ objs-y$(CONFIG_FB_OMAP_LCDC_BLIZZARD) +=
 
 objs-y$(CONFIG_MACH_OMAP_H4) += lcd_h4.o
 objs-y$(CONFIG_MACH_OMAP_H3) += lcd_h3.o
+objs-y$(CONFIG_MACH_OMAP_PALMTE) += lcd_palmte.o
 
 omapfb-objs := $(objs-yy)
 
diff -puN /dev/null drivers/video/omap/lcd_palmte.c
--- /dev/null
+++ a/drivers/video/omap/lcd_palmte.c
@@ -0,0 +1,123 @@
+/*
+ * LCD panel support for the Palm Tungsten E
+ *
+ * Original version : Romain Goyet <r.goyet@gmail.com>
+ * Current version : Laurent Gonzalez <palmte.linux@free.fr>
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
+#include <asm/arch/fpga.h>
+#include <asm/arch/omapfb.h>
+
+static int palmte_panel_init(struct lcd_panel *panel,
+				struct omapfb_device *fbdev)
+{
+	return 0;
+}
+
+static void palmte_panel_cleanup(struct lcd_panel *panel)
+{
+}
+
+static int palmte_panel_enable(struct lcd_panel *panel)
+{
+	return 0;
+}
+
+static void palmte_panel_disable(struct lcd_panel *panel)
+{
+}
+
+static unsigned long palmte_panel_get_caps(struct lcd_panel *panel)
+{
+	return 0;
+}
+
+struct lcd_panel palmte_panel = {
+	.name		= "palmte",
+	.config		= OMAP_LCDC_PANEL_TFT | OMAP_LCDC_INV_VSYNC |
+			  OMAP_LCDC_INV_HSYNC | OMAP_LCDC_HSVS_RISING_EDGE |
+			  OMAP_LCDC_HSVS_OPPOSITE,
+
+	.data_lines	= 16,
+	.bpp		= 8,
+	.pixel_clock	= 12000,
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
+	.init		= palmte_panel_init,
+	.cleanup	= palmte_panel_cleanup,
+	.enable		= palmte_panel_enable,
+	.disable	= palmte_panel_disable,
+	.get_caps	= palmte_panel_get_caps,
+};
+
+static int palmte_panel_probe(struct platform_device *pdev)
+{
+	omapfb_register_panel(&palmte_panel);
+	return 0;
+}
+
+static int palmte_panel_remove(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static int palmte_panel_suspend(struct platform_device *pdev, pm_message_t mesg)
+{
+	return 0;
+}
+
+static int palmte_panel_resume(struct platform_device *pdev)
+{
+	return 0;
+}
+
+struct platform_driver palmte_panel_driver = {
+	.probe		= palmte_panel_probe,
+	.remove		= palmte_panel_remove,
+	.suspend	= palmte_panel_suspend,
+	.resume		= palmte_panel_resume,
+	.driver		= {
+		.name	= "lcd_palmte",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int palmte_panel_drv_init(void)
+{
+	return platform_driver_register(&palmte_panel_driver);
+}
+
+static void palmte_panel_drv_cleanup(void)
+{
+	platform_driver_unregister(&palmte_panel_driver);
+}
+
+module_init(palmte_panel_drv_init);
+module_exit(palmte_panel_drv_cleanup);
+
_

Patches currently in -mm which might be from r.goyet@gmail.com are

omap-lcd-panel-support-for-the-palm-tungsten-e.patch
