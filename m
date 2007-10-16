From: akpm@linux-foundation.org
Subject: - s3c2410fb-fix-missing-registers-offset.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:43:27 -0700
Message-ID: <200710162043.l9GKhRkO016050@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60059 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936079AbXJPVIu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:08:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     s3c2410fb: fix missing registers offset
has been removed from the -mm tree.  Its filename was
     s3c2410fb-fix-missing-registers-offset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 20 insertions(+), 12 deletions(-)

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

origin.patch
git-alsa.patch
cyber2000fb-checkpatch-fixes.patch
