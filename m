From: akpm@linux-foundation.org
Subject: +
 drm-exynos-convert-g2d_userptr_get_dma_addr-to-use-get_vaddr_frames.patch
 added to -mm tree
Date: Wed, 10 Jun 2015 14:16:26 -0700
Message-ID: <5578a92a.s7eJF7PdXd429jeK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58208 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382AbbFJVQ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Jun 2015 17:16:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, airlied@linux.ie, fabf@skynet.be, hans.verkuil@cisco.com, inki.dae@samsung.com, jy0922.shim@samsung.com, kgene@kernel.org, kyungmin.park@samsung.com, laurent.pinchart+renesas@ideasonboard.com, m.szyprowski@samsung.com, mchehab@osg.samsung.com, mgorman@suse.de, pawel@osciak.com, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: drm/exynos: convert g2d_userptr_get_dma_addr() to use get_vaddr_frames()
has been added to the -mm tree.  Its filename is
     drm-exynos-convert-g2d_userptr_get_dma_addr-to-use-get_vaddr_frames.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drm-exynos-convert-g2d_userptr_get_dma_addr-to-use-get_vaddr_frames.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drm-exynos-convert-g2d_userptr_get_dma_addr-to-use-get_vaddr_frames.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: drm/exynos: convert g2d_userptr_get_dma_addr() to use get_vaddr_frames()

Convert g2d_userptr_get_dma_addr() to pin pages using get_vaddr_frames(). 
This removes the knowledge about vmas and mmap_sem locking from exynos
driver.  Also it fixes a problem that the function has been mapping user
provided address without holding mmap_sem.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: "Prabhakar Lad" <prabhakar.csengg@gmail.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Inki Dae <inki.dae@samsung.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: Kukjin Kim <kgene@kernel.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Pawel Osciak <pawel@osciak.com>
Cc: Seung-Woo Kim <sw0312.kim@samsung.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/exynos/exynos_drm_g2d.c |   91 ++++++--------------
 drivers/gpu/drm/exynos/exynos_drm_gem.c |   97 ----------------------
 2 files changed, 29 insertions(+), 159 deletions(-)

diff -puN drivers/gpu/drm/exynos/exynos_drm_g2d.c~drm-exynos-convert-g2d_userptr_get_dma_addr-to-use-get_vaddr_frames drivers/gpu/drm/exynos/exynos_drm_g2d.c
--- a/drivers/gpu/drm/exynos/exynos_drm_g2d.c~drm-exynos-convert-g2d_userptr_get_dma_addr-to-use-get_vaddr_frames
+++ a/drivers/gpu/drm/exynos/exynos_drm_g2d.c
@@ -190,10 +190,8 @@ struct g2d_cmdlist_userptr {
 	dma_addr_t		dma_addr;
 	unsigned long		userptr;
 	unsigned long		size;
-	struct page		**pages;
-	unsigned int		npages;
+	struct frame_vector	*vec;
 	struct sg_table		*sgt;
-	struct vm_area_struct	*vma;
 	atomic_t		refcount;
 	bool			in_pool;
 	bool			out_of_list;
@@ -363,6 +361,7 @@ static void g2d_userptr_put_dma_addr(str
 {
 	struct g2d_cmdlist_userptr *g2d_userptr =
 					(struct g2d_cmdlist_userptr *)obj;
+	struct page **pages;
 
 	if (!obj)
 		return;
@@ -382,19 +381,21 @@ out:
 	exynos_gem_unmap_sgt_from_dma(drm_dev, g2d_userptr->sgt,
 					DMA_BIDIRECTIONAL);
 
-	exynos_gem_put_pages_to_userptr(g2d_userptr->pages,
-					g2d_userptr->npages,
-					g2d_userptr->vma);
+	pages = frame_vector_pages(g2d_userptr->vec);
+	if (!IS_ERR(pages)) {
+		int i;
 
-	exynos_gem_put_vma(g2d_userptr->vma);
+		for (i = 0; i < frame_vector_count(g2d_userptr->vec); i++)
+			set_page_dirty_lock(pages[i]);
+	}
+	put_vaddr_frames(g2d_userptr->vec);
+	frame_vector_destroy(g2d_userptr->vec);
 
 	if (!g2d_userptr->out_of_list)
 		list_del_init(&g2d_userptr->list);
 
 	sg_free_table(g2d_userptr->sgt);
 	kfree(g2d_userptr->sgt);
-
-	drm_free_large(g2d_userptr->pages);
 	kfree(g2d_userptr);
 }
 
@@ -408,9 +409,7 @@ static dma_addr_t *g2d_userptr_get_dma_a
 	struct exynos_drm_g2d_private *g2d_priv = file_priv->g2d_priv;
 	struct g2d_cmdlist_userptr *g2d_userptr;
 	struct g2d_data *g2d;
-	struct page **pages;
 	struct sg_table	*sgt;
-	struct vm_area_struct *vma;
 	unsigned long start, end;
 	unsigned int npages, offset;
 	int ret;
@@ -456,65 +455,38 @@ static dma_addr_t *g2d_userptr_get_dma_a
 		return ERR_PTR(-ENOMEM);
 
 	atomic_set(&g2d_userptr->refcount, 1);
+	g2d_userptr->size = size;
 
 	start = userptr & PAGE_MASK;
 	offset = userptr & ~PAGE_MASK;
 	end = PAGE_ALIGN(userptr + size);
 	npages = (end - start) >> PAGE_SHIFT;
-	g2d_userptr->npages = npages;
-
-	pages = drm_calloc_large(npages, sizeof(struct page *));
-	if (!pages) {
-		DRM_ERROR("failed to allocate pages.\n");
-		ret = -ENOMEM;
+	g2d_userptr->vec = frame_vector_create(npages);
+	if (!vec)
 		goto err_free;
-	}
 
-	down_read(&current->mm->mmap_sem);
-	vma = find_vma(current->mm, userptr);
-	if (!vma) {
-		up_read(&current->mm->mmap_sem);
-		DRM_ERROR("failed to get vm region.\n");
+	ret = get_vaddr_frames(start, npages, true, true, g2d_userptr->vec);
+	if (ret != npages) {
+		DRM_ERROR("failed to get user pages from userptr.\n");
+		if (ret < 0)
+			goto err_destroy_framevec;
 		ret = -EFAULT;
-		goto err_free_pages;
+		goto err_put_framevec;
 	}
-
-	if (vma->vm_end < userptr + size) {
-		up_read(&current->mm->mmap_sem);
-		DRM_ERROR("vma is too small.\n");
+	if (frame_vector_to_pages(g2d_userptr->vec) < 0) {
 		ret = -EFAULT;
-		goto err_free_pages;
+		goto err_put_framevec;
 	}
 
-	g2d_userptr->vma = exynos_gem_get_vma(vma);
-	if (!g2d_userptr->vma) {
-		up_read(&current->mm->mmap_sem);
-		DRM_ERROR("failed to copy vma.\n");
-		ret = -ENOMEM;
-		goto err_free_pages;
-	}
-
-	g2d_userptr->size = size;
-
-	ret = exynos_gem_get_pages_from_userptr(start & PAGE_MASK,
-						npages, pages, vma);
-	if (ret < 0) {
-		up_read(&current->mm->mmap_sem);
-		DRM_ERROR("failed to get user pages from userptr.\n");
-		goto err_put_vma;
-	}
-
-	up_read(&current->mm->mmap_sem);
-	g2d_userptr->pages = pages;
-
 	sgt = kzalloc(sizeof(*sgt), GFP_KERNEL);
 	if (!sgt) {
 		ret = -ENOMEM;
-		goto err_free_userptr;
+		goto err_put_framevec;
 	}
 
-	ret = sg_alloc_table_from_pages(sgt, pages, npages, offset,
-					size, GFP_KERNEL);
+	ret = sg_alloc_table_from_pages(sgt,
+					frame_vector_pages(g2d_userptr->vec),
+					npages, offset, size, GFP_KERNEL);
 	if (ret < 0) {
 		DRM_ERROR("failed to get sgt from pages.\n");
 		goto err_free_sgt;
@@ -549,16 +521,11 @@ err_sg_free_table:
 err_free_sgt:
 	kfree(sgt);
 
-err_free_userptr:
-	exynos_gem_put_pages_to_userptr(g2d_userptr->pages,
-					g2d_userptr->npages,
-					g2d_userptr->vma);
-
-err_put_vma:
-	exynos_gem_put_vma(g2d_userptr->vma);
+err_put_framevec:
+	put_vaddr_frames(g2d_userptr->vec);
 
-err_free_pages:
-	drm_free_large(pages);
+err_destroy_framevec:
+	frame_vector_destroy(g2d_userptr->vec);
 
 err_free:
 	kfree(g2d_userptr);
diff -puN drivers/gpu/drm/exynos/exynos_drm_gem.c~drm-exynos-convert-g2d_userptr_get_dma_addr-to-use-get_vaddr_frames drivers/gpu/drm/exynos/exynos_drm_gem.c
--- a/drivers/gpu/drm/exynos/exynos_drm_gem.c~drm-exynos-convert-g2d_userptr_get_dma_addr-to-use-get_vaddr_frames
+++ a/drivers/gpu/drm/exynos/exynos_drm_gem.c
@@ -378,103 +378,6 @@ int exynos_drm_gem_get_ioctl(struct drm_
 	return 0;
 }
 
-struct vm_area_struct *exynos_gem_get_vma(struct vm_area_struct *vma)
-{
-	struct vm_area_struct *vma_copy;
-
-	vma_copy = kmalloc(sizeof(*vma_copy), GFP_KERNEL);
-	if (!vma_copy)
-		return NULL;
-
-	if (vma->vm_ops && vma->vm_ops->open)
-		vma->vm_ops->open(vma);
-
-	if (vma->vm_file)
-		get_file(vma->vm_file);
-
-	memcpy(vma_copy, vma, sizeof(*vma));
-
-	vma_copy->vm_mm = NULL;
-	vma_copy->vm_next = NULL;
-	vma_copy->vm_prev = NULL;
-
-	return vma_copy;
-}
-
-void exynos_gem_put_vma(struct vm_area_struct *vma)
-{
-	if (!vma)
-		return;
-
-	if (vma->vm_ops && vma->vm_ops->close)
-		vma->vm_ops->close(vma);
-
-	if (vma->vm_file)
-		fput(vma->vm_file);
-
-	kfree(vma);
-}
-
-int exynos_gem_get_pages_from_userptr(unsigned long start,
-						unsigned int npages,
-						struct page **pages,
-						struct vm_area_struct *vma)
-{
-	int get_npages;
-
-	/* the memory region mmaped with VM_PFNMAP. */
-	if (vma_is_io(vma)) {
-		unsigned int i;
-
-		for (i = 0; i < npages; ++i, start += PAGE_SIZE) {
-			unsigned long pfn;
-			int ret = follow_pfn(vma, start, &pfn);
-			if (ret)
-				return ret;
-
-			pages[i] = pfn_to_page(pfn);
-		}
-
-		if (i != npages) {
-			DRM_ERROR("failed to get user_pages.\n");
-			return -EINVAL;
-		}
-
-		return 0;
-	}
-
-	get_npages = get_user_pages(current, current->mm, start,
-					npages, 1, 1, pages, NULL);
-	get_npages = max(get_npages, 0);
-	if (get_npages != npages) {
-		DRM_ERROR("failed to get user_pages.\n");
-		while (get_npages)
-			put_page(pages[--get_npages]);
-		return -EFAULT;
-	}
-
-	return 0;
-}
-
-void exynos_gem_put_pages_to_userptr(struct page **pages,
-					unsigned int npages,
-					struct vm_area_struct *vma)
-{
-	if (!vma_is_io(vma)) {
-		unsigned int i;
-
-		for (i = 0; i < npages; i++) {
-			set_page_dirty_lock(pages[i]);
-
-			/*
-			 * undo the reference we took when populating
-			 * the table.
-			 */
-			put_page(pages[i]);
-		}
-	}
-}
