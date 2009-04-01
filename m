From: akpm@linux-foundation.org
Subject: [merged] vfb-fix-memory-leaks-in-removal-path.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:43:18 -0700
Message-ID: <200904011843.n31IhIJG009987@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36428 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932479AbZDASqW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:46:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, dilinger@debian.org, krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     vfb: fix memory leaks in removal path
has been removed from the -mm tree.  Its filename was
     vfb-fix-memory-leaks-in-removal-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfb: fix memory leaks in removal path
From: Andres Salomon <dilinger@queued.net>

We were leaking the cmap memory.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/vfb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/vfb.c~vfb-fix-memory-leaks-in-removal-path drivers/video/vfb.c
--- a/drivers/video/vfb.c~vfb-fix-memory-leaks-in-removal-path
+++ a/drivers/video/vfb.c
@@ -543,6 +543,7 @@ static int vfb_remove(struct platform_de
 	if (info) {
 		unregister_framebuffer(info);
 		rvfree(videomemory, videomemorysize);
+		fb_dealloc_cmap(&info->cmap);
 		framebuffer_release(info);
 	}
 	return 0;
_

Patches currently in -mm which might be from dilinger@queued.net are

origin.patch
cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support.patch
alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization.patch

