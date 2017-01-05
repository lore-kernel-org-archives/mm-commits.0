From: akpm@linux-foundation.org
Subject: +
 userfaultfd-hugetlbfs-add-hugetlb_mcopy_atomic_pte-for-userfaultfd-support.patch added to -mm tree
Date: Wed, 04 Jan 2017 16:53:54 -0800
Message-ID: <586d9922.4B1Vn/ag5htPL56z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36230 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937142AbdAEAyW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2017 19:54:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, RAPOPORT@il.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, rppt@linux.vnet.ibm.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: hugetlbfs: add hugetlb_mcopy_atomic_pte for userfaultfd support
has been added to the -mm tree.  Its filename is
     userfaultfd-hugetlbfs-add-hugetlb_mcopy_atomic_pte-for-userfaultfd-support.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-hugetlbfs-add-hugetlb_mcopy_atomic_pte-for-userfaultfd-support.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-hugetlbfs-add-hugetlb_mcopy_atomic_pte-for-userfaultfd-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: userfaultfd: hugetlbfs: add hugetlb_mcopy_atomic_pte for userfaultfd support

hugetlb_mcopy_atomic_pte is the low level routine that implements the
userfaultfd UFFDIO_COPY command.  It is based on the existing
mcopy_atomic_pte routine with modifications for huge pages.

Link: http://lkml.kernel.org/r/20161216144821.5183-18-aarcange@redhat.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    7 +++
 mm/hugetlb.c            |   81 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 88 insertions(+)

diff -puN include/linux/hugetlb.h~userfaultfd-hugetlbfs-add-hugetlb_mcopy_atomic_pte-for-userfaultfd-support include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~userfaultfd-hugetlbfs-add-hugetlb_mcopy_atomic_pte-for-userfaultfd-support
+++ a/include/linux/hugetlb.h
@@ -81,6 +81,11 @@ void hugetlb_show_meminfo(void);
 unsigned long hugetlb_total_pages(void);
 int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long address, unsigned int flags);
+int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm, pte_t *dst_pte,
+				struct vm_area_struct *dst_vma,
+				unsigned long dst_addr,
+				unsigned long src_addr,
+				struct page **pagep);
 int hugetlb_reserve_pages(struct inode *inode, long from, long to,
 						struct vm_area_struct *vma,
 						vm_flags_t vm_flags);
@@ -149,6 +154,8 @@ static inline void hugetlb_show_meminfo(
 #define is_hugepage_only_range(mm, addr, len)	0
 #define hugetlb_free_pgd_range(tlb, addr, end, floor, ceiling) ({BUG(); 0; })
 #define hugetlb_fault(mm, vma, addr, flags)	({ BUG(); 0; })
+#define hugetlb_mcopy_atomic_pte(dst_mm, dst_pte, dst_vma, dst_addr, \
+				src_addr, pagep)	({ BUG(); 0; })
 #define huge_pte_offset(mm, address)	0
 static inline int dequeue_hwpoisoned_huge_page(struct page *page)
 {
diff -puN mm/hugetlb.c~userfaultfd-hugetlbfs-add-hugetlb_mcopy_atomic_pte-for-userfaultfd-support mm/hugetlb.c
--- a/mm/hugetlb.c~userfaultfd-hugetlbfs-add-hugetlb_mcopy_atomic_pte-for-userfaultfd-support
+++ a/mm/hugetlb.c
@@ -3929,6 +3929,87 @@ out_mutex:
 	return ret;
 }
 
+/*
+ * Used by userfaultfd UFFDIO_COPY.  Based on mcopy_atomic_pte with
+ * modifications for huge pages.
+ */
+int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm,
+			    pte_t *dst_pte,
+			    struct vm_area_struct *dst_vma,
+			    unsigned long dst_addr,
+			    unsigned long src_addr,
+			    struct page **pagep)
+{
+	struct hstate *h = hstate_vma(dst_vma);
+	pte_t _dst_pte;
+	spinlock_t *ptl;
+	int ret;
+	struct page *page;
+
+	if (!*pagep) {
+		ret = -ENOMEM;
+		page = alloc_huge_page(dst_vma, dst_addr, 0);
+		if (IS_ERR(page))
+			goto out;
+
+		ret = copy_huge_page_from_user(page,
+						(const void __user *) src_addr,
+						pages_per_huge_page(h));
+
+		/* fallback to copy_from_user outside mmap_sem */
+		if (unlikely(ret)) {
+			ret = -EFAULT;
+			*pagep = page;
+			/* don't free the page */
+			goto out;
+		}
+	} else {
+		page = *pagep;
+		*pagep = NULL;
+	}
+
+	/*
+	 * The memory barrier inside __SetPageUptodate makes sure that
+	 * preceding stores to the page contents become visible before
+	 * the set_pte_at() write.
+	 */
+	__SetPageUptodate(page);
+	set_page_huge_active(page);
+
+	ptl = huge_pte_lockptr(h, dst_mm, dst_pte);
+	spin_lock(ptl);
+
+	ret = -EEXIST;
+	if (!huge_pte_none(huge_ptep_get(dst_pte)))
+		goto out_release_unlock;
+
+	ClearPagePrivate(page);
+	hugepage_add_new_anon_rmap(page, dst_vma, dst_addr);
+
+	_dst_pte = make_huge_pte(dst_vma, page, dst_vma->vm_flags & VM_WRITE);
+	if (dst_vma->vm_flags & VM_WRITE)
+		_dst_pte = huge_pte_mkdirty(_dst_pte);
+	_dst_pte = pte_mkyoung(_dst_pte);
+
+	set_huge_pte_at(dst_mm, dst_addr, dst_pte, _dst_pte);
+
+	(void)huge_ptep_set_access_flags(dst_vma, dst_addr, dst_pte, _dst_pte,
+					dst_vma->vm_flags & VM_WRITE);
+	hugetlb_count_add(pages_per_huge_page(h), dst_mm);
+
+	/* No need to invalidate - it was non-present before */
+	update_mmu_cache(dst_vma, dst_addr, dst_pte);
+
+	spin_unlock(ptl);
+	ret = 0;
+out:
+	return ret;
+out_release_unlock:
+	spin_unlock(ptl);
+	put_page(page);
+	goto out;
+}
+
 long follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			 struct page **pages, struct vm_area_struct **vmas,
 			 unsigned long *position, unsigned long *nr_pages,
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

