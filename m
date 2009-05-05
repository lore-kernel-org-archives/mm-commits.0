From: akpm@linux-foundation.org
Subject: + igafb-use-framebuffer_alloc-to-allocate-fb_info-struct.patch added to -mm tree
Date: Tue, 05 May 2009 12:53:10 -0700
Message-ID: <200905051953.n45JrAFm023500@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49318 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751438AbZEET4M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2009 15:56:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, davem@davemloft.net, geert@linux-m68k.org


The patch titled
     igafb: use framebuffer_alloc() to allocate fb_info struct
has been added to the -mm tree.  Its filename is
     igafb-use-framebuffer_alloc-to-allocate-fb_info-struct.patch

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
Subject: igafb: use framebuffer_alloc() to allocate fb_info struct
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Use the framebuffer_alloc() function to allocate the fb_info
structure so the structure is correctly initialized after allocation.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/igafb.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/video/igafb.c~igafb-use-framebuffer_alloc-to-allocate-fb_info-struct drivers/video/igafb.c
--- a/drivers/video/igafb.c~igafb-use-framebuffer_alloc-to-allocate-fb_info-struct
+++ a/drivers/video/igafb.c
@@ -395,17 +395,16 @@ int __init igafb_init(void)
 	/* We leak a reference here but as it cannot be unloaded this is
 	   fine. If you write unload code remember to free it in unload */
 	
-	size = sizeof(struct fb_info) + sizeof(struct iga_par) + sizeof(u32)*16;
+	size = sizeof(struct iga_par) + sizeof(u32)*16;
 
-        info = kzalloc(size, GFP_ATOMIC);
+	info = framebuffer_alloc(size, &pdev->dev);
         if (!info) {
                 printk("igafb_init: can't alloc fb_info\n");
 		 pci_dev_put(pdev);
                 return -ENOMEM;
         }
 
-	par = (struct iga_par *) (info + 1);
-	
+	par = info->par;
 
 	if ((addr = pdev->resource[0].start) == 0) {
                 printk("igafb_init: no memory start\n");
@@ -526,7 +525,6 @@ int __init igafb_init(void)
 	info->var = default_var;
 	info->fix = igafb_fix;
 	info->pseudo_palette = (void *)(par + 1);
-	info->device = &pdev->dev;
 
 	if (!iga_init(info, par)) {
 		iounmap((void *)par->io_base);
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

linux-next.patch
fbdev-fix-fillrect-for-24bpp-modes.patch
fbdev-remove-makefile-reference-to-removed-driver.patch
chipsfb-remove-redundant-assignment.patch
igafb-use-framebuffer_alloc-to-allocate-fb_info-struct.patch

