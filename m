From: akpm@linux-foundation.org
Subject: [folded-merged]
 userfaultfd-hugetlbfs-add-uffdio_copy-support-for-shared-mappings-update.patch removed from -mm tree
Date: Wed, 22 Feb 2017 15:21:33 -0800
Message-ID: <58ae1cfd.vFnDbH/IcEU68CLI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45532 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932393AbdBVXVe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:21:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, aarcange@redhat.com, hillf.zj@alibaba-inc.com, rppt@linux.vnet.ibm.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd-hugetlbfs-add-uffdio_copy-support-for-shared-mappings-update
has been removed from the -mm tree.  Its filename was
     userfaultfd-hugetlbfs-add-uffdio_copy-support-for-shared-mappings-update.patch

This patch was dropped because it was folded into userfaultfd-hugetlbfs-add-uffdio_copy-support-for-shared-mappings.patch

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: userfaultfd-hugetlbfs-add-uffdio_copy-support-for-shared-mappings-update

Thanks Andrea, I incorporated your suggestions into a new version of the
patch.  While changing (dst_vma->vm_flags & VM_SHARED) to integers, I
noticed an issue in the error path of __mcopy_atomic_hugetlb().

>                */
> -             ClearPagePrivate(page);
> +             if (dst_vma->vm_flags & VM_SHARED)
> +                     SetPagePrivate(page);
> +             else
> +                     ClearPagePrivate(page);
>               put_page(page);

We can not use dst_vma here as it may be different than the vma for which
the page was originally allocated, or even NULL.  Remember, we may drop
mmap_sem and look up dst_vma again.  Therefore, we need to save the value
of (dst_vma->vm_flags & VM_SHARED) for the vma which was used when the
page was allocated.  This change as well as your suggestions are in the
patch below:

Link: http://lkml.kernel.org/r/c9c8cafe-baa7-05b4-34ea-1dfa5523a85f@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c     |    9 +++++----
 mm/userfaultfd.c |   22 ++++++++++++++++++----
 2 files changed, 23 insertions(+), 8 deletions(-)

diff -puN mm/hugetlb.c~userfaultfd-hugetlbfs-add-uffdio_copy-support-for-shared-mappings-update mm/hugetlb.c
--- a/mm/hugetlb.c~userfaultfd-hugetlbfs-add-uffdio_copy-support-for-shared-mappings-update
+++ a/mm/hugetlb.c
@@ -3992,6 +3992,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 			    unsigned long src_addr,
 			    struct page **pagep)
 {
+	int vm_shared = dst_vma->vm_flags & VM_SHARED;
 	struct hstate *h = hstate_vma(dst_vma);
 	pte_t _dst_pte;
 	spinlock_t *ptl;
@@ -4031,7 +4032,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 	/*
 	 * If shared, add to page cache
 	 */
-	if (dst_vma->vm_flags & VM_SHARED) {
+	if (vm_shared) {
 		struct address_space *mapping = dst_vma->vm_file->f_mapping;
 		pgoff_t idx = vma_hugecache_offset(h, dst_vma, dst_addr);
 
@@ -4047,7 +4048,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 	if (!huge_pte_none(huge_ptep_get(dst_pte)))
 		goto out_release_unlock;
 
-	if (dst_vma->vm_flags & VM_SHARED) {
+	if (vm_shared) {
 		page_dup_rmap(page, true);
 	} else {
 		ClearPagePrivate(page);
@@ -4069,7 +4070,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 	update_mmu_cache(dst_vma, dst_addr, dst_pte);
 
 	spin_unlock(ptl);
-	if (dst_vma->vm_flags & VM_SHARED)
+	if (vm_shared)
 		unlock_page(page);
 	ret = 0;
 out:
@@ -4077,7 +4078,7 @@ out:
 out_release_unlock:
 	spin_unlock(ptl);
 out_release_nounlock:
-	if (dst_vma->vm_flags & VM_SHARED)
+	if (vm_shared)
 		unlock_page(page);
 	put_page(page);
 	goto out;
diff -puN mm/userfaultfd.c~userfaultfd-hugetlbfs-add-uffdio_copy-support-for-shared-mappings-update mm/userfaultfd.c
--- a/mm/userfaultfd.c~userfaultfd-hugetlbfs-add-uffdio_copy-support-for-shared-mappings-update
+++ a/mm/userfaultfd.c
@@ -154,6 +154,8 @@ static __always_inline ssize_t __mcopy_a
 					      unsigned long len,
 					      bool zeropage)
 {
+	int vm_alloc_shared = dst_vma->vm_flags & VM_SHARED;
+	int vm_shared = dst_vma->vm_flags & VM_SHARED;
 	ssize_t err;
 	pte_t *dst_pte;
 	unsigned long src_addr, dst_addr;
@@ -210,6 +212,8 @@ retry:
 		if (dst_start < dst_vma->vm_start ||
 		    dst_start + len > dst_vma->vm_end)
 			goto out_unlock;
+
+		vm_shared = dst_vma->vm_flags & VM_SHARED;
 	}
 
 	if (WARN_ON(dst_addr & (vma_hpagesize - 1) ||
@@ -226,7 +230,7 @@ retry:
 	 * If not shared, ensure the dst_vma has a anon_vma.
 	 */
 	err = -ENOMEM;
-	if (!(dst_vma->vm_flags & VM_SHARED)) {
+	if (!vm_shared) {
 		if (unlikely(anon_vma_prepare(dst_vma)))
 			goto out_unlock;
 	}
@@ -266,6 +270,7 @@ retry:
 						dst_addr, src_addr, &page);
 
 		mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+		vm_alloc_shared = vm_shared;
 
 		cond_resched();
 
@@ -339,8 +344,12 @@ out:
 		 * reserved page.  In this case, set PagePrivate so that the
 		 * global reserve count will be incremented to match the
 		 * reservation map entry which was created.
+		 *
+		 * Note that vm_alloc_shared is based on the flags of the vma
+		 * for which the page was originally allocated.  dst_vma could
+		 * be different or NULL on error.
 		 */
-		if (dst_vma->vm_flags & VM_SHARED)
+		if (vm_alloc_shared)
 			SetPagePrivate(page);
 		else
 			ClearPagePrivate(page);
@@ -399,9 +408,14 @@ retry:
 	dst_vma = find_vma(dst_mm, dst_start);
 	if (!dst_vma)
 		goto out_unlock;
-	if (!vma_is_shmem(dst_vma) && !is_vm_hugetlb_page(dst_vma) &&
-	    dst_vma->vm_flags & VM_SHARED)
+	/*
+	 * shmem_zero_setup is invoked in mmap for MAP_ANONYMOUS|MAP_SHARED but
+	 * it will overwrite vm_ops, so vma_is_anonymous must return false.
+	 */
+	if (WARN_ON_ONCE(vma_is_anonymous(dst_vma) &&
+	    dst_vma->vm_flags & VM_SHARED))
 		goto out_unlock;
+
 	if (dst_start < dst_vma->vm_start ||
 	    dst_start + len > dst_vma->vm_end)
 		goto out_unlock;
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

userfaultfd-hugetlbfs-add-copy_huge_page_from_user-for-hugetlb-userfaultfd-support.patch
userfaultfd-hugetlbfs-add-hugetlb_mcopy_atomic_pte-for-userfaultfd-support.patch
userfaultfd-hugetlbfs-add-__mcopy_atomic_hugetlb-for-huge-page-uffdio_copy.patch
userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing.patch
userfaultfd-hugetlbfs-add-userfaultfd-hugetlb-hook.patch
userfaultfd-hugetlbfs-allow-registration-of-ranges-containing-huge-pages.patch
userfaultfd-hugetlbfs-add-userfaultfd_hugetlb-test.patch
userfaultfd-hugetlbfs-userfaultfd_huge_must_wait-for-hugepmd-ranges.patch
userfaultfd-hugetlbfs-reserve-count-on-error-in-__mcopy_atomic_hugetlb.patch
userfaultfd-hugetlbfs-add-uffdio_copy-support-for-shared-mappings.patch

