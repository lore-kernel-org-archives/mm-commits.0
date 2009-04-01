From: akpm@linux-foundation.org
Subject: [merged] amba-clcd-fix-cmap-memory-leaks.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:43:37 -0700
Message-ID: <200904011843.n31IhbVN010095@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49335 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933676AbZDASqo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:46:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, dilinger@debian.org, krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     amba-clcd: fix cmap memory leaks
has been removed from the -mm tree.  Its filename was
     amba-clcd-fix-cmap-memory-leaks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support.patch
alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization.patch

