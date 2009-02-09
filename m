From: akpm@linux-foundation.org
Subject: + amba-clcd-fix-cmap-memory-leaks.patch added to -mm tree
Date: Mon, 09 Feb 2009 15:49:03 -0800
Message-ID: <200902092349.n19Nn3Pk008715@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47008 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755816AbZBIXtk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2009 18:49:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, dilinger@debian.org, krzysztof.h1@wp.pl


The patch titled
     amba-clcd: fix cmap memory leaks
has been added to the -mm tree.  Its filename is
     amba-clcd-fix-cmap-memory-leaks.patch

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
Subject: amba-clcd: fix cmap memory leaks
From: Andres Salomon <dilinger@queued.net>

- fix cmap leak in removal path

- fix cmap leak when register_framebuffer fails

Signed-off-by: Andres Salomon <dilinger@debian.org>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/amba-clcd.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/video/amba-clcd.c~amba-clcd-fix-cmap-memory-leaks drivers/video/amba-clcd.c
--- a/drivers/video/amba-clcd.c~amba-clcd-fix-cmap-memory-leaks
+++ a/drivers/video/amba-clcd.c
@@ -408,7 +408,9 @@ static int clcdfb_register(struct clcd_f
 	/*
 	 * Allocate colourmap.
 	 */
-	fb_alloc_cmap(&fb->fb.cmap, 256, 0);
+	ret = fb_alloc_cmap(&fb->fb.cmap, 256, 0);
+	if (ret)
+		goto unmap;
 
 	/*
 	 * Ensure interrupts are disabled.
@@ -426,6 +428,8 @@ static int clcdfb_register(struct clcd_f
 
 	printk(KERN_ERR "CLCD: cannot register framebuffer (%d)\n", ret);
 
+	fb_dealloc_cmap(&fb->fb.cmap);
+ unmap:
 	iounmap(fb->regs);
  free_clk:
 	clk_put(fb->clk);
@@ -485,6 +489,8 @@ static int clcdfb_remove(struct amba_dev
 
 	clcdfb_disable(fb);
 	unregister_framebuffer(&fb->fb);
+	if (fb->fb.cmap.len)
+		fb_dealloc_cmap(&fb->fb.cmap);
 	iounmap(fb->regs);
 	clk_put(fb->clk);
 
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

