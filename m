From: akpm@linux-foundation.org
Subject: + amifb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch added to -mm tree
Date: Mon, 09 Feb 2009 15:49:33 -0800
Message-ID: <200902092349.n19NnXaM009400@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49589 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754479AbZBIXuX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2009 18:50:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, dilinger@debian.org, geert@linux-m68k.org, krzysztof.h1@wp.pl


The patch titled
     amifb: check fb_alloc_cmap return value and handle failure properly
has been added to the -mm tree.  Its filename is
     amifb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch

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
Subject: amifb: check fb_alloc_cmap return value and handle failure properly
From: Andres Salomon <dilinger@queued.net>

Signed-off-by: Andres Salomon <dilinger@debian.org>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/amifb.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/video/amifb.c~amifb-check-fb_alloc_cmap-return-value-and-handle-failure-properly drivers/video/amifb.c
--- a/drivers/video/amifb.c~amifb-check-fb_alloc_cmap-return-value-and-handle-failure-properly
+++ a/drivers/video/amifb.c
@@ -2437,7 +2437,9 @@ default_chipset:
 		goto amifb_error;
 	}
 
-	fb_alloc_cmap(&fb_info.cmap, 1<<fb_info.var.bits_per_pixel, 0);
+	err = fb_alloc_cmap(&fb_info.cmap, 1<<fb_info.var.bits_per_pixel, 0);
+	if (err)
+		goto amifb_error;
 
 	if (register_framebuffer(&fb_info) < 0) {
 		err = -EINVAL;
@@ -2456,7 +2458,8 @@ amifb_error:
 
 static void amifb_deinit(void)
 {
-	fb_dealloc_cmap(&fb_info.cmap);
+	if (fb_info.cmap.len)
+		fb_dealloc_cmap(&fb_info.cmap);
 	chipfree();
 	if (videomemory)
 		iounmap((void*)videomemory);
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
amba-clcd-fix-cmap-memory-leaks.patch
amifb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch

