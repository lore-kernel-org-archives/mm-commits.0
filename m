From: akpm@linux-foundation.org
Subject: [merged] 68328fb-fix-cmap-memory-leaks.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:43:35 -0700
Message-ID: <200904011843.n31IhZWL010092@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60112 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933674AbZDASqo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:46:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, dilinger@debian.org, krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     68328fb: fix cmap memory leaks
has been removed from the -mm tree.  Its filename was
     68328fb-fix-cmap-memory-leaks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: 68328fb: fix cmap memory leaks
From: Andres Salomon <dilinger@queued.net>


- fix cmap leak in removal path

- fix cmap leak when register_framebuffer fails

- check return value of fb_alloc_cmap

Signed-off-by: Andres Salomon <dilinger@debian.org>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/68328fb.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/video/68328fb.c~68328fb-fix-cmap-memory-leaks drivers/video/68328fb.c
--- a/drivers/video/68328fb.c~68328fb-fix-cmap-memory-leaks
+++ a/drivers/video/68328fb.c
@@ -471,9 +471,11 @@ int __init mc68x328fb_init(void)
 	fb_info.pseudo_palette = &mc68x328fb_pseudo_palette;
 	fb_info.flags = FBINFO_DEFAULT | FBINFO_HWACCEL_YPAN;
 
-	fb_alloc_cmap(&fb_info.cmap, 256, 0);
+	if (fb_alloc_cmap(&fb_info.cmap, 256, 0))
+		return -ENOMEM;
 
 	if (register_framebuffer(&fb_info) < 0) {
+		fb_dealloc_cmap(&fb_info.cmap);
 		return -EINVAL;
 	}
 
@@ -494,6 +496,7 @@ module_init(mc68x328fb_init);
 static void __exit mc68x328fb_cleanup(void)
 {
 	unregister_framebuffer(&fb_info);
+	fb_dealloc_cmap(&fb_info.cmap);
 }
 
 module_exit(mc68x328fb_cleanup);
_

Patches currently in -mm which might be from dilinger@queued.net are

origin.patch
cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support.patch
alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization.patch

