From: akpm@linux-foundation.org
Subject: + dma-rename-dma__writecombine-to-dma__wc.patch added to -mm tree
Date: Tue, 26 Jan 2016 15:03:42 -0800
Message-ID: <56a7fb4e.bFsXNhctOwSTMj7o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34025 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbcAZXDn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 18:03:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mcgrof@suse.com, airlied@linux.ie, benh@kernel.crashing.org, bhelgaas@google.com, bp@suse.de, dan.j.williams@intel.com, daniel.vetter@ffwll.ch, dhowells@redhat.com, julia.lawall@lip6.fr, konrad.wilk@oracle.com, luto@amacapital.net, mingo@kernel.org, mst@redhat.com, tomi.valkeinen@ti.com, toshi.kani@hp.com, vinod.koul@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-mapping: rename dma_*_writecombine() to dma_*_wc()
has been added to the -mm tree.  Its filename is
     dma-rename-dma__writecombine-to-dma__wc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dma-rename-dma__writecombine-to-dma__wc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dma-rename-dma__writecombine-to-dma__wc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: dma-mapping: rename dma_*_writecombine() to dma_*_wc()

Rename dma_*_writecombine() to dma_*_wc(), so that the naming is coherent
across the various write-combining APIs.  Keep the old names for
compatibility for a while, these can be removed at a later time.  A guard
is left to enable backporting of the rename, and later remove of the old
mapping defines seemlessly.

Build tested successfully with allmodconfig.

The following Coccinelle SmPL patch was used for this simple
transformation:

@ rename_dma_alloc_writecombine @
expression dev, size, dma_addr, gfp;
@@

-dma_alloc_writecombine(dev, size, dma_addr, gfp)
+dma_alloc_wc(dev, size, dma_addr, gfp)

@ rename_dma_free_writecombine @
expression dev, size, cpu_addr, dma_addr;
@@

-dma_free_writecombine(dev, size, cpu_addr, dma_addr)
+dma_free_wc(dev, size, cpu_addr, dma_addr)

@ rename_dma_mmap_writecombine @
expression dev, vma, cpu_addr, dma_addr, size;
@@

-dma_mmap_writecombine(dev, vma, cpu_addr, dma_addr, size)
+dma_mmap_wc(dev, vma, cpu_addr, dma_addr, size)

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
Suggested-by: Ingo Molnar <mingo@kernel.org>
Cc: Boris Petkov <bp@suse.de>
Cc: Julia Lawall <julia.lawall@lip6.fr>
Cc: David Howells <dhowells@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-lpc32xx/phy3250.c           |   13 ++++------
 arch/arm/mach-netx/fb.c                   |   14 ++++-------
 arch/arm/mach-nspire/clcd.c               |   13 ++++------
 drivers/dma/iop-adma.c                    |    8 +++---
 drivers/dma/mv_xor.c                      |    4 +--
 drivers/dma/qcom_bam_dma.c                |   14 +++++------
 drivers/gpu/drm/drm_gem_cma_helper.c      |   13 ++++------
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c     |    8 +++---
 drivers/gpu/drm/omapdrm/omap_dmm_tiler.c  |   13 ++++------
 drivers/gpu/drm/omapdrm/omap_gem.c        |    8 +++---
 drivers/gpu/drm/sti/sti_cursor.c          |   20 +++++++---------
 drivers/gpu/drm/sti/sti_gdp.c             |    3 --
 drivers/gpu/drm/sti/sti_hqvdp.c           |    6 ++--
 drivers/gpu/drm/tegra/gem.c               |   11 ++++----
 drivers/gpu/drm/vc4/vc4_bo.c              |    5 +---
 drivers/gpu/host1x/cdma.c                 |    8 +++---
 drivers/gpu/host1x/job.c                  |   10 +++-----
 drivers/media/platform/coda/coda-bit.c    |   10 ++++----
 drivers/video/fbdev/acornfb.c             |    4 +--
 drivers/video/fbdev/amba-clcd-versatile.c |   14 ++++-------
 drivers/video/fbdev/amba-clcd.c           |    4 +--
 drivers/video/fbdev/atmel_lcdfb.c         |    9 ++++---
 drivers/video/fbdev/ep93xx-fb.c           |    8 ++----
 drivers/video/fbdev/gbefb.c               |    8 +++---
 drivers/video/fbdev/imxfb.c               |   12 ++++-----
 drivers/video/fbdev/mx3fb.c               |    9 +++----
 drivers/video/fbdev/nuc900fb.c            |    8 +++---
 drivers/video/fbdev/omap/lcdc.c           |   16 ++++++------
 drivers/video/fbdev/pxa168fb.c            |    8 +++---
 drivers/video/fbdev/pxafb.c               |    4 +--
 drivers/video/fbdev/s3c-fb.c              |    7 ++---
 drivers/video/fbdev/s3c2410fb.c           |    8 +++---
 drivers/video/fbdev/sa1100fb.c            |    8 +++---
 include/linux/dma-mapping.h               |   25 +++++++++++++-------
 sound/arm/pxa2xx-pcm-lib.c                |   12 +++------
 sound/soc/fsl/imx-pcm-fiq.c               |   10 +++-----
 sound/soc/nuc900/nuc900-pcm.c             |    6 +---
 sound/soc/omap/omap-pcm.c                 |   12 +++------
 38 files changed, 176 insertions(+), 197 deletions(-)

diff -puN arch/arm/mach-lpc32xx/phy3250.c~dma-rename-dma__writecombine-to-dma__wc arch/arm/mach-lpc32xx/phy3250.c
--- a/arch/arm/mach-lpc32xx/phy3250.c~dma-rename-dma__writecombine-to-dma__wc
+++ a/arch/arm/mach-lpc32xx/phy3250.c
@@ -86,8 +86,8 @@ static int lpc32xx_clcd_setup(struct clc
 {
 	dma_addr_t dma;
 
-	fb->fb.screen_base = dma_alloc_writecombine(&fb->dev->dev,
-		PANEL_SIZE, &dma, GFP_KERNEL);
+	fb->fb.screen_base = dma_alloc_wc(&fb->dev->dev, PANEL_SIZE, &dma,
+					  GFP_KERNEL);
 	if (!fb->fb.screen_base) {
 		printk(KERN_ERR "CLCD: unable to map framebuffer\n");
 		return -ENOMEM;
@@ -116,15 +116,14 @@ static int lpc32xx_clcd_setup(struct clc
 
 static int lpc32xx_clcd_mmap(struct clcd_fb *fb, struct vm_area_struct *vma)
 {
-	return dma_mmap_writecombine(&fb->dev->dev, vma,
-		fb->fb.screen_base, fb->fb.fix.smem_start,
-		fb->fb.fix.smem_len);
+	return dma_mmap_wc(&fb->dev->dev, vma, fb->fb.screen_base,
+			   fb->fb.fix.smem_start, fb->fb.fix.smem_len);
 }
 
 static void lpc32xx_clcd_remove(struct clcd_fb *fb)
 {
-	dma_free_writecombine(&fb->dev->dev, fb->fb.fix.smem_len,
-		fb->fb.screen_base, fb->fb.fix.smem_start);
+	dma_free_wc(&fb->dev->dev, fb->fb.fix.smem_len, fb->fb.screen_base,
+		    fb->fb.fix.smem_start);
 }
 
 /*
diff -puN arch/arm/mach-netx/fb.c~dma-rename-dma__writecombine-to-dma__wc arch/arm/mach-netx/fb.c
--- a/arch/arm/mach-netx/fb.c~dma-rename-dma__writecombine-to-dma__wc
+++ a/arch/arm/mach-netx/fb.c
@@ -42,8 +42,8 @@ int netx_clcd_setup(struct clcd_fb *fb)
 
 	fb->panel = netx_panel;
 
-	fb->fb.screen_base = dma_alloc_writecombine(&fb->dev->dev, 1024*1024,
-						    &dma, GFP_KERNEL);
+	fb->fb.screen_base = dma_alloc_wc(&fb->dev->dev, 1024 * 1024, &dma,
+					  GFP_KERNEL);
 	if (!fb->fb.screen_base) {
 		printk(KERN_ERR "CLCD: unable to map framebuffer\n");
 		return -ENOMEM;
@@ -57,16 +57,14 @@ int netx_clcd_setup(struct clcd_fb *fb)
 
 int netx_clcd_mmap(struct clcd_fb *fb, struct vm_area_struct *vma)
 {
-	return dma_mmap_writecombine(&fb->dev->dev, vma,
-				     fb->fb.screen_base,
-				     fb->fb.fix.smem_start,
-				     fb->fb.fix.smem_len);
+	return dma_mmap_wc(&fb->dev->dev, vma, fb->fb.screen_base,
+			   fb->fb.fix.smem_start, fb->fb.fix.smem_len);
 }
 
 void netx_clcd_remove(struct clcd_fb *fb)
 {
-	dma_free_writecombine(&fb->dev->dev, fb->fb.fix.smem_len,
-			      fb->fb.screen_base, fb->fb.fix.smem_start);
+	dma_free_wc(&fb->dev->dev, fb->fb.fix.smem_len, fb->fb.screen_base,
+		    fb->fb.fix.smem_start);
 }
 
 static AMBA_AHB_DEVICE(fb, "fb", 0, 0x00104000, { NETX_IRQ_LCD }, NULL);
diff -puN arch/arm/mach-nspire/clcd.c~dma-rename-dma__writecombine-to-dma__wc arch/arm/mach-nspire/clcd.c
--- a/arch/arm/mach-nspire/clcd.c~dma-rename-dma__writecombine-to-dma__wc
+++ a/arch/arm/mach-nspire/clcd.c
@@ -90,8 +90,8 @@ int nspire_clcd_setup(struct clcd_fb *fb
 	panel_size = ((panel->mode.xres * panel->mode.yres) * panel->bpp) / 8;
 	panel_size = ALIGN(panel_size, PAGE_SIZE);
 
-	fb->fb.screen_base = dma_alloc_writecombine(&fb->dev->dev,
-		panel_size, &dma, GFP_KERNEL);
+	fb->fb.screen_base = dma_alloc_wc(&fb->dev->dev, panel_size, &dma,
+					  GFP_KERNEL);
 
 	if (!fb->fb.screen_base) {
 		pr_err("CLCD: unable to map framebuffer\n");
@@ -107,13 +107,12 @@ int nspire_clcd_setup(struct clcd_fb *fb
 
 int nspire_clcd_mmap(struct clcd_fb *fb, struct vm_area_struct *vma)
 {
-	return dma_mmap_writecombine(&fb->dev->dev, vma,
-		fb->fb.screen_base, fb->fb.fix.smem_start,
-		fb->fb.fix.smem_len);
+	return dma_mmap_wc(&fb->dev->dev, vma, fb->fb.screen_base,
+			   fb->fb.fix.smem_start, fb->fb.fix.smem_len);
 }
 
 void nspire_clcd_remove(struct clcd_fb *fb)
 {
-	dma_free_writecombine(&fb->dev->dev, fb->fb.fix.smem_len,
-		fb->fb.screen_base, fb->fb.fix.smem_start);
+	dma_free_wc(&fb->dev->dev, fb->fb.fix.smem_len, fb->fb.screen_base,
+		    fb->fb.fix.smem_start);
 }
diff -puN drivers/dma/iop-adma.c~dma-rename-dma__writecombine-to-dma__wc drivers/dma/iop-adma.c
--- a/drivers/dma/iop-adma.c~dma-rename-dma__writecombine-to-dma__wc
+++ a/drivers/dma/iop-adma.c
@@ -1300,10 +1300,10 @@ static int iop_adma_probe(struct platfor
 	 * note: writecombine gives slightly better performance, but
 	 * requires that we explicitly flush the writes
 	 */
-	adev->dma_desc_pool_virt = dma_alloc_writecombine(&pdev->dev,
-							  plat_data->pool_size,
-							  &adev->dma_desc_pool,
-							  GFP_KERNEL);
+	adev->dma_desc_pool_virt = dma_alloc_wc(&pdev->dev,
+						plat_data->pool_size,
+						&adev->dma_desc_pool,
+						GFP_KERNEL);
 	if (!adev->dma_desc_pool_virt) {
 		ret = -ENOMEM;
 		goto err_free_adev;
diff -puN drivers/dma/mv_xor.c~dma-rename-dma__writecombine-to-dma__wc drivers/dma/mv_xor.c
--- a/drivers/dma/mv_xor.c~dma-rename-dma__writecombine-to-dma__wc
+++ a/drivers/dma/mv_xor.c
@@ -964,8 +964,8 @@ mv_xor_channel_add(struct mv_xor_device
 	 * requires that we explicitly flush the writes
 	 */
 	mv_chan->dma_desc_pool_virt =
-	  dma_alloc_writecombine(&pdev->dev, MV_XOR_POOL_SIZE,
-				 &mv_chan->dma_desc_pool, GFP_KERNEL);
+	  dma_alloc_wc(&pdev->dev, MV_XOR_POOL_SIZE, &mv_chan->dma_desc_pool,
+		       GFP_KERNEL);
 	if (!mv_chan->dma_desc_pool_virt)
 		return ERR_PTR(-ENOMEM);
 
diff -puN drivers/dma/qcom_bam_dma.c~dma-rename-dma__writecombine-to-dma__wc drivers/dma/qcom_bam_dma.c
--- a/drivers/dma/qcom_bam_dma.c~dma-rename-dma__writecombine-to-dma__wc
+++ a/drivers/dma/qcom_bam_dma.c
@@ -502,8 +502,8 @@ static int bam_alloc_chan(struct dma_cha
 		return 0;
 
 	/* allocate FIFO descriptor space, but only if necessary */
-	bchan->fifo_virt = dma_alloc_writecombine(bdev->dev, BAM_DESC_FIFO_SIZE,
-				&bchan->fifo_phys, GFP_KERNEL);
+	bchan->fifo_virt = dma_alloc_wc(bdev->dev, BAM_DESC_FIFO_SIZE,
+					&bchan->fifo_phys, GFP_KERNEL);
 
 	if (!bchan->fifo_virt) {
 		dev_err(bdev->dev, "Failed to allocate desc fifo\n");
@@ -538,8 +538,8 @@ static void bam_free_chan(struct dma_cha
 	bam_reset_channel(bchan);
 	spin_unlock_irqrestore(&bchan->vc.lock, flags);
 
-	dma_free_writecombine(bdev->dev, BAM_DESC_FIFO_SIZE, bchan->fifo_virt,
-				bchan->fifo_phys);
+	dma_free_wc(bdev->dev, BAM_DESC_FIFO_SIZE, bchan->fifo_virt,
+		    bchan->fifo_phys);
 	bchan->fifo_virt = NULL;
 
 	/* mask irq for pipe/channel */
@@ -1231,9 +1231,9 @@ static int bam_dma_remove(struct platfor
 		bam_dma_terminate_all(&bdev->channels[i].vc.chan);
 		tasklet_kill(&bdev->channels[i].vc.task);
 
-		dma_free_writecombine(bdev->dev, BAM_DESC_FIFO_SIZE,
-			bdev->channels[i].fifo_virt,
-			bdev->channels[i].fifo_phys);
+		dma_free_wc(bdev->dev, BAM_DESC_FIFO_SIZE,
+			    bdev->channels[i].fifo_virt,
+			    bdev->channels[i].fifo_phys);
 	}
 
 	tasklet_kill(&bdev->task);
diff -puN drivers/gpu/drm/drm_gem_cma_helper.c~dma-rename-dma__writecombine-to-dma__wc drivers/gpu/drm/drm_gem_cma_helper.c
--- a/drivers/gpu/drm/drm_gem_cma_helper.c~dma-rename-dma__writecombine-to-dma__wc
+++ a/drivers/gpu/drm/drm_gem_cma_helper.c
@@ -109,8 +109,8 @@ struct drm_gem_cma_object *drm_gem_cma_c
 	if (IS_ERR(cma_obj))
 		return cma_obj;
 
-	cma_obj->vaddr = dma_alloc_writecombine(drm->dev, size,
-			&cma_obj->paddr, GFP_KERNEL | __GFP_NOWARN);
+	cma_obj->vaddr = dma_alloc_wc(drm->dev, size, &cma_obj->paddr,
+				      GFP_KERNEL | __GFP_NOWARN);
 	if (!cma_obj->vaddr) {
 		dev_err(drm->dev, "failed to allocate buffer with size %zu\n",
 			size);
@@ -192,8 +192,8 @@ void drm_gem_cma_free_object(struct drm_
 	cma_obj = to_drm_gem_cma_obj(gem_obj);
 
 	if (cma_obj->vaddr) {
-		dma_free_writecombine(gem_obj->dev->dev, cma_obj->base.size,
-				      cma_obj->vaddr, cma_obj->paddr);
+		dma_free_wc(gem_obj->dev->dev, cma_obj->base.size,
+			    cma_obj->vaddr, cma_obj->paddr);
 	} else if (gem_obj->import_attach) {
 		drm_prime_gem_destroy(gem_obj, cma_obj->sgt);
 	}
@@ -324,9 +324,8 @@ static int drm_gem_cma_mmap_obj(struct d
 	vma->vm_flags &= ~VM_PFNMAP;
 	vma->vm_pgoff = 0;
 
-	ret = dma_mmap_writecombine(cma_obj->base.dev->dev, vma,
-				    cma_obj->vaddr, cma_obj->paddr,
-				    vma->vm_end - vma->vm_start);
+	ret = dma_mmap_wc(cma_obj->base.dev->dev, vma, cma_obj->vaddr,
+			  cma_obj->paddr, vma->vm_end - vma->vm_start);
 	if (ret)
 		drm_gem_vm_close(vma);
 
diff -puN drivers/gpu/drm/etnaviv/etnaviv_gpu.c~dma-rename-dma__writecombine-to-dma__wc drivers/gpu/drm/etnaviv/etnaviv_gpu.c
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c~dma-rename-dma__writecombine-to-dma__wc
+++ a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
@@ -1048,8 +1048,8 @@ struct etnaviv_cmdbuf *etnaviv_gpu_cmdbu
 	if (!cmdbuf)
 		return NULL;
 
-	cmdbuf->vaddr = dma_alloc_writecombine(gpu->dev, size, &cmdbuf->paddr,
-					       GFP_KERNEL);
+	cmdbuf->vaddr = dma_alloc_wc(gpu->dev, size, &cmdbuf->paddr,
+				     GFP_KERNEL);
 	if (!cmdbuf->vaddr) {
 		kfree(cmdbuf);
 		return NULL;
@@ -1063,8 +1063,8 @@ struct etnaviv_cmdbuf *etnaviv_gpu_cmdbu
 
 void etnaviv_gpu_cmdbuf_free(struct etnaviv_cmdbuf *cmdbuf)
 {
-	dma_free_writecombine(cmdbuf->gpu->dev, cmdbuf->size,
-			      cmdbuf->vaddr, cmdbuf->paddr);
+	dma_free_wc(cmdbuf->gpu->dev, cmdbuf->size, cmdbuf->vaddr,
+		    cmdbuf->paddr);
 	kfree(cmdbuf);
 }
 
diff -puN drivers/gpu/drm/omapdrm/omap_dmm_tiler.c~dma-rename-dma__writecombine-to-dma__wc drivers/gpu/drm/omapdrm/omap_dmm_tiler.c
--- a/drivers/gpu/drm/omapdrm/omap_dmm_tiler.c~dma-rename-dma__writecombine-to-dma__wc
+++ a/drivers/gpu/drm/omapdrm/omap_dmm_tiler.c
@@ -573,10 +573,9 @@ static int omap_dmm_remove(struct platfo
 
 		kfree(omap_dmm->engines);
 		if (omap_dmm->refill_va)
-			dma_free_writecombine(omap_dmm->dev,
-				REFILL_BUFFER_SIZE * omap_dmm->num_engines,
-				omap_dmm->refill_va,
-				omap_dmm->refill_pa);
+			dma_free_wc(omap_dmm->dev,
+				    REFILL_BUFFER_SIZE * omap_dmm->num_engines,
+				    omap_dmm->refill_va, omap_dmm->refill_pa);
 		if (omap_dmm->dummy_page)
 			__free_page(omap_dmm->dummy_page);
 
@@ -701,9 +700,9 @@ static int omap_dmm_probe(struct platfor
 	omap_dmm->dummy_pa = page_to_phys(omap_dmm->dummy_page);
 
 	/* alloc refill memory */
-	omap_dmm->refill_va = dma_alloc_writecombine(&dev->dev,
-				REFILL_BUFFER_SIZE * omap_dmm->num_engines,
-				&omap_dmm->refill_pa, GFP_KERNEL);
+	omap_dmm->refill_va = dma_alloc_wc(&dev->dev,
+					   REFILL_BUFFER_SIZE * omap_dmm->num_engines,
+					   &omap_dmm->refill_pa, GFP_KERNEL);
 	if (!omap_dmm->refill_va) {
 		dev_err(&dev->dev, "could not allocate refill memory\n");
 		goto fail;
diff -puN drivers/gpu/drm/omapdrm/omap_gem.c~dma-rename-dma__writecombine-to-dma__wc drivers/gpu/drm/omapdrm/omap_gem.c
--- a/drivers/gpu/drm/omapdrm/omap_gem.c~dma-rename-dma__writecombine-to-dma__wc
+++ a/drivers/gpu/drm/omapdrm/omap_gem.c
@@ -1330,8 +1330,8 @@ void omap_gem_free_object(struct drm_gem
 			omap_gem_detach_pages(obj);
 
 		if (!is_shmem(obj)) {
-			dma_free_writecombine(dev->dev, obj->size,
-					omap_obj->vaddr, omap_obj->paddr);
+			dma_free_wc(dev->dev, obj->size, omap_obj->vaddr,
+				    omap_obj->paddr);
 		} else if (omap_obj->vaddr) {
 			vunmap(omap_obj->vaddr);
 		}
@@ -1395,8 +1395,8 @@ struct drm_gem_object *omap_gem_new(stru
 		/* attempt to allocate contiguous memory if we don't
 		 * have DMM for remappign discontiguous buffers
 		 */
-		omap_obj->vaddr =  dma_alloc_writecombine(dev->dev, size,
-				&omap_obj->paddr, GFP_KERNEL);
+		omap_obj->vaddr =  dma_alloc_wc(dev->dev, size,
+						&omap_obj->paddr, GFP_KERNEL);
 		if (!omap_obj->vaddr) {
 			kfree(omap_obj);
 
diff -puN drivers/gpu/drm/sti/sti_cursor.c~dma-rename-dma__writecombine-to-dma__wc drivers/gpu/drm/sti/sti_cursor.c
--- a/drivers/gpu/drm/sti/sti_cursor.c~dma-rename-dma__writecombine-to-dma__wc
+++ a/drivers/gpu/drm/sti/sti_cursor.c
@@ -157,17 +157,15 @@ static void sti_cursor_atomic_update(str
 		cursor->height = src_h;
 
 		if (cursor->pixmap.base)
-			dma_free_writecombine(cursor->dev,
-					      cursor->pixmap.size,
-					      cursor->pixmap.base,
-					      cursor->pixmap.paddr);
+			dma_free_wc(cursor->dev, cursor->pixmap.size,
+				    cursor->pixmap.base, cursor->pixmap.paddr);
 
 		cursor->pixmap.size = cursor->width * cursor->height;
 
-		cursor->pixmap.base = dma_alloc_writecombine(cursor->dev,
-							cursor->pixmap.size,
-							&cursor->pixmap.paddr,
-							GFP_KERNEL | GFP_DMA);
+		cursor->pixmap.base = dma_alloc_wc(cursor->dev,
+						   cursor->pixmap.size,
+						   &cursor->pixmap.paddr,
+						   GFP_KERNEL | GFP_DMA);
 		if (!cursor->pixmap.base) {
 			DRM_ERROR("Failed to allocate memory for pixmap\n");
 			return;
@@ -252,8 +250,8 @@ struct drm_plane *sti_cursor_create(stru
 
 	/* Allocate clut buffer */
 	size = 0x100 * sizeof(unsigned short);
-	cursor->clut = dma_alloc_writecombine(dev, size, &cursor->clut_paddr,
-					      GFP_KERNEL | GFP_DMA);
+	cursor->clut = dma_alloc_wc(dev, size, &cursor->clut_paddr,
+				    GFP_KERNEL | GFP_DMA);
 
 	if (!cursor->clut) {
 		DRM_ERROR("Failed to allocate memory for cursor clut\n");
@@ -286,7 +284,7 @@ struct drm_plane *sti_cursor_create(stru
 	return &cursor->plane.drm_plane;
 
 err_plane:
-	dma_free_writecombine(dev, size, cursor->clut, cursor->clut_paddr);
+	dma_free_wc(dev, size, cursor->clut, cursor->clut_paddr);
 err_clut:
 	devm_kfree(dev, cursor);
 	return NULL;
diff -puN drivers/gpu/drm/sti/sti_gdp.c~dma-rename-dma__writecombine-to-dma__wc drivers/gpu/drm/sti/sti_gdp.c
--- a/drivers/gpu/drm/sti/sti_gdp.c~dma-rename-dma__writecombine-to-dma__wc
+++ a/drivers/gpu/drm/sti/sti_gdp.c
@@ -312,8 +312,7 @@ static void sti_gdp_init(struct sti_gdp
 	/* Allocate all the nodes within a single memory page */
 	size = sizeof(struct sti_gdp_node) *
 	    GDP_NODE_PER_FIELD * GDP_NODE_NB_BANK;
-	base = dma_alloc_writecombine(gdp->dev,
-				      size, &dma_addr, GFP_KERNEL | GFP_DMA);
+	base = dma_alloc_wc(gdp->dev, size, &dma_addr, GFP_KERNEL | GFP_DMA);
 
 	if (!base) {
 		DRM_ERROR("Failed to allocate memory for GDP node\n");
diff -puN drivers/gpu/drm/sti/sti_hqvdp.c~dma-rename-dma__writecombine-to-dma__wc drivers/gpu/drm/sti/sti_hqvdp.c
--- a/drivers/gpu/drm/sti/sti_hqvdp.c~dma-rename-dma__writecombine-to-dma__wc
+++ a/drivers/gpu/drm/sti/sti_hqvdp.c
@@ -617,9 +617,9 @@ static void sti_hqvdp_init(struct sti_hq
 
 	/* Allocate memory for the VDP commands */
 	size = NB_VDP_CMD * sizeof(struct sti_hqvdp_cmd);
-	hqvdp->hqvdp_cmd = dma_alloc_writecombine(hqvdp->dev, size,
-					 &hqvdp->hqvdp_cmd_paddr,
-					 GFP_KERNEL | GFP_DMA);
+	hqvdp->hqvdp_cmd = dma_alloc_wc(hqvdp->dev, size,
+					&hqvdp->hqvdp_cmd_paddr,
+					GFP_KERNEL | GFP_DMA);
 	if (!hqvdp->hqvdp_cmd) {
 		DRM_ERROR("Failed to allocate memory for VDP cmd\n");
 		return;
diff -puN drivers/gpu/drm/tegra/gem.c~dma-rename-dma__writecombine-to-dma__wc drivers/gpu/drm/tegra/gem.c
--- a/drivers/gpu/drm/tegra/gem.c~dma-rename-dma__writecombine-to-dma__wc
+++ a/drivers/gpu/drm/tegra/gem.c
@@ -175,8 +175,7 @@ static void tegra_bo_free(struct drm_dev
 		sg_free_table(bo->sgt);
 		kfree(bo->sgt);
 	} else if (bo->vaddr) {
-		dma_free_writecombine(drm->dev, bo->gem.size, bo->vaddr,
-				      bo->paddr);
+		dma_free_wc(drm->dev, bo->gem.size, bo->vaddr, bo->paddr);
 	}
 }
 
@@ -233,8 +232,8 @@ static int tegra_bo_alloc(struct drm_dev
 	} else {
 		size_t size = bo->gem.size;
 
-		bo->vaddr = dma_alloc_writecombine(drm->dev, size, &bo->paddr,
-						   GFP_KERNEL | __GFP_NOWARN);
+		bo->vaddr = dma_alloc_wc(drm->dev, size, &bo->paddr,
+					 GFP_KERNEL | __GFP_NOWARN);
 		if (!bo->vaddr) {
 			dev_err(drm->dev,
 				"failed to allocate buffer of size %zu\n",
@@ -472,8 +471,8 @@ int tegra_drm_mmap(struct file *file, st
 		vma->vm_flags &= ~VM_PFNMAP;
 		vma->vm_pgoff = 0;
 
-		ret = dma_mmap_writecombine(gem->dev->dev, vma, bo->vaddr,
-					    bo->paddr, gem->size);
+		ret = dma_mmap_wc(gem->dev->dev, vma, bo->vaddr, bo->paddr,
+				  gem->size);
 		if (ret) {
 			drm_gem_vm_close(vma);
 			return ret;
diff -puN drivers/gpu/drm/vc4/vc4_bo.c~dma-rename-dma__writecombine-to-dma__wc drivers/gpu/drm/vc4/vc4_bo.c
--- a/drivers/gpu/drm/vc4/vc4_bo.c~dma-rename-dma__writecombine-to-dma__wc
+++ a/drivers/gpu/drm/vc4/vc4_bo.c
@@ -398,9 +398,8 @@ int vc4_mmap(struct file *filp, struct v
 	vma->vm_flags &= ~VM_PFNMAP;
 	vma->vm_pgoff = 0;
 
-	ret = dma_mmap_writecombine(bo->base.base.dev->dev, vma,
-				    bo->base.vaddr, bo->base.paddr,
-				    vma->vm_end - vma->vm_start);
+	ret = dma_mmap_wc(bo->base.base.dev->dev, vma, bo->base.vaddr,
+			  bo->base.paddr, vma->vm_end - vma->vm_start);
 	if (ret)
 		drm_gem_vm_close(vma);
 
diff -puN drivers/gpu/host1x/cdma.c~dma-rename-dma__writecombine-to-dma__wc drivers/gpu/host1x/cdma.c
--- a/drivers/gpu/host1x/cdma.c~dma-rename-dma__writecombine-to-dma__wc
+++ a/drivers/gpu/host1x/cdma.c
@@ -52,8 +52,8 @@ static void host1x_pushbuffer_destroy(st
 	struct host1x *host1x = cdma_to_host1x(cdma);
 
 	if (pb->phys != 0)
-		dma_free_writecombine(host1x->dev, pb->size_bytes + 4,
-				      pb->mapped, pb->phys);
+		dma_free_wc(host1x->dev, pb->size_bytes + 4, pb->mapped,
+			    pb->phys);
 
 	pb->mapped = NULL;
 	pb->phys = 0;
@@ -76,8 +76,8 @@ static int host1x_pushbuffer_init(struct
 	pb->pos = 0;
 
 	/* allocate and map pushbuffer memory */
-	pb->mapped = dma_alloc_writecombine(host1x->dev, pb->size_bytes + 4,
-					    &pb->phys, GFP_KERNEL);
+	pb->mapped = dma_alloc_wc(host1x->dev, pb->size_bytes + 4, &pb->phys,
+				  GFP_KERNEL);
 	if (!pb->mapped)
 		goto fail;
 
diff -puN drivers/gpu/host1x/job.c~dma-rename-dma__writecombine-to-dma__wc drivers/gpu/host1x/job.c
--- a/drivers/gpu/host1x/job.c~dma-rename-dma__writecombine-to-dma__wc
+++ a/drivers/gpu/host1x/job.c
@@ -467,9 +467,8 @@ static inline int copy_gathers(struct ho
 		size += g->words * sizeof(u32);
 	}
 
-	job->gather_copy_mapped = dma_alloc_writecombine(dev, size,
-							 &job->gather_copy,
-							 GFP_KERNEL);
+	job->gather_copy_mapped = dma_alloc_wc(dev, size, &job->gather_copy,
+					       GFP_KERNEL);
 	if (!job->gather_copy_mapped) {
 		job->gather_copy_mapped = NULL;
 		return -ENOMEM;
@@ -578,9 +577,8 @@ void host1x_job_unpin(struct host1x_job
 	job->num_unpins = 0;
 
 	if (job->gather_copy_size)
-		dma_free_writecombine(job->channel->dev, job->gather_copy_size,
-				      job->gather_copy_mapped,
-				      job->gather_copy);
+		dma_free_wc(job->channel->dev, job->gather_copy_size,
+		            job->gather_copy_mapped, job->gather_copy);
 }
 EXPORT_SYMBOL(host1x_job_unpin);
 
diff -puN drivers/media/platform/coda/coda-bit.c~dma-rename-dma__writecombine-to-dma__wc drivers/media/platform/coda/coda-bit.c
--- a/drivers/media/platform/coda/coda-bit.c~dma-rename-dma__writecombine-to-dma__wc
+++ a/drivers/media/platform/coda/coda-bit.c
@@ -1455,9 +1455,9 @@ static int coda_alloc_bitstream_buffer(s
 		return 0;
 
 	ctx->bitstream.size = roundup_pow_of_two(q_data->sizeimage * 2);
-	ctx->bitstream.vaddr = dma_alloc_writecombine(
-			&ctx->dev->plat_dev->dev, ctx->bitstream.size,
-			&ctx->bitstream.paddr, GFP_KERNEL);
+	ctx->bitstream.vaddr = dma_alloc_wc(&ctx->dev->plat_dev->dev,
+					    ctx->bitstream.size,
+					    &ctx->bitstream.paddr, GFP_KERNEL);
 	if (!ctx->bitstream.vaddr) {
 		v4l2_err(&ctx->dev->v4l2_dev,
 			 "failed to allocate bitstream ringbuffer");
@@ -1474,8 +1474,8 @@ static void coda_free_bitstream_buffer(s
 	if (ctx->bitstream.vaddr == NULL)
 		return;
 
-	dma_free_writecombine(&ctx->dev->plat_dev->dev, ctx->bitstream.size,
-			      ctx->bitstream.vaddr, ctx->bitstream.paddr);
+	dma_free_wc(&ctx->dev->plat_dev->dev, ctx->bitstream.size,
+		    ctx->bitstream.vaddr, ctx->bitstream.paddr);
 	ctx->bitstream.vaddr = NULL;
 	kfifo_init(&ctx->bitstream_fifo, NULL, 0);
 }
diff -puN drivers/video/fbdev/acornfb.c~dma-rename-dma__writecombine-to-dma__wc drivers/video/fbdev/acornfb.c
--- a/drivers/video/fbdev/acornfb.c~dma-rename-dma__writecombine-to-dma__wc
+++ a/drivers/video/fbdev/acornfb.c
@@ -1040,8 +1040,8 @@ static int acornfb_probe(struct platform
 		 * for the framebuffer if we are not using
 		 * VRAM.
 		 */
-		base = dma_alloc_writecombine(current_par.dev, size, &handle,
-					      GFP_KERNEL);
+		base = dma_alloc_wc(current_par.dev, size, &handle,
+				    GFP_KERNEL);
 		if (base == NULL) {
 			printk(KERN_ERR "acornfb: unable to allocate screen "
 			       "memory\n");
diff -puN drivers/video/fbdev/amba-clcd-versatile.c~dma-rename-dma__writecombine-to-dma__wc drivers/video/fbdev/amba-clcd-versatile.c
--- a/drivers/video/fbdev/amba-clcd-versatile.c~dma-rename-dma__writecombine-to-dma__wc
+++ a/drivers/video/fbdev/amba-clcd-versatile.c
@@ -154,8 +154,8 @@ int versatile_clcd_setup_dma(struct clcd
 {
 	dma_addr_t dma;
 
-	fb->fb.screen_base = dma_alloc_writecombine(&fb->dev->dev, framesize,
-						    &dma, GFP_KERNEL);
+	fb->fb.screen_base = dma_alloc_wc(&fb->dev->dev, framesize, &dma,
+					  GFP_KERNEL);
 	if (!fb->fb.screen_base) {
 		pr_err("CLCD: unable to map framebuffer\n");
 		return -ENOMEM;
@@ -169,14 +169,12 @@ int versatile_clcd_setup_dma(struct clcd
 
 int versatile_clcd_mmap_dma(struct clcd_fb *fb, struct vm_area_struct *vma)
 {
-	return dma_mmap_writecombine(&fb->dev->dev, vma,
-				     fb->fb.screen_base,
-				     fb->fb.fix.smem_start,
-				     fb->fb.fix.smem_len);
+	return dma_mmap_wc(&fb->dev->dev, vma, fb->fb.screen_base,
+			   fb->fb.fix.smem_start, fb->fb.fix.smem_len);
 }
 
 void versatile_clcd_remove_dma(struct clcd_fb *fb)
 {
-	dma_free_writecombine(&fb->dev->dev, fb->fb.fix.smem_len,
-			      fb->fb.screen_base, fb->fb.fix.smem_start);
+	dma_free_wc(&fb->dev->dev, fb->fb.fix.smem_len, fb->fb.screen_base,
+		    fb->fb.fix.smem_start);
 }
diff -puN drivers/video/fbdev/amba-clcd.c~dma-rename-dma__writecombine-to-dma__wc drivers/video/fbdev/amba-clcd.c
--- a/drivers/video/fbdev/amba-clcd.c~dma-rename-dma__writecombine-to-dma__wc
+++ a/drivers/video/fbdev/amba-clcd.c
@@ -774,8 +774,8 @@ static int clcdfb_of_dma_setup(struct cl
 
 static int clcdfb_of_dma_mmap(struct clcd_fb *fb, struct vm_area_struct *vma)
 {
-	return dma_mmap_writecombine(&fb->dev->dev, vma, fb->fb.screen_base,
-			fb->fb.fix.smem_start, fb->fb.fix.smem_len);
+	return dma_mmap_wc(&fb->dev->dev, vma, fb->fb.screen_base,
+			   fb->fb.fix.smem_start, fb->fb.fix.smem_len);
 }
 
 static void clcdfb_of_dma_remove(struct clcd_fb *fb)
diff -puN drivers/video/fbdev/atmel_lcdfb.c~dma-rename-dma__writecombine-to-dma__wc drivers/video/fbdev/atmel_lcdfb.c
--- a/drivers/video/fbdev/atmel_lcdfb.c~dma-rename-dma__writecombine-to-dma__wc
+++ a/drivers/video/fbdev/atmel_lcdfb.c
@@ -414,8 +414,8 @@ static inline void atmel_lcdfb_free_vide
 {
 	struct fb_info *info = sinfo->info;
 
-	dma_free_writecombine(info->device, info->fix.smem_len,
-				info->screen_base, info->fix.smem_start);
+	dma_free_wc(info->device, info->fix.smem_len, info->screen_base,
+		    info->fix.smem_start);
 }
 
 /**
@@ -435,8 +435,9 @@ static int atmel_lcdfb_alloc_video_memor
 		    * ((var->bits_per_pixel + 7) / 8));
 	info->fix.smem_len = max(smem_len, sinfo->smem_len);
 
-	info->screen_base = dma_alloc_writecombine(info->device, info->fix.smem_len,
-					(dma_addr_t *)&info->fix.smem_start, GFP_KERNEL);
+	info->screen_base = dma_alloc_wc(info->device, info->fix.smem_len,
+					 (dma_addr_t *)&info->fix.smem_start,
+					 GFP_KERNEL);
 
 	if (!info->screen_base) {
 		return -ENOMEM;
diff -puN drivers/video/fbdev/ep93xx-fb.c~dma-rename-dma__writecombine-to-dma__wc drivers/video/fbdev/ep93xx-fb.c
--- a/drivers/video/fbdev/ep93xx-fb.c~dma-rename-dma__writecombine-to-dma__wc
+++ a/drivers/video/fbdev/ep93xx-fb.c
@@ -316,9 +316,8 @@ static int ep93xxfb_mmap(struct fb_info
 	unsigned int offset = vma->vm_pgoff << PAGE_SHIFT;
 
 	if (offset < info->fix.smem_len) {
-		return dma_mmap_writecombine(info->dev, vma, info->screen_base,
-					     info->fix.smem_start,
-					     info->fix.smem_len);
+		return dma_mmap_wc(info->dev, vma, info->screen_base,
+				   info->fix.smem_start, info->fix.smem_len);
 	}
 
 	return -EINVAL;
@@ -428,8 +427,7 @@ static int ep93xxfb_alloc_videomem(struc
 	/* Maximum 16bpp -> used memory is maximum x*y*2 bytes */
 	fb_size = EP93XXFB_MAX_XRES * EP93XXFB_MAX_YRES * 2;
 
-	virt_addr = dma_alloc_writecombine(info->dev, fb_size,
-					   &phys_addr, GFP_KERNEL);
+	virt_addr = dma_alloc_wc(info->dev, fb_size, &phys_addr, GFP_KERNEL);
 	if (!virt_addr)
 		return -ENOMEM;
 
diff -puN drivers/video/fbdev/gbefb.c~dma-rename-dma__writecombine-to-dma__wc drivers/video/fbdev/gbefb.c
--- a/drivers/video/fbdev/gbefb.c~dma-rename-dma__writecombine-to-dma__wc
+++ a/drivers/video/fbdev/gbefb.c
@@ -1185,8 +1185,8 @@ static int gbefb_probe(struct platform_d
 	} else {
 		/* try to allocate memory with the classical allocator
 		 * this has high chance to fail on low memory machines */
-		gbe_mem = dma_alloc_writecombine(NULL, gbe_mem_size,
-						 &gbe_dma_addr, GFP_KERNEL);
+		gbe_mem = dma_alloc_wc(NULL, gbe_mem_size, &gbe_dma_addr,
+				       GFP_KERNEL);
 		if (!gbe_mem) {
 			printk(KERN_ERR "gbefb: couldn't allocate framebuffer memory\n");
 			ret = -ENOMEM;
@@ -1238,7 +1238,7 @@ static int gbefb_probe(struct platform_d
 out_gbe_unmap:
 	arch_phys_wc_del(par->wc_cookie);
 	if (gbe_dma_addr)
-		dma_free_writecombine(NULL, gbe_mem_size, gbe_mem, gbe_mem_phys);
+		dma_free_wc(NULL, gbe_mem_size, gbe_mem, gbe_mem_phys);
 out_tiles_free:
 	dma_free_coherent(NULL, GBE_TLB_SIZE * sizeof(uint16_t),
 			  (void *)gbe_tiles.cpu, gbe_tiles.dma);
@@ -1259,7 +1259,7 @@ static int gbefb_remove(struct platform_
 	gbe_turn_off();
 	arch_phys_wc_del(par->wc_cookie);
 	if (gbe_dma_addr)
-		dma_free_writecombine(NULL, gbe_mem_size, gbe_mem, gbe_mem_phys);
+		dma_free_wc(NULL, gbe_mem_size, gbe_mem, gbe_mem_phys);
 	dma_free_coherent(NULL, GBE_TLB_SIZE * sizeof(uint16_t),
 			  (void *)gbe_tiles.cpu, gbe_tiles.dma);
 	release_mem_region(GBE_BASE, sizeof(struct sgi_gbe));
diff -puN drivers/video/fbdev/imxfb.c~dma-rename-dma__writecombine-to-dma__wc drivers/video/fbdev/imxfb.c
--- a/drivers/video/fbdev/imxfb.c~dma-rename-dma__writecombine-to-dma__wc
+++ a/drivers/video/fbdev/imxfb.c
@@ -922,8 +922,8 @@ static int imxfb_probe(struct platform_d
 	}
 
 	fbi->map_size = PAGE_ALIGN(info->fix.smem_len);
-	info->screen_base = dma_alloc_writecombine(&pdev->dev, fbi->map_size,
-						   &fbi->map_dma, GFP_KERNEL);
+	info->screen_base = dma_alloc_wc(&pdev->dev, fbi->map_size,
+					 &fbi->map_dma, GFP_KERNEL);
 
 	if (!info->screen_base) {
 		dev_err(&pdev->dev, "Failed to allocate video RAM: %d\n", ret);
@@ -990,8 +990,8 @@ failed_cmap:
 	if (pdata && pdata->exit)
 		pdata->exit(fbi->pdev);
 failed_platform_init:
-	dma_free_writecombine(&pdev->dev, fbi->map_size, info->screen_base,
-			      fbi->map_dma);
+	dma_free_wc(&pdev->dev, fbi->map_size, info->screen_base,
+		    fbi->map_dma);
 failed_map:
 	iounmap(fbi->regs);
 failed_ioremap:
@@ -1026,8 +1026,8 @@ static int imxfb_remove(struct platform_
 	kfree(info->pseudo_palette);
 	framebuffer_release(info);
 
-	dma_free_writecombine(&pdev->dev, fbi->map_size, info->screen_base,
-			      fbi->map_dma);
+	dma_free_wc(&pdev->dev, fbi->map_size, info->screen_base,
+		    fbi->map_dma);
 
 	iounmap(fbi->regs);
 	release_mem_region(res->start, resource_size(res));
diff -puN drivers/video/fbdev/mx3fb.c~dma-rename-dma__writecombine-to-dma__wc drivers/video/fbdev/mx3fb.c
--- a/drivers/video/fbdev/mx3fb.c~dma-rename-dma__writecombine-to-dma__wc
+++ a/drivers/video/fbdev/mx3fb.c
@@ -1336,9 +1336,8 @@ static int mx3fb_map_video_memory(struct
 	int retval = 0;
 	dma_addr_t addr;
 
-	fbi->screen_base = dma_alloc_writecombine(fbi->device,
-						  mem_len,
-						  &addr, GFP_DMA | GFP_KERNEL);
+	fbi->screen_base = dma_alloc_wc(fbi->device, mem_len, &addr,
+					GFP_DMA | GFP_KERNEL);
 
 	if (!fbi->screen_base) {
 		dev_err(fbi->device, "Cannot allocate %u bytes framebuffer memory\n",
@@ -1378,8 +1377,8 @@ err0:
  */
 static int mx3fb_unmap_video_memory(struct fb_info *fbi)
 {
-	dma_free_writecombine(fbi->device, fbi->fix.smem_len,
-			      fbi->screen_base, fbi->fix.smem_start);
+	dma_free_wc(fbi->device, fbi->fix.smem_len, fbi->screen_base,
+		    fbi->fix.smem_start);
 
 	fbi->screen_base = NULL;
 	mutex_lock(&fbi->mm_lock);
diff -puN drivers/video/fbdev/nuc900fb.c~dma-rename-dma__writecombine-to-dma__wc drivers/video/fbdev/nuc900fb.c
--- a/drivers/video/fbdev/nuc900fb.c~dma-rename-dma__writecombine-to-dma__wc
+++ a/drivers/video/fbdev/nuc900fb.c
@@ -396,8 +396,8 @@ static int nuc900fb_map_video_memory(str
 	dev_dbg(fbi->dev, "nuc900fb_map_video_memory(fbi=%p) map_size %lu\n",
 		fbi, map_size);
 
-	info->screen_base = dma_alloc_writecombine(fbi->dev, map_size,
-							&map_dma, GFP_KERNEL);
+	info->screen_base = dma_alloc_wc(fbi->dev, map_size, &map_dma,
+					 GFP_KERNEL);
 
 	if (!info->screen_base)
 		return -ENOMEM;
@@ -411,8 +411,8 @@ static int nuc900fb_map_video_memory(str
 static inline void nuc900fb_unmap_video_memory(struct fb_info *info)
 {
 	struct nuc900fb_info *fbi = info->par;
-	dma_free_writecombine(fbi->dev, PAGE_ALIGN(info->fix.smem_len),
-			      info->screen_base, info->fix.smem_start);
+	dma_free_wc(fbi->dev, PAGE_ALIGN(info->fix.smem_len),
+		    info->screen_base, info->fix.smem_start);
 }
 
 static irqreturn_t nuc900fb_irqhandler(int irq, void *dev_id)
diff -puN drivers/video/fbdev/omap/lcdc.c~dma-rename-dma__writecombine-to-dma__wc drivers/video/fbdev/omap/lcdc.c
--- a/drivers/video/fbdev/omap/lcdc.c~dma-rename-dma__writecombine-to-dma__wc
+++ a/drivers/video/fbdev/omap/lcdc.c
@@ -612,8 +612,8 @@ static void lcdc_dma_handler(u16 status,
 
 static int alloc_palette_ram(void)
 {
-	lcdc.palette_virt = dma_alloc_writecombine(lcdc.fbdev->dev,
-		MAX_PALETTE_SIZE, &lcdc.palette_phys, GFP_KERNEL);
+	lcdc.palette_virt = dma_alloc_wc(lcdc.fbdev->dev, MAX_PALETTE_SIZE,
+					 &lcdc.palette_phys, GFP_KERNEL);
 	if (lcdc.palette_virt == NULL) {
 		dev_err(lcdc.fbdev->dev, "failed to alloc palette memory\n");
 		return -ENOMEM;
@@ -625,8 +625,8 @@ static int alloc_palette_ram(void)
 
 static void free_palette_ram(void)
 {
-	dma_free_writecombine(lcdc.fbdev->dev, MAX_PALETTE_SIZE,
-			lcdc.palette_virt, lcdc.palette_phys);
+	dma_free_wc(lcdc.fbdev->dev, MAX_PALETTE_SIZE, lcdc.palette_virt,
+		    lcdc.palette_phys);
 }
 
 static int alloc_fbmem(struct omapfb_mem_region *region)
@@ -642,8 +642,8 @@ static int alloc_fbmem(struct omapfb_mem
 	if (region->size > frame_size)
 		frame_size = region->size;
 	lcdc.vram_size = frame_size;
-	lcdc.vram_virt = dma_alloc_writecombine(lcdc.fbdev->dev,
-			lcdc.vram_size, &lcdc.vram_phys, GFP_KERNEL);
+	lcdc.vram_virt = dma_alloc_wc(lcdc.fbdev->dev, lcdc.vram_size,
+				      &lcdc.vram_phys, GFP_KERNEL);
 	if (lcdc.vram_virt == NULL) {
 		dev_err(lcdc.fbdev->dev, "unable to allocate FB DMA memory\n");
 		return -ENOMEM;
@@ -660,8 +660,8 @@ static int alloc_fbmem(struct omapfb_mem
 
 static void free_fbmem(void)
 {
-	dma_free_writecombine(lcdc.fbdev->dev, lcdc.vram_size,
-			      lcdc.vram_virt, lcdc.vram_phys);
+	dma_free_wc(lcdc.fbdev->dev, lcdc.vram_size, lcdc.vram_virt,
+		    lcdc.vram_phys);
 }
 
 static int setup_fbmem(struct omapfb_mem_desc *req_md)
diff -puN drivers/video/fbdev/pxa168fb.c~dma-rename-dma__writecombine-to-dma__wc drivers/video/fbdev/pxa168fb.c
--- a/drivers/video/fbdev/pxa168fb.c~dma-rename-dma__writecombine-to-dma__wc
+++ a/drivers/video/fbdev/pxa168fb.c
@@ -680,8 +680,8 @@ static int pxa168fb_probe(struct platfor
 	 */
 	info->fix.smem_len = PAGE_ALIGN(DEFAULT_FB_SIZE);
 
-	info->screen_base = dma_alloc_writecombine(fbi->dev, info->fix.smem_len,
-						&fbi->fb_start_dma, GFP_KERNEL);
+	info->screen_base = dma_alloc_wc(fbi->dev, info->fix.smem_len,
+					 &fbi->fb_start_dma, GFP_KERNEL);
 	if (info->screen_base == NULL) {
 		ret = -ENOMEM;
 		goto failed_free_info;
@@ -804,8 +804,8 @@ static int pxa168fb_remove(struct platfo
 
 	irq = platform_get_irq(pdev, 0);
 
-	dma_free_writecombine(fbi->dev, PAGE_ALIGN(info->fix.smem_len),
-				info->screen_base, info->fix.smem_start);
+	dma_free_wc(fbi->dev, PAGE_ALIGN(info->fix.smem_len),
+		    info->screen_base, info->fix.smem_start);
 
 	clk_disable(fbi->clk);
 
diff -puN drivers/video/fbdev/pxafb.c~dma-rename-dma__writecombine-to-dma__wc drivers/video/fbdev/pxafb.c
--- a/drivers/video/fbdev/pxafb.c~dma-rename-dma__writecombine-to-dma__wc
+++ a/drivers/video/fbdev/pxafb.c
@@ -2446,8 +2446,8 @@ static int pxafb_remove(struct platform_
 
 	free_pages_exact(fbi->video_mem, fbi->video_mem_size);
 
-	dma_free_writecombine(&dev->dev, fbi->dma_buff_size,
-			fbi->dma_buff, fbi->dma_buff_phys);
+	dma_free_wc(&dev->dev, fbi->dma_buff_size, fbi->dma_buff,
+		    fbi->dma_buff_phys);
 
 	iounmap(fbi->mmio_base);
 
diff -puN drivers/video/fbdev/s3c-fb.c~dma-rename-dma__writecombine-to-dma__wc drivers/video/fbdev/s3c-fb.c
--- a/drivers/video/fbdev/s3c-fb.c~dma-rename-dma__writecombine-to-dma__wc
+++ a/drivers/video/fbdev/s3c-fb.c
@@ -1105,8 +1105,7 @@ static int s3c_fb_alloc_memory(struct s3
 
 	dev_dbg(sfb->dev, "want %u bytes for window\n", size);
 
-	fbi->screen_base = dma_alloc_writecombine(sfb->dev, size,
-						  &map_dma, GFP_KERNEL);
+	fbi->screen_base = dma_alloc_wc(sfb->dev, size, &map_dma, GFP_KERNEL);
 	if (!fbi->screen_base)
 		return -ENOMEM;
 
@@ -1131,8 +1130,8 @@ static void s3c_fb_free_memory(struct s3
 	struct fb_info *fbi = win->fbinfo;
 
 	if (fbi->screen_base)
-		dma_free_writecombine(sfb->dev, PAGE_ALIGN(fbi->fix.smem_len),
-			      fbi->screen_base, fbi->fix.smem_start);
+		dma_free_wc(sfb->dev, PAGE_ALIGN(fbi->fix.smem_len),
+		            fbi->screen_base, fbi->fix.smem_start);
 }
 
 /**
diff -puN drivers/video/fbdev/s3c2410fb.c~dma-rename-dma__writecombine-to-dma__wc drivers/video/fbdev/s3c2410fb.c
--- a/drivers/video/fbdev/s3c2410fb.c~dma-rename-dma__writecombine-to-dma__wc
+++ a/drivers/video/fbdev/s3c2410fb.c
@@ -645,8 +645,8 @@ static int s3c2410fb_map_video_memory(st
 
 	dprintk("map_video_memory(fbi=%p) map_size %u\n", fbi, map_size);
 
-	info->screen_base = dma_alloc_writecombine(fbi->dev, map_size,
-						   &map_dma, GFP_KERNEL);
+	info->screen_base = dma_alloc_wc(fbi->dev, map_size, &map_dma,
+					 GFP_KERNEL);
 
 	if (info->screen_base) {
 		/* prevent initial garbage on screen */
@@ -667,8 +667,8 @@ static inline void s3c2410fb_unmap_video
 {
 	struct s3c2410fb_info *fbi = info->par;
 
-	dma_free_writecombine(fbi->dev, PAGE_ALIGN(info->fix.smem_len),
-			      info->screen_base, info->fix.smem_start);
+	dma_free_wc(fbi->dev, PAGE_ALIGN(info->fix.smem_len),
+		    info->screen_base, info->fix.smem_start);
 }
 
 static inline void modify_gpio(void __iomem *reg,
diff -puN drivers/video/fbdev/sa1100fb.c~dma-rename-dma__writecombine-to-dma__wc drivers/video/fbdev/sa1100fb.c
--- a/drivers/video/fbdev/sa1100fb.c~dma-rename-dma__writecombine-to-dma__wc
+++ a/drivers/video/fbdev/sa1100fb.c
@@ -567,8 +567,8 @@ static int sa1100fb_mmap(struct fb_info
 
 	if (off < info->fix.smem_len) {
 		vma->vm_pgoff += 1; /* skip over the palette */
-		return dma_mmap_writecombine(fbi->dev, vma, fbi->map_cpu,
-					     fbi->map_dma, fbi->map_size);
+		return dma_mmap_wc(fbi->dev, vma, fbi->map_cpu, fbi->map_dma,
+				   fbi->map_size);
 	}
 
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
@@ -1099,8 +1099,8 @@ static int sa1100fb_map_video_memory(str
 	 * of the framebuffer.
 	 */
 	fbi->map_size = PAGE_ALIGN(fbi->fb.fix.smem_len + PAGE_SIZE);
-	fbi->map_cpu = dma_alloc_writecombine(fbi->dev, fbi->map_size,
-					      &fbi->map_dma, GFP_KERNEL);
+	fbi->map_cpu = dma_alloc_wc(fbi->dev, fbi->map_size, &fbi->map_dma,
+				    GFP_KERNEL);
 
 	if (fbi->map_cpu) {
 		fbi->fb.screen_base = fbi->map_cpu + PAGE_SIZE;
diff -puN include/linux/dma-mapping.h~dma-rename-dma__writecombine-to-dma__wc include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~dma-rename-dma__writecombine-to-dma__wc
+++ a/include/linux/dma-mapping.h
@@ -641,31 +641,40 @@ static inline void dmam_release_declared
 }
 #endif /* CONFIG_HAVE_GENERIC_DMA_COHERENT */
 
-static inline void *dma_alloc_writecombine(struct device *dev, size_t size,
-					   dma_addr_t *dma_addr, gfp_t gfp)
+static inline void *dma_alloc_wc(struct device *dev, size_t size,
+				 dma_addr_t *dma_addr, gfp_t gfp)
 {
 	DEFINE_DMA_ATTRS(attrs);
 	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
 	return dma_alloc_attrs(dev, size, dma_addr, gfp, &attrs);
 }
+#ifndef dma_alloc_writecombine
+#define dma_alloc_writecombine dma_alloc_wc
+#endif
 
-static inline void dma_free_writecombine(struct device *dev, size_t size,
-					 void *cpu_addr, dma_addr_t dma_addr)
+static inline void dma_free_wc(struct device *dev, size_t size,
+			       void *cpu_addr, dma_addr_t dma_addr)
 {
 	DEFINE_DMA_ATTRS(attrs);
 	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
 	return dma_free_attrs(dev, size, cpu_addr, dma_addr, &attrs);
 }
+#ifndef dma_free_writecombine
+#define dma_free_writecombine dma_free_wc
+#endif
 
-static inline int dma_mmap_writecombine(struct device *dev,
-					struct vm_area_struct *vma,
-					void *cpu_addr, dma_addr_t dma_addr,
-					size_t size)
+static inline int dma_mmap_wc(struct device *dev,
+			      struct vm_area_struct *vma,
+			      void *cpu_addr, dma_addr_t dma_addr,
+			      size_t size)
 {
 	DEFINE_DMA_ATTRS(attrs);
 	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
 	return dma_mmap_attrs(dev, vma, cpu_addr, dma_addr, size, &attrs);
 }
+#ifndef dma_mmap_writecombine
+#define dma_mmap_writecombine dma_mmap_wc
+#endif
 
 #ifdef CONFIG_NEED_DMA_MAP_STATE
 #define DEFINE_DMA_UNMAP_ADDR(ADDR_NAME)        dma_addr_t ADDR_NAME
diff -puN sound/arm/pxa2xx-pcm-lib.c~dma-rename-dma__writecombine-to-dma__wc sound/arm/pxa2xx-pcm-lib.c
--- a/sound/arm/pxa2xx-pcm-lib.c~dma-rename-dma__writecombine-to-dma__wc
+++ a/sound/arm/pxa2xx-pcm-lib.c
@@ -141,10 +141,8 @@ int pxa2xx_pcm_mmap(struct snd_pcm_subst
 	struct vm_area_struct *vma)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
-	return dma_mmap_writecombine(substream->pcm->card->dev, vma,
-				     runtime->dma_area,
-				     runtime->dma_addr,
-				     runtime->dma_bytes);
+	return dma_mmap_wc(substream->pcm->card->dev, vma, runtime->dma_area,
+			   runtime->dma_addr, runtime->dma_bytes);
 }
 EXPORT_SYMBOL(pxa2xx_pcm_mmap);
 
@@ -156,8 +154,7 @@ int pxa2xx_pcm_preallocate_dma_buffer(st
 	buf->dev.type = SNDRV_DMA_TYPE_DEV;
 	buf->dev.dev = pcm->card->dev;
 	buf->private_data = NULL;
-	buf->area = dma_alloc_writecombine(pcm->card->dev, size,
-					   &buf->addr, GFP_KERNEL);
+	buf->area = dma_alloc_wc(pcm->card->dev, size, &buf->addr, GFP_KERNEL);
 	if (!buf->area)
 		return -ENOMEM;
 	buf->bytes = size;
@@ -178,8 +175,7 @@ void pxa2xx_pcm_free_dma_buffers(struct
 		buf = &substream->dma_buffer;
 		if (!buf->area)
 			continue;
-		dma_free_writecombine(pcm->card->dev, buf->bytes,
-				      buf->area, buf->addr);
+		dma_free_wc(pcm->card->dev, buf->bytes, buf->area, buf->addr);
 		buf->area = NULL;
 	}
 }
diff -puN sound/soc/fsl/imx-pcm-fiq.c~dma-rename-dma__writecombine-to-dma__wc sound/soc/fsl/imx-pcm-fiq.c
--- a/sound/soc/fsl/imx-pcm-fiq.c~dma-rename-dma__writecombine-to-dma__wc
+++ a/sound/soc/fsl/imx-pcm-fiq.c
@@ -217,8 +217,8 @@ static int snd_imx_pcm_mmap(struct snd_p
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	int ret;
 
-	ret = dma_mmap_writecombine(substream->pcm->card->dev, vma,
-		runtime->dma_area, runtime->dma_addr, runtime->dma_bytes);
+	ret = dma_mmap_wc(substream->pcm->card->dev, vma, runtime->dma_area,
+			  runtime->dma_addr, runtime->dma_bytes);
 
 	pr_debug("%s: ret: %d %p %pad 0x%08x\n", __func__, ret,
 			runtime->dma_area,
@@ -247,8 +247,7 @@ static int imx_pcm_preallocate_dma_buffe
 	buf->dev.type = SNDRV_DMA_TYPE_DEV;
 	buf->dev.dev = pcm->card->dev;
 	buf->private_data = NULL;
-	buf->area = dma_alloc_writecombine(pcm->card->dev, size,
-					   &buf->addr, GFP_KERNEL);
+	buf->area = dma_alloc_wc(pcm->card->dev, size, &buf->addr, GFP_KERNEL);
 	if (!buf->area)
 		return -ENOMEM;
 	buf->bytes = size;
@@ -330,8 +329,7 @@ static void imx_pcm_free(struct snd_pcm
 		if (!buf->area)
 			continue;
 
-		dma_free_writecombine(pcm->card->dev, buf->bytes,
-				      buf->area, buf->addr);
+		dma_free_wc(pcm->card->dev, buf->bytes, buf->area, buf->addr);
 		buf->area = NULL;
 	}
 }
diff -puN sound/soc/nuc900/nuc900-pcm.c~dma-rename-dma__writecombine-to-dma__wc sound/soc/nuc900/nuc900-pcm.c
--- a/sound/soc/nuc900/nuc900-pcm.c~dma-rename-dma__writecombine-to-dma__wc
+++ a/sound/soc/nuc900/nuc900-pcm.c
@@ -267,10 +267,8 @@ static int nuc900_dma_mmap(struct snd_pc
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
 
-	return dma_mmap_writecombine(substream->pcm->card->dev, vma,
-					runtime->dma_area,
-					runtime->dma_addr,
-					runtime->dma_bytes);
+	return dma_mmap_wc(substream->pcm->card->dev, vma, runtime->dma_area,
+			   runtime->dma_addr, runtime->dma_bytes);
 }
 
 static struct snd_pcm_ops nuc900_dma_ops = {
diff -puN sound/soc/omap/omap-pcm.c~dma-rename-dma__writecombine-to-dma__wc sound/soc/omap/omap-pcm.c
--- a/sound/soc/omap/omap-pcm.c~dma-rename-dma__writecombine-to-dma__wc
+++ a/sound/soc/omap/omap-pcm.c
@@ -156,10 +156,8 @@ static int omap_pcm_mmap(struct snd_pcm_
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
 
-	return dma_mmap_writecombine(substream->pcm->card->dev, vma,
-				     runtime->dma_area,
-				     runtime->dma_addr,
-				     runtime->dma_bytes);
+	return dma_mmap_wc(substream->pcm->card->dev, vma, runtime->dma_area,
+			   runtime->dma_addr, runtime->dma_bytes);
 }
 
 static struct snd_pcm_ops omap_pcm_ops = {
@@ -183,8 +181,7 @@ static int omap_pcm_preallocate_dma_buff
 	buf->dev.type = SNDRV_DMA_TYPE_DEV;
 	buf->dev.dev = pcm->card->dev;
 	buf->private_data = NULL;
-	buf->area = dma_alloc_writecombine(pcm->card->dev, size,
-					   &buf->addr, GFP_KERNEL);
+	buf->area = dma_alloc_wc(pcm->card->dev, size, &buf->addr, GFP_KERNEL);
 	if (!buf->area)
 		return -ENOMEM;
 
@@ -207,8 +204,7 @@ static void omap_pcm_free_dma_buffers(st
 		if (!buf->area)
 			continue;
 
-		dma_free_writecombine(pcm->card->dev, buf->bytes,
-				      buf->area, buf->addr);
+		dma_free_wc(pcm->card->dev, buf->bytes, buf->area, buf->addr);
 		buf->area = NULL;
 	}
 }
_

Patches currently in -mm which might be from mcgrof@suse.com are

dma-rename-dma__writecombine-to-dma__wc.patch

