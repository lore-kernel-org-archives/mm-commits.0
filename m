From: akpm@linux-foundation.org
Subject: - gbefb-unsigned-var-pixclock-cannot-be-less-than-0.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:19:44 -0800
Message-ID: <200901072219.n07MJirE019049@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50478 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932289AbZAGWhf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:37:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, krzysztof.h1@poczta.fm, tsbogend@alpha.franken.de, mm-commits@vger.kernel.org


The patch titled
     gbefb: unsigned var->pixclock cannot be less than 0
has been removed from the -mm tree.  Its filename was
     gbefb-unsigned-var-pixclock-cannot-be-less-than-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gbefb: unsigned var->pixclock cannot be less than 0
From: roel kluin <roel.kluin@gmail.com>

unsigned var->pixclock cannot be less than 0

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/gbefb.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/video/gbefb.c~gbefb-unsigned-var-pixclock-cannot-be-less-than-0 drivers/video/gbefb.c
--- a/drivers/video/gbefb.c~gbefb-unsigned-var-pixclock-cannot-be-less-than-0
+++ a/drivers/video/gbefb.c
@@ -912,6 +912,7 @@ static int gbefb_check_var(struct fb_var
 {
 	unsigned int line_length;
 	struct gbe_timing_info timing;
+	int ret;
 
 	/* Limit bpp to 8, 16, and 32 */
 	if (var->bits_per_pixel <= 8)
@@ -930,8 +931,10 @@ static int gbefb_check_var(struct fb_var
 
 	var->grayscale = 0;	/* No grayscale for now */
 
-	if ((var->pixclock = compute_gbe_timing(var, &timing)) < 0)
-		return(-EINVAL);
+	ret = compute_gbe_timing(var, &timing);
+	var->pixclock = ret;
+	if (ret < 0)
+		return -EINVAL;
 
 	/* Adjust virtual resolution, if necessary */
 	if (var->xres > var->xres_virtual || (!ywrap && !ypan))
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
ufs-sector_t-cannot-be-negative.patch
romfs-romfs_iget-unsigned-ino-=-0-is-always-true.patch
romfs-romfs_iget-unsigned-ino-=-0-is-always-true-checkpatch-fixes.patch
make-various-things-static.patch

