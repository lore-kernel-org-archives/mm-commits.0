From: akpm@linux-foundation.org
Subject: - fbdev-platforming-metronomefb-and-am200epd-v4.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:59:26 -0700
Message-ID: <200804282159.m3SLxQJi018589@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42495 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965484AbYD1V7j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:59:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jayakumar.lkml@gmail.com, adaplas@pol.net, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     fbdev: platforming metronomefb and am200epd
has been removed from the -mm tree.  Its filename was
     fbdev-platforming-metronomefb-and-am200epd-v4.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: platforming metronomefb and am200epd
From: Jaya Kumar <jayakumar.lkml@gmail.com>

This patch splits metronomefb into the platform independent metronomefb and
the platform dependent am200epd.

Signed-off-by: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/fb/metronomefb.txt |   16 -
 drivers/video/Kconfig            |   16 -
 drivers/video/Makefile           |    1 
 drivers/video/am200epd.c         |  295 +++++++++++++++++++++++++++
 drivers/video/metronomefb.c      |  314 ++++-------------------------
 include/video/metronomefb.h      |   62 +++++
 6 files changed, 422 insertions(+), 282 deletions(-)

diff -puN Documentation/fb/metronomefb.txt~fbdev-platforming-metronomefb-and-am200epd-v4 Documentation/fb/metronomefb.txt
--- a/Documentation/fb/metronomefb.txt~fbdev-platforming-metronomefb-and-am200epd-v4
+++ a/Documentation/fb/metronomefb.txt
@@ -1,7 +1,7 @@
 			Metronomefb
 			-----------
 Maintained by Jaya Kumar <jayakumar.lkml.gmail.com>
-Last revised: Nov 20, 2007
+Last revised: Mar 10, 2008
 
 Metronomefb is a driver for the Metronome display controller. The controller
 is from E-Ink Corporation. It is intended to be used to drive the E-Ink
@@ -11,20 +11,18 @@ display media here http://www.e-ink.com/
 Metronome is interfaced to the host CPU through the AMLCD interface. The
 host CPU generates the control information and the image in a framebuffer
 which is then delivered to the AMLCD interface by a host specific method.
-Currently, that's implemented for the PXA's LCDC controller. The display and
-error status are each pulled through individual GPIOs.
+The display and error status are each pulled through individual GPIOs.
 
-Metronomefb was written for the PXA255/gumstix/lyre combination and
-therefore currently has board set specific code in it. If other boards based on
-other architectures are available, then the host specific code can be separated
-and abstracted out.
+Metronomefb is platform independent and depends on a board specific driver
+to do all physical IO work. Currently, an example is implemented for the
+PXA board used in the AM-200 EPD devkit. This example is am200epd.c
 
 Metronomefb requires waveform information which is delivered via the AMLCD
 interface to the metronome controller. The waveform information is expected to
 be delivered from userspace via the firmware class interface. The waveform file
 can be compressed as long as your udev or hotplug script is aware of the need
-to uncompress it before delivering it. metronomefb will ask for waveform.wbf
-which would typically go into /lib/firmware/waveform.wbf depending on your
+to uncompress it before delivering it. metronomefb will ask for metronome.wbf
+which would typically go into /lib/firmware/metronome.wbf depending on your
 udev/hotplug setup. I have only tested with a single waveform file which was
 originally labeled 23P01201_60_WT0107_MTC. I do not know what it stands for.
 Caution should be exercised when manipulating the waveform as there may be
diff -puN drivers/video/Kconfig~fbdev-platforming-metronomefb-and-am200epd-v4 drivers/video/Kconfig
--- a/drivers/video/Kconfig~fbdev-platforming-metronomefb-and-am200epd-v4
+++ a/drivers/video/Kconfig
@@ -173,6 +173,11 @@ config FB_DEFERRED_IO
 	depends on FB
 	default y
 
+config FB_METRONOME
+	tristate
+	depends on FB
+	depends on FB_DEFERRED_IO
+
 config FB_SVGALIB
 	tristate
 	depends on FB
@@ -1927,19 +1932,18 @@ config FB_XILINX
 	  framebuffer. ML300 carries a 640*480 LCD display on the board,
 	  ML403 uses a standard DB15 VGA connector.
 
-config FB_METRONOME
-       tristate "Metronome display controller support"
+config FB_AM200EPD
+       tristate "AM-200 E-Ink EPD devkit support"
        depends on FB && ARCH_PXA && MMU
        select FB_SYS_FILLRECT
        select FB_SYS_COPYAREA
        select FB_SYS_IMAGEBLIT
        select FB_SYS_FOPS
        select FB_DEFERRED_IO
+       select FB_METRONOME
        help
-         This enables support for the Metronome display controller. Tested
-         with an E-Ink 800x600 display and Gumstix Connex through an AMLCD
-         interface. Please read <file:Documentation/fb/metronomefb.txt>
-         for more information.
+         This enables support for the Metronome display controller used on
+         the E-Ink AM-200 EPD devkit.
 
 config FB_VIRTUAL
 	tristate "Virtual Frame Buffer support (ONLY FOR TESTING!)"
diff -puN drivers/video/Makefile~fbdev-platforming-metronomefb-and-am200epd-v4 drivers/video/Makefile
--- a/drivers/video/Makefile~fbdev-platforming-metronomefb-and-am200epd-v4
+++ a/drivers/video/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_FB_DEFERRED_IO)   += fb_def
 
 # Hardware specific drivers go first
 obj-$(CONFIG_FB_AMIGA)            += amifb.o c2p.o
+obj-$(CONFIG_FB_AM200EPD)         += am200epd.o
 obj-$(CONFIG_FB_ARC)              += arcfb.o
 obj-$(CONFIG_FB_CLPS711X)         += clps711xfb.o
 obj-$(CONFIG_FB_CYBER2000)        += cyber2000fb.o
diff -puN /dev/null drivers/video/am200epd.c
--- /dev/null
+++ a/drivers/video/am200epd.c
@@ -0,0 +1,295 @@
+/*
+ * linux/drivers/video/am200epd.c -- Platform device for AM200 EPD kit
+ *
+ * Copyright (C) 2008, Jaya Kumar
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file COPYING in the main directory of this archive for
+ * more details.
+ *
+ * Layout is based on skeletonfb.c by James Simmons and Geert Uytterhoeven.
+ *
+ * This work was made possible by help and equipment support from E-Ink
+ * Corporation. http://support.eink.com/community
+ *
+ * This driver is written to be used with the Metronome display controller.
+ * on the AM200 EPD prototype kit/development kit with an E-Ink 800x600
+ * Vizplex EPD on a Gumstix board using the Lyre interface board.
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
+#include <video/metronomefb.h>
+
+#include <asm/arch/pxa-regs.h>
+
+/* register offsets for gpio control */
+#define LED_GPIO_PIN 51
+#define STDBY_GPIO_PIN 48
+#define RST_GPIO_PIN 49
+#define RDY_GPIO_PIN 32
+#define ERR_GPIO_PIN 17
+#define PCBPWR_GPIO_PIN 16
+
+#define AF_SEL_GPIO_N 0x3
+#define GAFR0_U_OFFSET(pin) ((pin - 16) * 2)
+#define GAFR1_L_OFFSET(pin) ((pin - 32) * 2)
+#define GAFR1_U_OFFSET(pin) ((pin - 48) * 2)
+#define GPDR1_OFFSET(pin) (pin - 32)
+#define GPCR1_OFFSET(pin) (pin - 32)
+#define GPSR1_OFFSET(pin) (pin - 32)
+#define GPCR0_OFFSET(pin) (pin)
+#define GPSR0_OFFSET(pin) (pin)
+
+static void am200_set_gpio_output(int pin, int val)
+{
+	u8 index;
+
+	index = pin >> 4;
+
+	switch (index) {
+	case 1:
+		if (val)
+			GPSR0 |= (1 << GPSR0_OFFSET(pin));
+		else
+			GPCR0 |= (1 << GPCR0_OFFSET(pin));
+		break;
+	case 2:
+		break;
+	case 3:
+		if (val)
+			GPSR1 |= (1 << GPSR1_OFFSET(pin));
+		else
+			GPCR1 |= (1 << GPCR1_OFFSET(pin));
+		break;
+	default:
+		printk(KERN_ERR "unimplemented\n");
+	}
+}
+
+static void __devinit am200_init_gpio_pin(int pin, int dir)
+{
+	u8 index;
+	/* dir 0 is output, 1 is input
+	- do 2 things here:
+	- set gpio alternate function to standard gpio
+	- set gpio direction to input or output  */
+
+	index = pin >> 4;
+	switch (index) {
+	case 1:
+		GAFR0_U &= ~(AF_SEL_GPIO_N << GAFR0_U_OFFSET(pin));
+
+		if (dir)
+			GPDR0 &= ~(1 << pin);
+		else
+			GPDR0 |= (1 << pin);
+		break;
+	case 2:
+		GAFR1_L &= ~(AF_SEL_GPIO_N << GAFR1_L_OFFSET(pin));
+
+		if (dir)
+			GPDR1 &= ~(1 << GPDR1_OFFSET(pin));
+		else
+			GPDR1 |= (1 << GPDR1_OFFSET(pin));
+		break;
+	case 3:
+		GAFR1_U &= ~(AF_SEL_GPIO_N << GAFR1_U_OFFSET(pin));
+
+		if (dir)
+			GPDR1 &= ~(1 << GPDR1_OFFSET(pin));
+		else
+			GPDR1 |= (1 << GPDR1_OFFSET(pin));
+		break;
+	default:
+		printk(KERN_ERR "unimplemented\n");
+	}
+}
+
+static void am200_init_gpio_regs(struct metronomefb_par *par)
+{
+	am200_init_gpio_pin(LED_GPIO_PIN, 0);
+	am200_set_gpio_output(LED_GPIO_PIN, 0);
+
+	am200_init_gpio_pin(STDBY_GPIO_PIN, 0);
+	am200_set_gpio_output(STDBY_GPIO_PIN, 0);
+
+	am200_init_gpio_pin(RST_GPIO_PIN, 0);
+	am200_set_gpio_output(RST_GPIO_PIN, 0);
+
+	am200_init_gpio_pin(RDY_GPIO_PIN, 1);
+
+	am200_init_gpio_pin(ERR_GPIO_PIN, 1);
+
+	am200_init_gpio_pin(PCBPWR_GPIO_PIN, 0);
+	am200_set_gpio_output(PCBPWR_GPIO_PIN, 0);
+}
+
+static void am200_disable_lcd_controller(struct metronomefb_par *par)
+{
+	LCSR = 0xffffffff;	/* Clear LCD Status Register */
+	LCCR0 |= LCCR0_DIS;	/* Disable LCD Controller */
+
+	/* we reset and just wait for things to settle */
+	msleep(200);
+}
+
+static void am200_enable_lcd_controller(struct metronomefb_par *par)
+{
+	LCSR = 0xffffffff;
+	FDADR0 = par->metromem_desc_dma;
+	LCCR0 |= LCCR0_ENB;
+}
+
+static void am200_init_lcdc_regs(struct metronomefb_par *par)
+{
+	/* here we do:
+	- disable the lcd controller
+	- setup lcd control registers
+	- setup dma descriptor
+	- reenable lcd controller
+	*/
+
+	/* disable the lcd controller */
+	am200_disable_lcd_controller(par);
+
+	/* setup lcd control registers */
+	LCCR0 = LCCR0_LDM | LCCR0_SFM | LCCR0_IUM | LCCR0_EFM | LCCR0_PAS
+		| LCCR0_QDM | LCCR0_BM | LCCR0_OUM;
+
+	LCCR1 = (par->info->var.xres/2 - 1) /* pixels per line */
+		| (27 << 10) /* hsync pulse width - 1 */
+		| (33 << 16) /* eol pixel count */
+		| (33 << 24); /* bol pixel count */
+
+	LCCR2 = (par->info->var.yres - 1) /* lines per panel */
+		| (24 << 10) /* vsync pulse width - 1 */
+		| (2 << 16) /* eof pixel count */
+		| (0 << 24); /* bof pixel count */
+
+	LCCR3 = 2 /* pixel clock divisor */
+		| (24 << 8) /* AC Bias pin freq */
+		| LCCR3_16BPP /* BPP */
+		| LCCR3_PCP;  /* PCP falling edge */
+
+}
+
+static void am200_post_dma_setup(struct metronomefb_par *par)
+{
+	par->metromem_desc->mFDADR0 = par->metromem_desc_dma;
+	par->metromem_desc->mFSADR0 = par->metromem_dma;
+	par->metromem_desc->mFIDR0 = 0;
+	par->metromem_desc->mLDCMD0 = par->info->var.xres
+					* par->info->var.yres;
+	am200_enable_lcd_controller(par);
+}
+
+static void am200_free_irq(struct fb_info *info)
+{
+	free_irq(IRQ_GPIO(RDY_GPIO_PIN), info);
+}
+
+static irqreturn_t am200_handle_irq(int irq, void *dev_id)
+{
+	struct fb_info *info = dev_id;
+	struct metronomefb_par *par = info->par;
+
+	wake_up_interruptible(&par->waitq);
+	return IRQ_HANDLED;
+}
+
+static int am200_setup_irq(struct fb_info *info)
+{
+	int retval;
+
+	retval = request_irq(IRQ_GPIO(RDY_GPIO_PIN), am200_handle_irq,
+				IRQF_DISABLED, "AM200", info);
+	if (retval) {
+		printk(KERN_ERR "am200epd: request_irq failed: %d\n", retval);
+		return retval;
+	}
+
+	return set_irq_type(IRQ_GPIO(RDY_GPIO_PIN), IRQT_FALLING);
+}
+
+static void am200_set_rst(struct metronomefb_par *par, int state)
+{
+	am200_set_gpio_output(RST_GPIO_PIN, state);
+}
+
+static void am200_set_stdby(struct metronomefb_par *par, int state)
+{
+	am200_set_gpio_output(STDBY_GPIO_PIN, state);
+}
+
+static int am200_wait_event(struct metronomefb_par *par)
+{
+	return wait_event_timeout(par->waitq, (GPLR1 & 0x01), HZ);
+}
+
+static int am200_wait_event_intr(struct metronomefb_par *par)
+{
+	return wait_event_interruptible_timeout(par->waitq, (GPLR1 & 0x01), HZ);
+}
+
+static struct metronome_board am200_board = {
+	.owner			= THIS_MODULE,
+	.free_irq		= am200_free_irq,
+	.setup_irq		= am200_setup_irq,
+	.init_gpio_regs		= am200_init_gpio_regs,
+	.init_lcdc_regs		= am200_init_lcdc_regs,
+	.post_dma_setup		= am200_post_dma_setup,
+	.set_rst		= am200_set_rst,
+	.set_stdby		= am200_set_stdby,
+	.met_wait_event		= am200_wait_event,
+	.met_wait_event_intr	= am200_wait_event_intr,
+};
+
+static struct platform_device *am200_device;
+
+static int __init am200_init(void)
+{
+	int ret;
+
+	/* request our platform independent driver */
+	request_module("metronomefb");
+
+	am200_device = platform_device_alloc("metronomefb", -1);
+	if (!am200_device)
+		return -ENOMEM;
+
+	platform_device_add_data(am200_device, &am200_board,
+					sizeof(am200_board));
+
+	/* this _add binds metronomefb to am200. metronomefb refcounts am200 */
+	ret = platform_device_add(am200_device);
+
+	if (ret)
+		platform_device_put(am200_device);
+
+	return ret;
+}
+
+static void __exit am200_exit(void)
+{
+	platform_device_unregister(am200_device);
+}
+
+module_init(am200_init);
+module_exit(am200_exit);
+
+MODULE_DESCRIPTION("board driver for am200 metronome epd kit");
+MODULE_AUTHOR("Jaya Kumar");
+MODULE_LICENSE("GPL");
diff -puN drivers/video/metronomefb.c~fbdev-platforming-metronomefb-and-am200epd-v4 drivers/video/metronomefb.c
--- a/drivers/video/metronomefb.c~fbdev-platforming-metronomefb-and-am200epd-v4
+++ a/drivers/video/metronomefb.c
@@ -13,12 +13,10 @@
  * Corporation. http://support.eink.com/community
  *
  * This driver is written to be used with the Metronome display controller.
- * It was tested with an E-Ink 800x600 Vizplex EPD on a Gumstix Connex board
- * using the Lyre interface board.
+ * It is intended to be architecture independent. A board specific driver
+ * must be used to perform all the physical IO interactions. An example
+ * is provided as am200epd.c
  *
- * General notes:
- * - User must set metronomefb_enable=1 to enable it.
- * - See Documentation/fb/metronomefb.txt for how metronome works.
  */
 #include <linux/module.h>
 #include <linux/kernel.h>
@@ -38,9 +36,11 @@
 #include <linux/uaccess.h>
 #include <linux/irq.h>
 
-#include <asm/arch/pxa-regs.h>
+#include <video/metronomefb.h>
+
 #include <asm/unaligned.h>
 
+
 #define DEBUG 1
 #ifdef DEBUG
 #define DPRINTK(f, a...) printk(KERN_DEBUG "%s: " f, __func__ , ## a)
@@ -53,35 +53,6 @@
 #define DPY_W 832
 #define DPY_H 622
 
-struct metromem_desc {
-	u32 mFDADR0;
-	u32 mFSADR0;
-	u32 mFIDR0;
-	u32 mLDCMD0;
-};
-
-struct metromem_cmd {
-	u16 opcode;
-	u16 args[((64-2)/2)];
-	u16 csum;
-};
-
-struct metronomefb_par {
-	unsigned char *metromem;
-	struct metromem_desc *metromem_desc;
-	struct metromem_cmd *metromem_cmd;
-	unsigned char *metromem_wfm;
-	unsigned char *metromem_img;
-	u16 *metromem_img_csum;
-	u16 *csum_table;
-	int metromemsize;
-	dma_addr_t metromem_dma;
-	dma_addr_t metromem_desc_dma;
-	struct fb_info *info;
-	wait_queue_head_t waitq;
-	u8 frame_count;
-};
-
 /* frame differs from image. frame includes non-visible pixels */
 struct epd_frame {
 	int fw; /* frame width */
@@ -120,8 +91,7 @@ static struct fb_var_screeninfo metronom
 	.transp =	{ 0, 0, 0 },
 };
 
-static unsigned int metronomefb_enable;
-
+/* the waveform structure that is coming from userspace firmware */
 struct waveform_hdr {
 	u8 stuff[32];
 
@@ -301,165 +271,6 @@ static int load_waveform(u8 *mem, size_t
 	return 0;
 }
 
-/* register offsets for gpio control */
-#define LED_GPIO_PIN 51
-#define STDBY_GPIO_PIN 48
-#define RST_GPIO_PIN 49
-#define RDY_GPIO_PIN 32
-#define ERR_GPIO_PIN 17
-#define PCBPWR_GPIO_PIN 16
-
-#define AF_SEL_GPIO_N 0x3
-#define GAFR0_U_OFFSET(pin) ((pin - 16) * 2)
-#define GAFR1_L_OFFSET(pin) ((pin - 32) * 2)
-#define GAFR1_U_OFFSET(pin) ((pin - 48) * 2)
-#define GPDR1_OFFSET(pin) (pin - 32)
-#define GPCR1_OFFSET(pin) (pin - 32)
-#define GPSR1_OFFSET(pin) (pin - 32)
-#define GPCR0_OFFSET(pin) (pin)
-#define GPSR0_OFFSET(pin) (pin)
-
-static void metronome_set_gpio_output(int pin, int val)
-{
-	u8 index;
-
-	index = pin >> 4;
-
-	switch (index) {
-	case 1:
-		if (val)
-			GPSR0 |= (1 << GPSR0_OFFSET(pin));
-		else
-			GPCR0 |= (1 << GPCR0_OFFSET(pin));
-		break;
-	case 2:
-		break;
-	case 3:
-		if (val)
-			GPSR1 |= (1 << GPSR1_OFFSET(pin));
-		else
-			GPCR1 |= (1 << GPCR1_OFFSET(pin));
-		break;
-	default:
-		printk(KERN_ERR "unimplemented\n");
-	}
-}
-
-static void __devinit metronome_init_gpio_pin(int pin, int dir)
-{
-	u8 index;
-	/* dir 0 is output, 1 is input
-	- do 2 things here:
-	- set gpio alternate function to standard gpio
-	- set gpio direction to input or output  */
-
-	index = pin >> 4;
-	switch (index) {
-	case 1:
-		GAFR0_U &= ~(AF_SEL_GPIO_N << GAFR0_U_OFFSET(pin));
-
-		if (dir)
-			GPDR0 &= ~(1 << pin);
-		else
-			GPDR0 |= (1 << pin);
-		break;
-	case 2:
-		GAFR1_L &= ~(AF_SEL_GPIO_N << GAFR1_L_OFFSET(pin));
-
-		if (dir)
-			GPDR1 &= ~(1 << GPDR1_OFFSET(pin));
-		else
-			GPDR1 |= (1 << GPDR1_OFFSET(pin));
-		break;
-	case 3:
-		GAFR1_U &= ~(AF_SEL_GPIO_N << GAFR1_U_OFFSET(pin));
-
-		if (dir)
-			GPDR1 &= ~(1 << GPDR1_OFFSET(pin));
-		else
-			GPDR1 |= (1 << GPDR1_OFFSET(pin));
-		break;
-	default:
-		printk(KERN_ERR "unimplemented\n");
-	}
-}
-
-static void __devinit metronome_init_gpio_regs(void)
-{
-	metronome_init_gpio_pin(LED_GPIO_PIN, 0);
-	metronome_set_gpio_output(LED_GPIO_PIN, 0);
-
-	metronome_init_gpio_pin(STDBY_GPIO_PIN, 0);
-	metronome_set_gpio_output(STDBY_GPIO_PIN, 0);
-
-	metronome_init_gpio_pin(RST_GPIO_PIN, 0);
-	metronome_set_gpio_output(RST_GPIO_PIN, 0);
-
-	metronome_init_gpio_pin(RDY_GPIO_PIN, 1);
-
-	metronome_init_gpio_pin(ERR_GPIO_PIN, 1);
-
-	metronome_init_gpio_pin(PCBPWR_GPIO_PIN, 0);
-	metronome_set_gpio_output(PCBPWR_GPIO_PIN, 0);
-}
-
-static void metronome_disable_lcd_controller(struct metronomefb_par *par)
-{
-	LCSR = 0xffffffff;	/* Clear LCD Status Register */
-	LCCR0 |= LCCR0_DIS;	/* Disable LCD Controller */
-
-	/* we reset and just wait for things to settle */
-	msleep(200);
-}
-
-static void metronome_enable_lcd_controller(struct metronomefb_par *par)
-{
-	LCSR = 0xffffffff;
-	FDADR0 = par->metromem_desc_dma;
-	LCCR0 |= LCCR0_ENB;
-}
-
-static void __devinit metronome_init_lcdc_regs(struct metronomefb_par *par)
-{
-	/* here we do:
-	- disable the lcd controller
-	- setup lcd control registers
-	- setup dma descriptor
-	- reenable lcd controller
-	*/
-
-	/* disable the lcd controller */
-	metronome_disable_lcd_controller(par);
-
-	/* setup lcd control registers */
-	LCCR0 = LCCR0_LDM | LCCR0_SFM | LCCR0_IUM | LCCR0_EFM | LCCR0_PAS
-		| LCCR0_QDM | LCCR0_BM | LCCR0_OUM;
-
-	LCCR1 = (epd_frame_table[0].fw/2 - 1) /* pixels per line */
-		| (27 << 10) /* hsync pulse width - 1 */
-		| (33 << 16) /* eol pixel count */
-		| (33 << 24); /* bol pixel count */
-
-	LCCR2 = (epd_frame_table[0].fh - 1) /* lines per panel */
-		| (24 << 10) /* vsync pulse width - 1 */
-		| (2 << 16) /* eof pixel count */
-		| (0 << 24); /* bof pixel count */
-
-	LCCR3 = 2 /* pixel clock divisor */
-		| (24 << 8) /* AC Bias pin freq */
-		| LCCR3_16BPP /* BPP */
-		| LCCR3_PCP;  /* PCP falling edge */
-
-	/* setup dma descriptor */
-	par->metromem_desc->mFDADR0 = par->metromem_desc_dma;
-	par->metromem_desc->mFSADR0 = par->metromem_dma;
-	par->metromem_desc->mFIDR0 = 0;
-	par->metromem_desc->mLDCMD0 = epd_frame_table[0].fw
-					* epd_frame_table[0].fh;
-	/* reenable lcd controller */
-	metronome_enable_lcd_controller(par);
-}
-
 static int metronome_display_cmd(struct metronomefb_par *par)
 {
 	int i;
@@ -493,8 +304,7 @@ static int metronome_display_cmd(struct 
 	par->metromem_cmd->csum = cs;
 	par->metromem_cmd->opcode = opcode; /* display cmd */
 
-	i = wait_event_interruptible_timeout(par->waitq, (GPLR1 & 0x01), HZ);
-	return i;
+	return par->board->met_wait_event_intr(par);
 }
 
 static int __devinit metronome_powerup_cmd(struct metronomefb_par *par)
@@ -518,13 +328,12 @@ static int __devinit metronome_powerup_c
 	par->metromem_cmd->csum = cs;
 
 	msleep(1);
-	metronome_set_gpio_output(RST_GPIO_PIN, 1);
+	par->board->set_rst(par, 1);
 
 	msleep(1);
-	metronome_set_gpio_output(STDBY_GPIO_PIN, 1);
+	par->board->set_stdby(par, 1);
 
-	i = wait_event_timeout(par->waitq, (GPLR1 & 0x01), HZ);
-	return i;
+	return par->board->met_wait_event(par);
 }
 
 static int __devinit metronome_config_cmd(struct metronomefb_par *par)
@@ -569,8 +378,7 @@ static int __devinit metronome_config_cm
 	par->metromem_cmd->csum = cs;
 	par->metromem_cmd->opcode = 0xCC10; /* config cmd */
 
-	i = wait_event_timeout(par->waitq, (GPLR1 & 0x01), HZ);
-	return i;
+	return par->board->met_wait_event(par);
 }
 
 static int __devinit metronome_init_cmd(struct metronomefb_par *par)
@@ -596,16 +404,19 @@ static int __devinit metronome_init_cmd(
 	par->metromem_cmd->csum = cs;
 	par->metromem_cmd->opcode = 0xCC20; /* init cmd */
 
-	i = wait_event_timeout(par->waitq, (GPLR1 & 0x01), HZ);
-	return i;
+	return par->board->met_wait_event(par);
 }
 
 static int __devinit metronome_init_regs(struct metronomefb_par *par)
 {
 	int res;
 
-	metronome_init_gpio_regs();
-	metronome_init_lcdc_regs(par);
+	par->board->init_gpio_regs(par);
+
+	par->board->init_lcdc_regs(par);
+
+	/* now that lcd is setup, setup dma descriptor */
+	par->board->post_dma_setup(par);
 
 	res = metronome_powerup_cmd(par);
 	if (res)
@@ -616,8 +427,6 @@ static int __devinit metronome_init_regs
 		return res;
 
 	res = metronome_init_cmd(par);
-	if (res)
-		return res;
 
 	return res;
 }
@@ -632,7 +441,7 @@ static void metronomefb_dpy_update(struc
 
 	cksum = calc_img_cksum((u16 *) par->metromem_img,
 				(epd_frame_table[0].fw * DPY_H)/2);
-	*((u16 *) (par->metromem_img) +
+	*((u16 *)(par->metromem_img) +
 			(epd_frame_table[0].fw * DPY_H)/2) = cksum;
 	metronome_display_cmd(par);
 }
@@ -641,8 +450,8 @@ static u16 metronomefb_dpy_update_page(s
 {
 	int i;
 	u16 csum = 0;
-	u16 *buf = (u16 __force *) (par->info->screen_base + index);
-	u16 *img = (u16 *) (par->metromem_img + index);
+	u16 *buf = (u16 __force *)(par->info->screen_base + index);
+	u16 *img = (u16 *)(par->metromem_img + index);
 
 	/* swizzle from vm to metromem and recalc cksum at the same time*/
 	for (i = 0; i < PAGE_SIZE/2; i++) {
@@ -733,7 +542,7 @@ static ssize_t metronomefb_write(struct 
 		count = total_size - p;
 	}
 
-	dst = (void __force *) (info->screen_base + p);
+	dst = (void __force *)(info->screen_base + p);
 
 	if (copy_from_user(dst, buf, count))
 		err = -EFAULT;
@@ -759,18 +568,10 @@ static struct fb_deferred_io metronomefb
 	.deferred_io	= metronomefb_dpy_deferred_io,
 };
 
-static irqreturn_t metronome_handle_irq(int irq, void *dev_id)
-{
-	struct fb_info *info = dev_id;
-	struct metronomefb_par *par = info->par;
-
-	wake_up_interruptible(&par->waitq);
-	return IRQ_HANDLED;
-}
-
 static int __devinit metronomefb_probe(struct platform_device *dev)
 {
 	struct fb_info *info;
+	struct metronome_board *board;
 	int retval = -ENOMEM;
 	int videomemorysize;
 	unsigned char *videomemory;
@@ -779,17 +580,26 @@ static int __devinit metronomefb_probe(s
 	int cmd_size, wfm_size, img_size, padding_size, totalsize;
 	int i;
 
+	/* pick up board specific routines */
+	board = dev->dev.platform_data;
+	if (!board)
+		return -EINVAL;
+
+	/* try to count device specific driver, if can't, platform recalls */
+	if (!try_module_get(board->owner))
+		return -ENODEV;
+
 	/* we have two blocks of memory.
 	info->screen_base which is vm, and is the fb used by apps.
 	par->metromem which is physically contiguous memory and
 	contains the display controller commands, waveform,
 	processed image data and padding. this is the data pulled
-	by the pxa255's LCD controller and pushed to Metronome */
+	by the device's LCD controller and pushed to Metronome */
 
 	videomemorysize = (DPY_W*DPY_H);
 	videomemory = vmalloc(videomemorysize);
 	if (!videomemory)
-		return retval;
+		return -ENOMEM;
 
 	memset(videomemory, 0, videomemorysize);
 
@@ -797,7 +607,7 @@ static int __devinit metronomefb_probe(s
 	if (!info)
 		goto err_vfree;
 
-	info->screen_base = (char __iomem *) videomemory;
+	info->screen_base = (char __force __iomem *)videomemory;
 	info->fbops = &metronomefb_ops;
 
 	info->var = metronomefb_var;
@@ -805,6 +615,7 @@ static int __devinit metronomefb_probe(s
 	info->fix.smem_len = videomemorysize;
 	par = info->par;
 	par->info = info;
+	par->board = board;
 	init_waitqueue_head(&par->waitq);
 
 	/* this table caches per page csum values. */
@@ -849,11 +660,10 @@ static int __devinit metronomefb_probe(s
 	par->metromem_desc_dma = par->metromem_dma + cmd_size + wfm_size
 				 + img_size + padding_size;
 
-	/* load the waveform in. assume mode 3, temp 31 for now */
-	/* 	a) request the waveform file from userspace
+	/* load the waveform in. assume mode 3, temp 31 for now
+		a) request the waveform file from userspace
 		b) process waveform and decode into metromem */
-
-	retval = request_firmware(&fw_entry, "waveform.wbf", &dev->dev);
+	retval = request_firmware(&fw_entry, "metronome.wbf", &dev->dev);
 	if (retval < 0) {
 		printk(KERN_ERR "metronomefb: couldn't get waveform\n");
 		goto err_dma_free;
@@ -867,13 +677,8 @@ static int __devinit metronomefb_probe(s
 	}
 	release_firmware(fw_entry);
 
-	retval = request_irq(IRQ_GPIO(RDY_GPIO_PIN), metronome_handle_irq,
-				IRQF_DISABLED, "Metronome", info);
-	if (retval) {
-		dev_err(&dev->dev, "request_irq failed: %d\n", retval);
+	if (board->setup_irq(info))
 		goto err_ld_wfm;
-	}
-	set_irq_type(IRQ_GPIO(RDY_GPIO_PIN), IRQT_FALLING);
 
 	retval = metronome_init_regs(par);
 	if (retval < 0)
@@ -913,7 +718,7 @@ err_cmap:
 err_fb_rel:
 	framebuffer_release(info);
 err_free_irq:
-	free_irq(IRQ_GPIO(RDY_GPIO_PIN), info);
+	board->free_irq(info);
 err_ld_wfm:
 	release_firmware(fw_entry);
 err_dma_free:
@@ -923,6 +728,7 @@ err_csum_table:
 	vfree(par->csum_table);
 err_vfree:
 	vfree(videomemory);
+	module_put(board->owner);
 	return retval;
 }
 
@@ -939,7 +745,8 @@ static int __devexit metronomefb_remove(
 		vfree(par->csum_table);
 		unregister_framebuffer(info);
 		vfree((void __force *)info->screen_base);
-		free_irq(IRQ_GPIO(RDY_GPIO_PIN), info);
+		par->board->free_irq(info);
+		module_put(par->board->owner);
 		framebuffer_release(info);
 	}
 	return 0;
@@ -949,48 +756,21 @@ static struct platform_driver metronomef
 	.probe	= metronomefb_probe,
 	.remove = metronomefb_remove,
 	.driver	= {
+		.owner	= THIS_MODULE,
 		.name	= "metronomefb",
 	},
 };
 
-static struct platform_device *metronomefb_device;
-
 static int __init metronomefb_init(void)
 {
-	int ret;
-
-	if (!metronomefb_enable) {
-		printk(KERN_ERR
-			"Use metronomefb_enable to enable the device\n");
-		return -ENXIO;
-	}
-
-	ret = platform_driver_register(&metronomefb_driver);
-	if (!ret) {
-		metronomefb_device = platform_device_alloc("metronomefb", 0);
-		if (metronomefb_device)
-			ret = platform_device_add(metronomefb_device);
-		else
-			ret = -ENOMEM;
-
-		if (ret) {
-			platform_device_put(metronomefb_device);
-			platform_driver_unregister(&metronomefb_driver);
-		}
-	}
-	return ret;
-
+	return platform_driver_register(&metronomefb_driver);
 }
 
 static void __exit metronomefb_exit(void)
 {
-	platform_device_unregister(metronomefb_device);
 	platform_driver_unregister(&metronomefb_driver);
 }
 
-module_param(metronomefb_enable, uint, 0);
-MODULE_PARM_DESC(metronomefb_enable, "Enable communication with Metronome");
-
 module_init(metronomefb_init);
 module_exit(metronomefb_exit);
 
diff -puN /dev/null include/video/metronomefb.h
--- /dev/null
+++ a/include/video/metronomefb.h
@@ -0,0 +1,62 @@
+/*
+ * metronomefb.h - definitions for the metronome framebuffer driver
+ *
+ * Copyright (C) 2008 by Jaya Kumar
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file COPYING in the main directory of this archive for
+ * more details.
+ *
+ */
+
+#ifndef _LINUX_METRONOMEFB_H_
+#define _LINUX_METRONOMEFB_H_
+
+/* address and control descriptors used by metronome controller */
+struct metromem_desc {
+	u32 mFDADR0;
+	u32 mFSADR0;
+	u32 mFIDR0;
+	u32 mLDCMD0;
+};
+
+/* command structure used by metronome controller */
+struct metromem_cmd {
+	u16 opcode;
+	u16 args[((64-2)/2)];
+	u16 csum;
+};
+
+/* struct used by metronome. board specific stuff comes from *board */
+struct metronomefb_par {
+	unsigned char *metromem;
+	struct metromem_desc *metromem_desc;
+	struct metromem_cmd *metromem_cmd;
+	unsigned char *metromem_wfm;
+	unsigned char *metromem_img;
+	u16 *metromem_img_csum;
+	u16 *csum_table;
+	int metromemsize;
+	dma_addr_t metromem_dma;
+	dma_addr_t metromem_desc_dma;
+	struct fb_info *info;
+	struct metronome_board *board;
+	wait_queue_head_t waitq;
+	u8 frame_count;
+};
+
+/* board specific routines */
+struct metronome_board {
+	struct module *owner;
+	void (*free_irq)(struct fb_info *);
+	void (*init_gpio_regs)(struct metronomefb_par *);
+	void (*init_lcdc_regs)(struct metronomefb_par *);
+	void (*post_dma_setup)(struct metronomefb_par *);
+	void (*set_rst)(struct metronomefb_par *, int);
+	void (*set_stdby)(struct metronomefb_par *, int);
+	int (*met_wait_event)(struct metronomefb_par *);
+	int (*met_wait_event_intr)(struct metronomefb_par *);
+	int (*setup_irq)(struct fb_info *);
+};
+
+#endif
_

Patches currently in -mm which might be from jayakumar.lkml@gmail.com are

origin.patch
git-arm.patch

