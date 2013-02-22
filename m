From: akpm@linux-foundation.org
Subject: [merged] goldfish-framebuffer-driver.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:37:54 -0800
Message-ID: <20130222203754.D916331C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:56972 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757009Ab3BVUh4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:37:56 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so119275qah.0
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:37:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arve@android.com, FlorianSchandinat@gmx.de, alan@linux.intel.com, bruce.j.beare@intel.com, jun.nakajima@intel.com, mikechan@google.com, sheng@linux.intel.com, thomas.keel@intel.com, tomi.valkeinen@ti.com, xiaohui.xin@intel.com, yunhong.jiang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: goldfish: framebuffer driver
has been removed from the -mm tree.  Its filename was
     goldfish-framebuffer-driver.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Arve Hj=F8nnev=E5g <arve@android.com>
Subject: goldfish: framebuffer driver

=46ramebuffer support for the Goldfish emulator.  This takes the Google
emulator and applies the x86 cleanups as well as moving the blank metho=
ds
to the usual Linux place and dropping the Android early suspend logic (=
for
now at least, that can be looked at as Android and upstream converge).=20
Dropped various oddities like setting MTRRs on a virtual frame buffer
emulation...

With the drivers so far you can now boot a Linux initrd and have fun.

[sheng@linux.intel.com: cleaned up to handle x86]
[thomas.keel@intel.com: ported to 3.4]
[alan@linux.intel.com: cleaned up for style and 3.7, moved blank method=
s]
[akpm@linux-foundation.org: fix (silly) sparse warnings]
Signed-off-by: Mike A. Chan <mikechan@google.com>
Signed-off-by: Arve Hj=F8nnev=E5g <arve@android.com>
Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Yunhong Jiang <yunhong.jiang@intel.com>
Signed-off-by: Xiaohui Xin <xiaohui.xin@intel.com>
Signed-off-by: Jun Nakajima <jun.nakajima@intel.com>
Signed-off-by: Bruce Beare <bruce.j.beare@intel.com>
Signed-off-by: Tom Keel <thomas.keel@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig      |    9=20
 drivers/video/Makefile     |    1=20
 drivers/video/goldfishfb.c |  318 +++++++++++++++++++++++++++++++++++
 3 files changed, 328 insertions(+)

diff -puN drivers/video/Kconfig~goldfish-framebuffer-driver drivers/vid=
eo/Kconfig
--- a/drivers/video/Kconfig~goldfish-framebuffer-driver
+++ a/drivers/video/Kconfig
@@ -2183,6 +2183,15 @@ config FB_XILINX
 	  framebuffer. ML300 carries a 640*480 LCD display on the board,
 	  ML403 uses a standard DB15 VGA connector.
=20
+config FB_GOLDFISH
+	tristate "Goldfish Framebuffer"
+	depends on FB
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	---help---
+	  Framebuffer driver for Goldfish Virtual Platform
+
 config FB_COBALT
 	tristate "Cobalt server LCD frame buffer support"
 	depends on FB && (MIPS_COBALT || MIPS_SEAD3)
diff -puN drivers/video/Makefile~goldfish-framebuffer-driver drivers/vi=
deo/Makefile
--- a/drivers/video/Makefile~goldfish-framebuffer-driver
+++ a/drivers/video/Makefile
@@ -98,6 +98,7 @@ obj-$(CONFIG_FB_ATMEL)		  +=3D atmel_lcdfb
 obj-$(CONFIG_FB_PVR2)             +=3D pvr2fb.o
 obj-$(CONFIG_FB_VOODOO1)          +=3D sstfb.o
 obj-$(CONFIG_FB_ARMCLCD)	  +=3D amba-clcd.o
+obj-$(CONFIG_FB_GOLDFISH)         +=3D goldfishfb.o
 obj-$(CONFIG_FB_68328)            +=3D 68328fb.o
 obj-$(CONFIG_FB_GBE)              +=3D gbefb.o
 obj-$(CONFIG_FB_CIRRUS)		  +=3D cirrusfb.o
diff -puN /dev/null drivers/video/goldfishfb.c
--- /dev/null
+++ a/drivers/video/goldfishfb.c
@@ -0,0 +1,318 @@
+/*
+ * Copyright (C) 2007 Google, Inc.
+ * Copyright (C) 2012 Intel, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, an=
d
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/dma-mapping.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/mm.h>
+#include <linux/fb.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/ioport.h>
+#include <linux/platform_device.h>
+
+enum {
+	FB_GET_WIDTH        =3D 0x00,
+	FB_GET_HEIGHT       =3D 0x04,
+	FB_INT_STATUS       =3D 0x08,
+	FB_INT_ENABLE       =3D 0x0c,
+	FB_SET_BASE         =3D 0x10,
+	FB_SET_ROTATION     =3D 0x14,
+	FB_SET_BLANK        =3D 0x18,
+	FB_GET_PHYS_WIDTH   =3D 0x1c,
+	FB_GET_PHYS_HEIGHT  =3D 0x20,
+
+	FB_INT_VSYNC             =3D 1U << 0,
+	FB_INT_BASE_UPDATE_DONE  =3D 1U << 1
+};
+
+struct goldfish_fb {
+	void __iomem *reg_base;
+	int irq;
+	spinlock_t lock;
+	wait_queue_head_t wait;
+	int base_update_count;
+	int rotation;
+	struct fb_info fb;
+	u32 cmap[16];
+};
+
+static irqreturn_t goldfish_fb_interrupt(int irq, void *dev_id)
+{
+	unsigned long irq_flags;
+	struct goldfish_fb *fb =3D dev_id;
+	u32 status;
+
+	spin_lock_irqsave(&fb->lock, irq_flags);
+	status =3D readl(fb->reg_base + FB_INT_STATUS);
+	if (status & FB_INT_BASE_UPDATE_DONE) {
+		fb->base_update_count++;
+		wake_up(&fb->wait);
+	}
+	spin_unlock_irqrestore(&fb->lock, irq_flags);
+	return status ? IRQ_HANDLED : IRQ_NONE;
+}
+
+static inline u32 convert_bitfield(int val, struct fb_bitfield *bf)
+{
+	unsigned int mask =3D (1 << bf->length) - 1;
+
+	return (val >> (16 - bf->length) & mask) << bf->offset;
+}
+
+static int
+goldfish_fb_setcolreg(unsigned int regno, unsigned int red, unsigned i=
nt green,
+		 unsigned int blue, unsigned int transp, struct fb_info *info)
+{
+	struct goldfish_fb *fb =3D container_of(info, struct goldfish_fb, fb)=
;
+
+	if (regno < 16) {
+		fb->cmap[regno] =3D convert_bitfield(transp, &fb->fb.var.transp) |
+				  convert_bitfield(blue, &fb->fb.var.blue) |
+				  convert_bitfield(green, &fb->fb.var.green) |
+				  convert_bitfield(red, &fb->fb.var.red);
+		return 0;
+	} else {
+		return 1;
+	}
+}
+
+static int goldfish_fb_check_var(struct fb_var_screeninfo *var,
+							struct fb_info *info)
+{
+	if ((var->rotate & 1) !=3D (info->var.rotate & 1)) {
+		if ((var->xres !=3D info->var.yres) ||
+				(var->yres !=3D info->var.xres) ||
+				(var->xres_virtual !=3D info->var.yres) ||
+				(var->yres_virtual > info->var.xres * 2) ||
+				(var->yres_virtual < info->var.xres)) {
+			return -EINVAL;
+		}
+	} else {
+		if ((var->xres !=3D info->var.xres) ||
+		   (var->yres !=3D info->var.yres) ||
+		   (var->xres_virtual !=3D info->var.xres) ||
+		   (var->yres_virtual > info->var.yres * 2) ||
+		   (var->yres_virtual < info->var.yres)) {
+			return -EINVAL;
+		}
+	}
+	if ((var->xoffset !=3D info->var.xoffset) ||
+			(var->bits_per_pixel !=3D info->var.bits_per_pixel) ||
+			(var->grayscale !=3D info->var.grayscale)) {
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int goldfish_fb_set_par(struct fb_info *info)
+{
+	struct goldfish_fb *fb =3D container_of(info, struct goldfish_fb, fb)=
;
+	if (fb->rotation !=3D fb->fb.var.rotate) {
+		info->fix.line_length =3D info->var.xres * 2;
+		fb->rotation =3D fb->fb.var.rotate;
+		writel(fb->rotation, fb->reg_base + FB_SET_ROTATION);
+	}
+	return 0;
+}
+
+
+static int goldfish_fb_pan_display(struct fb_var_screeninfo *var,
+							struct fb_info *info)
+{
+	unsigned long irq_flags;
+	int base_update_count;
+	struct goldfish_fb *fb =3D container_of(info, struct goldfish_fb, fb)=
;
+
+	spin_lock_irqsave(&fb->lock, irq_flags);
+	base_update_count =3D fb->base_update_count;
+	writel(fb->fb.fix.smem_start + fb->fb.var.xres * 2 * var->yoffset,
+						fb->reg_base + FB_SET_BASE);
+	spin_unlock_irqrestore(&fb->lock, irq_flags);
+	wait_event_timeout(fb->wait,
+			fb->base_update_count !=3D base_update_count, HZ / 15);
+	if (fb->base_update_count =3D=3D base_update_count)
+		pr_err("goldfish_fb_pan_display: timeout wating for base update\n");
+	return 0;
+}
+
+static int goldfish_fb_blank(int blank, struct fb_info *info)
+{
+	struct goldfish_fb *fb =3D container_of(info, struct goldfish_fb, fb)=
;
+	switch (blank) {
+	case FB_BLANK_NORMAL:
+		writel(1, fb->reg_base + FB_SET_BLANK);
+		break;
+	case FB_BLANK_UNBLANK:
+		writel(0, fb->reg_base + FB_SET_BLANK);
+		break;
+	}
+	return 0;
+}
+
+static struct fb_ops goldfish_fb_ops =3D {
+	.owner          =3D THIS_MODULE,
+	.fb_check_var   =3D goldfish_fb_check_var,
+	.fb_set_par     =3D goldfish_fb_set_par,
+	.fb_setcolreg   =3D goldfish_fb_setcolreg,
+	.fb_pan_display =3D goldfish_fb_pan_display,
+	.fb_blank	=3D goldfish_fb_blank,
+	.fb_fillrect    =3D cfb_fillrect,
+	.fb_copyarea    =3D cfb_copyarea,
+	.fb_imageblit   =3D cfb_imageblit,
+};
+
+
+static int goldfish_fb_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct resource *r;
+	struct goldfish_fb *fb;
+	size_t framesize;
+	u32 width, height;
+	dma_addr_t fbpaddr;
+
+	fb =3D kzalloc(sizeof(*fb), GFP_KERNEL);
+	if (fb =3D=3D NULL) {
+		ret =3D -ENOMEM;
+		goto err_fb_alloc_failed;
+	}
+	spin_lock_init(&fb->lock);
+	init_waitqueue_head(&fb->wait);
+	platform_set_drvdata(pdev, fb);
+
+	r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (r =3D=3D NULL) {
+		ret =3D -ENODEV;
+		goto err_no_io_base;
+	}
+	fb->reg_base =3D ioremap(r->start, PAGE_SIZE);
+	if (fb->reg_base =3D=3D NULL) {
+		ret =3D -ENOMEM;
+		goto err_no_io_base;
+	}
+
+	fb->irq =3D platform_get_irq(pdev, 0);
+	if (fb->irq <=3D 0) {
+		ret =3D -ENODEV;
+		goto err_no_irq;
+	}
+
+	width =3D readl(fb->reg_base + FB_GET_WIDTH);
+	height =3D readl(fb->reg_base + FB_GET_HEIGHT);
+
+	fb->fb.fbops		=3D &goldfish_fb_ops;
+	fb->fb.flags		=3D FBINFO_FLAG_DEFAULT;
+	fb->fb.pseudo_palette	=3D fb->cmap;
+	fb->fb.fix.type		=3D FB_TYPE_PACKED_PIXELS;
+	fb->fb.fix.visual =3D FB_VISUAL_TRUECOLOR;
+	fb->fb.fix.line_length =3D width * 2;
+	fb->fb.fix.accel	=3D FB_ACCEL_NONE;
+	fb->fb.fix.ypanstep =3D 1;
+
+	fb->fb.var.xres		=3D width;
+	fb->fb.var.yres		=3D height;
+	fb->fb.var.xres_virtual	=3D width;
+	fb->fb.var.yres_virtual	=3D height * 2;
+	fb->fb.var.bits_per_pixel =3D 16;
+	fb->fb.var.activate	=3D FB_ACTIVATE_NOW;
+	fb->fb.var.height	=3D readl(fb->reg_base + FB_GET_PHYS_HEIGHT);
+	fb->fb.var.width	=3D readl(fb->reg_base + FB_GET_PHYS_WIDTH);
+	fb->fb.var.pixclock	=3D 10000;
+
+	fb->fb.var.red.offset =3D 11;
+	fb->fb.var.red.length =3D 5;
+	fb->fb.var.green.offset =3D 5;
+	fb->fb.var.green.length =3D 6;
+	fb->fb.var.blue.offset =3D 0;
+	fb->fb.var.blue.length =3D 5;
+
+	framesize =3D width * height * 2 * 2;
+	fb->fb.screen_base =3D (char __force __iomem *)dma_alloc_coherent(
+						&pdev->dev, framesize,
+						&fbpaddr, GFP_KERNEL);
+	pr_debug("allocating frame buffer %d * %d, got %p\n",
+					width, height, fb->fb.screen_base);
+	if (fb->fb.screen_base =3D=3D NULL) {
+		ret =3D -ENOMEM;
+		goto err_alloc_screen_base_failed;
+	}
+	fb->fb.fix.smem_start =3D fbpaddr;
+	fb->fb.fix.smem_len =3D framesize;
+
+	ret =3D fb_set_var(&fb->fb, &fb->fb.var);
+	if (ret)
+		goto err_fb_set_var_failed;
+
+	ret =3D request_irq(fb->irq, goldfish_fb_interrupt, IRQF_SHARED,
+							pdev->name, fb);
+	if (ret)
+		goto err_request_irq_failed;
+
+	writel(FB_INT_BASE_UPDATE_DONE, fb->reg_base + FB_INT_ENABLE);
+	goldfish_fb_pan_display(&fb->fb.var, &fb->fb); /* updates base */
+
+	ret =3D register_framebuffer(&fb->fb);
+	if (ret)
+		goto err_register_framebuffer_failed;
+	return 0;
+
+err_register_framebuffer_failed:
+	free_irq(fb->irq, fb);
+err_request_irq_failed:
+err_fb_set_var_failed:
+	dma_free_coherent(&pdev->dev, framesize,
+				(void *)fb->fb.screen_base,
+				fb->fb.fix.smem_start);
+err_alloc_screen_base_failed:
+err_no_irq:
+	iounmap(fb->reg_base);
+err_no_io_base:
+	kfree(fb);
+err_fb_alloc_failed:
+	return ret;
+}
+
+static int goldfish_fb_remove(struct platform_device *pdev)
+{
+	size_t framesize;
+	struct goldfish_fb *fb =3D platform_get_drvdata(pdev);
+
+	framesize =3D fb->fb.var.xres_virtual * fb->fb.var.yres_virtual * 2;
+	unregister_framebuffer(&fb->fb);
+	free_irq(fb->irq, fb);
+
+	dma_free_coherent(&pdev->dev, framesize, (void *)fb->fb.screen_base,
+						fb->fb.fix.smem_start);
+	iounmap(fb->reg_base);
+	return 0;
+}
+
+
+static struct platform_driver goldfish_fb_driver =3D {
+	.probe		=3D goldfish_fb_probe,
+	.remove		=3D goldfish_fb_remove,
+	.driver =3D {
+		.name =3D "goldfish_fb"
+	}
+};
+
+module_platform_driver(goldfish_fb_driver);
+
+MODULE_LICENSE("GPL v2");
_

Patches currently in -mm which might be from arve@android.com are

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
