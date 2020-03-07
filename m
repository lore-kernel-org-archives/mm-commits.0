From: akpm@linux-foundation.org
Subject: [merged]
 mm-fix-possible-pmd-dirty-bit-lost-in-set_pmd_migration_entry.patch removed
 from -mm tree
Date: Fri, 06 Mar 2020 20:01:17 -0800
Message-ID: <20200307040117.u9Y2Kxoru%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgCGEBT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 6 Mar 2020 23:01:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, mm-commits@vger.kernel.org, stable@vger.kernel.org, vbabka@suse.cz, william.kucharski@oracle.com, ying.huang@intel.com, ziy@nvidia.com


The patch titled
     Subject: mm: fix possible PMD dirty bit lost in set_pmd_migration_entry()
has been removed from the -mm tree.  Its filename was
     mm-fix-possible-pmd-dirty-bit-lost-in-set_pmd_migration_entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm: fix possible PMD dirty bit lost in set_pmd_migration_entry()

In set_pmd_migration_entry(), pmdp_invalidate() is used to change PMD
atomically.  But the PMD is read before that with an ordinary memory
reading.  If the THP (transparent huge page) is written between the PMD
reading and pmdp_invalidate(), the PMD dirty bit may be lost, and cause
data corruption.  The race window is quite small, but still possible in
theory, so need to be fixed.

The race is fixed via using the return value of pmdp_invalidate() to get
the original content of PMD, which is a read/modify/write atomic
operation.  So no THP writing can occur in between.

The race has been introduced when the THP migration support is added in
the commit 616b8371539a ("mm: thp: enable thp migration in generic path").
But this fix depends on the commit d52605d7cb30 ("mm: do not lose dirty
and accessed bits in pmdp_invalidate()").  So it's easy to be backported
after v4.16.  But the race window is really small, so it may be fine not
to backport the fix at all.

Link: http://lkml.kernel.org/r/20200220075220.2327056-1-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-fix-possible-pmd-dirty-bit-lost-in-set_pmd_migration_entry
+++ a/mm/huge_memory.c
@@ -3043,8 +3043,7 @@ void set_pmd_migration_entry(struct page
 		return;
 
 	flush_cache_range(vma, address, address + HPAGE_PMD_SIZE);
-	pmdval = *pvmw->pmd;
-	pmdp_invalidate(vma, address, pvmw->pmd);
+	pmdval = pmdp_invalidate(vma, address, pvmw->pmd);
 	if (pmd_dirty(pmdval))
 		set_page_dirty(page);
 	entry = make_migration_entry(page, pmd_write(pmdval));
_

Patches currently in -mm which might be from ying.huang@intel.com are
