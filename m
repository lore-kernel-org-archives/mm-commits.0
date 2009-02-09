From: akpm@linux-foundation.org
Subject: + 68328fb-fix-cmap-memory-leaks.patch added to -mm tree
Date: Mon, 09 Feb 2009 15:48:31 -0800
Message-ID: <200902092348.n19NmVGl008027@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55231 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750869AbZBIXtI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2009 18:49:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, dilinger@debian.org, krzysztof.h1@wp.pl


The patch titled
     68328fb: fix cmap memory leaks
has been added to the -mm tree.  Its filename is
     68328fb-fix-cmap-memory-leaks.patch

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

gxfb-properly-alloc-cmap-and-plug-cmap-leak.patch
gx1fb-properly-alloc-cmap-and-plug-cmap-leak.patch
jffs2-force-the-jffs2-gc-daemon-to-behave-a-bit-better.patch
drivers-video-sgivwfbc-fix-memory-leaks-in-removal-path.patch
tdfxfb-fix-memory-leaks-in-removal-path.patch
tridentfb-fix-memory-leaks-in-removal-path.patch
vfb-fix-memory-leaks-in-removal-path.patch
skeletonfb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
sm501fb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
sstfb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
stifb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
valkyriefb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
sunxvr500-fix-cmap-memory-leaks.patch
tgafb-fix-cmap-memory-leak.patch
68328fb-fix-cmap-memory-leaks.patch

