From: akpm@linux-foundation.org
Subject: - tgafb-remove-a-redundant-non-mono-test-in-mono-imageblit.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:45:55 -0700
Message-ID: <200710162045.l9GKjtGJ016312@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42455 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965540AbXJPU5d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 16:57:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, Jay.Estabrook@hp.com, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     tgafb: remove a redundant non-mono test in mono imageblit
has been removed from the -mm tree.  Its filename was
     tgafb-remove-a-redundant-non-mono-test-in-mono-imageblit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tgafb: remove a redundant non-mono test in mono imageblit
From: "Maciej W. Rozycki" <macro@linux-mips.org>

There is a test in tgafb_mono_imageblit() for a colour image with a fall-back
to cfb_imageblit().  The test is not necessary as the only caller, which is
tgafb_imageblit(), checks it too and only invokes this function for monochrome
images.  It looks like a left-over from before some changes to
tgafb_imageblit().

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Antonino Daplas <adaplas@pol.net>
Cc: Jay Estabrook <Jay.Estabrook@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tgafb.c |    9 ---------
 1 file changed, 9 deletions(-)

diff -puN drivers/video/tgafb.c~tgafb-remove-a-redundant-non-mono-test-in-mono-imageblit drivers/video/tgafb.c
--- a/drivers/video/tgafb.c~tgafb-remove-a-redundant-non-mono-test-in-mono-imageblit
+++ a/drivers/video/tgafb.c
@@ -637,15 +637,6 @@ tgafb_mono_imageblit(struct fb_info *inf
 
 	is8bpp = info->var.bits_per_pixel == 8;
 
-	/* For copies that aren't pixel expansion, there's little we
-	   can do better than the generic code.  */
-	/* ??? There is a DMA write mode; I wonder if that could be
-	   made to pull the data from the image buffer...  */
-	if (image->depth > 1) {
-		cfb_imageblit(info, image);
-		return;
-	}
-
 	dx = image->dx;
 	dy = image->dy;
 	width = image->width;
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
include-linux-typesh-in-if_fddih.patch
avoid-negative-and-full-width-shifts-in-radix-treec.patch
lk201-remove-obsolete-driver.patch
kernel-printkc-concerns-about-the-console-handover.patch
