From: akpm@linux-foundation.org
Subject: + fbdev-bf54x-lq043fb-bfin-t350mcqb-fb-drop-custom-mmap-handler.patch added to -mm tree
Date: Wed, 30 Dec 2009 13:30:41 -0800
Message-ID: <200912302130.nBULUfAY003407@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59317 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753571AbZL3Vaq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Dec 2009 16:30:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael.hennerich@analog.com, vapier@gentoo.org


The patch titled
     fbdev: bf54x-lq043fb/bfin-t350mcqb-fb: drop custom mmap() handler
has been added to the -mm tree.  Its filename is
     fbdev-bf54x-lq043fb-bfin-t350mcqb-fb-drop-custom-mmap-handler.patch

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
Subject: fbdev: bf54x-lq043fb/bfin-t350mcqb-fb: drop custom mmap() handler
From: Michael Hennerich <michael.hennerich@analog.com>

The common Blackfin code implements the get_fb_unmapped_area() function,
so we no longer need to have our own mmap() handler.  The common fb code
will take care of everything for us now.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/bf54x-lq043fb.c    |   30 -----------------------------
 drivers/video/bfin-t350mcqb-fb.c |   29 ----------------------------
 2 files changed, 59 deletions(-)

diff -puN drivers/video/bf54x-lq043fb.c~fbdev-bf54x-lq043fb-bfin-t350mcqb-fb-drop-custom-mmap-handler drivers/video/bf54x-lq043fb.c
--- a/drivers/video/bf54x-lq043fb.c~fbdev-bf54x-lq043fb-bfin-t350mcqb-fb-drop-custom-mmap-handler
+++ a/drivers/video/bf54x-lq043fb.c
@@ -82,7 +82,6 @@ struct bfin_bf54xfb_info {
 	unsigned char *fb_buffer;	/* RGB Buffer */
 
 	dma_addr_t dma_handle;
-	int lq043_mmap;
 	int lq043_open_cnt;
 	int irq;
 	spinlock_t lock;	/* lock */
@@ -316,7 +315,6 @@ static int bfin_bf54x_fb_release(struct 
 	spin_lock(&fbi->lock);
 
 	fbi->lq043_open_cnt--;
-	fbi->lq043_mmap = 0;
 
 	if (fbi->lq043_open_cnt <= 0) {
 
@@ -374,33 +372,6 @@ static int bfin_bf54x_fb_check_var(struc
 	return 0;
 }
 
-static int bfin_bf54x_fb_mmap(struct fb_info *info, struct vm_area_struct *vma)
-{
-
-	struct bfin_bf54xfb_info *fbi = info->par;
-
-	if (fbi->lq043_mmap)
-		return -1;
-
-	spin_lock(&fbi->lock);
-	fbi->lq043_mmap = 1;
-	spin_unlock(&fbi->lock);
-
-	vma->vm_start = (unsigned long)(fbi->fb_buffer);
-
-	vma->vm_end = vma->vm_start + info->fix.smem_len;
-	/* For those who don't understand how mmap works, go read
-	 *   Documentation/nommu-mmap.txt.
-	 * For those that do, you will know that the VM_MAYSHARE flag
-	 * must be set in the vma->vm_flags structure on noMMU
-	 *   Other flags can be set, and are documented in
-	 *   include/linux/mm.h
-	 */
-	vma->vm_flags |=  VM_MAYSHARE | VM_SHARED;
-
-	return 0;
-}
-
 int bfin_bf54x_fb_cursor(struct fb_info *info, struct fb_cursor *cursor)
 {
 	if (nocursor)
@@ -452,7 +423,6 @@ static struct fb_ops bfin_bf54x_fb_ops =
 	.fb_fillrect = cfb_fillrect,
 	.fb_copyarea = cfb_copyarea,
 	.fb_imageblit = cfb_imageblit,
-	.fb_mmap = bfin_bf54x_fb_mmap,
 	.fb_cursor = bfin_bf54x_fb_cursor,
 	.fb_setcolreg = bfin_bf54x_fb_setcolreg,
 };
diff -puN drivers/video/bfin-t350mcqb-fb.c~fbdev-bf54x-lq043fb-bfin-t350mcqb-fb-drop-custom-mmap-handler drivers/video/bfin-t350mcqb-fb.c
--- a/drivers/video/bfin-t350mcqb-fb.c~fbdev-bf54x-lq043fb-bfin-t350mcqb-fb-drop-custom-mmap-handler
+++ a/drivers/video/bfin-t350mcqb-fb.c
@@ -87,7 +87,6 @@ struct bfin_t350mcqbfb_info {
 	struct device *dev;
 	unsigned char *fb_buffer;	/* RGB Buffer */
 	dma_addr_t dma_handle;
-	int lq043_mmap;
 	int lq043_open_cnt;
 	int irq;
 	spinlock_t lock;	/* lock */
@@ -235,7 +234,6 @@ static int bfin_t350mcqb_fb_release(stru
 	spin_lock(&fbi->lock);
 
 	fbi->lq043_open_cnt--;
-	fbi->lq043_mmap = 0;
 
 	if (fbi->lq043_open_cnt <= 0) {
 		bfin_t350mcqb_disable_ppi();
@@ -293,32 +291,6 @@ static int bfin_t350mcqb_fb_check_var(st
 	return 0;
 }
 
-static int bfin_t350mcqb_fb_mmap(struct fb_info *info, struct vm_area_struct *vma)
-{
-	struct bfin_t350mcqbfb_info *fbi = info->par;
-
-	if (fbi->lq043_mmap)
-		return -1;
-
-	spin_lock(&fbi->lock);
-	fbi->lq043_mmap = 1;
-	spin_unlock(&fbi->lock);
-
-	vma->vm_start = (unsigned long)(fbi->fb_buffer + ACTIVE_VIDEO_MEM_OFFSET);
-
-	vma->vm_end = vma->vm_start + info->fix.smem_len;
-	/* For those who don't understand how mmap works, go read
-	 *   Documentation/nommu-mmap.txt.
-	 * For those that do, you will know that the VM_MAYSHARE flag
-	 * must be set in the vma->vm_flags structure on noMMU
-	 *   Other flags can be set, and are documented in
-	 *   include/linux/mm.h
-	 */
-	vma->vm_flags |= VM_MAYSHARE | VM_SHARED;
-
-	return 0;
-}
