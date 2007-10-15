From: akpm@linux-foundation.org
Subject: + s3fb-do-not-allow-incorrect-pixclock-settings.patch added to -mm tree
Date: Mon, 15 Oct 2007 15:38:00 -0700
Message-ID: <200710152238.l9FMc0mn028805@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46629 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753046AbXJOWiH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 18:38:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     s3fb: do not allow incorrect pixclock settings
has been added to the -mm tree.  Its filename is
     s3fb-do-not-allow-incorrect-pixclock-settings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
git-arm.patch
pm3fb-copyarea-and-partial-imageblit-suppor.patch
skeletonfb-wrong-field-name-fix.patch
pm3fb-header-file-reduction.patch
pm3fb-imageblit-improved.patch
pm3fb-3-small-fixes.patch
pm3fb-improvements-and-cleanups.patch
pm3fb-mtrr-support-and-noaccel-option.patch
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
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
s3c2410fb-byte-ordering-fixes.patch
fbdev-change-asm-uaccessh-to-linux-uaccessh.patch
s3c2410fb-source-code-improvements.patch
s3c2410fb-adds-pixclock-to-s3c2410fb_display.patch
s3c2410fb-removes-lcdcon1-register-value-from-s3c2410fb_display.patch
s3c2410fb-make-use-of-default_display-settings.patch
cirrusfb-checkpatchpl-cleanup.patch
cirrusfb-checkpatchpl-cleanup-ppc-fix.patch
cirrusfb-remove-typedefs.patch
cirrusfb-remove-fields-from-cirrusfb_info.patch
cirrusfb-code-improvements.patch
cirrusfb-code-improvement-2nd-part.patch
pm3fb-header-file-cleanup.patch
pm2fb-hardware-cursor-support-for-the-permedia2.patch
pm2fb-panning-and-hardware-cursor-fixes.patch
tdfxfb-replace-busy-waiting-with-cpu_relax.patch
pm2fb-replace-busy-waiting-with-cpu_relax.patch
pm3fb-replace-busy-waiting-with-cpu_relax.patch
tdfxfb-checkpatch-fixes.patch
s3fb-do-not-allow-incorrect-pixclock-settings.patch
cyber2000fb-checkpatch-fixes.patch
