From: akpm@linux-foundation.org
Subject: + omapfb-add-support-for-the-3430sdp-lcd.patch added to -mm tree
Date: Wed, 24 Jun 2009 17:07:48 -0700
Message-ID: <200906250007.n5P07nCi004661@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38533 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755113AbZFYAIY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jun 2009 20:08:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khilman@mvista.com, imre.deak@nokia.com, khilman@mvsita.com, krzysztof.h1@wp.pl, tony@atomide.com


The patch titled
     omapfb: add support for the 3430SDP LCD
has been added to the -mm tree.  Its filename is
     omapfb-add-support-for-the-3430sdp-lcd.patch

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
Subject: omapfb: add support for the 3430SDP LCD
From: Kevin Hilman <khilman@mvista.com>

The 3430SDP uses the same panel as the 2430SDP.  The main difference are
in the GPIO lines used for panel enable and backlight, and the VAUX
register/commands sent to the TWL4030 power subsystem.

Also, some misc. whitespace cleanups.

Fixed-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Kevin Hilman <khilman@mvsita.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Imre Deak <imre.deak@nokia.com>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/configs/omap_3430sdp_defconfig |   39 ++++++++++++++++++++--
 drivers/video/omap/Makefile             |    2 +
 drivers/video/omap/lcd_2430sdp.c        |   12 ++++--
 3 files changed, 47 insertions(+), 6 deletions(-)

diff -puN arch/arm/configs/omap_3430sdp_defconfig~omapfb-add-support-for-the-3430sdp-lcd arch/arm/configs/omap_3430sdp_defconfig
--- a/arch/arm/configs/omap_3430sdp_defconfig~omapfb-add-support-for-the-3430sdp-lcd
+++ a/arch/arm/configs/omap_3430sdp_defconfig
@@ -1313,8 +1313,33 @@ CONFIG_DVB_ISL6421=m
 # Graphics support
 #
 # CONFIG_VGASTATE is not set
-# CONFIG_VIDEO_OUTPUT_CONTROL is not set
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
@@ -1331,6 +1356,16 @@ CONFIG_DISPLAY_SUPPORT=y
 #
 # CONFIG_VGA_CONSOLE is not set
 CONFIG_DUMMY_CONSOLE=y
+CONFIG_FRAMEBUFFER_CONSOLE=y
+# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
+# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
+# CONFIG_FONTS is not set
+CONFIG_FONT_8x8=y
+CONFIG_FONT_8x16=y
+CONFIG_LOGO=y
+CONFIG_LOGO_LINUX_MONO=y
+CONFIG_LOGO_LINUX_VGA16=y
+CONFIG_LOGO_LINUX_CLUT224=y
 CONFIG_SOUND=y
 CONFIG_SOUND_OSS_CORE=y
 CONFIG_SND=y
diff -puN drivers/video/omap/Makefile~omapfb-add-support-for-the-3430sdp-lcd drivers/video/omap/Makefile
--- a/drivers/video/omap/Makefile~omapfb-add-support-for-the-3430sdp-lcd
+++ a/drivers/video/omap/Makefile
@@ -8,6 +8,7 @@ objs-yy := omapfb_main.o
 
 objs-y$(CONFIG_ARCH_OMAP1) += lcdc.o
 objs-y$(CONFIG_ARCH_OMAP2) += dispc.o
+objs-y$(CONFIG_ARCH_OMAP3) += dispc.o
 
 objs-$(CONFIG_ARCH_OMAP1)$(CONFIG_FB_OMAP_LCDC_EXTERNAL) += sossi.o
 objs-$(CONFIG_ARCH_OMAP2)$(CONFIG_FB_OMAP_LCDC_EXTERNAL) += rfbi.o
@@ -27,6 +28,7 @@ objs-y$(CONFIG_MACH_OMAP_OSK) += lcd_osk
 
 objs-y$(CONFIG_MACH_OMAP_APOLLON) += lcd_apollon.o
 objs-y$(CONFIG_MACH_OMAP_2430SDP) += lcd_2430sdp.o
+objs-y$(CONFIG_MACH_OMAP_3430SDP) += lcd_2430sdp.o
 objs-y$(CONFIG_MACH_OMAP2EVM) += lcd_omap2evm.o
 objs-y$(CONFIG_FB_OMAP_LCD_MIPID) += lcd_mipid.o
 
diff -puN drivers/video/omap/lcd_2430sdp.c~omapfb-add-support-for-the-3430sdp-lcd drivers/video/omap/lcd_2430sdp.c
--- a/drivers/video/omap/lcd_2430sdp.c~omapfb-add-support-for-the-3430sdp-lcd
+++ a/drivers/video/omap/lcd_2430sdp.c
@@ -39,13 +39,17 @@
 static unsigned backlight_gpio;
 static unsigned enable_gpio;
 
-#define LCD_PANEL_BACKLIGHT_GPIO	91
-#define LCD_PANEL_ENABLE_GPIO		154
 #define LCD_PIXCLOCK_MAX		5400 /* freq 5.4 MHz */
 #define PM_RECEIVER             TWL4030_MODULE_PM_RECEIVER
 #define ENABLE_VAUX2_DEDICATED  0x09
 #define ENABLE_VAUX2_DEV_GRP    0x20
+#define ENABLE_VAUX3_DEDICATED	0x03
+#define ENABLE_VAUX3_DEV_GRP	0x20
 
+#define ENABLE_VPLL2_DEDICATED          0x05
+#define ENABLE_VPLL2_DEV_GRP            0xE0
+#define TWL4030_VPLL2_DEV_GRP           0x33
+#define TWL4030_VPLL2_DEDICATED         0x36
 
 #define t2_out(c, r, v) twl4030_i2c_write_u8(c, r, v)
 
@@ -146,7 +150,7 @@ struct lcd_panel sdp2430_panel = {
 
 	.init		= sdp2430_panel_init,
 	.cleanup	= sdp2430_panel_cleanup,
-	.enable	= sdp2430_panel_enable,
+	.enable		= sdp2430_panel_enable,
 	.disable	= sdp2430_panel_disable,
 	.get_caps	= sdp2430_panel_get_caps,
 };
@@ -176,7 +180,7 @@ static int sdp2430_panel_resume(struct p
 struct platform_driver sdp2430_panel_driver = {
 	.probe		= sdp2430_panel_probe,
 	.remove		= sdp2430_panel_remove,
-	.suspend		= sdp2430_panel_suspend,
+	.suspend	= sdp2430_panel_suspend,
 	.resume		= sdp2430_panel_resume,
 	.driver		= {
 		.name	= "sdp2430_lcd",
_

Patches currently in -mm which might be from khilman@mvista.com are

omapfb-add-support-for-the-2430sdp-lcd.patch
omapfb-add-support-for-the-3430sdp-lcd.patch

