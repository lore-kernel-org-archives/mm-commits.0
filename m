From: akpm@linux-foundation.org
Subject: + viafb-clean-up-virtual-memory-handling.patch added to -mm tree
Date: Wed, 19 Aug 2009 11:50:00 -0700
Message-ID: <200908191850.n7JIo0SS025701@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51194 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752738AbZHSSuX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Aug 2009 14:50:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn


The patch titled
     viafb: clean up virtual memory handling
has been added to the -mm tree.  Its filename is
     viafb-clean-up-virtual-memory-handling.patch

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
Subject: viafb: clean up virtual memory handling
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

Clean the handling of ioremapped video memory up.  The following changes
were made:

info->screen_base - viafb_FB_MM
(VRAM offset calculation) was replaced by
info->fix.smem_start - viafbinfo->fix.smem_start
which is essentially the same calculation but done with physical instead
virtual addresses.

*->fbmem_virt
was replaced by
viafbinfo->screen_base
This is true for viafbinfo and viafbinfo1 as the par pointers are equal.

An early initialization of viafbinfo1->fix.smem* was removed as done later
in viafb_setup_fixinfo.

This patch highlights that the only usage of the ioremapped video memory
in the driver is for hardware cursor handling.  Even if it has to hold the
used virtual screen mapped for old-fashioned read/write calls (vs. 
mmap'ed) a lot virtual memory could be saved by only ioremapping on
demand.

Code cleanup, no runtime changes expected.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Joseph Chan <JosephChan@via.com.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/global.c   |    1 -
 drivers/video/via/global.h   |    1 -
 drivers/video/via/viafbdev.c |   27 ++++++++-------------------
 drivers/video/via/viafbdev.h |    1 -
 4 files changed, 8 insertions(+), 22 deletions(-)

diff -puN drivers/video/via/global.c~viafb-clean-up-virtual-memory-handling drivers/video/via/global.c
--- a/drivers/video/via/global.c~viafb-clean-up-virtual-memory-handling
+++ a/drivers/video/via/global.c
@@ -46,7 +46,6 @@ int viafb_hotplug_refresh = 60;
 unsigned int viafb_second_offset;
 int viafb_second_size;
 int viafb_primary_dev = None_Device;
-void __iomem *viafb_FB_MM;
 unsigned int viafb_second_xres = 640;
 unsigned int viafb_second_yres = 480;
 unsigned int viafb_second_virtual_xres;
diff -puN drivers/video/via/global.h~viafb-clean-up-virtual-memory-handling drivers/video/via/global.h
--- a/drivers/video/via/global.h~viafb-clean-up-virtual-memory-handling
+++ a/drivers/video/via/global.h
@@ -77,7 +77,6 @@ extern int viafb_hotplug_Yres;
 extern int viafb_hotplug_bpp;
 extern int viafb_hotplug_refresh;
 extern int viafb_primary_dev;
-extern void __iomem *viafb_FB_MM;
 extern struct fb_cursor viacursor;
 
 extern unsigned int viafb_second_xres;
diff -puN drivers/video/via/viafbdev.c~viafb-clean-up-virtual-memory-handling drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-clean-up-virtual-memory-handling
+++ a/drivers/video/via/viafbdev.c
@@ -832,8 +832,7 @@ static void viafb_fillrect(struct fb_inf
 	/* Source Base Address */
 	writel(0x0, viaparinfo->io_virt + VIA_REG_SRCBASE);
 	/* Destination Base Address */
-	writel(((unsigned long) (info->screen_base) -
-		   (unsigned long) viafb_FB_MM) >> 3,
+	writel((info->fix.smem_start - viafbinfo->fix.smem_start) >> 3,
 		   viaparinfo->io_virt + VIA_REG_DSTBASE);
 	/* Pitch */
 	pitch = (info->var.xres_virtual + 7) & ~7;
@@ -887,12 +886,10 @@ static void viafb_copyarea(struct fb_inf
 	}
 
 	/* Source Base Address */
-	writel(((unsigned long) (info->screen_base) -
-		   (unsigned long) viafb_FB_MM) >> 3,
+	writel((info->fix.smem_start - viafbinfo->fix.smem_start) >> 3,
 		   viaparinfo->io_virt + VIA_REG_SRCBASE);
 	/* Destination Base Address */
-	writel(((unsigned long) (info->screen_base) -
-		   (unsigned long) viafb_FB_MM) >> 3,
+	writel((info->fix.smem_start - viafbinfo->fix.smem_start) >> 3,
 		   viaparinfo->io_virt + VIA_REG_DSTBASE);
 	/* Pitch */
 	pitch = (info->var.xres_virtual + 7) & ~7;
@@ -951,8 +948,7 @@ static void viafb_imageblit(struct fb_in
 	/* Source Base Address */
 	writel(0x0, viaparinfo->io_virt + VIA_REG_SRCBASE);
 	/* Destination Base Address */
-	writel(((unsigned long) (info->screen_base) -
-		   (unsigned long) viafb_FB_MM) >> 3,
+	writel((info->fix.smem_start - viafbinfo->fix.smem_start) >> 3,
 		   viaparinfo->io_virt + VIA_REG_DSTBASE);
 	/* Pitch */
 	pitch = (info->var.xres_virtual + 7) & ~7;
@@ -1170,7 +1166,7 @@ static int viafb_cursor(struct fb_info *
 			}
 		}
 
-		memcpy(((struct viafb_par *)(info->par))->fbmem_virt +
+		memcpy(viafbinfo->screen_base +
 		       ((struct viafb_par *)(info->par))->cursor_start,
 		       cr_data->bak, CURSOR_SIZE);
 out:
@@ -2073,11 +2069,9 @@ static int __devinit via_pci_probe(void)
 	viafb_get_fb_info(&viaparinfo->fbmem, &viaparinfo->memsize);
 	viaparinfo->fbmem_free = viaparinfo->memsize;
 	viaparinfo->fbmem_used = 0;
-	viaparinfo->fbmem_virt = ioremap_nocache(viaparinfo->fbmem,
+	viafbinfo->screen_base = ioremap_nocache(viaparinfo->fbmem,
 		viaparinfo->memsize);
-	viafbinfo->screen_base = (char *)viaparinfo->fbmem_virt;
-
-	if (!viaparinfo->fbmem_virt) {
+	if (!viafbinfo->screen_base) {
 		printk(KERN_INFO "ioremap failed\n");
 		return -ENOMEM;
 	}
@@ -2110,7 +2104,6 @@ static int __devinit via_pci_probe(void)
 			viafb_second_size * 1024 * 1024;
 	}
 
-	viafb_FB_MM = viaparinfo->fbmem_virt;
 	tmpm = viafb_mode;
 	tmpc = strsep(&tmpm, "x");
 	strict_strtoul(tmpc, 0, &default_xres);
@@ -2203,8 +2196,6 @@ static int __devinit via_pci_probe(void)
 		viaparinfo1->memsize = viaparinfo->memsize -
 			viafb_second_offset;
 		viaparinfo->memsize = viafb_second_offset;
-		viaparinfo1->fbmem_virt = viaparinfo->fbmem_virt +
-			viafb_second_offset;
 		viaparinfo1->fbmem = viaparinfo->fbmem + viafb_second_offset;
 
 		viaparinfo1->fbmem_used = viaparinfo->fbmem_used;
@@ -2226,8 +2217,6 @@ static int __devinit via_pci_probe(void)
 		memcpy(viafbinfo1, viafbinfo, sizeof(struct fb_info));
 		viafbinfo1->screen_base = viafbinfo->screen_base +
 			viafb_second_offset;
-		viafbinfo1->fix.smem_start = viaparinfo1->fbmem;
-		viafbinfo1->fix.smem_len = viaparinfo1->fbmem_free;
 
 		default_var.xres = viafb_second_xres;
 		default_var.yres = viafb_second_yres;
@@ -2289,7 +2278,7 @@ static void __devexit via_pci_remove(voi
 	unregister_framebuffer(viafbinfo);
 	if (viafb_dual_fb)
 		unregister_framebuffer(viafbinfo1);
-	iounmap((void *)viaparinfo->fbmem_virt);
+	iounmap((void *)viafbinfo->screen_base);
 	iounmap(viaparinfo->io_virt);
 
 	viafb_delete_i2c_buss(viaparinfo);
diff -puN drivers/video/via/viafbdev.h~viafb-clean-up-virtual-memory-handling drivers/video/via/viafbdev.h
--- a/drivers/video/via/viafbdev.h~viafb-clean-up-virtual-memory-handling
+++ a/drivers/video/via/viafbdev.h
@@ -38,7 +38,6 @@
 #define VERSION_MINOR       4
 
 struct viafb_par {
-	void __iomem *fbmem_virt;	/*framebuffer virtual memory address */
 	void __iomem *io_virt;	/*iospace virtual memory address */
 	unsigned int fbmem;	/*framebuffer physical memory address */
 	unsigned int memsize;	/*size of fbmem */
_

Patches currently in -mm which might be from FlorianSchandinat@gmx.de are

viafb-remove-duplicated-cx700-register-init.patch
viafb-remove-temporary-start-address-setting.patch
viafb-merge-viafb_update_viafb_par-in-viafb_update_fix.patch
viafb-split-viafb_set_start_addr-up.patch
viafb-fix-ioremap_nocache-error-handling.patch
viafb-clean-up-viamodeh.patch
viafb-remove-duplicated-mode-information.patch
viafb-clean-up-duoview.patch
viafb-clean-up-virtual-memory-handling.patch
fb-fix-fb_pan_display-range-check.patch

