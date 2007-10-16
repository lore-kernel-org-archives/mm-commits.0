From: akpm@linux-foundation.org
Subject: - pm2fb-accelerated-24-bit-fillrect.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:42:15 -0700
Message-ID: <200710162042.l9GKgFpO015870@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39046 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761059AbXJPVH1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:07:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     pm2fb: accelerated 24-bit fillrect
has been removed from the -mm tree.  Its filename was
     pm2fb-accelerated-24-bit-fillrect.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pm2fb: accelerated 24-bit fillrect
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch adds accelerated fillrect for 24-bit depth.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm2fb.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/video/pm2fb.c~pm2fb-accelerated-24-bit-fillrect drivers/video/pm2fb.c
--- a/drivers/video/pm2fb.c~pm2fb-accelerated-24-bit-fillrect
+++ a/drivers/video/pm2fb.c
@@ -1077,7 +1077,13 @@ static void pm2fb_fillrect (struct fb_in
 		pm2_WR(par, PM2R_RENDER,
 				PM2F_RENDER_RECTANGLE | PM2F_RENDER_FASTFILL);
 	} else {
-		cfb_fillrect(info, region);
+		WAIT_FIFO(par, 4);
+		pm2_WR(par, PM2R_COLOR_DDA_MODE, 1);
+		pm2_WR(par, PM2R_CONSTANT_COLOR, color);
+		wmb();
+		pm2_WR(par, PM2R_RENDER,
+				PM2F_RENDER_RECTANGLE | PM2F_INCREASE_X | PM2F_INCREASE_Y );
+		pm2_WR(par, PM2R_COLOR_DDA_MODE, 0);
 	}
 }
 
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
git-alsa.patch
cyber2000fb-checkpatch-fixes.patch
