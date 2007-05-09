From: akpm@linux-foundation.org
Subject: - vfb-use-sys-instead-of-cfb-drawing-functions.patch removed from -mm tree
Date: Tue, 08 May 2007 20:01:21 -0700
Message-ID: <200705090301.l4931LcR010681@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33699 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1033194AbXEIDBZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:01:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     vfb: use sys instead of cfb drawing functions
has been removed from the -mm tree.  Its filename was
     vfb-use-sys-instead-of-cfb-drawing-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: vfb: use sys instead of cfb drawing functions
From: "Antonino A. Daplas" <adaplas@gmail.com>

Since vfb's framebuffer is vmalloc'ed, use the sys_* drawing functions
instead of cfb_*.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig |    6 +++---
 drivers/video/vfb.c   |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/video/Kconfig~vfb-use-sys-instead-of-cfb-drawing-functions drivers/video/Kconfig
--- a/drivers/video/Kconfig~vfb-use-sys-instead-of-cfb-drawing-functions
+++ a/drivers/video/Kconfig
@@ -1733,9 +1733,9 @@ config FB_PS3_DEFAULT_SIZE_M
 config FB_VIRTUAL
 	tristate "Virtual Frame Buffer support (ONLY FOR TESTING!)"
 	depends on FB
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
+	select FB_SYS_FILLRECT
+	select FB_SYS_COPYAREA
+	select FB_SYS_IMAGEBLIT
 	---help---
 	  This is a `virtual' frame buffer device. It operates on a chunk of
 	  unswappable kernel memory instead of on the memory of a graphics
diff -puN drivers/video/vfb.c~vfb-use-sys-instead-of-cfb-drawing-functions drivers/video/vfb.c
--- a/drivers/video/vfb.c~vfb-use-sys-instead-of-cfb-drawing-functions
+++ a/drivers/video/vfb.c
@@ -88,9 +88,9 @@ static struct fb_ops vfb_ops = {
 	.fb_set_par	= vfb_set_par,
 	.fb_setcolreg	= vfb_setcolreg,
 	.fb_pan_display	= vfb_pan_display,
-	.fb_fillrect	= cfb_fillrect,
-	.fb_copyarea	= cfb_copyarea,
-	.fb_imageblit	= cfb_imageblit,
+	.fb_fillrect	= sys_fillrect,
+	.fb_copyarea	= sys_copyarea,
+	.fb_imageblit	= sys_imageblit,
 	.fb_mmap	= vfb_mmap,
 };
 
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
