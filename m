From: akpm@linux-foundation.org
Subject: - fbdev-defio-and-metronomefb-v4.patch removed from -mm tree
Date: Fri, 21 Mar 2008 13:30:15 -0700
Message-ID: <200803212030.m2LKUFeP008968@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49288 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757863AbYCUUaU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 16:30:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jayakumar.lkml@gmail.com, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     fbdev: defio and Metronomefb
has been removed from the -mm tree.  Its filename was
     fbdev-defio-and-metronomefb-v4.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: defio and Metronomefb
From: Jaya Kumar <jayakumar.lkml@gmail.com>

Implement support for the E-Ink Metronome controller.  It provides an mmapable
interface to the controller using defio support.  It was tested with a gumstix
pxa255 with Vizplex media using Xfbdev and various X clients such as xeyes,
xpdf, xloadimage.

This patch also fixes the following bug: Defio would cause a hang on write
access to the framebuffer as the page fault would be called ad-infinitum.  It
fixes fb_defio by setting the mapping to be used by page_mkclean.

Signed-off-by: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/fb/cmap_xfbdev.txt |   53 +
 Documentation/fb/metronomefb.txt |   38 +
 drivers/video/Kconfig            |   14 
 drivers/video/Makefile           |    1 
 drivers/video/fb_defio.c         |   22 
 drivers/video/metronomefb.c      |  999 +++++++++++++++++++++++++++++
 6 files changed, 1125 insertions(+), 2 deletions(-)

diff -puN /dev/null Documentation/fb/cmap_xfbdev.txt
--- /dev/null
+++ a/Documentation/fb/cmap_xfbdev.txt
@@ -0,0 +1,53 @@
+Understanding fbdev's cmap
+--------------------------
+
+These notes explain how X's dix layer uses fbdev's cmap structures.
+
+*. example of relevant structures in fbdev as used for a 3-bit grayscale cmap
+struct fb_var_screeninfo {
+        .bits_per_pixel = 8,
+        .grayscale      = 1,
+        .red =          { 4, 3, 0 },
+        .green =        { 0, 0, 0 },
+        .blue =         { 0, 0, 0 },
+}
+struct fb_fix_screeninfo {
+        .visual =       FB_VISUAL_STATIC_PSEUDOCOLOR,
+}
+for (i = 0; i < 8; i++)
+	info->cmap.red[i] = (((2*i)+1)*(0xFFFF))/16;
+memcpy(info->cmap.green, info->cmap.red, sizeof(u16)*8);
+memcpy(info->cmap.blue, info->cmap.red, sizeof(u16)*8);
+
+*. X11 apps do something like the following when trying to use grayscale.
+for (i=0; i < 8; i++) {
+	char colorspec[64];
+	memset(colorspec,0,64);
+	sprintf(colorspec, "rgb:%x/%x/%x", i*36,i*36,i*36);
+	if (!XParseColor(outputDisplay, testColormap, colorspec, &wantedColor))
+		printf("Can't get color %s\n",colorspec);
+	XAllocColor(outputDisplay, testColormap, &wantedColor);
+	grays[i] = wantedColor;
+}
+There's also named equivalents like gray1..x provided you have an rgb.txt.
+
+Somewhere in X's callchain, this results in a call to X code that handles the
+colormap. For example, Xfbdev hits the following:
+
+xc-011010/programs/Xserver/dix/colormap.c:
+
+FindBestPixel(pentFirst, size, prgb, channel)
+
+dr = (long) pent->co.local.red - prgb->red;
+dg = (long) pent->co.local.green - prgb->green;
+db = (long) pent->co.local.blue - prgb->blue;
+sq = dr * dr;
+UnsignedToBigNum (sq, &sum);
+BigNumAdd (&sum, &temp, &sum);
+
+co.local.red are entries that were brought in through FBIOGETCMAP which come
+directly from the info->cmap.red that was listed above. The prgb is the rgb
+that the app wants to match to. The above code is doing what looks like a least
+squares matching function. That's why the cmap entries can't be set to the left
+hand side boundaries of a color range.
+
diff -puN /dev/null Documentation/fb/metronomefb.txt
--- /dev/null
+++ a/Documentation/fb/metronomefb.txt
@@ -0,0 +1,38 @@
+			Metronomefb
+			-----------
+Maintained by Jaya Kumar <jayakumar.lkml.gmail.com>
+Last revised: Nov 20, 2007
+
+Metronomefb is a driver for the Metronome display controller. The controller
+is from E-Ink Corporation. It is intended to be used to drive the E-Ink
+Vizplex display media. E-Ink hosts some details of this controller and the
+display media here http://www.e-ink.com/products/matrix/metronome.html .
+
+Metronome is interfaced to the host CPU through the AMLCD interface. The
+host CPU generates the control information and the image in a framebuffer
+which is then delivered to the AMLCD interface by a host specific method.
+Currently, that's implemented for the PXA's LCDC controller. The display and
+error status are each pulled through individual GPIOs.
+
+Metronomefb was written for the PXA255/gumstix/lyre combination and
+therefore currently has board set specific code in it. If other boards based on
+other architectures are available, then the host specific code can be separated
+and abstracted out.
+
+Metronomefb requires waveform information which is delivered via the AMLCD
+interface to the metronome controller. The waveform information is expected to
+be delivered from userspace via the firmware class interface. The waveform file
+can be compressed as long as your udev or hotplug script is aware of the need
+to uncompress it before delivering it. metronomefb will ask for waveform.wbf
+which would typically go into /lib/firmware/waveform.wbf depending on your
+udev/hotplug setup. I have only tested with a single waveform file which was
+originally labeled 23P01201_60_WT0107_MTC. I do not know what it stands for.
+Caution should be exercised when manipulating the waveform as there may be
+a possibility that it could have some permanent effects on the display media.
+I neither have access to nor know exactly what the waveform does in terms of
+the physical media.
+
+Metronomefb uses the deferred IO interface so that it can provide a memory
+mappable frame buffer. It has been tested with tinyx (Xfbdev). It is known
+to work at this time with xeyes, xclock, xloadimage, xpdf.
+
diff -puN drivers/video/Kconfig~fbdev-defio-and-metronomefb-v4 drivers/video/Kconfig
--- a/drivers/video/Kconfig~fbdev-defio-and-metronomefb-v4
+++ a/drivers/video/Kconfig
@@ -1893,6 +1893,20 @@ config FB_XILINX
 	  framebuffer. ML300 carries a 640*480 LCD display on the board,
 	  ML403 uses a standard DB15 VGA connector.
 
+config FB_METRONOME
+       tristate "Metronome display controller support"
+       depends on FB && ARCH_PXA && MMU
+       select FB_SYS_FILLRECT
+       select FB_SYS_COPYAREA
+       select FB_SYS_IMAGEBLIT
+       select FB_SYS_FOPS
+       select FB_DEFERRED_IO
+       help
+         This enables support for the Metronome display controller. Tested
+         with an E-Ink 800x600 display and Gumstix Connex through an AMLCD
+         interface. Please read <file:Documentation/fb/metronomefb.txt>
+         for more information.
+
 config FB_VIRTUAL
 	tristate "Virtual Frame Buffer support (ONLY FOR TESTING!)"
 	depends on FB
diff -puN drivers/video/Makefile~fbdev-defio-and-metronomefb-v4 drivers/video/Makefile
--- a/drivers/video/Makefile~fbdev-defio-and-metronomefb-v4
+++ a/drivers/video/Makefile
@@ -103,6 +103,7 @@ obj-$(CONFIG_FB_PMAG_AA)	  += pmag-aa-fb
 obj-$(CONFIG_FB_PMAG_BA)	  += pmag-ba-fb.o
 obj-$(CONFIG_FB_PMAGB_B)	  += pmagb-b-fb.o
 obj-$(CONFIG_FB_MAXINE)		  += maxinefb.o
+obj-$(CONFIG_FB_METRONOME)        += metronomefb.o
 obj-$(CONFIG_FB_S1D13XXX)	  += s1d13xxxfb.o
 obj-$(CONFIG_FB_IMX)              += imxfb.o
 obj-$(CONFIG_FB_S3C2410)	  += s3c2410fb.o
diff -puN drivers/video/fb_defio.c~fbdev-defio-and-metronomefb-v4 drivers/video/fb_defio.c
--- a/drivers/video/fb_defio.c~fbdev-defio-and-metronomefb-v4
+++ a/drivers/video/fb_defio.c
@@ -4,7 +4,7 @@
  *  Copyright (C) 2006 Jaya Kumar
  *
  * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file COPYING in the main directory of this archive
+ * License. See the file COPYING in the main directory of this archive
  * for more details.
  */
 
@@ -31,7 +31,7 @@ static int fb_deferred_io_fault(struct v
 	unsigned long offset;
 	struct page *page;
 	struct fb_info *info = vma->vm_private_data;
-	/* info->screen_base is in System RAM */
+	/* info->screen_base is virtual memory */
 	void *screen_base = (void __force *) info->screen_base;
 
 	offset = vmf->pgoff << PAGE_SHIFT;
@@ -43,6 +43,15 @@ static int fb_deferred_io_fault(struct v
 		return VM_FAULT_SIGBUS;
 
 	get_page(page);
+
+	if (vma->vm_file)
+		page->mapping = vma->vm_file->f_mapping;
+	else
+		printk(KERN_ERR "no mapping available\n");
+
+	BUG_ON(!page->mapping);
+	page->index = vmf->pgoff;
+
 	vmf->page = page;
 	return 0;
 }
@@ -138,11 +147,20 @@ EXPORT_SYMBOL_GPL(fb_deferred_io_init);
 
 void fb_deferred_io_cleanup(struct fb_info *info)
 {
+	void *screen_base = (void __force *) info->screen_base;
 	struct fb_deferred_io *fbdefio = info->fbdefio;
+	struct page *page;
+	int i;
 
 	BUG_ON(!fbdefio);
 	cancel_delayed_work(&info->deferred_work);
 	flush_scheduled_work();
+
+	/* clear out the mapping that we setup */
+	for (i = 0 ; i < info->fix.smem_len; i += PAGE_SIZE) {
+		page = vmalloc_to_page(screen_base + i);
+		page->mapping = NULL;
+	}
 }
 EXPORT_SYMBOL_GPL(fb_deferred_io_cleanup);
 
diff -puN /dev/null drivers/video/metronomefb.c
--- /dev/null
+++ a/drivers/video/metronomefb.c
@@ -0,0 +1,999 @@
+/*
+ * linux/drivers/video/metronomefb.c -- FB driver for Metronome controller
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
+ * It was tested with an E-Ink 800x600 Vizplex EPD on a Gumstix Connex board
+ * using the Lyre interface board.
+ *
+ * General notes:
+ * - User must set metronomefb_enable=1 to enable it.
+ * - See Documentation/fb/metronomefb.txt for how metronome works.
+ */
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/fb.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/list.h>
+#include <linux/firmware.h>
+#include <linux/dma-mapping.h>
+#include <linux/uaccess.h>
+#include <linux/irq.h>
+
+#include <asm/arch/pxa-regs.h>
+#include <asm/unaligned.h>
+
+#define DEBUG 1
+#ifdef DEBUG
+#define DPRINTK(f, a...) printk(KERN_DEBUG "%s: " f, __func__ , ## a)
+#else
+#define DPRINTK(f, a...)
+#endif
+
+
+/* Display specific information */
+#define DPY_W 832
+#define DPY_H 622
+
+struct metromem_desc {
+	u32 mFDADR0;
+	u32 mFSADR0;
+	u32 mFIDR0;
+	u32 mLDCMD0;
+};
+
+struct metromem_cmd {
+	u16 opcode;
+	u16 args[((64-2)/2)];
+	u16 csum;
+};
+
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
+	wait_queue_head_t waitq;
+	u8 frame_count;
+};
+
+/* frame differs from image. frame includes non-visible pixels */
+struct epd_frame {
+	int fw; /* frame width */
+	int fh; /* frame height */
+};
+
+static struct epd_frame epd_frame_table[] = {
+	{
+	.fw = 832,
+	.fh = 622
+	},
+};
+
+static struct fb_fix_screeninfo metronomefb_fix __devinitdata = {
+	.id =		"metronomefb",
+	.type =		FB_TYPE_PACKED_PIXELS,
+	.visual =	FB_VISUAL_STATIC_PSEUDOCOLOR,
+	.xpanstep =	0,
+	.ypanstep =	0,
+	.ywrapstep =	0,
+	.line_length =	DPY_W,
+	.accel =	FB_ACCEL_NONE,
+};
+
+static struct fb_var_screeninfo metronomefb_var __devinitdata = {
+	.xres		= DPY_W,
+	.yres		= DPY_H,
+	.xres_virtual	= DPY_W,
+	.yres_virtual	= DPY_H,
+	.bits_per_pixel	= 8,
+	.grayscale	= 1,
+	.nonstd		= 1,
+	.red =		{ 4, 3, 0 },
+	.green =	{ 0, 0, 0 },
+	.blue =		{ 0, 0, 0 },
+	.transp =	{ 0, 0, 0 },
+};
+
+static unsigned int metronomefb_enable;
+
+struct waveform_hdr {
+	u8 stuff[32];
+
+	u8 wmta[3];
+	u8 fvsn;
+
+	u8 luts;
+	u8 mc;
+	u8 trc;
+	u8 stuff3;
+
+	u8 endb;
+	u8 swtb;
+	u8 stuff2a[2];
+
+	u8 stuff2b[3];
+	u8 wfm_cs;
+} __attribute__ ((packed));
+
+/* main metronomefb functions */
+static u8 calc_cksum(int start, int end, u8 *mem)
+{
+	u8 tmp = 0;
+	int i;
+
+	for (i = start; i < end; i++)
+		tmp += mem[i];
+
+	return tmp;
+}
+
+static u16 calc_img_cksum(u16 *start, int length)
+{
+	u16 tmp = 0;
+
+	while (length--)
+		tmp += *start++;
+
+	return tmp;
+}
+
+/* here we decode the incoming waveform file and populate metromem */
+#define EXP_WFORM_SIZE 47001
+static int load_waveform(u8 *mem, size_t size, u8 *metromem, int m, int t,
+				u8 *frame_count)
+{
+	int tta;
+	int wmta;
+	int trn = 0;
+	int i;
+	unsigned char v;
+	u8 cksum;
+	int cksum_idx;
+	int wfm_idx, owfm_idx;
+	int mem_idx = 0;
+	struct waveform_hdr *wfm_hdr;
+
+	if (size != EXP_WFORM_SIZE) {
+		printk(KERN_ERR "Error: unexpected size %d != %d\n", size,
+					EXP_WFORM_SIZE);
+		return -EINVAL;
+	}
+
+	wfm_hdr = (struct waveform_hdr *) mem;
+
+	if (wfm_hdr->fvsn != 1) {
+		printk(KERN_ERR "Error: bad fvsn %x\n", wfm_hdr->fvsn);
+		return -EINVAL;
+	}
+	if (wfm_hdr->luts != 0) {
+		printk(KERN_ERR "Error: bad luts %x\n", wfm_hdr->luts);
+		return -EINVAL;
+	}
+	cksum = calc_cksum(32, 47, mem);
+	if (cksum != wfm_hdr->wfm_cs) {
+		printk(KERN_ERR "Error: bad cksum %x != %x\n", cksum,
+					wfm_hdr->wfm_cs);
+		return -EINVAL;
+	}
+	wfm_hdr->mc += 1;
+	wfm_hdr->trc += 1;
+	for (i = 0; i < 5; i++) {
+		if (*(wfm_hdr->stuff2a + i) != 0) {
+			printk(KERN_ERR "Error: unexpected value in padding\n");
+			return -EINVAL;
+		}
+	}
+
+	/* calculating trn. trn is something used to index into
+	the waveform. presumably selecting the right one for the
+	desired temperature. it works out the offset of the first
+	v that exceeds the specified temperature */
+	if ((sizeof(*wfm_hdr) + wfm_hdr->trc) > size)
+		return -EINVAL;
+
+	for (i = sizeof(*wfm_hdr); i <= sizeof(*wfm_hdr) + wfm_hdr->trc; i++) {
+		if (mem[i] > t) {
+			trn = i - sizeof(*wfm_hdr) - 1;
+			break;
+		}
+	}
+
+	/* check temperature range table checksum */
+	cksum_idx = sizeof(*wfm_hdr) + wfm_hdr->trc + 1;
+	if (cksum_idx > size)
+		return -EINVAL;
+	cksum = calc_cksum(sizeof(*wfm_hdr), cksum_idx, mem);
+	if (cksum != mem[cksum_idx]) {
+		printk(KERN_ERR "Error: bad temperature range table cksum"
+				" %x != %x\n", cksum, mem[cksum_idx]);
+		return -EINVAL;
+	}
+
+	/* check waveform mode table address checksum */
+	wmta = le32_to_cpu(get_unaligned((__le32 *) wfm_hdr->wmta));
+	wmta &= 0x00FFFFFF;
+	cksum_idx = wmta + m*4 + 3;
+	if (cksum_idx > size)
+		return -EINVAL;
+	cksum = calc_cksum(cksum_idx - 3, cksum_idx, mem);
+	if (cksum != mem[cksum_idx]) {
+		printk(KERN_ERR "Error: bad mode table address cksum"
+				" %x != %x\n", cksum, mem[cksum_idx]);
+		return -EINVAL;
+	}
+
+	/* check waveform temperature table address checksum */
+	tta = le32_to_cpu(get_unaligned((int *) (mem + wmta + m*4)));
+	tta &= 0x00FFFFFF;
+	cksum_idx = tta + trn*4 + 3;
+	if (cksum_idx > size)
+		return -EINVAL;
+	cksum = calc_cksum(cksum_idx - 3, cksum_idx, mem);
+	if (cksum != mem[cksum_idx]) {
+		printk(KERN_ERR "Error: bad temperature table address cksum"
+			" %x != %x\n", cksum, mem[cksum_idx]);
+		return -EINVAL;
+	}
+
+	/* here we do the real work of putting the waveform into the
+	metromem buffer. this does runlength decoding of the waveform */
+	wfm_idx = le32_to_cpu(get_unaligned((__le32 *) (mem + tta + trn*4)));
+	wfm_idx &= 0x00FFFFFF;
+	owfm_idx = wfm_idx;
+	if (wfm_idx > size)
+		return -EINVAL;
+	while (wfm_idx < size) {
+		unsigned char rl;
+		v = mem[wfm_idx++];
+		if (v == wfm_hdr->swtb) {
+			while (((v = mem[wfm_idx++]) != wfm_hdr->swtb) &&
+				wfm_idx < size)
+				metromem[mem_idx++] = v;
+
+			continue;
+		}
+
+		if (v == wfm_hdr->endb)
+			break;
+
+		rl = mem[wfm_idx++];
+		for (i = 0; i <= rl; i++)
+			metromem[mem_idx++] = v;
+	}
+
+	cksum_idx = wfm_idx;
+	if (cksum_idx > size)
+		return -EINVAL;
+	cksum = calc_cksum(owfm_idx, cksum_idx, mem);
+	if (cksum != mem[cksum_idx]) {
+		printk(KERN_ERR "Error: bad waveform data cksum"
+				" %x != %x\n", cksum, mem[cksum_idx]);
+		return -EINVAL;
+	}
+	*frame_count = (mem_idx/64);
+
+	return 0;
+}
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
+static void metronome_set_gpio_output(int pin, int val)
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
+static void __devinit metronome_init_gpio_pin(int pin, int dir)
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
+static void __devinit metronome_init_gpio_regs(void)
+{
+	metronome_init_gpio_pin(LED_GPIO_PIN, 0);
+	metronome_set_gpio_output(LED_GPIO_PIN, 0);
+
+	metronome_init_gpio_pin(STDBY_GPIO_PIN, 0);
+	metronome_set_gpio_output(STDBY_GPIO_PIN, 0);
+
+	metronome_init_gpio_pin(RST_GPIO_PIN, 0);
+	metronome_set_gpio_output(RST_GPIO_PIN, 0);
+
+	metronome_init_gpio_pin(RDY_GPIO_PIN, 1);
+
+	metronome_init_gpio_pin(ERR_GPIO_PIN, 1);
+
+	metronome_init_gpio_pin(PCBPWR_GPIO_PIN, 0);
+	metronome_set_gpio_output(PCBPWR_GPIO_PIN, 0);
+}
+
+static void metronome_disable_lcd_controller(struct metronomefb_par *par)
+{
+	LCSR = 0xffffffff;	/* Clear LCD Status Register */
+	LCCR0 |= LCCR0_DIS;	/* Disable LCD Controller */
+
+	/* we reset and just wait for things to settle */
+	msleep(200);
+}
+
+static void metronome_enable_lcd_controller(struct metronomefb_par *par)
+{
+	LCSR = 0xffffffff;
+	FDADR0 = par->metromem_desc_dma;
+	LCCR0 |= LCCR0_ENB;
+}
+
+static void __devinit metronome_init_lcdc_regs(struct metronomefb_par *par)
+{
+	/* here we do:
+	- disable the lcd controller
+	- setup lcd control registers
+	- setup dma descriptor
+	- reenable lcd controller
+	*/
+
+	/* disable the lcd controller */
+	metronome_disable_lcd_controller(par);
+
+	/* setup lcd control registers */
+	LCCR0 = LCCR0_LDM | LCCR0_SFM | LCCR0_IUM | LCCR0_EFM | LCCR0_PAS
+		| LCCR0_QDM | LCCR0_BM | LCCR0_OUM;
+
+	LCCR1 = (epd_frame_table[0].fw/2 - 1) /* pixels per line */
+		| (27 << 10) /* hsync pulse width - 1 */
+		| (33 << 16) /* eol pixel count */
+		| (33 << 24); /* bol pixel count */
+
+	LCCR2 = (epd_frame_table[0].fh - 1) /* lines per panel */
+		| (24 << 10) /* vsync pulse width - 1 */
+		| (2 << 16) /* eof pixel count */
+		| (0 << 24); /* bof pixel count */
+
+	LCCR3 = 2 /* pixel clock divisor */
+		| (24 << 8) /* AC Bias pin freq */
+		| LCCR3_16BPP /* BPP */
+		| LCCR3_PCP;  /* PCP falling edge */
+
+	/* setup dma descriptor */
+	par->metromem_desc->mFDADR0 = par->metromem_desc_dma;
+	par->metromem_desc->mFSADR0 = par->metromem_dma;
+	par->metromem_desc->mFIDR0 = 0;
+	par->metromem_desc->mLDCMD0 = epd_frame_table[0].fw
+					* epd_frame_table[0].fh;
+	/* reenable lcd controller */
+	metronome_enable_lcd_controller(par);
+}
+
+static int metronome_display_cmd(struct metronomefb_par *par)
+{
+	int i;
+	u16 cs;
+	u16 opcode;
+	static u8 borderval;
+	u8 *ptr;
+
+	/* setup display command
+	we can't immediately set the opcode since the controller
+	will try parse the command before we've set it all up
+	so we just set cs here and set the opcode at the end */
+
+	ptr = par->metromem;
+
+	if (par->metromem_cmd->opcode == 0xCC40)
+		opcode = cs = 0xCC41;
+	else
+		opcode = cs = 0xCC40;
+
+	/* set the args ( 2 bytes ) for display */
+	i = 0;
+	par->metromem_cmd->args[i] = 	1 << 3 /* border update */
+					| ((borderval++ % 4) & 0x0F) << 4
+					| (par->frame_count - 1) << 8;
+	cs += par->metromem_cmd->args[i++];
+
+	/* the rest are 0 */
+	memset((u8 *) (par->metromem_cmd->args + i), 0, (32-i)*2);
+
+	par->metromem_cmd->csum = cs;
+	par->metromem_cmd->opcode = opcode; /* display cmd */
+
+	i = wait_event_interruptible_timeout(par->waitq, (GPLR1 & 0x01), HZ);
+	return i;
+}
+
+static int __devinit metronome_powerup_cmd(struct metronomefb_par *par)
+{
+	int i;
+	u16 cs;
+
+	/* setup power up command */
+	par->metromem_cmd->opcode = 0x1234; /* pwr up pseudo cmd */
+	cs = par->metromem_cmd->opcode;
+
+	/* set pwr1,2,3 to 1024 */
+	for (i = 0; i < 3; i++) {
+		par->metromem_cmd->args[i] = 1024;
+		cs += par->metromem_cmd->args[i];
+	}
+
+	/* the rest are 0 */
+	memset((u8 *) (par->metromem_cmd->args + i), 0, (32-i)*2);
+
+	par->metromem_cmd->csum = cs;
+
+	msleep(1);
+	metronome_set_gpio_output(RST_GPIO_PIN, 1);
+
+	msleep(1);
+	metronome_set_gpio_output(STDBY_GPIO_PIN, 1);
+
+	i = wait_event_timeout(par->waitq, (GPLR1 & 0x01), HZ);
+	return i;
+}
+
+static int __devinit metronome_config_cmd(struct metronomefb_par *par)
+{
+	int i;
+	u16 cs;
+
+	/* setup config command
+	we can't immediately set the opcode since the controller
+	will try parse the command before we've set it all up
+	so we just set cs here and set the opcode at the end */
+
+	cs = 0xCC10;
+
+	/* set the 12 args ( 8 bytes ) for config. see spec for meanings */
+	i = 0;
+	par->metromem_cmd->args[i] = 	15 /* sdlew */
+					| 2 << 8 /* sdosz */
+					| 0 << 11 /* sdor */
+					| 0 << 12 /* sdces */
+					| 0 << 15; /* sdcer */
+	cs += par->metromem_cmd->args[i++];
+
+	par->metromem_cmd->args[i] = 	42 /* gdspl */
+					| 1 << 8 /* gdr1 */
+					| 1 << 9 /* sdshr */
+					| 0 << 15; /* gdspp */
+	cs += par->metromem_cmd->args[i++];
+
+	par->metromem_cmd->args[i] = 	18 /* gdspw */
+					| 0 << 15; /* dispc */
+	cs += par->metromem_cmd->args[i++];
+
+	par->metromem_cmd->args[i] = 	599 /* vdlc */
+					| 0 << 11 /* dsi */
+					| 0 << 12; /* dsic */
+	cs += par->metromem_cmd->args[i++];
+
+	/* the rest are 0 */
+	memset((u8 *) (par->metromem_cmd->args + i), 0, (32-i)*2);
+
+	par->metromem_cmd->csum = cs;
+	par->metromem_cmd->opcode = 0xCC10; /* config cmd */
+
+	i = wait_event_timeout(par->waitq, (GPLR1 & 0x01), HZ);
+	return i;
+}
+
+static int __devinit metronome_init_cmd(struct metronomefb_par *par)
+{
+	int i;
+	u16 cs;
+
+	/* setup init command
+	we can't immediately set the opcode since the controller
+	will try parse the command before we've set it all up
+	so we just set cs here and set the opcode at the end */
+
+	cs = 0xCC20;
+
+	/* set the args ( 2 bytes ) for init */
+	i = 0;
+	par->metromem_cmd->args[i] = 0;
+	cs += par->metromem_cmd->args[i++];
+
+	/* the rest are 0 */
+	memset((u8 *) (par->metromem_cmd->args + i), 0, (32-i)*2);
+
+	par->metromem_cmd->csum = cs;
+	par->metromem_cmd->opcode = 0xCC20; /* init cmd */
+
+	i = wait_event_timeout(par->waitq, (GPLR1 & 0x01), HZ);
+	return i;
+}
+
+static int __devinit metronome_init_regs(struct metronomefb_par *par)
+{
+	int res;
+
+	metronome_init_gpio_regs();
+	metronome_init_lcdc_regs(par);
+
+	res = metronome_powerup_cmd(par);
+	if (res)
+		return res;
+
+	res = metronome_config_cmd(par);
+	if (res)
+		return res;
+
+	res = metronome_init_cmd(par);
+	if (res)
+		return res;
+
+	return res;
+}
+
+static void metronomefb_dpy_update(struct metronomefb_par *par)
+{
+	u16 cksum;
+	unsigned char *buf = (unsigned char __force *)par->info->screen_base;
+
+	/* copy from vm to metromem */
+	memcpy(par->metromem_img, buf, DPY_W*DPY_H);
+
+	cksum = calc_img_cksum((u16 *) par->metromem_img,
+				(epd_frame_table[0].fw * DPY_H)/2);
+	*((u16 *) (par->metromem_img) +
+			(epd_frame_table[0].fw * DPY_H)/2) = cksum;
+	metronome_display_cmd(par);
+}
+
+static u16 metronomefb_dpy_update_page(struct metronomefb_par *par, int index)
+{
+	int i;
+	u16 csum = 0;
+	u16 *buf = (u16 __force *) (par->info->screen_base + index);
+	u16 *img = (u16 *) (par->metromem_img + index);
+
+	/* swizzle from vm to metromem and recalc cksum at the same time*/
+	for (i = 0; i < PAGE_SIZE/2; i++) {
+		*(img + i) = (buf[i] << 5) & 0xE0E0;
+		csum += *(img + i);
+	}
+	return csum;
+}
+
+/* this is called back from the deferred io workqueue */
+static void metronomefb_dpy_deferred_io(struct fb_info *info,
+				struct list_head *pagelist)
+{
+	u16 cksum;
+	struct page *cur;
+	struct fb_deferred_io *fbdefio = info->fbdefio;
+	struct metronomefb_par *par = info->par;
+
+	/* walk the written page list and swizzle the data */
+	list_for_each_entry(cur, &fbdefio->pagelist, lru) {
+		cksum = metronomefb_dpy_update_page(par,
+					(cur->index << PAGE_SHIFT));
+		par->metromem_img_csum -= par->csum_table[cur->index];
+		par->csum_table[cur->index] = cksum;
+		par->metromem_img_csum += cksum;
+	}
+
+	metronome_display_cmd(par);
+}
+
+static void metronomefb_fillrect(struct fb_info *info,
+				   const struct fb_fillrect *rect)
+{
+	struct metronomefb_par *par = info->par;
+
+	cfb_fillrect(info, rect);
+	metronomefb_dpy_update(par);
+}
+
+static void metronomefb_copyarea(struct fb_info *info,
+				   const struct fb_copyarea *area)
+{
+	struct metronomefb_par *par = info->par;
+
+	cfb_copyarea(info, area);
+	metronomefb_dpy_update(par);
+}
+
+static void metronomefb_imageblit(struct fb_info *info,
+				const struct fb_image *image)
+{
+	struct metronomefb_par *par = info->par;
+
+	cfb_imageblit(info, image);
+	metronomefb_dpy_update(par);
+}
+
+/*
+ * this is the slow path from userspace. they can seek and write to
+ * the fb. it is based on fb_sys_write
+ */
+static ssize_t metronomefb_write(struct fb_info *info, const char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	struct metronomefb_par *par = info->par;
+	unsigned long p = *ppos;
+	void *dst;
+	int err = 0;
+	unsigned long total_size;
+
+	if (info->state != FBINFO_STATE_RUNNING)
+		return -EPERM;
+
+	total_size = info->fix.smem_len;
+
+	if (p > total_size)
+		return -EFBIG;
+
+	if (count > total_size) {
+		err = -EFBIG;
+		count = total_size;
+	}
+
+	if (count + p > total_size) {
+		if (!err)
+			err = -ENOSPC;
+
+		count = total_size - p;
+	}
+
+	dst = (void __force *) (info->screen_base + p);
+
+	if (copy_from_user(dst, buf, count))
+		err = -EFAULT;
+
+	if  (!err)
+		*ppos += count;
+
+	metronomefb_dpy_update(par);
+
+	return (err) ? err : count;
+}
+
+static struct fb_ops metronomefb_ops = {
+	.owner		= THIS_MODULE,
+	.fb_write	= metronomefb_write,
+	.fb_fillrect	= metronomefb_fillrect,
+	.fb_copyarea	= metronomefb_copyarea,
+	.fb_imageblit	= metronomefb_imageblit,
+};
+
+static struct fb_deferred_io metronomefb_defio = {
+	.delay		= HZ,
+	.deferred_io	= metronomefb_dpy_deferred_io,
+};
+
+static irqreturn_t metronome_handle_irq(int irq, void *dev_id)
+{
+	struct fb_info *info = dev_id;
+	struct metronomefb_par *par = info->par;
+
+	wake_up_interruptible(&par->waitq);
+	return IRQ_HANDLED;
+}
+
+static int __devinit metronomefb_probe(struct platform_device *dev)
+{
+	struct fb_info *info;
+	int retval = -ENOMEM;
+	int videomemorysize;
+	unsigned char *videomemory;
+	struct metronomefb_par *par;
+	const struct firmware *fw_entry;
+	int cmd_size, wfm_size, img_size, padding_size, totalsize;
+	int i;
+
+	/* we have two blocks of memory.
+	info->screen_base which is vm, and is the fb used by apps.
+	par->metromem which is physically contiguous memory and
+	contains the display controller commands, waveform,
+	processed image data and padding. this is the data pulled
+	by the pxa255's LCD controller and pushed to Metronome */
+
+	videomemorysize = (DPY_W*DPY_H);
+	videomemory = vmalloc(videomemorysize);
+	if (!videomemory)
+		return retval;
+
+	memset(videomemory, 0, videomemorysize);
+
+	info = framebuffer_alloc(sizeof(struct metronomefb_par), &dev->dev);
+	if (!info)
+		goto err_vfree;
+
+	info->screen_base = (char __iomem *) videomemory;
+	info->fbops = &metronomefb_ops;
+
+	info->var = metronomefb_var;
+	info->fix = metronomefb_fix;
+	info->fix.smem_len = videomemorysize;
+	par = info->par;
+	par->info = info;
+	init_waitqueue_head(&par->waitq);
+
+	/* this table caches per page csum values. */
+	par->csum_table = vmalloc(videomemorysize/PAGE_SIZE);
+	if (!par->csum_table)
+		goto err_csum_table;
+
+	/* the metromem buffer is divided as follows:
+	command | CRC | padding
+	16kb waveform data | CRC | padding
+	image data | CRC
+	and an extra 256 bytes for dma descriptors
+	eg: IW=832 IH=622 WS=128
+	*/
+
+	cmd_size = 1 * epd_frame_table[0].fw;
+	wfm_size = ((16*1024 + 2 + epd_frame_table[0].fw - 1)
+			/ epd_frame_table[0].fw) * epd_frame_table[0].fw;
+	img_size = epd_frame_table[0].fh * epd_frame_table[0].fw;
+	padding_size = 4 * epd_frame_table[0].fw;
+	totalsize = cmd_size + wfm_size + img_size + padding_size;
+	par->metromemsize = PAGE_ALIGN(totalsize + 256);
+	DPRINTK("desired memory size = %d\n", par->metromemsize);
+	dev->dev.coherent_dma_mask = 0xffffffffull;
+	par->metromem = dma_alloc_writecombine(&dev->dev, par->metromemsize,
+						&par->metromem_dma, GFP_KERNEL);
+	if (!par->metromem) {
+		printk(KERN_ERR
+			"metronomefb: unable to allocate dma buffer\n");
+		goto err_vfree;
+	}
+
+	info->fix.smem_start = par->metromem_dma;
+	par->metromem_cmd = (struct metromem_cmd *) par->metromem;
+	par->metromem_wfm = par->metromem + cmd_size;
+	par->metromem_img = par->metromem + cmd_size + wfm_size;
+	par->metromem_img_csum = (u16 *) (par->metromem_img +
+					(epd_frame_table[0].fw * DPY_H));
+	DPRINTK("img offset=0x%x\n", cmd_size + wfm_size);
+	par->metromem_desc = (struct metromem_desc *) (par->metromem + cmd_size
+					+ wfm_size + img_size + padding_size);
+	par->metromem_desc_dma = par->metromem_dma + cmd_size + wfm_size
+				 + img_size + padding_size;
+
+	/* load the waveform in. assume mode 3, temp 31 for now */
+	/* 	a) request the waveform file from userspace
+		b) process waveform and decode into metromem */
+
+	retval = request_firmware(&fw_entry, "waveform.wbf", &dev->dev);
+	if (retval < 0) {
+		printk(KERN_ERR "metronomefb: couldn't get waveform\n");
+		goto err_dma_free;
+	}
+
+	retval = load_waveform((u8 *) fw_entry->data, fw_entry->size,
+				par->metromem_wfm, 3, 31, &par->frame_count);
+	if (retval < 0) {
+		printk(KERN_ERR "metronomefb: couldn't process waveform\n");
+		goto err_ld_wfm;
+	}
+	release_firmware(fw_entry);
+
+	retval = request_irq(IRQ_GPIO(RDY_GPIO_PIN), metronome_handle_irq,
+				IRQF_DISABLED, "Metronome", info);
+	if (retval) {
+		dev_err(&dev->dev, "request_irq failed: %d\n", retval);
+		goto err_ld_wfm;
+	}
+	set_irq_type(IRQ_GPIO(RDY_GPIO_PIN), IRQT_FALLING);
+
+	retval = metronome_init_regs(par);
+	if (retval < 0)
+		goto err_free_irq;
+
+	info->flags = FBINFO_FLAG_DEFAULT;
+
+	info->fbdefio = &metronomefb_defio;
+	fb_deferred_io_init(info);
+
+	retval = fb_alloc_cmap(&info->cmap, 8, 0);
+	if (retval < 0) {
+		printk(KERN_ERR "Failed to allocate colormap\n");
+		goto err_fb_rel;
+	}
+
+	/* set cmap */
+	for (i = 0; i < 8; i++)
+		info->cmap.red[i] = (((2*i)+1)*(0xFFFF))/16;
+	memcpy(info->cmap.green, info->cmap.red, sizeof(u16)*8);
+	memcpy(info->cmap.blue, info->cmap.red, sizeof(u16)*8);
+
+	retval = register_framebuffer(info);
+	if (retval < 0)
+		goto err_cmap;
+
+	platform_set_drvdata(dev, info);
+
+	printk(KERN_INFO
+		"fb%d: Metronome frame buffer device, using %dK of video"
+		" memory\n", info->node, videomemorysize >> 10);
+
+	return 0;
+
+err_cmap:
+	fb_dealloc_cmap(&info->cmap);
+err_fb_rel:
+	framebuffer_release(info);
+err_free_irq:
+	free_irq(IRQ_GPIO(RDY_GPIO_PIN), info);
+err_ld_wfm:
+	release_firmware(fw_entry);
+err_dma_free:
+	dma_free_writecombine(&dev->dev, par->metromemsize, par->metromem,
+				par->metromem_dma);
+err_csum_table:
+	vfree(par->csum_table);
+err_vfree:
+	vfree(videomemory);
+	return retval;
+}
+
+static int __devexit metronomefb_remove(struct platform_device *dev)
+{
+	struct fb_info *info = platform_get_drvdata(dev);
+
+	if (info) {
+		struct metronomefb_par *par = info->par;
+		fb_deferred_io_cleanup(info);
+		dma_free_writecombine(&dev->dev, par->metromemsize,
+					par->metromem, par->metromem_dma);
+		fb_dealloc_cmap(&info->cmap);
+		vfree(par->csum_table);
+		unregister_framebuffer(info);
+		vfree((void __force *)info->screen_base);
+		free_irq(IRQ_GPIO(RDY_GPIO_PIN), info);
+		framebuffer_release(info);
+	}
+	return 0;
+}
+
+static struct platform_driver metronomefb_driver = {
+	.probe	= metronomefb_probe,
+	.remove = metronomefb_remove,
+	.driver	= {
+		.name	= "metronomefb",
+	},
+};
+
+static struct platform_device *metronomefb_device;
+
+static int __init metronomefb_init(void)
+{
+	int ret;
+
+	if (!metronomefb_enable) {
+		printk(KERN_ERR
+			"Use metronomefb_enable to enable the device\n");
+		return -ENXIO;
+	}
+
+	ret = platform_driver_register(&metronomefb_driver);
+	if (!ret) {
+		metronomefb_device = platform_device_alloc("metronomefb", 0);
+		if (metronomefb_device)
+			ret = platform_device_add(metronomefb_device);
+		else
+			ret = -ENOMEM;
+
+		if (ret) {
+			platform_device_put(metronomefb_device);
+			platform_driver_unregister(&metronomefb_driver);
+		}
+	}
+	return ret;
+
+}
+
+static void __exit metronomefb_exit(void)
+{
+	platform_device_unregister(metronomefb_device);
+	platform_driver_unregister(&metronomefb_driver);
+}
+
+module_param(metronomefb_enable, uint, 0);
+MODULE_PARM_DESC(metronomefb_enable, "Enable communication with Metronome");
+
+module_init(metronomefb_init);
+module_exit(metronomefb_exit);
+
+MODULE_DESCRIPTION("fbdev driver for Metronome controller");
+MODULE_AUTHOR("Jaya Kumar");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from jayakumar.lkml@gmail.com are

origin.patch

