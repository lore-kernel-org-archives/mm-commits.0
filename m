From: akpm@linux-foundation.org
Subject: + asiliantfb-fix-cmap-memory-leaks.patch added to -mm tree
Date: Fri, 13 Feb 2009 15:42:55 -0800
Message-ID: <200902132342.n1DNgtDS027256@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49918 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752954AbZBMXnG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Feb 2009 18:43:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@debian.org, krzysztof.h1@wp.pl


The patch titled
     asiliantfb: fix cmap memory leaks
has been added to the -mm tree.  Its filename is
     asiliantfb-fix-cmap-memory-leaks.patch

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
Subject: asiliantfb: fix cmap memory leaks
From: Andres Salomon <dilinger@debian.org>

 - fix cmap leak in removal path
 - fix cmap leak when register_framebuffer fails
 - check return value of fb_alloc_cmap
 - don't continue with driver setup if register_framebuffer fails

[krzysztof.h1@wp.pl: spotted missing iounmap]
Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/asiliantfb.c |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff -puN drivers/video/asiliantfb.c~asiliantfb-fix-cmap-memory-leaks drivers/video/asiliantfb.c
--- a/drivers/video/asiliantfb.c~asiliantfb-fix-cmap-memory-leaks
+++ a/drivers/video/asiliantfb.c
@@ -505,19 +505,26 @@ static struct fb_var_screeninfo asiliant
 	.vsync_len 	= 2,
 };
 
-static void __devinit init_asiliant(struct fb_info *p, unsigned long addr)
+static int __devinit init_asiliant(struct fb_info *p, unsigned long addr)
 {
 	p->fix			= asiliantfb_fix;
 	p->fix.smem_start	= addr;
 	p->var			= asiliantfb_var;
 	p->fbops		= &asiliantfb_ops;
 	p->flags		= FBINFO_DEFAULT;
+	int err;
 
-	fb_alloc_cmap(&p->cmap, 256, 0);
+	err = fb_alloc_cmap(&p->cmap, 256, 0);
+	if (err) {
+		printk(KERN_ERR "C&T 69000 fb failed to alloc cmap memory\n");
+		return err;
+	}
 
-	if (register_framebuffer(p) < 0) {
+	err = register_framebuffer(p);
+	if (err < 0) {
 		printk(KERN_ERR "C&T 69000 framebuffer failed to register\n");
-		return;
+		fb_dealloc_cmap(&p->cmap);
+		return err;
 	}
 
 	printk(KERN_INFO "fb%d: Asiliant 69000 frame buffer (%dK RAM detected)\n",
@@ -532,6 +539,7 @@ asiliantfb_pci_init(struct pci_dev *dp, 
 {
 	unsigned long addr, size;
 	struct fb_info *p;
+	int err;
 
 	if ((dp->resource[0].flags & IORESOURCE_MEM) == 0)
 		return -ENODEV;
@@ -560,7 +568,13 @@ asiliantfb_pci_init(struct pci_dev *dp, 
 	pci_write_config_dword(dp, 4, 0x02800083);
 	writeb(3, p->screen_base + 0x400784);
 
-	init_asiliant(p, addr);
+	err = init_asiliant(p, addr);
+	if (err) {
+		iounmap(p->screen_base);
+		release_mem_region(addr, size);
+		framebuffer_release(p);
+		return err;
+	}
 
 	pci_set_drvdata(dp, p);
 	return 0;
@@ -571,6 +585,7 @@ static void __devexit asiliantfb_remove(
 	struct fb_info *p = pci_get_drvdata(dp);
 
 	unregister_framebuffer(p);
+	fb_dealloc_cmap(&p->cmap);
 	iounmap(p->screen_base);
 	release_mem_region(pci_resource_start(dp, 0), pci_resource_len(dp, 0));
 	pci_set_drvdata(dp, NULL);
_

Patches currently in -mm which might be from dilinger@debian.org are

origin.patch
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
asiliantfb-fix-cmap-memory-leaks.patch

