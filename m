From: akpm@linux-foundation.org
Subject: + omap-lcd-panel-support-for-the-ti-omap1610-innovator-board.patch added to -mm tree
Date: Tue, 26 Jun 2007 17:29:49 -0700
Message-ID: <200706270029.l5R0Tn69006375@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42054 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753574AbXF0AaA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 20:30:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: imre.deak@solidboot.com, adaplas@pol.net, soni.trilok@gmail.com, tony@atomide.com


The patch titled
     OMAP: LCD panel support for the TI OMAP1610 Innovator board
has been added to the -mm tree.  Its filename is
     omap-lcd-panel-support-for-the-ti-omap1610-innovator-board.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: OMAP: LCD panel support for the TI OMAP1610 Innovator board
From: Imre Deak <imre.deak@solidboot.com>

- Add TFT LCD panel spport for TI OMAP1610 Innovator EVM.

Signed-off-by: Trilok Soni <soni.trilok@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/omap/Makefile      |    1 
 drivers/video/omap/lcd_inn1610.c |  150 +++++++++++++++++++++++++++++
 2 files changed, 151 insertions(+)

diff -puN drivers/video/omap/Makefile~omap-lcd-panel-support-for-the-ti-omap1610-innovator-board drivers/video/omap/Makefile
--- a/drivers/video/omap/Makefile~omap-lcd-panel-support-for-the-ti-omap1610-innovator-board
+++ a/drivers/video/omap/Makefile
@@ -20,6 +20,7 @@ objs-y$(CONFIG_MACH_OMAP_H3) += lcd_h3.o
 objs-y$(CONFIG_MACH_OMAP_PALMTE) += lcd_palmte.o
 objs-y$(CONFIG_MACH_OMAP_PALMTT) += lcd_palmtt.o
 objs-y$(CONFIG_MACH_OMAP_PALMZ71) += lcd_palmz71.o
+objs-$(CONFIG_ARCH_OMAP16XX)$(CONFIG_MACH_OMAP_INNOVATOR) += lcd_inn1610.o
 
 omapfb-objs := $(objs-yy)
 
diff -puN /dev/null drivers/video/omap/lcd_inn1610.c
--- /dev/null
+++ a/drivers/video/omap/lcd_inn1610.c
@@ -0,0 +1,150 @@
+/*
+ * LCD panel support for the TI OMAP1610 Innovator board
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
+#include <asm/arch/omapfb.h>
+
+#define MODULE_NAME	"omapfb-lcd_h3"
+
+#define pr_err(fmt, args...) printk(KERN_ERR MODULE_NAME ": " fmt, ## args)
+
+static int innovator1610_panel_init(struct lcd_panel *panel,
+				    struct omapfb_device *fbdev)
+{
+	int r = 0;
+
+	if (omap_request_gpio(14)) {
+		pr_err("can't request GPIO 14\n");
+		r = -1;
+		goto exit;
+	}
+	if (omap_request_gpio(15)) {
+		pr_err("can't request GPIO 15\n");
+		omap_free_gpio(14);
+		r = -1;
+		goto exit;
+	}
+	/* configure GPIO(14, 15) as outputs */
+	omap_set_gpio_direction(14, 0);
+	omap_set_gpio_direction(15, 0);
+exit:
+	return r;
+}
+
+static void innovator1610_panel_cleanup(struct lcd_panel *panel)
+{
+	omap_free_gpio(15);
+	omap_free_gpio(14);
+}
+
+static int innovator1610_panel_enable(struct lcd_panel *panel)
+{
+	/* set GPIO14 and GPIO15 high */
+	omap_set_gpio_dataout(14, 1);
+	omap_set_gpio_dataout(15, 1);
+	return 0;
+}
+
+static void innovator1610_panel_disable(struct lcd_panel *panel)
+{
+	/* set GPIO13, GPIO14 and GPIO15 low */
+	omap_set_gpio_dataout(14, 0);
+	omap_set_gpio_dataout(15, 0);
+}
+
+static unsigned long innovator1610_panel_get_caps(struct lcd_panel *panel)
+{
+	return 0;
+}
+
+struct lcd_panel innovator1610_panel = {
+	.name		= "inn1610",
+	.config		= OMAP_LCDC_PANEL_TFT,
+
+	.bpp		= 16,
+	.data_lines	= 16,
+	.x_res		= 320,
+	.y_res		= 240,
+	.pixel_clock	= 12500,
+	.hsw		= 40,
+	.hfp		= 40,
+	.hbp		= 72,
+	.vsw		= 1,
+	.vfp		= 1,
+	.vbp		= 0,
+	.pcd		= 12,
+
+	.init		= innovator1610_panel_init,
+	.cleanup	= innovator1610_panel_cleanup,
+	.enable		= innovator1610_panel_enable,
+	.disable	= innovator1610_panel_disable,
+	.get_caps	= innovator1610_panel_get_caps,
+};
+
+static int innovator1610_panel_probe(struct platform_device *pdev)
+{
+	omapfb_register_panel(&innovator1610_panel);
+	return 0;
+}
+
+static int innovator1610_panel_remove(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static int innovator1610_panel_suspend(struct platform_device *pdev,
+				       pm_message_t mesg)
+{
+	return 0;
+}
+
+static int innovator1610_panel_resume(struct platform_device *pdev)
+{
+	return 0;
+}
+
+struct platform_driver innovator1610_panel_driver = {
+	.probe		= innovator1610_panel_probe,
+	.remove		= innovator1610_panel_remove,
+	.suspend	= innovator1610_panel_suspend,
+	.resume		= innovator1610_panel_resume,
+	.driver		= {
+		.name	= "lcd_inn1610",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int innovator1610_panel_drv_init(void)
+{
+	return platform_driver_register(&innovator1610_panel_driver);
+}
+
+static void innovator1610_panel_drv_cleanup(void)
+{
+	platform_driver_unregister(&innovator1610_panel_driver);
+}
+
+module_init(innovator1610_panel_drv_init);
+module_exit(innovator1610_panel_drv_cleanup);
+
_

Patches currently in -mm which might be from imre.deak@solidboot.com are

omap-add-ti-omap-framebuffer-driver.patch
omap-add-ti-omap1610-accelerator-entry.patch
omap-add-ti-omap1-internal-lcd-controller.patch
omap-add-ti-omap2-internal-display-controller-support.patch
omap-add-ti-omap1-external-lcd-controller-support-sossi.patch
omap-add-ti-omap2-external-lcd-controller-support-rfbi.patch
omap-add-external-epson-hwa742-lcd-controller-support.patch
omap-add-external-epson-blizzard-lcd-controller-support.patch
omap-lcd-panel-support-for-the-ti-omap-h4-board.patch
omap-lcd-panel-support-for-the-ti-omap-h3-board.patch
omap-lcd-panel-support-for-the-ti-omap1610-innovator-board.patch
omap-lcd-panel-support-for-the-ti-omap1510-innovator-board.patch
