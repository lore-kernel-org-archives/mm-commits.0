From: akpm@linux-foundation.org
Subject: + omap-lcd-panel-support-for-the-ti-omap-osk-board.patch added to -mm tree
Date: Tue, 26 Jun 2007 17:29:54 -0700
Message-ID: <200706270029.l5R0Ts4x006381@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39472 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752924AbXF0AaS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 20:30:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dirk.behme@de.bosch.com, adaplas@pol.net, soni.trilok@gmail.com, tony@atomide.com


The patch titled
     OMAP: LCD panel support for the TI OMAP OSK board
has been added to the -mm tree.  Its filename is
     omap-lcd-panel-support-for-the-ti-omap-osk-board.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: OMAP: LCD panel support for the TI OMAP OSK board
From: Dirk Behme <dirk.behme@de.bosch.com>

- Adds TFT LCD panel support for TI OMAP OSK board.

Signed-off-by: Trilok Soni <soni.trilok@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/omap/Makefile  |    1 
 drivers/video/omap/lcd_osk.c |  144 +++++++++++++++++++++++++++++++++
 2 files changed, 145 insertions(+)

diff -puN drivers/video/omap/Makefile~omap-lcd-panel-support-for-the-ti-omap-osk-board drivers/video/omap/Makefile
--- a/drivers/video/omap/Makefile~omap-lcd-panel-support-for-the-ti-omap-osk-board
+++ a/drivers/video/omap/Makefile
@@ -22,6 +22,7 @@ objs-y$(CONFIG_MACH_OMAP_PALMTT) += lcd_
 objs-y$(CONFIG_MACH_OMAP_PALMZ71) += lcd_palmz71.o
 objs-$(CONFIG_ARCH_OMAP16XX)$(CONFIG_MACH_OMAP_INNOVATOR) += lcd_inn1610.o
 objs-$(CONFIG_ARCH_OMAP15XX)$(CONFIG_MACH_OMAP_INNOVATOR) += lcd_inn1510.o
+objs-y$(CONFIG_MACH_OMAP_OSK) += lcd_osk.o
 
 omapfb-objs := $(objs-yy)
 
diff -puN /dev/null drivers/video/omap/lcd_osk.c
--- /dev/null
+++ a/drivers/video/omap/lcd_osk.c
@@ -0,0 +1,144 @@
+/*
+ * LCD panel support for the TI OMAP OSK board
+ *
+ * Copyright (C) 2004 Nokia Corporation
+ * Author: Imre Deak <imre.deak@nokia.com>
+ * Adapted for OSK by <dirk.behme@de.bosch.com>
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
+#include <asm/arch/mux.h>
+#include <asm/arch/omapfb.h>
+
+static int osk_panel_init(struct lcd_panel *panel, struct omapfb_device *fbdev)
+{
+	return 0;
+}
+
+static void osk_panel_cleanup(struct lcd_panel *panel)
+{
+}
+
+static int osk_panel_enable(struct lcd_panel *panel)
+{
+	/* configure PWL pin */
+	omap_cfg_reg(PWL);
+
+	/* Enable PWL unit */
+	omap_writeb(0x01, OMAP_PWL_CLK_ENABLE);
+
+	/* Set PWL level */
+	omap_writeb(0xFF, OMAP_PWL_ENABLE);
+
+	/* configure GPIO2 as output */
+	omap_set_gpio_direction(2, 0);
+
+	/* set GPIO2 high */
+	omap_set_gpio_dataout(2, 1);
+
+	return 0;
+}
+
+static void osk_panel_disable(struct lcd_panel *panel)
+{
+	/* Set PWL level to zero */
+	omap_writeb(0x00, OMAP_PWL_ENABLE);
+
+	/* Disable PWL unit */
+	omap_writeb(0x00, OMAP_PWL_CLK_ENABLE);
+
+	/* set GPIO2 low */
+	omap_set_gpio_dataout(2, 0);
+}
+
+static unsigned long osk_panel_get_caps(struct lcd_panel *panel)
+{
+	return 0;
+}
+
+struct lcd_panel osk_panel = {
+	.name		= "osk",
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
+	.init		= osk_panel_init,
+	.cleanup	= osk_panel_cleanup,
+	.enable		= osk_panel_enable,
+	.disable	= osk_panel_disable,
+	.get_caps	= osk_panel_get_caps,
+};
+
+static int osk_panel_probe(struct platform_device *pdev)
+{
+	omapfb_register_panel(&osk_panel);
+	return 0;
+}
+
+static int osk_panel_remove(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static int osk_panel_suspend(struct platform_device *pdev, pm_message_t mesg)
+{
+	return 0;
+}
+
+static int osk_panel_resume(struct platform_device *pdev)
+{
+	return 0;
+}
+
+struct platform_driver osk_panel_driver = {
+	.probe		= osk_panel_probe,
+	.remove		= osk_panel_remove,
+	.suspend	= osk_panel_suspend,
+	.resume		= osk_panel_resume,
+	.driver		= {
+		.name	= "lcd_osk",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int osk_panel_drv_init(void)
+{
+	return platform_driver_register(&osk_panel_driver);
+}
+
+static void osk_panel_drv_cleanup(void)
+{
+	platform_driver_unregister(&osk_panel_driver);
+}
+
+module_init(osk_panel_drv_init);
+module_exit(osk_panel_drv_cleanup);
+
_

Patches currently in -mm which might be from dirk.behme@de.bosch.com are

omap-lcd-panel-support-for-the-ti-omap-osk-board.patch
