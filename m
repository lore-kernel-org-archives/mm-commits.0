From: akpm@linux-foundation.org
Subject: [patch 069/142] userfaultfd: hugetlbfs: gup: support
 VM_FAULT_RETRY
Date: Wed, 22 Feb 2017 15:43:13 -0800
Message-ID: <58ae2211.IfuJZKyagdLgNkmK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48658 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933368AbdBVXnP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:43:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, aarcange@redhat.com, RAPOPORT@il.ibm.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, xemul@parallels.com

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
@@ -4065,7 +4065,7 @@ out_release_unlock:
 long follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			 struct page **pages, struct vm_area_struct **vmas,
 			 unsigned long *position, unsigned long *nr_pages,
-			 long i, unsigned int flags)
+			 long i, unsigned int flags, int *nonblocking)
 {
 	unsigned long pfn_offset;
 	unsigned long vaddr = *position;
@@ -4128,16 +4128,43 @@ long follow_hugetlb_page(struct mm_struc
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
@@ -4166,6 +4193,11 @@ same_page:
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
