From: akpm@linux-foundation.org
Subject: [merged] sstfb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:43:25 -0700
Message-ID: <200904011843.n31IhPF1010037@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59901 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760229AbZDATZw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:25:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, dilinger@debian.org, krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     sstfb: check fb_alloc_cmap return value and handle failure properly
has been removed from the -mm tree.  Its filename was
     sstfb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sstfb: check fb_alloc_cmap return value and handle failure properly
From: Andres Salomon <dilinger@queued.net>

Signed-off-by: Andres Salomon <dilinger@debian.org>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sstfb.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN drivers/video/sstfb.c~sstfb-check-fb_alloc_cmap-return-value-and-handle-failure-properly drivers/video/sstfb.c
--- a/drivers/video/sstfb.c~sstfb-check-fb_alloc_cmap-return-value-and-handle-failure-properly
+++ a/drivers/video/sstfb.c
@@ -1421,13 +1421,16 @@ static int __devinit sstfb_probe(struct 
 		goto fail;
 	}
 	
-	fb_alloc_cmap(&info->cmap, 256, 0);
+	if (fb_alloc_cmap(&info->cmap, 256, 0)) {
+		printk(KERN_ERR "sstfb: can't alloc cmap memory.\n");
+		goto fail;
+	}
 
 	/* register fb */
 	info->device = &pdev->dev;
 	if (register_framebuffer(info) < 0) {
 		printk(KERN_ERR "sstfb: can't register framebuffer.\n");
-		goto fail;
+		goto fail_register;
 	}
 
 	sstfb_clear_screen(info);
@@ -1441,8 +1444,9 @@ static int __devinit sstfb_probe(struct 
 
 	return 0;
 
-fail:
+fail_register:
 	fb_dealloc_cmap(&info->cmap);
+fail:
 	iounmap(info->screen_base);
 fail_fb_remap:
 	iounmap(par->mmio_vbase);
_

Patches currently in -mm which might be from dilinger@queued.net are

origin.patch
cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support.patch
alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization.patch

