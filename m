From: akpm@linux-foundation.org
Subject: - s3fb-implement-fb_get_caps.patch removed from -mm tree
Date: Tue, 08 May 2007 20:02:11 -0700
Message-ID: <200705090302.l4932BtP010801@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53508 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1033225AbXEIDCO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:02:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     s3fb: implement fb_get_caps
has been removed from the -mm tree.  Its filename was
     s3fb-implement-fb_get_caps.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: s3fb: implement fb_get_caps
From: "Antonino A. Daplas" <adaplas@gmail.com>

Implement fb_get_caps().  This will allow the driver to tell upper layer that
it can only support 256 8x16 bitmaps when in tileblitting mode
(var->bits_per_pixel == 0);

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3fb.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff -puN drivers/video/s3fb.c~s3fb-implement-fb_get_caps drivers/video/s3fb.c
--- a/drivers/video/s3fb.c~s3fb-implement-fb_get_caps
+++ a/drivers/video/s3fb.c
@@ -799,6 +799,23 @@ static int s3fb_pan_display(struct fb_va
 	return 0;
 }
 
+/* Get capabilities of accelerator based on the mode */
+
+static void s3fb_get_caps(struct fb_info *info, struct fb_blit_caps *caps,
+			  struct fb_var_screeninfo *var)
+{
+	if (var->bits_per_pixel == 0) {
+		/* can only support 256 8x16 bitmap */
+		caps->x = 1 << (8 - 1);
+		caps->y = 1 << (16 - 1);
+		caps->len = 256;
+	} else {
+		caps->x = ~(u32)0;
+		caps->y = ~(u32)0;
+		caps->len = ~(u32)0;
+	}
+}
+
 /* ------------------------------------------------------------------------- */
 
 /* Frame buffer operations */
@@ -815,6 +832,7 @@ static struct fb_ops s3fb_ops = {
 	.fb_fillrect	= s3fb_fillrect,
 	.fb_copyarea	= cfb_copyarea,
 	.fb_imageblit	= s3fb_imageblit,
+	.fb_get_caps    = s3fb_get_caps,
 };
 
 /* ------------------------------------------------------------------------- */
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
vt8623fb-new-framebuffer-driver-for-via-vt8623.patch
vt8623fb-fix-compile-warnings.patch
vt8623fb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards.patch
arkfb-fix-compiler-warnings.patch
arkfb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards-fix.patch
svgalib-move-fb_get_caps-to-svgalib.patch
