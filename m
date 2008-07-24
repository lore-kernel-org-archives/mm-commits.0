From: akpm@linux-foundation.org
Subject: - atyfb-fix-a-cast.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:32:37 -0700
Message-ID: <200807242332.m6ONWbuj011851@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60850 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756814AbYGXXcp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:32:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: syrjala@sci.fi, adaplas@pol.net, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     atyfb: fix a cast
has been removed from the -mm tree.  Its filename was
     atyfb-fix-a-cast.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atyfb: fix a cast
From: Ville Syrjala <syrjala@sci.fi>

The argument to iounmap() is void __iomem *. Fix the cast.

Signed-off-by: Ville Syrjala <syrjala@sci.fi>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/atyfb_base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/aty/atyfb_base.c~atyfb-fix-a-cast drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~atyfb-fix-a-cast
+++ a/drivers/video/aty/atyfb_base.c
@@ -3335,7 +3335,7 @@ static int __devinit init_from_bios(stru
 		PRINTKE("no BIOS frequency table found, use parameters\n");
 		ret = -ENXIO;
 	}
-	iounmap((void* __iomem )bios_base);
+	iounmap((void __iomem *)bios_base);
 
 	return ret;
 }
_

Patches currently in -mm which might be from syrjala@sci.fi are

origin.patch

