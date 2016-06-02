From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-introduce-post-allocation-processing-on-page-allocator.patch
 added to -mm tree
Date: Thu, 02 Jun 2016 12:49:37 -0700
Message-ID: <57508dd1.WtpGqFddrXS1Zg3U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50442 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbcFBTtj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jun 2016 15:49:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, glider@google.com, hughd@google.com, mgorman@techsingularity.net, mhocko@kernel.org, minchan@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: introduce post allocation processing on page allocator
has been added to the -mm tree.  Its filename is
     mm-page_alloc-introduce-post-allocation-processing-on-page-allocator.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-introduce-post-allocation-processing-on-page-allocator.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-introduce-post-allocation-processing-on-page-allocator.patch

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

Link: http://lkml.kernel.org/r/1464230275-25791-7-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c     |    8 +-------
 mm/internal.h       |    2 ++
 mm/page_alloc.c     |   22 +++++++++++++---------
 mm/page_isolation.c |    4 +---
 4 files changed, 17 insertions(+), 19 deletions(-)

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
@@ -149,6 +149,8 @@ extern int __isolate_free_page(struct pa
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
@@ -1722,6 +1722,18 @@ static bool check_new_pages(struct page
 	return false;
 }
 
+void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags)
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
@@ -1734,13 +1746,7 @@ static void prep_new_page(struct page *p
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
@@ -1749,8 +1755,6 @@ static void prep_new_page(struct page *p
 	if (order && (gfp_flags & __GFP_COMP))
 		prep_compound_page(page, order);
 
-	set_page_owner(page, order, gfp_flags);
-
 	/*
 	 * page is set pfmemalloc when ALLOC_NO_WATERMARKS was necessary to
 	 * allocate the page. The expectation is that the caller is taking
diff -puN mm/page_isolation.c~mm-page_alloc-introduce-post-allocation-processing-on-page-allocator mm/page_isolation.c
--- a/mm/page_isolation.c~mm-page_alloc-introduce-post-allocation-processing-on-page-allocator
+++ a/mm/page_isolation.c
@@ -128,9 +128,7 @@ static void unset_migratetype_isolate(st
 out:
 	spin_unlock_irqrestore(&zone->lock, flags);
 	if (isolated_page) {
-		kernel_map_pages(page, (1 << order), 1);
-		set_page_refcounted(page);
-		set_page_owner(page, order, __GFP_MOVABLE);
+		post_alloc_hook(page, order, __GFP_MOVABLE);
 		__free_pages(isolated_page, order);
 	}
 }
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-compaction-split-freepages-without-holding-the-zone-lock.patch
mm-page_owner-initialize-page-owner-without-holding-the-zone-lock.patch
mm-page_owner-copy-last_migrate_reason-in-copy_page_owner.patch
mm-page_owner-introduce-split_page_owner-and-replace-manual-handling.patch
tools-vm-page_owner-increase-temporary-buffer-size.patch
mm-page_owner-use-stackdepot-to-store-stacktrace.patch
mm-page_alloc-introduce-post-allocation-processing-on-page-allocator.patch

