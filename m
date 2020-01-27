From: akpm@linux-foundation.org
Subject: [failures]
 mm-mremap-use-pmd_addr_end-to-calculate-next-in-move_page_tables.patch
 removed from -mm tree
Date: Sun, 26 Jan 2020 18:59:28 -0800
Message-ID: <20200127025928.P7aTLYk9U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726545AbgA0C73 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 26 Jan 2020 21:59:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.ibm.com, dan.j.williams@intel.com, kirill@shutemov.name, mm-commits@vger.kernel.org, richardw.yang@linux.intel.com, thellstrom@vmware.com, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm/mremap: use pmd_addr_end to calculate next in move_page_tables()
has been removed from the -mm tree.  Its filename was
     mm-mremap-use-pmd_addr_end-to-calculate-next-in-move_page_tables.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Wei Yang <richardw.yang@linux.intel.com>
Subject: mm/mremap: use pmd_addr_end to calculate next in move_page_tables()

Use the general helper instead of doing it by hand.

Link: http://lkml.kernel.org/r/20200117232254.2792-4-richardw.yang@linux.intel.com
Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/mremap.c~mm-mremap-use-pmd_addr_end-to-calculate-next-in-move_page_tables
+++ a/mm/mremap.c
@@ -253,11 +253,8 @@ unsigned long move_page_tables(struct vm
 
 	for (; old_addr < old_end; old_addr += extent, new_addr += extent) {
 		cond_resched();
-		next = (old_addr + PMD_SIZE) & PMD_MASK;
-		/* even if next overflowed, extent below will be ok */
+		next = pmd_addr_end(old_addr, old_end);
 		extent = next - old_addr;
-		if (extent > old_end - old_addr)
-			extent = old_end - old_addr;
 		old_pmd = get_old_pmd(vma->vm_mm, old_addr);
 		if (!old_pmd)
 			continue;
@@ -301,7 +298,7 @@ unsigned long move_page_tables(struct vm
 
 		if (pte_alloc(new_vma->vm_mm, new_pmd))
 			break;
-		next = (new_addr + PMD_SIZE) & PMD_MASK;
+		next = pmd_addr_end(new_addr, new_addr + len);
 		if (extent > next - new_addr)
 			extent = next - new_addr;
 		move_ptes(vma, old_pmd, old_addr, old_addr + extent, new_vma,
_

Patches currently in -mm which might be from richardw.yang@linux.intel.com are

mm-thp-remove-the-defer-list-related-code-since-this-will-not-happen.patch
mm-migratec-also-overwrite-error-when-it-is-bigger-than-zero.patch
mm-gupc-use-is_vm_hugetlb_page-to-check-whether-to-follow-huge.patch
mm-mremap-calculate-extent-in-one-place.patch
mm-mremap-start-addresses-are-properly-aligned.patch
mm-huge_memoryc-use-head-to-check-huge-zero-page.patch
mm-huge_memoryc-use-head-to-emphasize-the-purpose-of-page.patch
mm-huge_memoryc-reduce-critical-section-protected-by-split_queue_lock.patch
mm-remove-dead-code-totalram_pages_set.patch
