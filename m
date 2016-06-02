From: akpm@linux-foundation.org
Subject: +
 mm-page_owner-initialize-page-owner-without-holding-the-zone-lock.patch
 added to -mm tree
Date: Thu, 02 Jun 2016 12:49:27 -0700
Message-ID: <57508dc7.AH3HcTVWjVlJpXfU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50414 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbcFBTt3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jun 2016 15:49:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, glider@google.com, hughd@google.com, mgorman@techsingularity.net, mhocko@kernel.org, minchan@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_owner: initialize page owner without holding the zone lock
has been added to the -mm tree.  Its filename is
     mm-page_owner-initialize-page-owner-without-holding-the-zone-lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_owner-initialize-page-owner-without-holding-the-zone-lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_owner-initialize-page-owner-without-holding-the-zone-lock.patch

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
Subject: mm/page_owner: initialize page owner without holding the zone lock

It's not necessary to initialized page_owner with holding the zone lock. 
It would cause more contention on the zone lock although it's not a big
problem since it is just debug feature.  But, it is better than before so
do it.  This is also preparation step to use stackdepot in page owner
feature.  Stackdepot allocates new pages when there is no reserved space
and holding the zone lock in this case will cause deadlock.

Link: http://lkml.kernel.org/r/1464230275-25791-2-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c     |    3 +++
 mm/page_alloc.c     |    2 --
 mm/page_isolation.c |    9 ++++++---
 3 files changed, 9 insertions(+), 5 deletions(-)

diff -puN mm/compaction.c~mm-page_owner-initialize-page-owner-without-holding-the-zone-lock mm/compaction.c
--- a/mm/compaction.c~mm-page_owner-initialize-page-owner-without-holding-the-zone-lock
+++ a/mm/compaction.c
@@ -19,6 +19,7 @@
 #include <linux/kasan.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
+#include <linux/page_owner.h>
 #include "internal.h"
 
 #ifdef CONFIG_COMPACTION
@@ -79,6 +80,8 @@ static void map_pages(struct list_head *
 		arch_alloc_page(page, order);
 		kernel_map_pages(page, nr_pages, 1);
 		kasan_alloc_pages(page, order);
+
+		set_page_owner(page, order, __GFP_MOVABLE);
 		if (order)
 			split_page(page, order);
 
diff -puN mm/page_alloc.c~mm-page_owner-initialize-page-owner-without-holding-the-zone-lock mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_owner-initialize-page-owner-without-holding-the-zone-lock
+++ a/mm/page_alloc.c
@@ -2507,8 +2507,6 @@ int __isolate_free_page(struct page *pag
 	zone->free_area[order].nr_free--;
 	rmv_page_order(page);
 
-	set_page_owner(page, order, __GFP_MOVABLE);
-
 	/* Set the pageblock if the isolated page is at least a pageblock */
 	if (order >= pageblock_order - 1) {
 		struct page *endpage = page + (1 << order) - 1;
diff -puN mm/page_isolation.c~mm-page_owner-initialize-page-owner-without-holding-the-zone-lock mm/page_isolation.c
--- a/mm/page_isolation.c~mm-page_owner-initialize-page-owner-without-holding-the-zone-lock
+++ a/mm/page_isolation.c
@@ -7,6 +7,7 @@
 #include <linux/pageblock-flags.h>
 #include <linux/memory.h>
 #include <linux/hugetlb.h>
+#include <linux/page_owner.h>
 #include "internal.h"
 
 #define CREATE_TRACE_POINTS
@@ -108,8 +109,6 @@ static void unset_migratetype_isolate(st
 			if (pfn_valid_within(page_to_pfn(buddy)) &&
 			    !is_migrate_isolate_page(buddy)) {
 				__isolate_free_page(page, order);
-				kernel_map_pages(page, (1 << order), 1);
-				set_page_refcounted(page);
 				isolated_page = page;
 			}
 		}
@@ -128,8 +127,12 @@ static void unset_migratetype_isolate(st
 	zone->nr_isolate_pageblock--;
 out:
 	spin_unlock_irqrestore(&zone->lock, flags);
-	if (isolated_page)
+	if (isolated_page) {
+		kernel_map_pages(page, (1 << order), 1);
+		set_page_refcounted(page);
+		set_page_owner(page, order, __GFP_MOVABLE);
 		__free_pages(isolated_page, order);
+	}
 }
 
 static inline struct page *
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-compaction-split-freepages-without-holding-the-zone-lock.patch
mm-page_owner-initialize-page-owner-without-holding-the-zone-lock.patch
mm-page_owner-copy-last_migrate_reason-in-copy_page_owner.patch
mm-page_owner-introduce-split_page_owner-and-replace-manual-handling.patch
tools-vm-page_owner-increase-temporary-buffer-size.patch
mm-page_owner-use-stackdepot-to-store-stacktrace.patch
mm-page_alloc-introduce-post-allocation-processing-on-page-allocator.patch

