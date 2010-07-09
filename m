From: akpm@linux-foundation.org
Subject: + s3c-fb-correct-window-osd-size-and-alpha-register-handling.patch added to -mm tree
Date: Fri, 09 Jul 2010 16:09:15 -0700
Message-ID: <201007092309.o69N9FkI030993@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36279 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755625Ab0GIXJc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jul 2010 19:09:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: p.osciak@samsung.com, ben-linux@fluff.org, inki.dae@samsung.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com


The patch titled
     s3c-fb: correct window osd size and alpha register handling
has been added to the -mm tree.  Its filename is
     s3c-fb-correct-window-osd-size-and-alpha-register-handling.patch

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
Subject: s3c-fb: correct window osd size and alpha register handling
From: Pawel Osciak <p.osciak@samsung.com>

S3C64xx and S5P OSD registers for OSD size and alpha are as follows:
VIDOSDC: win 0 - size, win 1-4: alpha
VIDOSDD: win 1-2 - size; not present for windows 0, 3 and 4

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: InKi Dae <inki.dae@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3c-fb.c |   54 +++++++++++++++++++++++++++++++++------
 1 file changed, 47 insertions(+), 7 deletions(-)

diff -puN drivers/video/s3c-fb.c~s3c-fb-correct-window-osd-size-and-alpha-register-handling drivers/video/s3c-fb.c
--- a/drivers/video/s3c-fb.c~s3c-fb-correct-window-osd-size-and-alpha-register-handling
+++ a/drivers/video/s3c-fb.c
@@ -103,8 +103,11 @@ struct s3c_fb_variant {
  * struct s3c_fb_win_variant
  * @has_osd_c: Set if has OSD C register.
  * @has_osd_d: Set if has OSD D register.
+ * @has_osd_alpha: Set if can change alpha transparency for a window.
  * @palette_sz: Size of palette in entries.
  * @palette_16bpp: Set if palette is 16bits wide.
+ * @osd_size_off: If != 0, supports setting up OSD for a window; the appropriate
+ *                register is located at the given offset from OSD_BASE.
  * @valid_bpp: 1 bit per BPP setting to show valid bits-per-pixel.
  *
  * valid_bpp bit x is set if (x+1)BPP is supported.
@@ -112,7 +115,9 @@ struct s3c_fb_variant {
 struct s3c_fb_win_variant {
 	unsigned int	has_osd_c:1;
 	unsigned int	has_osd_d:1;
+	unsigned int	has_osd_alpha:1;
 	unsigned int	palette_16bpp:1;
+	unsigned short	osd_size_off;
 	unsigned short	palette_sz;
 	u32		valid_bpp;
 };
@@ -365,6 +370,36 @@ static int s3c_fb_align_word(unsigned in
 }
 
 /**
+ * vidosd_set_size() - set OSD size for a window
+ *
+ * @win: the window to set OSD size for
+ * @size: OSD size register value
+ */
+static void vidosd_set_size(struct s3c_fb_win *win, u32 size)
+{
+	struct s3c_fb *sfb = win->parent;
+
+	/* OSD can be set up if osd_size_off != 0 for this window */
+	if (win->variant.osd_size_off)
+		writel(size, sfb->regs + OSD_BASE(win->index, sfb->variant)
+				+ win->variant.osd_size_off);
+}
+
+/**
+ * vidosd_set_alpha() - set alpha transparency for a window
+ *
+ * @win: the window to set OSD size for
+ * @alpha: alpha register value
+ */
+static void vidosd_set_alpha(struct s3c_fb_win *win, u32 alpha)
+{
+	struct s3c_fb *sfb = win->parent;
+
+	if (win->variant.has_osd_alpha)
+		writel(alpha, sfb->regs + VIDOSD_C(win->index, sfb->variant));
+}
+
+/**
  * shadow_protect_win() - disable updating values from shadow registers at vsync
  *
  * @win: window to protect registers for
@@ -408,7 +443,7 @@ static int s3c_fb_set_par(struct fb_info
 	void __iomem *regs = sfb->regs;
 	void __iomem *buf = regs;
 	int win_no = win->index;
-	u32 osdc_data = 0;
+	u32 alpha = 0;
 	u32 data;
 	u32 pagewidth;
 	int clkdiv;
@@ -511,15 +546,12 @@ static int s3c_fb_set_par(struct fb_info
 
 	data = var->xres * var->yres;
 
-	osdc_data = VIDISD14C_ALPHA1_R(0xf) |
+	alpha = VIDISD14C_ALPHA1_R(0xf) |
 		VIDISD14C_ALPHA1_G(0xf) |
 		VIDISD14C_ALPHA1_B(0xf);
 
-	if (win->variant.has_osd_d) {
-		writel(data, regs + VIDOSD_D(win_no, sfb->variant));
-		writel(osdc_data, regs + VIDOSD_C(win_no, sfb->variant));
-	} else
-		writel(data, regs + VIDOSD_C(win_no, sfb->variant));
+	vidosd_set_alpha(win, alpha);
+	vidosd_set_size(win, data);
 
 	data = WINCONx_ENWIN;
 
@@ -1442,12 +1474,15 @@ static int s3c_fb_resume(struct platform
 static struct s3c_fb_win_variant s3c_fb_data_64xx_wins[] __devinitdata = {
 	[0] = {
 		.has_osd_c	= 1,
+		.osd_size_off	= 0x8,
 		.palette_sz	= 256,
 		.valid_bpp	= VALID_BPP1248 | VALID_BPP(16) | VALID_BPP(24),
 	},
 	[1] = {
 		.has_osd_c	= 1,
 		.has_osd_d	= 1,
+		.osd_size_off	= 0x12,
+		.has_osd_alpha	= 1,
 		.palette_sz	= 256,
 		.valid_bpp	= (VALID_BPP1248 | VALID_BPP(16) |
 				   VALID_BPP(18) | VALID_BPP(19) |
@@ -1456,6 +1491,8 @@ static struct s3c_fb_win_variant s3c_fb_
 	[2] = {
 		.has_osd_c	= 1,
 		.has_osd_d	= 1,
+		.osd_size_off	= 0x12,
+		.has_osd_alpha	= 1,
 		.palette_sz	= 16,
 		.palette_16bpp	= 1,
 		.valid_bpp	= (VALID_BPP1248 | VALID_BPP(16) |
@@ -1464,6 +1501,7 @@ static struct s3c_fb_win_variant s3c_fb_
 	},
 	[3] = {
 		.has_osd_c	= 1,
+		.has_osd_alpha	= 1,
 		.palette_sz	= 16,
 		.palette_16bpp	= 1,
 		.valid_bpp	= (VALID_BPP124  | VALID_BPP(16) |
@@ -1472,6 +1510,7 @@ static struct s3c_fb_win_variant s3c_fb_
 	},
 	[4] = {
 		.has_osd_c	= 1,
+		.has_osd_alpha	= 1,
 		.palette_sz	= 4,
 		.palette_16bpp	= 1,
 		.valid_bpp	= (VALID_BPP(1) | VALID_BPP(2) |
@@ -1597,6 +1636,7 @@ static struct s3c_fb_driverdata s3c_fb_d
 	},
 	.win[1] = &(struct s3c_fb_win_variant) {
 		.has_osd_c	= 1,
+		.has_osd_alpha	= 1,
 		.palette_sz	= 256,
 		.valid_bpp	= (VALID_BPP1248 | VALID_BPP(16) |
 				   VALID_BPP(18) | VALID_BPP(19) |
_

Patches currently in -mm which might be from p.osciak@samsung.com are

linux-next.patch
s3c-fb-change-to-depending-on-config_s3c_fb_dev.patch
s3c-fb-add-default-window-feature.patch
s3c-fb-fix-distortedness-situation-for-the-mode-more-then-24bpp.patch
s3c-fb-only-init-window-colour-key-controls-for-windows-with-blending.patch
s3c-fb-initial-move-to-unifying-the-header-files.patch
s3c-fb-udpate-to-support-s3c2416-s3c2443-style-hardware.patch
s3c-fb-integrate-palette-setup-code-into-main-driver.patch
s3c-fb-fix-various-null-references-on-framebuffer-memory-alloc-failure.patch
s3c-fb-correct-framesel1-bitfield-defines-for-vidintcon0-register.patch
s3c-fb-separate-s5pc100-and-s5pv210-framebuffer-driver-data-structures.patch
s3c-fb-add-device-name-initialization.patch
s3c-fb-add-support-for-display-panning.patch
s3c-fb-add-wait-for-vsync-ioctl.patch
s3c-fb-window-3-of-64xx-does-not-have-an-osd_d-register.patch
s3c-fb-add-shadowcon-shadow-register-locking-support-for-s5pv210.patch
s3c-fb-correct-window-osd-size-and-alpha-register-handling.patch
s3c-fb-protect-window-specific-registers-during-updates.patch
s3c-fb-add-support-for-dma-channel-control-on-s5pv210.patch

