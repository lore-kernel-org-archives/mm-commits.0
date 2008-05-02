From: akpm@linux-foundation.org
Subject: + add-the-carmine-fb-driver.patch added to -mm tree
Date: Fri, 02 May 2008 16:21:24 -0700
Message-ID: <200805022321.m42NLOCo020329@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46625 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937525AbYEBXVg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 19:21:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bigeasy@linutronix.de, adaplas@pol.net


The patch titled
     fbdev: add the carmine FB driver
has been added to the -mm tree.  Its filename is
     add-the-carmine-fb-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: add the carmine FB driver
From: Sebastian Siewior <bigeasy@linutronix.de>

Basic FB driver for the carmine chip.  The driver registers two FB devices for
the two possible screens.  The DRAM settings can be be switched via Kconfig
(between eval board and custom).

Signed-off-by: Sebastian Siewior <bigeasy@linutronix.de>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig          |   26 +
 drivers/video/Makefile         |    1 
 drivers/video/carminefb.c      |  801 +++++++++++++++++++++++++++++++
 drivers/video/carminefb.h      |   64 ++
 drivers/video/carminefb_regs.h |  159 ++++++
 5 files changed, 1051 insertions(+)

diff -puN drivers/video/Kconfig~add-the-carmine-fb-driver drivers/video/Kconfig
--- a/drivers/video/Kconfig~add-the-carmine-fb-driver
+++ a/drivers/video/Kconfig
@@ -1659,6 +1659,32 @@ config FB_PM3
 	  similar boards, 3DLabs Permedia3 Create!, Appian Jeronimo 2000
 	  and maybe other boards.
 
+config FB_CARMINE
+	tristate "Fujitsu carmine frame buffer support"
+	depends on FB && PCI
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This is the frame buffer device driver for the Fujitsu Carmine chip.
+	  The driver provides two independent frame buffer devices.
+
+choice
+	depends on FB_CARMINE
+	prompt "DRAM timing"
+	default FB_CARMINE_DRAM_EVAL
+
+config FB_CARMINE_DRAM_EVAL
+	bool "Eval board timings"
+	help
+	  Use timings which work on the eval card.
+
+config CARMINE_DRAM_CUSTOM
+	bool "Custom board timings"
+	help
+	  Use custom board timings.
+endchoice
+
 config FB_AU1100
 	bool "Au1100 LCD Driver"
 	depends on (FB = y) && MIPS && SOC_AU1100
diff -puN drivers/video/Makefile~add-the-carmine-fb-driver drivers/video/Makefile
--- a/drivers/video/Makefile~add-the-carmine-fb-driver
+++ a/drivers/video/Makefile
@@ -117,6 +117,7 @@ obj-$(CONFIG_FB_SM501)            += sm5
 obj-$(CONFIG_FB_XILINX)           += xilinxfb.o
 obj-$(CONFIG_FB_OMAP)             += omap/
 obj-$(CONFIG_XEN_FBDEV_FRONTEND)  += xen-fbfront.o
+obj-$(CONFIG_FB_CARMINE)          += carminefb.o
 
 # Platform or fallback drivers go here
 obj-$(CONFIG_FB_UVESA)            += uvesafb.o
diff -puN /dev/null drivers/video/carminefb.c
--- /dev/null
+++ a/drivers/video/carminefb.c
@@ -0,0 +1,801 @@
+/*
+ * Frame buffer driver for the Carmine GPU.
+ *
+ * The driver configures the GPU as follows
+ * - FB0 is display 0 with unique memory area
+ * - FB1 is display 1 with unique memory area
+ * - both display use 32 bit colors
+ */
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/fb.h>
+#include <linux/interrupt.h>
+#include <linux/pci.h>
+
+#include "carminefb.h"
+#include "carminefb_regs.h"
+
+#if !defined(__LITTLE_ENDIAN) && !defined(__BIG_ENDIAN)
+#error  "The endianness of the target host has not been defined."
+#endif
+
+/*
+ * The initial video mode can be supplied via two different ways:
+ * - as a string that is passed to fb_find_mode() (module option fb_mode_str)
+ * - as an integer that picks the video mode from carmine_modedb[] (module
+ *   option fb_mode)
+ *
+ * If nothing is used than the initial video mode will be the
+ * CARMINEFB_DEFAULT_VIDEO_MODE member of the carmine_modedb[].
+ */
+#define CARMINEFB_DEFAULT_VIDEO_MODE	1
+
+static unsigned int fb_mode = CARMINEFB_DEFAULT_VIDEO_MODE;
+module_param(fb_mode, uint, 444);
+MODULE_PARM_DESC(fb_mode, "Initial video mode as integer.");
+
+static char *fb_mode_str;
+module_param(fb_mode_str, charp, 444);
+MODULE_PARM_DESC(fb_mode_str, "Initial video mode in characters.");
+
+/*
+ * Carminefb displays:
+ * 0b000 None
+ * 0b001 Display 0
+ * 0b010 Display 1
+ */
+static int fb_displays = CARMINE_USE_DISPLAY0 | CARMINE_USE_DISPLAY1;
+module_param(fb_displays, int, 444);
+MODULE_PARM_DESC(fb_displays, "Bit mode, which displays are used");
+
+struct carmine_hw {
+	void __iomem *v_regs;
+	void __iomem *screen_mem;
+	struct fb_info *fb[MAX_DISPLAY];
+};
+
+struct carmine_resolution {
+	u32 htp;
+	u32 hsp;
+	u32 hsw;
+	u32 hdp;
+	u32 vtr;
+	u32 vsp;
+	u32 vsw;
+	u32 vdp;
+	u32 disp_mode;
+};
+
+struct carmine_fb {
+	void __iomem *display_reg;
+	void __iomem *screen_base;
+	u32 smem_offset;
+	u32 cur_mode;
+	u32 new_mode;
+	struct carmine_resolution *res;
+	u32 pseudo_palette[16];
+};
+
+static struct fb_fix_screeninfo carminefb_fix __devinitdata = {
+	.id = "Carmine",
+	.type = FB_TYPE_PACKED_PIXELS,
+	.visual = FB_VISUAL_TRUECOLOR,
+	.accel = FB_ACCEL_NONE,
+};
+
+static const struct fb_videomode carmine_modedb[] = {
+	{
+		.name		= "640x480",
+		.xres		= 640,
+		.yres		= 480,
+		.pixclock	= 0,
+		.left_margin	= 0,
+		.right_margin	= 0,
+		.upper_margin	= 0,
+		.lower_margin	= 0,
+		.hsync_len	= 0,
+		.vsync_len	= 0,
+		.sync		= 0,
+		.vmode		= 0,
+		.flag		= 0,
+	}, {
+		.name		= "800x600",
+		.xres		= 800,
+		.yres		= 600,
+		.pixclock	= 0,
+	},
+};
+
+static struct carmine_resolution car_modes[] = {
+	{
+		/* 640x480 */
+		.htp = 800,
+		.hsp = 672,
+		.hsw = 96,
+		.hdp = 640,
+		.vtr = 525,
+		.vsp = 490,
+		.vsw = 2,
+		.vdp = 480,
+		.disp_mode = 0x1400,
+	},
+	{
+		/* 800x600 */
+		.htp = 1060,
+		.hsp = 864,
+		.hsw = 72,
+		.hdp = 800,
+		.vtr = 628,
+		.vsp = 601,
+		.vsw = 2,
+		.vdp = 600,
+		.disp_mode = 0x0d00,
+	}
+};
+
+static int carmine_find_mode(const struct fb_var_screeninfo *var)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(car_modes); i++)
+		if (car_modes[i].hdp == var->xres &&
+		    car_modes[i].vdp == var->yres)
+			return i;
+	return -EINVAL;
+}
+
+static void c_set_disp_reg(const struct carmine_fb *par,
+		u32 offset, u32 val)
+{
+	writel(val, par->display_reg + offset);
+}
+
+static u32 c_get_disp_reg(const struct carmine_fb *par,
+		u32 offset)
+{
+	return readl(par->display_reg + offset);
+}
+
+static void c_set_hw_reg(const struct carmine_hw *hw,
+		u32 offset, u32 val)
+{
+	writel(val, hw->v_regs + offset);
+}
+
+static u32 c_get_hw_reg(const struct carmine_hw *hw,
+		u32 offset)
+{
+	return readl(hw->v_regs + offset);
+}
+
+static int carmine_setcolreg(unsigned regno, unsigned red, unsigned green,
+		unsigned blue, unsigned transp, struct fb_info *info)
+{
+	if (regno >= 16)
+		return 1;
+
+	red >>= 8;
+	green >>= 8;
+	blue >>= 8;
+	transp >>= 8;
+
+	((u32 *)info->pseudo_palette)[regno] = be32_to_cpu(transp << 24 |
+		red << 0 | green << 8 | blue << 16);
+	return 0;
+}
+
+static int carmine_check_var(struct fb_var_screeninfo *var,
+		struct fb_info *info)
+{
+	int ret;
+
+	ret = carmine_find_mode(var);
+	if (ret < 0)
+		return ret;
+
+	if (var->grayscale || var->rotate || var->nonstd)
+		return -EINVAL;
+
+	var->xres_virtual = var->xres;
+	var->yres_virtual = var->yres;
+
+	var->bits_per_pixel = 32;
+
+#ifdef __BIG_ENDIAN
+	var->transp.offset = 24;
+	var->red.offset = 0;
+	var->green.offset = 8;
+	var->blue.offset = 16;
+#else
+	var->transp.offset = 24;
+	var->red.offset = 16;
+	var->green.offset = 8;
+	var->blue.offset = 0;
+#endif
+
+	var->red.length = 8;
+	var->green.length = 8;
+	var->blue.length = 8;
+	var->transp.length = 8;
+
+	var->red.msb_right = 0;
+	var->green.msb_right = 0;
+	var->blue.msb_right = 0;
+	var->transp.msb_right = 0;
+	return 0;
+}
+
+static void carmine_init_display_param(struct carmine_fb *par)
+{
+	u32 width;
+	u32 height;
+	u32 param;
+	u32 window_size;
+	u32 soffset = par->smem_offset;
+
+	c_set_disp_reg(par, CARMINE_DISP_REG_C_TRANS, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_MLMR_TRANS, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_CURSOR_MODE,
+			CARMINE_CURSOR0_PRIORITY_MASK |
+			CARMINE_CURSOR1_PRIORITY_MASK |
+			CARMINE_CURSOR_CUTZ_MASK);
+
+	/* Set default cursor position */
+	c_set_disp_reg(par, CARMINE_DISP_REG_CUR1_POS, 0 << 16 | 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_CUR2_POS, 0 << 16 | 0);
+
+	/* Set default display mode */
+	c_set_disp_reg(par, CARMINE_DISP_REG_L0_EXT_MODE, CARMINE_WINDOW_MODE |
+			CARMINE_EXT_CMODE_DIRECT24_RGBA);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L1_EXT_MODE,
+			CARMINE_EXT_CMODE_DIRECT24_RGBA);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L2_EXT_MODE, CARMINE_EXTEND_MODE |
+			CARMINE_EXT_CMODE_DIRECT24_RGBA);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L3_EXT_MODE, CARMINE_EXTEND_MODE |
+			CARMINE_EXT_CMODE_DIRECT24_RGBA);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L4_EXT_MODE, CARMINE_EXTEND_MODE |
+			CARMINE_EXT_CMODE_DIRECT24_RGBA);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L5_EXT_MODE, CARMINE_EXTEND_MODE |
+			CARMINE_EXT_CMODE_DIRECT24_RGBA);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L6_EXT_MODE, CARMINE_EXTEND_MODE |
+			CARMINE_EXT_CMODE_DIRECT24_RGBA);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L7_EXT_MODE, CARMINE_EXTEND_MODE |
+			CARMINE_EXT_CMODE_DIRECT24_RGBA);
+
+	/* Set default frame size to layer mode register */
+	width = par->res->hdp * 4 / CARMINE_DISP_WIDTH_UNIT;
+	width = width << CARMINE_DISP_WIDTH_SHIFT;
+
+	height = par->res->vdp - 1;
+	param = width | height;
+
+	c_set_disp_reg(par, CARMINE_DISP_REG_L0_MODE_W_H, param);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L1_WIDTH, width);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L2_MODE_W_H, param);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L3_MODE_W_H, param);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L4_MODE_W_H, param);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L5_MODE_W_H, param);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L6_MODE_W_H, param);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L7_MODE_W_H, param);
+
+	/* Set default pos and size */
+	window_size = (par->res->vdp - 1) << CARMINE_DISP_WIN_H_SHIFT;
+	window_size |= par->res->hdp;
+
+	c_set_disp_reg(par, CARMINE_DISP_REG_L0_WIN_POS, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L0_WIN_SIZE, window_size);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L1_WIN_POS, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L1_WIN_SIZE, window_size);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L2_WIN_POS, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L2_WIN_SIZE, window_size);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L3_WIN_POS, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L3_WIN_SIZE, window_size);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L4_WIN_POS, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L4_WIN_SIZE, window_size);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L5_WIN_POS, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L5_WIN_SIZE, window_size);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L6_WIN_POS, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L6_WIN_SIZE, window_size);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L7_WIN_POS, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L7_WIN_SIZE, window_size);
+
+	/* Set default origin address */
+	c_set_disp_reg(par, CARMINE_DISP_REG_L0_ORG_ADR, soffset);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L1_ORG_ADR, soffset);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L2_ORG_ADR1, soffset);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L3_ORG_ADR1, soffset);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L4_ORG_ADR1, soffset);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L5_ORG_ADR1, soffset);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L6_ORG_ADR1, soffset);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L7_ORG_ADR1, soffset);
+
+	/* Set default display address */
+	c_set_disp_reg(par, CARMINE_DISP_REG_L0_DISP_ADR, soffset);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L2_DISP_ADR1, soffset);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L3_DISP_ADR1, soffset);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L4_DISP_ADR1, soffset);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L5_DISP_ADR1, soffset);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L6_DISP_ADR0, soffset);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L7_DISP_ADR0, soffset);
+
+	/* Set default display position */
+	c_set_disp_reg(par, CARMINE_DISP_REG_L0_DISP_POS, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L2_DISP_POS, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L3_DISP_POS, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L4_DISP_POS, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L5_DISP_POS, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L6_DISP_POS, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L7_DISP_POS, 0);
+
+	/* Set default blend mode */
+	c_set_disp_reg(par, CARMINE_DISP_REG_BLEND_MODE_L0, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_BLEND_MODE_L1, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_BLEND_MODE_L2, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_BLEND_MODE_L3, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_BLEND_MODE_L4, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_BLEND_MODE_L5, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_BLEND_MODE_L6, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_BLEND_MODE_L7, 0);
+
+	/* default transparency mode */
+	c_set_disp_reg(par, CARMINE_DISP_REG_L0_TRANS, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L1_TRANS, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L2_TRANS, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L3_TRANS, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L4_TRANS, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L5_TRANS, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L6_TRANS, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L7_TRANS, 0);
+
+	/* Set default read skip parameter */
+	c_set_disp_reg(par, CARMINE_DISP_REG_L0RM, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L2RM, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L3RM, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L4RM, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L5RM, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L6RM, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L7RM, 0);
+
+	c_set_disp_reg(par, CARMINE_DISP_REG_L0PX, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L2PX, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L3PX, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L4PX, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L5PX, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L6PX, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L7PX, 0);
+
+	c_set_disp_reg(par, CARMINE_DISP_REG_L0PY, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L2PY, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L3PY, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L4PY, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L5PY, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L6PY, 0);
+	c_set_disp_reg(par, CARMINE_DISP_REG_L7PY, 0);
+}
+
+static void set_display_parameters(struct carmine_fb *par)
+{
+	u32 mode;
+	u32 hdp, vdp, htp, hsp, hsw, vtr, vsp, vsw;
+
+	/*
+	 * display timing. Parameters are decreased by one because hardware
+	 * spec is 0 to (n - 1)
+	 * */
+	hdp = par->res->hdp - 1;
+	vdp = par->res->vdp - 1;
+	htp = par->res->htp - 1;
+	hsp = par->res->hsp - 1;
+	hsw = par->res->hsw - 1;
+	vtr = par->res->vtr - 1;
+	vsp = par->res->vsp - 1;
+	vsw = par->res->vsw - 1;
+
+	c_set_disp_reg(par, CARMINE_DISP_REG_H_TOTAL,
+			htp << CARMINE_DISP_HTP_SHIFT);
+	c_set_disp_reg(par, CARMINE_DISP_REG_H_PERIOD,
+			(hdp << CARMINE_DISP_HDB_SHIFT)	| hdp);
+	c_set_disp_reg(par, CARMINE_DISP_REG_V_H_W_H_POS,
+			(vsw << CARMINE_DISP_VSW_SHIFT) |
+			(hsw << CARMINE_DISP_HSW_SHIFT) |
+			(hsp));
+	c_set_disp_reg(par, CARMINE_DISP_REG_V_TOTAL,
+			vtr << CARMINE_DISP_VTR_SHIFT);
+	c_set_disp_reg(par, CARMINE_DISP_REG_V_PERIOD_POS,
+			(vdp << CARMINE_DISP_VDP_SHIFT) | vsp);
+
+	/* clock */
+	mode = c_get_disp_reg(par, CARMINE_DISP_REG_DCM1);
+	mode = (mode & ~CARMINE_DISP_DCM_MASK) |
+		(par->res->disp_mode & CARMINE_DISP_DCM_MASK);
+	/* enable video output and layer 0 */
+	mode |= CARMINE_DEN | CARMINE_L0E;
+	c_set_disp_reg(par, CARMINE_DISP_REG_DCM1, mode);
+}
+
+static int carmine_set_par(struct fb_info *info)
+{
+	struct carmine_fb *par = info->par;
+	int ret;
+
+	ret = carmine_find_mode(&info->var);
+	if (ret < 0)
+		return ret;
+
+	par->new_mode = ret;
+	if (par->cur_mode != par->new_mode) {
+
+		par->cur_mode = par->new_mode;
+		par->res = &car_modes[par->new_mode];
+
+		carmine_init_display_param(par);
+		set_display_parameters(par);
+	}
+
+	info->fix.line_length = info->var.xres * info->var.bits_per_pixel / 8;
+	return 0;
+}
+
+static int init_hardware(struct carmine_hw *hw)
+{
+	u32 flags;
+	u32 loops;
+	u32 ret;
+
+	/* Initalize Carmine */
+	/* Sets internal clock */
+	c_set_hw_reg(hw, CARMINE_CTL_REG + CARMINE_CTL_REG_CLOCK_ENABLE,
+			CARMINE_DFLT_IP_CLOCK_ENABLE);
+
+	/* Video signal output is turned off */
+	c_set_hw_reg(hw, CARMINE_DISP0_REG + CARMINE_DISP_REG_DCM1, 0);
+	c_set_hw_reg(hw, CARMINE_DISP1_REG + CARMINE_DISP_REG_DCM1, 0);
+
+	/* Software reset */
+	c_set_hw_reg(hw, CARMINE_CTL_REG + CARMINE_CTL_REG_SOFTWARE_RESET, 1);
+	c_set_hw_reg(hw, CARMINE_CTL_REG + CARMINE_CTL_REG_SOFTWARE_RESET, 0);
+
+	/* I/O mode settings */
+	flags = CARMINE_DFLT_IP_DCTL_IO_CONT1 << 16 |
+		CARMINE_DFLT_IP_DCTL_IO_CONT0;
+	c_set_hw_reg(hw, CARMINE_DCTL_REG + CARMINE_DCTL_REG_IOCONT1_IOCONT0,
+			flags);
+
+	/* DRAM initial sequence */
+	flags = CARMINE_DFLT_IP_DCTL_MODE << 16 | CARMINE_DFLT_IP_DCTL_ADD;
+	c_set_hw_reg(hw, CARMINE_DCTL_REG + CARMINE_DCTL_REG_MODE_ADD,
+			flags);
+
+	flags = CARMINE_DFLT_IP_DCTL_SET_TIME1 << 16 |
+		CARMINE_DFLT_IP_DCTL_EMODE;
+	c_set_hw_reg(hw, CARMINE_DCTL_REG + CARMINE_DCTL_REG_SETTIME1_EMODE,
+			flags);
+
+	flags = CARMINE_DFLT_IP_DCTL_REFRESH << 16 |
+		CARMINE_DFLT_IP_DCTL_SET_TIME2;
+	c_set_hw_reg(hw, CARMINE_DCTL_REG + CARMINE_DCTL_REG_REFRESH_SETTIME2,
+			flags);
+
+	flags = CARMINE_DFLT_IP_DCTL_RESERVE2 << 16 |
+		CARMINE_DFLT_IP_DCTL_FIFO_DEPTH;
+	c_set_hw_reg(hw, CARMINE_DCTL_REG + CARMINE_DCTL_REG_RSV2_RSV1, flags);
+
+	flags = CARMINE_DFLT_IP_DCTL_DDRIF2 << 16 | CARMINE_DFLT_IP_DCTL_DDRIF1;
+	c_set_hw_reg(hw, CARMINE_DCTL_REG + CARMINE_DCTL_REG_DDRIF2_DDRIF1,
+			flags);
+
+	flags = CARMINE_DFLT_IP_DCTL_RESERVE0 << 16 |
+		CARMINE_DFLT_IP_DCTL_STATES;
+	c_set_hw_reg(hw, CARMINE_DCTL_REG + CARMINE_DCTL_REG_RSV0_STATES,
+			flags);
+
+	/* Executes DLL reset */
+	if (CARMINE_DCTL_DLL_RESET) {
+		for (loops = 0; loops < CARMINE_DCTL_INIT_WAIT_LIMIT; loops++) {
+
+			ret = c_get_hw_reg(hw, CARMINE_DCTL_REG +
+					CARMINE_DCTL_REG_RSV0_STATES);
+			ret &= CARMINE_DCTL_REG_STATES_MASK;
+			if (!ret)
+				break;
+
+			mdelay(CARMINE_DCTL_INIT_WAIT_INTERVAL);
+		}
+
+		if (loops >= CARMINE_DCTL_INIT_WAIT_LIMIT) {
+			printk(KERN_ERR "DRAM init failed\n");
+			return -EIO;
+		}
+	}
+
+	flags = CARMINE_DFLT_IP_DCTL_MODE_AFT_RST << 16 |
+		CARMINE_DFLT_IP_DCTL_ADD;
+	c_set_hw_reg(hw, CARMINE_DCTL_REG + CARMINE_DCTL_REG_MODE_ADD, flags);
+
+	flags = CARMINE_DFLT_IP_DCTL_RESERVE0 << 16 |
+		CARMINE_DFLT_IP_DCTL_STATES_AFT_RST;
+	c_set_hw_reg(hw, CARMINE_DCTL_REG + CARMINE_DCTL_REG_RSV0_STATES,
+			flags);
+
+	/* Initialize the write back register */
+	c_set_hw_reg(hw, CARMINE_WB_REG + CARMINE_WB_REG_WBM,
+			CARMINE_WB_REG_WBM_DEFAULT);
+
+	/* Initialize the Kottos registers */
+	c_set_hw_reg(hw, CARMINE_GRAPH_REG + CARMINE_GRAPH_REG_VRINTM, 0);
+	c_set_hw_reg(hw, CARMINE_GRAPH_REG + CARMINE_GRAPH_REG_VRERRM, 0);
+
+	/* Set DC offsets */
+	c_set_hw_reg(hw, CARMINE_GRAPH_REG + CARMINE_GRAPH_REG_DC_OFFSET_PX, 0);
+	c_set_hw_reg(hw, CARMINE_GRAPH_REG + CARMINE_GRAPH_REG_DC_OFFSET_PY, 0);
+	c_set_hw_reg(hw, CARMINE_GRAPH_REG + CARMINE_GRAPH_REG_DC_OFFSET_LX, 0);
+	c_set_hw_reg(hw, CARMINE_GRAPH_REG + CARMINE_GRAPH_REG_DC_OFFSET_LY, 0);
+	c_set_hw_reg(hw, CARMINE_GRAPH_REG + CARMINE_GRAPH_REG_DC_OFFSET_TX, 0);
+	c_set_hw_reg(hw, CARMINE_GRAPH_REG + CARMINE_GRAPH_REG_DC_OFFSET_TY, 0);
+	return 0;
+}
+
+static struct fb_ops carminefb_ops = {
+	.owner		= THIS_MODULE,
+	.fb_fillrect	= cfb_fillrect,
+	.fb_copyarea	= cfb_copyarea,
+	.fb_imageblit	= cfb_imageblit,
+
+	.fb_check_var	= carmine_check_var,
+	.fb_set_par	= carmine_set_par,
+	.fb_setcolreg	= carmine_setcolreg,
+};
+
+static int alloc_carmine_fb(void __iomem *regs, void __iomem *smem_base,
+		int smem_offset, struct device *device, struct fb_info **rinfo)
+{
+	int ret;
+	struct fb_info *info;
+	struct carmine_fb *par;
+
+	info = framebuffer_alloc(sizeof *par, device);
+	if (!info)
+		return -ENOMEM;
+
+	par = info->par;
+	par->display_reg = regs;
+	par->smem_offset = smem_offset;
+
+	info->screen_base = smem_base + smem_offset;
+	info->screen_size = CARMINE_DISPLAY_MEM;
+	info->fbops = &carminefb_ops;
+
+	info->fix = carminefb_fix;
+	info->pseudo_palette = par->pseudo_palette;
+	info->flags = FBINFO_DEFAULT;
+
+	ret = fb_alloc_cmap(&info->cmap, 256, 1);
+	if (ret < 0)
+		goto err_free_fb;
+
+	if (fb_mode > ARRAY_SIZE(carmine_modedb))
+		fb_mode = CARMINEFB_DEFAULT_VIDEO_MODE;
+
+	par->cur_mode = par->new_mode = ~0;
+
+	ret = fb_find_mode(&info->var, info, fb_mode_str, carmine_modedb,
+			ARRAY_SIZE(carmine_modedb),
+			&carmine_modedb[fb_mode], 32);
+	if (!ret || ret == 4) {
+		ret = -EINVAL;
+		goto err_dealloc_cmap;
+	}
+
+	fb_videomode_to_modelist(carmine_modedb, ARRAY_SIZE(carmine_modedb),
+			&info->modelist);
+
+	ret = register_framebuffer(info);
+	if (ret < 0)
+		goto err_dealloc_cmap;
+
+	printk(KERN_INFO "fb%d: %s frame buffer device\n", info->node,
+			info->fix.id);
+
+	*rinfo = info;
+	return 0;
+
+err_dealloc_cmap:
+	fb_dealloc_cmap(&info->cmap);
+err_free_fb:
+	framebuffer_release(info);
+	return ret;
+}
+
+static void cleanup_fb_device(struct fb_info *info)
+{
+	if (info) {
+		unregister_framebuffer(info);
+		fb_dealloc_cmap(&info->cmap);
+		framebuffer_release(info);
+	}
+}
+
+static int __devinit carminefb_probe(struct pci_dev *dev,
+		const struct pci_device_id *ent)
+{
+	struct carmine_hw *hw;
+	struct device *device = &dev->dev;
+	struct fb_info *info;
+	int ret;
+
+	ret = pci_enable_device(dev);
+	if (ret)
+		return ret;
+
+	ret = -ENOMEM;
+	hw = kzalloc(sizeof *hw, GFP_KERNEL);
+	if (!hw)
+		goto err_enable_pci;
+
+	carminefb_fix.mmio_start = pci_resource_start(dev, CARMINE_CONFIG_BAR);
+	carminefb_fix.mmio_len = pci_resource_len(dev, CARMINE_CONFIG_BAR);
+
+	if (!request_mem_region(carminefb_fix.mmio_start,
+				carminefb_fix.mmio_len,
+				"carminefb regbase")) {
+		printk(KERN_ERR "carminefb: Can't reserve regbase.\n");
+		ret = -EBUSY;
+		goto err_free_hw;
+	}
+	hw->v_regs = ioremap_nocache(carminefb_fix.mmio_start,
+			carminefb_fix.mmio_len);
+	if (!hw->v_regs) {
+		printk(KERN_ERR "carminefb: Can't remap %s register.\n",
+				carminefb_fix.id);
+		goto err_free_reg_mmio;
+	}
+
+	carminefb_fix.smem_start = pci_resource_start(dev, CARMINE_MEMORY_BAR);
+	carminefb_fix.smem_len = pci_resource_len(dev, CARMINE_MEMORY_BAR);
+
+	/* The memory area tends to be very large (256 MiB). Remap only what
+	 * is required for that largest resolution to avoid remaps at run
+	 * time
+	 */
+	if (carminefb_fix.smem_len > CARMINE_TOTAL_DIPLAY_MEM)
+		carminefb_fix.smem_len = CARMINE_TOTAL_DIPLAY_MEM;
+
+	else if (carminefb_fix.smem_len < CARMINE_TOTAL_DIPLAY_MEM) {
+		printk(KERN_ERR "carminefb: Memory bar is only %d bytes, %d "
+				"are required.", carminefb_fix.smem_len,
+				CARMINE_TOTAL_DIPLAY_MEM);
+		goto err_free_reg_mmio;
+	}
+
+	if (!request_mem_region(carminefb_fix.smem_start,
+				carminefb_fix.smem_len,	"carminefb smem")) {
+		printk(KERN_ERR "carminefb: Can't reserve smem.\n");
+		goto err_unmap_vregs;
+	}
+
+	hw->screen_mem = ioremap_nocache(carminefb_fix.smem_start,
+			carminefb_fix.smem_len);
+	if (!hw->screen_mem) {
+		printk(KERN_ERR "carmine: Can't ioremap smem area.\n");
+		release_mem_region(carminefb_fix.smem_start,
+				carminefb_fix.smem_len);
+		goto err_reg_smem;
+	}
+
+	ret = init_hardware(hw);
+	if (ret)
+		goto err_unmap_screen;
+
+	info = NULL;
+	if (fb_displays & CARMINE_USE_DISPLAY0) {
+		ret = alloc_carmine_fb(hw->v_regs + CARMINE_DISP0_REG,
+				hw->screen_mem, CARMINE_DISPLAY_MEM * 0,
+				device, &info);
+		if (ret)
+			goto err_deinit_hw;
+	}
+
+	hw->fb[0] = info;
+
+	info = NULL;
+	if (fb_displays & CARMINE_USE_DISPLAY1) {
+		ret = alloc_carmine_fb(hw->v_regs + CARMINE_DISP1_REG,
+				hw->screen_mem, CARMINE_DISPLAY_MEM * 1,
+				device, &info);
+		if (ret)
+			goto err_cleanup_fb0;
+	}
+
+	hw->fb[1] = info;
+	info = NULL;
+
+	pci_set_drvdata(dev, hw);
+	return 0;
+
+err_cleanup_fb0:
+	cleanup_fb_device(hw->fb[0]);
+err_deinit_hw:
+	/* disable clock, etc */
+	c_set_hw_reg(hw, CARMINE_CTL_REG + CARMINE_CTL_REG_CLOCK_ENABLE, 0);
+err_unmap_screen:
+	iounmap(hw->screen_mem);
+err_reg_smem:
+	release_mem_region(carminefb_fix.mmio_start, carminefb_fix.mmio_len);
+err_unmap_vregs:
+	iounmap(hw->v_regs);
+err_free_reg_mmio:
+	release_mem_region(carminefb_fix.mmio_start, carminefb_fix.mmio_len);
+err_free_hw:
+	kfree(hw);
+err_enable_pci:
+	pci_disable_device(dev);
+	return ret;
+}
+
+static void __devexit carminefb_remove(struct pci_dev *dev)
+{
+	struct carmine_hw *hw = pci_get_drvdata(dev);
+	struct fb_fix_screeninfo fix;
+	int i;
+
+	/* in case we use only fb1 and not fb1 */
+	if (hw->fb[0])
+		fix = hw->fb[0]->fix;
+	else
+		fix = hw->fb[1]->fix;
+
+	/* deactivate display(s) and switch clocks */
+	c_set_hw_reg(hw, CARMINE_DISP0_REG + CARMINE_DISP_REG_DCM1, 0);
+	c_set_hw_reg(hw, CARMINE_DISP1_REG + CARMINE_DISP_REG_DCM1, 0);
+	c_set_hw_reg(hw, CARMINE_CTL_REG + CARMINE_CTL_REG_CLOCK_ENABLE, 0);
+
+	for (i = 0; i < MAX_DISPLAY; i++)
+		cleanup_fb_device(hw->fb[i]);
+
+	iounmap(hw->screen_mem);
+	release_mem_region(fix.smem_start, fix.smem_len);
+	iounmap(hw->v_regs);
+	release_mem_region(fix.mmio_start, fix.mmio_len);
+
+	pci_set_drvdata(dev, NULL);
+	pci_disable_device(dev);
+	kfree(hw);
+}
+
+#define PCI_VENDOR_ID_FUJITU_LIMITED 0x10cf
+static struct pci_device_id carmine_devices[] __devinitdata = {
+{
+	PCI_DEVICE(PCI_VENDOR_ID_FUJITU_LIMITED, 0x202b)},
+	{0, 0, 0, 0, 0, 0, 0}
+};
+
+MODULE_DEVICE_TABLE(pci, carmine_devices);
+
+static struct pci_driver carmine_pci_driver = {
+	.name		= "carminefb",
+	.id_table	= carmine_devices,
+	.probe		= carminefb_probe,
+	.remove		= __devexit_p(carminefb_remove),
+};
+
+static int __init carminefb_init(void)
+{
+	if (!(fb_displays &
+		(CARMINE_USE_DISPLAY0 | CARMINE_USE_DISPLAY1))) {
+		printk(KERN_ERR "If you disable both displays than you don't "
+				"need the driver at all\n");
+		return -EINVAL;
+	}
+	return pci_register_driver(&carmine_pci_driver);
+}
+module_init(carminefb_init);
+
+static void __exit carminefb_cleanup(void)
+{
+	pci_unregister_driver(&carmine_pci_driver);
+}
+module_exit(carminefb_cleanup);
+
+MODULE_AUTHOR("Sebastian Siewior <bigeasy@linutronix.de>");
+MODULE_DESCRIPTION("Framebuffer driver for Fujitsu Carmine based devices");
+MODULE_LICENSE("GPL v2");
diff -puN /dev/null drivers/video/carminefb.h
--- /dev/null
+++ a/drivers/video/carminefb.h
@@ -0,0 +1,64 @@
+#ifndef CARMINE_CARMINE_H
+#define CARMINE_CARMINE_H
+
+#define CARMINE_MEMORY_BAR	2
+#define CARMINE_CONFIG_BAR	3
+
+#define MAX_DISPLAY	2
+#define CARMINE_DISPLAY_MEM	(800 * 600 * 4)
+#define CARMINE_TOTAL_DIPLAY_MEM	(CARMINE_DISPLAY_MEM * MAX_DISPLAY)
+
+#define CARMINE_USE_DISPLAY0	(1 << 0)
+#define CARMINE_USE_DISPLAY1	(1 << 1)
+
+/*
+ * This values work on the eval card. Custom boards may use different timings,
+ * here an example :)
+ */
+
+/* DRAM initialization values */
+#ifdef CONFIG_FB_CARMINE_DRAM_EVAL
+
+#define CARMINE_DFLT_IP_CLOCK_ENABLE		(0x03ff)
+#define CARMINE_DFLT_IP_DCTL_ADD		(0x05c3)
+#define CARMINE_DFLT_IP_DCTL_MODE		(0x0121)
+#define CARMINE_DFLT_IP_DCTL_EMODE		(0x8000)
+#define CARMINE_DFLT_IP_DCTL_SET_TIME1		(0x4749)
+#define CARMINE_DFLT_IP_DCTL_SET_TIME2		(0x2a22)
+#define CARMINE_DFLT_IP_DCTL_REFRESH		(0x0042)
+#define CARMINE_DFLT_IP_DCTL_STATES		(0x0003)
+#define CARMINE_DFLT_IP_DCTL_RESERVE0		(0x0020)
+#define CARMINE_DFLT_IP_DCTL_FIFO_DEPTH		(0x000f)
+#define CARMINE_DFLT_IP_DCTL_RESERVE2		(0x0000)
+#define CARMINE_DFLT_IP_DCTL_DDRIF1		(0x6646)
+#define CARMINE_DFLT_IP_DCTL_DDRIF2		(0x0055)
+#define CARMINE_DFLT_IP_DCTL_MODE_AFT_RST	(0x0021)
+#define CARMINE_DFLT_IP_DCTL_STATES_AFT_RST	(0x0002)
+#define CARMINE_DFLT_IP_DCTL_IO_CONT0		(0x0555)
+#define CARMINE_DFLT_IP_DCTL_IO_CONT1		(0x0555)
+#define CARMINE_DCTL_DLL_RESET			(1)
+#endif
+
+#ifdef CONFIG_CARMINE_DRAM_CUSTOM
+
+#define CARMINE_DFLT_IP_CLOCK_ENABLE		(0x03ff)
+#define CARMINE_DFLT_IP_DCTL_ADD		(0x03b2)
+#define CARMINE_DFLT_IP_DCTL_MODE		(0x0161)
+#define CARMINE_DFLT_IP_DCTL_EMODE		(0x8000)
+#define CARMINE_DFLT_IP_DCTL_SET_TIME1		(0x2628)
+#define CARMINE_DFLT_IP_DCTL_SET_TIME2		(0x1a09)
+#define CARMINE_DFLT_IP_DCTL_REFRESH		(0x00fe)
+#define CARMINE_DFLT_IP_DCTL_STATES		(0x0003)
+#define CARMINE_DFLT_IP_DCTL_RESERVE0		(0x0020)
+#define CARMINE_DFLT_IP_DCTL_FIFO_DEPTH		(0x000f)
+#define CARMINE_DFLT_IP_DCTL_RESERVE2		(0x0000)
+#define CARMINE_DFLT_IP_DCTL_DDRIF1		(0x0646)
+#define CARMINE_DFLT_IP_DCTL_DDRIF2		(0x55aa)
+#define CARMINE_DFLT_IP_DCTL_MODE_AFT_RST	(0x0061)
+#define CARMINE_DFLT_IP_DCTL_STATES_AFT_RST	(0x0002)
+#define CARMINE_DFLT_IP_DCTL_IO_CONT0		(0x0555)
+#define CARMINE_DFLT_IP_DCTL_IO_CONT1		(0x0555)
+#define CARMINE_DCTL_DLL_RESET			(1)
+#endif
+
+#endif
diff -puN /dev/null drivers/video/carminefb_regs.h
--- /dev/null
+++ a/drivers/video/carminefb_regs.h
@@ -0,0 +1,159 @@
+#ifndef _CARMINEFB_REGS_H
+#define _CARMINEFB_REGS_H
+
+#define CARMINE_OVERLAY_EXT_MODE	(0x00000002)
+#define CARMINE_GRAPH_REG		(0x00000000)
+#define CARMINE_DISP0_REG		(0x00100000)
+#define CARMINE_DISP1_REG		(0x00140000)
+#define CARMINE_WB_REG			(0x00180000)
+#define CARMINE_DCTL_REG		(0x00300000)
+#define CARMINE_CTL_REG			(0x00400000)
+#define CARMINE_WINDOW_MODE		(0x00000001)
+#define CARMINE_EXTEND_MODE		(CARMINE_WINDOW_MODE | \
+					CARMINE_OVERLAY_EXT_MODE)
+#define CARMINE_L0E			(1 << 16)
+#define CARMINE_L2E			(1 << 18)
+#define CARMINE_DEN			(1 << 31)
+
+#define CARMINE_EXT_CMODE_DIRECT24_RGBA		(0xC0000000)
+#define CARMINE_DCTL_REG_MODE_ADD		(0x00)
+#define CARMINE_DCTL_REG_SETTIME1_EMODE		(0x04)
+#define CARMINE_DCTL_REG_REFRESH_SETTIME2	(0x08)
+#define CARMINE_DCTL_REG_RSV0_STATES		(0x0C)
+#define CARMINE_DCTL_REG_RSV2_RSV1		(0x10)
+#define CARMINE_DCTL_REG_DDRIF2_DDRIF1		(0x14)
+#define CARMINE_DCTL_REG_IOCONT1_IOCONT0	(0x24)
+#define CARMINE_DCTL_REG_STATES_MASK		(0x000F)
+#define CARMINE_DCTL_INIT_WAIT_INTERVAL		(1)
+#define CARMINE_DCTL_INIT_WAIT_LIMIT		(5000)
+#define CARMINE_WB_REG_WBM_DEFAULT		(0x0001c020)
+#define CARMINE_DISP_REG_L0RM			(0x1880)
+#define CARMINE_DISP_REG_L0PX			(0x1884)
+#define CARMINE_DISP_REG_L0PY			(0x1888)
+#define CARMINE_DISP_REG_L2RM			(0x18A0)
+#define CARMINE_DISP_REG_L2PX			(0x18A4)
+#define CARMINE_DISP_REG_L2PY			(0x18A8)
+#define CARMINE_DISP_REG_L3RM			(0x18B0)
+#define CARMINE_DISP_REG_L3PX			(0x18B4)
+#define CARMINE_DISP_REG_L3PY			(0x18B8)
+#define CARMINE_DISP_REG_L4RM			(0x18C0)
+#define CARMINE_DISP_REG_L4PX			(0x18C4)
+#define CARMINE_DISP_REG_L4PY			(0x18C8)
+#define CARMINE_DISP_REG_L5RM			(0x18D0)
+#define CARMINE_DISP_REG_L5PX			(0x18D4)
+#define CARMINE_DISP_REG_L5PY			(0x18D8)
+#define CARMINE_DISP_REG_L6RM			(0x1924)
+#define CARMINE_DISP_REG_L6PX			(0x1928)
+#define CARMINE_DISP_REG_L6PY			(0x192C)
+#define CARMINE_DISP_REG_L7RM			(0x1964)
+#define CARMINE_DISP_REG_L7PX			(0x1968)
+#define CARMINE_DISP_REG_L7PY			(0x196C)
+#define CARMINE_WB_REG_WBM			(0x0004)
+#define CARMINE_DISP_HTP_SHIFT			(16)
+#define CARMINE_DISP_HDB_SHIFT			(16)
+#define CARMINE_DISP_HSW_SHIFT			(16)
+#define CARMINE_DISP_VSW_SHIFT			(24)
+#define CARMINE_DISP_VTR_SHIFT			(16)
+#define CARMINE_DISP_VDP_SHIFT			(16)
+#define CARMINE_CURSOR_CUTZ_MASK		(0x00000100)
+#define CARMINE_CURSOR0_PRIORITY_MASK		(0x00010000)
+#define CARMINE_CURSOR1_PRIORITY_MASK		(0x00020000)
+#define CARMINE_DISP_WIDTH_SHIFT		(16)
+#define CARMINE_DISP_WIN_H_SHIFT		(16)
+#define CARMINE_DISP_REG_H_TOTAL		(0x0004)
+#define CARMINE_DISP_REG_H_PERIOD		(0x0008)
+#define CARMINE_DISP_REG_V_H_W_H_POS		(0x000C)
+#define CARMINE_DISP_REG_V_TOTAL		(0x0010)
+#define CARMINE_DISP_REG_V_PERIOD_POS		(0x0014)
+#define CARMINE_DISP_REG_L0_MODE_W_H		(0x0020)
+#define CARMINE_DISP_REG_L0_ORG_ADR		(0x0024)
+#define CARMINE_DISP_REG_L0_DISP_ADR		(0x0028)
+#define CARMINE_DISP_REG_L0_DISP_POS		(0x002C)
+#define CARMINE_DISP_REG_L1_WIDTH		(0x0030)
+#define CARMINE_DISP_REG_L1_ORG_ADR		(0x0034)
+#define CARMINE_DISP_REG_L2_MODE_W_H		(0x0040)
+#define CARMINE_DISP_REG_L2_ORG_ADR1		(0x0044)
+#define CARMINE_DISP_REG_L2_DISP_ADR1		(0x0048)
+#define CARMINE_DISP_REG_L2_DISP_POS		(0x0054)
+#define CARMINE_DISP_REG_L3_MODE_W_H		(0x0058)
+#define CARMINE_DISP_REG_L3_ORG_ADR1		(0x005C)
+#define CARMINE_DISP_REG_L3_DISP_ADR1		(0x0060)
+#define CARMINE_DISP_REG_L3_DISP_POS		(0x006C)
+#define CARMINE_DISP_REG_L4_MODE_W_H		(0x0070)
+#define CARMINE_DISP_REG_L4_ORG_ADR1		(0x0074)
+#define CARMINE_DISP_REG_L4_DISP_ADR1		(0x0078)
+#define CARMINE_DISP_REG_L4_DISP_POS		(0x0084)
+#define CARMINE_DISP_REG_L5_MODE_W_H		(0x0088)
+#define CARMINE_DISP_REG_L5_ORG_ADR1		(0x008C)
+#define CARMINE_DISP_REG_L5_DISP_ADR1		(0x0090)
+#define CARMINE_DISP_REG_L5_DISP_POS		(0x009C)
+#define CARMINE_DISP_REG_CURSOR_MODE		(0x00A0)
+#define CARMINE_DISP_REG_CUR1_POS		(0x00A8)
+#define CARMINE_DISP_REG_CUR2_POS		(0x00B0)
+#define CARMINE_DISP_REG_C_TRANS		(0x00BC)
+#define CARMINE_DISP_REG_MLMR_TRANS		(0x00C0)
+#define CARMINE_DISP_REG_L0_EXT_MODE		(0x0110)
+#define CARMINE_DISP_REG_L0_WIN_POS		(0x0114)
+#define CARMINE_DISP_REG_L0_WIN_SIZE		(0x0118)
+#define CARMINE_DISP_REG_L1_EXT_MODE		(0x0120)
+#define CARMINE_DISP_REG_L1_WIN_POS		(0x0124)
+#define CARMINE_DISP_REG_L1_WIN_SIZE		(0x0128)
+#define CARMINE_DISP_REG_L2_EXT_MODE		(0x0130)
+#define CARMINE_DISP_REG_L2_WIN_POS		(0x0134)
+#define CARMINE_DISP_REG_L2_WIN_SIZE		(0x0138)
+#define CARMINE_DISP_REG_L3_EXT_MODE		(0x0140)
+#define CARMINE_DISP_REG_L3_WIN_POS		(0x0144)
+#define CARMINE_DISP_REG_L3_WIN_SIZE		(0x0148)
+#define CARMINE_DISP_REG_L4_EXT_MODE		(0x0150)
+#define CARMINE_DISP_REG_L4_WIN_POS		(0x0154)
+#define CARMINE_DISP_REG_L4_WIN_SIZE		(0x0158)
+#define CARMINE_DISP_REG_L5_EXT_MODE		(0x0160)
+#define CARMINE_DISP_REG_L5_WIN_POS		(0x0164)
+#define CARMINE_DISP_REG_L5_WIN_SIZE		(0x0168)
+#define CARMINE_DISP_REG_L6_EXT_MODE		(0x1918)
+#define CARMINE_DISP_REG_L6_WIN_POS		(0x191c)
+#define CARMINE_DISP_REG_L6_WIN_SIZE		(0x1920)
+#define CARMINE_DISP_REG_L7_EXT_MODE		(0x1958)
+#define CARMINE_DISP_REG_L7_WIN_POS		(0x195c)
+#define CARMINE_DISP_REG_L7_WIN_SIZE		(0x1960)
+#define CARMINE_DISP_REG_BLEND_MODE_L0		(0x00B4)
+#define CARMINE_DISP_REG_BLEND_MODE_L1		(0x0188)
+#define CARMINE_DISP_REG_BLEND_MODE_L2		(0x018C)
+#define CARMINE_DISP_REG_BLEND_MODE_L3		(0x0190)
+#define CARMINE_DISP_REG_BLEND_MODE_L4		(0x0194)
+#define CARMINE_DISP_REG_BLEND_MODE_L5		(0x0198)
+#define CARMINE_DISP_REG_BLEND_MODE_L6		(0x1990)
+#define CARMINE_DISP_REG_BLEND_MODE_L7		(0x1994)
+#define CARMINE_DISP_REG_L0_TRANS		(0x01A0)
+#define CARMINE_DISP_REG_L1_TRANS		(0x01A4)
+#define CARMINE_DISP_REG_L2_TRANS		(0x01A8)
+#define CARMINE_DISP_REG_L3_TRANS		(0x01AC)
+#define CARMINE_DISP_REG_L4_TRANS		(0x01B0)
+#define CARMINE_DISP_REG_L5_TRANS		(0x01B4)
+#define CARMINE_DISP_REG_L6_TRANS		(0x1998)
+#define CARMINE_DISP_REG_L7_TRANS		(0x199c)
+#define CARMINE_EXTEND_MODE_MASK		(0x00000003)
+#define CARMINE_DISP_DCM_MASK			(0x0000FFFF)
+#define CARMINE_DISP_REG_DCM1			(0x0100)
+#define CARMINE_DISP_WIDTH_UNIT			(64)
+#define CARMINE_DISP_REG_L6_MODE_W_H		(0x1900)
+#define CARMINE_DISP_REG_L6_ORG_ADR1		(0x1904)
+#define CARMINE_DISP_REG_L6_DISP_ADR0		(0x1908)
+#define CARMINE_DISP_REG_L6_DISP_POS		(0x1914)
+#define CARMINE_DISP_REG_L7_MODE_W_H		(0x1940)
+#define CARMINE_DISP_REG_L7_ORG_ADR1		(0x1944)
+#define CARMINE_DISP_REG_L7_DISP_ADR0		(0x1948)
+#define CARMINE_DISP_REG_L7_DISP_POS		(0x1954)
+#define CARMINE_CTL_REG_CLOCK_ENABLE		(0x000C)
+#define CARMINE_CTL_REG_SOFTWARE_RESET		(0x0010)
+#define CARMINE_CTL_REG_IST_MASK_ALL		(0x07FFFFFF)
+#define CARMINE_GRAPH_REG_VRINTM		(0x00028064)
+#define CARMINE_GRAPH_REG_VRERRM		(0x0002806C)
+#define CARMINE_GRAPH_REG_DC_OFFSET_PX		(0x0004005C)
+#define CARMINE_GRAPH_REG_DC_OFFSET_PY		(0x00040060)
+#define CARMINE_GRAPH_REG_DC_OFFSET_LX		(0x00040064)
+#define CARMINE_GRAPH_REG_DC_OFFSET_LY		(0x00040068)
+#define CARMINE_GRAPH_REG_DC_OFFSET_TX		(0x0004006C)
+#define CARMINE_GRAPH_REG_DC_OFFSET_TY		(0x00040070)
+
+#endif
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

origin.patch
linux-next.patch
add-the-carmine-fb-driver.patch

