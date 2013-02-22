From: akpm@linux-foundation.org
Subject: [merged] video-mx3fb-use-null-for-pointer.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:38:52 -0800
Message-ID: <20130222203852.B07225A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:50668 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757125Ab3BVUix (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:38:53 -0500
Received: by mail-qe0-f73.google.com with SMTP id 7so104077qeb.0
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:38:53 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabio.estevam@freescale.com, g.liakhovetski@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/mx3fb.c: use NULL for pointer
has been removed from the -mm tree.  Its filename was
     video-mx3fb-use-null-for-pointer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabio Estevam <fabio.estevam@freescale.com>
Subject: drivers/video/mx3fb.c: use NULL for pointer

Fix the following sparse error:

drivers/video/mx3fb.c:1309:28: warning: Using plain integer as NULL pointer

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/mx3fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/mx3fb.c~video-mx3fb-use-null-for-pointer drivers/video/mx3fb.c
--- a/drivers/video/mx3fb.c~video-mx3fb-use-null-for-pointer
+++ a/drivers/video/mx3fb.c
@@ -1306,7 +1306,7 @@ static int mx3fb_unmap_video_memory(stru
 	dma_free_writecombine(fbi->device, fbi->fix.smem_len,
 			      fbi->screen_base, fbi->fix.smem_start);
 
-	fbi->screen_base = 0;
+	fbi->screen_base = NULL;
 	mutex_lock(&fbi->mm_lock);
 	fbi->fix.smem_start = 0;
 	fbi->fix.smem_len = 0;
_

Patches currently in -mm which might be from fabio.estevam@freescale.com are

origin.patch
linux-next.patch

