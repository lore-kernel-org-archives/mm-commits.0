From: akpm@linux-foundation.org
Subject: - omap-lcd-panel-support-for-the-ti-omap-h3-board.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:08:41 -0700
Message-ID: <200707172308.l6HN8faw012302@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55045 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936546AbXGQXPw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: imre.deak@solidboot.com, adaplas@pol.net, soni.trilok@gmail.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     OMAP: LCD panel support for the TI OMAP H3 board
has been removed from the -mm tree.  Its filename was
     omap-lcd-panel-support-for-the-ti-omap-h3-board.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: OMAP: LCD panel support for the TI OMAP H3 board
From: Imre Deak <imre.deak@solidboot.com>

- Adds support for TFT LCD panel on TI OMAP H3 EVM board.

Signed-off-by: Trilok Soni <soni.trilok@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/omap/Makefile |    1 
 drivers/video/omap/lcd_h3.c |  141 ++++++++++++++++++++++++++++++++++
 2 files changed, 142 insertions(+)

diff -puN drivers/video/omap/Makefile~omap-lcd-panel-support-for-the-ti-omap-h3-board drivers/video/omap/Makefile
--- a/drivers/video/omap/Makefile~omap-lcd-panel-support-for-the-ti-omap-h3-board
+++ a/drivers/video/omap/Makefile
@@ -16,6 +16,7 @@ objs-y$(CONFIG_FB_OMAP_LCDC_HWA742) += h
 objs-y$(CONFIG_FB_OMAP_LCDC_BLIZZARD) += blizzard.o
 
 objs-y$(CONFIG_MACH_OMAP_H4) += lcd_h4.o
+objs-y$(CONFIG_MACH_OMAP_H3) += lcd_h3.o
 
 omapfb-objs := $(objs-yy)
 
diff -puN /dev/null drivers/video/omap/lcd_h3.c
--- /dev/null
+++ a/drivers/video/omap/lcd_h3.c
@@ -0,0 +1,141 @@
+/*
+ * LCD panel support for the TI OMAP H3 board
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
+#include <asm/arch/gpio.h>
+#include <asm/arch/tps65010.h>
+#include <asm/arch/omapfb.h>
+
+#define MODULE_NAME	"omapfb-lcd_h3"
+
+#define pr_err(fmt, args...) printk(KERN_ERR MODULE_NAME ": " fmt, ## args)
+
+static int h3_panel_init(struct lcd_panel *panel, struct omapfb_device *fbdev)
+{
+	return 0;
+}
+
+static void h3_panel_cleanup(struct lcd_panel *panel)
+{
+}
+
+static int h3_panel_enable(struct lcd_panel *panel)
+{
+	int r = 0;
+
+	/* GPIO1 and GPIO2 of TPS65010 send LCD_ENBKL and LCD_ENVDD signals */
+	r = tps65010_set_gpio_out_value(GPIO1, HIGH);
+	if (!r)
+		r = tps65010_set_gpio_out_value(GPIO2, HIGH);
+	if (r)
+		pr_err("Unable to turn on LCD panel\n");
+
+	return r;
+}
+
+static void h3_panel_disable(struct lcd_panel *panel)
+{
+	int r = 0;
+
+	/* GPIO1 and GPIO2 of TPS65010 send LCD_ENBKL and LCD_ENVDD signals */
+	r = tps65010_set_gpio_out_value(GPIO1, LOW);
+	if (!r)
+		tps65010_set_gpio_out_value(GPIO2, LOW);
+	if (r)
+		pr_err("Unable to turn off LCD panel\n");
+}
+
+static unsigned long h3_panel_get_caps(struct lcd_panel *panel)
+{
+	return 0;
+}
+
+struct lcd_panel h3_panel = {
+	.name		= "h3",
+	.config		= OMAP_LCDC_PANEL_TFT,
+
+	.data_lines	= 16,
+	.bpp		= 16,
+	.x_res		= 240,
+	.y_res		= 320,
+	.pixel_clock	= 12000,
+	.hsw		= 12,
+	.hfp		= 14,
+	.hbp		= 72 - 12,
+	.vsw		= 1,
+	.vfp		= 1,
+	.vbp		= 0,
+	.pcd		= 0,
+
+	.init		= h3_panel_init,
+	.cleanup	= h3_panel_cleanup,
+	.enable		= h3_panel_enable,
+	.disable	= h3_panel_disable,
+	.get_caps	= h3_panel_get_caps,
+};
+
+static int h3_panel_probe(struct platform_device *pdev)
+{
+	omapfb_register_panel(&h3_panel);
+	return 0;
+}
+
+static int h3_panel_remove(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static int h3_panel_suspend(struct platform_device *pdev, pm_message_t mesg)
+{
+	return 0;
+}
+
+static int h3_panel_resume(struct platform_device *pdev)
+{
+	return 0;
+}
+
+struct platform_driver h3_panel_driver = {
+	.probe		= h3_panel_probe,
+	.remove		= h3_panel_remove,
+	.suspend	= h3_panel_suspend,
+	.resume		= h3_panel_resume,
+	.driver		= {
+		.name	= "lcd_h3",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int h3_panel_drv_init(void)
+{
+	return platform_driver_register(&h3_panel_driver);
+}
+
+static void h3_panel_drv_cleanup(void)
+{
+	platform_driver_unregister(&h3_panel_driver);
+}
+
+module_init(h3_panel_drv_init);
+module_exit(h3_panel_drv_cleanup);
+
_

Patches currently in -mm which might be from imre.deak@solidboot.com are

origin.patch
