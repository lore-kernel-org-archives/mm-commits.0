From: akpm@linux-foundation.org
Subject: [merged] mm-huge_memory-fix-typo-when-updating-mmu-cache.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:12:23 -0700
Message-ID: <201111012112.pA1LCN6s006192@hpaq1.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:16016 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab1KAVM2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:12:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhillf@gmail.com, aarcange@redhat.com, jweiner@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory: fix typo when updating mmu cache
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-fix-typo-when-updating-mmu-cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hillf Danton <dhillf@gmail.com>
Subject: mm/huge_memory: fix typo when updating mmu cache

There are three cases of update_mmu_cache() in the file, and the case in
function collapse_huge_page() has a typo, namely the last parameter used,
which is corrected based on the other two cases.

Due to the define of update_mmu_cache by X86, the only arch that
implements THP currently, the change here has no really crystal point, but
one or two minutes of efforts could be saved for those archs that are
likely to support THP in future.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/huge_memory.c~mm-huge_memory-fix-typo-when-updating-mmu-cache mm/huge_memory.c
--- a/mm/huge_memory.c~mm-huge_memory-fix-typo-when-updating-mmu-cache
+++ a/mm/huge_memory.c
@@ -1952,7 +1952,7 @@ static void collapse_huge_page(struct mm
 	BUG_ON(!pmd_none(*pmd));
 	page_add_new_anon_rmap(new_page, vma, address);
 	set_pmd_at(mm, address, pmd, _pmd);
-	update_mmu_cache(vma, address, entry);
+	update_mmu_cache(vma, address, _pmd);
 	prepare_pmd_huge_pte(pgtable, mm);
 	mm->nr_ptes--;
 	spin_unlock(&mm->page_table_lock);
_

Patches currently in -mm which might be from dhillf@gmail.com are

origin.patch
linux-next.patch

