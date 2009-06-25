From: akpm@linux-foundation.org
Subject: + omapfb-add-support-for-the-apollon-lcd.patch added to -mm tree
Date: Wed, 24 Jun 2009 17:07:28 -0700
Message-ID: <200906250007.n5P07Sul004266@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752138AbZFYAIK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jun 2009 20:08:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kyungmin.park@samsung.com, imre.deak@nokia.com, krzysztof.h1@wp.pl


The patch titled
     omapfb: add support for the Apollon LCD
has been added to the -mm tree.  Its filename is
     omapfb-add-support-for-the-apollon-lcd.patch

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
Subject: omapfb: add support for the Apollon LCD
From: Kyungmin Park <kyungmin.park@samsung.com>

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Imre Deak <imre.deak@nokia.com>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/omap/Makefile      |    2 
 drivers/video/omap/lcd_apollon.c |  138 +++++++++++++++++++++++++++++
 2 files changed, 140 insertions(+)

diff -puN drivers/video/omap/Makefile~omapfb-add-support-for-the-apollon-lcd drivers/video/omap/Makefile
--- a/drivers/video/omap/Makefile~omapfb-add-support-for-the-apollon-lcd
+++ a/drivers/video/omap/Makefile
@@ -24,5 +24,7 @@ objs-$(CONFIG_ARCH_OMAP16XX)$(CONFIG_MAC
 objs-$(CONFIG_ARCH_OMAP15XX)$(CONFIG_MACH_OMAP_INNOVATOR) += lcd_inn1510.o
 objs-y$(CONFIG_MACH_OMAP_OSK) += lcd_osk.o
 
+objs-y$(CONFIG_MACH_OMAP_APOLLON) += lcd_apollon.o
+
 omapfb-objs := $(objs-yy)
 
diff -puN /dev/null drivers/video/omap/lcd_apollon.c
--- /dev/null
+++ a/drivers/video/omap/lcd_apollon.c
@@ -0,0 +1,138 @@
+/*
+ * LCD panel support for the Samsung OMAP2 Apollon board
+ *
+ * Copyright (C) 2005,2006 Samsung Electronics
+ * Author: Kyungmin Park <kyungmin.park@samsung.com>
+ *
+ * Derived from drivers/video/omap/lcd-h4.c
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
+#include <mach/gpio.h>
+#include <mach/mux.h>
+#include <mach/omapfb.h>
+
+/* #define USE_35INCH_LCD 1 */
+
+static int apollon_panel_init(struct lcd_panel *panel,
+				struct omapfb_device *fbdev)
+{
+	/* configure LCD PWR_EN */
+	omap_cfg_reg(M21_242X_GPIO11);
+	return 0;
+}
+
+static void apollon_panel_cleanup(struct lcd_panel *panel)
+{
+}
+
+static int apollon_panel_enable(struct lcd_panel *panel)
+{
+	return 0;
+}
+
+static void apollon_panel_disable(struct lcd_panel *panel)
+{
+}
+
+static unsigned long apollon_panel_get_caps(struct lcd_panel *panel)
+{
+	return 0;
+}
+
+struct lcd_panel apollon_panel = {
+	.name		= "apollon",
+	.config		= OMAP_LCDC_PANEL_TFT | OMAP_LCDC_INV_VSYNC |
+			  OMAP_LCDC_INV_HSYNC,
+
+	.bpp		= 16,
+	.data_lines	= 18,
+#ifdef USE_35INCH_LCD
+	.x_res		= 240,
+	.y_res		= 320,
+	.hsw		= 2,
+	.hfp		= 3,
+	.hbp		= 9,
+	.vsw		= 4,
+	.vfp		= 3,
+	.vbp		= 5,
+#else
+	.x_res		= 480,
+	.y_res		= 272,
+	.hsw		= 41,
+	.hfp		= 2,
+	.hbp		= 2,
+	.vsw		= 10,
+	.vfp		= 2,
+	.vbp		= 2,
+#endif
+	.pixel_clock	= 6250,
+
+	.init		= apollon_panel_init,
+	.cleanup	= apollon_panel_cleanup,
+	.enable		= apollon_panel_enable,
+	.disable	= apollon_panel_disable,
+	.get_caps	= apollon_panel_get_caps,
+};
+
+static int apollon_panel_probe(struct platform_device *pdev)
+{
+	omapfb_register_panel(&apollon_panel);
+	return 0;
+}
+
+static int apollon_panel_remove(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static int apollon_panel_suspend(struct platform_device *pdev,
+				  pm_message_t mesg)
+{
+	return 0;
+}
+
+static int apollon_panel_resume(struct platform_device *pdev)
+{
+	return 0;
+}
+
+struct platform_driver apollon_panel_driver = {
+	.probe		= apollon_panel_probe,
+	.remove		= apollon_panel_remove,
+	.suspend	= apollon_panel_suspend,
+	.resume		= apollon_panel_resume,
+	.driver		= {
+		.name	= "apollon_lcd",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init apollon_panel_drv_init(void)
+{
+	return platform_driver_register(&apollon_panel_driver);
+}
+
+static void __exit apollon_panel_drv_exit(void)
+{
+	platform_driver_unregister(&apollon_panel_driver);
+}
+
+module_init(apollon_panel_drv_init);
+module_exit(apollon_panel_drv_exit);
_

Patches currently in -mm which might be from kyungmin.park@samsung.com are

origin.patch
linux-next.patch
omapfb-add-support-for-the-apollon-lcd.patch

