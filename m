From: akpm@linux-foundation.org
Subject: + page-allocator-remove-dead-function-free_cold_page.patch added to -mm tree
Date: Wed, 05 Aug 2009 18:53:04 -0700
Message-ID: <200908060153.n761r46l003573@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41450 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753116AbZHFBx2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Aug 2009 21:53:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie


The patch titled
     page-allocator: remove dead function free_cold_page()
has been added to the -mm tree.  Its filename is
     page-allocator-remove-dead-function-free_cold_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page-allocator: remove dead function free_cold_page()
From: Mel Gorman <mel@csn.ul.ie>

The function free_cold_page() has no callers so delete it.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    1 -
 mm/page_alloc.c     |    5 -----
 2 files changed, 6 deletions(-)

diff -puN include/linux/gfp.h~page-allocator-remove-dead-function-free_cold_page include/linux/gfp.h
--- a/include/linux/gfp.h~page-allocator-remove-dead-function-free_cold_page
+++ a/include/linux/gfp.h
@@ -326,7 +326,6 @@ void free_pages_exact(void *virt, size_t
 extern void __free_pages(struct page *page, unsigned int order);
 extern void free_pages(unsigned long addr, unsigned int order);
 extern void free_hot_page(struct page *page);
-extern void free_cold_page(struct page *page);
 
 #define __free_page(page) __free_pages((page), 0)
 #define free_page(addr) free_pages((addr),0)
diff -puN mm/page_alloc.c~page-allocator-remove-dead-function-free_cold_page mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-remove-dead-function-free_cold_page
+++ a/mm/page_alloc.c
@@ -1082,11 +1082,6 @@ void free_hot_page(struct page *page)
 	free_hot_cold_page(page, 0);
 }
 	
-void free_cold_page(struct page *page)
-{
-	free_hot_cold_page(page, 1);
-}
-
 /*
  * split_page takes a non-compound higher-order page, and splits it into
  * n (1<<order) sub-pages: page[0..n]
_

Patches currently in -mm which might be from mel@csn.ul.ie are

memory-hotplug-update-zone-pcp-at-memory-online.patch
memory-hotplug-update-zone-pcp-at-memory-online-fix.patch
memory-hotplug-exclude-isolated-page-from-pco-page-alloc.patch
memory-hotplug-make-pages-from-movable-zone-always-isolatable.patch
memory-hotplug-alloc-page-from-other-node-in-memory-online.patch
memory-hotplug-migrate-swap-cache-page.patch
hugetlb-balance-freeing-of-huge-pages-across-nodes.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages-fix.patch
hugetlb-clean-up-and-update-huge-pages-documentation.patch
hugetlb-restore-interleaving-of-bootmem-huge-pages.patch
mm-clean-up-page_remove_rmap.patch
mm-update-alloc_flags-after-oom-killer-has-been-called.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
vmscan-move-clearpageactive-from-move_active_pages-to-shrink_active_list.patch
vmscan-kill-unnecessary-page-flag-test.patch
vmscan-kill-unnecessary-prefetch.patch
mm-perform-non-atomic-test-clear-of-pg_mlocked-on-free.patch
mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set.patch
page-allocator-change-migratetype-for-all-pageblocks-within-a-high-order-page-during-__rmqueue_fallback.patch
page-allocator-remove-dead-function-free_cold_page.patch
add-debugging-aid-for-memory-initialisation-problems.patch

