From: akpm@linux-foundation.org
Subject: - arcfb-use-sys-instead-of-cfb-drawing-functions.patch removed from -mm tree
Date: Tue, 08 May 2007 20:01:16 -0700
Message-ID: <200705090301.l4931GpV010671@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36101 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1033133AbXEIDBT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:01:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     arcfb: use sys instead of cfb drawing functions
has been removed from the -mm tree.  Its filename was
     arcfb-use-sys-instead-of-cfb-drawing-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: arcfb: use sys instead of cfb drawing functions
From: "Antonino A. Daplas" <adaplas@gmail.com>

Since arcfb's framebuffer is vmalloc'ed, use the sys_* drawing functions
instead of cfb_*.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig |    6 +++---
 drivers/video/arcfb.c |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/video/Kconfig~arcfb-use-sys-instead-of-cfb-drawing-functions drivers/video/Kconfig
--- a/drivers/video/Kconfig~arcfb-use-sys-instead-of-cfb-drawing-functions
+++ a/drivers/video/Kconfig
@@ -412,9 +412,9 @@ config FB_FM2
 config FB_ARC
 	tristate "Arc Monochrome LCD board support"
 	depends on FB && X86
-	select FB_CFB_FILLRECT
-	select FB_CFB_COPYAREA
-	select FB_CFB_IMAGEBLIT
+	select FB_SYS_FILLRECT
+	select FB_SYS_COPYAREA
+	select FB_SYS_IMAGEBLIT
 	help
 	  This enables support for the Arc Monochrome LCD board. The board
 	  is based on the KS-108 lcd controller and is typically a matrix
diff -puN drivers/video/arcfb.c~arcfb-use-sys-instead-of-cfb-drawing-functions drivers/video/arcfb.c
--- a/drivers/video/arcfb.c~arcfb-use-sys-instead-of-cfb-drawing-functions
+++ a/drivers/video/arcfb.c
@@ -369,7 +369,7 @@ static void arcfb_fillrect(struct fb_inf
 {
 	struct arcfb_par *par = info->par;
 
-	cfb_fillrect(info, rect);
+	sys_fillrect(info, rect);
 
 	/* update the physical lcd */
 	arcfb_lcd_update(par, rect->dx, rect->dy, rect->width, rect->height);
@@ -380,7 +380,7 @@ static void arcfb_copyarea(struct fb_inf
 {
 	struct arcfb_par *par = info->par;
 
-	cfb_copyarea(info, area);
+	sys_copyarea(info, area);
 
 	/* update the physical lcd */
 	arcfb_lcd_update(par, area->dx, area->dy, area->width, area->height);
@@ -390,7 +390,7 @@ static void arcfb_imageblit(struct fb_in
 {
 	struct arcfb_par *par = info->par;
 
-	cfb_imageblit(info, image);
+	sys_imageblit(info, image);
 
 	/* update the physical lcd */
 	arcfb_lcd_update(par, image->dx, image->dy, image->width,
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
