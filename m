From: akpm@linux-foundation.org
Subject: - sm501fb-rgb-offsets-are-reversed-in-16bpp-modes.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:44:31 -0800
Message-ID: <200803050744.m257iVlF021515@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60075 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765035AbYCEHpm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:45:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: syrjala@sci.fi, ben-linux@fluff.org, mm-commits@vger.kernel.org


The patch titled
     sm501fb: RGB offsets are reversed in 16bpp modes
has been removed from the -mm tree.  Its filename was
     sm501fb-rgb-offsets-are-reversed-in-16bpp-modes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sm501fb: RGB offsets are reversed in 16bpp modes
From: Ville Syrjala <syrjala@sci.fi>

The RGB offsets were reversed in 16bpp modes.  Simply trying to reverse the
offsets when endianness differs is clearly the wrong thing to do but that is
an issue for another patch.

Signed-off-by: Ville Syrjala <syrjala@sci.fi>
Acked-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sm501fb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/video/sm501fb.c~sm501fb-rgb-offsets-are-reversed-in-16bpp-modes drivers/video/sm501fb.c
--- a/drivers/video/sm501fb.c~sm501fb-rgb-offsets-are-reversed-in-16bpp-modes
+++ a/drivers/video/sm501fb.c
@@ -286,13 +286,13 @@ static int sm501fb_check_var(struct fb_v
 
 	case 16:
 		if (sm->pdata->flags & SM501_FBPD_SWAP_FB_ENDIAN) {
-			var->red.offset		= 11;
-			var->green.offset	= 5;
-			var->blue.offset	= 0;
-		} else {
 			var->blue.offset	= 11;
 			var->green.offset	= 5;
 			var->red.offset		= 0;
+		} else {
+			var->red.offset		= 11;
+			var->green.offset	= 5;
+			var->blue.offset	= 0;
 		}
 
 		var->red.length		= 5;
_

Patches currently in -mm which might be from syrjala@sci.fi are


