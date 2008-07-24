From: akpm@linux-foundation.org
Subject: - video-sh7760fb-sh7760-sh7763-lcdc-framebuffer-driver.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:33:16 -0700
Message-ID: <200807242333.m6ONXGTj011915@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757083AbYGXXeX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:34:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iwamatsu.nobuhiro@renesas.com, adaplas@pol.net, krzysztof.h1@poczta.fm, lethal@linux-sh.org, mano@roarinelk.homelinux.net, s.schaefer@schaefer-edv.de, mm-commits@vger.kernel.org


The patch titled
     video: sh7760fb: SH7760/SH7763 LCDC framebuffer driver
has been removed from the -mm tree.  Its filename was
     video-sh7760fb-sh7760-sh7763-lcdc-framebuffer-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: video: sh7760fb: SH7760/SH7763 LCDC framebuffer driver
From: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>

Framebuffer driver for the SH7760/SH7763 integrated LCD controller.

Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>
Signed-off-by: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
Reviewed-by: Paul Mundt <lethal@linux-sh.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Siegfried Schaefer <s.schaefer@schaefer-edv.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/fb/sh7760fb.txt |  131 ++++++
 drivers/video/Kconfig         |   13 
 drivers/video/Makefile        |    1 
 drivers/video/sh7760fb.c      |  658 ++++++++++++++++++++++++++++++++
 include/asm-sh/sh7760fb.h     |  197 +++++++++
 5 files changed, 1000 insertions(+)

diff -puN /dev/null Documentation/fb/sh7760fb.txt
--- /dev/null
+++ a/Documentation/fb/sh7760fb.txt
@@ -0,0 +1,131 @@
+SH7760/SH7763 integrated LCDC Framebuffer driver
+================================================
+
+0. Overwiew
+-----------
+The SH7760/SH7763 have an integrated LCD Display controller (LCDC) which
+supports (in theory) resolutions ranging from 1x1 to 1024x1024,
+with color depths ranging from 1 to 16 bits, on STN, DSTN and TFT Panels.
+
+Caveats:
+* Framebuffer memory must be a large chunk allocated at the top
+  of Area3 (HW requirement). Because of this requirement you should NOT
+  make the driver a module since at runtime it may become impossible to
+  get a large enough contiguous chunk of memory.
+
+* The driver does not support changing resolution while loaded
+  (displays aren't hotpluggable anyway)
+
+* Heavy flickering may be observed
+  a) if you're using 15/16bit color modes at >= 640x480 px resolutions,
+  b) during PCMCIA (or any other slow bus) activity.
+
+* Rotation works only 90degress clockwise, and only if horizontal
+  resolution is <= 320 pixels.
+
+files:   drivers/video/sh7760fb.c
+        include/asm-sh/sh7760fb.h
+        Documentation/fb/sh7760fb.txt
+
+1. Platform setup
+-----------------
+SH7760:
+ Video data is fetched via the DMABRG DMA engine, so you have to
+ configure the SH DMAC for DMABRG mode (write 0x94808080 to the
+ DMARSRA register somewhere at boot).
+
+ PFC registers PCCR and PCDR must be set to peripheral mode.
+ (write zeros to both).
+
+The driver does NOT do the above for you since board setup is, well, job
+of the board setup code.
+
+2. Panel definitions
+--------------------
+The LCDC must explicitly be told about the type of LCD panel
+attached.  Data must be wrapped in a "struct sh7760fb_platdata" and
+passed to the driver as platform_data.
+
+Suggest you take a closer look at the SH7760 Manual, Section 30.
+(http://documentation.renesas.com/eng/products/mpumcu/e602291_sh7760.pdf)
+
+The following code illustrates what needs to be done to
+get the framebuffer working on a 640x480 TFT:
+
+====================== cut here ======================================
+
+#include <linux/fb.h>
+#include <asm/sh7760fb.h>
+
+/*
+ * NEC NL6440bc26-01 640x480 TFT
+ * dotclock 25175 kHz
+ * Xres                640     Yres            480
+ * Htotal      800     Vtotal          525
+ * HsynStart   656     VsynStart       490
+ * HsynLenn    30      VsynLenn        2
+ *
+ * The linux framebuffer layer does not use the syncstart/synclen
+ * values but right/left/upper/lower margin values. The comments
+ * for the x_margin explain how to calculate those from given
+ * panel sync timings.
+ */
+static struct fb_videomode nl6448bc26 = {
+       .name           = "NL6448BC26",
+       .refresh        = 60,
+       .xres           = 640,
+       .yres           = 480,
+       .pixclock       = 39683,        /* in picoseconds! */
+       .hsync_len      = 30,
+       .vsync_len      = 2,
+       .left_margin    = 114,  /* HTOT - (HSYNSLEN + HSYNSTART) */
+       .right_margin   = 16,   /* HSYNSTART - XRES */
+       .upper_margin   = 33,   /* VTOT - (VSYNLEN + VSYNSTART) */
+       .lower_margin   = 10,   /* VSYNSTART - YRES */
+       .sync           = FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
+       .vmode          = FB_VMODE_NONINTERLACED,
+       .flag           = 0,
+};
+
+static struct sh7760fb_platdata sh7760fb_nl6448 = {
+       .def_mode       = &nl6448bc26,
+       .ldmtr          = LDMTR_TFT_COLOR_16,   /* 16bit TFT panel */
+       .lddfr          = LDDFR_8BPP,           /* we want 8bit output */
+       .ldpmmr         = 0x0070,
+       .ldpspr         = 0x0500,
+       .ldaclnr        = 0,
+       .ldickr         = LDICKR_CLKSRC(LCDC_CLKSRC_EXTERNAL) |
+                         LDICKR_CLKDIV(1),
+       .rotate         = 0,
+       .novsync        = 1,
+       .blank          = NULL,
+};
+
+/* SH7760:
+ * 0xFE300800: 256 * 4byte xRGB palette ram
+ * 0xFE300C00: 42 bytes ctrl registers
+ */
+static struct resource sh7760_lcdc_res[] = {
+       [0] = {
+               .start  = 0xFE300800,
+               .end    = 0xFE300CFF,
+               .flags  = IORESOURCE_MEM,
+       },
+       [1] = {
+               .start  = 65,
+               .end    = 65,
+               .flags  = IORESOURCE_IRQ,
+       },
+};
+
+static struct platform_device sh7760_lcdc_dev = {
+       .dev    = {
+               .platform_data = &sh7760fb_nl6448,
+       },
+       .name           = "sh7760-lcdc",
+       .id             = -1,
+       .resource       = sh7760_lcdc_res,
+       .num_resources  = ARRAY_SIZE(sh7760_lcdc_res),
+};
+
+====================== cut here ======================================
diff -puN drivers/video/Kconfig~video-sh7760fb-sh7760-sh7763-lcdc-framebuffer-driver drivers/video/Kconfig
--- a/drivers/video/Kconfig~video-sh7760fb-sh7760-sh7763-lcdc-framebuffer-driver
+++ a/drivers/video/Kconfig
@@ -1991,6 +1991,19 @@ config FB_COBALT
 	tristate "Cobalt server LCD frame buffer support"
 	depends on FB && MIPS_COBALT
 
+config FB_SH7760
+       bool "SH7760/SH7763 LCDC support"
+       depends on FB && (CPU_SUBTYPE_SH7760 || CPU_SUBTYPE_SH7763)
+       select FB_CFB_FILLRECT
+       select FB_CFB_COPYAREA
+       select FB_CFB_IMAGEBLIT
+       help
+         Support for the SH7760/SH7763 integrated (D)STN/TFT LCD Controller.
+         Supports display resolutions up to 1024x1024 pixel, grayscale and
+         color operation, with depths ranging from 1 bpp to 8 bpp monochrome
+         and 8, 15 or 16 bpp color; 90 degrees clockwise display rotation for
+         panels <= 320 pixel horizontal resolution.
+
 config FB_VIRTUAL
 	tristate "Virtual Frame Buffer support (ONLY FOR TESTING!)"
 	depends on FB
diff -puN drivers/video/Makefile~video-sh7760fb-sh7760-sh7763-lcdc-framebuffer-driver drivers/video/Makefile
--- a/drivers/video/Makefile~video-sh7760fb-sh7760-sh7763-lcdc-framebuffer-driver
+++ a/drivers/video/Makefile
@@ -106,6 +106,7 @@ obj-$(CONFIG_FB_PMAGB_B)	  += pmagb-b-fb
 obj-$(CONFIG_FB_MAXINE)		  += maxinefb.o
 obj-$(CONFIG_FB_METRONOME)        += metronomefb.o
 obj-$(CONFIG_FB_S1D13XXX)	  += s1d13xxxfb.o
+obj-$(CONFIG_FB_SH7760)		  += sh7760fb.o
 obj-$(CONFIG_FB_IMX)              += imxfb.o
 obj-$(CONFIG_FB_S3C2410)	  += s3c2410fb.o
 obj-$(CONFIG_FB_FSL_DIU)	  += fsl-diu-fb.o
diff -puN /dev/null drivers/video/sh7760fb.c
--- /dev/null
+++ a/drivers/video/sh7760fb.c
@@ -0,0 +1,658 @@
+/*
+ * SH7760/SH7763 LCDC Framebuffer driver.
+ *
+ * (c) 2006-2008 MSC Vertriebsges.m.b.H.,
+ *             Manuel Lauss <mano@roarinelk.homelinux.net>
+ * (c) 2008 Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
+ *
+ *  This file is subject to the terms and conditions of the GNU General
+ *  Public License.  See the file COPYING in the main directory of this
+ *  archive for more details.
+ *
+ * PLEASE HAVE A LOOK AT Documentation/fb/sh7760fb.txt!
+ *
+ * Thanks to Siegfried Schaefer <s.schaefer at schaefer-edv.de>
+ *     for his original source and testing!
+ */
+
+#include <linux/completion.h>
+#include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include <linux/fb.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+
+#include <asm/sh7760fb.h>
+
+struct sh7760fb_par {
+	void __iomem *base;
+	int irq;
+
+	struct sh7760fb_platdata *pd;	/* display information */
+
+	dma_addr_t fbdma;	/* physical address */
+
+	int rot;		/* rotation enabled? */
+
+	u32 pseudo_palette[16];
+
+	struct platform_device *dev;
+	struct resource *ioarea;
+	struct completion vsync;	/* vsync irq event */
+};
+
+static irqreturn_t sh7760fb_irq(int irq, void *data)
+{
+	struct completion *c = data;
+
+	complete(c);
+
+	return IRQ_HANDLED;
+}
+
+static void sh7760fb_wait_vsync(struct fb_info *info)
+{
+	struct sh7760fb_par *par = info->par;
+
+	if (par->pd->novsync)
+		return;
+
+	iowrite16(ioread16(par->base + LDINTR) & ~VINT_CHECK,
+		  par->base + LDINTR);
+
+	if (par->irq < 0) {
+		/* poll for vert. retrace: status bit is sticky */
+		while (!(ioread16(par->base + LDINTR) & VINT_CHECK))
+			cpu_relax();
+	} else {
+		/* a "wait_for_irq_event(par->irq)" would be extremely nice */
+		init_completion(&par->vsync);
+		enable_irq(par->irq);
+		wait_for_completion(&par->vsync);
+		disable_irq_nosync(par->irq);
+	}
+}
+
+/* wait_for_lps - wait until power supply has reached a certain state. */
+static int wait_for_lps(struct sh7760fb_par *par, int val)
+{
+	int i = 100;
+	while (--i && ((ioread16(par->base + LDPMMR) & 3) != val))
+		msleep(1);
+
+	if (i <= 0)
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
+/* en/disable the LCDC */
+static int sh7760fb_blank(int blank, struct fb_info *info)
+{
+	struct sh7760fb_par *par = info->par;
+	struct sh7760fb_platdata *pd = par->pd;
+	unsigned short cntr = ioread16(par->base + LDCNTR);
+	unsigned short intr = ioread16(par->base + LDINTR);
+	int lps;
+
+	if (blank == FB_BLANK_UNBLANK) {
+		intr |= VINT_START;
+		cntr = LDCNTR_DON2 | LDCNTR_DON;
+		lps = 3;
+	} else {
+		intr &= ~VINT_START;
+		cntr = LDCNTR_DON2;
+		lps = 0;
+	}
+
+	if (pd->blank)
+		pd->blank(blank);
+
+	iowrite16(intr, par->base + LDINTR);
+	iowrite16(cntr, par->base + LDCNTR);
+
+	return wait_for_lps(par, lps);
+}
+
+/* set color registers */
+static int sh7760fb_setcmap(struct fb_cmap *cmap, struct fb_info *info)
+{
+	struct sh7760fb_par *par = info->par;
+	u32 s = cmap->start;
+	u32 l = cmap->len;
+	u16 *r = cmap->red;
+	u16 *g = cmap->green;
+	u16 *b = cmap->blue;
+	u32 col, tmo;
+	int ret;
+
+	ret = 0;
+
+	sh7760fb_wait_vsync(info);
+
+	/* request palette access */
+	iowrite16(LDPALCR_PALEN, par->base + LDPALCR);
+
+	/* poll for access grant */
+	tmo = 100;
+	while (!(ioread16(par->base + LDPALCR) & LDPALCR_PALS) && (--tmo))
+		cpu_relax();
+
+	if (!tmo) {
+		ret = 1;
+		dev_dbg(info->dev, "no palette access!\n");
+		goto out;
+	}
+
+	while (l && (s < 256)) {
+		col = ((*r) & 0xff) << 16;
+		col |= ((*g) & 0xff) << 8;
+		col |= ((*b) & 0xff);
+		col &= SH7760FB_PALETTE_MASK;
+
+		if (s < 16)
+			((u32 *) (info->pseudo_palette))[s] = s;
+
+		s++;
+		l--;
+		r++;
+		g++;
+		b++;
+	}
+out:
+	iowrite16(0, par->base + LDPALCR);
+	return ret;
+}
+
+static void encode_fix(struct fb_fix_screeninfo *fix, struct fb_info *info,
+		       unsigned long stride)
+{
+	memset(fix, 0, sizeof(struct fb_fix_screeninfo));
+	strcpy(fix->id, "sh7760-lcdc");
+
+	fix->smem_start = (unsigned long)info->screen_base;
+	fix->smem_len = info->screen_size;
+
+	fix->line_length = stride;
+}
+
+static int sh7760fb_get_color_info(struct device *dev,
+				   u16 lddfr, int *bpp, int *gray)
+{
+	int lbpp, lgray;
+
+	lgray = lbpp = 0;
+
+	switch (lddfr & LDDFR_COLOR_MASK) {
+	case LDDFR_1BPP_MONO:
+		lgray = 1;
+		lbpp = 1;
+		break;
+	case LDDFR_2BPP_MONO:
+		lgray = 1;
+		lbpp = 2;
+		break;
+	case LDDFR_4BPP_MONO:
+		lgray = 1;
+	case LDDFR_4BPP:
+		lbpp = 4;
+		break;
+	case LDDFR_6BPP_MONO:
+		lgray = 1;
+	case LDDFR_8BPP:
+		lbpp = 8;
+		break;
+	case LDDFR_16BPP_RGB555:
+	case LDDFR_16BPP_RGB565:
+		lbpp = 16;
+		lgray = 0;
+		break;
+	default:
+		dev_dbg(dev, "unsupported LDDFR bit depth.\n");
+		return -EINVAL;
+	}
+
+	if (bpp)
+		*bpp = lbpp;
+	if (gray)
+		*gray = lgray;
+
+	return 0;
+}
+
+static int sh7760fb_check_var(struct fb_var_screeninfo *var,
+			      struct fb_info *info)
+{
+	struct fb_fix_screeninfo *fix = &info->fix;
+	struct sh7760fb_par *par = info->par;
+	int ret, bpp;
+
+	/* get color info from register value */
+	ret = sh7760fb_get_color_info(info->dev, par->pd->lddfr, &bpp, NULL);
+	if (ret)
+		return ret;
+
+	var->bits_per_pixel = bpp;
+
+	if ((var->grayscale) && (var->bits_per_pixel == 1))
+		fix->visual = FB_VISUAL_MONO10;
+	else if (var->bits_per_pixel >= 15)
+		fix->visual = FB_VISUAL_TRUECOLOR;
+	else
+		fix->visual = FB_VISUAL_PSEUDOCOLOR;
+
+	/* TODO: add some more validation here */
+	return 0;
+}
+
+/*
+ * sh7760fb_set_par - set videomode.
+ *
+ * NOTE: The rotation, grayscale and DSTN codepaths are
+ *     totally untested!
+ */
+static int sh7760fb_set_par(struct fb_info *info)
+{
+	struct sh7760fb_par *par = info->par;
+	struct fb_videomode *vm = par->pd->def_mode;
+	unsigned long sbase, dstn_off, ldsarl, stride;
+	unsigned short hsynp, hsynw, htcn, hdcn;
+	unsigned short vsynp, vsynw, vtln, vdln;
+	unsigned short lddfr, ldmtr;
+	int ret, bpp, gray;
+
+	par->rot = par->pd->rotate;
+
+	/* rotate only works with xres <= 320 */
+	if (par->rot && (vm->xres > 320)) {
+		dev_dbg(info->dev, "rotation disabled due to display size\n");
+		par->rot = 0;
+	}
+
+	/* calculate LCDC reg vals from display parameters */
+	hsynp = vm->right_margin + vm->xres;
+	hsynw = vm->hsync_len;
+	htcn = vm->left_margin + hsynp + hsynw;
+	hdcn = vm->xres;
+	vsynp = vm->lower_margin + vm->yres;
+	vsynw = vm->vsync_len;
+	vtln = vm->upper_margin + vsynp + vsynw;
+	vdln = vm->yres;
+
+	/* get color info from register value */
+	ret = sh7760fb_get_color_info(info->dev, par->pd->lddfr, &bpp, &gray);
+	if (ret)
+		return ret;
+
+	dev_dbg(info->dev, "%dx%d %dbpp %s (orientation %s)\n", hdcn,
+		vdln, bpp, gray ? "grayscale" : "color",
+		par->rot ? "rotated" : "normal");
+
+#ifdef CONFIG_CPU_LITTLE_ENDIAN
+	lddfr = par->pd->lddfr | (1 << 8);
+#else
+	lddfr = par->pd->lddfr & ~(1 << 8);
+#endif
+
+	ldmtr = par->pd->ldmtr;
+
+	if (!(vm->sync & FB_SYNC_HOR_HIGH_ACT))
+		ldmtr |= LDMTR_CL1POL;
+	if (!(vm->sync & FB_SYNC_VERT_HIGH_ACT))
+		ldmtr |= LDMTR_FLMPOL;
+
+	/* shut down LCDC before changing display parameters */
+	sh7760fb_blank(FB_BLANK_POWERDOWN, info);
+
+	iowrite16(par->pd->ldickr, par->base + LDICKR);	/* pixclock */
+	iowrite16(ldmtr, par->base + LDMTR);	/* polarities */
+	iowrite16(lddfr, par->base + LDDFR);	/* color/depth */
+	iowrite16((par->rot ? 1 << 13 : 0), par->base + LDSMR);	/* rotate */
+	iowrite16(par->pd->ldpmmr, par->base + LDPMMR);	/* Power Management */
+	iowrite16(par->pd->ldpspr, par->base + LDPSPR);	/* Power Supply Ctrl */
+
+	/* display resolution */
+	iowrite16(((htcn >> 3) - 1) | (((hdcn >> 3) - 1) << 8),
+		  par->base + LDHCNR);
+	iowrite16(vdln - 1, par->base + LDVDLNR);
+	iowrite16(vtln - 1, par->base + LDVTLNR);
+	/* h/v sync signals */
+	iowrite16((vsynp - 1) | ((vsynw - 1) << 12), par->base + LDVSYNR);
+	iowrite16(((hsynp >> 3) - 1) | (((hsynw >> 3) - 1) << 12),
+		  par->base + LDHSYNR);
+	/* AC modulation sig */
+	iowrite16(par->pd->ldaclnr, par->base + LDACLNR);
+
+	stride = (par->rot) ? vtln : hdcn;
+	if (!gray)
+		stride *= (bpp + 7) >> 3;
+	else {
+		if (bpp == 1)
+			stride >>= 3;
+		else if (bpp == 2)
+			stride >>= 2;
+		else if (bpp == 4)
+			stride >>= 1;
+		/* 6 bpp == 8 bpp */
+	}
+
+	/* if rotated, stride must be power of 2 */
+	if (par->rot) {
+		unsigned long bit = 1 << 31;
+		while (bit) {
+			if (stride & bit)
+				break;
+			bit >>= 1;
+		}
+		if (stride & ~bit)
+			stride = bit << 1;	/* not P-o-2, round up */
+	}
+	iowrite16(stride, par->base + LDLAOR);
+
+	/* set display mem start address */
+	sbase = (unsigned long)par->fbdma;
+	if (par->rot)
+		sbase += (hdcn - 1) * stride;
+
+	iowrite32(sbase, par->base + LDSARU);
+
+	/*
+	 * for DSTN need to set address for lower half.
+	 * I (mlau) don't know which address to set it to,
+	 * so I guessed at (stride * yres/2).
+	 */
+	if (((ldmtr & 0x003f) >= LDMTR_DSTN_MONO_8) &&
+	    ((ldmtr & 0x003f) <= LDMTR_DSTN_COLOR_16)) {
+
+		dev_dbg(info->dev, " ***** DSTN untested! *****\n");
+
+		dstn_off = stride;
+		if (par->rot)
+			dstn_off *= hdcn >> 1;
+		else
+			dstn_off *= vdln >> 1;
+
+		ldsarl = sbase + dstn_off;
+	} else
+		ldsarl = 0;
+
+	iowrite32(ldsarl, par->base + LDSARL);	/* mem for lower half of DSTN */
+
+	encode_fix(&info->fix, info, stride);
+	sh7760fb_check_var(&info->var, info);
+
+	sh7760fb_blank(FB_BLANK_UNBLANK, info);	/* panel on! */
+
+	dev_dbg(info->dev, "hdcn  : %6d htcn  : %6d\n", hdcn, htcn);
+	dev_dbg(info->dev, "hsynw : %6d hsynp : %6d\n", hsynw, hsynp);
+	dev_dbg(info->dev, "vdln  : %6d vtln  : %6d\n", vdln, vtln);
+	dev_dbg(info->dev, "vsynw : %6d vsynp : %6d\n", vsynw, vsynp);
+	dev_dbg(info->dev, "clksrc: %6d clkdiv: %6d\n",
+		(par->pd->ldickr >> 12) & 3, par->pd->ldickr & 0x1f);
+	dev_dbg(info->dev, "ldpmmr: 0x%04x ldpspr: 0x%04x\n", par->pd->ldpmmr,
+		par->pd->ldpspr);
+	dev_dbg(info->dev, "ldmtr : 0x%04x lddfr : 0x%04x\n", ldmtr, lddfr);
+	dev_dbg(info->dev, "ldlaor: %ld\n", stride);
+	dev_dbg(info->dev, "ldsaru: 0x%08lx ldsarl: 0x%08lx\n", sbase, ldsarl);
+
+	return 0;
+}
+
+static struct fb_ops sh7760fb_ops = {
+	.owner = THIS_MODULE,
+	.fb_blank = sh7760fb_blank,
+	.fb_check_var = sh7760fb_check_var,
+	.fb_setcmap = sh7760fb_setcmap,
+	.fb_set_par = sh7760fb_set_par,
+	.fb_fillrect = cfb_fillrect,
+	.fb_copyarea = cfb_copyarea,
+	.fb_imageblit = cfb_imageblit,
+};
+
+static void sh7760fb_free_mem(struct fb_info *info)
+{
+	struct sh7760fb_par *par = info->par;
+
+	if (!info->screen_base)
+		return;
+
+	dma_free_coherent(info->dev, info->screen_size,
+			  info->screen_base, par->fbdma);
+
+	par->fbdma = 0;
+	info->screen_base = NULL;
+	info->screen_size = 0;
+}
+
+/* allocate the framebuffer memory. This memory must be in Area3,
+ * (dictated by the DMA engine) and contiguous, at a 512 byte boundary.
+ */
+static int sh7760fb_alloc_mem(struct fb_info *info)
+{
+	struct sh7760fb_par *par = info->par;
+	void *fbmem;
+	unsigned long vram;
+	int ret, bpp;
+
+	if (info->screen_base)
+		return 0;
+
+	/* get color info from register value */
+	ret = sh7760fb_get_color_info(info->dev, par->pd->lddfr, &bpp, NULL);
+	if (ret) {
+		printk(KERN_ERR "colinfo\n");
+		return ret;
+	}
+
+	/* min VRAM: xres_min = 16, yres_min = 1, bpp = 1: 2byte -> 1 page
+	   max VRAM: xres_max = 1024, yres_max = 1024, bpp = 16: 2MB */
+
+	vram = info->var.xres * info->var.yres;
+	if (info->var.grayscale) {
+		if (bpp == 1)
+			vram >>= 3;
+		else if (bpp == 2)
+			vram >>= 2;
+		else if (bpp == 4)
+			vram >>= 1;
+	} else if (bpp > 8)
+		vram *= 2;
+	if ((vram < 1) || (vram > 1024 * 2048)) {
+		dev_dbg(info->dev, "too much VRAM required. Check settings\n");
+		return -ENODEV;
+	}
+
+	if (vram < PAGE_SIZE)
+		vram = PAGE_SIZE;
+
+	fbmem = dma_alloc_coherent(info->dev, vram, &par->fbdma, GFP_KERNEL);
+
+	if (!fbmem)
+		return -ENOMEM;
+
+	if ((par->fbdma & SH7760FB_DMA_MASK) != SH7760FB_DMA_MASK) {
+		sh7760fb_free_mem(info);
+		dev_err(info->dev, "kernel gave me memory at 0x%08lx, which is"
+			"unusable for the LCDC\n", (unsigned long)par->fbdma);
+		return -ENOMEM;
+	}
+
+	info->screen_base = fbmem;
+	info->screen_size = vram;
+
+	return 0;
+}
+
+static int __devinit sh7760fb_probe(struct platform_device *pdev)
+{
+	struct fb_info *info;
+	struct resource *res;
+	struct sh7760fb_par *par;
+	int ret;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (unlikely(res == NULL)) {
+		dev_err(&pdev->dev, "invalid resource\n");
+		return -EINVAL;
+	}
+
+	info = framebuffer_alloc(sizeof(struct sh7760fb_par), &pdev->dev);
+	if (!info)
+		return -ENOMEM;
+
+	par = info->par;
+	par->dev = pdev;
+
+	par->pd = pdev->dev.platform_data;
+	if (!par->pd) {
+		dev_dbg(info->dev, "no display setup data!\n");
+		ret = -ENODEV;
+		goto out_fb;
+	}
+
+	par->ioarea = request_mem_region(res->start,
+					 (res->end - res->start), pdev->name);
+	if (!par->ioarea) {
+		dev_err(&pdev->dev, "mmio area busy\n");
+		ret = -EBUSY;
+		goto out_fb;
+	}
+
+	par->base = ioremap_nocache(res->start, res->end - res->start + 1);
+	if (!par->base) {
+		dev_err(&pdev->dev, "cannot remap\n");
+		ret = -ENODEV;
+		goto out_res;
+	}
+
+	iowrite16(0, par->base + LDINTR);	/* disable vsync irq */
+	par->irq = platform_get_irq(pdev, 0);
+	if (par->irq >= 0) {
+		ret = request_irq(par->irq, sh7760fb_irq, 0,
+				  "sh7760-lcdc", &par->vsync);
+		if (ret) {
+			dev_err(&pdev->dev, "cannot grab IRQ\n");
+			par->irq = -ENXIO;
+		} else
+			disable_irq_nosync(par->irq);
+	}
+
+	fb_videomode_to_var(&info->var, par->pd->def_mode);
+
+	ret = sh7760fb_alloc_mem(info);
+	if (ret) {
+		dev_dbg(info->dev, "framebuffer memory allocation failed!\n");
+		goto out_unmap;
+	}
+
+	info->pseudo_palette = par->pseudo_palette;
+
+	/* fixup color register bitpositions. These are fixed by hardware */
+	info->var.red.offset = 11;
+	info->var.red.length = 5;
+	info->var.red.msb_right = 0;
+
+	info->var.green.offset = 5;
+	info->var.green.length = 6;
+	info->var.green.msb_right = 0;
+
+	info->var.blue.offset = 0;
+	info->var.blue.length = 5;
+	info->var.blue.msb_right = 0;
+
+	info->var.transp.offset = 0;
+	info->var.transp.length = 0;
+	info->var.transp.msb_right = 0;
+
+	/* set the DON2 bit now, before cmap allocation, as it will randomize
+	 * palette memory.
+	 */
+	iowrite16(LDCNTR_DON2, par->base + LDCNTR);
+	info->fbops = &sh7760fb_ops;
+
+	ret = fb_alloc_cmap(&info->cmap, 256, 0);
+	if (ret) {
+		dev_dbg(info->dev, "Unable to allocate cmap memory\n");
+		goto out_mem;
+	}
+
+	ret = register_framebuffer(info);
+	if (ret < 0) {
+		dev_dbg(info->dev, "cannot register fb!\n");
+		goto out_cmap;
+	}
+	platform_set_drvdata(pdev, info);
+
+	printk(KERN_INFO "%s: memory at phys 0x%08lx-0x%08lx, size %ld KiB\n",
+	       pdev->name,
+	       (unsigned long)par->fbdma,
+	       (unsigned long)(par->fbdma + info->screen_size - 1),
+	       info->screen_size >> 10);
+
+	return 0;
+
+out_cmap:
+	sh7760fb_blank(FB_BLANK_POWERDOWN, info);
+	fb_dealloc_cmap(&info->cmap);
+out_mem:
+	sh7760fb_free_mem(info);
+out_unmap:
+	if (par->irq >= 0)
+		free_irq(par->irq, &par->vsync);
+	iounmap(par->base);
+out_res:
+	release_resource(par->ioarea);
+	kfree(par->ioarea);
+out_fb:
+	framebuffer_release(info);
+	return ret;
+}
+
+static int __devexit sh7760fb_remove(struct platform_device *dev)
+{
+	struct fb_info *info = platform_get_drvdata(dev);
+	struct sh7760fb_par *par = info->par;
+
+	sh7760fb_blank(FB_BLANK_POWERDOWN, info);
+	unregister_framebuffer(info);
+	fb_dealloc_cmap(&info->cmap);
+	sh7760fb_free_mem(info);
+	if (par->irq >= 0)
+		free_irq(par->irq, par);
+	iounmap(par->base);
+	release_resource(par->ioarea);
+	kfree(par->ioarea);
+	framebuffer_release(info);
+	platform_set_drvdata(dev, NULL);
+
+	return 0;
+}
+
+static struct platform_driver sh7760_lcdc_driver = {
+	.driver = {
+		   .name = "sh7760-lcdc",
+		   .owner = THIS_MODULE,
+		   },
+	.probe = sh7760fb_probe,
+	.remove = __devexit_p(sh7760fb_remove),
+};
+
+static int __init sh7760fb_init(void)
+{
+	return platform_driver_register(&sh7760_lcdc_driver);
+}
+
+static void __exit sh7760fb_exit(void)
+{
+	platform_driver_unregister(&sh7760_lcdc_driver);
+}
+
+module_init(sh7760fb_init);
+module_exit(sh7760fb_exit);
+
+MODULE_AUTHOR("Nobuhiro Iwamatsu, Manuel Lauss");
+MODULE_DESCRIPTION("FBdev for SH7760/63 integrated LCD Controller");
+MODULE_LICENSE("GPL");
diff -puN /dev/null include/asm-sh/sh7760fb.h
--- /dev/null
+++ a/include/asm-sh/sh7760fb.h
@@ -0,0 +1,197 @@
+/*
+ * sh7760fb.h -- platform data for SH7760/SH7763 LCDC framebuffer driver.
+ *
+ * (c) 2006-2008 MSC Vertriebsges.m.b.H.,
+ * 			Manuel Lauss <mano@roarinelk.homelinux.net>
+ * (c) 2008 Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
+ */
+
+#ifndef _ASM_SH_SH7760FB_H
+#define _ASM_SH_SH7760FB_H
+
+/*
+ * some bits of the colormap registers should be written as zero.
+ * create a mask for that.
+ */
+#define SH7760FB_PALETTE_MASK 0x00f8fcf8
+
+/* The LCDC dma engine always sets bits 27-26 to 1: this is Area3 */
+#define SH7760FB_DMA_MASK 0x0C000000
+
+/* palette */
+#define LDPR(x) (((x) << 2))
+
+/* framebuffer registers and bits */
+#define LDICKR 0x400
+#define LDMTR 0x402
+/* see sh7760fb.h for LDMTR bits */
+#define LDDFR 0x404
+#define LDDFR_PABD (1 << 8)
+#define LDDFR_COLOR_MASK 0x7F
+#define LDSMR 0x406
+#define LDSMR_ROT (1 << 13)
+#define LDSARU 0x408
+#define LDSARL 0x40c
+#define LDLAOR 0x410
+#define LDPALCR 0x412
+#define LDPALCR_PALS (1 << 4)
+#define LDPALCR_PALEN (1 << 0)
+#define LDHCNR 0x414
+#define LDHSYNR 0x416
+#define LDVDLNR 0x418
+#define LDVTLNR 0x41a
+#define LDVSYNR 0x41c
+#define LDACLNR 0x41e
+#define LDINTR 0x420
+#define LDPMMR 0x424
+#define LDPSPR 0x426
+#define LDCNTR 0x428
+#define LDCNTR_DON (1 << 0)
+#define LDCNTR_DON2 (1 << 4)
+
+#ifdef CONFIG_CPU_SUBTYPE_SH7763
+# define LDLIRNR       0x440
+/* LDINTR bit */
+# define LDINTR_MINTEN (1 << 15)
+# define LDINTR_FINTEN (1 << 14)
+# define LDINTR_VSINTEN (1 << 13)
+# define LDINTR_VEINTEN (1 << 12)
+# define LDINTR_MINTS (1 << 11)
+# define LDINTR_FINTS (1 << 10)
+# define LDINTR_VSINTS (1 << 9)
+# define LDINTR_VEINTS (1 << 8)
+# define VINT_START (LDINTR_VSINTEN)
+# define VINT_CHECK (LDINTR_VSINTS)
+#else
+/* LDINTR bit */
+# define LDINTR_VINTSEL (1 << 12)
+# define LDINTR_VINTE (1 << 8)
+# define LDINTR_VINTS (1 << 0)
+# define VINT_START (LDINTR_VINTSEL)
+# define VINT_CHECK (LDINTR_VINTS)
+#endif
+
+/* HSYNC polarity inversion */
+#define LDMTR_FLMPOL (1 << 15)
+
+/* VSYNC polarity inversion */
+#define LDMTR_CL1POL (1 << 14)
+
+/* DISPLAY-ENABLE polarity inversion */
+#define LDMTR_DISPEN_LOWACT (1 << 13)
+
+/* DISPLAY DATA BUS polarity inversion */
+#define LDMTR_DPOL_LOWACT (1 << 12)
+
+/* AC modulation signal enable */
+#define LDMTR_MCNT (1 << 10)
+
+/* Disable output of HSYNC during VSYNC period */
+#define LDMTR_CL1CNT (1 << 9)
+
+/* Disable output of VSYNC during VSYNC period */
+#define LDMTR_CL2CNT (1 << 8)
+
+/* Display types supported by the LCDC */
+#define LDMTR_STN_MONO_4       0x00
+#define LDMTR_STN_MONO_8       0x01
+#define LDMTR_STN_COLOR_4      0x08
+#define LDMTR_STN_COLOR_8      0x09
+#define LDMTR_STN_COLOR_12     0x0A
+#define LDMTR_STN_COLOR_16     0x0B
+#define LDMTR_DSTN_MONO_8      0x11
+#define LDMTR_DSTN_MONO_16     0x13
+#define LDMTR_DSTN_COLOR_8     0x19
+#define LDMTR_DSTN_COLOR_12    0x1A
+#define LDMTR_DSTN_COLOR_16    0x1B
+#define LDMTR_TFT_COLOR_16     0x2B
+
+/* framebuffer color layout */
+#define LDDFR_1BPP_MONO 0x00
+#define LDDFR_2BPP_MONO 0x01
+#define LDDFR_4BPP_MONO 0x02
+#define LDDFR_6BPP_MONO 0x04
+#define LDDFR_4BPP 0x0A
+#define LDDFR_8BPP 0x0C
+#define LDDFR_16BPP_RGB555 0x1D
+#define LDDFR_16BPP_RGB565 0x2D
+
+/* LCDC Pixclock sources */
+#define LCDC_CLKSRC_BUSCLOCK 0
+#define LCDC_CLKSRC_PERIPHERAL 1
+#define LCDC_CLKSRC_EXTERNAL 2
+
+#define LDICKR_CLKSRC(x) \
+       (((x) & 3) << 12)
+
+/* LCDC pixclock input divider. Set to 1 at a minimum! */
+#define LDICKR_CLKDIV(x) \
+       ((x) & 0x1f)
+
+struct sh7760fb_platdata {
+
+	/* Set this member to a valid fb_videmode for the display you
+	 * wish to use.  The following members must be initialized:
+	 * xres, yres, hsync_len, vsync_len, sync,
+	 * {left,right,upper,lower}_margin.
+	 * The driver uses the above members to calculate register values
+	 * and memory requirements. Other members are ignored but may
+	 * be used by other framebuffer layer components.
+	 */
+	struct fb_videomode *def_mode;
+
+	/* LDMTR includes display type and signal polarity.  The
+	 * HSYNC/VSYNC polarities are derived from the fb_var_screeninfo
+	 * data above; however the polarities of the following signals
+	 * must be encoded in the ldmtr member:
+	 * Display Enable signal (default high-active)  DISPEN_LOWACT
+	 * Display Data signals (default high-active)   DPOL_LOWACT
+	 * AC Modulation signal (default off)           MCNT
+	 * Hsync-During-Vsync suppression (default off) CL1CNT
+	 * Vsync-during-vsync suppression (default off) CL2CNT
+	 * NOTE: also set a display type!
+	 * (one of LDMTR_{STN,DSTN,TFT}_{MONO,COLOR}_{4,8,12,16})
+	 */
+	u16 ldmtr;
+
+	/* LDDFR controls framebuffer image format (depth, organization)
+	 * Use ONE of the LDDFR_?BPP_* macros!
+	 */
+	u16 lddfr;
+
+	/* LDPMMR and LDPSPR control the timing of the power signals
+	 * for the display. Please read the SH7760 Hardware Manual,
+	 * Chapters 30.3.17, 30.3.18 and 30.4.6!
+	 */
+	u16 ldpmmr;
+	u16 ldpspr;
+
+	/* LDACLNR contains the line numbers after which the AC modulation
+	 * signal is to toggle. Set to ZERO for TFTs or displays which
+	 * do not need it. (Chapter 30.3.15 in SH7760 Hardware Manual).
+	 */
+	u16 ldaclnr;
+
+	/* LDICKR contains information on pixelclock source and config.
+	 * Please use the LDICKR_CLKSRC() and LDICKR_CLKDIV() macros.
+	 * minimal value for CLKDIV() must be 1!.
+	 */
+	u16 ldickr;
+
+	/* set this member to 1 if you wish to use the LCDC's hardware
+	 * rotation function.  This is limited to displays <= 320x200
+	 * pixels resolution!
+	 */
+	int rotate;		/* set to 1 to rotate 90 CCW */
+
+	/* set this to 1 to suppress vsync irq use. */
+	int novsync;
+
+	/* blanking hook for platform. Set this if your platform can do
+	 * more than the LCDC in terms of blanking (e.g. disable clock
+	 * generator / backlight power supply / etc.
+	 */
+	void (*blank) (int);
+};
+
+#endif /* _ASM_SH_SH7760FB_H */
_

Patches currently in -mm which might be from iwamatsu.nobuhiro@renesas.com are

origin.patch
linux-next.patch

