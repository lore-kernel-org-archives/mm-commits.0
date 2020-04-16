From: akpm@linux-foundation.org
Subject: +
 mm-thp-dont-need-drain-lru-cache-when-splitting-and-mlocking-thp.patch
 added to -mm tree
Date: Wed, 15 Apr 2020 17:55:01 -0700
Message-ID: <20200416005501.EAIIQ1GzK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405346AbgDPAzD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Apr 2020 20:55:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, daniel.m.jordan@oracle.com, hughd@google.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm: thp: don't need to drain lru cache when splitting and mlocking THP
has been added to the -mm tree.  Its filename is
     mm-thp-dont-need-drain-lru-cache-when-splitting-and-mlocking-thp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-dont-need-drain-lru-cache-when-splitting-and-mlocking-thp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-dont-need-drain-lru-cache-when-splitting-and-mlocking-thp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1582,7 +1582,6 @@ struct page *follow_trans_huge_pmd(struc
 			goto skip_mlock;
 		if (!trylock_page(page))
 			goto skip_mlock;
-		lru_add_drain();
 		if (page->mapping && !PageDoubleMap(page))
 			mlock_vma_page(page);
 		unlock_page(page);
@@ -2784,7 +2783,6 @@ int split_huge_page_to_list(struct page
 	struct anon_vma *anon_vma = NULL;
 	struct address_space *mapping = NULL;
 	int count, mapcount, extra_pins, ret;
-	bool mlocked;
 	unsigned long flags;
 	pgoff_t end;
 
@@ -2843,14 +2841,9 @@ int split_huge_page_to_list(struct page
 		goto out_unlock;
 	}
 
-	mlocked = PageMlocked(head);
 	unmap_page(head);
 	VM_BUG_ON_PAGE(compound_mapcount(head), head);
 
-	/* Make sure the page is not on per-CPU pagevec as it takes pin */
-	if (mlocked)
-		lru_add_drain();
