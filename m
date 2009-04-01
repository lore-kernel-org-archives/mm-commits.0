From: akpm@linux-foundation.org
Subject: [merged] sm501fb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:43:22 -0700
Message-ID: <200904011843.n31IhMXQ010034@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55031 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761240AbZDASrQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:47:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, ben-linux@fluff.org, dilinger@debian.org, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     sm501fb: check fb_alloc_cmap return value and handle failure properly
has been removed from the -mm tree.  Its filename was
     sm501fb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sm501fb: check fb_alloc_cmap return value and handle failure properly
From: Andres Salomon <dilinger@queued.net>

Signed-off-by: Andres Salomon <dilinger@debian.org>
Acked-by: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sm501fb.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/video/sm501fb.c~sm501fb-check-fb_alloc_cmap-return-value-and-handle-failure-properly drivers/video/sm501fb.c
--- a/drivers/video/sm501fb.c~sm501fb-check-fb_alloc_cmap-return-value-and-handle-failure-properly
+++ a/drivers/video/sm501fb.c
@@ -1525,7 +1525,10 @@ static int sm501fb_init_fb(struct fb_inf
 	}
 
 	/* initialise and set the palette */
-	fb_alloc_cmap(&fb->cmap, NR_PALETTE, 0);
+	if (fb_alloc_cmap(&fb->cmap, NR_PALETTE, 0)) {
+		dev_err(info->dev, "failed to allocate cmap memory\n");
+		return -ENOMEM;
+	}
 	fb_set_cmap(&fb->cmap, fb);
 
 	ret = (fb->fbops->fb_check_var)(&fb->var, fb);
_

Patches currently in -mm which might be from dilinger@queued.net are

origin.patch
cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support.patch
alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization.patch

