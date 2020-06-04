From: akpm@linux-foundation.org
Subject: [merged]
 mm-thp-dont-need-drain-lru-cache-when-splitting-and-mlocking-thp.patch
 removed from -mm tree
Date: Thu, 04 Jun 2020 10:21:25 -0700
Message-ID: <20200604172125.E5xaGp1R9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730050AbgFDRV1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:21:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, daniel.m.jordan@oracle.com, hughd@google.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm: thp: don't need to drain lru cache when splitting and mlocking THP
has been removed from the -mm tree.  Its filename was
     mm-thp-dont-need-drain-lru-cache-when-splitting-and-mlocking-thp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm: thp: don't need to drain lru cache when splitting and mlocking THP

Since commit 8f182270dfec ("mm/swap.c: flush lru pvecs on compound page
arrival") THP would not stay in pagevec anymore.  So the optimization made
by commit d965432234db ("thp: increase split_huge_page() success rate")
doesn't make sense anymore, which tries to unpin munlocked THPs from
pagevec by draining pagevec.

Draining lru cache before isolating THP in mlock path is also unnecessary.
b676b293fb48 ("mm, thp: fix mapped pages avoiding unevictable list on
mlock") added it and 9a73f61bdb8a ("thp, mlock: do not mlock PTE-mapped
file huge pages") accidentally carried it over after the above
optimization went in.

Link: http://lkml.kernel.org/r/1585946493-7531-1-git-send-email-yang.shi@linux.alibaba.com
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/mm/huge_memory.c~mm-thp-dont-need-drain-lru-cache-when-splitting-and-mlocking-thp
+++ a/mm/huge_memory.c
@@ -1378,7 +1378,6 @@ struct page *follow_trans_huge_pmd(struc
 			goto skip_mlock;
 		if (!trylock_page(page))
 			goto skip_mlock;
-		lru_add_drain();
 		if (page->mapping && !PageDoubleMap(page))
 			mlock_vma_page(page);
 		unlock_page(page);
@@ -2582,7 +2581,6 @@ int split_huge_page_to_list(struct page
 	struct anon_vma *anon_vma = NULL;
 	struct address_space *mapping = NULL;
 	int count, mapcount, extra_pins, ret;
-	bool mlocked;
 	unsigned long flags;
 	pgoff_t end;
 
@@ -2641,14 +2639,9 @@ int split_huge_page_to_list(struct page
 		goto out_unlock;
 	}
 
-	mlocked = PageMlocked(head);
 	unmap_page(head);
 	VM_BUG_ON_PAGE(compound_mapcount(head), head);
 
-	/* Make sure the page is not on per-CPU pagevec as it takes pin */
-	if (mlocked)
-		lru_add_drain();
