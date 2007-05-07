From: akpm@linux-foundation.org
Subject: + pm2fb-removal-of-pm2fb_par-fields.patch added to -mm tree
Date: Mon, 07 May 2007 15:27:23 -0700
Message-ID: <200705072227.l47MRN28006994@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57925 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966354AbXEGW15 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 18:27:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     pm2fb: removal of pm2fb_par fields
has been added to the -mm tree.  Its filename is
     pm2fb-removal-of-pm2fb_par-fields.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pm2fb: removal of pm2fb_par fields
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch removes two redundant fields in the pm2fb_par structure.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm2fb.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff -puN drivers/video/pm2fb.c~pm2fb-removal-of-pm2fb_par-fields drivers/video/pm2fb.c
--- a/drivers/video/pm2fb.c~pm2fb-removal-of-pm2fb_par-fields
+++ a/drivers/video/pm2fb.c
@@ -81,8 +81,6 @@ static int lowvsync;
 struct pm2fb_par
 {
 	pm2type_t	type;		/* Board type */
-	u32		fb_size;	/* framebuffer memory size */
-	unsigned char	__iomem *v_fb;  /* virtual address of frame buffer */
 	unsigned char	__iomem *v_regs;/* virtual address of p_regs */
 	u32 	   	memclock;	/* memclock */
 	u32		video;		/* video flags before blanking */
@@ -1293,20 +1291,19 @@ static int __devinit pm2fb_probe(struct 
 	/* Now work out how big lfb is going to be. */
 	switch(default_par->mem_config & PM2F_MEM_CONFIG_RAM_MASK) {
 	case PM2F_MEM_BANKS_1:
-		default_par->fb_size=0x200000;
+		pm2fb_fix.smem_len=0x200000;
 		break;
 	case PM2F_MEM_BANKS_2:
-		default_par->fb_size=0x400000;
+		pm2fb_fix.smem_len=0x400000;
 		break;
 	case PM2F_MEM_BANKS_3:
-		default_par->fb_size=0x600000;
+		pm2fb_fix.smem_len=0x600000;
 		break;
 	case PM2F_MEM_BANKS_4:
-		default_par->fb_size=0x800000;
+		pm2fb_fix.smem_len=0x800000;
 		break;
 	}
 	pm2fb_fix.smem_start = pci_resource_start(pdev, 1);
-	pm2fb_fix.smem_len = default_par->fb_size;
 
 	/* Linear frame buffer - request region and map it. */
 	if ( !request_mem_region(pm2fb_fix.smem_start, pm2fb_fix.smem_len,
@@ -1314,9 +1311,9 @@ static int __devinit pm2fb_probe(struct 
 		printk(KERN_WARNING "pm2fb: Can't reserve smem.\n");
 		goto err_exit_mmio;
 	}
-	info->screen_base = default_par->v_fb =
+	info->screen_base =
 		ioremap_nocache(pm2fb_fix.smem_start, pm2fb_fix.smem_len);
-	if ( !default_par->v_fb ) {
+	if ( !info->screen_base ) {
 		printk(KERN_WARNING "pm2fb: Can't ioremap smem area.\n");
 		release_mem_region(pm2fb_fix.smem_start, pm2fb_fix.smem_len);
 		goto err_exit_mmio;
@@ -1344,7 +1341,7 @@ static int __devinit pm2fb_probe(struct 
 		goto err_exit_both;
 
 	printk(KERN_INFO "fb%d: %s frame buffer device, memory = %dK.\n",
-	       info->node, info->fix.id, default_par->fb_size / 1024);
+	       info->node, info->fix.id, pm2fb_fix.smem_len / 1024);
 
 	/*
 	 * Our driver data
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

skeletonfb-various-corrections.patch
pm2fb-3dlabs-permedia-2v-reference-board-added.patch
pm2fb-permedia-2v-memory-clock-setting.patch
pm2fb-pixclock-setting-restriction.patch
pm2fb-reset-transparency-settings.patch
pm2fb-memclock-setting-corrections.patch
pm2fb-accelerated-fillrect-and-copyarea.patch
skeletonfb-more-corrections.patch
pm2fb-removal-of-pm2fb_par-fields.patch
skeletonfb-improvements.patch
pm2fb-fix-of-jumps-in-pm2fb_probe.patch
