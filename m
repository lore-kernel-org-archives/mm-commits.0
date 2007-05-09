From: akpm@linux-foundation.org
Subject: - hecubafb-kill-sparse-warnings.patch removed from -mm tree
Date: Tue, 08 May 2007 20:01:06 -0700
Message-ID: <200705090301.l493163M010650@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39865 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032775AbXEIDBJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:01:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     hecubafb: kill sparse warnings
has been removed from the -mm tree.  Its filename was
     hecubafb-kill-sparse-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hecubafb: kill sparse warnings
From: "Antonino A. Daplas" <adaplas@gmail.com>

The framebuffer memory is allocated from system RAM (vmalloc'ed).  Add __force
annotations.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/hecubafb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/hecubafb.c~hecubafb-kill-sparse-warnings drivers/video/hecubafb.c
--- a/drivers/video/hecubafb.c~hecubafb-kill-sparse-warnings
+++ a/drivers/video/hecubafb.c
@@ -214,7 +214,7 @@ static void apollo_send_command(struct h
 static void hecubafb_dpy_update(struct hecubafb_par *par)
 {
 	int i;
-	unsigned char *buf = par->info->screen_base;
+	unsigned char *buf = (unsigned char __force *)par->info->screen_base;
 
 	apollo_send_command(par, 0xA0);
 
@@ -303,7 +303,7 @@ static ssize_t hecubafb_write(struct fil
 	if (count) {
 		char *base_addr;
 
-		base_addr = info->screen_base;
+		base_addr = (char __force *)info->screen_base;
 		count -= copy_from_user(base_addr + p, buf, count);
 		*ppos += count;
 		err = -EFAULT;
@@ -409,7 +409,7 @@ static int __devexit hecubafb_remove(str
 	if (info) {
 		fb_deferred_io_cleanup(info);
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
