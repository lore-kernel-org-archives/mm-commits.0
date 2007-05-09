From: akpm@linux-foundation.org
Subject: - vga16fb-actually-support-widths-in-multiples-of-8.patch removed from -mm tree
Date: Tue, 08 May 2007 20:02:47 -0700
Message-ID: <200705090302.l4932l8k010879@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032804AbXEIDCv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:02:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     vga16fb: actually support widths in multiples of 8
has been removed from the -mm tree.  Its filename was
     vga16fb-actually-support-widths-in-multiples-of-8.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: vga16fb: actually support widths in multiples of 8
From: "Antonino A. Daplas" <adaplas@gmail.com>

vga16fb does not just support 8-pixel wide rectangles, but rectangles with
widths in multiples of 8.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/vga16fb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/vga16fb.c~vga16fb-actually-support-widths-in-multiples-of-8 drivers/video/vga16fb.c
--- a/drivers/video/vga16fb.c~vga16fb-actually-support-widths-in-multiples-of-8
+++ a/drivers/video/vga16fb.c
@@ -1378,8 +1378,8 @@ static int __init vga16fb_probe(struct p
 	info->fbops = &vga16fb_ops;
 	info->var = vga16fb_defined;
 	info->fix = vga16fb_fix;
-	/* supports 8-pixel wide blit rectangles only */
-	info->pixmap.blit_x = 1 << (8 - 1);
+	/* supports rectangles with widths of multiples of 8 */
+	info->pixmap.blit_x = 1 << 7 | 1 << 15 | 1 << 23 | 1 << 31;
 	info->flags = FBINFO_FLAG_DEFAULT |
 		FBINFO_HWACCEL_YPAN;
 
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
