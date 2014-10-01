From: akpm@linux-foundation.org
Subject: +
 mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range-fix.patch added to -mm tree
Date: Wed, 01 Oct 2014 14:53:33 -0700
Message-ID: <542c77dd.tI31s1Kw6x9oZ+Li%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44934 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbaJAVxe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2014 17:53:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: fix isolated page counting bug in compaction
has been added to the -mm tree.  Its filename is
     mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range-fix.patch

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
Subject: mm/compaction: fix isolated page counting bug in compaction

acct_isolated() is the function to adjust isolated page count.  It
iterates cc->migratepages list and add NR_ISOLATED_ANON/NR_ISOLATED_FILE
count according to number of anon, file pages in migratepages list,
respectively.  Before commit (mm, compaction: move pageblock checks up
from isolate_migratepages_range()), it is called just once in
isolate_migratepages_range(), but, after commit, it is called in newly
introduced isolate_migratepages_block() and this
isolate_migratepages_block() could be called many times in
isolate_migratepages_range() so that some page could be counted more than
once.  This duplicate counting bug results in hang in cma_alloc(), because
too_many_isolated() returns true continually.

This patch fixes this bug by moving acct_isolated() into upper layer
function, isolate_migratepages_range() and isolate_migratepages().  After
this change, isolated page would be counted only once so problem would be
gone.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff -puN mm/compaction.c~mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range-fix mm/compaction.c
--- a/mm/compaction.c~mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range-fix
+++ a/mm/compaction.c
@@ -414,22 +414,19 @@ isolate_freepages_range(struct compact_c
 }
 
 /* Update the number of anon and file isolated pages in the zone */
-static void acct_isolated(struct zone *zone, bool locked, struct compact_control *cc)
+static void acct_isolated(struct zone *zone, struct compact_control *cc)
 {
 	struct page *page;
 	unsigned int count[2] = { 0, };
 
+	if (list_empty(&cc->migratepages))
+		return;
+
 	list_for_each_entry(page, &cc->migratepages, lru)
 		count[!!page_is_file_cache(page)]++;
 
-	/* If locked we can use the interrupt unsafe versions */
-	if (locked) {
-		__mod_zone_page_state(zone, NR_ISOLATED_ANON, count[0]);
-		__mod_zone_page_state(zone, NR_ISOLATED_FILE, count[1]);
-	} else {
-		mod_zone_page_state(zone, NR_ISOLATED_ANON, count[0]);
-		mod_zone_page_state(zone, NR_ISOLATED_FILE, count[1]);
-	}
+	mod_zone_page_state(zone, NR_ISOLATED_ANON, count[0]);
+	mod_zone_page_state(zone, NR_ISOLATED_FILE, count[1]);
 }
 
 /* Similar to reclaim, but different enough that they don't share logic */
@@ -612,8 +609,6 @@ isolate_success:
 		}
 	}
 
-	acct_isolated(zone, locked, cc);
-
 	if (locked)
 		spin_unlock_irqrestore(&zone->lru_lock, flags);
 
@@ -676,6 +671,7 @@ isolate_migratepages_range(struct compac
 			break;
 		}
 	}
+	acct_isolated(cc->zone, cc);
 
 	return pfn;
 }
@@ -911,6 +907,7 @@ static isolate_migrate_t isolate_migrate
 		break;
 	}
 
+	acct_isolated(zone, cc);
 	/* Record where migration scanner will be restarted */
 	cc->migrate_pfn = low_pfn;
 
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-slab_commonc-suppress-warning.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header-fix.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2.patch
mm-slab_common-move-kmem_cache-definition-to-internal-header-fix-2-fix.patch
mm-slb-always-track-caller-in-kmalloc_node_track_caller.patch
mm-slab-move-cache_flusharray-out-of-unlikelytext-section.patch
mm-slab-noinline-__ac_put_obj.patch
mm-slab-factor-out-unlikely-part-of-cache_free_alien.patch
slub-disable-tracing-and-failslab-for-merged-slabs.patch
topology-add-support-for-node_to_mem_node-to-determine-the-fallback-node.patch
slub-fallback-to-node_to_mem_node-node-if-allocating-on-memoryless-node.patch
partial-revert-of-81c98869faa5-kthread-ensure-locality-of-task_struct-allocations.patch
slab-fix-for_each_kmem_cache_node.patch
mm-slab_common-commonize-slab-merge-logic.patch
mm-slab_common-commonize-slab-merge-logic-fix.patch
mm-slab-support-slab-merge.patch
mm-slab-use-percpu-allocator-for-cpu-cache.patch
mm-cma-adjust-address-limit-to-avoid-hitting-low-high-memory-boundary.patch
arm-mm-dont-limit-default-cma-region-only-to-low-memory.patch
mm-page_alloc-determine-migratetype-only-once.patch
mm-thp-dont-hold-mmap_sem-in-khugepaged-when-allocating-thp.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone-fix.patch
mm-compaction-do-not-count-compact_stall-if-all-zones-skipped-compaction.patch
mm-compaction-do-not-recheck-suitable_migration_target-under-lock.patch
mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range.patch
mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range-fix.patch
mm-compaction-reduce-zone-checking-frequency-in-the-migration-scanner.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix.patch
mm-compaction-remember-position-within-pageblock-in-free-pages-scanner.patch
mm-compaction-skip-buddy-pages-by-their-order-in-the-migrate-scanner.patch
mm-rename-allocflags_to_migratetype-for-clarity.patch
mm-compaction-pass-gfp-mask-to-compact_control.patch
mm-use-__seq_open_private-instead-of-seq_open.patch
memcg-move-memcg_allocfree_cache_params-to-slab_commonc.patch
memcg-dont-call-memcg_update_all_caches-if-new-cache-id-fits.patch
memcg-move-memcg_update_cache_size-to-slab_commonc.patch
drivers-dma-coherent-add-initialization-from-device-tree.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-checkpatch-fixes.patch
drivers-dma-contiguous-add-initialization-from-device-tree.patch
drivers-dma-contiguous-add-initialization-from-device-tree-checkpatch-fixes.patch
zsmalloc-move-pages_allocated-to-zs_pool.patch
zsmalloc-change-return-value-unit-of-zs_get_total_size_bytes.patch
zram-zram-memory-size-limitation.patch
zram-report-maximum-used-memory.patch
page-owners-correct-page-order-when-to-free-page.patch

