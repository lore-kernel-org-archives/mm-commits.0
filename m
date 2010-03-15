From: akpm@linux-foundation.org
Subject: [merged] nuc900-lcd-controller-driver.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:57:06 -0400
Message-ID: <201003150657.o2F6vd2a016388@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60629 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756997Ab0COG5w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:57:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rurality.linux@gmail.com, krzysztof.h1@poczta.fm, mcuos.com@gmail.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     NUC900 LCD Controller Driver
has been removed from the -mm tree.  Its filename was
     nuc900-lcd-controller-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: NUC900 LCD Controller Driver
From: Wang Qiang <rurality.linux@gmail.com>

An LCD controller driver for nuc900s.  The Linux LOGO is just fine and the
FB-Test application was ok, too.

Signed-off-by: Wang Qiang <rurality.linux@gmail.com>
Cc: Wang Zongshun <mcuos.com@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/configs/nuc950_defconfig             |   53 +
 arch/arm/mach-w90x900/cpu.h                   |    1 
 arch/arm/mach-w90x900/dev.c                   |   42 
 arch/arm/mach-w90x900/include/mach/fb.h       |   83 +
 arch/arm/mach-w90x900/include/mach/regs-ldm.h |  253 +++++
 arch/arm/mach-w90x900/mach-nuc950evb.c        |   47 
 arch/arm/mach-w90x900/nuc950.c                |    4 
 drivers/video/Kconfig                         |   21 
 drivers/video/Makefile                        |    1 
 drivers/video/nuc900fb.c                      |  779 ++++++++++++++++
 drivers/video/nuc900fb.h                      |   55 +
 11 files changed, 1338 insertions(+), 1 deletion(-)

diff -puN arch/arm/configs/nuc950_defconfig~nuc900-lcd-controller-driver arch/arm/configs/nuc950_defconfig
--- a/arch/arm/configs/nuc950_defconfig~nuc900-lcd-controller-driver
+++ a/arch/arm/configs/nuc950_defconfig
@@ -590,8 +590,40 @@ CONFIG_SSB_POSSIBLE=y
 #
 # CONFIG_VGASTATE is not set
 # CONFIG_VIDEO_OUTPUT_CONTROL is not set
-# CONFIG_FB is not set
 # CONFIG_BACKLIGHT_LCD_SUPPORT is not set
+CONFIG_FB=y
+# CONFIG_FIRMWARE_EDID is not set
+# CONFIG_FB_DDC is not set
+# CONFIG_FB_BOOT_VESA_SUPPORT is not set
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
+CONFIG_FB_NUC900=y
+CONFIG_GPM1040A0_320X240=y
+CONFIG_FB_NUC900_DEBUG=y
+# CONFIG_FB_VIRTUAL is not set
+# CONFIG_FB_METRONOME is not set
+# CONFIG_FB_MB862XX is not set
+# CONFIG_FB_BROADSHEET is not set
+# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
+
+
 
 #
 # Display device support
@@ -603,6 +635,25 @@ CONFIG_SSB_POSSIBLE=y
 #
 # CONFIG_VGA_CONSOLE is not set
 CONFIG_DUMMY_CONSOLE=y
+CONFIG_FRAMEBUFFER_CONSOLE=y
+CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
+# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
+CONFIG_FONTS=y
+# CONFIG_FONT_8x8 is not set
+CONFIG_FONT_8x16=y
+# CONFIG_FONT_6x11 is not set
+# CONFIG_FONT_7x14 is not set
+# CONFIG_FONT_PEARL_8x8 is not set
+# CONFIG_FONT_ACORN_8x8 is not set
+# CONFIG_FONT_MINI_4x6 is not set
+# CONFIG_FONT_SUN8x16 is not set
+# CONFIG_FONT_SUN12x22 is not set
+# CONFIG_FONT_10x18 is not set
+CONFIG_LOGO=y
+# CONFIG_LOGO_LINUX_MONO is not set
+# CONFIG_LOGO_LINUX_VGA16 is not set
+CONFIG_LOGO_LINUX_CLUT224=y
+
 # CONFIG_SOUND is not set
 # CONFIG_HID_SUPPORT is not set
 CONFIG_USB_SUPPORT=y
diff -puN arch/arm/mach-w90x900/cpu.h~nuc900-lcd-controller-driver arch/arm/mach-w90x900/cpu.h
--- a/arch/arm/mach-w90x900/cpu.h~nuc900-lcd-controller-driver
+++ a/arch/arm/mach-w90x900/cpu.h
@@ -57,3 +57,4 @@ extern struct platform_device nuc900_dev
 extern struct platform_device nuc900_device_kpi;
 extern struct platform_device nuc900_device_rtc;
 extern struct platform_device nuc900_device_ts;
+extern struct platform_device nuc900_device_lcd;
diff -puN arch/arm/mach-w90x900/dev.c~nuc900-lcd-controller-driver arch/arm/mach-w90x900/dev.c
--- a/arch/arm/mach-w90x900/dev.c~nuc900-lcd-controller-driver
+++ a/arch/arm/mach-w90x900/dev.c
@@ -34,6 +34,7 @@
 #include <mach/regs-serial.h>
 #include <mach/nuc900_spi.h>
 #include <mach/map.h>
+#include <mach/fb.h>
 
 #include "cpu.h"
 
@@ -380,6 +381,47 @@ struct platform_device nuc900_device_kpi
 	.resource	= nuc900_kpi_resource,
 };
 
+#ifdef CONFIG_FB_NUC900
+
+static struct resource nuc900_lcd_resource[] = {
+	[0] = {
+		.start = W90X900_PA_LCD,
+		.end   = W90X900_PA_LCD + W90X900_SZ_LCD - 1,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = IRQ_LCD,
+		.end   = IRQ_LCD,
+		.flags = IORESOURCE_IRQ,
+	}
+};
+
+static u64 nuc900_device_lcd_dmamask = -1;
+struct platform_device nuc900_device_lcd = {
+	.name             = "nuc900-lcd",
+	.id               = -1,
+	.num_resources    = ARRAY_SIZE(nuc900_lcd_resource),
+	.resource         = nuc900_lcd_resource,
+	.dev              = {
+		.dma_mask               = &nuc900_device_lcd_dmamask,
+		.coherent_dma_mask      = -1,
+	}
+};
+
+void  nuc900_fb_set_platdata(struct nuc900fb_mach_info *pd)
+{
+	struct nuc900fb_mach_info *npd;
+
+	npd = kmalloc(sizeof(*npd), GFP_KERNEL);
+	if (npd) {
+		memcpy(npd, pd, sizeof(*npd));
+		nuc900_device_lcd.dev.platform_data = npd;
+	} else {
+		printk(KERN_ERR "no memory for LCD platform data\n");
+	}
+}
+#endif
+
 /*Here should be your evb resourse,such as LCD*/
 
 static struct platform_device *nuc900_public_dev[] __initdata = {
diff -puN /dev/null arch/arm/mach-w90x900/include/mach/fb.h
--- /dev/null
+++ a/arch/arm/mach-w90x900/include/mach/fb.h
@@ -0,0 +1,83 @@
+/* linux/include/asm/arch-nuc900/fb.h
+ *
+ * Copyright (c) 2008 Nuvoton technology corporation
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * Changelog:
+ *
+ *   2008/08/26     vincen.zswan modify this file for LCD.
+ */
+
+#ifndef __ASM_ARM_FB_H
+#define __ASM_ARM_FB_H
+
+
+
+/* LCD Controller Hardware Desc */
+struct nuc900fb_hw {
+	unsigned int lcd_dccs;
+	unsigned int lcd_device_ctrl;
+	unsigned int lcd_mpulcd_cmd;
+	unsigned int lcd_int_cs;
+	unsigned int lcd_crtc_size;
+	unsigned int lcd_crtc_dend;
+	unsigned int lcd_crtc_hr;
+	unsigned int lcd_crtc_hsync;
+	unsigned int lcd_crtc_vr;
+	unsigned int lcd_va_baddr0;
+	unsigned int lcd_va_baddr1;
+	unsigned int lcd_va_fbctrl;
+	unsigned int lcd_va_scale;
+	unsigned int lcd_va_test;
+	unsigned int lcd_va_win;
+	unsigned int lcd_va_stuff;
+};
+
+/* LCD Display Description */
+struct nuc900fb_display {
+	/* LCD Image type */
+	unsigned type;
+
+	/* LCD Screen Size */
+	unsigned short width;
+	unsigned short height;
+
+	/* LCD Screen Info */
+	unsigned short xres;
+	unsigned short yres;
+	unsigned short bpp;
+
+	unsigned long pixclock;
+	unsigned short left_margin;
+	unsigned short right_margin;
+	unsigned short hsync_len;
+	unsigned short upper_margin;
+	unsigned short lower_margin;
+	unsigned short vsync_len;
+
+	/* hardware special register value */
+	unsigned int dccs;
+	unsigned int devctl;
+	unsigned int fbctrl;
+	unsigned int scale;
+};
+
+struct nuc900fb_mach_info {
+	struct nuc900fb_display *displays;
+	unsigned num_displays;
+	unsigned default_display;
+	/* GPIO Setting  Info */
+	unsigned gpio_dir;
+	unsigned gpio_dir_mask;
+	unsigned gpio_data;
+	unsigned gpio_data_mask;
+};
+
+extern void __init nuc900_fb_set_platdata(struct nuc900fb_mach_info *);
+
+#endif /* __ASM_ARM_FB_H */
diff -puN /dev/null arch/arm/mach-w90x900/include/mach/regs-ldm.h
--- /dev/null
+++ a/arch/arm/mach-w90x900/include/mach/regs-ldm.h
@@ -0,0 +1,253 @@
+/*
+ * arch/arm/mach-w90x900/include/mach/regs-serial.h
+ *
+ * Copyright (c) 2009 Nuvoton technology corporation
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ *  Description:
+ *     Nuvoton Display, LCM Register list
+ *  Author:  Wang Qiang (rurality.linux@gmail.com) 2009/12/11
+ *
+ */
+
+
+#ifndef __ASM_ARM_W90X900_REGS_LDM_H
+#define __ASM_ARM_W90X900_REGS_LDM_H
+
+#include <mach/map.h>
+
+/* Display Controller Control/Status Register */
+#define REG_LCM_DCCS			(0x00)
+
+#define LCM_DCCS_ENG_RST		(1 << 0)
+#define LCM_DCCS_VA_EN			(1 << 1)
+#define LCM_DCCS_OSD_EN			(1 << 2)
+#define LCM_DCCS_DISP_OUT_EN		(1 << 3)
+#define LCM_DCCS_DISP_INT_EN		(1 << 4)
+#define LCM_DCCS_CMD_ON			(1 << 5)
+#define LCM_DCCS_FIELD_INTR		(1 << 6)
+#define LCM_DCCS_SINGLE			(1 << 7)
+
+enum LCM_DCCS_VA_SRC {
+	LCM_DCCS_VA_SRC_YUV422		= (0 << 8),
+	LCM_DCCS_VA_SRC_YCBCR422	= (1 << 8),
+	LCM_DCCS_VA_SRC_RGB888		= (2 << 8),
+	LCM_DCCS_VA_SRC_RGB666		= (3 << 8),
+	LCM_DCCS_VA_SRC_RGB565		= (4 << 8),
+	LCM_DCCS_VA_SRC_RGB444LOW	= (5 << 8),
+	LCM_DCCS_VA_SRC_RGB444HIGH 	= (7 << 8)
+};
+
+
+/* Display Device Control Register */
+#define REG_LCM_DEV_CTRL		(0x04)
+
+enum LCM_DEV_CTRL_SWAP_YCbCr {
+	LCM_DEV_CTRL_SWAP_UYVY		= (0 << 1),
+	LCM_DEV_CTRL_SWAP_YUYV		= (1 << 1),
+	LCM_DEV_CTRL_SWAP_VYUY		= (2 << 1),
+	LCM_DEV_CTRL_SWAP_YVYU		= (3 << 1)
+};
+
+enum LCM_DEV_CTRL_RGB_SHIFT {
+	LCM_DEV_CTRL_RGB_SHIFT_NOT 	= (0 << 3),
+	LCM_DEV_CTRL_RGB_SHIFT_ONECYCLE = (1 << 3),
+	LCM_DEV_CTRL_RGB_SHIFT_TWOCYCLE = (2 << 3),
+	LCM_DEV_CTRL_RGB_SHIFT_NOT_DEF	= (3 << 3)
+};
+
+enum LCM_DEV_CTRL_DEVICE {
+	LCM_DEV_CTRL_DEVICE_YUV422	= (0 << 5),
+	LCM_DEV_CTRL_DEVICE_YUV444	= (1 << 5),
+	LCM_DEV_CTRL_DEVICE_UNIPAC	= (4 << 5),
+	LCM_DEV_CTRL_DEVICE_SEIKO_EPSON	= (5 << 5),
+	LCM_DEV_CTRL_DEVICE_HIGH_COLOR	= (6 << 5),
+	LCM_DEV_CTRL_DEVICE_MPU		= (7 << 5)
+};
+
+#define LCM_DEV_CTRL_LCD_DDA		(8)
+#define LCM_DEV_CTRL_YUV2CCIR		(16)
+
+enum LCM_DEV_CTRL_LCD_SEL {
+	LCM_DEV_CTRL_LCD_SEL_RGB_GBR	= (0 << 17),
+	LCM_DEV_CTRL_LCD_SEL_BGR_RBG	= (1 << 17),
+	LCM_DEV_CTRL_LCD_SEL_GBR_RGB	= (2 << 17),
+	LCM_DEV_CTRL_LCD_SEL_RBG_BGR	= (3 << 17)
+};
+
+enum LCM_DEV_CTRL_FAL_D {
+	LCM_DEV_CTRL_FAL_D_FALLING	= (0 << 19),
+	LCM_DEV_CTRL_FAL_D_RISING	= (1 << 19),
+};
+
+enum LCM_DEV_CTRL_H_POL {
+	LCM_DEV_CTRL_H_POL_LOW		= (0 << 20),
+	LCM_DEV_CTRL_H_POL_HIGH		= (1 << 20),
+};
+
+enum LCM_DEV_CTRL_V_POL {
+	LCM_DEV_CTRL_V_POL_LOW		= (0 << 21),
+	LCM_DEV_CTRL_V_POL_HIGH		= (1 << 21),
+};
+
+enum LCM_DEV_CTRL_VR_LACE {
+	LCM_DEV_CTRL_VR_LACE_NINTERLACE	= (0 << 22),
+	LCM_DEV_CTRL_VR_LACE_INTERLACE	= (1 << 22),
+};
+
+enum LCM_DEV_CTRL_LACE {
+	LCM_DEV_CTRL_LACE_NINTERLACE	= (0 << 23),
+	LCM_DEV_CTRL_LACE_INTERLACE	= (1 << 23),
+};
+
+enum LCM_DEV_CTRL_RGB_SCALE {
+	LCM_DEV_CTRL_RGB_SCALE_4096 	= (0 << 24),
+	LCM_DEV_CTRL_RGB_SCALE_65536 	= (1 << 24),
+	LCM_DEV_CTRL_RGB_SCALE_262144 	= (2 << 24),
+	LCM_DEV_CTRL_RGB_SCALE_16777216 = (3 << 24),
+};
+
+enum LCM_DEV_CTRL_DBWORD {
+	LCM_DEV_CTRL_DBWORD_HALFWORD	= (0 << 26),
+	LCM_DEV_CTRL_DBWORD_FULLWORD	= (1 << 26),
+};
+
+enum LCM_DEV_CTRL_MPU68 {
+	LCM_DEV_CTRL_MPU68_80_SERIES	= (0 << 27),
+	LCM_DEV_CTRL_MPU68_68_SERIES	= (1 << 27),
+};
+
+enum LCM_DEV_CTRL_DE_POL {
+	LCM_DEV_CTRL_DE_POL_HIGH	= (0 << 28),
+	LCM_DEV_CTRL_DE_POL_LOW		= (1 << 28),
+};
+
+#define LCM_DEV_CTRL_CMD16		(29)
+#define LCM_DEV_CTRL_CM16t18		(30)
+#define LCM_DEV_CTRL_CMD_LOW		(31)
+
+/* MPU-Interface LCD Write Command */
+#define REG_LCM_MPU_CMD			(0x08)
+
+/* Interrupt Control/Status Register */
+#define REG_LCM_INT_CS			(0x0c)
+#define LCM_INT_CS_DISP_F_EN		(1 << 0)
+#define LCM_INT_CS_UNDERRUN_EN   	(1 << 1)
+#define LCM_INT_CS_BUS_ERROR_INT 	(1 << 28)
+#define LCM_INT_CS_UNDERRUN_INT  	(1 << 29)
+#define LCM_INT_CS_DISP_F_STATUS 	(1 << 30)
+#define LCM_INT_CS_DISP_F_INT		(1 << 31)
+
+/* CRTC Display Size Control Register */
+#define REG_LCM_CRTC_SIZE		(0x10)
+#define LCM_CRTC_SIZE_VTTVAL(x)		((x) << 16)
+#define LCM_CRTC_SIZE_HTTVAL(x)		((x) << 0)
+
+/* CRTC Display Enable End */
+#define REG_LCM_CRTC_DEND		(0x14)
+#define LCM_CRTC_DEND_VDENDVAL(x)	((x) << 16)
+#define LCM_CRTC_DEND_HDENDVAL(x)	((x) << 0)
+
+/* CRTC Internal Horizontal Retrace Control Register */
+#define REG_LCM_CRTC_HR			(0x18)
+#define LCM_CRTC_HR_EVAL(x)		((x) << 16)
+#define LCM_CRTC_HR_SVAL(x)		((x) << 0)
+
+/* CRTC Horizontal Sync Control Register */
+#define REG_LCM_CRTC_HSYNC		(0x1C)
+#define LCM_CRTC_HSYNC_SHIFTVAL(x)	((x) << 30)
+#define LCM_CRTC_HSYNC_EVAL(x)		((x) << 16)
+#define LCM_CRTC_HSYNC_SVAL(x)		((x) << 0)
+
+/* CRTC Internal Vertical Retrace Control Register */
+#define REG_LCM_CRTC_VR			(0x20)
+#define LCM_CRTC_VR_EVAL(x)		((x) << 16)
+#define LCM_CRTC_VR_SVAL(x)		((x) << 0)
+
+/* Video Stream Frame Buffer-0 Starting Address */
+#define REG_LCM_VA_BADDR0		(0x24)
+
+/* Video Stream Frame Buffer-1 Starting Address */
+#define REG_LCM_VA_BADDR1		(0x28)
+
+/* Video Stream Frame Buffer Control Register */
+#define REG_LCM_VA_FBCTRL		(0x2C)
+#define LCM_VA_FBCTRL_IO_REGION_HALF	(1 << 28)
+#define LCM_VA_FBCTRL_FIELD_DUAL  	(1 << 29)
+#define LCM_VA_FBCTRL_START_BUF 	(1 << 30)
+#define LCM_VA_FBCTRL_DB_EN		(1 << 31)
+
+/* Video Stream Scaling Control Register */
+#define REG_LCM_VA_SCALE		(0x30)
+#define LCM_VA_SCALE_XCOPY_INTERPOLATION (0 << 15)
+#define LCM_VA_SCALE_XCOPY_DUPLICATION	 (1 << 15)
+
+/* Image Stream Active Window Coordinates */
+#define REG_LCM_VA_WIN			(0x38)
+
+/* Image Stream Stuff Pixel */
+#define REG_LCM_VA_STUFF		(0x3C)
+
+/* OSD Window Starting Coordinates */
+#define REG_LCM_OSD_WINS		(0x40)
+
+/* OSD Window Ending Coordinates */
+#define REG_LCM_OSD_WINE		(0x44)
+
+/* OSD Stream Frame Buffer Starting Address */
+#define REG_LCM_OSD_BADDR		(0x48)
+
+/* OSD Stream Frame Buffer Control Register */
+#define REG_LCM_OSD_FBCTRL		(0x4c)
+
+/* OSD Overlay Control Register */
+#define REG_LCM_OSD_OVERLAY		(0x50)
+
+/* OSD Overlay Color-Key Pattern Register */
+#define REG_LCM_OSD_CKEY		(0x54)
+
+/* OSD Overlay Color-Key Mask Register */
+#define REG_LCM_OSD_CMASK		(0x58)
+
+/* OSD Window Skip1 Register */
+#define REG_LCM_OSD_SKIP1		(0x5C)
+
+/* OSD Window Skip2 Register */
+#define REG_LCM_OSD_SKIP2		(0x60)
+
+/* OSD horizontal up scaling control register */
+#define REG_LCM_OSD_SCALE		(0x64)
+
+/* MPU Vsync control register */
+#define REG_LCM_MPU_VSYNC		(0x68)
+
+/* Hardware cursor control Register */
+#define REG_LCM_HC_CTRL			(0x6C)
+
+/* Hardware cursot tip point potison on va picture */
+#define REG_LCM_HC_POS			(0x70)
+
+/* Hardware Cursor Window Buffer Control Register */
+#define REG_LCM_HC_WBCTRL		(0x74)
+
+/* Hardware cursor memory base address register */
+#define REG_LCM_HC_BADDR		(0x78)
+
+/* Hardware cursor color ram register mapped to bpp = 0 */
+#define REG_LCM_HC_COLOR0		(0x7C)
+
+/* Hardware cursor color ram register mapped to bpp = 1 */
+#define REG_LCM_HC_COLOR1		(0x80)
+
+/* Hardware cursor color ram register mapped to bpp = 2 */
+#define REG_LCM_HC_COLOR2		(0x84)
+
+/* Hardware cursor color ram register mapped to bpp = 3 */
+#define REG_LCM_HC_COLOR3		(0x88)
+
+#endif /* __ASM_ARM_W90X900_REGS_LDM_H */
diff -puN arch/arm/mach-w90x900/mach-nuc950evb.c~nuc900-lcd-controller-driver arch/arm/mach-w90x900/mach-nuc950evb.c
--- a/arch/arm/mach-w90x900/mach-nuc950evb.c~nuc900-lcd-controller-driver
+++ a/arch/arm/mach-w90x900/mach-nuc950evb.c
@@ -10,6 +10,8 @@
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as
  * published by the Free Software Foundation;version 2 of the License.
+ *   history:
+ *     Wang Qiang (rurality.linux@gmail.com) add LCD support
  *
  */
 
@@ -18,9 +20,51 @@
 #include <asm/mach/map.h>
 #include <asm/mach-types.h>
 #include <mach/map.h>
+#include <mach/regs-ldm.h>
+#include <mach/fb.h>
 
 #include "nuc950.h"
 
+#ifdef CONFIG_FB_NUC900
+/* LCD Controller */
+static struct nuc900fb_display __initdata nuc950_lcd_info[] = {
+	/* Giantplus Technology GPM1040A0 320x240 Color TFT LCD */
+	[0] = {
+		.type		= LCM_DCCS_VA_SRC_RGB565,
+		.width 		= 320,
+		.height		= 240,
+		.xres		= 320,
+		.yres		= 240,
+		.bpp		= 16,
+		.pixclock	= 200000,
+		.left_margin	= 34,
+		.right_margin   = 54,
+		.hsync_len	= 10,
+		.upper_margin	= 18,
+		.lower_margin	= 4,
+		.vsync_len	= 1,
+		.dccs		= 0x8e00041a,
+		.devctl		= 0x060800c0,
+		.fbctrl		= 0x00a000a0,
+		.scale		= 0x04000400,
+	},
+};
+
+static struct nuc900fb_mach_info nuc950_fb_info __initdata = {
+#if defined(CONFIG_GPM1040A0_320X240)
+	.displays		= &nuc950_lcd_info[0],
+#else
+	.displays		= nuc950_lcd_info,
+#endif
+	.num_displays 		= ARRAY_SIZE(nuc950_lcd_info),
+	.default_display	= 0,
+	.gpio_dir		= 0x00000004,
+	.gpio_dir_mask		= 0xFFFFFFFD,
+	.gpio_data		= 0x00000004,
+	.gpio_data_mask		= 0xFFFFFFFD,
+};
+#endif
+
 static void __init nuc950evb_map_io(void)
 {
 	nuc950_map_io();
@@ -30,6 +74,9 @@ static void __init nuc950evb_map_io(void
 static void __init nuc950evb_init(void)
 {
 	nuc950_board_init();
+#ifdef CONFIG_FB_NUC900
+	nuc900_fb_set_platdata(&nuc950_fb_info);
+#endif
 }
 
 MACHINE_START(W90P950EVB, "W90P950EVB")
diff -puN arch/arm/mach-w90x900/nuc950.c~nuc900-lcd-controller-driver arch/arm/mach-w90x900/nuc950.c
--- a/arch/arm/mach-w90x900/nuc950.c~nuc900-lcd-controller-driver
+++ a/arch/arm/mach-w90x900/nuc950.c
@@ -18,6 +18,7 @@
 #include <linux/platform_device.h>
 #include <asm/mach/map.h>
 #include <mach/hardware.h>
+
 #include "cpu.h"
 
 /* define specific CPU platform device */
@@ -25,6 +26,9 @@
 static struct platform_device *nuc950_dev[] __initdata = {
 	&nuc900_device_kpi,
 	&nuc900_device_fmi,
+#ifdef CONFIG_FB_NUC900
+	&nuc900_device_lcd,
+#endif
 };
 
 /* define specific CPU platform io map */
diff -puN drivers/video/Kconfig~nuc900-lcd-controller-driver drivers/video/Kconfig
--- a/drivers/video/Kconfig~nuc900-lcd-controller-driver
+++ a/drivers/video/Kconfig
@@ -1944,6 +1944,27 @@ config FB_S3C2410_DEBUG
 	  Turn on debugging messages. Note that you can set/unset at run time
 	  through sysfs
 
+config FB_NUC900
+        bool "NUC900 LCD framebuffer support"
+        depends on FB && ARCH_W90X900
+        select FB_CFB_FILLRECT
+        select FB_CFB_COPYAREA
+        select FB_CFB_IMAGEBLIT
+        ---help---
+          Frame buffer driver for the built-in LCD controller in the Nuvoton
+          NUC900 processor
+
+config GPM1040A0_320X240
+        bool "Giantplus Technology GPM1040A0 320x240 Color TFT LCD"
+        depends on FB_NUC900
+
+config FB_NUC900_DEBUG
+        bool "NUC900 lcd debug messages"
+        depends on FB_NUC900
+        help
+          Turn on debugging messages. Note that you can set/unset at run time
+          through sysfs
+
 config FB_SM501
 	tristate "Silicon Motion SM501 framebuffer support"
 	depends on FB && MFD_SM501
diff -puN drivers/video/Makefile~nuc900-lcd-controller-driver drivers/video/Makefile
--- a/drivers/video/Makefile~nuc900-lcd-controller-driver
+++ a/drivers/video/Makefile
@@ -129,6 +129,7 @@ obj-$(CONFIG_XEN_FBDEV_FRONTEND)  += xen
 obj-$(CONFIG_FB_CARMINE)          += carminefb.o
 obj-$(CONFIG_FB_MB862XX)	  += mb862xx/
 obj-$(CONFIG_FB_MSM)              += msm/
+obj-$(CONFIG_FB_NUC900)           += nuc900fb.o
 
 # Platform or fallback drivers go here
 obj-$(CONFIG_FB_UVESA)            += uvesafb.o
diff -puN /dev/null drivers/video/nuc900fb.c
--- /dev/null
+++ a/drivers/video/nuc900fb.c
@@ -0,0 +1,779 @@
+/*
+ *
+ * Copyright (c) 2009 Nuvoton technology corporation
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ *  Description:
+ *    Nuvoton LCD Controller Driver
+ *  Author:
+ *    Wang Qiang (rurality.linux@gmail.com) 2009/12/11
+ */
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/mm.h>
+#include <linux/tty.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/fb.h>
+#include <linux/init.h>
+#include <linux/dma-mapping.h>
+#include <linux/interrupt.h>
+#include <linux/workqueue.h>
+#include <linux/wait.h>
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+#include <linux/cpufreq.h>
+#include <linux/io.h>
+#include <linux/pm.h>
+#include <linux/device.h>
+
+#include <mach/map.h>
+#include <mach/regs-clock.h>
+#include <mach/regs-ldm.h>
+#include <mach/fb.h>
+#include <mach/clkdev.h>
+
+#include "nuc900fb.h"
+
+
+/*
+ *  Initialize the nuc900 video (dual) buffer address
+ */
+static void nuc900fb_set_lcdaddr(struct fb_info *info)
+{
+	struct nuc900fb_info *fbi = info->par;
+	void __iomem *regs = fbi->io;
+	unsigned long vbaddr1, vbaddr2;
+
+	vbaddr1  = info->fix.smem_start;
+	vbaddr2  = info->fix.smem_start;
+	vbaddr2 += info->fix.line_length * info->var.yres;
+
+	/* set frambuffer start phy addr*/
+	writel(vbaddr1, regs + REG_LCM_VA_BADDR0);
+	writel(vbaddr2, regs + REG_LCM_VA_BADDR1);
+
+	writel(fbi->regs.lcd_va_fbctrl, regs + REG_LCM_VA_FBCTRL);
+	writel(fbi->regs.lcd_va_scale, regs + REG_LCM_VA_SCALE);
+}
+
+/*
+ *	calculate divider for lcd div
+ */
+static unsigned int nuc900fb_calc_pixclk(struct nuc900fb_info *fbi,
+					 unsigned long pixclk)
+{
+	unsigned long clk = fbi->clk_rate;
+	unsigned long long div;
+
+	/* pixclk is in picseconds. our clock is in Hz*/
+	/* div = (clk * pixclk)/10^12 */
+	div = (unsigned long long)clk * pixclk;
+	div >>= 12;
+	do_div(div, 625 * 625UL * 625);
+
+	dev_dbg(fbi->dev, "pixclk %ld, divisor is %lld\n", pixclk, div);
+
+	return div;
+}
+
+/*
+ *	Check the video params of 'var'.
+ */
+static int nuc900fb_check_var(struct fb_var_screeninfo *var,
+			       struct fb_info *info)
+{
+	struct nuc900fb_info *fbi = info->par;
+	struct nuc900fb_mach_info *mach_info = fbi->dev->platform_data;
+	struct nuc900fb_display *display = NULL;
+	struct nuc900fb_display *default_display = mach_info->displays +
+						   mach_info->default_display;
+	int i;
+
+	dev_dbg(fbi->dev, "check_var(var=%p, info=%p)\n", var, info);
+
+	/* validate x/y resolution */
+	/* choose default mode if possible */
+	if (var->xres == default_display->xres &&
+	    var->yres == default_display->yres &&
+	    var->bits_per_pixel == default_display->bpp)
+		display = default_display;
+	else
+		for (i = 0; i < mach_info->num_displays; i++)
+			if (var->xres == mach_info->displays[i].xres &&
+			    var->yres == mach_info->displays[i].yres &&
+			    var->bits_per_pixel == mach_info->displays[i].bpp) {
+				display = mach_info->displays + i;
+				break;
+			}
+
+	if (display == NULL) {
+		printk(KERN_ERR "wrong resolution or depth %dx%d at %d bit per pixel\n",
+			var->xres, var->yres, var->bits_per_pixel);
+		return -EINVAL;
+	}
+
+	/* it should be the same size as the display */
+	var->xres_virtual	= display->xres;
+	var->yres_virtual	= display->yres;
+	var->height		= display->height;
+	var->width		= display->width;
+
+	/* copy lcd settings */
+	var->pixclock		= display->pixclock;
+	var->left_margin	= display->left_margin;
+	var->right_margin	= display->right_margin;
+	var->upper_margin	= display->upper_margin;
+	var->lower_margin	= display->lower_margin;
+	var->vsync_len		= display->vsync_len;
+	var->hsync_len		= display->hsync_len;
+
+	var->transp.offset	= 0;
+	var->transp.length	= 0;
+
+	fbi->regs.lcd_dccs = display->dccs;
+	fbi->regs.lcd_device_ctrl = display->devctl;
+	fbi->regs.lcd_va_fbctrl = display->fbctrl;
+	fbi->regs.lcd_va_scale = display->scale;
+
+	/* set R/G/B possions */
+	switch (var->bits_per_pixel) {
+	case 1:
+	case 2:
+	case 4:
+	case 8:
+	default:
+		var->red.offset 	= 0;
+		var->red.length 	= var->bits_per_pixel;
+		var->green 		= var->red;
+		var->blue		= var->red;
+		break;
+	case 12:
+		var->red.length		= 4;
+		var->green.length	= 4;
+		var->blue.length	= 4;
+		var->red.offset		= 8;
+		var->green.offset	= 4;
+		var->blue.offset	= 0;
+		break;
+	case 16:
+		var->red.length		= 5;
+		var->green.length	= 6;
+		var->blue.length	= 5;
+		var->red.offset		= 11;
+		var->green.offset	= 5;
+		var->blue.offset	= 0;
+		break;
+	case 18:
+		var->red.length		= 6;
+		var->green.length	= 6;
+		var->blue.length	= 6;
+		var->red.offset		= 12;
+		var->green.offset	= 6;
+		var->blue.offset	= 0;
+		break;
+	case 32:
+		var->red.length		= 8;
+		var->green.length	= 8;
+		var->blue.length	= 8;
+		var->red.offset		= 16;
+		var->green.offset	= 8;
+		var->blue.offset	= 0;
+		break;
+	}
+
+	return 0;
+}
+
+/*
+ *	Calculate lcd register values from var setting & save into hw
+ */
+static void nuc900fb_calculate_lcd_regs(const struct fb_info *info,
+					struct nuc900fb_hw *regs)
+{
+	const struct fb_var_screeninfo *var = &info->var;
+	int vtt = var->height + var->upper_margin + var->lower_margin;
+	int htt = var->width + var->left_margin + var->right_margin;
+	int hsync = var->width + var->right_margin;
+	int vsync = var->height + var->lower_margin;
+
+	regs->lcd_crtc_size = LCM_CRTC_SIZE_VTTVAL(vtt) |
+			      LCM_CRTC_SIZE_HTTVAL(htt);
+	regs->lcd_crtc_dend = LCM_CRTC_DEND_VDENDVAL(var->height) |
+			      LCM_CRTC_DEND_HDENDVAL(var->width);
+	regs->lcd_crtc_hr = LCM_CRTC_HR_EVAL(var->width + 5) |
+			    LCM_CRTC_HR_SVAL(var->width + 1);
+	regs->lcd_crtc_hsync = LCM_CRTC_HSYNC_EVAL(hsync + var->hsync_len) |
+			       LCM_CRTC_HSYNC_SVAL(hsync);
+	regs->lcd_crtc_vr = LCM_CRTC_VR_EVAL(vsync + var->vsync_len) |
+			    LCM_CRTC_VR_SVAL(vsync);
+
+}
+
+/*
+ *	Activate (set) the controller from the given framebuffer
+ *	information
+ */
+static void nuc900fb_activate_var(struct fb_info *info)
+{
+	struct nuc900fb_info *fbi = info->par;
+	void __iomem *regs = fbi->io;
+	struct fb_var_screeninfo *var = &info->var;
+	int clkdiv;
+
+	clkdiv = nuc900fb_calc_pixclk(fbi, var->pixclock) - 1;
+	if (clkdiv < 0)
+		clkdiv = 0;
+
+	nuc900fb_calculate_lcd_regs(info, &fbi->regs);
+
+	/* set the new lcd registers*/
+
+	dev_dbg(fbi->dev, "new lcd register set:\n");
+	dev_dbg(fbi->dev, "dccs       = 0x%08x\n", fbi->regs.lcd_dccs);
+	dev_dbg(fbi->dev, "dev_ctl    = 0x%08x\n", fbi->regs.lcd_device_ctrl);
+	dev_dbg(fbi->dev, "crtc_size  = 0x%08x\n", fbi->regs.lcd_crtc_size);
+	dev_dbg(fbi->dev, "crtc_dend  = 0x%08x\n", fbi->regs.lcd_crtc_dend);
+	dev_dbg(fbi->dev, "crtc_hr    = 0x%08x\n", fbi->regs.lcd_crtc_hr);
+	dev_dbg(fbi->dev, "crtc_hsync = 0x%08x\n", fbi->regs.lcd_crtc_hsync);
+	dev_dbg(fbi->dev, "crtc_vr    = 0x%08x\n", fbi->regs.lcd_crtc_vr);
+
+	writel(fbi->regs.lcd_device_ctrl, regs + REG_LCM_DEV_CTRL);
+	writel(fbi->regs.lcd_crtc_size, regs + REG_LCM_CRTC_SIZE);
+	writel(fbi->regs.lcd_crtc_dend, regs + REG_LCM_CRTC_DEND);
+	writel(fbi->regs.lcd_crtc_hr, regs + REG_LCM_CRTC_HR);
+	writel(fbi->regs.lcd_crtc_hsync, regs + REG_LCM_CRTC_HSYNC);
+	writel(fbi->regs.lcd_crtc_vr, regs + REG_LCM_CRTC_VR);
+
+	/* set lcd address pointers */
+	nuc900fb_set_lcdaddr(info);
+
+	writel(fbi->regs.lcd_dccs, regs + REG_LCM_DCCS);
+}
+
+/*
+ *      Alters the hardware state.
+ *
+ */
+static int nuc900fb_set_par(struct fb_info *info)
+{
+	struct fb_var_screeninfo *var = &info->var;
+
+	switch (var->bits_per_pixel) {
+	case 32:
+	case 24:
+	case 18:
+	case 16:
+	case 12:
+		info->fix.visual = FB_VISUAL_TRUECOLOR;
+		break;
+	case 1:
+		info->fix.visual = FB_VISUAL_MONO01;
+		break;
+	default:
+		info->fix.visual = FB_VISUAL_PSEUDOCOLOR;
+		break;
+	}
+
+	info->fix.line_length = (var->xres_virtual * var->bits_per_pixel) / 8;
+
+	/* activate this new configuration */
+	nuc900fb_activate_var(info);
+	return 0;
+}
+
+static inline unsigned int chan_to_field(unsigned int chan,
+					 struct fb_bitfield *bf)
+{
+	chan &= 0xffff;
+	chan >>= 16 - bf->length;
+	return chan << bf->offset;
+}
+
+static int nuc900fb_setcolreg(unsigned regno,
+			       unsigned red, unsigned green, unsigned blue,
+			       unsigned transp, struct fb_info *info)
+{
+	unsigned int val;
+
+	switch (info->fix.visual) {
+	case FB_VISUAL_TRUECOLOR:
+		/* true-colour, use pseuo-palette */
+		if (regno < 16) {
+			u32 *pal = info->pseudo_palette;
+
+			val  = chan_to_field(red, &info->var.red);
+			val |= chan_to_field(green, &info->var.green);
+			val |= chan_to_field(blue, &info->var.blue);
+			pal[regno] = val;
+		}
+		break;
+
+	default:
+		return 1;   /* unknown type */
+	}
+	return 0;
+}
+
+/**
+ *      nuc900fb_blank
+ *
+ */
+static int nuc900fb_blank(int blank_mode, struct fb_info *info)
+{
+
+	return 0;
+}
+
+static struct fb_ops nuc900fb_ops = {
+	.owner			= THIS_MODULE,
+	.fb_check_var		= nuc900fb_check_var,
+	.fb_set_par		= nuc900fb_set_par,
+	.fb_blank		= nuc900fb_blank,
+	.fb_setcolreg		= nuc900fb_setcolreg,
+	.fb_fillrect		= cfb_fillrect,
+	.fb_copyarea		= cfb_copyarea,
+	.fb_imageblit		= cfb_imageblit,
+};
+
+
+static inline void modify_gpio(void __iomem *reg,
+			       unsigned long set, unsigned long mask)
+{
+	unsigned long tmp;
+	tmp = readl(reg) & ~mask;
+	writel(tmp | set, reg);
+}
+
+/*
+ * Initialise LCD-related registers
+ */
+static int nuc900fb_init_registers(struct fb_info *info)
+{
+	struct nuc900fb_info *fbi = info->par;
+	struct nuc900fb_mach_info *mach_info = fbi->dev->platform_data;
+	void __iomem *regs = fbi->io;
+
+	/*reset the display engine*/
+	writel(0, regs + REG_LCM_DCCS);
+	writel(readl(regs + REG_LCM_DCCS) | LCM_DCCS_ENG_RST,
+	       regs + REG_LCM_DCCS);
+	ndelay(100);
+	writel(readl(regs + REG_LCM_DCCS) & (~LCM_DCCS_ENG_RST),
+	       regs + REG_LCM_DCCS);
+	ndelay(100);
+
+	writel(0, regs + REG_LCM_DEV_CTRL);
+
+	/* config gpio output */
+	modify_gpio(W90X900_VA_GPIO + 0x54, mach_info->gpio_dir,
+		    mach_info->gpio_dir_mask);
+	modify_gpio(W90X900_VA_GPIO + 0x58, mach_info->gpio_data,
+		    mach_info->gpio_data_mask);
+
+	return 0;
+}
+
+
+/*
+ *    Alloc the SDRAM region of NUC900 for the frame buffer.
+ *    The buffer should be a non-cached, non-buffered, memory region
+ *    to allow palette and pixel writes without flushing the cache.
+ */
+static int __init nuc900fb_map_video_memory(struct fb_info *info)
+{
+	struct nuc900fb_info *fbi = info->par;
+	dma_addr_t map_dma;
+	unsigned long map_size = PAGE_ALIGN(info->fix.smem_len);
+
+	dev_dbg(fbi->dev, "nuc900fb_map_video_memory(fbi=%p) map_size %lu\n",
+		fbi, map_size);
+
+	info->screen_base = dma_alloc_writecombine(fbi->dev, map_size,
+							&map_dma, GFP_KERNEL);
+
+	if (!info->screen_base)
+		return -ENOMEM;
+
+	memset(info->screen_base, 0x00, map_size);
+	info->fix.smem_start = map_dma;
+
+	return 0;
+}
+
+static inline void nuc900fb_unmap_video_memory(struct fb_info *info)
+{
+	struct nuc900fb_info *fbi = info->par;
+	dma_free_writecombine(fbi->dev, PAGE_ALIGN(info->fix.smem_len),
+			      info->screen_base, info->fix.smem_start);
+}
+
+static irqreturn_t nuc900fb_irqhandler(int irq, void *dev_id)
+{
+	struct nuc900fb_info *fbi = dev_id;
+	void __iomem *regs = fbi->io;
+	void __iomem *irq_base = fbi->irq_base;
+	unsigned long lcdirq = readl(regs + REG_LCM_INT_CS);
+
+	if (lcdirq & LCM_INT_CS_DISP_F_STATUS) {
+		writel(readl(irq_base) | 1<<30, irq_base);
+
+		/* wait VA_EN low */
+		if ((readl(regs + REG_LCM_DCCS) &
+		    LCM_DCCS_SINGLE) == LCM_DCCS_SINGLE)
+			while ((readl(regs + REG_LCM_DCCS) &
+			       LCM_DCCS_VA_EN) == LCM_DCCS_VA_EN)
+				;
+		/* display_out-enable */
+		writel(readl(regs + REG_LCM_DCCS) | LCM_DCCS_DISP_OUT_EN,
+			regs + REG_LCM_DCCS);
+		/* va-enable*/
+		writel(readl(regs + REG_LCM_DCCS) | LCM_DCCS_VA_EN,
+			regs + REG_LCM_DCCS);
+	} else if (lcdirq & LCM_INT_CS_UNDERRUN_INT) {
+		writel(readl(irq_base) | LCM_INT_CS_UNDERRUN_INT, irq_base);
+	} else if (lcdirq & LCM_INT_CS_BUS_ERROR_INT) {
+		writel(readl(irq_base) | LCM_INT_CS_BUS_ERROR_INT, irq_base);
+	}
+
+	return IRQ_HANDLED;
+}
+
+#ifdef CONFIG_CPU_FREQ
+
+static int nuc900fb_cpufreq_transition(struct notifier_block *nb,
+				       unsigned long val, void *data)
+{
+	struct nuc900fb_info *info;
+	struct fb_info *fbinfo;
+	long delta_f;
+	info = container_of(nb, struct nuc900fb_info, freq_transition);
+	fbinfo = platform_get_drvdata(to_platform_device(info->dev));
+
+	delta_f = info->clk_rate - clk_get_rate(info->clk);
+
+	if ((val == CPUFREQ_POSTCHANGE && delta_f > 0) ||
+	   (val == CPUFREQ_PRECHANGE && delta_f < 0)) {
+		info->clk_rate = clk_get_rate(info->clk);
+		nuc900fb_activate_var(fbinfo);
+	}
+
+	return 0;
+}
+
+static inline int nuc900fb_cpufreq_register(struct nuc900fb_info *fbi)
+{
+	fbi->freq_transition.notifier_call = nuc900fb_cpufreq_transition;
+	return cpufreq_register_notifier(&fbi->freq_transition,
+				  CPUFREQ_TRANSITION_NOTIFIER);
+}
+
+static inline void nuc900fb_cpufreq_deregister(struct nuc900fb_info *fbi)
+{
+	cpufreq_unregister_notifier(&fbi->freq_transition,
+				    CPUFREQ_TRANSITION_NOTIFIER);
+}
+#else
+static inline int nuc900fb_cpufreq_transition(struct notifier_block *nb,
+				       unsigned long val, void *data)
+{
+	return 0;
+}
+
+static inline int nuc900fb_cpufreq_register(struct nuc900fb_info *fbi)
+{
+	return 0;
+}
+
+static inline void nuc900fb_cpufreq_deregister(struct nuc900fb_info *info)
+{
+}
+#endif
+
+static char driver_name[] = "nuc900fb";
+
+static int __devinit nuc900fb_probe(struct platform_device *pdev)
+{
+	struct nuc900fb_info *fbi;
+	struct nuc900fb_display *display;
+	struct fb_info	   *fbinfo;
+	struct nuc900fb_mach_info *mach_info;
+	struct resource *res;
+	int ret;
+	int irq;
+	int i;
+	int size;
+
+	dev_dbg(&pdev->dev, "devinit\n");
+	mach_info = pdev->dev.platform_data;
+	if (mach_info == NULL) {
+		dev_err(&pdev->dev,
+			"no platform data for lcd, cannot attach\n");
+		return -EINVAL;
+	}
+
+	if (mach_info->default_display > mach_info->num_displays) {
+		dev_err(&pdev->dev,
+			"default display No. is %d but only %d displays \n",
+			mach_info->default_display, mach_info->num_displays);
+		return -EINVAL;
+	}
+
+
+	display = mach_info->displays + mach_info->default_display;
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(&pdev->dev, "no irq for device\n");
+		return -ENOENT;
+	}
+
+	fbinfo = framebuffer_alloc(sizeof(struct nuc900fb_info), &pdev->dev);
+	if (!fbinfo)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, fbinfo);
+
+	fbi = fbinfo->par;
+	fbi->dev = &pdev->dev;
+
+#ifdef CONFIG_CPU_NUC950
+	fbi->drv_type = LCDDRV_NUC950;
+#endif
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
+	size = (res->end - res->start) + 1;
+	fbi->mem = request_mem_region(res->start, size, pdev->name);
+	if (fbi->mem == NULL) {
+		dev_err(&pdev->dev, "failed to alloc memory region\n");
+		ret = -ENOENT;
+		goto free_fb;
+	}
+
+	fbi->io = ioremap(res->start, size);
+	if (fbi->io == NULL) {
+		dev_err(&pdev->dev, "ioremap() of lcd registers failed\n");
+		ret = -ENXIO;
+		goto release_mem_region;
+	}
+
+	fbi->irq_base = fbi->io + REG_LCM_INT_CS;
+
+
+	/* Stop the LCD */
+	writel(0, fbi->io + REG_LCM_DCCS);
+
+	/* fill the fbinfo*/
+	strcpy(fbinfo->fix.id, driver_name);
+	fbinfo->fix.type		= FB_TYPE_PACKED_PIXELS;
+	fbinfo->fix.type_aux		= 0;
+	fbinfo->fix.xpanstep		= 0;
+	fbinfo->fix.ypanstep		= 0;
+	fbinfo->fix.ywrapstep		= 0;
+	fbinfo->fix.accel		= FB_ACCEL_NONE;
+	fbinfo->var.nonstd		= 0;
+	fbinfo->var.activate		= FB_ACTIVATE_NOW;
+	fbinfo->var.accel_flags		= 0;
+	fbinfo->var.vmode		= FB_VMODE_NONINTERLACED;
+	fbinfo->fbops			= &nuc900fb_ops;
+	fbinfo->flags			= FBINFO_FLAG_DEFAULT;
+	fbinfo->pseudo_palette		= &fbi->pseudo_pal;
+
+	ret = request_irq(irq, nuc900fb_irqhandler, IRQF_DISABLED,
+			  pdev->name, fbinfo);
+	if (ret) {
+		dev_err(&pdev->dev, "cannot register irq handler %d -err %d\n",
+			irq, ret);
+		ret = -EBUSY;
+		goto release_regs;
+	}
+
+	nuc900_driver_clksrc_div(&pdev->dev, "ext", 0x2);
+
+	fbi->clk = clk_get(&pdev->dev, NULL);
+	if (!fbi->clk || IS_ERR(fbi->clk)) {
+		printk(KERN_ERR "nuc900-lcd:failed to get lcd clock source\n");
+		ret = -ENOENT;
+		goto release_irq;
+	}
+
+	clk_enable(fbi->clk);
+	dev_dbg(&pdev->dev, "got and enabled clock\n");
+
+	fbi->clk_rate = clk_get_rate(fbi->clk);
+
+	/* calutate the video buffer size */
+	for (i = 0; i < mach_info->num_displays; i++) {
+		unsigned long smem_len = mach_info->displays[i].xres;
+		smem_len *= mach_info->displays[i].yres;
+		smem_len *= mach_info->displays[i].bpp;
+		smem_len >>= 3;
+		if (fbinfo->fix.smem_len < smem_len)
+			fbinfo->fix.smem_len = smem_len;
+	}
+
+	/* Initialize Video Memory */
+	ret = nuc900fb_map_video_memory(fbinfo);
+	if (ret) {
+		printk(KERN_ERR "Failed to allocate video RAM: %x\n", ret);
+		goto release_clock;
+	}
+
+	dev_dbg(&pdev->dev, "got video memory\n");
+
+	fbinfo->var.xres = display->xres;
+	fbinfo->var.yres = display->yres;
+	fbinfo->var.bits_per_pixel = display->bpp;
+
+	nuc900fb_init_registers(fbinfo);
+
+	nuc900fb_check_var(&fbinfo->var, fbinfo);
+
+	ret = nuc900fb_cpufreq_register(fbi);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Failed to register cpufreq\n");
+		goto free_video_memory;
+	}
+
+	ret = register_framebuffer(fbinfo);
+	if (ret) {
+		printk(KERN_ERR "failed to register framebuffer device: %d\n",
+			ret);
+		goto free_cpufreq;
+	}
+
+	printk(KERN_INFO "fb%d: %s frame buffer device\n",
+		fbinfo->node, fbinfo->fix.id);
+
+	return 0;
+
+free_cpufreq:
+	nuc900fb_cpufreq_deregister(fbi);
+free_video_memory:
+	nuc900fb_unmap_video_memory(fbinfo);
+release_clock:
+	clk_disable(fbi->clk);
+	clk_put(fbi->clk);
+release_irq:
+	free_irq(irq, fbi);
+release_regs:
+	iounmap(fbi->io);
+release_mem_region:
+	release_mem_region((unsigned long)fbi->mem, size);
+free_fb:
+	framebuffer_release(fbinfo);
+	return ret;
+}
+
+/*
+ * shutdown the lcd controller
+ */
+static void nuc900fb_stop_lcd(struct fb_info *info)
+{
+	struct nuc900fb_info *fbi = info->par;
+	void __iomem *regs = fbi->io;
+
+	writel((~LCM_DCCS_DISP_INT_EN) | (~LCM_DCCS_VA_EN) | (~LCM_DCCS_OSD_EN),
+		regs + REG_LCM_DCCS);
+}
+
+/*
+ *  Cleanup
+ */
+static int nuc900fb_remove(struct platform_device *pdev)
+{
+	struct fb_info *fbinfo = platform_get_drvdata(pdev);
+	struct nuc900fb_info *fbi = fbinfo->par;
+	int irq;
+
+	nuc900fb_stop_lcd(fbinfo);
+	msleep(1);
+
+	nuc900fb_unmap_video_memory(fbinfo);
+
+	iounmap(fbi->io);
+
+	irq = platform_get_irq(pdev, 0);
+	free_irq(irq, fbi);
+
+	release_resource(fbi->mem);
+	kfree(fbi->mem);
+
+	platform_set_drvdata(pdev, NULL);
+	framebuffer_release(fbinfo);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+
+/*
+ *	suspend and resume support for the lcd controller
+ */
+
+static int nuc900fb_suspend(struct platform_device *dev, pm_message_t state)
+{
+	struct fb_info	   *fbinfo = platform_get_drvdata(dev);
+	struct nuc900fb_info *info = fbinfo->par;
+
+	nuc900fb_stop_lcd();
+	msleep(1);
+	clk_disable(info->clk);
+	return 0;
+}
+
+static int nuc900fb_resume(struct platform_device *dev)
+{
+	struct fb_info	   *fbinfo = platform_get_drvdata(dev);
+	struct nuc900fb_info *fbi = fbinfo->par;
+
+	printk(KERN_INFO "nuc900fb resume\n");
+
+	clk_enable(fbi->clk);
+	msleep(1);
+
+	nuc900fb_init_registers(fbinfo);
+	nuc900fb_activate_var(bfinfo);
+
+	return 0;
+}
+
+#else
+#define nuc900fb_suspend NULL
+#define nuc900fb_resume  NULL
+#endif
+
+static struct platform_driver nuc900fb_driver = {
+	.probe		= nuc900fb_probe,
+	.remove		= nuc900fb_remove,
+	.suspend	= nuc900fb_suspend,
+	.resume		= nuc900fb_resume,
+	.driver		= {
+		.name	= "nuc900-lcd",
+		.owner	= THIS_MODULE,
+	},
+};
+
+int __devinit nuc900fb_init(void)
+{
+	return platform_driver_register(&nuc900fb_driver);
+}
+
+static void __exit nuc900fb_cleanup(void)
+{
+	platform_driver_unregister(&nuc900fb_driver);
+}
+
+module_init(nuc900fb_init);
+module_exit(nuc900fb_cleanup);
+
+MODULE_DESCRIPTION("Framebuffer driver for the NUC900");
+MODULE_LICENSE("GPL");
diff -puN /dev/null drivers/video/nuc900fb.h
--- /dev/null
+++ a/drivers/video/nuc900fb.h
@@ -0,0 +1,55 @@
+/*
+ *
+ * Copyright (c) 2009 Nuvoton technology corporation
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ *   Auther:
+ *        Wang Qiang(rurality.linux@gmail.com)  2009/12/16
+ */
+
+#ifndef __NUC900FB_H
+#define __NUC900FB_H
+
+#include <mach/map.h>
+#include <mach/fb.h>
+
+enum nuc900_lcddrv_type {
+	LCDDRV_NUC910,
+	LCDDRV_NUC930,
+	LCDDRV_NUC932,
+	LCDDRV_NUC950,
+	LCDDRV_NUC960,
+};
+
+
+#define PALETTE_BUFFER_SIZE	256
+#define PALETTE_BUFF_CLEAR 	(0x80000000) /* entry is clear/invalid */
+
+struct nuc900fb_info {
+	struct device		*dev;
+	struct clk		*clk;
+
+	struct resource		*mem;
+	void __iomem		*io;
+	void __iomem		*irq_base;
+	int 			drv_type;
+	struct nuc900fb_hw	regs;
+	unsigned long		clk_rate;
+
+#ifdef CONFIG_CPU_FREQ
+	struct notifier_block	freq_transition;
+#endif
+
+	/* keep these registers in case we need to re-write palette */
+	u32			palette_buffer[PALETTE_BUFFER_SIZE];
+	u32			pseudo_pal[16];
+};
+
+int nuc900fb_init(void);
+
+#endif /* __NUC900FB_H */
_

Patches currently in -mm which might be from rurality.linux@gmail.com are

origin.patch

