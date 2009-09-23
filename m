From: akpm@linux-foundation.org
Subject: [merged] s3c2410fb-fix-clockrate-calculation.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:02:55 -0700
Message-ID: <200909232002.n8NK2tft018176@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51309 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753565AbZIWUDW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:03:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben@simtec.co.uk, mm-commits@vger.kernel.org


The patch titled
     s3c2410fb: fix clockrate calculation
has been removed from the -mm tree.  Its filename was
     s3c2410fb-fix-clockrate-calculation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: s3c2410fb: fix clockrate calculation
From: Ben Dooks <ben@simtec.co.uk>

In the final part of the calculation for the tft display clockrate we
divide the output pf s3c2410fb_calc_pixclk() by 2 which leaves us with a
rounding error if the result is odd.

Change to using DIV_ROUND_UP() to ensure that we always choose a higher
divisor and thus a lower frequency.

Signed-off-by: Ben Dooks <ben@simtec.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3c2410fb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/video/s3c2410fb.c~s3c2410fb-fix-clockrate-calculation drivers/video/s3c2410fb.c
--- a/drivers/video/s3c2410fb.c~s3c2410fb-fix-clockrate-calculation
+++ a/drivers/video/s3c2410fb.c
@@ -369,7 +369,9 @@ static void s3c2410fb_activate_var(struc
 	void __iomem *regs = fbi->io;
 	int type = fbi->regs.lcdcon1 & S3C2410_LCDCON1_TFT;
 	struct fb_var_screeninfo *var = &info->var;
-	int clkdiv = s3c2410fb_calc_pixclk(fbi, var->pixclock) / 2;
+	int clkdiv;
+
+	clkdiv = DIV_ROUND_UP(s3c2410fb_calc_pixclk(fbi, var->pixclock), 2);
 
 	dprintk("%s: var->xres  = %d\n", __func__, var->xres);
 	dprintk("%s: var->yres  = %d\n", __func__, var->yres);
_

Patches currently in -mm which might be from ben@simtec.co.uk are

origin.patch
linux-next.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch

