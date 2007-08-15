From: akpm@linux-foundation.org
Subject: + s3c2410fb-fix-missing-registers-offset.patch added to -mm tree
Date: Wed, 15 Aug 2007 16:21:20 -0700
Message-ID: <200708152321.l7FNLK5U020349@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53240 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759412AbXHOXaW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 19:30:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     s3c2410fb: fix missing registers offset
has been added to the -mm tree.  Its filename is
     s3c2410fb-fix-missing-registers-offset.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: s3c2410fb: fix missing registers offset
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch adds missing virtual register offsets where
appropriate. This fixes crashes in the driver.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3c2410fb.c |   32 ++++++++++++++++++++------------
 1 files changed, 20 insertions(+), 12 deletions(-)

diff -puN drivers/video/s3c2410fb.c~s3c2410fb-fix-missing-registers-offset drivers/video/s3c2410fb.c
--- a/drivers/video/s3c2410fb.c~s3c2410fb-fix-missing-registers-offset
+++ a/drivers/video/s3c2410fb.c
@@ -123,6 +123,8 @@ static void s3c2410fb_set_lcdaddr(struct
 {
 	unsigned long saddr1, saddr2, saddr3;
 	int line_length = info->var.xres * info->var.bits_per_pixel;
+	struct s3c2410fb_info *fbi = info->par;
+	void __iomem *regs = fbi->io;
 
 	saddr1  = info->fix.smem_start >> 1;
 	saddr2  = info->fix.smem_start;
@@ -136,9 +138,9 @@ static void s3c2410fb_set_lcdaddr(struct
 	dprintk("LCDSADDR2 = 0x%08lx\n", saddr2);
 	dprintk("LCDSADDR3 = 0x%08lx\n", saddr3);
 
-	writel(saddr1, S3C2410_LCDSADDR1);
-	writel(saddr2, S3C2410_LCDSADDR2);
-	writel(saddr3, S3C2410_LCDSADDR3);
+	writel(saddr1, regs + S3C2410_LCDSADDR1);
+	writel(saddr2, regs + S3C2410_LCDSADDR2);
+	writel(saddr3, regs + S3C2410_LCDSADDR3);
 }
 
 /* s3c2410fb_calc_pixclk()
@@ -409,6 +411,7 @@ static void s3c2410fb_calculate_tft_lcd_
 static void s3c2410fb_activate_var(struct fb_info *info)
 {
 	struct s3c2410fb_info *fbi = info->par;
+	void __iomem *regs = fbi->io;
 	struct fb_var_screeninfo *var = &info->var;
 	struct s3c2410fb_mach_info *mach_info = fbi->mach_info;
 	struct s3c2410fb_display *display = mach_info->displays +
@@ -449,16 +452,17 @@ static void s3c2410fb_activate_var(struc
 	dprintk("lcdcon[4] = 0x%08lx\n", fbi->regs.lcdcon4);
 	dprintk("lcdcon[5] = 0x%08lx\n", fbi->regs.lcdcon5);
 
-	writel(fbi->regs.lcdcon1 & ~S3C2410_LCDCON1_ENVID, S3C2410_LCDCON1);
-	writel(fbi->regs.lcdcon2, S3C2410_LCDCON2);
-	writel(fbi->regs.lcdcon3, S3C2410_LCDCON3);
-	writel(fbi->regs.lcdcon4, S3C2410_LCDCON4);
-	writel(fbi->regs.lcdcon5, S3C2410_LCDCON5);
+	writel(fbi->regs.lcdcon1 & ~S3C2410_LCDCON1_ENVID,
+		regs + S3C2410_LCDCON1);
+	writel(fbi->regs.lcdcon2, regs + S3C2410_LCDCON2);
+	writel(fbi->regs.lcdcon3, regs + S3C2410_LCDCON3);
+	writel(fbi->regs.lcdcon4, regs + S3C2410_LCDCON4);
+	writel(fbi->regs.lcdcon5, regs + S3C2410_LCDCON5);
 
 	/* set lcd address pointers */
 	s3c2410fb_set_lcdaddr(info);
 
-	writel(fbi->regs.lcdcon1, S3C2410_LCDCON1);
+	writel(fbi->regs.lcdcon1, regs + S3C2410_LCDCON1);
 }
 
 /*
@@ -527,6 +531,7 @@ static int s3c2410fb_setcolreg(unsigned 
 			       unsigned transp, struct fb_info *info)
 {
 	struct s3c2410fb_info *fbi = info->par;
+	void __iomem *regs = fbi->io;
 	unsigned int val;
 
 	/* dprintk("setcol: regno=%d, rgb=%d,%d,%d\n",
@@ -555,7 +560,7 @@ static int s3c2410fb_setcolreg(unsigned 
 			val |= ((green >>  5) & 0x07e0);
 			val |= ((blue  >> 11) & 0x001f);
 
-			writel(val, S3C2410_TFTPAL(regno));
+			writel(val, regs + S3C2410_TFTPAL(regno));
 			schedule_palette_update(fbi, regno, val);
 		}
 
@@ -586,16 +591,19 @@ static int s3c2410fb_setcolreg(unsigned 
  */
 static int s3c2410fb_blank(int blank_mode, struct fb_info *info)
 {
+	struct s3c2410fb_info *fbi = info->par;
+	void __iomem *regs = fbi->io;
+
 	dprintk("blank(mode=%d, info=%p)\n", blank_mode, info);
 
 	if (mach_info == NULL)
 		return -EINVAL;
 
 	if (blank_mode == FB_BLANK_UNBLANK)
-		writel(0x0, S3C2410_TPAL);
+		writel(0x0, regs + S3C2410_TPAL);
 	else {
 		dprintk("setting TPAL to output 0x000000\n");
-		writel(S3C2410_TPAL_EN, S3C2410_TPAL);
+		writel(S3C2410_TPAL_EN, regs + S3C2410_TPAL);
 	}
 
 	return 0;
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

git-alsa.patch
git-arm-master.patch
git-hwmon.patch
pm3fb-copyarea-and-partial-imageblit-suppor.patch
skeletonfb-wrong-field-name-fix.patch
pm3fb-header-file-reduction.patch
pm3fb-imageblit-improved.patch
pm3fb-3-small-fixes.patch
pm3fb-improvements-and-cleanups.patch
pm3fb-mtrr-support-and-noaccel-option.patch
pm2fb-mtrr-support-and-noaccel-option.patch
pm2fb-mtrr-support-and-noaccel-option-pm2fb-lowsyncs-section-mismatch-fix.patch
pm2fb-accelerated-imageblit.patch
pm2fb-source-code-improvements.patch
pm2fb-permedia-2v-initialization-fixes.patch
pm2fb-accelerated-24-bit-fillrect.patch
tridentfb-coding-style-improvement.patch
tdfxfb-coding-style-improvement.patch
tdfxfb-3-fixes.patch
tdfxfb-palette-fixes.patch
tdfxfb-code-improvements.patch
tdfxfb-hardware-cursor.patch
tdfxfb-mtrr-support.patch
tdfxfb-mtrr-support-fix.patch
tdfxfb-mtrr-support-fix-2.patch
pm2fb-checkpatch-fixes.patch
pm3fb-checkpatch-fixes.patch
pm2fb-permedia-2v-hardware-cursor-support.patch
pm3fb-hardware-cursor-support.patch
s3c2410fb-code-cleanup.patch
s3c2410fb-remove-fb_info-pointer-from-s3c2410fb_info.patch
s3c2410fb-multi-display-support.patch
s3c2410fb-add-margin-fields-to-s3c2410fb_display.patch
s3c2410fb-use-new-margin-fields.patch
s3c2410fb-remove-lcdcon3-register-from-s3c2410fb_display.patch
s3c2410fb-add-vertical-margins-fields-to-s3c2410fb_display.patch
s3c2410fb-use-vertical-margins-values.patch
s3c2410fb-add-pulse-length-fields-to-s3c2410fb_display.patch
s3c2410fb-remove-lcdcon2-and-lcdcon3-register-fields.patch
s3c2410fb-fix-missing-registers-offset.patch
