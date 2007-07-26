From: akpm@linux-foundation.org
Subject: + pm3fb-3-small-fixes.patch added to -mm tree
Date: Thu, 26 Jul 2007 12:00:29 -0700
Message-ID: <200707261900.l6QJ0TCX015628@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41810 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936256AbXGZTBI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 15:01:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     pm3fb: 3 small fixes
has been added to the -mm tree.  Its filename is
     pm3fb-3-small-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pm3fb: 3 small fixes
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch contains 3 small improvements:
- it corrects scan line width calculation in pm3fb_imageblit()
- it corrects mmio mapping for big endian machines
- it enables panning acceleration constants

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm3fb.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN drivers/video/pm3fb.c~pm3fb-3-small-fixes drivers/video/pm3fb.c
--- a/drivers/video/pm3fb.c~pm3fb-3-small-fixes
+++ a/drivers/video/pm3fb.c
@@ -558,7 +558,8 @@ static void pm3fb_imageblit(struct fb_in
 
 
 	while (height--) {
-		int width = ((image->width + 7) >> 3) + info->pixmap.scan_align;
+		int width = ((image->width + 7) >> 3)
+				+ info->pixmap.scan_align - 1;
 		width >>= 2;
 
 		while (width >= PM3_FIFO_SIZE) {
@@ -1194,6 +1195,10 @@ static int __devinit pm3fb_probe(struct 
 	 */
 	pm3fb_fix.mmio_start = pci_resource_start(dev, 0);
 	pm3fb_fix.mmio_len = PM3_REGS_SIZE;
+#if defined(__BIG_ENDIAN)
+	pm3fb_fix.mmio_start += PM3_REGS_SIZE;
+	DPRINTK("Adjusting register base for big-endian.\n");
+#endif
 
 	/* Registers - request region and map it. */
 	if (!request_mem_region(pm3fb_fix.mmio_start, pm3fb_fix.mmio_len,
@@ -1210,10 +1215,6 @@ static int __devinit pm3fb_probe(struct 
 		goto err_exit_neither;
 	}
 
-#if defined(__BIG_ENDIAN)
-	pm3fb_fix.mmio_start += PM3_REGS_SIZE;
-	DPRINTK("Adjusting register base for big-endian.\n");
-#endif
 	/* Linear frame buffer - request region and map it. */
 	pm3fb_fix.smem_start = pci_resource_start(dev, 1);
 	pm3fb_fix.smem_len = pm3fb_size_memory(par);
@@ -1243,7 +1244,8 @@ static int __devinit pm3fb_probe(struct 
 	info->fix = pm3fb_fix;
 	info->pseudo_palette = par->palette;
 	info->flags = FBINFO_DEFAULT |
-/*			FBINFO_HWACCEL_YPAN |*/
+			FBINFO_HWACCEL_XPAN |
+			FBINFO_HWACCEL_YPAN |
 			FBINFO_HWACCEL_COPYAREA |
 			FBINFO_HWACCEL_IMAGEBLIT |
 			FBINFO_HWACCEL_FILLRECT;
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

git-hwmon.patch
pm3fb-copyarea-and-partial-imageblit-suppor.patch
skeletonfb-wrong-field-name-fix.patch
pm3fb-header-file-reduction.patch
pm3fb-imageblit-improved.patch
pm3fb-3-small-fixes.patch
pm3fb-improvements-and-cleanups.patch
pm3fb-mtrr-support-and-noaccel-option.patch
pm2fb-mtrr-support-and-noaccel-option.patch
pm2fb-accelerated-imageblit.patch
pm2fb-source-code-improvements.patch
pm2fb-permedia-2v-initialization-fixes.patch
pm2fb-accelerated-24-bit-fillrect.patch
tdfxfb-coding-style-improvement.patch
tridentfb-coding-style-improvement.patch
tdfxfb-3-fixes.patch
tdfxfb-palette-fixes.patch
