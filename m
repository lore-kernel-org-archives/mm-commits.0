From: akpm@linux-foundation.org
Subject: + skeletonfb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch added to -mm tree
Date: Mon, 09 Feb 2009 15:44:50 -0800
Message-ID: <200902092344.n19Niou6002913@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57339 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752616AbZBIXpd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2009 18:45:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, dilinger@debian.org, krzysztof.h1@poczta.fm


The patch titled
     skeletonfb: check fb_alloc_cmap return value and handle failure properly
has been added to the -mm tree.  Its filename is
     skeletonfb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch

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

gxfb-properly-alloc-cmap-and-plug-cmap-leak.patch
gx1fb-properly-alloc-cmap-and-plug-cmap-leak.patch
jffs2-force-the-jffs2-gc-daemon-to-behave-a-bit-better.patch
drivers-video-sgivwfbc-fix-memory-leaks-in-removal-path.patch
tdfxfb-fix-memory-leaks-in-removal-path.patch
tridentfb-fix-memory-leaks-in-removal-path.patch
vfb-fix-memory-leaks-in-removal-path.patch
skeletonfb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch

