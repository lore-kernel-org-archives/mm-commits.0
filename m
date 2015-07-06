From: akpm@linux-foundation.org
Subject: [to-be-updated] media-vb2-remove-unused-functions.patch removed
 from -mm tree
Date: Mon, 06 Jul 2015 15:19:24 -0700
Message-ID: <559afeec.ktgRm4euxafzzTPt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33751 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506AbbGFWTZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 18:19:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, airlied@linux.ie, fabf@skynet.be, hans.verkuil@cisco.com, inki.dae@samsung.com, jy0922.shim@samsung.com, kgene@kernel.org, kyungmin.park@samsung.com, laurent.pinchart+renesas@ideasonboard.com, m.szyprowski@samsung.com, mchehab@osg.samsung.com, mgorman@suse.de, pawel@osciak.com, prabhakar.csengg@gmail.com, sw0312.kim@samsung.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: media: vb2: remove unused functions
has been removed from the -mm tree.  Its filename was
     media-vb2-remove-unused-functions.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: media: vb2: remove unused functions

Conversion to the use of pinned pfns made some functions unused.  Remove
them.  Also there's no need to lock mmap_sem in __buf_prepare() anymore.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>
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

 drivers/media/v4l2-core/videobuf2-memops.c |  114 -------------------
 include/media/videobuf2-memops.h           |    6 -
 2 files changed, 120 deletions(-)

diff -puN drivers/media/v4l2-core/videobuf2-memops.c~media-vb2-remove-unused-functions drivers/media/v4l2-core/videobuf2-memops.c
--- a/drivers/media/v4l2-core/videobuf2-memops.c~media-vb2-remove-unused-functions
+++ a/drivers/media/v4l2-core/videobuf2-memops.c
@@ -23,120 +23,6 @@
 #include <media/videobuf2-memops.h>
 
 /**
- * vb2_get_vma() - acquire and lock the virtual memory area
- * @vma:	given virtual memory area
- *
- * This function attempts to acquire an area mapped in the userspace for
- * the duration of a hardware operation. The area is "locked" by performing
- * the same set of operation that are done when process calls fork() and
- * memory areas are duplicated.
- *
- * Returns a copy of a virtual memory region on success or NULL.
- */
-struct vm_area_struct *vb2_get_vma(struct vm_area_struct *vma)
-{
-	struct vm_area_struct *vma_copy;
-
-	vma_copy = kmalloc(sizeof(*vma_copy), GFP_KERNEL);
-	if (vma_copy == NULL)
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
-EXPORT_SYMBOL_GPL(vb2_get_vma);
-
-/**
- * vb2_put_userptr() - release a userspace virtual memory area
- * @vma:	virtual memory region associated with the area to be released
- *
- * This function releases the previously acquired memory area after a hardware
- * operation.
- */
-void vb2_put_vma(struct vm_area_struct *vma)
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
-EXPORT_SYMBOL_GPL(vb2_put_vma);
-
-/**
- * vb2_get_contig_userptr() - lock physically contiguous userspace mapped memory
- * @vaddr:	starting virtual address of the area to be verified
- * @size:	size of the area
- * @res_paddr:	will return physical address for the given vaddr
- * @res_vma:	will return locked copy of struct vm_area for the given area
- *
- * This function will go through memory area of size @size mapped at @vaddr and
- * verify that the underlying physical pages are contiguous. If they are
- * contiguous the virtual memory area is locked and a @res_vma is filled with
- * the copy and @res_pa set to the physical address of the buffer.
- *
- * Returns 0 on success.
- */
-int vb2_get_contig_userptr(unsigned long vaddr, unsigned long size,
-			   struct vm_area_struct **res_vma, dma_addr_t *res_pa)
-{
-	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma;
-	unsigned long offset, start, end;
-	unsigned long this_pfn, prev_pfn;
-	dma_addr_t pa = 0;
-
-	start = vaddr;
-	offset = start & ~PAGE_MASK;
-	end = start + size;
-
-	vma = find_vma(mm, start);
-
-	if (vma == NULL || vma->vm_end < end)
-		return -EFAULT;
-
-	for (prev_pfn = 0; start < end; start += PAGE_SIZE) {
-		int ret = follow_pfn(vma, start, &this_pfn);
-		if (ret)
-			return ret;
-
-		if (prev_pfn == 0)
-			pa = this_pfn << PAGE_SHIFT;
-		else if (this_pfn != prev_pfn + 1)
-			return -EFAULT;
-
-		prev_pfn = this_pfn;
-	}
-
-	/*
-	 * Memory is contigous, lock vma and return to the caller
-	 */
-	*res_vma = vb2_get_vma(vma);
-	if (*res_vma == NULL)
-		return -ENOMEM;
-
-	*res_pa = pa + offset;
-	return 0;
-}
-EXPORT_SYMBOL_GPL(vb2_get_contig_userptr);
-
-/**
  * vb2_create_framevec() - map virtual addresses to pfns
  * @start:	Virtual user address where we start mapping
  * @length:	Length of a range to map
diff -puN include/media/videobuf2-memops.h~media-vb2-remove-unused-functions include/media/videobuf2-memops.h
--- a/include/media/videobuf2-memops.h~media-vb2-remove-unused-functions
+++ a/include/media/videobuf2-memops.h
@@ -31,12 +31,6 @@ struct vb2_vmarea_handler {
 
 extern const struct vm_operations_struct vb2_common_vm_ops;
 
-int vb2_get_contig_userptr(unsigned long vaddr, unsigned long size,
-			   struct vm_area_struct **res_vma, dma_addr_t *res_pa);
-
-struct vm_area_struct *vb2_get_vma(struct vm_area_struct *vma);
-void vb2_put_vma(struct vm_area_struct *vma);
