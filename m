From: akpm@linux-foundation.org
Subject: +
 media-vb2-convert-vb2_vmalloc_get_userptr-to-use-frame-vector.patch added
 to -mm tree
Date: Wed, 10 Jun 2015 14:16:18 -0700
Message-ID: <5578a922.lVv2Q0UVAq9D0ZXx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58173 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbbFJVQU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Jun 2015 17:16:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, airlied@linux.ie, fabf@skynet.be, hans.verkuil@cisco.com, inki.dae@samsung.com, jy0922.shim@samsung.com, kgene@kernel.org, kyungmin.park@samsung.com, laurent.pinchart+renesas@ideasonboard.com, m.szyprowski@samsung.com, mchehab@osg.samsung.com, mgorman@suse.de, pawel@osciak.com, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: media: vb2: Convert vb2_vmalloc_get_userptr() to use frame vector
has been added to the -mm tree.  Its filename is
     media-vb2-convert-vb2_vmalloc_get_userptr-to-use-frame-vector.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/media-vb2-convert-vb2_vmalloc_get_userptr-to-use-frame-vector.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/media-vb2-convert-vb2_vmalloc_get_userptr-to-use-frame-vector.patch

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
Subject: media: vb2: Convert vb2_vmalloc_get_userptr() to use frame vector

Convert vb2_vmalloc_get_userptr() to use frame vector infrastructure. 
When we are doing that there's no need to allocate page array and some
code can be simplified.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: "Prabhakar Lad" <prabhakar.csengg@gmail.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Inki Dae <inki.dae@samsung.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: Kukjin Kim <kgene@kernel.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Pawel Osciak <pawel@osciak.com>
Cc: Seung-Woo Kim <sw0312.kim@samsung.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/v4l2-core/videobuf2-vmalloc.c |   94 ++++++------------
 1 file changed, 36 insertions(+), 58 deletions(-)

diff -puN drivers/media/v4l2-core/videobuf2-vmalloc.c~media-vb2-convert-vb2_vmalloc_get_userptr-to-use-frame-vector drivers/media/v4l2-core/videobuf2-vmalloc.c
--- a/drivers/media/v4l2-core/videobuf2-vmalloc.c~media-vb2-convert-vb2_vmalloc_get_userptr-to-use-frame-vector
+++ a/drivers/media/v4l2-core/videobuf2-vmalloc.c
@@ -23,11 +23,9 @@
 
 struct vb2_vmalloc_buf {
 	void				*vaddr;
-	struct page			**pages;
-	struct vm_area_struct		*vma;
+	struct frame_vector		*vec;
 	enum dma_data_direction		dma_dir;
 	unsigned long			size;
-	unsigned int			n_pages;
 	atomic_t			refcount;
 	struct vb2_vmarea_handler	handler;
 	struct dma_buf			*dbuf;
@@ -76,10 +74,8 @@ static void *vb2_vmalloc_get_userptr(voi
 				     enum dma_data_direction dma_dir)
 {
 	struct vb2_vmalloc_buf *buf;
-	unsigned long first, last;
-	int n_pages, offset;
-	struct vm_area_struct *vma;
-	dma_addr_t physp;
+	struct frame_vector *vec;
+	int n_pages, offset, i;
 
 	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
 	if (!buf)
@@ -88,53 +84,36 @@ static void *vb2_vmalloc_get_userptr(voi
 	buf->dma_dir = dma_dir;
 	offset = vaddr & ~PAGE_MASK;
 	buf->size = size;
-
-	down_read(&current->mm->mmap_sem);
-	vma = find_vma(current->mm, vaddr);
-	if (vma && (vma->vm_flags & VM_PFNMAP) && (vma->vm_pgoff)) {
-		if (vb2_get_contig_userptr(vaddr, size, &vma, &physp))
-			goto fail_pages_array_alloc;
-		buf->vma = vma;
-		buf->vaddr = (__force void *)ioremap_nocache(physp, size);
-		if (!buf->vaddr)
-			goto fail_pages_array_alloc;
+	vec = vb2_create_framevec(vaddr, size, dma_dir == DMA_FROM_DEVICE);
+	if (IS_ERR(vec))
+		goto fail_pfnvec_create;
+	buf->vec = vec;
+	n_pages = frame_vector_count(vec);
+	if (frame_vector_to_pages(vec) < 0) {
+		unsigned long *nums = frame_vector_pfns(vec);
+
+		/*
+		 * We cannot get page pointers for these pfns. Check memory is
+		 * physically contiguous and use direct mapping.
+		 */
+		for (i = 1; i < n_pages; i++)
+			if (nums[i-1] + 1 != nums[i])
+				goto fail_map;
+		buf->vaddr = (__force void *)
+				ioremap_nocache(nums[0] << PAGE_SHIFT, size);
 	} else {
-		first = vaddr >> PAGE_SHIFT;
-		last  = (vaddr + size - 1) >> PAGE_SHIFT;
-		buf->n_pages = last - first + 1;
-		buf->pages = kzalloc(buf->n_pages * sizeof(struct page *),
-				     GFP_KERNEL);
-		if (!buf->pages)
-			goto fail_pages_array_alloc;
-
-		/* current->mm->mmap_sem is taken by videobuf2 core */
-		n_pages = get_user_pages(current, current->mm,
-					 vaddr & PAGE_MASK, buf->n_pages,
-					 dma_dir == DMA_FROM_DEVICE,
-					 1, /* force */
-					 buf->pages, NULL);
-		if (n_pages != buf->n_pages)
-			goto fail_get_user_pages;
-
-		buf->vaddr = vm_map_ram(buf->pages, buf->n_pages, -1,
+		buf->vaddr = vm_map_ram(frame_vector_pages(vec), n_pages, -1,
 					PAGE_KERNEL);
-		if (!buf->vaddr)
-			goto fail_get_user_pages;
 	}
-	up_read(&current->mm->mmap_sem);
 
+	if (!buf->vaddr)
+		goto fail_map;
 	buf->vaddr += offset;
 	return buf;
 
-fail_get_user_pages:
-	pr_debug("get_user_pages requested/got: %d/%d]\n", n_pages,
-		 buf->n_pages);
-	while (--n_pages >= 0)
-		put_page(buf->pages[n_pages]);
-	kfree(buf->pages);
-
-fail_pages_array_alloc:
-	up_read(&current->mm->mmap_sem);
+fail_map:
+	vb2_destroy_framevec(vec);
+fail_pfnvec_create:
 	kfree(buf);
 
 	return NULL;
@@ -145,22 +124,21 @@ static void vb2_vmalloc_put_userptr(void
 	struct vb2_vmalloc_buf *buf = buf_priv;
 	unsigned long vaddr = (unsigned long)buf->vaddr & PAGE_MASK;
 	unsigned int i;
+	struct page **pages;
+	unsigned int n_pages;
 
-	down_read(&current->mm->mmap_sem);
-	if (buf->pages) {
+	if (!buf->vec->is_pfns) {
+		n_pages = frame_vector_count(buf->vec);
+		pages = frame_vector_pages(buf->vec);
 		if (vaddr)
-			vm_unmap_ram((void *)vaddr, buf->n_pages);
-		for (i = 0; i < buf->n_pages; ++i) {
-			if (buf->dma_dir == DMA_FROM_DEVICE)
-				set_page_dirty_lock(buf->pages[i]);
-			put_page(buf->pages[i]);
-		}
-		kfree(buf->pages);
+			vm_unmap_ram((void *)vaddr, n_pages);
+		if (buf->dma_dir == DMA_FROM_DEVICE)
+			for (i = 0; i < n_pages; i++)
+				set_page_dirty_lock(pages[i]);
 	} else {
-		vb2_put_vma(buf->vma);
 		iounmap((__force void __iomem *)buf->vaddr);
 	}
-	up_read(&current->mm->mmap_sem);
+	vb2_destroy_framevec(buf->vec);
 	kfree(buf);
 }
 
_

Patches currently in -mm which might be from jack@suse.cz are

revert-ufs-fix-deadlocks-introduced-by-sb-mutex-merge.patch
ufs-restore-s_lock-mutex.patch
fsnotify-remove-obsolete-documentation.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
linux-next.patch
mm-provide-new-get_vaddr_frames-helper.patch
media-omap_vout-convert-omap_vout_uservirt_to_phys-to-use-get_vaddr_pfns.patch
vb2-provide-helpers-for-mapping-virtual-addresses.patch
media-vb2-convert-vb2_dma_sg_get_userptr-to-use-frame-vector.patch
media-vb2-convert-vb2_vmalloc_get_userptr-to-use-frame-vector.patch
media-vb2-convert-vb2_dc_get_userptr-to-use-frame-vector.patch
media-vb2-remove-unused-functions.patch
drm-exynos-convert-g2d_userptr_get_dma_addr-to-use-get_vaddr_frames.patch
mm-move-get_vaddr_frames-behind-a-config-option.patch
mm-add-strictlimit-knob-v2.patch

