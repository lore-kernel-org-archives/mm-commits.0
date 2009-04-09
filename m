From: akpm@linux-foundation.org
Subject: + cirrusfb-do-not-allow-unsupported-pixel-depth.patch added to -mm tree
Date: Thu, 09 Apr 2009 14:27:20 -0700
Message-ID: <200904092127.n39LRKvO002471@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933318AbZDIV2h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 17:28:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     cirrusfb: do not allow unsupported pixel depth
has been added to the -mm tree.  Its filename is
     cirrusfb-do-not-allow-unsupported-pixel-depth.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cirrusfb: do not allow unsupported pixel depth
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Do not allow modes with unsupported pixel depth.  Otherwise, one can hang
a computer by setting incorrect value with fbset command.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-do-not-allow-unsupported-pixel-depth drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-do-not-allow-unsupported-pixel-depth
+++ a/drivers/video/cirrusfb.c
@@ -567,9 +567,7 @@ static int cirrusfb_check_var(struct fb_
 	default:
 		dev_dbg(info->device,
 			"Unsupported bpp size: %d\n", var->bits_per_pixel);
-		assert(false);
-		/* should never occur */
-		break;
+		return -EINVAL;
 	}
 
 	if (var->xres_virtual < var->xres)
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

linux-next.patch
sisfb-fix-color-component-length-for-pseudocolor-modes.patch
cirrusfb-do-not-allow-unsupported-pixel-depth.patch

