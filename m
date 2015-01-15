From: akpm@linux-foundation.org
Subject: +
 mm-compaction-change-tracepoint-format-from-decimal-to-hexadecimal.patch
 added to -mm tree
Date: Thu, 15 Jan 2015 15:51:59 -0800
Message-ID: <54b8529f.BjvWiS+dxcT2Xbfj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60625 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbbAOXwM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jan 2015 18:52:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, mgorman@suse.de, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: change tracepoint format from decimal to hexadecimal
has been added to the -mm tree.  Its filename is
     mm-compaction-change-tracepoint-format-from-decimal-to-hexadecimal.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-change-tracepoint-format-from-decimal-to-hexadecimal.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-change-tracepoint-format-from-decimal-to-hexadecimal.patch

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
Subject: mm/compaction: change tracepoint format from decimal to hexadecimal

To check the range that compaction is working, tracepoint print start/end
pfn of zone and start pfn of both scanner with decimal format.  Since we
manage all pages in order of 2 and it is well represented by hexadecimal,
this patch change the tracepoint format from decimal to hexadecimal.  This
would improve readability.  For example, it makes us easily notice whether
current scanner try to compact previously attempted pageblock or not.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/compaction.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/trace/events/compaction.h~mm-compaction-change-tracepoint-format-from-decimal-to-hexadecimal include/trace/events/compaction.h
--- a/include/trace/events/compaction.h~mm-compaction-change-tracepoint-format-from-decimal-to-hexadecimal
+++ a/include/trace/events/compaction.h
@@ -104,7 +104,7 @@ TRACE_EVENT(mm_compaction_begin,
 		__entry->zone_end = zone_end;
 	),
 
-	TP_printk("zone_start=%lu migrate_start=%lu free_start=%lu zone_end=%lu",
+	TP_printk("zone_start=0x%lx migrate_start=0x%lx free_start=0x%lx zone_end=0x%lx",
 		__entry->zone_start,
 		__entry->migrate_start,
 		__entry->free_start,
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-vmstatc-fix-cleanup-ifdefs.patch
mm-set-page-pfmemalloc-in-prep_new_page.patch
mm-page_alloc-reduce-number-of-alloc_pages-functions-parameters.patch
mm-reduce-try_to_compact_pages-parameters.patch
mm-microoptimize-zonelist-operations.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
mm-cma-fix-totalcma_pages-to-include-dt-defined-cma-regions.patch
mm-compaction-change-tracepoint-format-from-decimal-to-hexadecimal.patch
mm-compaction-enhance-tracepoint-output-for-compaction-begin-end.patch
mm-compaction-print-current-range-where-compaction-work.patch
mm-compaction-more-trace-to-understand-when-why-compaction-start-finish.patch
mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer.patch
mm-util-add-kstrdup_const.patch
kernfs-convert-node-name-allocation-to-kstrdup_const.patch
clk-convert-clock-name-allocations-to-kstrdup_const.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const.patch
fs-namespace-convert-devname-allocation-to-kstrdup_const.patch

