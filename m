From: akpm@linux-foundation.org
Subject: - vmlfb-framebuffer-driver-for-intel-vermilion-range.patch removed from -mm tree
Date: Tue, 08 May 2007 20:01:55 -0700
Message-ID: <200705090301.l4931tSZ010770@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33889 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032804AbXEIDCY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:02:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alanh@fairlite.demon.co.uk, adaplas@gmail.com, alanh@tungstengraphics.com, mm-commits@vger.kernel.org


The patch titled
     vmlfb: framebuffer driver for Intel Vermilion Range
has been removed from the -mm tree.  Its filename was
     vmlfb-framebuffer-driver-for-intel-vermilion-range.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
Subject: vmlfb: framebuffer driver for Intel Vermilion Range
=46rom: Alan Hourihane <alanh@fairlite.demon.co.uk>

Add the Intel Vermilion Range framebuffer support.

Signed-off-by: Alan Hourihane <alanh@tungstengraphics.com>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig               |   16=20
 drivers/video/Makefile              |    1=20
 drivers/video/backlight/Kconfig     |    8=20
 drivers/video/backlight/Makefile    |    1=20
 drivers/video/backlight/cr_bllcd.c  |  287 ++++++
 drivers/video/vermilion/Makefile    |    5=20
 drivers/video/vermilion/cr_pll.c    |  208 ++++
 drivers/video/vermilion/vermilion.c | 1195 ++++++++++++++++++++++++++
 drivers/video/vermilion/vermilion.h |  260 +++++
 9 files changed, 1981 insertions(+)

diff -puN drivers/video/Kconfig~vmlfb-framebuffer-driver-for-intel-verm=
ilion-range drivers/video/Kconfig
--- a/drivers/video/Kconfig~vmlfb-framebuffer-driver-for-intel-vermilio=
n-range
+++ a/drivers/video/Kconfig
@@ -882,6 +882,22 @@ config FB_I810_I2C
 	select FB_DDC
 	help
=20
+config FB_LE80578
+	tristate "Intel LE80578 (Vermilion) support"
+	depends on FB && PCI && X86
+	select FB_MODE_HELPERS
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This driver supports the LE80578 (Vermilion Range) chipset
+
+config FB_CARILLO_RANCH
+	tristate "Intel Carillo Ranch support"
+	depends on FB_LE80578 && FB && PCI && X86
+	help
+	  This driver supports the LE80578 (Carillo Ranch) board
+
 config FB_INTEL
 	tristate "Intel 830M/845G/852GM/855GM/865G/915G/945G support (EXPERIM=
ENTAL)"
 	depends on FB && EXPERIMENTAL && PCI && X86
diff -puN drivers/video/Makefile~vmlfb-framebuffer-driver-for-intel-ver=
milion-range drivers/video/Makefile
--- a/drivers/video/Makefile~vmlfb-framebuffer-driver-for-intel-vermili=
on-range
+++ a/drivers/video/Makefile
@@ -56,6 +56,7 @@ obj-$(CONFIG_FB_IMSTT)            +=3D ims
 obj-$(CONFIG_FB_FM2)              +=3D fm2fb.o
 obj-$(CONFIG_FB_CYBLA)            +=3D cyblafb.o
 obj-$(CONFIG_FB_TRIDENT)          +=3D tridentfb.o
+obj-$(CONFIG_FB_LE80578)          +=3D vermilion/
 obj-$(CONFIG_FB_S3)               +=3D s3fb.o
 obj-$(CONFIG_FB_STI)              +=3D stifb.o
 obj-$(CONFIG_FB_FFB)              +=3D ffb.o sbuslib.o
diff -puN drivers/video/backlight/Kconfig~vmlfb-framebuffer-driver-for-=
intel-vermilion-range drivers/video/backlight/Kconfig
--- a/drivers/video/backlight/Kconfig~vmlfb-framebuffer-driver-for-inte=
l-vermilion-range
+++ a/drivers/video/backlight/Kconfig
@@ -63,3 +63,11 @@ config BACKLIGHT_PROGEAR
 	help
 	  If you have a Frontpath ProGear say Y to enable the
 	  backlight driver.
+
+config BACKLIGHT_CARILLO_RANCH
+	tristate "Intel Carillo Ranch Backlight Driver"
+	depends on BACKLIGHT_CLASS_DEVICE && LCD_CLASS_DEVICE && PCI && X86 &=
& FB_LE80578
+	default n
+	help
+	  If you have a Intel LE80578 (Carillo Ranch) say Y to enable the
+	  backlight driver.
diff -puN drivers/video/backlight/Makefile~vmlfb-framebuffer-driver-for=
-intel-vermilion-range drivers/video/backlight/Makefile
--- a/drivers/video/backlight/Makefile~vmlfb-framebuffer-driver-for-int=
el-vermilion-range
+++ a/drivers/video/backlight/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_BACKLIGHT_CORGI)	+=3D corgi_b
 obj-$(CONFIG_BACKLIGHT_HP680)	+=3D hp680_bl.o
 obj-$(CONFIG_BACKLIGHT_LOCOMO)	+=3D locomolcd.o
 obj-$(CONFIG_BACKLIGHT_PROGEAR) +=3D progear_bl.o
+obj-$(CONFIG_BACKLIGHT_CARILLO_RANCH) +=3D cr_bllcd.o
diff -puN /dev/null drivers/video/backlight/cr_bllcd.c
--- /dev/null
+++ a/drivers/video/backlight/cr_bllcd.c
@@ -0,0 +1,287 @@
+/*
+ * Copyright (c) Intel Corp. 2007.
+ * All Rights Reserved.
+ *
+ * Intel funded Tungsten Graphics (http://www.tungstengraphics.com) to
+ * develop this driver.
+ *
+ * This file is part of the Carillo Ranch video subsystem driver.
+ * The Carillo Ranch video subsystem driver is free software;
+ * you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * The Carillo Ranch video subsystem driver is distributed
+ * in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this driver; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-13=
01  USA
+ *
+ * Authors:
+ *   Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
+ *   Alan Hourihane <alanh-at-tungstengraphics-dot-com>
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/mutex.h>
+#include <linux/fb.h>
+#include <linux/backlight.h>
+#include <linux/lcd.h>
+#include <linux/pci.h>
+#include <asm/uaccess.h>
+
+/* The LVDS- and panel power controls sits on the
+ * GPIO port of the ISA bridge.
+ */
+
+#define CRVML_DEVICE_LPC    0x27B8
+#define CRVML_REG_GPIOBAR   0x48
+#define CRVML_REG_GPIOEN    0x4C
+#define CRVML_GPIOEN_BIT    (1 << 4)
+#define CRVML_PANEL_PORT    0x38
+#define CRVML_LVDS_ON       0x00000001
+#define CRVML_PANEL_ON      0x00000002
+#define CRVML_BACKLIGHT_OFF 0x00000004
+
+/* The PLL Clock register sits on Host bridge */
+#define CRVML_DEVICE_MCH   0x5001
+#define CRVML_REG_MCHBAR   0x44
+#define CRVML_REG_MCHEN    0x54
+#define CRVML_MCHEN_BIT    (1 << 28)
+#define CRVML_MCHMAP_SIZE  4096
+#define CRVML_REG_CLOCK    0xc3c
+#define CRVML_CLOCK_SHIFT  8
+#define CRVML_CLOCK_MASK   0x00000f00
+
+static struct pci_dev *lpc_dev;
+static u32 gpio_bar;
+
+struct cr_panel {
+	struct backlight_device *cr_backlight_device;
+	struct lcd_device *cr_lcd_device;
+};
+
+static int cr_backlight_set_intensity(struct backlight_device *bd)
+{
+	int intensity =3D bd->props.brightness;
+	u32 addr =3D gpio_bar + CRVML_PANEL_PORT;
+	u32 cur =3D inl(addr);
+
+	if (bd->props.power =3D=3D FB_BLANK_UNBLANK)
+		intensity =3D FB_BLANK_UNBLANK;
+	if (bd->props.fb_blank =3D=3D FB_BLANK_UNBLANK)
+		intensity =3D FB_BLANK_UNBLANK;
+	if (bd->props.power =3D=3D FB_BLANK_POWERDOWN)
+		intensity =3D FB_BLANK_POWERDOWN;
+	if (bd->props.fb_blank =3D=3D FB_BLANK_POWERDOWN)
+		intensity =3D FB_BLANK_POWERDOWN;
+
+	if (intensity =3D=3D FB_BLANK_UNBLANK) { /* FULL ON */
+		cur &=3D ~CRVML_BACKLIGHT_OFF;
+		outl(cur, addr);
+	} else if (intensity =3D=3D FB_BLANK_POWERDOWN) { /* OFF */
+		cur |=3D CRVML_BACKLIGHT_OFF;
+		outl(cur, addr);
+	} /* anything else, don't bother */
+
+	return 0;
+}
+
+static int cr_backlight_get_intensity(struct backlight_device *bd)
+{
+	u32 addr =3D gpio_bar + CRVML_PANEL_PORT;
+	u32 cur =3D inl(addr);
+	u8 intensity;
+
+	if (cur & CRVML_BACKLIGHT_OFF)
+		intensity =3D FB_BLANK_POWERDOWN;
+	else
+		intensity =3D FB_BLANK_UNBLANK;
+
+	return intensity;
+}
+
+static struct backlight_ops cr_backlight_ops =3D {
+	.get_brightness =3D cr_backlight_get_intensity,
+	.update_status =3D cr_backlight_set_intensity,
+};
+
+static void cr_panel_on(void)
+{
+	u32 addr =3D gpio_bar + CRVML_PANEL_PORT;
+	u32 cur =3D inl(addr);
+
+	if (!(cur & CRVML_PANEL_ON)) {
+		/* Make sure LVDS controller is down. */
+		if (cur & 0x00000001) {
+			cur &=3D ~CRVML_LVDS_ON;
+			outl(cur, addr);
+		}
+		/* Power up Panel */
+		schedule_timeout(HZ / 10);
+		cur |=3D CRVML_PANEL_ON;
+		outl(cur, addr);
+	}
+
+	/* Power up LVDS controller */
+
+	if (!(cur & CRVML_LVDS_ON)) {
+		schedule_timeout(HZ / 10);
+		outl(cur | CRVML_LVDS_ON, addr);
+	}
+}
+
+static void cr_panel_off(void)
+{
+	u32 addr =3D gpio_bar + CRVML_PANEL_PORT;
+	u32 cur =3D inl(addr);
+
+	/* Power down LVDS controller first to avoid high currents */
+	if (cur & CRVML_LVDS_ON) {
+		cur &=3D ~CRVML_LVDS_ON;
+		outl(cur, addr);
+	}
+	if (cur & CRVML_PANEL_ON) {
+		schedule_timeout(HZ / 10);
+		outl(cur & ~CRVML_PANEL_ON, addr);
+	}
+}
+
+static int cr_lcd_set_power(struct lcd_device *ld, int power)
+{
+	if (power =3D=3D FB_BLANK_UNBLANK)
+		cr_panel_on();
+	if (power =3D=3D FB_BLANK_POWERDOWN)
+		cr_panel_off();
+
+	return 0;
+}
+
+static struct lcd_ops cr_lcd_ops =3D {
+	.set_power =3D cr_lcd_set_power,
+};
+
+static int cr_backlight_probe(struct platform_device *pdev)
+{
+	struct cr_panel *crp;
+	u8 dev_en;
+
+	crp =3D kzalloc(sizeof(crp), GFP_KERNEL);
+	if (crp =3D=3D NULL)
+		return -ENOMEM;
+
+	lpc_dev =3D pci_get_device(PCI_VENDOR_ID_INTEL,
+					CRVML_DEVICE_LPC, NULL);
+	if (!lpc_dev) {
+		printk("INTEL CARILLO RANCH LPC not found.\n");
+		return -ENODEV;
+	}
+
+	pci_read_config_byte(lpc_dev, CRVML_REG_GPIOEN, &dev_en);
+	if (!(dev_en & CRVML_GPIOEN_BIT)) {
+		printk(KERN_ERR
+		       "Carillo Ranch GPIO device was not enabled.\n");
+		pci_dev_put(lpc_dev);
+		return -ENODEV;
+	}
+
+	crp->cr_backlight_device =3D backlight_device_register("cr-backlight"=
,
+							     &pdev->dev, NULL,
+							     &cr_backlight_ops);
+	if (IS_ERR(crp->cr_backlight_device)) {
+		pci_dev_put(lpc_dev);
+		return PTR_ERR(crp->cr_backlight_device);
+	}
+
+	crp->cr_lcd_device =3D lcd_device_register("cr-lcd",
+							&pdev->dev,
+							&cr_lcd_ops);
+
+	if (IS_ERR(crp->cr_lcd_device)) {
+		pci_dev_put(lpc_dev);
+		return PTR_ERR(crp->cr_backlight_device);
+	}
+
+	pci_read_config_dword(lpc_dev, CRVML_REG_GPIOBAR,
+			      &gpio_bar);
+	gpio_bar &=3D ~0x3F;
+
+	crp->cr_backlight_device->props.power =3D FB_BLANK_UNBLANK;
+	crp->cr_backlight_device->props.brightness =3D 0;
+	crp->cr_backlight_device->props.max_brightness =3D 0;
+	cr_backlight_set_intensity(crp->cr_backlight_device);
+
+	cr_lcd_set_power(crp->cr_lcd_device, FB_BLANK_UNBLANK);
+
+	platform_set_drvdata(pdev, crp);
+
+	return 0;
+}
+
+static int cr_backlight_remove(struct platform_device *pdev)
+{
+	struct cr_panel *crp =3D platform_get_drvdata(pdev);
+	crp->cr_backlight_device->props.power =3D FB_BLANK_POWERDOWN;
+	crp->cr_backlight_device->props.brightness =3D 0;
+	crp->cr_backlight_device->props.max_brightness =3D 0;
+	cr_backlight_set_intensity(crp->cr_backlight_device);
+	cr_lcd_set_power(crp->cr_lcd_device, FB_BLANK_POWERDOWN);
+	backlight_device_unregister(crp->cr_backlight_device);
+	lcd_device_unregister(crp->cr_lcd_device);
+	pci_dev_put(lpc_dev);
+
+	return 0;
+}
+
+static struct platform_driver cr_backlight_driver =3D {
+	.probe =3D cr_backlight_probe,
+	.remove =3D cr_backlight_remove,
+	.driver =3D {
+		   .name =3D "cr_backlight",
+		   },
+};
+
+static struct platform_device *crp;
+
+static int __init cr_backlight_init(void)
+{
+	int ret =3D platform_driver_register(&cr_backlight_driver);
+
+	if (!ret) {
+		crp =3D platform_device_alloc("cr_backlight", -1);
+		if (!crp)
+			return -ENOMEM;
+
+		ret =3D platform_device_add(crp);
+
+		if (ret) {
+			platform_device_put(crp);
+			platform_driver_unregister(&cr_backlight_driver);
+		}
+	}
+
+	printk("Carillo Ranch Backlight Driver Initialized.\n");
+
+	return ret;
+}
+
+static void __exit cr_backlight_exit(void)
+{
+	platform_device_unregister(crp);
+	platform_driver_unregister(&cr_backlight_driver);
+}
+
+module_init(cr_backlight_init);
+module_exit(cr_backlight_exit);
+
+MODULE_AUTHOR("Tungsten Graphics Inc.");
+MODULE_DESCRIPTION("Carillo Ranch Backlight Driver");
+MODULE_LICENSE("GPL");
diff -puN /dev/null drivers/video/vermilion/Makefile
--- /dev/null
+++ a/drivers/video/vermilion/Makefile
@@ -0,0 +1,5 @@
+obj-$(CONFIG_FB_LE80578) +=3D vmlfb.o
+obj-$(CONFIG_FB_CARILLO_RANCH) +=3D crvml.o
+
+vmlfb-objs :=3D vermilion.o
+crvml-objs :=3D cr_pll.o
diff -puN /dev/null drivers/video/vermilion/cr_pll.c
--- /dev/null
+++ a/drivers/video/vermilion/cr_pll.c
@@ -0,0 +1,208 @@
+/*
+ * Copyright (c) Intel Corp. 2007.
+ * All Rights Reserved.
+ *
+ * Intel funded Tungsten Graphics (http://www.tungstengraphics.com) to
+ * develop this driver.
+ *
+ * This file is part of the Carillo Ranch video subsystem driver.
+ * The Carillo Ranch video subsystem driver is free software;
+ * you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * The Carillo Ranch video subsystem driver is distributed
+ * in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this driver; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-13=
01  USA
+ *
+ * Authors:
+ *   Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
+ *   Alan Hourihane <alanh-at-tungstengraphics-dot-com>
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/pci.h>
+#include <linux/errno.h>
+#include <linux/fb.h>
+#include "vermilion.h"
+
+/* The PLL Clock register sits on Host bridge */
+#define CRVML_DEVICE_MCH   0x5001
+#define CRVML_REG_MCHBAR   0x44
+#define CRVML_REG_MCHEN    0x54
+#define CRVML_MCHEN_BIT    (1 << 28)
+#define CRVML_MCHMAP_SIZE  4096
+#define CRVML_REG_CLOCK    0xc3c
+#define CRVML_CLOCK_SHIFT  8
+#define CRVML_CLOCK_MASK   0x00000f00
+
+static struct pci_dev *mch_dev;
+static u32 mch_bar;
+static void __iomem *mch_regs_base;
+static u32 saved_clock;
+
+static const unsigned crvml_clocks[] =3D {
+	6750,
+	13500,
+	27000,
+	29700,
+	37125,
+	54000,
+	59400,
+	74250,
+	120000
+	    /*
+	     * There are more clocks, but they are disabled on the CR board.
+	     */
+};
+
+static const u32 crvml_clock_bits[] =3D {
+	0x0a,
+	0x09,
+	0x08,
+	0x07,
+	0x06,
+	0x05,
+	0x04,
+	0x03,
+	0x0b
+};
+
+static const unsigned crvml_num_clocks =3D ARRAY_SIZE(crvml_clocks);
+
+static int crvml_sys_restore(struct vml_sys *sys)
+{
+	void __iomem *clock_reg =3D mch_regs_base + CRVML_REG_CLOCK;
+
+	iowrite32(saved_clock, clock_reg);
+	ioread32(clock_reg);
+
+	return 0;
+}
+
+static int crvml_sys_save(struct vml_sys *sys)
+{
+	void __iomem *clock_reg =3D mch_regs_base + CRVML_REG_CLOCK;
+
+	saved_clock =3D ioread32(clock_reg);
+
+	return 0;
+}
+
+static int crvml_nearest_index(const struct vml_sys *sys, int clock)
+{
+	int i;
+	int cur_index =3D 0;
+	int cur_diff;
+	int diff;
+
+	cur_diff =3D clock - crvml_clocks[0];
+	cur_diff =3D (cur_diff < 0) ? -cur_diff : cur_diff;
+	for (i =3D 1; i < crvml_num_clocks; ++i) {
+		diff =3D clock - crvml_clocks[i];
+		diff =3D (diff < 0) ? -diff : diff;
+		if (diff < cur_diff) {
+			cur_index =3D i;
+			cur_diff =3D diff;
+		}
+	}
+	return cur_index;
+}
+
+static int crvml_nearest_clock(const struct vml_sys *sys, int clock)
+{
+	return crvml_clocks[crvml_nearest_index(sys, clock)];
+}
+
+static int crvml_set_clock(struct vml_sys *sys, int clock)
+{
+	void __iomem *clock_reg =3D mch_regs_base + CRVML_REG_CLOCK;
+	int index;
+	u32 clock_val;
+
+	index =3D crvml_nearest_index(sys, clock);
+
+	if (crvml_clocks[index] !=3D clock)
+		return -EINVAL;
+
+	clock_val =3D ioread32(clock_reg) & ~CRVML_CLOCK_MASK;
+	clock_val =3D crvml_clock_bits[index] << CRVML_CLOCK_SHIFT;
+	iowrite32(clock_val, clock_reg);
+	ioread32(clock_reg);
+
+	return 0;
+}
+
+static struct vml_sys cr_pll_ops =3D {
+	.name =3D "Carillo Ranch",
+	.save =3D crvml_sys_save,
+	.restore =3D crvml_sys_restore,
+	.set_clock =3D crvml_set_clock,
+	.nearest_clock =3D crvml_nearest_clock,
+};
+
+static int __init cr_pll_init(void)
+{
+	int err;
+	u32 dev_en;
+
+	mch_dev =3D pci_get_device(PCI_VENDOR_ID_INTEL,
+					CRVML_DEVICE_MCH, NULL);
+	if (!mch_dev) {
+		printk(KERN_ERR
+		       "Could not find Carillo Ranch MCH device.\n");
+		return -ENODEV;
+	}
+
+	pci_read_config_dword(mch_dev, CRVML_REG_MCHEN, &dev_en);
+	if (!(dev_en & CRVML_MCHEN_BIT)) {
+		printk(KERN_ERR
+		       "Carillo Ranch MCH device was not enabled.\n");
+		pci_dev_put(mch_dev);
+		return -ENODEV;
+	}
+
+	pci_read_config_dword(mch_dev, CRVML_REG_MCHBAR,
+			      &mch_bar);
+	mch_regs_base =3D
+	    ioremap_nocache(mch_bar, CRVML_MCHMAP_SIZE);
+	if (!mch_regs_base) {
+		printk(KERN_ERR
+		       "Carillo Ranch MCH device was not enabled.\n");
+		pci_dev_put(mch_dev);
+		return -ENODEV;
+	}
+
+	err =3D vmlfb_register_subsys(&cr_pll_ops);
+	if (err) {
+		printk(KERN_ERR
+		       "Carillo Ranch failed to initialize vml_sys.\n");
+		pci_dev_put(mch_dev);
+		return err;
+	}
+
+	return 0;
+}
+
+static void __exit cr_pll_exit(void)
+{
+	vmlfb_unregister_subsys(&cr_pll_ops);
+
+	iounmap(mch_regs_base);
+	pci_dev_put(mch_dev);
+}
+
+module_init(cr_pll_init);
+module_exit(cr_pll_exit);
+
+MODULE_AUTHOR("Tungsten Graphics Inc.");
+MODULE_DESCRIPTION("Carillo Ranch PLL Driver");
+MODULE_LICENSE("GPL");
diff -puN /dev/null drivers/video/vermilion/vermilion.c
--- /dev/null
+++ a/drivers/video/vermilion/vermilion.c
@@ -0,0 +1,1195 @@
+/*
+ * Copyright (c) Intel Corp. 2007.
+ * All Rights Reserved.
+ *
+ * Intel funded Tungsten Graphics (http://www.tungstengraphics.com) to
+ * develop this driver.
+ *
+ * This file is part of the Vermilion Range fb driver.
+ * The Vermilion Range fb driver is free software;
+ * you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * The Vermilion Range fb driver is distributed
+ * in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this driver; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-13=
01  USA
+ *
+ * Authors:
+ *   Thomas Hellstr=F6m <thomas-at-tungstengraphics-dot-com>
+ *   Michel D=E4nzer <michel-at-tungstengraphics-dot-com>
+ *   Alan Hourihane <alanh-at-tungstengraphics-dot-com>
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/delay.h>
+#include <linux/mm.h>
+#include <linux/fb.h>
+#include <linux/pci.h>
+#include <asm/cacheflush.h>
+#include <asm/tlbflush.h>
+#include <linux/mmzone.h>
+#include <asm/uaccess.h>
+
+/* #define VERMILION_DEBUG */
+
+#include "vermilion.h"
+
+#define MODULE_NAME "vmlfb"
+
+#define VML_TOHW(_val, _width) ((((_val) << (_width)) + 0x7FFF - (_val=
)) >> 16)
+
+static struct mutex vml_mutex;
+static struct list_head global_no_mode;
+static struct list_head global_has_mode;
+static struct fb_ops vmlfb_ops;
+static struct vml_sys *subsys =3D NULL;
+static char *vml_default_mode =3D "1024x768@60";
+static struct fb_videomode defaultmode =3D {
+	NULL, 60, 1024, 768, 12896, 144, 24, 29, 3, 136, 6,
+	0, FB_VMODE_NONINTERLACED
+};
+
+static u32 vml_mem_requested =3D (10 * 1024 * 1024);
+static u32 vml_mem_contig =3D (4 * 1024 * 1024);
+static u32 vml_mem_min =3D (4 * 1024 * 1024);
+
+static u32 vml_clocks[] =3D {
+	6750,
+	13500,
+	27000,
+	29700,
+	37125,
+	54000,
+	59400,
+	74250,
+	120000,
+	148500
+};
+
+static u32 vml_num_clocks =3D ARRAY_SIZE(vml_clocks);
+
+/*
+ * Allocate a contiguous vram area and make its linear kernel map
+ * uncached.
+ */
+
+static int vmlfb_alloc_vram_area(struct vram_area *va, unsigned max_or=
der,
+				 unsigned min_order)
+{
+	gfp_t flags;
+	unsigned long i;
+	pgprot_t wc_pageprot;
+
+	wc_pageprot =3D PAGE_KERNEL_NOCACHE;
+	max_order++;
+	do {
+		/*
+		 * Really try hard to get the needed memory.
+		 * We need memory below the first 32MB, so we
+		 * add the __GFP_DMA flag that guarantees that we are
+		 * below the first 16MB.
+		 */
+
+		flags =3D __GFP_DMA | __GFP_HIGH;
+		va->logical =3D
+			 __get_free_pages(flags, --max_order);
+	} while (va->logical =3D=3D 0 && max_order > min_order);
+
+	if (!va->logical)
+		return -ENOMEM;
+
+	va->phys =3D virt_to_phys((void *)va->logical);
+	va->size =3D PAGE_SIZE << max_order;
+	va->order =3D max_order;
+
+	/*
+	 * It seems like __get_free_pages only ups the usage count
+	 * of the first page. This doesn't work with nopage mapping, so
+	 * up the usage count once more.
+	 */
+
+	memset((void *)va->logical, 0x00, va->size);
+	for (i =3D va->logical; i < va->logical + va->size; i +=3D PAGE_SIZE)=
 {
+		get_page(virt_to_page(i));
+	}
+
+	/*
+	 * Change caching policy of the linear kernel map to avoid
+	 * mapping type conflicts with user-space mappings.
+	 * The first global_flush_tlb() is really only there to do a global
+	 * wbinvd().
+	 */
+
+	global_flush_tlb();
+	change_page_attr(virt_to_page(va->logical), va->size >> PAGE_SHIFT,
+			 wc_pageprot);
+	global_flush_tlb();
+
+	printk(KERN_DEBUG MODULE_NAME
+	       ": Allocated %ld bytes vram area at 0x%08lx\n",
+	       va->size, va->phys);
+
+	return 0;
+}
+
+/*
+ * Free a contiguous vram area and reset its linear kernel map
+ * mapping type.
+ */
+
+static void vmlfb_free_vram_area(struct vram_area *va)
+{
+	unsigned long j;
+
+	if (va->logical) {
+
+		/*
+		 * Reset the linear kernel map caching policy.
+		 */
+
+		change_page_attr(virt_to_page(va->logical),
+				 va->size >> PAGE_SHIFT, PAGE_KERNEL);
+		global_flush_tlb();
+
+		/*
+		 * Decrease the usage count on the pages we've used
+		 * to compensate for upping when allocating.
+		 */
+
+		for (j =3D va->logical; j < va->logical + va->size;
+		     j +=3D PAGE_SIZE) {
+			(void)put_page_testzero(virt_to_page(j));
+		}
+
+		printk(KERN_DEBUG MODULE_NAME
+		       ": Freeing %ld bytes vram area at 0x%08lx\n",
+		       va->size, va->phys);
+		free_pages(va->logical, va->order);
+
+		va->logical =3D 0;
+	}
+}
+
+/*
+ * Free allocated vram.
+ */
+
+static void vmlfb_free_vram(struct vml_info *vinfo)
+{
+	int i;
+
+	for (i =3D 0; i < vinfo->num_areas; ++i) {
+		vmlfb_free_vram_area(&vinfo->vram[i]);
+	}
+	vinfo->num_areas =3D 0;
+}
+
+/*
+ * Allocate vram. Currently we try to allocate contiguous areas from t=
he
+ * __GFP_DMA zone and puzzle them together. A better approach would be=
 to
+ * allocate one contiguous area for scanout and use one-page allocatio=
ns for
+ * offscreen areas. This requires user-space and GPU virtual mappings.
+ */
+
+static int vmlfb_alloc_vram(struct vml_info *vinfo,
+			    size_t requested,
+			    size_t min_total, size_t min_contig)
+{
+	int i, j;
+	int order;
+	int contiguous;
+	int err;
+	struct vram_area *va;
+	struct vram_area *va2;
+
+	vinfo->num_areas =3D 0;
+	for (i =3D 0; i < VML_VRAM_AREAS; ++i) {
+		va =3D &vinfo->vram[i];
+		order =3D 0;
+
+		while (requested > (PAGE_SIZE << order) && order < MAX_ORDER)
+			order++;
+
+		err =3D vmlfb_alloc_vram_area(va, order, 0);
+
+		if (err)
+			break;
+
+		if (i =3D=3D 0) {
+			vinfo->vram_start =3D va->phys;
+			vinfo->vram_logical =3D (void __iomem *) va->logical;
+			vinfo->vram_contig_size =3D va->size;
+			vinfo->num_areas =3D 1;
+		} else {
+			contiguous =3D 0;
+
+			for (j =3D 0; j < i; ++j) {
+				va2 =3D &vinfo->vram[j];
+				if (va->phys + va->size =3D=3D va2->phys ||
+				    va2->phys + va2->size =3D=3D va->phys) {
+					contiguous =3D 1;
+					break;
+				}
+			}
+
+			if (contiguous) {
+				vinfo->num_areas++;
+				if (va->phys < vinfo->vram_start) {
+					vinfo->vram_start =3D va->phys;
+					vinfo->vram_logical =3D
+						(void __iomem *)va->logical;
+				}
+				vinfo->vram_contig_size +=3D va->size;
+			} else {
+				vmlfb_free_vram_area(va);
+				break;
+			}
+		}
+
+		if (requested < va->size)
+			break;
+		else
+			requested -=3D va->size;
+	}
+
+	if (vinfo->vram_contig_size > min_total &&
+	    vinfo->vram_contig_size > min_contig) {
+
+		printk(KERN_DEBUG MODULE_NAME
+		       ": Contiguous vram: %ld bytes at physical 0x%08lx.\n",
+		       (unsigned long)vinfo->vram_contig_size,
+		       (unsigned long)vinfo->vram_start);
+
+		return 0;
+	}
+
+	printk(KERN_ERR MODULE_NAME
+	       ": Could not allocate requested minimal amount of vram.\n");
+
+	vmlfb_free_vram(vinfo);
+
+	return -ENOMEM;
+}
+
+/*
+ * Find the GPU to use with our display controller.
+ */
+
+static int vmlfb_get_gpu(struct vml_par *par)
+{
+	mutex_lock(&vml_mutex);
+
+	par->gpu =3D pci_get_device(PCI_VENDOR_ID_INTEL, VML_DEVICE_GPU, NULL=
);
+
+	if (!par->gpu) {
+		mutex_unlock(&vml_mutex);
+		return -ENODEV;
+	}
+
+	mutex_unlock(&vml_mutex);
+
+	if (pci_enable_device(par->gpu) < 0)
+		return -ENODEV;
+
+	return 0;
+}
+
+/*
+ * Find a contiguous vram area that contains a given offset from vram =
start.
+ */
+static int vmlfb_vram_offset(struct vml_info *vinfo, unsigned long off=
set)
+{
+	unsigned long aoffset;
+	unsigned i;
+
+	for (i =3D 0; i < vinfo->num_areas; ++i) {
+		aoffset =3D offset - (vinfo->vram[i].phys - vinfo->vram_start);
+
+		if (aoffset < vinfo->vram[i].size) {
+			return 0;
+		}
+	}
+
+	return -EINVAL;
+}
+
+/*
+ * Remap the MMIO register spaces of the VDC and the GPU.
+ */
+
+static int vmlfb_enable_mmio(struct vml_par *par)
+{
+	int err;
+
+	par->vdc_mem_base =3D pci_resource_start(par->vdc, 0);
+	par->vdc_mem_size =3D pci_resource_len(par->vdc, 0);
+	if (!request_mem_region(par->vdc_mem_base, par->vdc_mem_size, "vmlfb"=
)) {
+		printk(KERN_ERR MODULE_NAME
+		       ": Could not claim display controller MMIO.\n");
+		return -EBUSY;
+	}
+	par->vdc_mem =3D ioremap_nocache(par->vdc_mem_base, par->vdc_mem_size=
);
+	if (par->vdc_mem =3D=3D NULL) {
+		printk(KERN_ERR MODULE_NAME
+		       ": Could not map display controller MMIO.\n");
+		err =3D -ENOMEM;
+		goto out_err_0;
+	}
+
+	par->gpu_mem_base =3D pci_resource_start(par->gpu, 0);
+	par->gpu_mem_size =3D pci_resource_len(par->gpu, 0);
+	if (!request_mem_region(par->gpu_mem_base, par->gpu_mem_size, "vmlfb"=
)) {
+		printk(KERN_ERR MODULE_NAME ": Could not claim GPU MMIO.\n");
+		err =3D -EBUSY;
+		goto out_err_1;
+	}
+	par->gpu_mem =3D ioremap_nocache(par->gpu_mem_base, par->gpu_mem_size=
);
+	if (par->gpu_mem =3D=3D NULL) {
+		printk(KERN_ERR MODULE_NAME ": Could not map GPU MMIO.\n");
+		err =3D -ENOMEM;
+		goto out_err_2;
+	}
+
+	return 0;
+
+out_err_2:
+	release_mem_region(par->gpu_mem_base, par->gpu_mem_size);
+out_err_1:
+	iounmap(par->vdc_mem);
+out_err_0:
+	release_mem_region(par->vdc_mem_base, par->vdc_mem_size);
+	return err;
+}
+
+/*
+ * Unmap the VDC and GPU register spaces.
+ */
+
+static void vmlfb_disable_mmio(struct vml_par *par)
+{
+	iounmap(par->gpu_mem);
+	release_mem_region(par->gpu_mem_base, par->gpu_mem_size);
+	iounmap(par->vdc_mem);
+	release_mem_region(par->vdc_mem_base, par->vdc_mem_size);
+}
+
+/*
+ * Release and uninit the VDC and GPU.
+ */
+
+static void vmlfb_release_devices(struct vml_par *par)
+{
+	if (atomic_dec_and_test(&par->refcount)) {
+		pci_set_drvdata(par->vdc, NULL);
+		pci_disable_device(par->gpu);
+		pci_disable_device(par->vdc);
+	}
+}
+
+/*
+ * Free up allocated resources for a device.
+ */
+
+static void __devexit vml_pci_remove(struct pci_dev *dev)
+{
+	struct fb_info *info;
+	struct vml_info *vinfo;
+	struct vml_par *par;
+
+	info =3D pci_get_drvdata(dev);
+	if (info) {
+		vinfo =3D container_of(info, struct vml_info, info);
+		par =3D vinfo->par;
+		mutex_lock(&vml_mutex);
+		unregister_framebuffer(info);
+		fb_dealloc_cmap(&info->cmap);
+		vmlfb_free_vram(vinfo);
+		vmlfb_disable_mmio(par);
+		vmlfb_release_devices(par);
+		kfree(vinfo);
+		kfree(par);
+		mutex_unlock(&vml_mutex);
+	}
+}
+
+static void vmlfb_set_pref_pixel_format(struct fb_var_screeninfo *var)
+{
+	switch (var->bits_per_pixel) {
+	case 16:
+		var->blue.offset =3D 0;
+		var->blue.length =3D 5;
+		var->green.offset =3D 5;
+		var->green.length =3D 5;
+		var->red.offset =3D 10;
+		var->red.length =3D 5;
+		var->transp.offset =3D 15;
+		var->transp.length =3D 1;
+		break;
+	case 32:
+		var->blue.offset =3D 0;
+		var->blue.length =3D 8;
+		var->green.offset =3D 8;
+		var->green.length =3D 8;
+		var->red.offset =3D 16;
+		var->red.length =3D 8;
+		var->transp.offset =3D 24;
+		var->transp.length =3D 0;
+		break;
+	default:
+		break;
+	}
+
+	var->blue.msb_right =3D var->green.msb_right =3D
+	    var->red.msb_right =3D var->transp.msb_right =3D 0;
+}
+
+/*
+ * Device initialization.
+ * We initialize one vml_par struct per device and one vml_info
+ * struct per pipe. Currently we have only one pipe.
+ */
+
+static int __devinit vml_pci_probe(struct pci_dev *dev,
+				   const struct pci_device_id *id)
+{
+	struct vml_info *vinfo;
+	struct fb_info *info;
+	struct vml_par *par;
+	int err =3D 0;
+
+	par =3D kzalloc(sizeof(*par), GFP_KERNEL);
+	if (par =3D=3D NULL)
+		return -ENOMEM;
+
+	vinfo =3D kzalloc(sizeof(*vinfo), GFP_KERNEL);
+	if (vinfo =3D=3D NULL) {
+		err =3D -ENOMEM;
+		goto out_err_0;
+	}
+
+	vinfo->par =3D par;
+	par->vdc =3D dev;
+	atomic_set(&par->refcount, 1);
+
+	switch (id->device) {
+	case VML_DEVICE_VDC:
+		if ((err =3D vmlfb_get_gpu(par)))
+			goto out_err_1;
+		pci_set_drvdata(dev, &vinfo->info);
+		break;
+	default:
+		err =3D -ENODEV;
+		goto out_err_1;
+		break;
+	}
+
+	info =3D &vinfo->info;
+	info->flags =3D FBINFO_DEFAULT | FBINFO_PARTIAL_PAN_OK;
+
+	err =3D vmlfb_enable_mmio(par);
+	if (err)
+		goto out_err_2;
+
+	err =3D vmlfb_alloc_vram(vinfo, vml_mem_requested,
+			       vml_mem_contig, vml_mem_min);
+	if (err)
+		goto out_err_3;
+
+	strcpy(info->fix.id, "Vermilion Range");
+	info->fix.mmio_start =3D 0;
+	info->fix.mmio_len =3D 0;
+	info->fix.smem_start =3D vinfo->vram_start;
+	info->fix.smem_len =3D vinfo->vram_contig_size;
+	info->fix.type =3D FB_TYPE_PACKED_PIXELS;
+	info->fix.visual =3D FB_VISUAL_TRUECOLOR;
+	info->fix.ypanstep =3D 1;
+	info->fix.xpanstep =3D 1;
+	info->fix.ywrapstep =3D 0;
+	info->fix.accel =3D FB_ACCEL_NONE;
+	info->screen_base =3D vinfo->vram_logical;
+	info->pseudo_palette =3D vinfo->pseudo_palette;
+	info->par =3D par;
+	info->fbops =3D &vmlfb_ops;
+	info->device =3D &dev->dev;
+
+	INIT_LIST_HEAD(&vinfo->head);
+	vinfo->pipe_disabled =3D 1;
+	vinfo->cur_blank_mode =3D FB_BLANK_UNBLANK;
+
+	info->var.grayscale =3D 0;
+	info->var.bits_per_pixel =3D 16;
+	vmlfb_set_pref_pixel_format(&info->var);
+
+	if (!fb_find_mode
+	    (&info->var, info, vml_default_mode, NULL, 0, &defaultmode, 16)) =
{
+		printk(KERN_ERR MODULE_NAME ": Could not find initial mode\n");
+	}
+
+	if (fb_alloc_cmap(&info->cmap, 256, 1) < 0) {
+		err =3D -ENOMEM;
+		goto out_err_4;
+	}
+
+	err =3D register_framebuffer(info);
+	if (err) {
+		printk(KERN_ERR MODULE_NAME ": Register framebuffer error.\n");
+		goto out_err_5;
+	}
+
+	printk("Initialized vmlfb\n");
+
+	return 0;
+
+out_err_5:
+	fb_dealloc_cmap(&info->cmap);
+out_err_4:
+	vmlfb_free_vram(vinfo);
+out_err_3:
+	vmlfb_disable_mmio(par);
+out_err_2:
+	vmlfb_release_devices(par);
+out_err_1:
+	kfree(vinfo);
+out_err_0:
+	kfree(par);
+	return err;
+}
+
+static int vmlfb_open(struct fb_info *info, int user)
+{
+	/*
+	 * Save registers here?
+	 */
+	return 0;
+}
+
+static int vmlfb_release(struct fb_info *info, int user)
+{
+	/*
+	 * Restore registers here.
+	 */
+
+	return 0;
+}
+
+static int vml_nearest_clock(int clock)
+{
+
+	int i;
+	int cur_index;
+	int cur_diff;
+	int diff;
+
+	cur_index =3D 0;
+	cur_diff =3D clock - vml_clocks[0];
+	cur_diff =3D (cur_diff < 0) ? -cur_diff : cur_diff;
+	for (i =3D 1; i < vml_num_clocks; ++i) {
+		diff =3D clock - vml_clocks[i];
+		diff =3D (diff < 0) ? -diff : diff;
+		if (diff < cur_diff) {
+			cur_index =3D i;
+			cur_diff =3D diff;
+		}
+	}
+	return vml_clocks[cur_index];
+}
+
+static int vmlfb_check_var_locked(struct fb_var_screeninfo *var,
+				  struct vml_info *vinfo)
+{
+	u32 pitch;
+	u64 mem;
+	int nearest_clock;
+	int clock;
+	int clock_diff;
+	struct fb_var_screeninfo v;
+
+	v =3D *var;
+	clock =3D PICOS2KHZ(var->pixclock);
+
+	if (subsys && subsys->nearest_clock) {
+		nearest_clock =3D subsys->nearest_clock(subsys, clock);
+	} else {
+		nearest_clock =3D vml_nearest_clock(clock);
+	}
+
+	/*
+	 * Accept a 20% diff.
+	 */
+
+	clock_diff =3D nearest_clock - clock;
+	clock_diff =3D (clock_diff < 0) ? -clock_diff : clock_diff;
+	if (clock_diff > clock / 5) {
+#if 0
+		printk(KERN_DEBUG MODULE_NAME ": Diff failure. %d %d\n",clock_diff,c=
lock);
+#endif
+		return -EINVAL;
+	}
+
+	v.pixclock =3D KHZ2PICOS(nearest_clock);
+
+	if (var->xres > VML_MAX_XRES || var->yres > VML_MAX_YRES) {
+		printk(KERN_DEBUG MODULE_NAME ": Resolution failure.\n");
+		return -EINVAL;
+	}
+	if (var->xres_virtual > VML_MAX_XRES_VIRTUAL) {
+		printk(KERN_DEBUG MODULE_NAME
+		       ": Virtual resolution failure.\n");
+		return -EINVAL;
+	}
+	switch (v.bits_per_pixel) {
+	case 0 ... 16:
+		v.bits_per_pixel =3D 16;
+		break;
+	case 17 ... 32:
+		v.bits_per_pixel =3D 32;
+		break;
+	default:
+		printk(KERN_DEBUG MODULE_NAME ": Invalid bpp: %d.\n",
+		       var->bits_per_pixel);
+		return -EINVAL;
+	}
+
+	pitch =3D __ALIGN_MASK((var->xres * var->bits_per_pixel) >> 3, 0x3F);
+	mem =3D pitch * var->yres_virtual;
+	if (mem > vinfo->vram_contig_size) {
+		return -ENOMEM;
+	}
+
+	switch (v.bits_per_pixel) {
+	case 16:
+		if (var->blue.offset !=3D 0 ||
+		    var->blue.length !=3D 5 ||
+		    var->green.offset !=3D 5 ||
+		    var->green.length !=3D 5 ||
+		    var->red.offset !=3D 10 ||
+		    var->red.length !=3D 5 ||
+		    var->transp.offset !=3D 15 || var->transp.length !=3D 1) {
+			vmlfb_set_pref_pixel_format(&v);
+		}
+		break;
+	case 32:
+		if (var->blue.offset !=3D 0 ||
+		    var->blue.length !=3D 8 ||
+		    var->green.offset !=3D 8 ||
+		    var->green.length !=3D 8 ||
+		    var->red.offset !=3D 16 ||
+		    var->red.length !=3D 8 ||
+		    (var->transp.length !=3D 0 && var->transp.length !=3D 8) ||
+		    (var->transp.length =3D=3D 8 && var->transp.offset !=3D 24)) {
+			vmlfb_set_pref_pixel_format(&v);
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	*var =3D v;
+
+	return 0;
+}
+
+static int vmlfb_check_var(struct fb_var_screeninfo *var, struct fb_in=
fo *info)
+{
+	struct vml_info *vinfo =3D container_of(info, struct vml_info, info);
+	int ret;
+
+	mutex_lock(&vml_mutex);
+	ret =3D vmlfb_check_var_locked(var, vinfo);
+	mutex_unlock(&vml_mutex);
+
+	return ret;
+}
+
+static void vml_wait_vblank(struct vml_info *vinfo)
+{
+	/* Wait for vblank. For now, just wait for a 50Hz cycle (20ms)) */
+	mdelay(20);
+}
+
+static void vmlfb_disable_pipe(struct vml_info *vinfo)
+{
+	struct vml_par *par =3D vinfo->par;
+
+	/* Disable the MDVO pad */
+	VML_WRITE32(par, VML_RCOMPSTAT, 0);
+	while (!(VML_READ32(par, VML_RCOMPSTAT) & VML_MDVO_VDC_I_RCOMP)) ;
+
+	/* Disable display planes */
+	VML_WRITE32(par, VML_DSPCCNTR,
+		    VML_READ32(par, VML_DSPCCNTR) & ~VML_GFX_ENABLE);
+	(void)VML_READ32(par, VML_DSPCCNTR);
+	/* Wait for vblank for the disable to take effect */
+	vml_wait_vblank(vinfo);
+
+	/* Next, disable display pipes */
+	VML_WRITE32(par, VML_PIPEACONF, 0);
+	(void)VML_READ32(par, VML_PIPEACONF);
+
+	vinfo->pipe_disabled =3D 1;
+}
+
+#ifdef VERMILION_DEBUG
+static void vml_dump_regs(struct vml_info *vinfo)
+{
+	struct vml_par *par =3D vinfo->par;
+
+	printk(KERN_DEBUG MODULE_NAME ": Modesetting register dump:\n");
+	printk(KERN_DEBUG MODULE_NAME ": \tHTOTAL_A         : 0x%08x\n",
+	       (unsigned)VML_READ32(par, VML_HTOTAL_A));
+	printk(KERN_DEBUG MODULE_NAME ": \tHBLANK_A         : 0x%08x\n",
+	       (unsigned)VML_READ32(par, VML_HBLANK_A));
+	printk(KERN_DEBUG MODULE_NAME ": \tHSYNC_A          : 0x%08x\n",
+	       (unsigned)VML_READ32(par, VML_HSYNC_A));
+	printk(KERN_DEBUG MODULE_NAME ": \tVTOTAL_A         : 0x%08x\n",
+	       (unsigned)VML_READ32(par, VML_VTOTAL_A));
+	printk(KERN_DEBUG MODULE_NAME ": \tVBLANK_A         : 0x%08x\n",
+	       (unsigned)VML_READ32(par, VML_VBLANK_A));
+	printk(KERN_DEBUG MODULE_NAME ": \tVSYNC_A          : 0x%08x\n",
+	       (unsigned)VML_READ32(par, VML_VSYNC_A));
+	printk(KERN_DEBUG MODULE_NAME ": \tDSPCSTRIDE       : 0x%08x\n",
+	       (unsigned)VML_READ32(par, VML_DSPCSTRIDE));
+	printk(KERN_DEBUG MODULE_NAME ": \tDSPCSIZE         : 0x%08x\n",
+	       (unsigned)VML_READ32(par, VML_DSPCSIZE));
+	printk(KERN_DEBUG MODULE_NAME ": \tDSPCPOS          : 0x%08x\n",
+	       (unsigned)VML_READ32(par, VML_DSPCPOS));
+	printk(KERN_DEBUG MODULE_NAME ": \tDSPARB           : 0x%08x\n",
+	       (unsigned)VML_READ32(par, VML_DSPARB));
+	printk(KERN_DEBUG MODULE_NAME ": \tDSPCADDR         : 0x%08x\n",
+	       (unsigned)VML_READ32(par, VML_DSPCADDR));
+	printk(KERN_DEBUG MODULE_NAME ": \tBCLRPAT_A        : 0x%08x\n",
+	       (unsigned)VML_READ32(par, VML_BCLRPAT_A));
+	printk(KERN_DEBUG MODULE_NAME ": \tCANVSCLR_A       : 0x%08x\n",
+	       (unsigned)VML_READ32(par, VML_CANVSCLR_A));
+	printk(KERN_DEBUG MODULE_NAME ": \tPIPEASRC         : 0x%08x\n",
+	       (unsigned)VML_READ32(par, VML_PIPEASRC));
+	printk(KERN_DEBUG MODULE_NAME ": \tPIPEACONF        : 0x%08x\n",
+	       (unsigned)VML_READ32(par, VML_PIPEACONF));
+	printk(KERN_DEBUG MODULE_NAME ": \tDSPCCNTR         : 0x%08x\n",
+	       (unsigned)VML_READ32(par, VML_DSPCCNTR));
+	printk(KERN_DEBUG MODULE_NAME ": \tRCOMPSTAT        : 0x%08x\n",
+	       (unsigned)VML_READ32(par, VML_RCOMPSTAT));
+	printk(KERN_DEBUG MODULE_NAME ": End of modesetting register dump.\n"=
);
+}
+#endif
+
+static int vmlfb_set_par_locked(struct vml_info *vinfo)
+{
+	struct vml_par *par =3D vinfo->par;
+	struct fb_info *info =3D &vinfo->info;
+	struct fb_var_screeninfo *var =3D &info->var;
+	u32 htotal, hactive, hblank_start, hblank_end, hsync_start, hsync_end=
;
+	u32 vtotal, vactive, vblank_start, vblank_end, vsync_start, vsync_end=
;
+	u32 dspcntr;
+	int clock;
+
+	vinfo->bytes_per_pixel =3D var->bits_per_pixel >> 3;
+	vinfo->stride =3D
+	    __ALIGN_MASK(var->xres_virtual * vinfo->bytes_per_pixel, 0x3F);
+	info->fix.line_length =3D vinfo->stride;
+
+	if (!subsys)
+		return 0;
+
+	htotal =3D
+	    var->xres + var->right_margin + var->hsync_len + var->left_margin=
;
+	hactive =3D var->xres;
+	hblank_start =3D var->xres;
+	hblank_end =3D htotal;
+	hsync_start =3D hactive + var->right_margin;
+	hsync_end =3D hsync_start + var->hsync_len;
+
+	vtotal =3D
+	    var->yres + var->lower_margin + var->vsync_len + var->upper_margi=
n;
+	vactive =3D var->yres;
+	vblank_start =3D var->yres;
+	vblank_end =3D vtotal;
+	vsync_start =3D vactive + var->lower_margin;
+	vsync_end =3D vsync_start + var->vsync_len;
+
+	dspcntr =3D VML_GFX_ENABLE | VML_GFX_GAMMABYPASS;
+	clock =3D PICOS2KHZ(var->pixclock);
+
+	if (subsys->nearest_clock) {
+		clock =3D subsys->nearest_clock(subsys, clock);
+	} else {
+		clock =3D vml_nearest_clock(clock);
+	}
+	printk(KERN_DEBUG MODULE_NAME
+	       ": Set mode Hfreq : %d kHz, Vfreq : %d Hz.\n", clock / htotal,
+	       ((clock / htotal) * 1000) / vtotal);
+
+	switch (var->bits_per_pixel) {
+	case 16:
+		dspcntr |=3D VML_GFX_ARGB1555;
+		break;
+	case 32:
+		if (var->transp.length =3D=3D 8)
+			dspcntr |=3D VML_GFX_ARGB8888 | VML_GFX_ALPHAMULT;
+		else
+			dspcntr |=3D VML_GFX_RGB0888;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	vmlfb_disable_pipe(vinfo);
+	mb();
+
+	if (subsys->set_clock)
+		subsys->set_clock(subsys, clock);
+	else
+		return -EINVAL;
+
+	VML_WRITE32(par, VML_HTOTAL_A, ((htotal - 1) << 16) | (hactive - 1));
+	VML_WRITE32(par, VML_HBLANK_A,
+		    ((hblank_end - 1) << 16) | (hblank_start - 1));
+	VML_WRITE32(par, VML_HSYNC_A,
+		    ((hsync_end - 1) << 16) | (hsync_start - 1));
+	VML_WRITE32(par, VML_VTOTAL_A, ((vtotal - 1) << 16) | (vactive - 1));
+	VML_WRITE32(par, VML_VBLANK_A,
+		    ((vblank_end - 1) << 16) | (vblank_start - 1));
+	VML_WRITE32(par, VML_VSYNC_A,
+		    ((vsync_end - 1) << 16) | (vsync_start - 1));
+	VML_WRITE32(par, VML_DSPCSTRIDE, vinfo->stride);
+	VML_WRITE32(par, VML_DSPCSIZE,
+		    ((var->yres - 1) << 16) | (var->xres - 1));
+	VML_WRITE32(par, VML_DSPCPOS, 0x00000000);
+	VML_WRITE32(par, VML_DSPARB, VML_FIFO_DEFAULT);
+	VML_WRITE32(par, VML_BCLRPAT_A, 0x00000000);
+	VML_WRITE32(par, VML_CANVSCLR_A, 0x00000000);
+	VML_WRITE32(par, VML_PIPEASRC,
+		    ((var->xres - 1) << 16) | (var->yres - 1));
+
+	wmb();
+	VML_WRITE32(par, VML_PIPEACONF, VML_PIPE_ENABLE);
+	wmb();
+	VML_WRITE32(par, VML_DSPCCNTR, dspcntr);
+	wmb();
+	VML_WRITE32(par, VML_DSPCADDR, (u32) vinfo->vram_start +
+		    var->yoffset * vinfo->stride +
+		    var->xoffset * vinfo->bytes_per_pixel);
+
+	VML_WRITE32(par, VML_RCOMPSTAT, VML_MDVO_PAD_ENABLE);
+
+	while (!(VML_READ32(par, VML_RCOMPSTAT) &
+		 (VML_MDVO_VDC_I_RCOMP | VML_MDVO_PAD_ENABLE))) ;
+
+	vinfo->pipe_disabled =3D 0;
+#ifdef VERMILION_DEBUG
+	vml_dump_regs(vinfo);
+#endif
+
+	return 0;
+}
+
+static int vmlfb_set_par(struct fb_info *info)
+{
+	struct vml_info *vinfo =3D container_of(info, struct vml_info, info);
+	int ret;
+
+	mutex_lock(&vml_mutex);
+	list_del(&vinfo->head);
+	list_add(&vinfo->head, (subsys) ? &global_has_mode : &global_no_mode)=
;
+	ret =3D vmlfb_set_par_locked(vinfo);
+
+	mutex_unlock(&vml_mutex);
+	return ret;
+}
+
+static int vmlfb_blank_locked(struct vml_info *vinfo)
+{
+	struct vml_par *par =3D vinfo->par;
+	u32 cur =3D VML_READ32(par, VML_PIPEACONF);
+
+	switch (vinfo->cur_blank_mode) {
+	case FB_BLANK_UNBLANK:
+		if (vinfo->pipe_disabled) {
+			vmlfb_set_par_locked(vinfo);
+		}
+		VML_WRITE32(par, VML_PIPEACONF, cur & ~VML_PIPE_FORCE_BORDER);
+		(void)VML_READ32(par, VML_PIPEACONF);
+		break;
+	case FB_BLANK_NORMAL:
+		if (vinfo->pipe_disabled) {
+			vmlfb_set_par_locked(vinfo);
+		}
+		VML_WRITE32(par, VML_PIPEACONF, cur | VML_PIPE_FORCE_BORDER);
+		(void)VML_READ32(par, VML_PIPEACONF);
+		break;
+	case FB_BLANK_VSYNC_SUSPEND:
+	case FB_BLANK_HSYNC_SUSPEND:
+		if (!vinfo->pipe_disabled) {
+			vmlfb_disable_pipe(vinfo);
+		}
+		break;
+	case FB_BLANK_POWERDOWN:
+		if (!vinfo->pipe_disabled) {
+			vmlfb_disable_pipe(vinfo);
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int vmlfb_blank(int blank_mode, struct fb_info *info)
+{
+	struct vml_info *vinfo =3D container_of(info, struct vml_info, info);
+	int ret;
+
+	mutex_lock(&vml_mutex);
+	vinfo->cur_blank_mode =3D blank_mode;
+	ret =3D vmlfb_blank_locked(vinfo);
+	mutex_unlock(&vml_mutex);
+	return ret;
+}
+
+static int vmlfb_pan_display(struct fb_var_screeninfo *var,
+			     struct fb_info *info)
+{
+	struct vml_info *vinfo =3D container_of(info, struct vml_info, info);
+	struct vml_par *par =3D vinfo->par;
+
+	mutex_lock(&vml_mutex);
+	VML_WRITE32(par, VML_DSPCADDR, (u32) vinfo->vram_start +
+		    var->yoffset * vinfo->stride +
+		    var->xoffset * vinfo->bytes_per_pixel);
+	(void)VML_READ32(par, VML_DSPCADDR);
+	mutex_unlock(&vml_mutex);
+
+	return 0;
+}
+
+static int vmlfb_setcolreg(u_int regno, u_int red, u_int green, u_int =
blue,
+			   u_int transp, struct fb_info *info)
+{
+	u32 v;
+
+	if (regno >=3D 16)
+		return -EINVAL;
+
+	if (info->var.grayscale) {
+		red =3D green =3D blue =3D (red * 77 + green * 151 + blue * 28) >> 8=
;
+	}
+
+	if (info->fix.visual !=3D FB_VISUAL_TRUECOLOR)
+		return -EINVAL;
+
+	red =3D VML_TOHW(red, info->var.red.length);
+	blue =3D VML_TOHW(blue, info->var.blue.length);
+	green =3D VML_TOHW(green, info->var.green.length);
+	transp =3D VML_TOHW(transp, info->var.transp.length);
+
+	v =3D (red << info->var.red.offset) |
+	    (green << info->var.green.offset) |
+	    (blue << info->var.blue.offset) |
+	    (transp << info->var.transp.offset);
+
+	switch (info->var.bits_per_pixel) {
+	case 16:
+		((u32 *) info->pseudo_palette)[regno] =3D v;
+		break;
+	case 24:
+	case 32:
+		((u32 *) info->pseudo_palette)[regno] =3D v;
+		break;
+	}
+	return 0;
+}
+
+static int vmlfb_mmap(struct fb_info *info, struct vm_area_struct *vma=
)
+{
+	struct vml_info *vinfo =3D container_of(info, struct vml_info, info);
+	unsigned long size =3D vma->vm_end - vma->vm_start;
+	unsigned long offset =3D vma->vm_pgoff << PAGE_SHIFT;
+	int ret;
+
+	if (vma->vm_pgoff > (~0UL >> PAGE_SHIFT))
+		return -EINVAL;
+	if (offset + size > vinfo->vram_contig_size)
+		return -EINVAL;
+	ret =3D vmlfb_vram_offset(vinfo, offset);
+	if (ret)
+		return -EINVAL;
+	offset +=3D vinfo->vram_start;
+	pgprot_val(vma->vm_page_prot) |=3D _PAGE_PCD;
+	pgprot_val(vma->vm_page_prot) &=3D ~_PAGE_PWT;
+	vma->vm_flags |=3D VM_RESERVED | VM_IO;
+	if (remap_pfn_range(vma, vma->vm_start, offset >> PAGE_SHIFT,
+						size, vma->vm_page_prot))
+		return -EAGAIN;
+	return 0;
+}
+
+static int vmlfb_sync(struct fb_info *info)
+{
+	return 0;
+}
+
+static int vmlfb_cursor(struct fb_info *info, struct fb_cursor *cursor=
)
+{
+	return -EINVAL;	/* just to force soft_cursor() call */
+}
+
+static struct fb_ops vmlfb_ops =3D {
+	.owner =3D THIS_MODULE,
+	.fb_open =3D vmlfb_open,
+	.fb_release =3D vmlfb_release,
+	.fb_check_var =3D vmlfb_check_var,
+	.fb_set_par =3D vmlfb_set_par,
+	.fb_blank =3D vmlfb_blank,
+	.fb_pan_display =3D vmlfb_pan_display,
+	.fb_fillrect =3D cfb_fillrect,
+	.fb_copyarea =3D cfb_copyarea,
+	.fb_imageblit =3D cfb_imageblit,
+	.fb_cursor =3D vmlfb_cursor,
+	.fb_sync =3D vmlfb_sync,
+	.fb_mmap =3D vmlfb_mmap,
+	.fb_setcolreg =3D vmlfb_setcolreg
+};
+
+static struct pci_device_id vml_ids[] =3D {
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, VML_DEVICE_VDC)},
+	{0}
+};
+
+static struct pci_driver vmlfb_pci_driver =3D {
+	.name =3D "vmlfb",
+	.id_table =3D vml_ids,
+	.probe =3D vml_pci_probe,
+	.remove =3D __devexit_p(vml_pci_remove)
+};
+
+static void __exit vmlfb_cleanup(void)
+{
+	pci_unregister_driver(&vmlfb_pci_driver);
+}
+
+static int __init vmlfb_init(void)
+{
+
+#ifndef MODULE
+	char *option =3D NULL;
+
+	if (fb_get_options(MODULE_NAME, &option))
+		return -ENODEV;
+#endif
+
+	printk(KERN_DEBUG MODULE_NAME ": initializing\n");
+	mutex_init(&vml_mutex);
+	INIT_LIST_HEAD(&global_no_mode);
+	INIT_LIST_HEAD(&global_has_mode);
+
+	return pci_register_driver(&vmlfb_pci_driver);
+}
+
+int vmlfb_register_subsys(struct vml_sys *sys)
+{
+	struct vml_info *entry;
+	struct list_head *list;
+	u32 save_activate;
+
+	mutex_lock(&vml_mutex);
+	if (subsys !=3D NULL) {
+		subsys->restore(subsys);
+	}
+	subsys =3D sys;
+	subsys->save(subsys);
+
+	/*
+	 * We need to restart list traversal for each item, since we
+	 * release the list mutex in the loop.
+	 */
+
+	list =3D global_no_mode.next;
+	while (list !=3D &global_no_mode) {
+		list_del_init(list);
+		entry =3D list_entry(list, struct vml_info, head);
+
+		/*
+		 * First, try the current mode which might not be
+		 * completely validated with respect to the pixel clock.
+		 */
+
+		if (!vmlfb_check_var_locked(&entry->info.var, entry)) {
+			vmlfb_set_par_locked(entry);
+			list_add_tail(list, &global_has_mode);
+		} else {
+
+			/*
+			 * Didn't work. Try to find another mode,
+			 * that matches this subsys.
+			 */
+
+			mutex_unlock(&vml_mutex);
+			save_activate =3D entry->info.var.activate;
+			entry->info.var.bits_per_pixel =3D 16;
+			vmlfb_set_pref_pixel_format(&entry->info.var);
+			if (fb_find_mode(&entry->info.var,
+					 &entry->info,
+					 vml_default_mode, NULL, 0, NULL, 16)) {
+				entry->info.var.activate |=3D
+				    FB_ACTIVATE_FORCE | FB_ACTIVATE_NOW;
+				fb_set_var(&entry->info, &entry->info.var);
+			} else {
+				printk(KERN_ERR MODULE_NAME
+				       ": Sorry. no mode found for this subsys.\n");
+			}
+			entry->info.var.activate =3D save_activate;
+			mutex_lock(&vml_mutex);
+		}
+		vmlfb_blank_locked(entry);
+		list =3D global_no_mode.next;
+	}
+	mutex_unlock(&vml_mutex);
+
+	printk(KERN_DEBUG MODULE_NAME ": Registered %s subsystem.\n",
+				subsys->name ? subsys->name : "unknown");
+	return 0;
+}
+
+EXPORT_SYMBOL_GPL(vmlfb_register_subsys);
+
+void vmlfb_unregister_subsys(struct vml_sys *sys)
+{
+	struct vml_info *entry, *next;
+
+	mutex_lock(&vml_mutex);
+	if (subsys !=3D sys) {
+		mutex_unlock(&vml_mutex);
+		return;
+	}
+	subsys->restore(subsys);
+	subsys =3D NULL;
+	list_for_each_entry_safe(entry, next, &global_has_mode, head) {
+		printk(KERN_DEBUG MODULE_NAME ": subsys disable pipe\n");
+		vmlfb_disable_pipe(entry);
+		list_del(&entry->head);
+		list_add_tail(&entry->head, &global_no_mode);
+	}
+	mutex_unlock(&vml_mutex);
+}
+
+EXPORT_SYMBOL_GPL(vmlfb_unregister_subsys);
+
+module_init(vmlfb_init);
+module_exit(vmlfb_cleanup);
+
+MODULE_AUTHOR("Tungsten Graphics");
+MODULE_DESCRIPTION("Initialization of the Vermilion display devices");
+MODULE_VERSION("1.0.0");
+MODULE_LICENSE("GPL");
diff -puN /dev/null drivers/video/vermilion/vermilion.h
--- /dev/null
+++ a/drivers/video/vermilion/vermilion.h
@@ -0,0 +1,260 @@
+/*
+ * Copyright (c) Intel Corp. 2007.
+ * All Rights Reserved.
+ *
+ * Intel funded Tungsten Graphics (http://www.tungstengraphics.com) to
+ * develop this driver.
+ *
+ * This file is part of the Vermilion Range fb driver.
+ * The Vermilion Range fb driver is free software;
+ * you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * The Vermilion Range fb driver is distributed
+ * in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this driver; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-13=
01  USA
+ *
+ * Authors:
+ *   Thomas Hellstr=F6m <thomas-at-tungstengraphics-dot-com>
+ */
+
+#ifndef _VERMILION_H_
+#define _VERMILION_H_
+
+#include <linux/kernel.h>
+#include <linux/version.h>
+#include <linux/pci.h>
+#include <asm/atomic.h>
+#include <linux/mutex.h>
+
+#define VML_DEVICE_GPU 0x5002
+#define VML_DEVICE_VDC 0x5009
+
+#define VML_VRAM_AREAS 3
+#define VML_MAX_XRES 1024
+#define VML_MAX_YRES 768
+#define VML_MAX_XRES_VIRTUAL 1040
+
+/*
+ * Display controller registers:
+ */
+
+/* Display controller 10-bit color representation */
+
+#define VML_R_MASK                   0x3FF00000
+#define VML_R_SHIFT                  20
+#define VML_G_MASK                   0x000FFC00
+#define VML_G_SHIFT                  10
+#define VML_B_MASK                   0x000003FF
+#define VML_B_SHIFT                  0
+
+/* Graphics plane control */
+#define VML_DSPCCNTR                 0x00072180
+#define VML_GFX_ENABLE               0x80000000
+#define VML_GFX_GAMMABYPASS          0x40000000
+#define VML_GFX_ARGB1555             0x0C000000
+#define VML_GFX_RGB0888              0x18000000
+#define VML_GFX_ARGB8888             0x1C000000
+#define VML_GFX_ALPHACONST           0x02000000
+#define VML_GFX_ALPHAMULT            0x01000000
+#define VML_GFX_CONST_ALPHA          0x000000FF
+
+/* Graphics plane start address. Pixel aligned. */
+#define VML_DSPCADDR                 0x00072184
+
+/* Graphics plane stride register. */
+#define VML_DSPCSTRIDE               0x00072188
+
+/* Graphics plane position register. */
+#define VML_DSPCPOS                  0x0007218C
+#define VML_POS_YMASK                0x0FFF0000
+#define VML_POS_YSHIFT               16
+#define VML_POS_XMASK                0x00000FFF
+#define VML_POS_XSHIFT               0
+
+/* Graphics plane height and width */
+#define VML_DSPCSIZE                 0x00072190
+#define VML_SIZE_HMASK               0x0FFF0000
+#define VML_SIZE_HSHIFT              16
+#define VML_SISE_WMASK               0x00000FFF
+#define VML_SIZE_WSHIFT              0
+
+/* Graphics plane gamma correction lookup table registers (129 * 32 bi=
ts) */
+#define VML_DSPCGAMLUT               0x00072200
+
+/* Pixel video output configuration register */
+#define VML_PVOCONFIG                0x00061140
+#define VML_CONFIG_BASE              0x80000000
+#define VML_CONFIG_PIXEL_SWAP        0x04000000
+#define VML_CONFIG_DE_INV            0x01000000
+#define VML_CONFIG_HREF_INV          0x00400000
+#define VML_CONFIG_VREF_INV          0x00100000
+#define VML_CONFIG_CLK_INV           0x00040000
+#define VML_CONFIG_CLK_DIV2          0x00010000
+#define VML_CONFIG_ESTRB_INV         0x00008000
+
+/* Pipe A Horizontal total register */
+#define VML_HTOTAL_A                 0x00060000
+#define VML_HTOTAL_MASK              0x1FFF0000
+#define VML_HTOTAL_SHIFT             16
+#define VML_HTOTAL_VAL               8192
+#define VML_HACTIVE_MASK             0x000007FF
+#define VML_HACTIVE_SHIFT            0
+#define VML_HACTIVE_VAL              4096
+
+/* Pipe A Horizontal Blank register */
+#define VML_HBLANK_A                 0x00060004
+#define VML_HBLANK_END_MASK          0x1FFF0000
+#define VML_HBLANK_END_SHIFT         16
+#define VML_HBLANK_END_VAL           8192
+#define VML_HBLANK_START_MASK        0x00001FFF
+#define VML_HBLANK_START_SHIFT       0
+#define VML_HBLANK_START_VAL         8192
+
+/* Pipe A Horizontal Sync register */
+#define VML_HSYNC_A                  0x00060008
+#define VML_HSYNC_END_MASK           0x1FFF0000
+#define VML_HSYNC_END_SHIFT          16
+#define VML_HSYNC_END_VAL            8192
+#define VML_HSYNC_START_MASK         0x00001FFF
+#define VML_HSYNC_START_SHIFT        0
+#define VML_HSYNC_START_VAL          8192
+
+/* Pipe A Vertical total register */
+#define VML_VTOTAL_A                 0x0006000C
+#define VML_VTOTAL_MASK              0x1FFF0000
+#define VML_VTOTAL_SHIFT             16
+#define VML_VTOTAL_VAL               8192
+#define VML_VACTIVE_MASK             0x000007FF
+#define VML_VACTIVE_SHIFT            0
+#define VML_VACTIVE_VAL              4096
+
+/* Pipe A Vertical Blank register */
+#define VML_VBLANK_A                 0x00060010
+#define VML_VBLANK_END_MASK          0x1FFF0000
+#define VML_VBLANK_END_SHIFT         16
+#define VML_VBLANK_END_VAL           8192
+#define VML_VBLANK_START_MASK        0x00001FFF
+#define VML_VBLANK_START_SHIFT       0
+#define VML_VBLANK_START_VAL         8192
+
+/* Pipe A Vertical Sync register */
+#define VML_VSYNC_A                  0x00060014
+#define VML_VSYNC_END_MASK           0x1FFF0000
+#define VML_VSYNC_END_SHIFT          16
+#define VML_VSYNC_END_VAL            8192
+#define VML_VSYNC_START_MASK         0x00001FFF
+#define VML_VSYNC_START_SHIFT        0
+#define VML_VSYNC_START_VAL          8192
+
+/* Pipe A Source Image size (minus one - equal to active size)
+ * Programmable while pipe is enabled.
+ */
+#define VML_PIPEASRC                 0x0006001C
+#define VML_PIPEASRC_HMASK           0x0FFF0000
+#define VML_PIPEASRC_HSHIFT          16
+#define VML_PIPEASRC_VMASK           0x00000FFF
+#define VML_PIPEASRC_VSHIFT          0
+
+/* Pipe A Border Color Pattern register (10 bit color) */
+#define VML_BCLRPAT_A                0x00060020
+
+/* Pipe A Canvas Color register  (10 bit color) */
+#define VML_CANVSCLR_A               0x00060024
+
+/* Pipe A Configuration register */
+#define VML_PIPEACONF                0x00070008
+#define VML_PIPE_BASE                0x00000000
+#define VML_PIPE_ENABLE              0x80000000
+#define VML_PIPE_FORCE_BORDER        0x02000000
+#define VML_PIPE_PLANES_OFF          0x00080000
+#define VML_PIPE_ARGB_OUTPUT_MODE    0x00040000
+
+/* Pipe A FIFO setting */
+#define VML_DSPARB                   0x00070030
+#define VML_FIFO_DEFAULT             0x00001D9C
+
+/* MDVO rcomp status & pads control register */
+#define VML_RCOMPSTAT                0x00070048
+#define VML_MDVO_VDC_I_RCOMP         0x80000000
+#define VML_MDVO_POWERSAVE_OFF       0x00000008
+#define VML_MDVO_PAD_ENABLE          0x00000004
+#define VML_MDVO_PULLDOWN_ENABLE     0x00000001
+
+struct vml_par {
+	struct pci_dev *vdc;
+	u64 vdc_mem_base;
+	u64 vdc_mem_size;
+	char __iomem *vdc_mem;
+
+	struct pci_dev *gpu;
+	u64 gpu_mem_base;
+	u64 gpu_mem_size;
+	char __iomem *gpu_mem;
+
+	atomic_t refcount;
+};
+
+struct vram_area {
+	unsigned long logical;
+	unsigned long phys;
+	unsigned long size;
+	unsigned order;
+};
+
+struct vml_info {
+	struct fb_info info;
+	struct vml_par *par;
+	struct list_head head;
+	struct vram_area vram[VML_VRAM_AREAS];
+	u64 vram_start;
+	u64 vram_contig_size;
+	u32 num_areas;
+	void __iomem *vram_logical;
+	u32 pseudo_palette[16];
+	u32 stride;
+	u32 bytes_per_pixel;
+	atomic_t vmas;
+	int cur_blank_mode;
+	int pipe_disabled;
+};
+
+/*
+ * Subsystem
+ */
+
+struct vml_sys {
+	char *name;
+
+	/*
+	 * Save / Restore;
+	 */
+
+	int (*save) (struct vml_sys * sys);
+	int (*restore) (struct vml_sys * sys);
+
+	/*
+	 * PLL programming;
+	 */
+
+	int (*set_clock) (struct vml_sys * sys, int clock);
+	int (*nearest_clock) (const struct vml_sys * sys, int clock);
+};
+
+extern int vmlfb_register_subsys(struct vml_sys *sys);
+extern void vmlfb_unregister_subsys(struct vml_sys *sys);
+
+#define VML_READ32(_par, _offset) \
+	(ioread32((_par)->vdc_mem + (_offset)))
+#define VML_WRITE32(_par, _offset, _value)				\
+	iowrite32(_value, (_par)->vdc_mem + (_offset))
+
+#endif
_

Patches currently in -mm which might be from alanh@fairlite.demon.co.uk=
 are

origin.patch
