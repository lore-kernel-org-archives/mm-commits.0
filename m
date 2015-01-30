From: akpm@linux-foundation.org
Subject: + mm-compaction-fix-wrong-order-check-in-compact_finished.patch
 added to -mm tree
Date: Fri, 30 Jan 2015 14:58:12 -0800
Message-ID: <54cc0c84.88p6lW0kgYDx9QuZ%akpm__24315.2498653673$1422658702$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48042 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbbA3W6N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Jan 2015 17:58:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, mgorman@suse.de, riel@redhat.com, rientjes@google.com, stable@vger.kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: fix wrong order check in compact_finished()
has been added to the -mm tree.  Its filename is
     mm-compaction-fix-wrong-order-check-in-compact_finished.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-fix-wrong-order-check-in-compact_finished.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-fix-wrong-order-check-in-compact_finished.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: From: Joonsoo <iamjoonsoo.kim@lge.com>
Subject: mm/compaction: fix wrong order check in compact_finished()

What we want to check here is whether there is highorder freepage in buddy
list of other migratetype in order to steal it without fragmentation. 
But, current code just checks cc->order which means allocation request
order.  So, this is wrong.

Without this fix, non-movable synchronous compaction below pageblock order
would not stopped until compaction is complete, because migratetype of
most pageblocks are movable and high order freepage made by compaction is
usually on movable type buddy list.

There is some report related to this bug. See below link.

http://www.spinics.net/lists/linux-mm/msg81666.html

Although the issued system still has load spike comes from compaction,
this makes that system completely stable and responsive according to his
report.

stress-highalloc test in mmtests with non movable order 7 allocation
doesn't show any notable difference in allocation success rate, but, it
shows more compaction success rate.

Compaction success rate (Compaction success * 100 / Compaction stalls, %)
18.47 : 28.94

Fixes: 1fb3f8ca0e922253 ("mm: compaction: capture a suitable high-order page immediately when it is made available")
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: <stable@vger.kernel.org>	[3.7+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-compaction-fix-wrong-order-check-in-compact_finished mm/compaction.c
--- a/mm/compaction.c~mm-compaction-fix-wrong-order-check-in-compact_finished
+++ a/mm/compaction.c
@@ -1173,7 +1173,7 @@ static int __compact_finished(struct zon
 			return COMPACT_PARTIAL;
 
 		/* Job done if allocation would set block type */
-		if (cc->order >= pageblock_order && area->nr_free)
+		if (order >= pageblock_order && area->nr_free)
 			return COMPACT_PARTIAL;
 	}
 
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-debug_pagealloc-fix-build-failure-on-ppc-and-some-other-archs.patch
mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off.patch
mm-slub-optimize-alloc-free-fastpath-by-removing-preemption-on-off-v3.patch
mm-dont-use-compound_head-in-virt_to_head_page.patch
mm-dont-use-compound_head-in-virt_to_head_page-v3.patch
mm-vmstatc-fix-cleanup-ifdefs.patch
mm-vmstatc-fix-cleanup-ifdefs-fix-2.patch
sparc32-fix-broken-set_pte.patch
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
mm-compaction-enhance-tracepoint-output-for-compaction-begin-end-v4-fix.patch
mm-compaction-print-current-range-where-compaction-work.patch
mm-compaction-more-trace-to-understand-when-why-compaction-start-finish.patch
mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer.patch
mm-compaction-add-tracepoint-to-observe-behaviour-of-compaction-defer-v4.patch
slab-embed-memcg_cache_params-to-kmem_cache.patch
slab-link-memcg-caches-of-the-same-kind-into-a-list.patch
cgroup-release-css-id-after-css_free.patch
slab-use-css-id-for-naming-per-memcg-caches.patch
memcg-free-memcg_caches-slot-on-css-offline.patch
list_lru-add-helpers-to-isolate-items.patch
memcg-reparent-list_lrus-and-free-kmemcg_id-on-css-offline.patch
slub-never-fail-to-shrink-cache.patch
slub-fix-kmem_cache_shrink-return-value.patch
slub-make-dead-caches-discard-free-slabs-immediately.patch
mm-when-stealing-freepages-also-take-pages-created-by-splitting-buddy-page.patch
mm-always-steal-split-buddies-in-fallback-allocations.patch
mm-more-aggressive-page-stealing-for-unmovable-allocations.patch
mm-page_ext-remove-unnecessary-stack_trace-field.patch
mm-page_ext-remove-unnecessary-stack_trace-field-fix.patch
mm-compaction-fix-wrong-order-check-in-compact_finished.patch
mm-compaction-stop-the-isolation-when-we-isolate-enough-freepage.patch
mm-util-add-kstrdup_const.patch
kernfs-convert-node-name-allocation-to-kstrdup_const.patch
clk-convert-clock-name-allocations-to-kstrdup_const.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const-fix.patch
fs-namespace-convert-devname-allocation-to-kstrdup_const.patch

