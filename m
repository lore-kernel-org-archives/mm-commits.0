From: akpm@linux-foundation.org
Subject: + tridentfb-resource-management-fixes-in-probe-function.patch added to -mm tree
Date: Mon, 25 Feb 2008 10:26:05 -0800
Message-ID: <200802251826.m1PIQvAG013027@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46293 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757929AbYBYS1b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Feb 2008 13:27:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@pol.net


The patch titled
     tridentfb: resource management fixes in probe function
has been added to the -mm tree.  Its filename is
     tridentfb-resource-management-fixes-in-probe-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tridentfb: resource management fixes in probe function
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Correct error paths in probe function.

The probe function enables mmio mode so it important to disable the mmio
mode before exiting the probe function.  Otherwise, the console is left in
unusable state (garbled fonts at least, lock up at worst).

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |   61 ++++++++++++++++++++++++++----------
 1 file changed, 45 insertions(+), 16 deletions(-)

diff -puN drivers/video/tridentfb.c~tridentfb-resource-management-fixes-in-probe-function drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-resource-management-fixes-in-probe-function
+++ a/drivers/video/tridentfb.c
@@ -566,17 +566,42 @@ static inline void write3CE(int reg, uns
 
 static inline void enable_mmio(void)
 {
+	unsigned char tmp;
 	/* Goto New Mode */
 	outb(0x0B, 0x3C4);
 	inb(0x3C5);
 
 	/* Unprotect registers */
 	outb(NewMode1, 0x3C4);
+	tmp = inb(0x3C5);
 	outb(0x80, 0x3C5);
 
 	/* Enable MMIO */
 	outb(PCIReg, 0x3D4);
 	outb(inb(0x3D5) | 0x01, 0x3D5);
+
+	t_outb(NewMode1, 0x3C4);
+	t_outb(tmp, 0x3C5);
+}
+
+static inline void disable_mmio(void)
+{
+	unsigned char tmp;
+	/* Goto New Mode */
+	t_outb(0x0B, 0x3C4);
+	t_inb(0x3C5);
+
+	/* Unprotect registers */
+	t_outb(NewMode1, 0x3C4);
+	tmp = t_inb(0x3C5);
+	t_outb(0x80, 0x3C5);
+
+	/* Disable MMIO */
+	t_outb(PCIReg, 0x3D4);
+	t_outb(t_inb(0x3D5) & ~0x01, 0x3D5);
+
+	outb(NewMode1, 0x3C4);
+	outb(tmp, 0x3C5);
 }
 
 #define crtc_unlock()	write3X4(CRTVSyncEnd, read3X4(CRTVSyncEnd) & 0x7F)
@@ -1239,9 +1264,9 @@ static int __devinit trident_pci_probe(s
 	default_par.io_virt = ioremap_nocache(tridentfb_fix.mmio_start, tridentfb_fix.mmio_len);
 
 	if (!default_par.io_virt) {
-		release_region(tridentfb_fix.mmio_start, tridentfb_fix.mmio_len);
 		debug("ioremap failed\n");
-		return -1;
+		err = -1;
+		goto out_unmap1;
 	}
 
 	enable_mmio();
@@ -1252,25 +1277,21 @@ static int __devinit trident_pci_probe(s
 
 	if (!request_mem_region(tridentfb_fix.smem_start, tridentfb_fix.smem_len, "tridentfb")) {
 		debug("request_mem_region failed!\n");
+		disable_mmio();
 		err = -1;
-		goto out_unmap;
+		goto out_unmap1;
 	}
 
 	fb_info.screen_base = ioremap_nocache(tridentfb_fix.smem_start,
 					      tridentfb_fix.smem_len);
 
 	if (!fb_info.screen_base) {
-		release_mem_region(tridentfb_fix.smem_start, tridentfb_fix.smem_len);
 		debug("ioremap failed\n");
 		err = -1;
-		goto out_unmap;
+		goto out_unmap2;
 	}
 
 	output("%s board found\n", pci_name(dev));
-#if 0
-	output("Trident board found : mem = %X, io = %X, mem_v = %X, io_v = %X\n",
-		tridentfb_fix.smem_start, tridentfb_fix.mmio_start, fb_info.screen_base, default_par.io_virt);
-#endif
 	displaytype = get_displaytype();
 
 	if (flatpanel)
@@ -1288,9 +1309,12 @@ static int __devinit trident_pci_probe(s
 
 	if (!fb_find_mode(&default_var, &fb_info, mode, NULL, 0, NULL, bpp)) {
 		err = -EINVAL;
-		goto out_unmap;
+		goto out_unmap2;
 	}
-	fb_alloc_cmap(&fb_info.cmap, 256, 0);
+	err = fb_alloc_cmap(&fb_info.cmap, 256, 0);
+	if (err < 0)
+		goto out_unmap2;
+
 	if (defaultaccel && acc)
 		default_var.accel_flags |= FB_ACCELF_TEXT;
 	else
@@ -1300,19 +1324,24 @@ static int __devinit trident_pci_probe(s
 	fb_info.device = &dev->dev;
 	if (register_framebuffer(&fb_info) < 0) {
 		printk(KERN_ERR "tridentfb: could not register Trident framebuffer\n");
+		fb_dealloc_cmap(&fb_info.cmap);
 		err = -EINVAL;
-		goto out_unmap;
+		goto out_unmap2;
 	}
 	output("fb%d: %s frame buffer device %dx%d-%dbpp\n",
 	   fb_info.node, fb_info.fix.id, default_var.xres,
 	   default_var.yres, default_var.bits_per_pixel);
 	return 0;
 
-out_unmap:
-	if (default_par.io_virt)
-		iounmap(default_par.io_virt);
+out_unmap2:
 	if (fb_info.screen_base)
 		iounmap(fb_info.screen_base);
+	release_mem_region(tridentfb_fix.smem_start, tridentfb_fix.smem_len);
+	disable_mmio();
+out_unmap1:
+	if (default_par.io_virt)
+		iounmap(default_par.io_virt);
+	release_mem_region(tridentfb_fix.mmio_start, tridentfb_fix.mmio_len);
 	return err;
 }
 
@@ -1323,7 +1352,7 @@ static void __devexit trident_pci_remove
 	iounmap(par->io_virt);
 	iounmap(fb_info.screen_base);
 	release_mem_region(tridentfb_fix.smem_start, tridentfb_fix.smem_len);
-	release_region(tridentfb_fix.mmio_start, tridentfb_fix.mmio_len);
+	release_mem_region(tridentfb_fix.mmio_start, tridentfb_fix.mmio_len);
 }
 
 /* List of boards that we are trying to support */
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

tridentfb-resource-management-fixes-in-probe-function.patch
tridentfb-resource-management-fixes-in-probe-function-fix.patch
pm2fb-correct-error-values-returned-from-probe-function.patch
pm2fb-change-option-mode-to-mode_option.patch
tridentfb-change-option-mode-to-mode_option.patch
pm3fb-change-option-mode-to-mode_option.patch
update-modedbtxt-documentation-about-mode_option-parameter-change.patch
vt8623fb-change-option-mode-to-mode_option.patch
arkfb-add-option-mode_option.patch
s3fb-add-option-mode_option.patch
fbdev-add-removed-option-mode-to-keep-compatibility.patch
