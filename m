From: akpm@linux-foundation.org
Subject: [merged] stifb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:43:27 -0700
Message-ID: <200904011843.n31IhRjG010040@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36258 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754137AbZDATaV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:30:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, dilinger@debian.org, krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     stifb: check fb_alloc_cmap return value and handle failure properly
has been removed from the -mm tree.  Its filename was
     stifb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: stifb: check fb_alloc_cmap return value and handle failure properly
From: Andres Salomon <dilinger@queued.net>

Signed-off-by: Andres Salomon <dilinger@debian.org>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/stifb.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff -puN drivers/video/stifb.c~stifb-check-fb_alloc_cmap-return-value-and-handle-failure-properly drivers/video/stifb.c
--- a/drivers/video/stifb.c~stifb-check-fb_alloc_cmap-return-value-and-handle-failure-properly
+++ a/drivers/video/stifb.c
@@ -1262,24 +1262,25 @@ static int __init stifb_init_fb(struct s
 	info->flags = FBINFO_DEFAULT;
 	info->pseudo_palette = &fb->pseudo_palette;
 
-	/* This has to been done !!! */
-	fb_alloc_cmap(&info->cmap, NR_PALETTE, 0);
+	/* This has to be done !!! */
+	if (fb_alloc_cmap(&info->cmap, NR_PALETTE, 0))
+		goto out_err1;
 	stifb_init_display(fb);
 
 	if (!request_mem_region(fix->smem_start, fix->smem_len, "stifb fb")) {
 		printk(KERN_ERR "stifb: cannot reserve fb region 0x%04lx-0x%04lx\n",
 				fix->smem_start, fix->smem_start+fix->smem_len);
-		goto out_err1;
+		goto out_err2;
 	}
 		
 	if (!request_mem_region(fix->mmio_start, fix->mmio_len, "stifb mmio")) {
 		printk(KERN_ERR "stifb: cannot reserve sti mmio region 0x%04lx-0x%04lx\n",
 				fix->mmio_start, fix->mmio_start+fix->mmio_len);
-		goto out_err2;
+		goto out_err3;
 	}
 
 	if (register_framebuffer(&fb->info) < 0)
-		goto out_err3;
+		goto out_err4;
 
 	sti->info = info; /* save for unregister_framebuffer() */
 
@@ -1297,13 +1298,14 @@ static int __init stifb_init_fb(struct s
 	return 0;
 
 
-out_err3:
+out_err4:
 	release_mem_region(fix->mmio_start, fix->mmio_len);
-out_err2:
+out_err3:
 	release_mem_region(fix->smem_start, fix->smem_len);
+out_err2:
+	fb_dealloc_cmap(&info->cmap);
 out_err1:
 	iounmap(info->screen_base);
-	fb_dealloc_cmap(&info->cmap);
 out_err0:
 	kfree(fb);
 	return -ENXIO;
_

Patches currently in -mm which might be from dilinger@queued.net are

origin.patch
cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support.patch
alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization.patch

