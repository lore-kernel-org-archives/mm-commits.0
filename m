From: akpm@linux-foundation.org
Subject: - fbdev-platforming-hecubafb-and-n411-v4.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:59:31 -0700
Message-ID: <200804282159.m3SLxVBu018595@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44050 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965488AbYD1V7n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:59:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jayakumar.lkml@gmail.com, adaplas@pol.net, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     fbdev: platforming hecubafb and n411
has been removed from the -mm tree.  Its filename was
     fbdev-platforming-hecubafb-and-n411-v4.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: platforming hecubafb and n411
From: Jaya Kumar <jayakumar.lkml@gmail.com>

This patch splits hecubafb into the platform independent hecubafb and the
platform dependent n411.

Signed-off-by: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig    |   17 +-
 drivers/video/hecubafb.c |  250 +++++++------------------------------
 drivers/video/n411.c     |  202 +++++++++++++++++++++++++++++
 include/video/hecubafb.h |   51 +++++++
 4 files changed, 314 insertions(+), 206 deletions(-)

diff -puN drivers/video/Kconfig~fbdev-platforming-hecubafb-and-n411-v4 drivers/video/Kconfig
--- a/drivers/video/Kconfig~fbdev-platforming-hecubafb-and-n411-v4
+++ a/drivers/video/Kconfig
@@ -178,6 +178,11 @@ config FB_METRONOME
 	depends on FB
 	depends on FB_DEFERRED_IO
 
+config FB_HECUBA
+	tristate
+	depends on FB
+	depends on FB_DEFERRED_IO
+
 config FB_SVGALIB
 	tristate
 	depends on FB
@@ -703,20 +708,18 @@ config FB_IMAC
 	help
 	  This is the frame buffer device driver for the Intel-based Macintosh
 
-config FB_HECUBA
-       tristate "Hecuba board support"
+config FB_N411
+       tristate "N411 Apollo/Hecuba devkit support"
        depends on FB && X86 && MMU
        select FB_SYS_FILLRECT
        select FB_SYS_COPYAREA
        select FB_SYS_IMAGEBLIT
        select FB_SYS_FOPS
        select FB_DEFERRED_IO
+       select FB_HECUBA
        help
-         This enables support for the Hecuba board. This driver was tested
-         with an E-Ink 800x600 display and x86 SBCs through a 16 bit GPIO
-         interface (8 bit data, 4 bit control). If you anticipate using
-         this driver, say Y or M; otherwise say N. You must specify the
-         GPIO IO address to be used for setting control and data.
+         This enables support for the Apollo display controller in its
+         Hecuba form using the n411 devkit.
 
 config FB_HGA
 	tristate "Hercules mono graphics support"
diff -puN drivers/video/hecubafb.c~fbdev-platforming-hecubafb-and-n411-v4 drivers/video/hecubafb.c
--- a/drivers/video/hecubafb.c~fbdev-platforming-hecubafb-and-n411-v4
+++ a/drivers/video/hecubafb.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/video/hecubafb.c -- FB driver for Hecuba controller
+ * linux/drivers/video/hecubafb.c -- FB driver for Hecuba/Apollo controller
  *
  * Copyright (C) 2006, Jaya Kumar
  * This work was sponsored by CIS(M) Sdn Bhd
@@ -17,18 +17,13 @@
  * values. There are other commands that the display is capable of,
  * beyond the 5 used here but they are more complex.
  *
- * This driver is written to be used with the Hecuba display controller
- * board, and tested with the EInk 800x600 display in 1 bit mode.
- * The interface between Hecuba and the host is TTL based GPIO. The
- * GPIO requirements are 8 writable data lines and 6 lines for control.
- * Only 4 of the controls are actually used here but 6 for future use.
- * The driver requires the IO addresses for data and control GPIO at
- * load time. It is also possible to use this display with a standard
- * PC parallel port.
+ * This driver is written to be used with the Hecuba display architecture.
+ * The actual display chip is called Apollo and the interface electronics
+ * it needs is called Hecuba.
  *
- * General notes:
- * - User must set hecubafb_enable=1 to enable it
- * - User must set dio_addr=0xIOADDR cio_addr=0xIOADDR c2io_addr=0xIOADDR
+ * It is intended to be architecture independent. A board specific driver
+ * must be used to perform all the physical IO interactions. An example
+ * is provided as n411.c
  *
  */
 
@@ -47,34 +42,12 @@
 #include <linux/list.h>
 #include <linux/uaccess.h>
 
-/* Apollo controller specific defines */
-#define APOLLO_START_NEW_IMG	0xA0
-#define APOLLO_STOP_IMG_DATA	0xA1
-#define APOLLO_DISPLAY_IMG	0xA2
-#define APOLLO_ERASE_DISPLAY	0xA3
-#define APOLLO_INIT_DISPLAY	0xA4
-
-/* Hecuba interface specific defines */
-/* WUP is inverted, CD is inverted, DS is inverted */
-#define HCB_NWUP_BIT	0x01
-#define HCB_NDS_BIT 	0x02
-#define HCB_RW_BIT 	0x04
-#define HCB_NCD_BIT 	0x08
-#define HCB_ACK_BIT 	0x80
+#include <video/hecubafb.h>
 
 /* Display specific information */
 #define DPY_W 600
 #define DPY_H 800
 
-struct hecubafb_par {
-	unsigned long dio_addr;
-	unsigned long cio_addr;
-	unsigned long c2io_addr;
-	unsigned char ctl;
-	struct fb_info *info;
-	unsigned int irq;
-};
-
 static struct fb_fix_screeninfo hecubafb_fix __devinitdata = {
 	.id =		"hecubafb",
 	.type =		FB_TYPE_PACKED_PIXELS,
@@ -82,6 +55,7 @@ static struct fb_fix_screeninfo hecubafb
 	.xpanstep =	0,
 	.ypanstep =	0,
 	.ywrapstep =	0,
+	.line_length =	DPY_W,
 	.accel =	FB_ACCEL_NONE,
 };
 
@@ -94,136 +68,51 @@ static struct fb_var_screeninfo hecubafb
 	.nonstd		= 1,
 };
 
-static unsigned long dio_addr;
-static unsigned long cio_addr;
-static unsigned long c2io_addr;
-static unsigned long splashval;
-static unsigned int nosplash;
-static unsigned int hecubafb_enable;
-static unsigned int irq;
-
-static DECLARE_WAIT_QUEUE_HEAD(hecubafb_waitq);
-
-static void hcb_set_ctl(struct hecubafb_par *par)
-{
-	outb(par->ctl, par->cio_addr);
-}
-
-static unsigned char hcb_get_ctl(struct hecubafb_par *par)
-{
-	return inb(par->c2io_addr);
-}
-
-static void hcb_set_data(struct hecubafb_par *par, unsigned char value)
-{
-	outb(value, par->dio_addr);
-}
-
-static int __devinit apollo_init_control(struct hecubafb_par *par)
-{
-	unsigned char ctl;
-	/* for init, we want the following setup to be set:
-	WUP = lo
-	ACK = hi
-	DS = hi
-	RW = hi
-	CD = lo
-	*/
-
-	/* write WUP to lo, DS to hi, RW to hi, CD to lo */
-	par->ctl = HCB_NWUP_BIT | HCB_RW_BIT | HCB_NCD_BIT ;
-	par->ctl &= ~HCB_NDS_BIT;
-	hcb_set_ctl(par);
-
-	/* check ACK is not lo */
-	ctl = hcb_get_ctl(par);
-	if ((ctl & HCB_ACK_BIT)) {
-		printk(KERN_ERR "Fail because ACK is already low\n");
-		return -ENXIO;
-	}
-
-	return 0;
-}
-
-static void hcb_wait_for_ack(struct hecubafb_par *par)
-{
-
-	int timeout;
-	unsigned char ctl;
-
-	timeout=500;
-	do {
-		ctl = hcb_get_ctl(par);
-		if ((ctl & HCB_ACK_BIT))
-			return;
-		udelay(1);
-	} while (timeout--);
-	printk(KERN_ERR "timed out waiting for ack\n");
-}
-
-static void hcb_wait_for_ack_clear(struct hecubafb_par *par)
-{
-
-	int timeout;
-	unsigned char ctl;
-
-	timeout=500;
-	do {
-		ctl = hcb_get_ctl(par);
-		if (!(ctl & HCB_ACK_BIT))
-			return;
-		udelay(1);
-	} while (timeout--);
-	printk(KERN_ERR "timed out waiting for clear\n");
-}
+/* main hecubafb functions */
 
 static void apollo_send_data(struct hecubafb_par *par, unsigned char data)
 {
 	/* set data */
-	hcb_set_data(par, data);
+	par->board->set_data(par, data);
 
 	/* set DS low */
-	par->ctl |= HCB_NDS_BIT;
-	hcb_set_ctl(par);
+	par->board->set_ctl(par, HCB_DS_BIT, 0);
 
-	hcb_wait_for_ack(par);
+	/* wait for ack */
+	par->board->wait_for_ack(par, 0);
 
 	/* set DS hi */
-	par->ctl &= ~(HCB_NDS_BIT);
-	hcb_set_ctl(par);
+	par->board->set_ctl(par, HCB_DS_BIT, 1);
 
-	hcb_wait_for_ack_clear(par);
+	/* wait for ack to clear */
+	par->board->wait_for_ack(par, 1);
 }
 
 static void apollo_send_command(struct hecubafb_par *par, unsigned char data)
 {
 	/* command so set CD to high */
-	par->ctl &= ~(HCB_NCD_BIT);
-	hcb_set_ctl(par);
+	par->board->set_ctl(par, HCB_CD_BIT, 1);
 
 	/* actually strobe with command */
 	apollo_send_data(par, data);
 
 	/* clear CD back to low */
-	par->ctl |= (HCB_NCD_BIT);
-	hcb_set_ctl(par);
+	par->board->set_ctl(par, HCB_CD_BIT, 0);
 }
 
-/* main hecubafb functions */
-
 static void hecubafb_dpy_update(struct hecubafb_par *par)
 {
 	int i;
 	unsigned char *buf = (unsigned char __force *)par->info->screen_base;
 
-	apollo_send_command(par, 0xA0);
+	apollo_send_command(par, APOLLO_START_NEW_IMG);
 
 	for (i=0; i < (DPY_W*DPY_H/8); i++) {
 		apollo_send_data(par, *(buf++));
 	}
 
-	apollo_send_command(par, 0xA1);
-	apollo_send_command(par, 0xA2);
+	apollo_send_command(par, APOLLO_STOP_IMG_DATA);
+	apollo_send_command(par, APOLLO_DISPLAY_IMG);
 }
 
 /* this is called back from the deferred io workqueue */
@@ -326,11 +215,21 @@ static struct fb_deferred_io hecubafb_de
 static int __devinit hecubafb_probe(struct platform_device *dev)
 {
 	struct fb_info *info;
+	struct hecuba_board *board;
 	int retval = -ENOMEM;
 	int videomemorysize;
 	unsigned char *videomemory;
 	struct hecubafb_par *par;
 
+	/* pick up board specific routines */
+	board = dev->dev.platform_data;
+	if (!board)
+		return -EINVAL;
+
+	/* try to count device specific driver, if can't, platform recalls */
+	if (!try_module_get(board->owner))
+		return -ENODEV;
+
 	videomemorysize = (DPY_W*DPY_H)/8;
 
 	if (!(videomemory = vmalloc(videomemorysize)))
@@ -340,9 +239,9 @@ static int __devinit hecubafb_probe(stru
 
 	info = framebuffer_alloc(sizeof(struct hecubafb_par), &dev->dev);
 	if (!info)
-		goto err;
+		goto err_fballoc;
 
-	info->screen_base = (char __iomem *) videomemory;
+	info->screen_base = (char __force __iomem *)videomemory;
 	info->fbops = &hecubafb_ops;
 
 	info->var = hecubafb_var;
@@ -350,14 +249,10 @@ static int __devinit hecubafb_probe(stru
 	info->fix.smem_len = videomemorysize;
 	par = info->par;
 	par->info = info;
+	par->board = board;
+	par->send_command = apollo_send_command;
+	par->send_data = apollo_send_data;
 
-	if (!dio_addr || !cio_addr || !c2io_addr) {
-		printk(KERN_WARNING "no IO addresses supplied\n");
-		goto err1;
-	}
-	par->dio_addr = dio_addr;
-	par->cio_addr = cio_addr;
-	par->c2io_addr = c2io_addr;
 	info->flags = FBINFO_FLAG_DEFAULT;
 
 	info->fbdefio = &hecubafb_defio;
@@ -365,7 +260,7 @@ static int __devinit hecubafb_probe(stru
 
 	retval = register_framebuffer(info);
 	if (retval < 0)
-		goto err1;
+		goto err_fbreg;
 	platform_set_drvdata(dev, info);
 
 	printk(KERN_INFO
@@ -373,25 +268,16 @@ static int __devinit hecubafb_probe(stru
 	       info->node, videomemorysize >> 10);
 
 	/* this inits the dpy */
-	apollo_init_control(par);
-
-	apollo_send_command(par, APOLLO_INIT_DISPLAY);
-	apollo_send_data(par, 0x81);
-
-	/* have to wait while display resets */
-	udelay(1000);
-
-	/* if we were told to splash the screen, we just clear it */
-	if (!nosplash) {
-		apollo_send_command(par, APOLLO_ERASE_DISPLAY);
-		apollo_send_data(par, splashval);
-	}
+	retval = par->board->init(par);
+	if (retval < 0)
+		goto err_fbreg;
 
 	return 0;
-err1:
+err_fbreg:
 	framebuffer_release(info);
-err:
+err_fballoc:
 	vfree(videomemory);
+	module_put(board->owner);
 	return retval;
 }
 
@@ -400,9 +286,13 @@ static int __devexit hecubafb_remove(str
 	struct fb_info *info = platform_get_drvdata(dev);
 
 	if (info) {
+		struct hecubafb_par *par = info->par;
 		fb_deferred_io_cleanup(info);
 		unregister_framebuffer(info);
 		vfree((void __force *)info->screen_base);
+		if (par->board->remove)
+			par->board->remove(par);
+		module_put(par->board->owner);
 		framebuffer_release(info);
 	}
 	return 0;
@@ -412,62 +302,24 @@ static struct platform_driver hecubafb_d
 	.probe	= hecubafb_probe,
 	.remove = hecubafb_remove,
 	.driver	= {
+		.owner	= THIS_MODULE,
 		.name	= "hecubafb",
 	},
 };
 
-static struct platform_device *hecubafb_device;
-
 static int __init hecubafb_init(void)
 {
-	int ret;
-
-	if (!hecubafb_enable) {
-		printk(KERN_ERR "Use hecubafb_enable to enable the device\n");
-		return -ENXIO;
-	}
-
-	ret = platform_driver_register(&hecubafb_driver);
-	if (!ret) {
-		hecubafb_device = platform_device_alloc("hecubafb", 0);
-		if (hecubafb_device)
-			ret = platform_device_add(hecubafb_device);
-		else
-			ret = -ENOMEM;
-
-		if (ret) {
-			platform_device_put(hecubafb_device);
-			platform_driver_unregister(&hecubafb_driver);
-		}
-	}
-	return ret;
-
+	return platform_driver_register(&hecubafb_driver);
 }
 
 static void __exit hecubafb_exit(void)
 {
-	platform_device_unregister(hecubafb_device);
 	platform_driver_unregister(&hecubafb_driver);
 }
 
-module_param(nosplash, uint, 0);
-MODULE_PARM_DESC(nosplash, "Disable doing the splash screen");
-module_param(hecubafb_enable, uint, 0);
-MODULE_PARM_DESC(hecubafb_enable, "Enable communication with Hecuba board");
-module_param(dio_addr, ulong, 0);
-MODULE_PARM_DESC(dio_addr, "IO address for data, eg: 0x480");
-module_param(cio_addr, ulong, 0);
-MODULE_PARM_DESC(cio_addr, "IO address for control, eg: 0x400");
-module_param(c2io_addr, ulong, 0);
-MODULE_PARM_DESC(c2io_addr, "IO address for secondary control, eg: 0x408");
-module_param(splashval, ulong, 0);
-MODULE_PARM_DESC(splashval, "Splash pattern: 0x00 is black, 0x01 is white");
-module_param(irq, uint, 0);
-MODULE_PARM_DESC(irq, "IRQ for the Hecuba board");
-
 module_init(hecubafb_init);
 module_exit(hecubafb_exit);
 
-MODULE_DESCRIPTION("fbdev driver for Hecuba board");
+MODULE_DESCRIPTION("fbdev driver for Hecuba/Apollo controller");
 MODULE_AUTHOR("Jaya Kumar");
 MODULE_LICENSE("GPL");
diff -puN /dev/null drivers/video/n411.c
--- /dev/null
+++ a/drivers/video/n411.c
@@ -0,0 +1,202 @@
+/*
+ * linux/drivers/video/n411.c -- Platform device for N411 EPD kit
+ *
+ * Copyright (C) 2008, Jaya Kumar
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file COPYING in the main directory of this archive for
+ * more details.
+ *
+ * Layout is based on skeletonfb.c by James Simmons and Geert Uytterhoeven.
+ *
+ * This driver is written to be used with the Hecuba display controller
+ * board, and tested with the EInk 800x600 display in 1 bit mode.
+ * The interface between Hecuba and the host is TTL based GPIO. The
+ * GPIO requirements are 8 writable data lines and 6 lines for control.
+ * Only 4 of the controls are actually used here but 6 for future use.
+ * The driver requires the IO addresses for data and control GPIO at
+ * load time. It is also possible to use this display with a standard
+ * PC parallel port.
+ *
+ * General notes:
+ * - User must set dio_addr=0xIOADDR cio_addr=0xIOADDR c2io_addr=0xIOADDR
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/fb.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/list.h>
+#include <linux/uaccess.h>
+#include <linux/irq.h>
+
+#include <video/hecubafb.h>
+
+static unsigned long dio_addr;
+static unsigned long cio_addr;
+static unsigned long c2io_addr;
+static unsigned long splashval;
+static unsigned int nosplash;
+static unsigned char ctl;
+
+static void n411_set_ctl(struct hecubafb_par *par, unsigned char bit, unsigned
+							char state)
+{
+	switch (bit) {
+	case HCB_CD_BIT:
+		if (state)
+			ctl &= ~(HCB_CD_BIT);
+		else
+			ctl |= HCB_CD_BIT;
+		break;
+	case HCB_DS_BIT:
+		if (state)
+			ctl &= ~(HCB_DS_BIT);
+		else
+			ctl |= HCB_DS_BIT;
+		break;
+	}
+	outb(ctl, cio_addr);
+}
+
+static unsigned char n411_get_ctl(struct hecubafb_par *par)
+{
+	return inb(c2io_addr);
+}
+
+static void n411_set_data(struct hecubafb_par *par, unsigned char value)
+{
+	outb(value, dio_addr);
+}
+
+static void n411_wait_for_ack(struct hecubafb_par *par, int clear)
+{
+	int timeout;
+	unsigned char tmp;
+
+	timeout = 500;
+	do {
+		tmp = n411_get_ctl(par);
+		if ((tmp & HCB_ACK_BIT) && (!clear))
+			return;
+		else if (!(tmp & HCB_ACK_BIT) && (clear))
+			return;
+		udelay(1);
+	} while (timeout--);
+	printk(KERN_ERR "timed out waiting for ack\n");
+}
+
+static int n411_init_control(struct hecubafb_par *par)
+{
+	unsigned char tmp;
+	/* for init, we want the following setup to be set:
+	WUP = lo
+	ACK = hi
+	DS = hi
+	RW = hi
+	CD = lo
+	*/
+
+	/* write WUP to lo, DS to hi, RW to hi, CD to lo */
+	ctl = HCB_WUP_BIT | HCB_RW_BIT | HCB_CD_BIT ;
+	n411_set_ctl(par, HCB_DS_BIT, 1);
+
+	/* check ACK is not lo */
+	tmp = n411_get_ctl(par);
+	if (tmp & HCB_ACK_BIT) {
+		printk(KERN_ERR "Fail because ACK is already low\n");
+		return -ENXIO;
+	}
+
+	return 0;
+}
+
+
+static int n411_init_board(struct hecubafb_par *par)
+{
+	int retval;
+
+	retval = n411_init_control(par);
+	if (retval)
+		return retval;
+
+	par->send_command(par, APOLLO_INIT_DISPLAY);
+	par->send_data(par, 0x81);
+
+	/* have to wait while display resets */
+	udelay(1000);
+
+	/* if we were told to splash the screen, we just clear it */
+	if (!nosplash) {
+		par->send_command(par, APOLLO_ERASE_DISPLAY);
+		par->send_data(par, splashval);
+	}
+
+	return 0;
+}
+
+static struct hecuba_board n411_board = {
+	.owner			= THIS_MODULE,
+	.init			= n411_init_board,
+	.set_ctl		= n411_set_ctl,
+	.set_data		= n411_set_data,
+	.wait_for_ack		= n411_wait_for_ack,
+};
+
+static struct platform_device *n411_device;
+static int __init n411_init(void)
+{
+	int ret;
+	if (!dio_addr || !cio_addr || !c2io_addr) {
+		printk(KERN_WARNING "no IO addresses supplied\n");
+		return -EINVAL;
+	}
+
+	/* request our platform independent driver */
+	request_module("hecubafb");
+
+	n411_device = platform_device_alloc("hecubafb", -1);
+	if (!n411_device)
+		return -ENOMEM;
+
+	platform_device_add_data(n411_device, &n411_board, sizeof(n411_board));
+
+	/* this _add binds hecubafb to n411. hecubafb refcounts n411 */
+	ret = platform_device_add(n411_device);
+
+	if (ret)
+		platform_device_put(n411_device);
+
+	return ret;
+
+}
+
+static void __exit n411_exit(void)
+{
+	platform_device_unregister(n411_device);
+}
+
+module_init(n411_init);
+module_exit(n411_exit);
+
+module_param(nosplash, uint, 0);
+MODULE_PARM_DESC(nosplash, "Disable doing the splash screen");
+module_param(dio_addr, ulong, 0);
+MODULE_PARM_DESC(dio_addr, "IO address for data, eg: 0x480");
+module_param(cio_addr, ulong, 0);
+MODULE_PARM_DESC(cio_addr, "IO address for control, eg: 0x400");
+module_param(c2io_addr, ulong, 0);
+MODULE_PARM_DESC(c2io_addr, "IO address for secondary control, eg: 0x408");
+module_param(splashval, ulong, 0);
+MODULE_PARM_DESC(splashval, "Splash pattern: 0x00 is black, 0x01 is white");
+
+MODULE_DESCRIPTION("board driver for n411 hecuba/apollo epd kit");
+MODULE_AUTHOR("Jaya Kumar");
+MODULE_LICENSE("GPL");
+
diff -puN /dev/null include/video/hecubafb.h
--- /dev/null
+++ a/include/video/hecubafb.h
@@ -0,0 +1,51 @@
+/*
+ * hecubafb.h - definitions for the hecuba framebuffer driver
+ *
+ * Copyright (C) 2008 by Jaya Kumar
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file COPYING in the main directory of this archive for
+ * more details.
+ *
+ */
+
+#ifndef _LINUX_HECUBAFB_H_
+#define _LINUX_HECUBAFB_H_
+
+/* Apollo controller specific defines */
+#define APOLLO_START_NEW_IMG	0xA0
+#define APOLLO_STOP_IMG_DATA	0xA1
+#define APOLLO_DISPLAY_IMG	0xA2
+#define APOLLO_ERASE_DISPLAY	0xA3
+#define APOLLO_INIT_DISPLAY	0xA4
+
+/* Hecuba interface specific defines */
+#define HCB_WUP_BIT	0x01
+#define HCB_DS_BIT 	0x02
+#define HCB_RW_BIT 	0x04
+#define HCB_CD_BIT 	0x08
+#define HCB_ACK_BIT 	0x80
+
+/* struct used by hecuba. board specific stuff comes from *board */
+struct hecubafb_par {
+	struct fb_info *info;
+	struct hecuba_board *board;
+	void (*send_command)(struct hecubafb_par *, unsigned char);
+	void (*send_data)(struct hecubafb_par *, unsigned char);
+};
+
+/* board specific routines
+board drivers can implement wait_for_ack with interrupts if desired. if
+wait_for_ack is called with clear=0, then go to sleep and return when ack
+goes hi or if wait_for_ack with clear=1, then return when ack goes lo */
+struct hecuba_board {
+	struct module *owner;
+	void (*remove)(struct hecubafb_par *);
+	void (*set_ctl)(struct hecubafb_par *, unsigned char, unsigned char);
+	void (*set_data)(struct hecubafb_par *, unsigned char);
+	void (*wait_for_ack)(struct hecubafb_par *, int);
+	int (*init)(struct hecubafb_par *);
+};
+
+
+#endif
_

Patches currently in -mm which might be from jayakumar.lkml@gmail.com are

origin.patch
git-arm.patch

