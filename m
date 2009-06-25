From: akpm@linux-foundation.org
Subject: + omapfb-add-support-for-the-omap3-beagle-dvi-output.patch added to -mm tree
Date: Wed, 24 Jun 2009 17:07:54 -0700
Message-ID: <200906250007.n5P07sjr004673@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53538 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755346AbZFYALd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jun 2009 20:11:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: koen@openembedded.org, dbrownell@users.sourceforge.net, felipe.contreras@gmail.com, imre.deak@nokia.com, jarkko.nikula@gmail.com, krzysztof.h1@wp.pl, steve@sakoman.com, tony@atomide.com


The patch titled
     omapfb: add support for the OMAP3 Beagle DVI output
has been added to the -mm tree.  Its filename is
     omapfb-add-support-for-the-omap3-beagle-dvi-output.patch

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
Subject: omapfb: add support for the OMAP3 Beagle DVI output
From: Koen Kooi <koen@openembedded.org>

The default resolution is 1024x768@24bit

This version addresses the comments from Felipe Balbi adn Arun Edarath

Fixed-by: Felipe Contreras <felipe.contreras@gmail.com>
Fixed-by: Steve Sakoman <steve@sakoman.com>
Fixed-by: Jarkko Nikula <jarkko.nikula@gmail.com>
Fixed-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Koen Kooi <koen@openembedded.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Imre Deak <imre.deak@nokia.com>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/configs/omap3_beagle_defconfig |   47 +++++++
 drivers/video/omap/Makefile             |    1 
 drivers/video/omap/lcd_omap3beagle.c    |  130 ++++++++++++++++++++++
 3 files changed, 177 insertions(+), 1 deletion(-)

diff -puN arch/arm/configs/omap3_beagle_defconfig~omapfb-add-support-for-the-omap3-beagle-dvi-output arch/arm/configs/omap3_beagle_defconfig
--- a/arch/arm/configs/omap3_beagle_defconfig~omapfb-add-support-for-the-omap3-beagle-dvi-output
+++ a/arch/arm/configs/omap3_beagle_defconfig
@@ -769,7 +769,33 @@ CONFIG_DAB=y
 #
 # CONFIG_VGASTATE is not set
 # CONFIG_VIDEO_OUTPUT_CONTROL is not set
-# CONFIG_FB is not set
+CONFIG_FB=y
+# CONFIG_FIRMWARE_EDID is not set
+# CONFIG_FB_DDC is not set
+CONFIG_FB_CFB_FILLRECT=y
+CONFIG_FB_CFB_COPYAREA=y
+CONFIG_FB_CFB_IMAGEBLIT=y
+# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
+# CONFIG_FB_SYS_FILLRECT is not set
+# CONFIG_FB_SYS_COPYAREA is not set
+# CONFIG_FB_SYS_IMAGEBLIT is not set
+# CONFIG_FB_FOREIGN_ENDIAN is not set
+# CONFIG_FB_SYS_FOPS is not set
+# CONFIG_FB_SVGALIB is not set
+# CONFIG_FB_MACMODES is not set
+# CONFIG_FB_BACKLIGHT is not set
+# CONFIG_FB_MODE_HELPERS is not set
+# CONFIG_FB_TILEBLITTING is not set
+
+#
+# Frame buffer hardware drivers
+#
+# CONFIG_FB_S1D13XXX is not set
+# CONFIG_FB_VIRTUAL is not set
+CONFIG_FB_OMAP=y
+# CONFIG_FB_OMAP_LCDC_EXTERNAL is not set
+# CONFIG_FB_OMAP_BOOTLOADER_INIT is not set
+CONFIG_FB_OMAP_CONSISTENT_DMA_SIZE=2
 # CONFIG_BACKLIGHT_LCD_SUPPORT is not set
 
 #
@@ -782,6 +808,25 @@ CONFIG_DAB=y
 #
 # CONFIG_VGA_CONSOLE is not set
 CONFIG_DUMMY_CONSOLE=y
+CONFIG_FRAMEBUFFER_CONSOLE=y
+# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
+CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
+CONFIG_FONTS=y
+CONFIG_FONT_8x8=y
+CONFIG_FONT_8x16=y
+# CONFIG_FONT_6x11 is not set
+# CONFIG_FONT_7x14 is not set
+# CONFIG_FONT_PEARL_8x8 is not set
+# CONFIG_FONT_ACORN_8x8 is not set
+# CONFIG_FONT_MINI_4x6 is not set
+# CONFIG_FONT_SUN8x16 is not set
+# CONFIG_FONT_SUN12x22 is not set
+# CONFIG_FONT_10x18 is not set
+# CONFIG_LOGO is not set
+
+#
+# Sound
+#
 # CONFIG_SOUND is not set
 # CONFIG_HID_SUPPORT is not set
 CONFIG_USB_SUPPORT=y
diff -puN drivers/video/omap/Makefile~omapfb-add-support-for-the-omap3-beagle-dvi-output drivers/video/omap/Makefile
--- a/drivers/video/omap/Makefile~omapfb-add-support-for-the-omap3-beagle-dvi-output
+++ a/drivers/video/omap/Makefile
@@ -31,6 +31,7 @@ objs-y$(CONFIG_MACH_OMAP_2430SDP) += lcd
 objs-y$(CONFIG_MACH_OMAP_3430SDP) += lcd_2430sdp.o
 objs-y$(CONFIG_MACH_OMAP2EVM) += lcd_omap2evm.o
 objs-y$(CONFIG_MACH_OMAP3EVM) += lcd_omap3evm.o
+objs-y$(CONFIG_MACH_OMAP3_BEAGLE) += lcd_omap3beagle.o
 objs-y$(CONFIG_FB_OMAP_LCD_MIPID) += lcd_mipid.o
 
 omapfb-objs := $(objs-yy)
diff -puN /dev/null drivers/video/omap/lcd_omap3beagle.c
--- /dev/null
+++ a/drivers/video/omap/lcd_omap3beagle.c
@@ -0,0 +1,130 @@
+/*
+ * LCD panel support for the TI OMAP3 Beagle board
+ *
+ * Author: Koen Kooi <koen@openembedded.org>
+ *
+ * Derived from drivers/video/omap/lcd-omap3evm.c
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
+#include <linux/gpio.h>
+#include <linux/i2c/twl4030.h>
+
+#include <mach/mux.h>
+#include <mach/omapfb.h>
+#include <asm/mach-types.h>
+
+#define LCD_PANEL_ENABLE_GPIO       170
+
+static int omap3beagle_panel_init(struct lcd_panel *panel,
+				struct omapfb_device *fbdev)
+{
+	gpio_request(LCD_PANEL_ENABLE_GPIO, "LCD enable");
+	return 0;
+}
+
+static void omap3beagle_panel_cleanup(struct lcd_panel *panel)
+{
+	gpio_free(LCD_PANEL_ENABLE_GPIO);
+}
+
+static int omap3beagle_panel_enable(struct lcd_panel *panel)
+{
+	gpio_set_value(LCD_PANEL_ENABLE_GPIO, 1);
+	return 0;
+}
+
+static void omap3beagle_panel_disable(struct lcd_panel *panel)
+{
+	gpio_set_value(LCD_PANEL_ENABLE_GPIO, 0);
+}
+
+static unsigned long omap3beagle_panel_get_caps(struct lcd_panel *panel)
+{
+	return 0;
+}
+
+struct lcd_panel omap3beagle_panel = {
+	.name		= "omap3beagle",
+	.config		= OMAP_LCDC_PANEL_TFT,
+
+	.bpp		= 16,
+	.data_lines	= 24,
+	.x_res		= 1024,
+	.y_res		= 768,
+	.hsw		= 3,		/* hsync_len (4) - 1 */
+	.hfp		= 3,		/* right_margin (4) - 1 */
+	.hbp		= 39,		/* left_margin (40) - 1 */
+	.vsw		= 1,		/* vsync_len (2) - 1 */
+	.vfp		= 2,		/* lower_margin */
+	.vbp		= 7,		/* upper_margin (8) - 1 */
+
+	.pixel_clock	= 64000,
+
+	.init		= omap3beagle_panel_init,
+	.cleanup	= omap3beagle_panel_cleanup,
+	.enable		= omap3beagle_panel_enable,
+	.disable	= omap3beagle_panel_disable,
+	.get_caps	= omap3beagle_panel_get_caps,
+};
+
+static int omap3beagle_panel_probe(struct platform_device *pdev)
+{
+	omapfb_register_panel(&omap3beagle_panel);
+	return 0;
+}
+
+static int omap3beagle_panel_remove(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static int omap3beagle_panel_suspend(struct platform_device *pdev,
+				   pm_message_t mesg)
+{
+	return 0;
+}
+
+static int omap3beagle_panel_resume(struct platform_device *pdev)
+{
+	return 0;
+}
+
+struct platform_driver omap3beagle_panel_driver = {
+	.probe		= omap3beagle_panel_probe,
+	.remove		= omap3beagle_panel_remove,
+	.suspend	= omap3beagle_panel_suspend,
+	.resume		= omap3beagle_panel_resume,
+	.driver		= {
+		.name	= "omap3beagle_lcd",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init omap3beagle_panel_drv_init(void)
+{
+	return platform_driver_register(&omap3beagle_panel_driver);
+}
+
+static void __exit omap3beagle_panel_drv_exit(void)
+{
+	platform_driver_unregister(&omap3beagle_panel_driver);
+}
+
+module_init(omap3beagle_panel_drv_init);
+module_exit(omap3beagle_panel_drv_exit);
_

Patches currently in -mm which might be from koen@openembedded.org are

omapfb-add-support-for-the-omap3-beagle-dvi-output.patch

