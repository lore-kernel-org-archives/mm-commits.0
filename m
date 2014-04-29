From: akpm@linux-foundation.org
Subject: [nacked]
 media-videobuf2-dma-sg-call-find_vma-with-the-mmap_sem-held.patch removed
 from -mm tree
Date: Tue, 29 Apr 2014 15:03:03 -0700
Message-ID: <53602197.iS3U5ZoLL1MG6Me0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35089 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965146AbaD2WDE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Apr 2014 18:03:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, pawel@osciak.com, m.szyprowski@samsung.com, m.chehab@samsung.com, kyungmin.park@samsung.com, davidlohr@hp.com

Subject: [nacked] media-videobuf2-dma-sg-call-find_vma-with-the-mmap_sem-held.patch removed from -mm tree
To: davidlohr@hp.com,kyungmin.park@samsung.com,m.chehab@samsung.com,m.szyprowski@samsung.com,pawel@osciak.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 29 Apr 2014 15:03:03 -0700


The patch titled
     Subject: drivers/media/v4l2-core/videobuf2-dma-sg.c: call find_vma with the mmap_sem held
has been removed from the -mm tree.  Its filename was
     media-videobuf2-dma-sg-call-find_vma-with-the-mmap_sem-held.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: drivers/media/v4l2-core/videobuf2-dma-sg.c: call find_vma with the mmap_sem held

Performing vma lookups without taking the mm->mmap_sem is asking for
trouble.  While doing the search, the vma in question can be modified or
even removed before returning to the caller.  Take the lock in order to
avoid races while iterating through the vmacache and/or rbtree.

Also do some very minor cleanup changes.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Pawel Osciak <pawel@osciak.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/v4l2-core/videobuf2-dma-sg.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN drivers/media/v4l2-core/videobuf2-dma-sg.c~media-videobuf2-dma-sg-call-find_vma-with-the-mmap_sem-held drivers/media/v4l2-core/videobuf2-dma-sg.c
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c~media-videobuf2-dma-sg-call-find_vma-with-the-mmap_sem-held
+++ a/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -168,8 +168,9 @@ static void *vb2_dma_sg_get_userptr(void
 	unsigned long first, last;
 	int num_pages_from_user;
 	struct vm_area_struct *vma;
+	struct mm_struct *mm = current->mm;
 
-	buf = kzalloc(sizeof *buf, GFP_KERNEL);
+	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
 	if (!buf)
 		return NULL;
 
@@ -178,7 +179,7 @@ static void *vb2_dma_sg_get_userptr(void
 	buf->offset = vaddr & ~PAGE_MASK;
 	buf->size = size;
 
-	first = (vaddr           & PAGE_MASK) >> PAGE_SHIFT;
+	first = (vaddr & PAGE_MASK) >> PAGE_SHIFT;
 	last  = ((vaddr + size - 1) & PAGE_MASK) >> PAGE_SHIFT;
 	buf->num_pages = last - first + 1;
 
@@ -187,7 +188,8 @@ static void *vb2_dma_sg_get_userptr(void
 	if (!buf->pages)
 		goto userptr_fail_alloc_pages;
 
-	vma = find_vma(current->mm, vaddr);
+	down_write(&mm->mmap_sem);
+	vma = find_vma(mm, vaddr);
 	if (!vma) {
 		dprintk(1, "no vma for address %lu\n", vaddr);
 		goto userptr_fail_find_vma;
@@ -218,7 +220,7 @@ static void *vb2_dma_sg_get_userptr(void
 			buf->pages[num_pages_from_user] = pfn_to_page(pfn);
 		}
 	} else
-		num_pages_from_user = get_user_pages(current, current->mm,
+		num_pages_from_user = get_user_pages(current, mm,
 					     vaddr & PAGE_MASK,
 					     buf->num_pages,
 					     write,
@@ -233,6 +235,7 @@ static void *vb2_dma_sg_get_userptr(void
 			buf->num_pages, buf->offset, size, 0))
 		goto userptr_fail_alloc_table_from_pages;
 
+	up_write(&mm->mmap_sem);
 	return buf;
 
 userptr_fail_alloc_table_from_pages:
@@ -244,6 +247,7 @@ userptr_fail_get_user_pages:
 			put_page(buf->pages[num_pages_from_user]);
 	vb2_put_vma(buf->vma);
 userptr_fail_find_vma:
+	up_write(&mm->mmap_sem);
 	kfree(buf->pages);
 userptr_fail_alloc_pages:
 	kfree(buf);
_

Patches currently in -mm which might be from davidlohr@hp.com are

origin.patch
mmvmacache-add-debug-data.patch
mmvmacache-optimize-overflow-system-wide-flushing.patch
mm-pass-vm_bug_on-reason-to-dump_page.patch
mm-pass-vm_bug_on-reason-to-dump_page-fix.patch
hugetlb-prep_compound_gigantic_page-drop-__init-marker.patch
hugetlb-add-hstate_is_gigantic.patch
hugetlb-update_and_free_page-dont-clear-pg_reserved-bit.patch
hugetlb-move-helpers-up-in-the-file.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch
m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush.patch
mips-call-find_vma-with-the-mmap_sem-held.patch
arc-call-find_vma-with-the-mmap_sem-held.patch
arc-call-find_vma-with-the-mmap_sem-held-fix.patch
drm-exynos-call-find_vma-with-the-mmap_sem-held.patch
ipc-constify-ipc_ops.patch
ipc-shmc-check-for-ulong-overflows-in-shmat.patch
ipc-shmc-check-for-overflows-of-shm_tot.patch
ipc-shmc-check-for-integer-overflow-during-shmget.patch
ipc-shmc-increase-the-defaults-for-shmall-shmmax.patch
blackfin-ptrace-call-find_vma-with-the-mmap_sem-held.patch

