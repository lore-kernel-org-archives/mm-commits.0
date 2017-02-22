From: akpm@linux-foundation.org
Subject: [patch 079/142] userfaultfd: hugetlbfs: add UFFDIO_COPY support
 for shared mappings
Date: Wed, 22 Feb 2017 15:43:43 -0800
Message-ID: <58ae222f.bvFWCLMZIToYHVzH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48816 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934171AbdBVXno (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:43:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mike.kravetz@oracle.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, rppt@linux.vnet.ibm.com, xemul@parallels.com

From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: userfaultfd: hugetlbfs: add UFFDIO_COPY support for shared mappings

When userfaultfd hugetlbfs support was originally added, it followed the
pattern of anon mappings and did not support any vmas marked VM_SHARED. 
As such, support was only added for private mappings.

Remove this limitation and support shared mappings.  The primary
functional change required is adding pages to the page cache.  More subtle
changes are required for huge page reservation handling in error paths.  A
lengthy comment in the code describes the reservation handling.

[mike.kravetz@oracle.com: update]
  Link: http://lkml.kernel.org/r/c9c8cafe-baa7-05b4-34ea-1dfa5523a85f@oracle.com
Link: http://lkml.kernel.org/r/1487195210-12839-1-git-send-email-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c     |   26 ++++++++++++++-
 mm/userfaultfd.c |   74 +++++++++++++++++++++++++++++++++++----------
 2 files changed, 82 insertions(+), 18 deletions(-)

diff -puN mm/hugetlb.c~userfaultfd-hugetlbfs-add-uffdio_copy-support-for-shared-mappings mm/hugetlb.c
--- a/mm/hugetlb.c~userfaultfd-hugetlbfs-add-uffdio_copy-support-for-shared-mappings
+++ a/mm/hugetlb.c
@@ -3992,6 +3992,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 			    unsigned long src_addr,
 			    struct page **pagep)
 {
+	int vm_shared = dst_vma->vm_flags & VM_SHARED;
 	struct hstate *h = hstate_vma(dst_vma);
 	pte_t _dst_pte;
 	spinlock_t *ptl;
@@ -4028,6 +4029,18 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 	__SetPageUptodate(page);
 	set_page_huge_active(page);
 
+	/*
+	 * If shared, add to page cache
+	 */
+	if (vm_shared) {
+		struct address_space *mapping = dst_vma->vm_file->f_mapping;
+		pgoff_t idx = vma_hugecache_offset(h, dst_vma, dst_addr);
+
+		ret = huge_add_to_page_cache(page, mapping, idx);
+		if (ret)
+			goto out_release_nounlock;
+	}
+
 	ptl = huge_pte_lockptr(h, dst_mm, dst_pte);
 	spin_lock(ptl);
 
@@ -4035,8 +4048,12 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 	if (!huge_pte_none(huge_ptep_get(dst_pte)))
 		goto out_release_unlock;
 
-	ClearPagePrivate(page);
-	hugepage_add_new_anon_rmap(page, dst_vma, dst_addr);
+	if (vm_shared) {
+		page_dup_rmap(page, true);
+	} else {
+		ClearPagePrivate(page);
+		hugepage_add_new_anon_rmap(page, dst_vma, dst_addr);
+	}
 
 	_dst_pte = make_huge_pte(dst_vma, page, dst_vma->vm_flags & VM_WRITE);
 	if (dst_vma->vm_flags & VM_WRITE)
@@ -4053,11 +4070,16 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 	update_mmu_cache(dst_vma, dst_addr, dst_pte);
 
 	spin_unlock(ptl);
+	if (vm_shared)
+		unlock_page(page);
 	ret = 0;
 out:
 	return ret;
 out_release_unlock:
 	spin_unlock(ptl);
+out_release_nounlock:
+	if (vm_shared)
+		unlock_page(page);
 	put_page(page);
 	goto out;
 }
diff -puN mm/userfaultfd.c~userfaultfd-hugetlbfs-add-uffdio_copy-support-for-shared-mappings mm/userfaultfd.c
--- a/mm/userfaultfd.c~userfaultfd-hugetlbfs-add-uffdio_copy-support-for-shared-mappings
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
@@ -204,14 +206,14 @@ retry:
 			goto out_unlock;
 
 		/*
-		 * Make sure the vma is not shared, that the remaining dst
-		 * range is both valid and fully within a single existing vma.
+		 * Make sure the remaining dst range is both valid and
+		 * fully within a single existing vma.
 		 */
-		if (dst_vma->vm_flags & VM_SHARED)
-			goto out_unlock;
 		if (dst_start < dst_vma->vm_start ||
 		    dst_start + len > dst_vma->vm_end)
 			goto out_unlock;
+
+		vm_shared = dst_vma->vm_flags & VM_SHARED;
 	}
 
 	if (WARN_ON(dst_addr & (vma_hpagesize - 1) ||
@@ -225,11 +227,13 @@ retry:
 		goto out_unlock;
 
 	/*
-	 * Ensure the dst_vma has a anon_vma.
+	 * If not shared, ensure the dst_vma has a anon_vma.
 	 */
 	err = -ENOMEM;
-	if (unlikely(anon_vma_prepare(dst_vma)))
-		goto out_unlock;
+	if (!vm_shared) {
+		if (unlikely(anon_vma_prepare(dst_vma)))
+			goto out_unlock;
+	}
 
 	h = hstate_vma(dst_vma);
 
@@ -266,6 +270,7 @@ retry:
 						dst_addr, src_addr, &page);
 
 		mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+		vm_alloc_shared = vm_shared;
 
 		cond_resched();
 
@@ -305,18 +310,49 @@ out:
 	if (page) {
 		/*
 		 * We encountered an error and are about to free a newly
-		 * allocated huge page.  It is possible that there was a
-		 * reservation associated with the page that has been
-		 * consumed.  See the routine restore_reserve_on_error
-		 * for details.  Unfortunately, we can not call
-		 * restore_reserve_on_error now as it would require holding
-		 * mmap_sem.  Clear the PagePrivate flag so that the global
+		 * allocated huge page.
+		 *
+		 * Reservation handling is very subtle, and is different for
+		 * private and shared mappings.  See the routine
+		 * restore_reserve_on_error for details.  Unfortunately, we
+		 * can not call restore_reserve_on_error now as it would
+		 * require holding mmap_sem.
+		 *
+		 * If a reservation for the page existed in the reservation
+		 * map of a private mapping, the map was modified to indicate
+		 * the reservation was consumed when the page was allocated.
+		 * We clear the PagePrivate flag now so that the global
 		 * reserve count will not be incremented in free_huge_page.
 		 * The reservation map will still indicate the reservation
 		 * was consumed and possibly prevent later page allocation.
-		 * This is better than leaking a global reservation.
+		 * This is better than leaking a global reservation.  If no
+		 * reservation existed, it is still safe to clear PagePrivate
+		 * as no adjustments to reservation counts were made during
+		 * allocation.
+		 *
+		 * The reservation map for shared mappings indicates which
+		 * pages have reservations.  When a huge page is allocated
+		 * for an address with a reservation, no change is made to
+		 * the reserve map.  In this case PagePrivate will be set
+		 * to indicate that the global reservation count should be
+		 * incremented when the page is freed.  This is the desired
+		 * behavior.  However, when a huge page is allocated for an
+		 * address without a reservation a reservation entry is added
+		 * to the reservation map, and PagePrivate will not be set.
+		 * When the page is freed, the global reserve count will NOT
+		 * be incremented and it will appear as though we have leaked
+		 * reserved page.  In this case, set PagePrivate so that the
+		 * global reserve count will be incremented to match the
+		 * reservation map entry which was created.
+		 *
+		 * Note that vm_alloc_shared is based on the flags of the vma
+		 * for which the page was originally allocated.  dst_vma could
+		 * be different or NULL on error.
 		 */
-		ClearPagePrivate(page);
+		if (vm_alloc_shared)
+			SetPagePrivate(page);
+		else
+			ClearPagePrivate(page);
 		put_page(page);
 	}
 	BUG_ON(copied < 0);
@@ -372,8 +408,14 @@ retry:
 	dst_vma = find_vma(dst_mm, dst_start);
 	if (!dst_vma)
 		goto out_unlock;
-	if (!vma_is_shmem(dst_vma) && dst_vma->vm_flags & VM_SHARED)
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
