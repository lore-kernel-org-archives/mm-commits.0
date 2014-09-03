From: akpm@linux-foundation.org
Subject: [merged] mm-actually-clear-pmd_numa-before-invalidating.patch
 removed from -mm tree
Date: Wed, 03 Sep 2014 10:57:23 -0700
Message-ID: <54075683.3dtjoFoabjEs2bnO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42832 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920AbaICR5Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2014 13:57:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew.r.wilcox@intel.com, mgorman@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: actually clear pmd_numa before invalidating
has been removed from the -mm tree.  Its filename was
     mm-actually-clear-pmd_numa-before-invalidating.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: mm: actually clear pmd_numa before invalidating

Commit 67f87463d3 ("mm: clear pmd_numa before invalidating") cleared the
NUMA bit in a copy of the PMD entry, but then wrote back the original

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pgtable-generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/pgtable-generic.c~mm-actually-clear-pmd_numa-before-invalidating mm/pgtable-generic.c
--- a/mm/pgtable-generic.c~mm-actually-clear-pmd_numa-before-invalidating
+++ a/mm/pgtable-generic.c
@@ -195,7 +195,7 @@ void pmdp_invalidate(struct vm_area_stru
 	pmd_t entry = *pmdp;
 	if (pmd_numa(entry))
 		entry = pmd_mknonnuma(entry);
-	set_pmd_at(vma->vm_mm, address, pmdp, pmd_mknotpresent(*pmdp));
+	set_pmd_at(vma->vm_mm, address, pmdp, pmd_mknotpresent(entry));
 	flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
_

Patches currently in -mm which might be from matthew.r.wilcox@intel.com are

mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

