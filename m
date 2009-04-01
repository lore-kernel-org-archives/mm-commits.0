From: akpm@linux-foundation.org
Subject: [merged] skeletonfb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:43:20 -0700
Message-ID: <200904011843.n31IhKnt010031@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41309 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933663AbZDASqY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:46:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, dilinger@debian.org, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     skeletonfb: check fb_alloc_cmap return value and handle failure properly
has been removed from the -mm tree.  Its filename was
     skeletonfb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: skeletonfb: check fb_alloc_cmap return value and handle failure properly
From: Andres Salomon <dilinger@queued.net>

Bad example code, no cookie!

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/skeletonfb.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN drivers/video/skeletonfb.c~skeletonfb-check-fb_alloc_cmap-return-value-and-handle-failure-properly drivers/video/skeletonfb.c
--- a/drivers/video/skeletonfb.c~skeletonfb-check-fb_alloc_cmap-return-value-and-handle-failure-properly
+++ a/drivers/video/skeletonfb.c
@@ -795,8 +795,9 @@ static int __devinit xxxfb_probe(struct 
     if (!retval || retval == 4)
 	return -EINVAL;			
 
-    /* This has to been done !!! */	
-    fb_alloc_cmap(&info->cmap, cmap_len, 0);
+    /* This has to be done! */
+    if (fb_alloc_cmap(&info->cmap, cmap_len, 0))
+	return -ENOMEM;
 	
     /* 
      * The following is done in the case of having hardware with a static 
@@ -820,8 +821,10 @@ static int __devinit xxxfb_probe(struct 
      */
     /* xxxfb_set_par(info); */
 
-    if (register_framebuffer(info) < 0)
+    if (register_framebuffer(info) < 0) {
+	fb_dealloc_cmap(&info->cmap);
 	return -EINVAL;
+    }
     printk(KERN_INFO "fb%d: %s frame buffer device\n", info->node,
 	   info->fix.id);
     pci_set_drvdata(dev, info); /* or platform_set_drvdata(pdev, info) */
_

Patches currently in -mm which might be from dilinger@queued.net are

origin.patch
cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support.patch
alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization.patch

