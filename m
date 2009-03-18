From: akpm@linux-foundation.org
Subject: + cirrusfb-add-accelerator-constant.patch added to -mm tree
Date: Wed, 18 Mar 2009 16:49:15 -0700
Message-ID: <200903182352.n2INqb5a031610@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49544 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755073AbZCRXxx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Mar 2009 19:53:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     cirrusfb: add accelerator constant
has been added to the -mm tree.  Its filename is
     cirrusfb-add-accelerator-constant.patch

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
Subject: cirrusfb: add accelerator constant
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Add an accelerator constant so almost all Cirrus are recognized as
accelerators by the fbset command.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-add-accelerator-constant drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-add-accelerator-constant
+++ a/drivers/video/cirrusfb.c
@@ -519,6 +519,7 @@ static int cirrusfb_check_var(struct fb_
 	int yres;
 	/* memory size in pixels */
 	unsigned pixels = info->screen_size * 8 / var->bits_per_pixel;
+	struct cirrusfb_info *cinfo = info->par;
 
 	switch (var->bits_per_pixel) {
 	case 1:
@@ -627,6 +628,9 @@ static int cirrusfb_check_var(struct fb_
 	if (cirrusfb_check_pixclock(var, info))
 		return -EINVAL;
 
+	if (!is_laguna(cinfo))
+		var->accel_flags = FB_ACCELF_TEXT;
+
 	return 0;
 }
 
@@ -2029,8 +2033,12 @@ static int __devinit cirrusfb_set_fbinfo
 		    | FBINFO_HWACCEL_FILLRECT
 		    | FBINFO_HWACCEL_IMAGEBLIT
 		    | FBINFO_HWACCEL_COPYAREA;
-	if (noaccel || is_laguna(cinfo))
+	if (noaccel || is_laguna(cinfo)) {
 		info->flags |= FBINFO_HWACCEL_DISABLED;
+		info->fix.accel = FB_ACCEL_NONE;
+	} else
+		info->fix.accel = FB_ACCEL_CIRRUS_ALPINE;
+
 	info->fbops = &cirrusfb_ops;
 
 	if (cinfo->btype == BT_GD5480) {
@@ -2056,7 +2064,6 @@ static int __devinit cirrusfb_set_fbinfo
 
 	/* FIXME: map region at 0xB8000 if available, fill in here */
 	info->fix.mmio_len   = 0;
-	info->fix.accel = FB_ACCEL_NONE;
 
 	fb_alloc_cmap(&info->cmap, 256, 0);
 
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
linux-next.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix3.patch
cirrusfb-fix-laguna-chipset-memory-detection-and-clock-setting.patch
cirrusfb-add-laguna-additional-overflow-register.patch
cirrusfb-add-mmio-registers-for-laguna-chipsets.patch
cirrusfb-do-not-calculate-line-length-twice.patch
cirrusfb-use-5-6-5-rgb-for-16bpp-mode.patch
cirrusfb-various-improvements.patch
cirrusfb-laguna-chipset-8bpp-fix.patch
cirrusfb-check_var-improvements.patch
cirrusfb-various-laguna-fixes.patch
cirrusfb-acceleration-improvements.patch
cirrusfb-add-imageblit-function.patch
cirrusfb-fix-error-paths-in-cirrusfb_xxx_register.patch
cirrusfb-fix-error-paths-in-cirrusfb_xxx_register-fix.patch
cirrusfb-gd5446-fixes.patch
cirrusfb-use-24bpp-instead-of-32bpp.patch
cirrusfb-fix-clock-doubling.patch
cirrusfb-fix-clock-doubling-fix.patch
drivers-video-sgivwfbc-fix-memory-leaks-in-removal-path.patch
tdfxfb-fix-memory-leaks-in-removal-path.patch
tridentfb-fix-memory-leaks-in-removal-path.patch
vfb-fix-memory-leaks-in-removal-path.patch
sstfb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
stifb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
valkyriefb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
68328fb-fix-cmap-memory-leaks.patch
amba-clcd-fix-cmap-memory-leaks.patch
amifb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
asiliantfb-fix-cmap-memory-leaks.patch
asiliantfb-fix-cmap-memory-leaks-fix.patch
remove-cyblafb-driver.patch
cirrusfb-add-accelerator-constant.patch
cirrusfb-set-mclk-in-one-place.patch
nvidiafb-remove-open_lock-mutex.patch
fb-hide-hardware-cursor-in-graphics-mode-mach64.patch
atyfb-speed-up-mach64-cursor.patch

