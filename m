From: akpm@linux-foundation.org
Subject: + fbdev-add-mutex-for-fb_mmap-locking.patch added to -mm tree
Date: Tue, 23 Jun 2009 15:43:06 -0700
Message-ID: <200906232243.n5NMh6mf011022@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752913AbZFWWnJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jun 2009 18:43:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, a.p.zijlstra@chello.nl


The patch titled
     fbdev: add mutex for fb_mmap locking
has been added to the -mm tree.  Its filename is
     fbdev-add-mutex-for-fb_mmap-locking.patch

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
Subject: fbdev: add mutex for fb_mmap locking
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Add a mutex to avoid a circular locking problem between the mm layer
semaphore and fbdev ioctl mutex through the fb_mmap() call.

Also, add mutex to all places where smem_start and smem_len fields change
so the mutex inside the fb_mmap() is actually used.  Changing of these
fields before calling the framebuffer_register() are not mutexed.

This is 2.6.31 material.  It removes one lockdep (fb_mmap() and
register_framebuffer()) but there is still another one (fb_release() and
register_framebuffer()).  It also cleans up handling of the smem_start and
smem_len fields used by mutexed section of the fb_mmap().

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/atafb.c                 |    7 ++++++-
 drivers/video/atmel_lcdfb.c           |    2 ++
 drivers/video/fbmem.c                 |   13 +++++--------
 drivers/video/fsl-diu-fb.c            |   14 +++++++++-----
 drivers/video/i810/i810_main.c        |    2 ++
 drivers/video/matrox/matroxfb_base.c  |    3 +++
 drivers/video/matrox/matroxfb_crtc2.c |    5 ++++-
 drivers/video/mx3fb.c                 |   17 +++++++++++------
 drivers/video/omap/omapfb_main.c      |    4 ++++
 drivers/video/platinumfb.c            |    2 ++
 drivers/video/pxafb.c                 |    2 ++
 drivers/video/sh7760fb.c              |   19 ++++++-------------
 drivers/video/sis/sis_main.c          |    2 ++
 drivers/video/sm501fb.c               |   21 +++++++++++++--------
 drivers/video/w100fb.c                |    2 ++
 include/linux/fb.h                    |    1 +
 16 files changed, 74 insertions(+), 42 deletions(-)

diff -puN drivers/video/atafb.c~fbdev-add-mutex-for-fb_mmap-locking drivers/video/atafb.c
--- a/drivers/video/atafb.c~fbdev-add-mutex-for-fb_mmap-locking
+++ a/drivers/video/atafb.c
@@ -2414,7 +2414,10 @@ static int atafb_get_fix(struct fb_fix_s
 	if (err)
 		return err;
 	memset(fix, 0, sizeof(struct fb_fix_screeninfo));
-	return fbhw->encode_fix(fix, &par);
+	mutex_lock(&info->mm_lock);
+	err = fbhw->encode_fix(fix, &par);
+	mutex_unlock(&info->mm_lock);
+	return err;
 }
 
 static int atafb_get_var(struct fb_var_screeninfo *var, struct fb_info *info)
@@ -2743,7 +2746,9 @@ static int atafb_set_par(struct fb_info 
 
 	/* Decode wanted screen parameters */
 	fbhw->decode_var(&info->var, par);
+	mutex_lock(&info->mm_lock);
 	fbhw->encode_fix(&info->fix, par);
+	mutex_unlock(&info->mm_lock);
 
 	/* Set new videomode */
 	ata_set_par(par);
diff -puN drivers/video/atmel_lcdfb.c~fbdev-add-mutex-for-fb_mmap-locking drivers/video/atmel_lcdfb.c
--- a/drivers/video/atmel_lcdfb.c~fbdev-add-mutex-for-fb_mmap-locking
+++ a/drivers/video/atmel_lcdfb.c
@@ -270,7 +270,9 @@ static int atmel_lcdfb_alloc_video_memor
 
 	smem_len = (var->xres_virtual * var->yres_virtual
 		    * ((var->bits_per_pixel + 7) / 8));
+	mutex_lock(&info->mm_lock);
 	info->fix.smem_len = max(smem_len, sinfo->smem_len);
+	mutex_unlock(&info->mm_lock);
 
 	info->screen_base = dma_alloc_writecombine(info->device, info->fix.smem_len,
 					(dma_addr_t *)&info->fix.smem_start, GFP_KERNEL);
diff -puN drivers/video/fbmem.c~fbdev-add-mutex-for-fb_mmap-locking drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fbdev-add-mutex-for-fb_mmap-locking
+++ a/drivers/video/fbmem.c
@@ -1310,8 +1310,6 @@ static long fb_compat_ioctl(struct file 
 
 static int
 fb_mmap(struct file *file, struct vm_area_struct * vma)
-__acquires(&info->lock)
-__releases(&info->lock)
 {
 	int fbidx = iminor(file->f_path.dentry->d_inode);
 	struct fb_info *info = registered_fb[fbidx];
@@ -1325,16 +1323,14 @@ __releases(&info->lock)
 	off = vma->vm_pgoff << PAGE_SHIFT;
 	if (!fb)
 		return -ENODEV;
+	mutex_lock(&info->mm_lock);
 	if (fb->fb_mmap) {
 		int res;
-		mutex_lock(&info->lock);
 		res = fb->fb_mmap(info, vma);
-		mutex_unlock(&info->lock);
+		mutex_unlock(&info->mm_lock);
 		return res;
 	}
 
-	mutex_lock(&info->lock);
-
 	/* frame buffer memory */
 	start = info->fix.smem_start;
 	len = PAGE_ALIGN((start & ~PAGE_MASK) + info->fix.smem_len);
@@ -1342,13 +1338,13 @@ __releases(&info->lock)
 		/* memory mapped io */
 		off -= len;
 		if (info->var.accel_flags) {
-			mutex_unlock(&info->lock);
+			mutex_unlock(&info->mm_lock);
 			return -EINVAL;
 		}
 		start = info->fix.mmio_start;
 		len = PAGE_ALIGN((start & ~PAGE_MASK) + info->fix.mmio_len);
 	}
-	mutex_unlock(&info->lock);
+	mutex_unlock(&info->mm_lock);
 	start &= PAGE_MASK;
 	if ((vma->vm_end - vma->vm_start + off) > len)
 		return -EINVAL;
@@ -1518,6 +1514,7 @@ register_framebuffer(struct fb_info *fb_
 			break;
 	fb_info->node = i;
 	mutex_init(&fb_info->lock);
+	mutex_init(&fb_info->mm_lock);
 
 	fb_info->dev = device_create(fb_class, fb_info->device,
 				     MKDEV(FB_MAJOR, i), NULL, "fb%d", i);
diff -puN drivers/video/fsl-diu-fb.c~fbdev-add-mutex-for-fb_mmap-locking drivers/video/fsl-diu-fb.c
--- a/drivers/video/fsl-diu-fb.c~fbdev-add-mutex-for-fb_mmap-locking
+++ a/drivers/video/fsl-diu-fb.c
@@ -750,24 +750,26 @@ static void update_lcdc(struct fb_info *
 static int map_video_memory(struct fb_info *info)
 {
 	phys_addr_t phys;
+	u32 smem_len = info->fix.line_length * info->var.yres_virtual;
 
 	pr_debug("info->var.xres_virtual = %d\n", info->var.xres_virtual);
 	pr_debug("info->var.yres_virtual = %d\n", info->var.yres_virtual);
 	pr_debug("info->fix.line_length  = %d\n", info->fix.line_length);
+	pr_debug("MAP_VIDEO_MEMORY: smem_len = %u\n", smem_len);
 
-	info->fix.smem_len = info->fix.line_length * info->var.yres_virtual;
-	pr_debug("MAP_VIDEO_MEMORY: smem_len = %d\n", info->fix.smem_len);
-	info->screen_base = fsl_diu_alloc(info->fix.smem_len, &phys);
+	info->screen_base = fsl_diu_alloc(smem_len, &phys);
 	if (info->screen_base == NULL) {
 		printk(KERN_ERR "Unable to allocate fb memory\n");
 		return -ENOMEM;
 	}
+	mutex_lock(&info->mm_lock);
 	info->fix.smem_start = (unsigned long) phys;
+	info->fix.smem_len = smem_len;
+	mutex_unlock(&info->mm_lock);
 	info->screen_size = info->fix.smem_len;
 
 	pr_debug("Allocated fb @ paddr=0x%08lx, size=%d.\n",
-				info->fix.smem_start,
-		info->fix.smem_len);
+		 info->fix.smem_start, info->fix.smem_len);
 	pr_debug("screen base %p\n", info->screen_base);
 
 	return 0;
@@ -776,9 +778,11 @@ static int map_video_memory(struct fb_in
 static void unmap_video_memory(struct fb_info *info)
 {
 	fsl_diu_free(info->screen_base, info->fix.smem_len);
+	mutex_lock(&info->mm_lock);
 	info->screen_base = NULL;
 	info->fix.smem_start = 0;
 	info->fix.smem_len = 0;
+	mutex_unlock(&info->mm_lock);
 }
 
 /*
diff -puN drivers/video/i810/i810_main.c~fbdev-add-mutex-for-fb_mmap-locking drivers/video/i810/i810_main.c
--- a/drivers/video/i810/i810_main.c~fbdev-add-mutex-for-fb_mmap-locking
+++ a/drivers/video/i810/i810_main.c
@@ -1090,8 +1090,10 @@ static int encode_fix(struct fb_fix_scre
     	memset(fix, 0, sizeof(struct fb_fix_screeninfo));
 
     	strcpy(fix->id, "I810");
+	mutex_lock(&info->mm_lock);
     	fix->smem_start = par->fb.physical;
     	fix->smem_len = par->fb.size;
+	mutex_unlock(&info->mm_lock);
     	fix->type = FB_TYPE_PACKED_PIXELS;
     	fix->type_aux = 0;
 	fix->xpanstep = 8;
diff -puN drivers/video/matrox/matroxfb_base.c~fbdev-add-mutex-for-fb_mmap-locking drivers/video/matrox/matroxfb_base.c
--- a/drivers/video/matrox/matroxfb_base.c~fbdev-add-mutex-for-fb_mmap-locking
+++ a/drivers/video/matrox/matroxfb_base.c
@@ -724,8 +724,10 @@ static void matroxfb_update_fix(WPMINFO2
 	struct fb_fix_screeninfo *fix = &ACCESS_FBINFO(fbcon).fix;
 	DBG(__func__)
 
+	mutex_lock(&ACCESS_FBINFO(fbcon).mm_lock);
 	fix->smem_start = ACCESS_FBINFO(video.base) + ACCESS_FBINFO(curr.ydstorg.bytes);
 	fix->smem_len = ACCESS_FBINFO(video.len_usable) - ACCESS_FBINFO(curr.ydstorg.bytes);
+	mutex_unlock(&ACCESS_FBINFO(fbcon).mm_lock);
 }
 
 static int matroxfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
@@ -2081,6 +2083,7 @@ static int matroxfb_probe(struct pci_dev
 	spin_lock_init(&ACCESS_FBINFO(lock.accel));
 	init_rwsem(&ACCESS_FBINFO(crtc2.lock));
 	init_rwsem(&ACCESS_FBINFO(altout.lock));
+	mutex_init(&ACCESS_FBINFO(fbcon).mm_lock);
 	ACCESS_FBINFO(irq_flags) = 0;
 	init_waitqueue_head(&ACCESS_FBINFO(crtc1.vsync.wait));
 	init_waitqueue_head(&ACCESS_FBINFO(crtc2.vsync.wait));
diff -puN drivers/video/matrox/matroxfb_crtc2.c~fbdev-add-mutex-for-fb_mmap-locking drivers/video/matrox/matroxfb_crtc2.c
--- a/drivers/video/matrox/matroxfb_crtc2.c~fbdev-add-mutex-for-fb_mmap-locking
+++ a/drivers/video/matrox/matroxfb_crtc2.c
@@ -289,13 +289,16 @@ static int matroxfb_dh_release(struct fb
 #undef m2info
 }
 
-static void matroxfb_dh_init_fix(struct matroxfb_dh_fb_info *m2info) {
+static void matroxfb_dh_init_fix(struct matroxfb_dh_fb_info *m2info)
+{
 	struct fb_fix_screeninfo *fix = &m2info->fbcon.fix;
 
 	strcpy(fix->id, "MATROX DH");
 
+	mutex_lock(&m2info->fbcon.mm_lock);
 	fix->smem_start = m2info->video.base;
 	fix->smem_len = m2info->video.len_usable;
+	mutex_unlock(&m2info->fbcon.mm_lock);
 	fix->ypanstep = 1;
 	fix->ywrapstep = 0;
 	fix->xpanstep = 8;	/* TBD */
diff -puN drivers/video/mx3fb.c~fbdev-add-mutex-for-fb_mmap-locking drivers/video/mx3fb.c
--- a/drivers/video/mx3fb.c~fbdev-add-mutex-for-fb_mmap-locking
+++ a/drivers/video/mx3fb.c
@@ -669,7 +669,7 @@ static uint32_t bpp_to_pixfmt(int bpp)
 }
 
 static int mx3fb_blank(int blank, struct fb_info *fbi);
-static int mx3fb_map_video_memory(struct fb_info *fbi);
+static int mx3fb_map_video_memory(struct fb_info *fbi, unsigned int mem_len);
 static int mx3fb_unmap_video_memory(struct fb_info *fbi);
 
 /**
@@ -742,8 +742,7 @@ static int mx3fb_set_par(struct fb_info 
 		if (fbi->fix.smem_start)
 			mx3fb_unmap_video_memory(fbi);
 
-		fbi->fix.smem_len = mem_len;
-		if (mx3fb_map_video_memory(fbi) < 0) {
+		if (mx3fb_map_video_memory(fbi, mem_len) < 0) {
 			mutex_unlock(&mx3_fbi->mutex);
 			return -ENOMEM;
 		}
@@ -1198,6 +1197,7 @@ static int mx3fb_resume(struct platform_
 /**
  * mx3fb_map_video_memory() - allocates the DRAM memory for the frame buffer.
  * @fbi:	framebuffer information pointer
+ * @mem_len:	length of mapped memory
  * @return:	Error code indicating success or failure
  *
  * This buffer is remapped into a non-cached, non-buffered, memory region to
@@ -1205,23 +1205,26 @@ static int mx3fb_resume(struct platform_
  * area is remapped, all virtual memory access to the video memory should occur
  * at the new region.
  */
-static int mx3fb_map_video_memory(struct fb_info *fbi)
+static int mx3fb_map_video_memory(struct fb_info *fbi, unsigned int mem_len)
 {
 	int retval = 0;
 	dma_addr_t addr;
 
 	fbi->screen_base = dma_alloc_writecombine(fbi->device,
-						  fbi->fix.smem_len,
+						  mem_len,
 						  &addr, GFP_DMA);
 
 	if (!fbi->screen_base) {
 		dev_err(fbi->device, "Cannot allocate %u bytes framebuffer memory\n",
-			fbi->fix.smem_len);
+			mem_len);
 		retval = -EBUSY;
 		goto err0;
 	}
 
+	mutex_lock(&fbi->mm_lock);
 	fbi->fix.smem_start = addr;
+	fbi->fix.smem_len = mem_len;
+	mutex_unlock(&fbi->mm_lock);
 
 	dev_dbg(fbi->device, "allocated fb @ p=0x%08x, v=0x%p, size=%d.\n",
 		(uint32_t) fbi->fix.smem_start, fbi->screen_base, fbi->fix.smem_len);
@@ -1251,8 +1254,10 @@ static int mx3fb_unmap_video_memory(stru
 			      fbi->screen_base, fbi->fix.smem_start);
 
 	fbi->screen_base = 0;
+	mutex_lock(&fbi->mm_lock);
 	fbi->fix.smem_start = 0;
 	fbi->fix.smem_len = 0;
+	mutex_unlock(&fbi->mm_lock);
 	return 0;
 }
 
diff -puN drivers/video/omap/omapfb_main.c~fbdev-add-mutex-for-fb_mmap-locking drivers/video/omap/omapfb_main.c
--- a/drivers/video/omap/omapfb_main.c~fbdev-add-mutex-for-fb_mmap-locking
+++ a/drivers/video/omap/omapfb_main.c
@@ -393,8 +393,10 @@ static void set_fb_fix(struct fb_info *f
 
 	rg = &plane->fbdev->mem_desc.region[plane->idx];
 	fbi->screen_base	= rg->vaddr;
+	mutex_lock(&fbi->mm_lock);
 	fix->smem_start		= rg->paddr;
 	fix->smem_len		= rg->size;
+	mutex_unlock(&fbi->mm_lock);
 
 	fix->type = FB_TYPE_PACKED_PIXELS;
 	bpp = var->bits_per_pixel;
@@ -886,8 +888,10 @@ static int omapfb_setup_mem(struct fb_in
 				 * plane memory is dealloce'd, the other
 				 * screen parameters in var / fix are invalid.
 				 */
+				mutex_lock(&fbi->mm_lock);
 				fbi->fix.smem_start = 0;
 				fbi->fix.smem_len = 0;
+				mutex_unlock(&fbi->mm_lock);
 			}
 		}
 	}
diff -puN drivers/video/platinumfb.c~fbdev-add-mutex-for-fb_mmap-locking drivers/video/platinumfb.c
--- a/drivers/video/platinumfb.c~fbdev-add-mutex-for-fb_mmap-locking
+++ a/drivers/video/platinumfb.c
@@ -141,7 +141,9 @@ static int platinumfb_set_par (struct fb
   		offset = 0x10;
 
 	info->screen_base = pinfo->frame_buffer + init->fb_offset + offset;
+	mutex_lock(&info->mm_lock);
 	info->fix.smem_start = (pinfo->frame_buffer_phys) + init->fb_offset + offset;
+	mutex_unlock(&info->mm_lock);
 	info->fix.visual = (pinfo->cmode == CMODE_8) ?
 		FB_VISUAL_PSEUDOCOLOR : FB_VISUAL_DIRECTCOLOR;
  	info->fix.line_length = vmode_attrs[pinfo->vmode-1].hres * (1<<pinfo->cmode)
diff -puN drivers/video/pxafb.c~fbdev-add-mutex-for-fb_mmap-locking drivers/video/pxafb.c
--- a/drivers/video/pxafb.c~fbdev-add-mutex-for-fb_mmap-locking
+++ a/drivers/video/pxafb.c
@@ -815,8 +815,10 @@ static int overlayfb_map_video_memory(st
 	ofb->video_mem_phys = virt_to_phys(ofb->video_mem);
 	ofb->video_mem_size = size;
 
+	mutex_lock(&ofb->fb.mm_lock);
 	ofb->fb.fix.smem_start	= ofb->video_mem_phys;
 	ofb->fb.fix.smem_len	= ofb->fb.fix.line_length * var->yres_virtual;
+	mutex_unlock(&ofb->fb.mm_lock);
 	ofb->fb.screen_base	= ofb->video_mem;
 	return 0;
 }
diff -puN drivers/video/sh7760fb.c~fbdev-add-mutex-for-fb_mmap-locking drivers/video/sh7760fb.c
--- a/drivers/video/sh7760fb.c~fbdev-add-mutex-for-fb_mmap-locking
+++ a/drivers/video/sh7760fb.c
@@ -120,18 +120,6 @@ static int sh7760_setcolreg (u_int regno
 	return 0;
 }
 
-static void encode_fix(struct fb_fix_screeninfo *fix, struct fb_info *info,
-		       unsigned long stride)
-{
-	memset(fix, 0, sizeof(struct fb_fix_screeninfo));
-	strcpy(fix->id, "sh7760-lcdc");
-
-	fix->smem_start = (unsigned long)info->screen_base;
-	fix->smem_len = info->screen_size;
-
-	fix->line_length = stride;
-}
-
 static int sh7760fb_get_color_info(struct device *dev,
 				   u16 lddfr, int *bpp, int *gray)
 {
@@ -334,7 +322,8 @@ static int sh7760fb_set_par(struct fb_in
 
 	iowrite32(ldsarl, par->base + LDSARL);	/* mem for lower half of DSTN */
 
-	encode_fix(&info->fix, info, stride);
+	info->fix.line_length = stride;
+
 	sh7760fb_check_var(&info->var, info);
 
 	sh7760fb_blank(FB_BLANK_UNBLANK, info);	/* panel on! */
@@ -435,6 +424,8 @@ static int sh7760fb_alloc_mem(struct fb_
 
 	info->screen_base = fbmem;
 	info->screen_size = vram;
+	info->fix.smem_start = (unsigned long)info->screen_base;
+	info->fix.smem_len = info->screen_size;
 
 	return 0;
 }
@@ -520,6 +511,8 @@ static int __devinit sh7760fb_probe(stru
 	info->var.transp.length = 0;
 	info->var.transp.msb_right = 0;
 
+	strcpy(info->fix.id, "sh7760-lcdc");
+
 	/* set the DON2 bit now, before cmap allocation, as it will randomize
 	 * palette memory.
 	 */
diff -puN drivers/video/sis/sis_main.c~fbdev-add-mutex-for-fb_mmap-locking drivers/video/sis/sis_main.c
--- a/drivers/video/sis/sis_main.c~fbdev-add-mutex-for-fb_mmap-locking
+++ a/drivers/video/sis/sis_main.c
@@ -1847,8 +1847,10 @@ sisfb_get_fix(struct fb_fix_screeninfo *
 
 	strcpy(fix->id, ivideo->myid);
 
+	mutex_lock(&info->mm_lock);
 	fix->smem_start  = ivideo->video_base + ivideo->video_offset;
 	fix->smem_len    = ivideo->sisfb_mem;
+	mutex_unlock(&info->mm_lock);
 	fix->type        = FB_TYPE_PACKED_PIXELS;
 	fix->type_aux    = 0;
 	fix->visual      = (ivideo->video_bpp == 8) ? FB_VISUAL_PSEUDOCOLOR : FB_VISUAL_TRUECOLOR;
diff -puN drivers/video/sm501fb.c~fbdev-add-mutex-for-fb_mmap-locking drivers/video/sm501fb.c
--- a/drivers/video/sm501fb.c~fbdev-add-mutex-for-fb_mmap-locking
+++ a/drivers/video/sm501fb.c
@@ -145,7 +145,7 @@ static inline void sm501fb_sync_regs(str
 #define SM501_MEMF_ACCEL		(8)
 
 static int sm501_alloc_mem(struct sm501fb_info *inf, struct sm501_mem *mem,
-			   unsigned int why, size_t size)
+			   unsigned int why, size_t size, u32 smem_len)
 {
 	struct sm501fb_par *par;
 	struct fb_info *fbi;
@@ -172,7 +172,7 @@ static int sm501_alloc_mem(struct sm501f
 		if (ptr > 0)
 			ptr &= ~(PAGE_SIZE - 1);
 
-		if (fbi && ptr < fbi->fix.smem_len)
+		if (fbi && ptr < smem_len)
 			return -ENOMEM;
 
 		break;
@@ -197,7 +197,7 @@ static int sm501_alloc_mem(struct sm501f
 
 	case SM501_MEMF_ACCEL:
 		fbi = inf->fb[HEAD_CRT];
-		ptr = fbi ? fbi->fix.smem_len : 0;
+		ptr = fbi ? smem_len : 0;
 
 		fbi = inf->fb[HEAD_PANEL];
 		if (fbi) {
@@ -413,6 +413,7 @@ static int sm501fb_set_par_common(struct
 	unsigned int mem_type;
 	unsigned int clock_type;
 	unsigned int head_addr;
+	unsigned int smem_len;
 
 	dev_dbg(fbi->dev, "%s: %dx%d, bpp = %d, virtual %dx%d\n",
 		__func__, var->xres, var->yres, var->bits_per_pixel,
@@ -453,18 +454,20 @@ static int sm501fb_set_par_common(struct
 
 	/* allocate fb memory within 501 */
 	info->fix.line_length = (var->xres_virtual * var->bits_per_pixel)/8;
-	info->fix.smem_len    = info->fix.line_length * var->yres_virtual;
+	smem_len = info->fix.line_length * var->yres_virtual;
 
 	dev_dbg(fbi->dev, "%s: line length = %u\n", __func__,
 		info->fix.line_length);
 
-	if (sm501_alloc_mem(fbi, &par->screen, mem_type,
-			    info->fix.smem_len)) {
+	if (sm501_alloc_mem(fbi, &par->screen, mem_type, smem_len, smem_len)) {
 		dev_err(fbi->dev, "no memory available\n");
 		return -ENOMEM;
 	}
 
+	mutex_lock(&info->mm_lock);
 	info->fix.smem_start = fbi->fbmem_res->start + par->screen.sm_addr;
+	info->fix.smem_len   = smem_len;
+	mutex_unlock(&info->mm_lock);
 
 	info->screen_base = fbi->fbmem + par->screen.sm_addr;
 	info->screen_size = info->fix.smem_len;
@@ -637,7 +640,8 @@ static int sm501fb_set_par_crt(struct fb
 	if ((control & SM501_DC_CRT_CONTROL_SEL) == 0) {
 		/* the head is displaying panel data... */
 
-		sm501_alloc_mem(fbi, &par->screen, SM501_MEMF_CRT, 0);
+		sm501_alloc_mem(fbi, &par->screen, SM501_MEMF_CRT, 0,
+				info->fix.smem_len);
 		goto out_update;
 	}
 
@@ -1289,7 +1293,8 @@ static int sm501_init_cursor(struct fb_i
 
 	par->cursor_regs = info->regs + reg_base;
 
-	ret = sm501_alloc_mem(info, &par->cursor, SM501_MEMF_CURSOR, 1024);
+	ret = sm501_alloc_mem(info, &par->cursor, SM501_MEMF_CURSOR, 1024,
+			      fbi->fix.smem_len);
 	if (ret < 0)
 		return ret;
 
diff -puN drivers/video/w100fb.c~fbdev-add-mutex-for-fb_mmap-locking drivers/video/w100fb.c
--- a/drivers/video/w100fb.c~fbdev-add-mutex-for-fb_mmap-locking
+++ a/drivers/video/w100fb.c
@@ -523,6 +523,7 @@ static int w100fb_set_par(struct fb_info
 		info->fix.ywrapstep = 0;
 		info->fix.line_length = par->xres * BITS_PER_PIXEL / 8;
 
+		mutex_lock(&info->mm_lock);
 		if ((par->xres*par->yres*BITS_PER_PIXEL/8) > (MEM_INT_SIZE+1)) {
 			par->extmem_active = 1;
 			info->fix.smem_len = par->mach->mem->size+1;
@@ -530,6 +531,7 @@ static int w100fb_set_par(struct fb_info
 			par->extmem_active = 0;
 			info->fix.smem_len = MEM_INT_SIZE+1;
 		}
+		mutex_unlock(&info->mm_lock);
 
 		w100fb_activate_var(par);
 	}
diff -puN include/linux/fb.h~fbdev-add-mutex-for-fb_mmap-locking include/linux/fb.h
--- a/include/linux/fb.h~fbdev-add-mutex-for-fb_mmap-locking
+++ a/include/linux/fb.h
@@ -819,6 +819,7 @@ struct fb_info {
 	int node;
 	int flags;
 	struct mutex lock;		/* Lock for open/release/ioctl funcs */
+	struct mutex mm_lock;		/* Lock for fb_mmap and smem_* fields */
 	struct fb_var_screeninfo var;	/* Current var */
 	struct fb_fix_screeninfo fix;	/* Current fix */
 	struct fb_monspecs monspecs;	/* Current Monitor specs */
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
fbdev-add-mutex-for-fb_mmap-locking.patch
intelfb-fix-setting-of-active-pipe-with-lvds-displays.patch

