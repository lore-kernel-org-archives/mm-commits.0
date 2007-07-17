From: akpm@linux-foundation.org
Subject: - omap-lcd-panel-support-for-the-ti-omap1510-innovator-board.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:08:51 -0700
Message-ID: <200707172308.l6HN8pYX012317@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32944 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760593AbXGQXPv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: imre.deak@solidboot.com, adaplas@pol.net, soni.trilok@gmail.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     OMAP: LCD panel support for the TI OMAP1510 Innovator board
has been removed from the -mm tree.  Its filename was
     omap-lcd-panel-support-for-the-ti-omap1510-innovator-board.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: OMAP: LCD panel support for the TI OMAP1510 Innovator board
From: Imre Deak <imre.deak@solidboot.com>

- Add TFT LCD panel spport for TI OMAP1510 Innovator EVM.

Signed-off-by: Trilok Soni <soni.trilok@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/omap/Makefile      |    1 
 drivers/video/omap/lcd_inn1510.c |  124 +++++++++++++++++++++++++++++
 2 files changed, 125 insertions(+)

diff -puN drivers/video/omap/Makefile~omap-lcd-panel-support-for-the-ti-omap1510-innovator-board drivers/video/omap/Makefile
--- a/drivers/video/omap/Makefile~omap-lcd-panel-support-for-the-ti-omap1510-innovator-board
+++ a/drivers/video/omap/Makefile
@@ -21,6 +21,7 @@ objs-y$(CONFIG_MACH_OMAP_PALMTE) += lcd_
 objs-y$(CONFIG_MACH_OMAP_PALMTT) += lcd_palmtt.o
 objs-y$(CONFIG_MACH_OMAP_PALMZ71) += lcd_palmz71.o
 objs-$(CONFIG_ARCH_OMAP16XX)$(CONFIG_MACH_OMAP_INNOVATOR) += lcd_inn1610.o
+objs-$(CONFIG_ARCH_OMAP15XX)$(CONFIG_MACH_OMAP_INNOVATOR) += lcd_inn1510.o
 
 omapfb-objs := $(objs-yy)
 
diff -puN /dev/null drivers/video/omap/lcd_inn1510.c
--- /dev/null
+++ a/drivers/video/omap/lcd_inn1510.c
@@ -0,0 +1,124 @@
+/*
+ * LCD panel support for the TI OMAP1510 Innovator board
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
+#include <linux/io.h>
+
+#include <asm/arch/fpga.h>
+#include <asm/arch/omapfb.h>
+
+static int innovator1510_panel_init(struct lcd_panel *panel,
+				    struct omapfb_device *fbdev)
+{
+	return 0;
+}
+
+static void innovator1510_panel_cleanup(struct lcd_panel *panel)
+{
+}
+
+static int innovator1510_panel_enable(struct lcd_panel *panel)
+{
+	fpga_write(0x7, OMAP1510_FPGA_LCD_PANEL_CONTROL);
+	return 0;
+}
+
+static void innovator1510_panel_disable(struct lcd_panel *panel)
+{
+	fpga_write(0x0, OMAP1510_FPGA_LCD_PANEL_CONTROL);
+}
+
+static unsigned long innovator1510_panel_get_caps(struct lcd_panel *panel)
+{
+	return 0;
+}
+
+struct lcd_panel innovator1510_panel = {
+	.name		= "inn1510",
+	.config		= OMAP_LCDC_PANEL_TFT,
+
+	.bpp		= 16,
+	.data_lines	= 16,
+	.x_res		= 240,
+	.y_res		= 320,
+	.pixel_clock	= 12500,
+	.hsw		= 40,
+	.hfp		= 40,
+	.hbp		= 72,
+	.vsw		= 1,
+	.vfp		= 1,
+	.vbp		= 0,
+	.pcd		= 12,
+
+	.init		= innovator1510_panel_init,
+	.cleanup	= innovator1510_panel_cleanup,
+	.enable		= innovator1510_panel_enable,
+	.disable	= innovator1510_panel_disable,
+	.get_caps	= innovator1510_panel_get_caps,
+};
+
+static int innovator1510_panel_probe(struct platform_device *pdev)
+{
+	omapfb_register_panel(&innovator1510_panel);
+	return 0;
+}
+
+static int innovator1510_panel_remove(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static int innovator1510_panel_suspend(struct platform_device *pdev,
+				       pm_message_t mesg)
+{
+	return 0;
+}
+
+static int innovator1510_panel_resume(struct platform_device *pdev)
+{
+	return 0;
+}
+
+struct platform_driver innovator1510_panel_driver = {
+	.probe		= innovator1510_panel_probe,
+	.remove		= innovator1510_panel_remove,
+	.suspend	= innovator1510_panel_suspend,
+	.resume		= innovator1510_panel_resume,
+	.driver		= {
+		.name	= "lcd_inn1510",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int innovator1510_panel_drv_init(void)
+{
+	return platform_driver_register(&innovator1510_panel_driver);
+}
+
+static void innovator1510_panel_drv_cleanup(void)
+{
+	platform_driver_unregister(&innovator1510_panel_driver);
+}
+
+module_init(innovator1510_panel_drv_init);
+module_exit(innovator1510_panel_drv_cleanup);
+
_

Patches currently in -mm which might be from imre.deak@solidboot.com are

origin.patch
