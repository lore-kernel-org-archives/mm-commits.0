From: akpm@linux-foundation.org
Subject: - s3fb-implement-fb_get_tilemax.patch removed from -mm tree
Date: Tue, 08 May 2007 20:01:46 -0700
Message-ID: <200705090301.l4931kTg010750@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52752 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032902AbXEIDBt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:01:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     s3fb: implement fb_get_tilemax()
has been removed from the -mm tree.  Its filename was
     s3fb-implement-fb_get_tilemax.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: s3fb: implement fb_get_tilemax()
From: "Antonino A. Daplas" <adaplas@gmail.com>

Implement fb_get_tilemax(). It just returns 256.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3fb.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/video/s3fb.c~s3fb-implement-fb_get_tilemax drivers/video/s3fb.c
--- a/drivers/video/s3fb.c~s3fb-implement-fb_get_tilemax
+++ a/drivers/video/s3fb.c
@@ -183,7 +183,10 @@ static void s3fb_settile_fast(struct fb_
 	}
 }
 
-
+static int s3fb_get_tilemax(struct fb_info *info)
+{
+	return 256;
+}
 
 static struct fb_tile_ops s3fb_tile_ops = {
 	.fb_settile	= svga_settile,
@@ -191,6 +194,7 @@ static struct fb_tile_ops s3fb_tile_ops 
 	.fb_tilefill    = svga_tilefill,
 	.fb_tileblit    = svga_tileblit,
 	.fb_tilecursor  = svga_tilecursor,
+	.fb_get_tilemax = s3fb_get_tilemax,
 };
 
 static struct fb_tile_ops s3fb_fast_tile_ops = {
@@ -199,6 +203,7 @@ static struct fb_tile_ops s3fb_fast_tile
 	.fb_tilefill    = svga_tilefill,
 	.fb_tileblit    = svga_tileblit,
 	.fb_tilecursor  = svga_tilecursor,
+	.fb_get_tilemax = s3fb_get_tilemax,
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
