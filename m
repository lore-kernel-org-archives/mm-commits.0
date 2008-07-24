From: akpm@linux-foundation.org
Subject: - fbdev-width-and-height-are-unsigned.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:32:23 -0700
Message-ID: <200807242332.m6ONWNBD011831@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52376 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756066AbYGXXch (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:32:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: syrjala@sci.fi, adaplas@pol.net, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     fbdev: width and height are unsigned
has been removed from the -mm tree.  Its filename was
     fbdev-width-and-height-are-unsigned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: width and height are unsigned
From: Ville Syrjala <syrjala@sci.fi>

The width and height members of fb_var_screeninfo are __u32.  The code
initializes them to -1 which seems wrong, and 0 seems like an equally good
default value.

Signed-off-by: Ville Syrjala <syrjala@sci.fi>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/fbmon.c~fbdev-width-and-height-are-unsigned drivers/video/fbmon.c
--- a/drivers/video/fbmon.c~fbdev-width-and-height-are-unsigned
+++ a/drivers/video/fbmon.c
@@ -879,7 +879,7 @@ int fb_parse_edid(unsigned char *edid, s
 		if (edid_is_timing_block(block)) {
 			var->xres = var->xres_virtual = H_ACTIVE;
 			var->yres = var->yres_virtual = V_ACTIVE;
-			var->height = var->width = -1;
+			var->height = var->width = 0;
 			var->right_margin = H_SYNC_OFFSET;
 			var->left_margin = (H_ACTIVE + H_BLANKING) -
 				(H_ACTIVE + H_SYNC_OFFSET + H_SYNC_WIDTH);
_

Patches currently in -mm which might be from syrjala@sci.fi are

origin.patch

