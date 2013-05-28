From: akpm@linux-foundation.org
Subject: [merged]
 drivers-video-implement-a-simple-framebuffer-driver.patch removed from -mm
 tree
Date: Tue, 28 May 2013 12:36:45 -0700
Message-ID: <51a5074d.B4W3ZDI4DLcJhBQr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60398 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553Ab3E1Tgq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 15:36:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tomasz.figa@gmail.com, robclark@gmail.com, olof@lixom.net, laurent.pinchart@ideasonboard.com, arnd@arndb.de, FlorianSchandinat@gmx.de, swarren@wwwdotorg.org

Subject: [merged] drivers-video-implement-a-simple-framebuffer-driver.patch removed from -mm tree
To: swarren@wwwdotorg.org,FlorianSchandinat@gmx.de,arnd@arndb.de,laurent.pinchart@ideasonboard.com,olof@lixom.net,robclark@gmail.com,tomasz.figa@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 12:36:45 -0700


The patch titled
     Subject: drivers/video: implement a simple framebuffer driver
has been removed from the -mm tree.  Its filename was
     drivers-video-implement-a-simple-framebuffer-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stephen Warren <swarren@wwwdotorg.org>
Subject: drivers/video: implement a simple framebuffer driver

A simple frame-buffer describes a raw memory region that may be rendered
to, with the assumption that the display hardware has already been set up
to scan out from that buffer.

This is useful in cases where a bootloader exists and has set up the
display hardware, but a Linux driver doesn't yet exist for the display
hardware.

Examples use-cases include:

* The built-in LCD panels on the Samsung ARM chromebook, and Tegra
  devices, and likely many other ARM or embedded systems.  These cannot
  yet be supported using a full graphics driver, since the panel control
  should be provided by the CDF (Common Display Framework), which has been
  stuck in design/review for quite some time.  One could support these
  panels using custom SoC-specific code, but there is a desire to use
  common infra-structure rather than having each SoC vendor invent their
  own code, hence the desire to wait for CDF.

* Hardware for which a full graphics driver is not yet available, and
  the path to obtain one upstream isn't yet clear.  For example, the
  Raspberry Pi.

* Any hardware in early stages of upstreaming, before a full graphics
  driver has been tackled.  This driver can provide a graphical boot
  console (even full X support) much earlier in the upstreaming process,
  thus making new SoC or board support more generally useful earlier.

[akpm@linux-foundation.org: make simplefb_formats[] static]
Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Acked-by: Olof Johansson <olof@lixom.net>
Cc: Rob Clark <robclark@gmail.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/video/simple-framebuffer.txt |   25 +
 drivers/video/Kconfig                                          |   17 
 drivers/video/Makefile                                         |    1 
 drivers/video/simplefb.c                                       |  234 ++++++++++
 4 files changed, 277 insertions(+)

diff -puN /dev/null Documentation/devicetree/bindings/video/simple-framebuffer.txt
--- /dev/null
+++ a/Documentation/devicetree/bindings/video/simple-framebuffer.txt
@@ -0,0 +1,25 @@
+Simple Framebuffer
+
+A simple frame-buffer describes a raw memory region that may be rendered to,
+with the assumption that the display hardware has already been set up to scan
+out from that buffer.
+
+Required properties:
+- compatible: "simple-framebuffer"
+- reg: Should contain the location and size of the framebuffer memory.
+- width: The width of the framebuffer in pixels.
+- height: The height of the framebuffer in pixels.
+- stride: The number of bytes in each line of the framebuffer.
+- format: The format of the framebuffer surface. Valid values are:
+  - r5g6b5 (16-bit pixels, d[15:11]=r, d[10:5]=g, d[4:0]=b).
+
+Example:
+
+	framebuffer {
+		compatible = "simple-framebuffer";
+		reg = <0x1d385000 (1600 * 1200 * 2)>;
+		width = <1600>;
+		height = <1200>;
+		stride = <(1600 * 2)>;
+		format = "r5g6b5";
+	};
diff -puN drivers/video/Kconfig~drivers-video-implement-a-simple-framebuffer-driver drivers/video/Kconfig
--- a/drivers/video/Kconfig~drivers-video-implement-a-simple-framebuffer-driver
+++ a/drivers/video/Kconfig
@@ -2453,6 +2453,23 @@ config FB_HYPERV
 	help
 	  This framebuffer driver supports Microsoft Hyper-V Synthetic Video.
 
+config FB_SIMPLE
+	bool "Simple framebuffer support"
+	depends on (FB = y) && OF
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  Say Y if you want support for a simple frame-buffer.
+
+	  This driver assumes that the display hardware has been initialized
+	  before the kernel boots, and the kernel will simply render to the
+	  pre-allocated frame buffer surface.
+
+	  Configuration re: surface address, size, and format must be provided
+	  through device tree, or potentially plain old platform data in the
+	  future.
+
 source "drivers/video/omap/Kconfig"
 source "drivers/video/omap2/Kconfig"
 source "drivers/video/exynos/Kconfig"
diff -puN drivers/video/Makefile~drivers-video-implement-a-simple-framebuffer-driver drivers/video/Makefile
--- a/drivers/video/Makefile~drivers-video-implement-a-simple-framebuffer-driver
+++ a/drivers/video/Makefile
@@ -166,6 +166,7 @@ obj-$(CONFIG_FB_MX3)		  += mx3fb.o
 obj-$(CONFIG_FB_DA8XX)		  += da8xx-fb.o
 obj-$(CONFIG_FB_MXS)		  += mxsfb.o
 obj-$(CONFIG_FB_SSD1307)	  += ssd1307fb.o
+obj-$(CONFIG_FB_SIMPLE)           += simplefb.o
 
 # the test framebuffer is last
 obj-$(CONFIG_FB_VIRTUAL)          += vfb.o
diff -puN /dev/null drivers/video/simplefb.c
--- /dev/null
+++ a/drivers/video/simplefb.c
@@ -0,0 +1,234 @@
+/*
+ * Simplest possible simple frame-buffer driver, as a platform device
+ *
+ * Copyright (c) 2013, Stephen Warren
+ *
+ * Based on q40fb.c, which was:
+ * Copyright (C) 2001 Richard Zidlicky <rz@linux-m68k.org>
+ *
+ * Also based on offb.c, which was:
+ * Copyright (C) 1997 Geert Uytterhoeven
+ * Copyright (C) 1996 Paul Mackerras
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#include <linux/errno.h>
+#include <linux/fb.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+
+static struct fb_fix_screeninfo simplefb_fix = {
+	.id		= "simple",
+	.type		= FB_TYPE_PACKED_PIXELS,
+	.visual		= FB_VISUAL_TRUECOLOR,
+	.accel		= FB_ACCEL_NONE,
+};
+
+static struct fb_var_screeninfo simplefb_var = {
+	.height		= -1,
+	.width		= -1,
+	.activate	= FB_ACTIVATE_NOW,
+	.vmode		= FB_VMODE_NONINTERLACED,
+};
+
+static int simplefb_setcolreg(u_int regno, u_int red, u_int green, u_int blue,
+			      u_int transp, struct fb_info *info)
+{
+	u32 *pal = info->pseudo_palette;
+	u32 cr = red >> (16 - info->var.red.length);
+	u32 cg = green >> (16 - info->var.green.length);
+	u32 cb = blue >> (16 - info->var.blue.length);
+	u32 value;
+
+	if (regno >= 16)
+		return -EINVAL;
+
+	value = (cr << info->var.red.offset) |
+		(cg << info->var.green.offset) |
+		(cb << info->var.blue.offset);
+	if (info->var.transp.length > 0) {
+		u32 mask = (1 << info->var.transp.length) - 1;
+		mask <<= info->var.transp.offset;
+		value |= mask;
+	}
+	pal[regno] = value;
+
+	return 0;
+}
+
+static struct fb_ops simplefb_ops = {
+	.owner		= THIS_MODULE,
+	.fb_setcolreg	= simplefb_setcolreg,
+	.fb_fillrect	= cfb_fillrect,
+	.fb_copyarea	= cfb_copyarea,
+	.fb_imageblit	= cfb_imageblit,
+};
+
+struct simplefb_format {
+	const char *name;
+	u32 bits_per_pixel;
+	struct fb_bitfield red;
+	struct fb_bitfield green;
+	struct fb_bitfield blue;
+	struct fb_bitfield transp;
+};
+
+static struct simplefb_format simplefb_formats[] = {
+	{ "r5g6b5", 16, {11, 5}, {5, 6}, {0, 5}, {0, 0} },
+};
+
+struct simplefb_params {
+	u32 width;
+	u32 height;
+	u32 stride;
+	struct simplefb_format *format;
+};
+
+static int simplefb_parse_dt(struct platform_device *pdev,
+			   struct simplefb_params *params)
+{
+	struct device_node *np = pdev->dev.of_node;
+	int ret;
+	const char *format;
+	int i;
+
+	ret = of_property_read_u32(np, "width", &params->width);
+	if (ret) {
+		dev_err(&pdev->dev, "Can't parse width property\n");
+		return ret;
+	}
+
+	ret = of_property_read_u32(np, "height", &params->height);
+	if (ret) {
+		dev_err(&pdev->dev, "Can't parse height property\n");
+		return ret;
+	}
+
+	ret = of_property_read_u32(np, "stride", &params->stride);
+	if (ret) {
+		dev_err(&pdev->dev, "Can't parse stride property\n");
+		return ret;
+	}
+
+	ret = of_property_read_string(np, "format", &format);
+	if (ret) {
+		dev_err(&pdev->dev, "Can't parse format property\n");
+		return ret;
+	}
+	params->format = NULL;
+	for (i = 0; i < ARRAY_SIZE(simplefb_formats); i++) {
+		if (strcmp(format, simplefb_formats[i].name))
+			continue;
+		params->format = &simplefb_formats[i];
+		break;
+	}
+	if (!params->format) {
+		dev_err(&pdev->dev, "Invalid format value\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int simplefb_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct simplefb_params params;
+	struct fb_info *info;
+	struct resource *mem;
+
+	if (fb_get_options("simplefb", NULL))
+		return -ENODEV;
+
+	ret = simplefb_parse_dt(pdev, &params);
+	if (ret)
+		return ret;
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem) {
+		dev_err(&pdev->dev, "No memory resource\n");
+		return -EINVAL;
+	}
+
+	info = framebuffer_alloc(sizeof(u32) * 16, &pdev->dev);
+	if (!info)
+		return -ENOMEM;
+	platform_set_drvdata(pdev, info);
+
+	info->fix = simplefb_fix;
+	info->fix.smem_start = mem->start;
+	info->fix.smem_len = resource_size(mem);
+	info->fix.line_length = params.stride;
+
+	info->var = simplefb_var;
+	info->var.xres = params.width;
+	info->var.yres = params.height;
+	info->var.xres_virtual = params.width;
+	info->var.yres_virtual = params.height;
+	info->var.bits_per_pixel = params.format->bits_per_pixel;
+	info->var.red = params.format->red;
+	info->var.green = params.format->green;
+	info->var.blue = params.format->blue;
+	info->var.transp = params.format->transp;
+
+	info->fbops = &simplefb_ops;
+	info->flags = FBINFO_DEFAULT;
+	info->screen_base = devm_ioremap(&pdev->dev, info->fix.smem_start,
+					 info->fix.smem_len);
+	if (!info->screen_base) {
+		framebuffer_release(info);
+		return -ENODEV;
+	}
+	info->pseudo_palette = (void *)(info + 1);
+
+	ret = register_framebuffer(info);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Unable to register simplefb: %d\n", ret);
+		framebuffer_release(info);
+		return ret;
+	}
+
+	dev_info(&pdev->dev, "fb%d: simplefb registered!\n", info->node);
+
+	return 0;
+}
+
+static int simplefb_remove(struct platform_device *pdev)
+{
+	struct fb_info *info = platform_get_drvdata(pdev);
+
+	unregister_framebuffer(info);
+	framebuffer_release(info);
+
+	return 0;
+}
+
+static const struct of_device_id simplefb_of_match[] = {
+	{ .compatible = "simple-framebuffer", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, simplefb_of_match);
+
+static struct platform_driver simplefb_driver = {
+	.driver = {
+		.name = "simple-framebuffer",
+		.owner = THIS_MODULE,
+		.of_match_table = simplefb_of_match,
+	},
+	.probe = simplefb_probe,
+	.remove = simplefb_remove,
+};
+module_platform_driver(simplefb_driver);
+
+MODULE_AUTHOR("Stephen Warren <swarren@wwwdotorg.org>");
+MODULE_DESCRIPTION("Simple framebuffer driver");
+MODULE_LICENSE("GPL v2");
_

Patches currently in -mm which might be from swarren@wwwdotorg.org are

linux-next.patch

