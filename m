From: akpm@linux-foundation.org
Subject: + mm-rename-nr_anon_pages-to-nr_anon_mapped.patch added to -mm
 tree
Date: Fri, 08 Jul 2016 13:33:48 -0700
Message-ID: <57800e2c.6fgCxIpg8rvbnVAl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42872 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932707AbcGHUdt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2016 16:33:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mhocko@kernel.org, minchan@kernel.org, riel@surriel.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rename NR_ANON_PAGES to NR_ANON_MAPPED
has been added to the -mm tree.  Its filename is
     mm-rename-nr_anon_pages-to-nr_anon_mapped.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-rename-nr_anon_pages-to-nr_anon_mapped.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-rename-nr_anon_pages-to-nr_anon_mapped.patch

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
Subject: mm: rename NR_ANON_PAGES to NR_ANON_MAPPED

NR_FILE_PAGES  is the number of        file pages.
NR_FILE_MAPPED is the number of mapped file pages.
NR_ANON_PAGES  is the number of mapped anon pages.

This is unhelpful naming as it's easy to confuse NR_FILE_MAPPED and
NR_ANON_PAGES for mapped pages.  This patch renames NR_ANON_PAGES so we
have

NR_FILE_PAGES  is the number of        file pages.
NR_FILE_MAPPED is the number of mapped file pages.
NR_ANON_MAPPED is the number of mapped anon pages.

Link: http://lkml.kernel.org/r/1467970510-21195-19-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c    |    2 +-
 fs/proc/meminfo.c      |    2 +-
 include/linux/mmzone.h |    2 +-
 mm/migrate.c           |    2 +-
 mm/rmap.c              |    8 ++++----
 5 files changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/base/node.c~mm-rename-nr_anon_pages-to-nr_anon_mapped drivers/base/node.c
--- a/drivers/base/node.c~mm-rename-nr_anon_pages-to-nr_anon_mapped
+++ a/drivers/base/node.c
@@ -122,7 +122,7 @@ static ssize_t node_read_meminfo(struct
 		       nid, K(sum_zone_node_page_state(nid, NR_WRITEBACK)),
 		       nid, K(sum_zone_node_page_state(nid, NR_FILE_PAGES)),
 		       nid, K(node_page_state(pgdat, NR_FILE_MAPPED)),
-		       nid, K(node_page_state(pgdat, NR_ANON_PAGES)),
+		       nid, K(node_page_state(pgdat, NR_ANON_MAPPED)),
 		       nid, K(i.sharedram),
 		       nid, sum_zone_node_page_state(nid, NR_KERNEL_STACK) *
 				THREAD_SIZE / 1024,
diff -puN fs/proc/meminfo.c~mm-rename-nr_anon_pages-to-nr_anon_mapped fs/proc/meminfo.c
--- a/fs/proc/meminfo.c~mm-rename-nr_anon_pages-to-nr_anon_mapped
+++ a/fs/proc/meminfo.c
@@ -140,7 +140,7 @@ static int meminfo_proc_show(struct seq_
 		K(i.freeswap),
 		K(global_page_state(NR_FILE_DIRTY)),
 		K(global_page_state(NR_WRITEBACK)),
-		K(global_node_page_state(NR_ANON_PAGES)),
+		K(global_node_page_state(NR_ANON_MAPPED)),
 		K(global_node_page_state(NR_FILE_MAPPED)),
 		K(i.sharedram),
 		K(global_page_state(NR_SLAB_RECLAIMABLE) +
diff -puN include/linux/mmzone.h~mm-rename-nr_anon_pages-to-nr_anon_mapped include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-rename-nr_anon_pages-to-nr_anon_mapped
+++ a/include/linux/mmzone.h
@@ -161,7 +161,7 @@ enum node_stat_item {
 	WORKINGSET_REFAULT,
 	WORKINGSET_ACTIVATE,
 	WORKINGSET_NODERECLAIM,
-	NR_ANON_PAGES,	/* Mapped anonymous pages */
+	NR_ANON_MAPPED,	/* Mapped anonymous pages */
 	NR_FILE_MAPPED,	/* pagecache pages mapped into pagetables.
 			   only modified from process context */
 	NR_VM_NODE_STAT_ITEMS
diff -puN mm/migrate.c~mm-rename-nr_anon_pages-to-nr_anon_mapped mm/migrate.c
--- a/mm/migrate.c~mm-rename-nr_anon_pages-to-nr_anon_mapped
+++ a/mm/migrate.c
@@ -501,7 +501,7 @@ int migrate_page_move_mapping(struct add
 	 * new page and drop references to the old page.
 	 *
 	 * Note that anonymous pages are accounted for
-	 * via NR_FILE_PAGES and NR_ANON_PAGES if they
+	 * via NR_FILE_PAGES and NR_ANON_MAPPED if they
 	 * are mapped to swap space.
 	 */
 	if (newzone != oldzone) {
diff -puN mm/rmap.c~mm-rename-nr_anon_pages-to-nr_anon_mapped mm/rmap.c
--- a/mm/rmap.c~mm-rename-nr_anon_pages-to-nr_anon_mapped
+++ a/mm/rmap.c
@@ -1217,7 +1217,7 @@ void do_page_add_anon_rmap(struct page *
 		 */
 		if (compound)
 			__inc_zone_page_state(page, NR_ANON_THPS);
-		__mod_node_page_state(page_pgdat(page), NR_ANON_PAGES, nr);
+		__mod_node_page_state(page_pgdat(page), NR_ANON_MAPPED, nr);
 	}
 	if (unlikely(PageKsm(page)))
 		return;
@@ -1261,7 +1261,7 @@ void page_add_new_anon_rmap(struct page
 		/* increment count (starts at -1) */
 		atomic_set(&page->_mapcount, 0);
 	}
-	__mod_node_page_state(page_pgdat(page), NR_ANON_PAGES, nr);
+	__mod_node_page_state(page_pgdat(page), NR_ANON_MAPPED, nr);
 	__page_set_anon_rmap(page, vma, address, 1);
 }
 
@@ -1378,7 +1378,7 @@ static void page_remove_anon_compound_rm
 		clear_page_mlock(page);
 
 	if (nr) {
-		__mod_node_page_state(page_pgdat(page), NR_ANON_PAGES, -nr);
+		__mod_node_page_state(page_pgdat(page), NR_ANON_MAPPED, -nr);
 		deferred_split_huge_page(page);
 	}
 }
@@ -1407,7 +1407,7 @@ void page_remove_rmap(struct page *page,
 	 * these counters are not modified in interrupt context, and
 	 * pte lock(a spinlock) is held, which implies preemption disabled.
 	 */
-	__dec_node_page_state(page, NR_ANON_PAGES);
+	__dec_node_page_state(page, NR_ANON_MAPPED);
 
 	if (unlikely(PageMlocked(page)))
 		clear_page_mlock(page);
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-meminit-always-return-a-valid-node-from-early_pfn_to_nid.patch
mm-meminit-ensure-node-is-online-before-checking-whether-pages-are-uninitialised.patch
mm-meminit-remove-early_page_nid_uninitialised.patch
mm-vmstat-add-infrastructure-for-per-node-vmstats.patch
mm-vmscan-move-lru_lock-to-the-node.patch
mm-vmscan-move-lru-lists-to-node.patch
mm-mmzone-clarify-the-usage-of-zone-padding.patch
mm-vmscan-begin-reclaiming-pages-on-a-per-node-basis.patch
mm-vmscan-have-kswapd-only-scan-based-on-the-highest-requested-zone.patch
mm-vmscan-make-kswapd-reclaim-in-terms-of-nodes.patch
mm-vmscan-remove-balance-gap.patch
mm-vmscan-simplify-the-logic-deciding-whether-kswapd-sleeps.patch
mm-vmscan-by-default-have-direct-reclaim-only-shrink-once-per-node.patch
mm-vmscan-remove-duplicate-logic-clearing-node-congestion-and-dirty-state.patch
mm-vmscan-do-not-reclaim-from-kswapd-if-there-is-any-eligible-zone.patch
mm-vmscan-make-shrink_node-decisions-more-node-centric.patch
mm-memcg-move-memcg-limit-enforcement-from-zones-to-nodes.patch
mm-workingset-make-working-set-detection-node-aware.patch
mm-page_alloc-consider-dirtyable-memory-in-terms-of-nodes.patch
mm-move-page-mapped-accounting-to-the-node.patch
mm-rename-nr_anon_pages-to-nr_anon_mapped.patch
mm-move-most-file-based-accounting-to-the-node.patch
mm-move-vmscan-writes-and-file-write-accounting-to-the-node.patch
mm-vmscan-only-wakeup-kswapd-once-per-node-for-the-requested-classzone.patch
mm-page_alloc-wake-kswapd-based-on-the-highest-eligible-zone.patch
mm-convert-zone_reclaim-to-node_reclaim.patch
mm-vmscan-avoid-passing-in-classzone_idx-unnecessarily-to-shrink_node.patch
mm-vmscan-avoid-passing-in-classzone_idx-unnecessarily-to-compaction_ready.patch
mm-vmscan-avoid-passing-in-remaining-unnecessarily-to-prepare_kswapd_sleep.patch
mm-vmscan-have-kswapd-reclaim-from-all-zones-if-reclaiming-and-buffer_heads_over_limit.patch
mm-vmscan-add-classzone-information-to-tracepoints.patch
mm-page_alloc-remove-fair-zone-allocation-policy.patch
mm-page_alloc-cache-the-last-node-whose-dirty-limit-is-reached.patch
mm-vmstat-replace-__count_zone_vm_events-with-a-zone-id-equivalent.patch
mm-vmstat-account-per-zone-stalls-and-pages-skipped-during-reclaim.patch
mm-vmstat-print-node-based-stats-in-zoneinfo-file.patch
mm-vmstat-remove-zone-and-node-double-accounting-by-approximating-retries.patch

