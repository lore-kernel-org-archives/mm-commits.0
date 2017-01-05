From: akpm@linux-foundation.org
Subject: + userfaultfd-hugetlbfs-gup-support-vm_fault_retry.patch added to -mm tree
Date: Wed, 04 Jan 2017 16:54:10 -0800
Message-ID: <586d9932.L/bybPYJ/sjUSSxU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36236 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937491AbdAEAyX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2017 19:54:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, RAPOPORT@il.ibm.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: hugetlbfs: gup: support VM_FAULT_RETRY
has been added to the -mm tree.  Its filename is
     userfaultfd-hugetlbfs-gup-support-vm_fault_retry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-hugetlbfs-gup-support-vm_fault_retry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-hugetlbfs-gup-support-vm_fault_retry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: hugetlbfs: gup: support VM_FAULT_RETRY

Add support for VM_FAULT_RETRY to follow_hugetlb_page() so that
get_user_pages_unlocked/locked and "nonblocking/FOLL_NOWAIT" features will
work on hugetlbfs.  This is required for fully functional userfaultfd
non-present support on hugetlbfs.

Link: http://lkml.kernel.org/r/20161216144821.5183-25-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    5 ++-
 mm/gup.c                |    2 -
 mm/hugetlb.c            |   48 +++++++++++++++++++++++++++++++-------
 3 files changed, 44 insertions(+), 11 deletions(-)

diff -puN include/linux/hugetlb.h~userfaultfd-hugetlbfs-gup-support-vm_fault_retry include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~userfaultfd-hugetlbfs-gup-support-vm_fault_retry
+++ a/include/linux/hugetlb.h
@@ -65,7 +65,8 @@ int hugetlb_mempolicy_sysctl_handler(str
 int copy_hugetlb_page_range(struct mm_struct *, struct mm_struct *, struct vm_area_struct *);
 long follow_hugetlb_page(struct mm_struct *, struct vm_area_struct *,
 			 struct page **, struct vm_area_struct **,
-			 unsigned long *, unsigned long *, long, unsigned int);
+			 unsigned long *, unsigned long *, long, unsigned int,
+			 int *);
 void unmap_hugepage_range(struct vm_area_struct *,
 			  unsigned long, unsigned long, struct page *);
 void __unmap_hugepage_range_final(struct mmu_gather *tlb,
@@ -136,7 +137,7 @@ static inline unsigned long hugetlb_tota
 	return 0;
 }
 
-#define follow_hugetlb_page(m,v,p,vs,a,b,i,w)	({ BUG(); 0; })
+#define follow_hugetlb_page(m,v,p,vs,a,b,i,w,n)	({ BUG(); 0; })
 #define follow_huge_addr(mm, addr, write)	ERR_PTR(-EINVAL)
 #define copy_hugetlb_page_range(src, dst, vma)	({ BUG(); 0; })
 static inline void hugetlb_report_meminfo(struct seq_file *m)
diff -puN mm/gup.c~userfaultfd-hugetlbfs-gup-support-vm_fault_retry mm/gup.c
--- a/mm/gup.c~userfaultfd-hugetlbfs-gup-support-vm_fault_retry
+++ a/mm/gup.c
@@ -572,7 +572,7 @@ static long __get_user_pages(struct task
 			if (is_vm_hugetlb_page(vma)) {
 				i = follow_hugetlb_page(mm, vma, pages, vmas,
 						&start, &nr_pages, i,
-						gup_flags);
+						gup_flags, nonblocking);
 				continue;
 			}
 		}
diff -puN mm/hugetlb.c~userfaultfd-hugetlbfs-gup-support-vm_fault_retry mm/hugetlb.c
--- a/mm/hugetlb.c~userfaultfd-hugetlbfs-gup-support-vm_fault_retry
+++ a/mm/hugetlb.c
@@ -4046,7 +4046,7 @@ out_release_unlock:
 long follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			 struct page **pages, struct vm_area_struct **vmas,
 			 unsigned long *position, unsigned long *nr_pages,
-			 long i, unsigned int flags)
+			 long i, unsigned int flags, int *nonblocking)
 {
 	unsigned long pfn_offset;
 	unsigned long vaddr = *position;
@@ -4109,16 +4109,43 @@ long follow_hugetlb_page(struct mm_struc
 		    ((flags & FOLL_WRITE) &&
 		      !huge_pte_write(huge_ptep_get(pte)))) {
 			int ret;
+			unsigned int fault_flags = 0;
 
 			if (pte)
 				spin_unlock(ptl);
-			ret = hugetlb_fault(mm, vma, vaddr,
-				(flags & FOLL_WRITE) ? FAULT_FLAG_WRITE : 0);
-			if (!(ret & VM_FAULT_ERROR))
-				continue;
-
-			remainder = 0;
-			break;
+			if (flags & FOLL_WRITE)
+				fault_flags |= FAULT_FLAG_WRITE;
+			if (nonblocking)
+				fault_flags |= FAULT_FLAG_ALLOW_RETRY;
+			if (flags & FOLL_NOWAIT)
+				fault_flags |= FAULT_FLAG_ALLOW_RETRY |
+					FAULT_FLAG_RETRY_NOWAIT;
+			if (flags & FOLL_TRIED) {
+				VM_WARN_ON_ONCE(fault_flags &
+						FAULT_FLAG_ALLOW_RETRY);
+				fault_flags |= FAULT_FLAG_TRIED;
+			}
+			ret = hugetlb_fault(mm, vma, vaddr, fault_flags);
+			if (ret & VM_FAULT_ERROR) {
+				remainder = 0;
+				break;
+			}
+			if (ret & VM_FAULT_RETRY) {
+				if (nonblocking)
+					*nonblocking = 0;
+				*nr_pages = 0;
+				/*
+				 * VM_FAULT_RETRY must not return an
+				 * error, it will return zero
+				 * instead.
+				 *
+				 * No need to update "position" as the
+				 * caller will not check it after
+				 * *nr_pages is set to 0.
+				 */
+				return i;
+			}
+			continue;
 		}
 
 		pfn_offset = (vaddr & ~huge_page_mask(h)) >> PAGE_SHIFT;
@@ -4147,6 +4174,11 @@ same_page:
 		spin_unlock(ptl);
 	}
 	*nr_pages = remainder;
+	/*
+	 * setting position is actually required only if remainder is
+	 * not zero but it's faster not to add a "if (remainder)"
+	 * branch.
+	 */
 	*position = vaddr;
 
 	return i ? i : -EFAULT;
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-document-_ior-_iow.patch
userfaultfd-correct-comment-about-uffd_feature_pagefault_flag_wp.patch
userfaultfd-convert-bug-to-warn_on_once.patch
userfaultfd-use-vma_is_anonymous.patch
userfaultfd-non-cooperative-report-all-available-features-to-userland.patch
userfaultfd-non-cooperative-add-fork-event-build-warning-fix.patch
userfaultfd-non-cooperative-optimize-mremap_userfaultfd_complete.patch
userfaultfd-non-cooperative-avoid-madv_dontneed-race-condition.patch
userfaultfd-non-cooperative-wake-userfaults-after-uffdio_unregister.patch
userfaultfd-hugetlbfs-gup-support-vm_fault_retry.patch
userfaultfd-hugetlbfs-uffd_feature_missing_hugetlbfs.patch
userfaultfd-shmem-add-tlbflushh-header-for-microblaze.patch
userfaultfd-shmem-lock-the-page-before-adding-it-to-pagecache.patch
userfaultfd-shmem-avoid-leaking-blocks-and-used-blocks-in-uffdio_copy.patch
userfaultfd-hugetlbfs-uffd_feature_missing_shmem.patch
userfaultfd-selftest-test-uffdio_zeropage-on-all-memory-types.patch
mm-mprotect-use-pmd_trans_unstable-instead-of-taking-the-pmd_lock.patch

