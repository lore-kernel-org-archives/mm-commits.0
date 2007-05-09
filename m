From: akpm@linux-foundation.org
Subject: - vfb-us-fb_sys_read-and-fb_sys_write.patch removed from -mm tree
Date: Tue, 08 May 2007 20:01:31 -0700
Message-ID: <200705090301.l4931Vc9010705@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49217 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1033194AbXEIDBe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:01:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     vfb: use fb_sys_read() and fb_sys_write()
has been removed from the -mm tree.  Its filename was
     vfb-us-fb_sys_read-and-fb_sys_write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: vfb: use fb_sys_read() and fb_sys_write()
From: "Antonino A. Daplas" <adaplas@gmail.com>

Since vfb's framebuffer is vmalloc'ed, use the fb_sys_read() and
fb_sys_write().

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig |    1 +
 drivers/video/vfb.c   |    2 ++
 2 files changed, 3 insertions(+)

diff -puN drivers/video/Kconfig~vfb-us-fb_sys_read-and-fb_sys_write drivers/video/Kconfig
--- a/drivers/video/Kconfig~vfb-us-fb_sys_read-and-fb_sys_write
+++ a/drivers/video/Kconfig
@@ -1743,6 +1743,7 @@ config FB_VIRTUAL
 	select FB_SYS_FILLRECT
 	select FB_SYS_COPYAREA
 	select FB_SYS_IMAGEBLIT
+	select FB_SYS_FOPS
 	---help---
 	  This is a `virtual' frame buffer device. It operates on a chunk of
 	  unswappable kernel memory instead of on the memory of a graphics
diff -puN drivers/video/vfb.c~vfb-us-fb_sys_read-and-fb_sys_write drivers/video/vfb.c
--- a/drivers/video/vfb.c~vfb-us-fb_sys_read-and-fb_sys_write
+++ a/drivers/video/vfb.c
@@ -84,6 +84,8 @@ static int vfb_mmap(struct fb_info *info
 		    struct vm_area_struct *vma);
 
 static struct fb_ops vfb_ops = {
+	.fb_read        = fb_sys_read,
+	.fb_write       = fb_sys_write,
 	.fb_check_var	= vfb_check_var,
 	.fb_set_par	= vfb_set_par,
 	.fb_setcolreg	= vfb_setcolreg,
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
