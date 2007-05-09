From: akpm@linux-foundation.org
Subject: - arcfb-kill-sparse-warning.patch removed from -mm tree
Date: Tue, 08 May 2007 20:01:02 -0700
Message-ID: <200705090301.l49312Cq010640@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032933AbXEIDBE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:01:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     arcfb: kill sparse warning
has been removed from the -mm tree.  Its filename was
     arcfb-kill-sparse-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: arcfb: kill sparse warning
From: "Antonino A. Daplas" <adaplas@gmail.com>

The framebuffer memory is allocated from system RAM (vmalloc'ed). Add __force
annotations.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/arcfb.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/video/arcfb.c~arcfb-kill-sparse-warning drivers/video/arcfb.c
--- a/drivers/video/arcfb.c~arcfb-kill-sparse-warning
+++ a/drivers/video/arcfb.c
@@ -262,7 +262,8 @@ static void arcfb_lcd_update_page(struct
 	ks108_set_yaddr(par, chipindex, upper/8);
 
 	linesize = par->info->var.xres/8;
-	src = par->info->screen_base + (left/8) + (upper * linesize);
+	src = (unsigned char __force *) par->info->screen_base + (left/8) +
+		(upper * linesize);
 	ks108_set_xaddr(par, chipindex, left);
 
 	bitmask=1;
@@ -477,7 +478,7 @@ static ssize_t arcfb_write(struct file *
 	if (count) {
 		char *base_addr;
 
-		base_addr = info->screen_base;
+		base_addr = (char __force *)info->screen_base;
 		count -= copy_from_user(base_addr + p, buf, count);
 		*ppos += count;
 		err = -EFAULT;
@@ -603,7 +604,7 @@ static int arcfb_remove(struct platform_
 
 	if (info) {
 		unregister_framebuffer(info);
-		vfree(info->screen_base);
+		vfree((void __force *)info->screen_base);
 		framebuffer_release(info);
 	}
 	return 0;
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
