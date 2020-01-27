From: akpm@linux-foundation.org
Subject: [failures] mm-mremap-calculate-extent-in-one-place.patch
 removed from -mm tree
Date: Sun, 26 Jan 2020 18:59:31 -0800
Message-ID: <20200127025931.grSdxI5kb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726545AbgA0C7c (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 26 Jan 2020 21:59:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.ibm.com, dan.j.williams@intel.com, kirill@shutemov.name, mm-commits@vger.kernel.org, richardw.yang@linux.intel.com, thellstrom@vmware.com, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm/mremap: calculate extent in one place
has been removed from the -mm tree.  Its filename was
     mm-mremap-calculate-extent-in-one-place.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Wei Yang <richardw.yang@linux.intel.com>
Subject: mm/mremap: calculate extent in one place

Page tables is moved on the base of PMD.  This requires both source and
destination range should meet the requirement.

Current code works well since move_huge_pmd() and move_normal_pmd() would
check old_addr and new_addr again.  And then return to move_ptes() if the
either of them is not aligned.

In stead of calculating the extent separately, it is better to calculate
in one place, so we know it is not necessary to try move pmd.  By doing
so, the logic seems a little clear.

Link: http://lkml.kernel.org/r/20200117232254.2792-5-richardw.yang@linux.intel.com
Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/mm/mremap.c~mm-mremap-calculate-extent-in-one-place
+++ a/mm/mremap.c
@@ -240,7 +240,7 @@ unsigned long move_page_tables(struct vm
 		unsigned long new_addr, unsigned long len,
 		bool need_rmap_locks)
 {
-	unsigned long extent, next, old_end;
+	unsigned long extent, old_next, new_next, old_end;
 	struct mmu_notifier_range range;
 	pmd_t *old_pmd, *new_pmd;
 
@@ -253,8 +253,9 @@ unsigned long move_page_tables(struct vm
 
 	for (; old_addr < old_end; old_addr += extent, new_addr += extent) {
 		cond_resched();
-		next = pmd_addr_end(old_addr, old_end);
-		extent = next - old_addr;
+		old_next = pmd_addr_end(old_addr, old_end);
+		new_next = pmd_addr_end(new_addr, new_addr + len);
+		extent = min((old_next - old_addr), (new_next - new_addr));
 		old_pmd = get_old_pmd(vma->vm_mm, old_addr);
 		if (!old_pmd)
 			continue;
@@ -298,9 +299,6 @@ unsigned long move_page_tables(struct vm
 
 		if (pte_alloc(new_vma->vm_mm, new_pmd))
 			break;
-		next = pmd_addr_end(new_addr, new_addr + len);
-		if (extent > next - new_addr)
-			extent = next - new_addr;
 		move_ptes(vma, old_pmd, old_addr, old_addr + extent, new_vma,
 			  new_pmd, new_addr, need_rmap_locks);
 	}
_

Patches currently in -mm which might be from richardw.yang@linux.intel.com are

mm-thp-remove-the-defer-list-related-code-since-this-will-not-happen.patch
mm-migratec-also-overwrite-error-when-it-is-bigger-than-zero.patch
mm-gupc-use-is_vm_hugetlb_page-to-check-whether-to-follow-huge.patch
mm-mremap-start-addresses-are-properly-aligned.patch
mm-huge_memoryc-use-head-to-check-huge-zero-page.patch
mm-huge_memoryc-use-head-to-emphasize-the-purpose-of-page.patch
mm-huge_memoryc-reduce-critical-section-protected-by-split_queue_lock.patch
mm-remove-dead-code-totalram_pages_set.patch
