From: akpm@linux-foundation.org
Subject: - s3fb-do-not-allow-incorrect-pixclock-settings.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:45:49 -0700
Message-ID: <200710162045.l9GKjnRv016303@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59602 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935163AbXJPU4y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 16:56:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     s3fb: do not allow incorrect pixclock settings
has been removed from the -mm tree.  Its filename was
     s3fb-do-not-allow-incorrect-pixclock-settings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: s3fb: do not allow incorrect pixclock settings
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch adds check if selected pixclock is valid (is in the PLL range).

Previously, if the pixclock could not be set, the new mode resolution was set
but pixclock was not set which led to incorrect timings sent to monitor.

[adaplas]
Fixed a few misplaced curly braces.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3fb.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN drivers/video/s3fb.c~s3fb-do-not-allow-incorrect-pixclock-settings drivers/video/s3fb.c
--- a/drivers/video/s3fb.c~s3fb-do-not-allow-incorrect-pixclock-settings
+++ a/drivers/video/s3fb.c
@@ -400,6 +400,7 @@ static int s3fb_check_var(struct fb_var_
 {
 	struct s3fb_info *par = info->par;
 	int rv, mem, step;
+	u16 m, n, r;
 
 	/* Find appropriate format */
 	rv = svga_match_format (s3fb_formats, var, NULL);
@@ -427,20 +428,26 @@ static int s3fb_check_var(struct fb_var_
 
 	/* Check whether have enough memory */
 	mem = ((var->bits_per_pixel * var->xres_virtual) >> 3) * var->yres_virtual;
-	if (mem > info->screen_size)
-	{
+	if (mem > info->screen_size) {
 		printk(KERN_ERR "fb%d: not enough framebuffer memory (%d kB requested , %d kB available)\n",
 			info->node, mem >> 10, (unsigned int) (info->screen_size >> 10));
 		return -EINVAL;
 	}
 
 	rv = svga_check_timings (&s3_timing_regs, var, info->node);
-	if (rv < 0)
-	{
+	if (rv < 0) {
 		printk(KERN_ERR "fb%d: invalid timings requested\n", info->node);
 		return rv;
 	}
 
+	rv = svga_compute_pll(&s3_pll, PICOS2KHZ(var->pixclock), &m, &n, &r,
+				info->node);
+	if (rv < 0) {
+		printk(KERN_ERR "fb%d: invalid pixclock value requested\n",
+			info->node);
+		return rv;
+	}
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
git-alsa.patch
cyber2000fb-checkpatch-fixes.patch
