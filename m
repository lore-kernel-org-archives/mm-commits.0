From: akpm@linux-foundation.org
Subject: - nvidia-fix-sparse-warnings.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:19:46 -0800
Message-ID: <200901072219.n07MJkrd019052@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48631 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932662AbZAGWe0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:34:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@hanneseder.net, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     nvidia: fix sparse warnings
has been removed from the -mm tree.  Its filename was
     nvidia-fix-sparse-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nvidia: fix sparse warnings
From: Hannes Eder <hannes@hanneseder.net>

Fix this sparse warnings:

  drivers/video/nvidia/nv_accel.c:304:3: warning: returning void-valued expression
  drivers/video/nvidia/nv_accel.c:323:3: warning: returning void-valued expression

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/nvidia/nv_accel.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN drivers/video/nvidia/nv_accel.c~nvidia-fix-sparse-warnings drivers/video/nvidia/nv_accel.c
--- a/drivers/video/nvidia/nv_accel.c~nvidia-fix-sparse-warnings
+++ a/drivers/video/nvidia/nv_accel.c
@@ -300,8 +300,10 @@ void nvidiafb_copyarea(struct fb_info *i
 	if (info->state != FBINFO_STATE_RUNNING)
 		return;
 
-	if (par->lockup)
-		return cfb_copyarea(info, region);
+	if (par->lockup) {
+		cfb_copyarea(info, region);
+		return;
+	}
 
 	NVDmaStart(info, par, BLIT_POINT_SRC, 3);
 	NVDmaNext(par, (region->sy << 16) | region->sx);
@@ -319,8 +321,10 @@ void nvidiafb_fillrect(struct fb_info *i
 	if (info->state != FBINFO_STATE_RUNNING)
 		return;
 
-	if (par->lockup)
-		return cfb_fillrect(info, rect);
+	if (par->lockup) {
+		cfb_fillrect(info, rect);
+		return;
+	}
 
 	if (info->var.bits_per_pixel == 8)
 		color = rect->color;
_

Patches currently in -mm which might be from hannes@hanneseder.net are

origin.patch
linux-next.patch

