From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-introduce-set_huge_swap_pte_at-helper.patch removed from -mm
 tree
Date: Fri, 07 Jul 2017 12:10:42 -0700
Message-ID: <20170707191042.QNqBM9KSb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34460 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752190AbdGGTK4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2017 15:10:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, catalin.marinas@arm.com, hillf.zj@alibaba-inc.com, kirill.shutemov@linux.intel.com, mark.rutland@arm.com, mhocko@suse.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, punit.agrawal@arm.com, steve.capper@arm.com, will.deacon@arm.com


The patch titled
     Subject: mm/hugetlb: introduce set_huge_swap_pte_at() helper
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-introduce-set_huge_swap_pte_at-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Punit Agrawal <punit.agrawal@arm.com>
Subject: mm/hugetlb: introduce set_huge_swap_pte_at() helper

set_huge_pte_at(), an architecture callback to populate hugepage ptes,
does not provide the range of virtual memory that is targeted.  This leads
to ambiguity when dealing with swap entries on architectures that support
hugepages consisting of contiguous ptes.

Fix the problem by introducing an overridable helper that is called when
populating the page tables with swap entries.  The size of the targeted
region is provided to the helper to help determine the number of entries
to be updated.

Provide a default implementation that maintains the current behaviour.

[punit.agrawal@arm.com: v4]
  Link: http://lkml.kernel.org/r/20170524115409.31309-8-punit.agrawal@arm.com
[punit.agrawal@arm.com: add an empty definition for set_huge_swap_pte_at()]
  Link: http://lkml.kernel.org/r/20170525171331.31469-1-punit.agrawal@arm.com
Link: http://lkml.kernel.org/r/20170522133604.11392-6-punit.agrawal@arm.com
Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Acked-by: Steve Capper <steve.capper@arm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   13 +++++++++++++
 mm/hugetlb.c            |    8 +++++---
 2 files changed, 18 insertions(+), 3 deletions(-)

diff -puN include/linux/hugetlb.h~mm-hugetlb-introduce-set_huge_swap_pte_at-helper include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlb-introduce-set_huge_swap_pte_at-helper
+++ a/include/linux/hugetlb.h
@@ -516,6 +516,14 @@ static inline void hugetlb_count_sub(lon
 {
 	atomic_long_sub(l, &mm->hugetlb_usage);
 }
+
+#ifndef set_huge_swap_pte_at
+static inline void set_huge_swap_pte_at(struct mm_struct *mm, unsigned long addr,
+					pte_t *ptep, pte_t pte, unsigned long sz)
+{
+	set_huge_pte_at(mm, addr, ptep, pte);
+}
+#endif
 #else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
 #define alloc_huge_page(v, a, r) NULL
@@ -565,6 +573,11 @@ static inline void hugetlb_report_usage(
 static inline void hugetlb_count_sub(long l, struct mm_struct *mm)
 {
 }
+
+static inline void set_huge_swap_pte_at(struct mm_struct *mm, unsigned long addr,
+					pte_t *ptep, pte_t pte, unsigned long sz)
+{
+}
 #endif	/* CONFIG_HUGETLB_PAGE */
 
 static inline spinlock_t *huge_pte_lock(struct hstate *h,
diff -puN mm/hugetlb.c~mm-hugetlb-introduce-set_huge_swap_pte_at-helper mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-introduce-set_huge_swap_pte_at-helper
+++ a/mm/hugetlb.c
@@ -3276,9 +3276,10 @@ int copy_hugetlb_page_range(struct mm_st
 				 */
 				make_migration_entry_read(&swp_entry);
 				entry = swp_entry_to_pte(swp_entry);
-				set_huge_pte_at(src, addr, src_pte, entry);
+				set_huge_swap_pte_at(src, addr, src_pte,
+						     entry, sz);
 			}
-			set_huge_pte_at(dst, addr, dst_pte, entry);
+			set_huge_swap_pte_at(dst, addr, dst_pte, entry, sz);
 		} else {
 			if (cow) {
 				huge_ptep_set_wrprotect(src, addr, src_pte);
@@ -4295,7 +4296,8 @@ unsigned long hugetlb_change_protection(
 
 				make_migration_entry_read(&entry);
 				newpte = swp_entry_to_pte(entry);
-				set_huge_pte_at(mm, address, ptep, newpte);
+				set_huge_swap_pte_at(mm, address, ptep,
+						     newpte, huge_page_size(h));
 				pages++;
 			}
 			spin_unlock(ptl);
_

Patches currently in -mm which might be from punit.agrawal@arm.com are


