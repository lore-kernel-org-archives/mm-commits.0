From: akpm@linux-foundation.org
Subject: + nvidia-fix-sparse-warnings.patch added to -mm tree
Date: Sat, 29 Nov 2008 19:33:27 -0800
Message-ID: <200811300333.mAU3XRWl020781@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60126 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754007AbYK3Ddf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 29 Nov 2008 22:33:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@hanneseder.net, krzysztof.h1@poczta.fm


The patch titled
     nvidia: fix sparse warnings
has been added to the -mm tree.  Its filename is
     nvidia-fix-sparse-warnings.patch

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

linux-next.patch
hugetlb-fix-sparse-warnings.patch
rtc-ds1511-fix-sparse-warning.patch
rtc-stk17ta8-fix-sparse-warning.patch
nvidia-fix-sparse-warnings.patch
viafb-fix-sparse-warnings.patch

