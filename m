From: akpm@linux-foundation.org
Subject: + mm-page_alloc-shorten-the-page-allocator-fast-path.patch added
 to -mm tree
Date: Fri, 15 Apr 2016 16:12:19 -0700
Message-ID: <57117553.uUHvOpMXHeDWlsJi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42580 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbcDOXMU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Apr 2016 19:12:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, brouer@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: shorten the page allocator fast path
has been added to the -mm tree.  Its filename is
     mm-page_alloc-shorten-the-page-allocator-fast-path.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-shorten-the-page-allocator-fast-path.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-shorten-the-page-allocator-fast-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: shorten the page allocator fast path

The page allocator fast path checks page multiple times unnecessarily. 
This patch avoids all the slowpath checks if the first allocation attempt
succeeds.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-shorten-the-page-allocator-fast-path mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-shorten-the-page-allocator-fast-path
+++ a/mm/page_alloc.c
@@ -3418,22 +3418,17 @@ retry_cpuset:
 
 	/* First allocation attempt */
 	page = get_page_from_freelist(alloc_mask, order, alloc_flags, &ac);
-	if (unlikely(!page)) {
-		/*
-		 * Runtime PM, block IO and its error handling path
-		 * can deadlock because I/O on the device might not
-		 * complete.
-		 */
-		alloc_mask = memalloc_noio_flags(gfp_mask);
-		ac.spread_dirty_pages = false;
+	if (likely(page))
+		goto out;
 
-		page = __alloc_pages_slowpath(alloc_mask, order, &ac);
-	}
-
-	if (kmemcheck_enabled && page)
-		kmemcheck_pagealloc_alloc(page, order, gfp_mask);
+	/*
+	 * Runtime PM, block IO and its error handling path can deadlock
+	 * because I/O on the device might not complete.
+	 */
+	alloc_mask = memalloc_noio_flags(gfp_mask);
+	ac.spread_dirty_pages = false;
 
-	trace_mm_page_alloc(page, order, alloc_mask, ac.migratetype);
+	page = __alloc_pages_slowpath(alloc_mask, order, &ac);
 
 	/*
 	 * When updating a task's mems_allowed, it is possible to race with
@@ -3446,6 +3441,12 @@ retry_cpuset:
 		goto retry_cpuset;
 	}
 
+out:
+	if (kmemcheck_enabled && page)
+		kmemcheck_pagealloc_alloc(page, order, gfp_mask);
+
+	trace_mm_page_alloc(page, order, alloc_mask, ac.migratetype);
+
 	return page;
 }
 EXPORT_SYMBOL(__alloc_pages_nodemask);
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-only-check-pagecompound-for-high-order-pages.patch
mm-page_alloc-use-new-pageanonhead-helper-in-the-free-page-fast-path.patch
mm-page_alloc-reduce-branches-in-zone_statistics.patch
mm-page_alloc-inline-zone_statistics.patch
mm-page_alloc-inline-the-fast-path-of-the-zonelist-iterator.patch
mm-page_alloc-use-__dec_zone_state-for-order-0-page-allocation.patch
mm-page_alloc-avoid-unnecessary-zone-lookups-during-pageblock-operations.patch
mm-page_alloc-convert-alloc_flags-to-unsigned.patch
mm-page_alloc-convert-nr_fair_skipped-to-bool.patch
mm-page_alloc-remove-unnecessary-local-variable-in-get_page_from_freelist.patch
mm-page_alloc-remove-unnecessary-initialisation-in-get_page_from_freelist.patch
mm-page_alloc-remove-redundant-check-for-empty-zonelist.patch
mm-page_alloc-simplify-last-cpupid-reset.patch
mm-page_alloc-move-might_sleep_if-check-to-the-allocator-slowpath.patch
mm-page_alloc-move-__gfp_hardwall-modifications-out-of-the-fastpath.patch
mm-page_alloc-check-once-if-a-zone-has-isolated-pageblocks.patch
mm-page_alloc-shorten-the-page-allocator-fast-path.patch
mm-page_alloc-reduce-cost-of-fair-zone-allocation-policy-retry.patch
mm-page_alloc-shortcut-watermark-checks-for-order-0-pages.patch
mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice.patch
mm-page_alloc-remove-field-from-alloc_context.patch
mm-page_alloc-check-multiple-page-fields-with-a-single-branch.patch
mm-page_alloc-remove-unnecessary-variable-from-free_pcppages_bulk.patch
mm-page_alloc-inline-pageblock-lookup-in-page-free-fast-paths.patch
mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain.patch
mm-page_alloc-defer-debugging-checks-of-pages-allocated-from-the-pcp.patch

