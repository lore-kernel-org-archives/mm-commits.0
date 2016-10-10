From: akpm@linux-foundation.org
Subject: [merged]
 mm-fix-set-pageblock-migratetype-in-deferred-struct-page-init.patch removed from -mm tree
Date: Mon, 10 Oct 2016 15:43:23 -0700
Message-ID: <57fc198b.k4wSvk4HfnbsI4OZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36628 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752257AbcJJWnn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:43:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qiuxishi@huawei.com, iamjoonsoo.kim@lge.com, izumi.taku@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mhocko@suse.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix set pageblock migratetype in deferred struct page init
has been removed from the -mm tree.  Its filename was
     mm-fix-set-pageblock-migratetype-in-deferred-struct-page-init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: mm: fix set pageblock migratetype in deferred struct page init

On x86_64 MAX_ORDER_NR_PAGES is usually 4M, and a pageblock is usually 2M,
so we only set one pageblock's migratetype in deferred_free_range() if pfn
is aligned to MAX_ORDER_NR_PAGES.  That means it causes uninitialized
migratetype blocks, you can see from "cat /proc/pagetypeinfo", almost half
blocks are Unmovable.

Also we missed freeing the last block in deferred_init_memmap(), it causes
memory leak.

Fixes: ac5d2539b238 ("mm: meminit: reduce number of times pageblocks are set during struct page init")
Link: http://lkml.kernel.org/r/57A3260F.4050709@huawei.com
Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff -puN mm/page_alloc.c~mm-fix-set-pageblock-migratetype-in-deferred-struct-page-init mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-set-pageblock-migratetype-in-deferred-struct-page-init
+++ a/mm/page_alloc.c
@@ -1393,15 +1393,18 @@ static void __init deferred_free_range(s
 		return;
 
 	/* Free a large naturally-aligned chunk if possible */
-	if (nr_pages == MAX_ORDER_NR_PAGES &&
-	    (pfn & (MAX_ORDER_NR_PAGES-1)) == 0) {
+	if (nr_pages == pageblock_nr_pages &&
+	    (pfn & (pageblock_nr_pages - 1)) == 0) {
 		set_pageblock_migratetype(page, MIGRATE_MOVABLE);
-		__free_pages_boot_core(page, MAX_ORDER-1);
+		__free_pages_boot_core(page, pageblock_order);
 		return;
 	}
 
-	for (i = 0; i < nr_pages; i++, page++)
+	for (i = 0; i < nr_pages; i++, page++, pfn++) {
+		if ((pfn & (pageblock_nr_pages - 1)) == 0)
+			set_pageblock_migratetype(page, MIGRATE_MOVABLE);
 		__free_pages_boot_core(page, 0);
+	}
 }
 
 /* Completion tracking for deferred_init_memmap() threads */
@@ -1469,9 +1472,9 @@ static int __init deferred_init_memmap(v
 
 			/*
 			 * Ensure pfn_valid is checked every
-			 * MAX_ORDER_NR_PAGES for memory holes
+			 * pageblock_nr_pages for memory holes
 			 */
-			if ((pfn & (MAX_ORDER_NR_PAGES - 1)) == 0) {
+			if ((pfn & (pageblock_nr_pages - 1)) == 0) {
 				if (!pfn_valid(pfn)) {
 					page = NULL;
 					goto free_range;
@@ -1484,7 +1487,7 @@ static int __init deferred_init_memmap(v
 			}
 
 			/* Minimise pfn page lookups and scheduler checks */
-			if (page && (pfn & (MAX_ORDER_NR_PAGES - 1)) != 0) {
+			if (page && (pfn & (pageblock_nr_pages - 1)) != 0) {
 				page++;
 			} else {
 				nr_pages += nr_to_free;
@@ -1520,6 +1523,9 @@ free_range:
 			free_base_page = NULL;
 			free_base_pfn = nr_to_free = 0;
 		}
+		/* Free the last block of pages to allocator */
+		nr_pages += nr_to_free;
+		deferred_free_range(free_base_page, free_base_pfn, nr_to_free);
 
 		first_init_pfn = max(end_pfn, first_init_pfn);
 	}
_

Patches currently in -mm which might be from qiuxishi@huawei.com are


