From: akpm@linux-foundation.org
Subject: - imxfb-fix-memory-hole.patch removed from -mm tree
Date: Tue, 29 May 2007 11:51:31 -0700
Message-ID: <200705291851.l4TIpUYl008344@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:39445 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756686AbXE2Sv6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:51:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: s.hauer@pengutronix.de, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     imxfb: fix memory hole
has been removed from the -mm tree.  Its filename was
     imxfb-fix-memory-hole.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: imxfb: fix memory hole
From: Sascha Hauer <s.hauer@pengutronix.de>

info->pseudo_palette was previously kmalloced.  Do not overwrite it afterwards

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/imxfb.c |    1 -
 1 files changed, 1 deletion(-)

diff -puN drivers/video/imxfb.c~imxfb-fix-memory-hole drivers/video/imxfb.c
--- a/drivers/video/imxfb.c~imxfb-fix-memory-hole
+++ a/drivers/video/imxfb.c
@@ -468,7 +468,6 @@ static int __init imxfb_init_fbinfo(stru
 
 	info->fbops			= &imxfb_ops;
 	info->flags			= FBINFO_FLAG_DEFAULT;
-	info->pseudo_palette		= (fbi + 1);
 
 	fbi->rgb[RGB_16]		= &def_rgb_16;
 	fbi->rgb[RGB_8]			= &def_rgb_8;
_

Patches currently in -mm which might be from s.hauer@pengutronix.de are
