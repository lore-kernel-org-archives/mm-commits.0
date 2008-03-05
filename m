From: akpm@linux-foundation.org
Subject: - sm501fb-set-transpoffset-to-0-in-8bpp-and-16bpp-modes.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:44:33 -0800
Message-ID: <200803050744.m257iX7M021520@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34618 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765027AbYCEHpk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:45:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: syrjala@sci.fi, ben-linux@fluff.org, mm-commits@vger.kernel.org


The patch titled
     sm501fb: set transp.offset to 0 in 8bpp and 16bpp modes
has been removed from the -mm tree.  Its filename was
     sm501fb-set-transpoffset-to-0-in-8bpp-and-16bpp-modes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sm501fb: set transp.offset to 0 in 8bpp and 16bpp modes
From: Ville Syrjala <syrjala@sci.fi>

Even though it may not be strictly necessary transp.offset should probably be
0 when alpha channel is not available.

Signed-off-by: Ville Syrjala <syrjala@sci.fi>
Acked-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sm501fb.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/video/sm501fb.c~sm501fb-set-transpoffset-to-0-in-8bpp-and-16bpp-modes drivers/video/sm501fb.c
--- a/drivers/video/sm501fb.c~sm501fb-set-transpoffset-to-0-in-8bpp-and-16bpp-modes
+++ a/drivers/video/sm501fb.c
@@ -281,6 +281,7 @@ static int sm501fb_check_var(struct fb_v
 		var->blue.length	= var->bits_per_pixel;
 		var->blue.offset	= 0;
 		var->transp.length	= 0;
+		var->transp.offset	= 0;
 
 		break;
 
@@ -294,6 +295,7 @@ static int sm501fb_check_var(struct fb_v
 			var->green.offset	= 5;
 			var->blue.offset	= 0;
 		}
+		var->transp.offset	= 0;
 
 		var->red.length		= 5;
 		var->green.length	= 6;
_

Patches currently in -mm which might be from syrjala@sci.fi are


