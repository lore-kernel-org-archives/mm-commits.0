From: akpm@linux-foundation.org
Subject: [merged] cirrusfb-add-accelerator-constant.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:42:57 -0700
Message-ID: <200904011842.n31Igv2r009866@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60301 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933883AbZDATB7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:01:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     cirrusfb: add accelerator constant
has been removed from the -mm tree.  Its filename was
     cirrusfb-add-accelerator-constant.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 include/linux/fb.h       |    1 +
 2 files changed, 10 insertions(+), 2 deletions(-)

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
 
diff -puN include/linux/fb.h~cirrusfb-add-accelerator-constant include/linux/fb.h
--- a/include/linux/fb.h~cirrusfb-add-accelerator-constant
+++ a/include/linux/fb.h
@@ -123,6 +123,7 @@ struct dentry;
 #define FB_ACCEL_TRIDENT_3DIMAGE 51	/* Trident 3DImage		*/
 #define FB_ACCEL_TRIDENT_BLADE3D 52	/* Trident Blade3D		*/
 #define FB_ACCEL_TRIDENT_BLADEXP 53	/* Trident BladeXP		*/
+#define FB_ACCEL_CIRRUS_ALPINE   53	/* Cirrus Logic 543x/544x/5480	*/
 #define FB_ACCEL_NEOMAGIC_NM2070 90	/* NeoMagic NM2070              */
 #define FB_ACCEL_NEOMAGIC_NM2090 91	/* NeoMagic NM2090              */
 #define FB_ACCEL_NEOMAGIC_NM2093 92	/* NeoMagic NM2093              */
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
linux-next.patch
tdfxfb-move-i2c-functionality-into-the-tdfxfb.patch
tdfxfb-make-use-of-ddc-information-about-connected-monitor.patch

