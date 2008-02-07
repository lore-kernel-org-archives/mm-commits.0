From: akpm@linux-foundation.org
Subject: - fb-fix-warning-no-return-statement-in-function-returning-non-void.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:31:02 -0800
Message-ID: <200802070030.m170UhfM007416@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60347 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764447AbYBGAoT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, adaplas@pol.net, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     fb: fix warning: no return statement in function returning non-void
has been removed from the -mm tree.  Its filename was
     fb-fix-warning-no-return-statement-in-function-returning-non-void.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fb: fix warning: no return statement in function returning non-void
From: Anton Vorontsov <avorontsov@ru.mvista.com>

Warning is reproducible with selected FB_CFB_REV_PIXELS_IN_BYTE.

  CC      drivers/video/sysfillrect.o
In file included from drivers/video/sysfillrect.c:18:
drivers/video/fb_draw.h: In function `fb_rev_pixels_in_long':
drivers/video/fb_draw.h:94: warning: no return statement in function returning non-void
  CC      drivers/video/syscopyarea.o
In file included from drivers/video/syscopyarea.c:22:
drivers/video/fb_draw.h: In function `fb_rev_pixels_in_long':
drivers/video/fb_draw.h:94: warning: no return statement in function returning non-void

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fb_draw.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/fb_draw.h~fb-fix-warning-no-return-statement-in-function-returning-non-void drivers/video/fb_draw.h
--- a/drivers/video/fb_draw.h~fb-fix-warning-no-return-statement-in-function-returning-non-void
+++ a/drivers/video/fb_draw.h
@@ -91,6 +91,7 @@ static inline unsigned long fb_rev_pixel
 		val = comp(val >> 2, val << 2, REV_PIXELS_MASK2);
 	if (bswapmask & 3)
 		val = comp(val >> 4, val << 4, REV_PIXELS_MASK4);
+	return val;
 }
 
 static inline u32 fb_shifted_pixels_mask_u32(u32 index, u32 bswapmask)
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
