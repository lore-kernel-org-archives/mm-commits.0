From: akpm@linux-foundation.org
Subject: [merged] cirrusfb-do-not-allow-unsupported-pixel-depth.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:49:14 -0700
Message-ID: <200904141949.n3EJnEhI019523@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45972 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752404AbZDNTub (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 15:50:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     cirrusfb: do not allow unsupported pixel depth
has been removed from the -mm tree.  Its filename was
     cirrusfb-do-not-allow-unsupported-pixel-depth.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

