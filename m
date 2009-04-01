From: akpm@linux-foundation.org
Subject: [merged] asiliantfb-fix-cmap-memory-leaks.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:43:48 -0700
Message-ID: <200904011843.n31IhmmM010175@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33553 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933489AbZDASqu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:46:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@debian.org, krzysztof.h1@wp.pl, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     asiliantfb: fix cmap memory leaks
has been removed from the -mm tree.  Its filename was
     asiliantfb-fix-cmap-memory-leaks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: asiliantfb: fix cmap memory leaks
From: Andres Salomon <dilinger@debian.org>

 - fix cmap leak in removal path
 - fix cmap leak when register_framebuffer fails
 - check return value of fb_alloc_cmap
 - don't continue with driver setup if register_framebuffer fails

[krzysztof.h1@wp.pl: spotted missing iounmap]
[randy.dunlap@oracle.com: move data declaration before any code]
Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/asiliantfb.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff -puN drivers/video/asiliantfb.c~asiliantfb-fix-cmap-memory-leaks drivers/video/asiliantfb.c
--- a/drivers/video/asiliantfb.c~asiliantfb-fix-cmap-memory-leaks
+++ a/drivers/video/asiliantfb.c
@@ -505,19 +505,27 @@ static struct fb_var_screeninfo asiliant
 	.vsync_len 	= 2,
 };
 
-static void __devinit init_asiliant(struct fb_info *p, unsigned long addr)
+static int __devinit init_asiliant(struct fb_info *p, unsigned long addr)
 {
+	int err;
+
 	p->fix			= asiliantfb_fix;
 	p->fix.smem_start	= addr;
 	p->var			= asiliantfb_var;
 	p->fbops		= &asiliantfb_ops;
 	p->flags		= FBINFO_DEFAULT;
 
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
@@ -532,6 +540,7 @@ asiliantfb_pci_init(struct pci_dev *dp, 
 {
 	unsigned long addr, size;
 	struct fb_info *p;
+	int err;
 
 	if ((dp->resource[0].flags & IORESOURCE_MEM) == 0)
 		return -ENODEV;
@@ -560,7 +569,13 @@ asiliantfb_pci_init(struct pci_dev *dp, 
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
@@ -571,6 +586,7 @@ static void __devexit asiliantfb_remove(
 	struct fb_info *p = pci_get_drvdata(dp);
 
 	unregister_framebuffer(p);
+	fb_dealloc_cmap(&p->cmap);
 	iounmap(p->screen_base);
 	release_mem_region(pci_resource_start(dp, 0), pci_resource_len(dp, 0));
 	pci_set_drvdata(dp, NULL);
_

Patches currently in -mm which might be from dilinger@debian.org are

origin.patch
cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support.patch
cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix.patch
alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization.patch

