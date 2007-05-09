From: akpm@linux-foundation.org
Subject: - hecubafb-use-sys-instead-of-cfb-drawing-functions.patch removed from -mm tree
Date: Tue, 08 May 2007 20:01:19 -0700
Message-ID: <200705090301.l4931JIn010676@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60176 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1033136AbXEIDBV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:01:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     hecubafb: use sys instead of cfb drawing functions
has been removed from the -mm tree.  Its filename was
     hecubafb-use-sys-instead-of-cfb-drawing-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hecubafb: use sys instead of cfb drawing functions
From: "Antonino A. Daplas" <adaplas@gmail.com>

Since hecubafb's framebuffer is vmalloc'ed, use the sys_* drawing functions
instead of cfb_*.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig    |    6 +++---
 drivers/video/hecubafb.c |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/video/Kconfig~hecubafb-use-sys-instead-of-cfb-drawing-functions drivers/video/Kconfig
--- a/drivers/video/Kconfig~hecubafb-use-sys-instead-of-cfb-drawing-functions
+++ a/drivers/video/Kconfig
@@ -602,9 +602,9 @@ config FB_IMAC
 config FB_HECUBA
        tristate "Hecuba board support"
        depends on FB && X86 && MMU
-       select FB_CFB_FILLRECT
-       select FB_CFB_COPYAREA
-       select FB_CFB_IMAGEBLIT
+       select FB_SYS_FILLRECT
+       select FB_SYS_COPYAREA
+       select FB_SYS_IMAGEBLIT
        select FB_DEFERRED_IO
        help
          This enables support for the Hecuba board. This driver was tested
diff -puN drivers/video/hecubafb.c~hecubafb-use-sys-instead-of-cfb-drawing-functions drivers/video/hecubafb.c
--- a/drivers/video/hecubafb.c~hecubafb-use-sys-instead-of-cfb-drawing-functions
+++ a/drivers/video/hecubafb.c
@@ -238,7 +238,7 @@ static void hecubafb_fillrect(struct fb_
 {
 	struct hecubafb_par *par = info->par;
 
-	cfb_fillrect(info, rect);
+	sys_fillrect(info, rect);
 
 	hecubafb_dpy_update(par);
 }
@@ -248,7 +248,7 @@ static void hecubafb_copyarea(struct fb_
 {
 	struct hecubafb_par *par = info->par;
 
-	cfb_copyarea(info, area);
+	sys_copyarea(info, area);
 
 	hecubafb_dpy_update(par);
 }
@@ -258,7 +258,7 @@ static void hecubafb_imageblit(struct fb
 {
 	struct hecubafb_par *par = info->par;
 
-	cfb_imageblit(info, image);
+	sys_imageblit(info, image);
 
 	hecubafb_dpy_update(par);
 }
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
