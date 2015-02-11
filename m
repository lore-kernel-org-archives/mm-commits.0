From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer-v4.patch removed from -mm tree
Date: Wed, 11 Feb 2015 15:16:58 -0800
Message-ID: <54dbe2ea.zmOjlTJVmLQVHUgQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43282 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbbBKXQ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 18:16:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, mgorman@suse.de, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer-v4
has been removed from the -mm tree.  Its filename was
     mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer-v4.patch

This patch was dropped because it was folded into mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer.patch

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer-v4

Changes from v3: Build fix for !CONFIG_COMPACTION

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/compaction.h |    2 ++
 mm/compaction.c                   |    1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN include/trace/events/compaction.h~mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer-v4 include/trace/events/compaction.h
--- a/include/trace/events/compaction.h~mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer-v4
+++ a/include/trace/events/compaction.h
@@ -238,6 +238,7 @@ DEFINE_EVENT(mm_compaction_suitable_temp
 	TP_ARGS(zone, order, ret)
 );
 
+#ifdef CONFIG_COMPACTION
 DECLARE_EVENT_CLASS(mm_compaction_defer_template,
 
 	TP_PROTO(struct zone *zone, int order),
@@ -291,6 +292,7 @@ DEFINE_EVENT(mm_compaction_defer_templat
 
 	TP_ARGS(zone, order)
 );
+#endif
 
 #endif /* _TRACE_COMPACTION_H */
 
diff -puN mm/compaction.c~mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer-v4 mm/compaction.c
--- a/mm/compaction.c~mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer-v4
+++ a/mm/compaction.c
@@ -1506,7 +1506,6 @@ unsigned long try_to_compact_pages(gfp_t
 			 * succeeds in this zone.
 			 */
 			compaction_defer_reset(zone, order, false);
-
 			/*
 			 * It is possible that async compaction aborted due to
 			 * need_resched() and the watermarks were ok thanks to
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
sparc32-fix-broken-set_pte.patch
mm-set-page-pfmemalloc-in-prep_new_page.patch
mm-page_alloc-reduce-number-of-alloc_pages-functions-parameters.patch
mm-reduce-try_to_compact_pages-parameters.patch
mm-microoptimize-zonelist-operations.patch
mm-cma-fix-totalcma_pages-to-include-dt-defined-cma-regions.patch
mm-compaction-change-tracepoint-format-from-decimal-to-hexadecimal.patch
mm-compaction-enhance-tracepoint-output-for-compaction-begin-end.patch
mm-compaction-print-current-range-where-compaction-work.patch
mm-compaction-more-trace-to-understand-when-why-compaction-start-finish.patch
mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer.patch
mm-when-stealing-freepages-also-take-pages-created-by-splitting-buddy-page.patch
mm-always-steal-split-buddies-in-fallback-allocations.patch
mm-more-aggressive-page-stealing-for-unmovable-allocations.patch
mm-page_ext-remove-unnecessary-stack_trace-field.patch
mm-page_ext-remove-unnecessary-stack_trace-field-fix.patch

