From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-introduce-post-allocation-processing-on-page-allocator.patch
 removed from -mm tree
Date: Wed, 27 Jul 2016 12:01:01 -0700
Message-ID: <579904ed.hW7JXlaBxcOA7IzW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40348 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190AbcG0TBC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 15:01:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, glider@google.com, hughd@google.com, mgorman@techsingularity.net, mhocko@kernel.org, minchan@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: introduce post allocation processing on page allocator
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-introduce-post-allocation-processing-on-page-allocator.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/page_alloc: introduce post allocation processing on page allocator

This patch is motivated from Hugh and Vlastimil's concern [1].

There are two ways to get freepage from the allocator.  One is using
normal memory allocation API and the other is __isolate_free_page() which
is internally used for compaction and pageblock isolation.  Later usage is
rather tricky since it doesn't do whole post allocation processing done by
normal API.

One problematic thing I already know is that poisoned page would not be
checked if it is allocated by __isolate_free_page().  Perhaps, there would
be more.

We could add more debug logic for allocated page in the future and this
separation would cause more problem.  I'd like to fix this situation at
this time.  Solution is simple.  This patch commonize some logic for newly
allocated page and uses it on all sites.  This will solve the problem.

[1] http://marc.info/?i=alpine.LSU.2.11.1604270029350.7066%40eggly.anvils%3E

[iamjoonsoo.kim@lge.com: mm-page_alloc-introduce-post-allocation-processing-on-page-allocator-v3]
  Link: http://lkml.kernel.org/r/1464230275-25791-7-git-send-email-iamjoonsoo.kim@lge.com
  Link: http://lkml.kernel.org/r/1466150259-27727-9-git-send-email-iamjoonsoo.kim@lge.com
Link: http://lkml.kernel.org/r/1464230275-25791-7-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c     |    8 +-------
 mm/internal.h       |    2 ++
 mm/page_alloc.c     |   23 ++++++++++++++---------
 mm/page_isolation.c |    4 +---
 4 files changed, 18 insertions(+), 19 deletions(-)

diff -puN mm/compaction.c~mm-page_alloc-introduce-post-allocation-processing-on-page-allocator mm/compaction.c
--- a/mm/compaction.c~mm-page_alloc-introduce-post-allocation-processing-on-page-allocator
+++ a/mm/compaction.c
@@ -74,14 +74,8 @@ static void map_pages(struct list_head *
 
 		order = page_private(page);
 		nr_pages = 1 << order;
-		set_page_private(page, 0);
-		set_page_refcounted(page);
 
-		arch_alloc_page(page, order);
-		kernel_map_pages(page, nr_pages, 1);
-		kasan_alloc_pages(page, order);
-
-		set_page_owner(page, order, __GFP_MOVABLE);
+		post_alloc_hook(page, order, __GFP_MOVABLE);
 		if (order)
 			split_page(page, order);
 
diff -puN mm/internal.h~mm-page_alloc-introduce-post-allocation-processing-on-page-allocator mm/internal.h
--- a/mm/internal.h~mm-page_alloc-introduce-post-allocation-processing-on-page-allocator
+++ a/mm/internal.h
@@ -150,6 +150,8 @@ extern int __isolate_free_page(struct pa
 extern void __free_pages_bootmem(struct page *page, unsigned long pfn,
 					unsigned int order);
 extern void prep_compound_page(struct page *page, unsigned int order);
+extern void post_alloc_hook(struct page *page, unsigned int order,
+					gfp_t gfp_flags);
 extern int user_min_free_kbytes;
 
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
diff -puN mm/page_alloc.c~mm-page_alloc-introduce-post-allocation-processing-on-page-allocator mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-introduce-post-allocation-processing-on-page-allocator
+++ a/mm/page_alloc.c
@@ -1724,6 +1724,19 @@ static bool check_new_pages(struct page
 	return false;
 }
 
+inline void post_alloc_hook(struct page *page, unsigned int order,
+				gfp_t gfp_flags)
+{
+	set_page_private(page, 0);
+	set_page_refcounted(page);
+
+	arch_alloc_page(page, order);
+	kernel_map_pages(page, 1 << order, 1);
+	kernel_poison_pages(page, 1 << order, 1);
+	kasan_alloc_pages(page, order);
+	set_page_owner(page, order, gfp_flags);
+}
+
 static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags,
 							unsigned int alloc_flags)
 {
@@ -1736,13 +1749,7 @@ static void prep_new_page(struct page *p
 			poisoned &= page_is_poisoned(p);
 	}
 
-	set_page_private(page, 0);
-	set_page_refcounted(page);
-
-	arch_alloc_page(page, order);
-	kernel_map_pages(page, 1 << order, 1);
-	kernel_poison_pages(page, 1 << order, 1);
-	kasan_alloc_pages(page, order);
+	post_alloc_hook(page, order, gfp_flags);
 
 	if (!free_pages_prezeroed(poisoned) && (gfp_flags & __GFP_ZERO))
 		for (i = 0; i < (1 << order); i++)
@@ -1751,8 +1758,6 @@ static void prep_new_page(struct page *p
 	if (order && (gfp_flags & __GFP_COMP))
 		prep_compound_page(page, order);
 
-	set_page_owner(page, order, gfp_flags);
