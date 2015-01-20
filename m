From: akpm@linux-foundation.org
Subject: +
 mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer-v4.patch added to -mm tree
Date: Tue, 20 Jan 2015 14:23:13 -0800
Message-ID: <54bed551.Bl3IcirBEC0I7oOh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47985 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbbATWXO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Jan 2015 17:23:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, mgorman@suse.de, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer-v4
has been added to the -mm tree.  Its filename is
     mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer-v4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer-v4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer-v4.patch

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

mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off.patch
mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off-v3.patch
mm-dont-use-compound_head-in-virt_to_head_page.patch
mm-dont-use-compound_head-in-virt_to_head_page-v3.patch
mm-vmstatc-fix-cleanup-ifdefs.patch
mm-vmstatc-fix-cleanup-ifdefs-fix.patch
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
mm-compaction-enhance-tracepoint-output-for-compaction-begin-end-v4.patch
mm-compaction-print-current-range-where-compaction-work.patch
mm-compaction-more-trace-to-understand-when-why-compaction-start-finish.patch
mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer.patch
mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer-v4.patch
mm-util-add-kstrdup_const.patch
kernfs-convert-node-name-allocation-to-kstrdup_const.patch
clk-convert-clock-name-allocations-to-kstrdup_const.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const-fix.patch
fs-namespace-convert-devname-allocation-to-kstrdup_const.patch

