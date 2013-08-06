From: akpm@linux-foundation.org
Subject: + swap-clean-up-ifdef-in-page_mapping.patch added to -mm tree
Date: Tue, 06 Aug 2013 15:13:41 -0700
Message-ID: <52017515.j91vzlzpi/cYpAXN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56584 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756632Ab3HFWNm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Aug 2013 18:13:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, minchan@kernel.org, mgorman@suse.de, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com

Subject: + swap-clean-up-ifdef-in-page_mapping.patch added to -mm tree
To: iamjoonsoo.kim@lge.com,hannes@cmpxchg.org,mgorman@suse.de,minchan@kernel.org,riel@redhat.com
From: akpm@linux-foundation.org
Date: Tue, 06 Aug 2013 15:13:41 -0700


The patch titled
     Subject: swap: clean-up #ifdef in page_mapping()
has been added to the -mm tree.  Its filename is
     swap-clean-up-ifdef-in-page_mapping.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/swap-clean-up-ifdef-in-page_mapping.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/swap-clean-up-ifdef-in-page_mapping.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: swap: clean-up #ifdef in page_mapping()

PageSwapCache() is always false when !CONFIG_SWAP, so compiler
properly discard related code. Therefore, we don't need #ifdef explicitly.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 +
 mm/util.c            |    5 +----
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN include/linux/swap.h~swap-clean-up-ifdef-in-page_mapping include/linux/swap.h
--- a/include/linux/swap.h~swap-clean-up-ifdef-in-page_mapping
+++ a/include/linux/swap.h
@@ -447,6 +447,7 @@ mem_cgroup_uncharge_swapcache(struct pag
 
 #else /* CONFIG_SWAP */
 
+#define swap_address_space(entry)		(NULL)
 #define get_nr_swap_pages()			0L
 #define total_swap_pages			0L
 #define total_swapcache_pages()			0UL
diff -puN mm/util.c~swap-clean-up-ifdef-in-page_mapping mm/util.c
--- a/mm/util.c~swap-clean-up-ifdef-in-page_mapping
+++ a/mm/util.c
@@ -388,15 +388,12 @@ struct address_space *page_mapping(struc
 	struct address_space *mapping = page->mapping;
 
 	VM_BUG_ON(PageSlab(page));
-#ifdef CONFIG_SWAP
 	if (unlikely(PageSwapCache(page))) {
 		swp_entry_t entry;
 
 		entry.val = page_private(page);
 		mapping = swap_address_space(entry);
-	} else
-#endif
-	if ((unsigned long)mapping & PAGE_MAPPING_ANON)
+	} else if ((unsigned long)mapping & PAGE_MAPPING_ANON)
 		mapping = NULL;
 	return mapping;
 }
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-hugetlb-move-up-the-code-which-check-availability-of-free-huge-page.patch
mm-hugetlb-trivial-commenting-fix.patch
mm-hugetlb-clean-up-alloc_huge_page.patch
mm-hugetlb-fix-and-clean-up-node-iteration-code-to-alloc-or-free.patch
mm-hugetlb-remove-redundant-list_empty-check-in-gather_surplus_pages.patch
mm-hugetlb-do-not-use-a-page-in-page-cache-for-cow-optimization.patch
mm-hugetlb-add-vm_noreserve-check-in-vma_has_reserves.patch
mm-hugetlb-remove-decrement_hugepage_resv_vma.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix.patch
mm-page_alloc-add-unlikely-macro-to-help-compiler-optimization.patch
mm-move-pgtable-related-functions-to-right-place.patch
swap-clean-up-ifdef-in-page_mapping.patch

