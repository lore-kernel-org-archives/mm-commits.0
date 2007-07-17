From: akpm@linux-foundation.org
Subject: - omap-lcd-panel-support-for-the-ti-omap-h4-board.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:08:39 -0700
Message-ID: <200707172308.l6HN8d2N012299@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36536 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936502AbXGQXPt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: imre.deak@solidboot.com, adaplas@pol.net, soni.trilok@gmail.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     OMAP: LCD panel support for the TI OMAP H4 board
has been removed from the -mm tree.  Its filename was
     omap-lcd-panel-support-for-the-ti-omap-h4-board.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: OMAP: LCD panel support for the TI OMAP H4 board
From: Imre Deak <imre.deak@solidboot.com>

- Adds support for TFT LCD panel on TI OMAP H4 EVM board.

Signed-off-by: Trilok Soni <soni.trilok@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/omap/Makefile |    2 
 drivers/video/omap/lcd_h4.c |  117 ++++++++++++++++++++++++++++++++++
 2 files changed, 119 insertions(+)

diff -puN drivers/video/omap/Makefile~omap-lcd-panel-support-for-the-ti-omap-h4-board drivers/video/omap/Makefile
--- a/drivers/video/omap/Makefile~omap-lcd-panel-support-for-the-ti-omap-h4-board
+++ a/drivers/video/omap/Makefile
@@ -15,5 +15,7 @@ objs-$(CONFIG_ARCH_OMAP2)$(CONFIG_FB_OMA
 objs-y$(CONFIG_FB_OMAP_LCDC_HWA742) += hwa742.o
 objs-y$(CONFIG_FB_OMAP_LCDC_BLIZZARD) += blizzard.o
 
+objs-y$(CONFIG_MACH_OMAP_H4) += lcd_h4.o
+
 omapfb-objs := $(objs-yy)
 
diff -puN /dev/null drivers/video/omap/lcd_h4.c
--- /dev/null
+++ a/drivers/video/omap/lcd_h4.c
@@ -0,0 +1,117 @@
+/*
+ * LCD panel support for the TI OMAP H4 board
+ *
+ * Copyright (C) 2004 Nokia Corporation
+ * Author: Imre Deak <imre.deak@nokia.com>
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
+
+#include <asm/arch/omapfb.h>
+
+static int h4_panel_init(struct lcd_panel *panel, struct omapfb_device *fbdev)
+{
+	return 0;
+}
+
+static void h4_panel_cleanup(struct lcd_panel *panel)
+{
+}
+
+static int h4_panel_enable(struct lcd_panel *panel)
+{
+	return 0;
+}
+
+static void h4_panel_disable(struct lcd_panel *panel)
+{
+}
+
+static unsigned long h4_panel_get_caps(struct lcd_panel *panel)
+{
+	return 0;
+}
+
+struct lcd_panel h4_panel = {
+	.name		= "h4",
+	.config		= OMAP_LCDC_PANEL_TFT,
+
+	.bpp		= 16,
+	.data_lines	= 16,
+	.x_res		= 240,
+	.y_res		= 320,
+	.pixel_clock	= 6250,
+	.hsw		= 15,
+	.hfp		= 15,
+	.hbp		= 60,
+	.vsw		= 1,
+	.vfp		= 1,
+	.vbp		= 1,
+
+	.init		= h4_panel_init,
+	.cleanup	= h4_panel_cleanup,
+	.enable		= h4_panel_enable,
+	.disable	= h4_panel_disable,
+	.get_caps	= h4_panel_get_caps,
+};
+
+static int h4_panel_probe(struct platform_device *pdev)
+{
+	omapfb_register_panel(&h4_panel);
+	return 0;
+}
+
+static int h4_panel_remove(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static int h4_panel_suspend(struct platform_device *pdev, pm_message_t mesg)
+{
+	return 0;
+}
+
+static int h4_panel_resume(struct platform_device *pdev)
+{
+	return 0;
+}
+
+struct platform_driver h4_panel_driver = {
+	.probe		= h4_panel_probe,
+	.remove		= h4_panel_remove,
+	.suspend	= h4_panel_suspend,
+	.resume		= h4_panel_resume,
+	.driver		= {
+		.name	= "lcd_h4",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int h4_panel_drv_init(void)
+{
+	return platform_driver_register(&h4_panel_driver);
+}
+
+static void h4_panel_drv_cleanup(void)
+{
+	platform_driver_unregister(&h4_panel_driver);
+}
+
+module_init(h4_panel_drv_init);
+module_exit(h4_panel_drv_cleanup);
+
_

Patches currently in -mm which might be from imre.deak@solidboot.com are

origin.patch
