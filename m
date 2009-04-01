From: akpm@linux-foundation.org
Subject: [merged] drivers-video-sgivwfbc-fix-memory-leaks-in-removal-path.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:43:12 -0700
Message-ID: <200904011843.n31IhCdK009978@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41677 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933637AbZDASqU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:46:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, dilinger@debian.org, krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     drivers/video/sgivwfb.c: fix memory leaks in removal path
has been removed from the -mm tree.  Its filename was
     drivers-video-sgivwfbc-fix-memory-leaks-in-removal-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video/sgivwfb.c: fix memory leaks in removal path
From: Andres Salomon <dilinger@queued.net>

We were leaking both the cmap memory and the info struct memory.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sgivwfb.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/video/sgivwfb.c~drivers-video-sgivwfbc-fix-memory-leaks-in-removal-path drivers/video/sgivwfb.c
--- a/drivers/video/sgivwfb.c~drivers-video-sgivwfbc-fix-memory-leaks-in-removal-path
+++ a/drivers/video/sgivwfb.c
@@ -837,6 +837,8 @@ static int sgivwfb_remove(struct platfor
 		iounmap(par->regs);
 		iounmap(info->screen_base);
 		release_mem_region(DBE_REG_PHYS, DBE_REG_SIZE);
+		fb_dealloc_cmap(&info->cmap);
+		framebuffer_release(info);
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from dilinger@queued.net are

origin.patch
cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support.patch
alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization.patch

