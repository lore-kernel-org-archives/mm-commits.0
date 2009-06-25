From: akpm@linux-foundation.org
Subject: + omapfb-add-support-for-the-2430sdp-lcd.patch added to -mm tree
Date: Wed, 24 Jun 2009 17:07:42 -0700
Message-ID: <200906250007.n5P07gIO004482@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33736 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758505AbZFYAIe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jun 2009 20:08:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hyau@mvista.com, dbrownell@users.sourceforge.net, francisco.alecrim@indt.org.br, imre.deak@nokia.com, khilman@mvista.com, krzysztof.h1@wp.pl, saaguirre@ti.com, tony@atomide.com


The patch titled
     omapfb: add support for the 2430SDP LCD
has been added to the -mm tree.  Its filename is
     omapfb-add-support-for-the-2430sdp-lcd.patch

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
Subject: omapfb: add support for the 2430SDP LCD
From: Hunyue Yau <hyau@mvista.com>

Add glue to control the 2430SDP LCD as a frame buffer device using the
existing dispc.c driver under omapfb.

Fixed-by: Kevin Hilman <khilman@mvista.com>
Fixed-by: Sergio Aguirre <saaguirre@ti.com>
Fixed-by: Francisco Alecrim <francisco.alecrim@indt.org.br>
Fixed-by: Tony Lindgren <tony@atomide.com>
Fixed-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Hunyue Yau <hyau@mvista.com>
Signed-off-by: Kevin Hilman <khilman@mvista.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Imre Deak <imre.deak@nokia.com>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/omap/Makefile      |    1 
 drivers/video/omap/lcd_2430sdp.c |  198 +++++++++++++++++++++++++++++
 2 files changed, 199 insertions(+)

diff -puN drivers/video/omap/Makefile~omapfb-add-support-for-the-2430sdp-lcd drivers/video/omap/Makefile
--- a/drivers/video/omap/Makefile~omapfb-add-support-for-the-2430sdp-lcd
+++ a/drivers/video/omap/Makefile
@@ -26,6 +26,7 @@ objs-$(CONFIG_ARCH_OMAP15XX)$(CONFIG_MAC
 objs-y$(CONFIG_MACH_OMAP_OSK) += lcd_osk.o
 
 objs-y$(CONFIG_MACH_OMAP_APOLLON) += lcd_apollon.o
+objs-y$(CONFIG_MACH_OMAP_2430SDP) += lcd_2430sdp.o
 objs-y$(CONFIG_FB_OMAP_LCD_MIPID) += lcd_mipid.o
 
 omapfb-objs := $(objs-yy)
diff -puN /dev/null drivers/video/omap/lcd_2430sdp.c
--- /dev/null
+++ a/drivers/video/omap/lcd_2430sdp.c
@@ -0,0 +1,198 @@
+/*
+ * LCD panel support for the TI 2430SDP board
+ *
+ * Copyright (C) 2007 MontaVista
+ * Author: Hunyue Yau <hyau@mvista.com>
+ *
+ * Derived from drivers/video/omap/lcd-apollon.c
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
+#include <linux/delay.h>
+#include <linux/gpio.h>
+#include <linux/i2c/twl4030.h>
+
+#include <mach/mux.h>
+#include <mach/omapfb.h>
+#include <asm/mach-types.h>
+
+#define SDP2430_LCD_PANEL_BACKLIGHT_GPIO	91
+#define SDP2430_LCD_PANEL_ENABLE_GPIO		154
+#define SDP3430_LCD_PANEL_BACKLIGHT_GPIO	24
+#define SDP3430_LCD_PANEL_ENABLE_GPIO		28
+
+static unsigned backlight_gpio;
+static unsigned enable_gpio;
+
+#define LCD_PANEL_BACKLIGHT_GPIO	91
+#define LCD_PANEL_ENABLE_GPIO		154
+#define LCD_PIXCLOCK_MAX		5400 /* freq 5.4 MHz */
+#define PM_RECEIVER             TWL4030_MODULE_PM_RECEIVER
+#define ENABLE_VAUX2_DEDICATED  0x09
+#define ENABLE_VAUX2_DEV_GRP    0x20
+
+
+#define t2_out(c, r, v) twl4030_i2c_write_u8(c, r, v)
+
+
+static int sdp2430_panel_init(struct lcd_panel *panel,
+				struct omapfb_device *fbdev)
+{
+	if (machine_is_omap_3430sdp()) {
+		enable_gpio    = SDP3430_LCD_PANEL_ENABLE_GPIO;
+		backlight_gpio = SDP3430_LCD_PANEL_BACKLIGHT_GPIO;
+	} else {
+		enable_gpio    = SDP2430_LCD_PANEL_ENABLE_GPIO;
+		backlight_gpio = SDP2430_LCD_PANEL_BACKLIGHT_GPIO;
+	}
+
+	gpio_request(enable_gpio, "LCD enable");	/* LCD panel */
+	gpio_request(backlight_gpio, "LCD bl");		/* LCD backlight */
+	gpio_direction_output(enable_gpio, 0);
+	gpio_direction_output(backlight_gpio, 0);
+
+	return 0;
+}
+
+static void sdp2430_panel_cleanup(struct lcd_panel *panel)
+{
+	gpio_free(backlight_gpio);
+	gpio_free(enable_gpio);
+}
+
+static int sdp2430_panel_enable(struct lcd_panel *panel)
+{
+	u8 ded_val, ded_reg;
+	u8 grp_val, grp_reg;
+
+	if (machine_is_omap_3430sdp()) {
+		ded_reg = TWL4030_VAUX3_DEDICATED;
+		ded_val = ENABLE_VAUX3_DEDICATED;
+		grp_reg = TWL4030_VAUX3_DEV_GRP;
+		grp_val = ENABLE_VAUX3_DEV_GRP;
+
+		if (omap_rev() > OMAP3430_REV_ES1_0) {
+			t2_out(PM_RECEIVER, ENABLE_VPLL2_DEDICATED,
+					TWL4030_VPLL2_DEDICATED);
+			t2_out(PM_RECEIVER, ENABLE_VPLL2_DEV_GRP,
+					TWL4030_VPLL2_DEV_GRP);
+		}
+	} else {
+		ded_reg = TWL4030_VAUX2_DEDICATED;
+		ded_val = ENABLE_VAUX2_DEDICATED;
+		grp_reg = TWL4030_VAUX2_DEV_GRP;
+		grp_val = ENABLE_VAUX2_DEV_GRP;
+	}
+
+	gpio_set_value(enable_gpio, 1);
+	gpio_set_value(backlight_gpio, 1);
+
+	if (0 != t2_out(PM_RECEIVER, ded_val, ded_reg))
+		return -EIO;
+	if (0 != t2_out(PM_RECEIVER, grp_val, grp_reg))
+		return -EIO;
+
+	return 0;
+}
+
+static void sdp2430_panel_disable(struct lcd_panel *panel)
+{
+	gpio_set_value(enable_gpio, 0);
+	gpio_set_value(backlight_gpio, 0);
+	if (omap_rev() > OMAP3430_REV_ES1_0) {
+		t2_out(PM_RECEIVER, 0x0, TWL4030_VPLL2_DEDICATED);
+		t2_out(PM_RECEIVER, 0x0, TWL4030_VPLL2_DEV_GRP);
+		msleep(4);
+	}
+}
+
+static unsigned long sdp2430_panel_get_caps(struct lcd_panel *panel)
+{
+	return 0;
+}
+
+struct lcd_panel sdp2430_panel = {
+	.name		= "sdp2430",
+	.config		= OMAP_LCDC_PANEL_TFT | OMAP_LCDC_INV_VSYNC |
+			  OMAP_LCDC_INV_HSYNC,
+
+	.bpp		= 16,
+	.data_lines	= 16,
+	.x_res		= 240,
+	.y_res		= 320,
+	.hsw		= 3,		/* hsync_len (4) - 1 */
+	.hfp		= 3,		/* right_margin (4) - 1 */
+	.hbp		= 39,		/* left_margin (40) - 1 */
+	.vsw		= 1,		/* vsync_len (2) - 1 */
+	.vfp		= 2,		/* lower_margin */
+	.vbp		= 7,		/* upper_margin (8) - 1 */
+
+	.pixel_clock	= LCD_PIXCLOCK_MAX,
+
+	.init		= sdp2430_panel_init,
+	.cleanup	= sdp2430_panel_cleanup,
+	.enable	= sdp2430_panel_enable,
+	.disable	= sdp2430_panel_disable,
+	.get_caps	= sdp2430_panel_get_caps,
+};
+
+static int sdp2430_panel_probe(struct platform_device *pdev)
+{
+	omapfb_register_panel(&sdp2430_panel);
+	return 0;
+}
+
+static int sdp2430_panel_remove(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static int sdp2430_panel_suspend(struct platform_device *pdev,
+					pm_message_t mesg)
+{
+	return 0;
+}
+
+static int sdp2430_panel_resume(struct platform_device *pdev)
+{
+	return 0;
+}
+
+struct platform_driver sdp2430_panel_driver = {
+	.probe		= sdp2430_panel_probe,
+	.remove		= sdp2430_panel_remove,
+	.suspend		= sdp2430_panel_suspend,
+	.resume		= sdp2430_panel_resume,
+	.driver		= {
+		.name	= "sdp2430_lcd",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init sdp2430_panel_drv_init(void)
+{
+	return platform_driver_register(&sdp2430_panel_driver);
+}
+
+static void __exit sdp2430_panel_drv_exit(void)
+{
+	platform_driver_unregister(&sdp2430_panel_driver);
+}
+
+module_init(sdp2430_panel_drv_init);
+module_exit(sdp2430_panel_drv_exit);
_

Patches currently in -mm which might be from hyau@mvista.com are

origin.patch
omapfb-add-support-for-the-2430sdp-lcd.patch

