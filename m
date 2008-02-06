From: akpm@linux-foundation.org
Subject: + fb-fix-warning-no-return-statement-in-function-returning-non-void.patch added to -mm tree
Date: Wed, 06 Feb 2008 01:00:19 -0800
Message-ID: <200802060900.m16900Dm002380@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52181 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759075AbYBFJBO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 04:01:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, adaplas@pol.net, stable@kernel.org


The patch titled
     fb: fix warning: no return statement in function returning non-void
has been added to the -mm tree.  Its filename is
     fb-fix-warning-no-return-statement-in-function-returning-non-void.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
fb-fix-warning-no-return-statement-in-function-returning-non-void.patch
