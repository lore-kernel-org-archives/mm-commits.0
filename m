From: akpm@linux-foundation.org
Subject: +
 mm-numa-limit-scope-of-lock-for-numa-migrate-rate-limiting.patch added to
 -mm tree
Date: Tue, 10 Dec 2013 14:20:31 -0800
Message-ID: <52a793af.EBDkaIen7cECTlOA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40774 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab3LJWUc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Dec 2013 17:20:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, athorlton@sgi.com, mgorman@suse.de

Subject: + mm-numa-limit-scope-of-lock-for-numa-migrate-rate-limiting.patch added to -mm tree
To: mgorman@suse.de,athorlton@sgi.com,riel@redhat.com
From: akpm@linux-foundation.org
Date: Tue, 10 Dec 2013 14:20:31 -0800


The patch titled
     Subject: mm: numa: limit scope of lock for NUMA migrate rate limiting
has been added to the -mm tree.  Its filename is
     mm-numa-limit-scope-of-lock-for-numa-migrate-rate-limiting.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-numa-limit-scope-of-lock-for-numa-migrate-rate-limiting.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-numa-limit-scope-of-lock-for-numa-migrate-rate-limiting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: numa: limit scope of lock for NUMA migrate rate limiting

NUMA migrate rate limiting protects a migration counter and window using a
lock but in some cases this can be a contended lock.  It is not critical
that the number of pages be perfect, lost updates are acceptable.  Reduce
the importance of this lock.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Alex Thorlton <athorlton@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    5 +----
 mm/migrate.c           |   21 ++++++++++++---------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff -puN include/linux/mmzone.h~mm-numa-limit-scope-of-lock-for-numa-migrate-rate-limiting include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-numa-limit-scope-of-lock-for-numa-migrate-rate-limiting
+++ a/include/linux/mmzone.h
@@ -764,10 +764,7 @@ typedef struct pglist_data {
 	int kswapd_max_order;
 	enum zone_type classzone_idx;
 #ifdef CONFIG_NUMA_BALANCING
-	/*
-	 * Lock serializing the per destination node AutoNUMA memory
-	 * migration rate limiting data.
-	 */
+	/* Lock serializing the migrate rate limiting window */
 	spinlock_t numabalancing_migrate_lock;
 
 	/* Rate limiting time interval */
diff -puN mm/migrate.c~mm-numa-limit-scope-of-lock-for-numa-migrate-rate-limiting mm/migrate.c
--- a/mm/migrate.c~mm-numa-limit-scope-of-lock-for-numa-migrate-rate-limiting
+++ a/mm/migrate.c
@@ -1601,26 +1601,29 @@ bool migrate_ratelimited(int node)
 static bool numamigrate_update_ratelimit(pg_data_t *pgdat,
 					unsigned long nr_pages)
 {
-	bool rate_limited = false;
-
 	/*
 	 * Rate-limit the amount of data that is being migrated to a node.
 	 * Optimal placement is no good if the memory bus is saturated and
 	 * all the time is being spent migrating!
 	 */
-	spin_lock(&pgdat->numabalancing_migrate_lock);
 	if (time_after(jiffies, pgdat->numabalancing_migrate_next_window)) {
+		spin_lock(&pgdat->numabalancing_migrate_lock);
 		pgdat->numabalancing_migrate_nr_pages = 0;
 		pgdat->numabalancing_migrate_next_window = jiffies +
 			msecs_to_jiffies(migrate_interval_millisecs);
+		spin_unlock(&pgdat->numabalancing_migrate_lock);
 	}
 	if (pgdat->numabalancing_migrate_nr_pages > ratelimit_pages)
-		rate_limited = true;
-	else
-		pgdat->numabalancing_migrate_nr_pages += nr_pages;
-	spin_unlock(&pgdat->numabalancing_migrate_lock);
-	
-	return rate_limited;
+		return true;
+
+	/*
+	 * This is an unlocked non-atomic update so errors are possible.
+	 * The consequences are failing to migrate when we potentiall should
+	 * have which is not severe enough to warrant locking. If it is ever
+	 * a problem, it can be converted to a per-cpu counter.
+	 */
+	pgdat->numabalancing_migrate_nr_pages += nr_pages;
+	return false;
 }
 
 static int numamigrate_isolate_page(pg_data_t *pgdat, struct page *page)
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-hugetlbfs-add-some-vm_bug_ons-to-catch-non-hugetlbfs-pages.patch
mm-hugetlb-use-get_page_foll-in-follow_hugetlb_page.patch
mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path.patch
mm-thp-optimize-compound_trans_huge.patch
mm-tail-page-refcounting-optimization-for-slab-and-hugetlbfs.patch
mm-hugetlbfs-use-__compound_tail_refcounted-in-__get_page_tail-too.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-hugetlbc-defer-pageheadhuge-symbol-export.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch
mm-call-mmu-notifiers-when-copying-a-hugetlb-page-range.patch
mm-show_mem-remove-show_mem_filter_page_count.patch
x86-get-pg_data_ts-memory-from-other-node.patch
memblock-numa-introduce-flags-field-into-memblock.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions.patch
memblock-make-memblock_set_node-support-different-memblock_type.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock.patch
acpi-numa-mem_hotplug-mark-all-nodes-the-kernel-resides-un-hotpluggable.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed.patch
x86-numa-acpi-memory-hotplug-make-movable_node-have-higher-priority.patch
mm-rmap-recompute-pgoff-for-huge-page.patch
mm-rmap-factor-nonlinear-handling-out-of-try_to_unmap_file.patch
mm-rmap-factor-lock-function-out-of-rmap_walk_anon.patch
mm-rmap-make-rmap_walk-to-get-the-rmap_walk_control-argument.patch
mm-rmap-extend-rmap_walk_xxx-to-cope-with-different-cases.patch
mm-rmap-use-rmap_walk-in-try_to_unmap.patch
mm-rmap-use-rmap_walk-in-try_to_munlock.patch
mm-rmap-use-rmap_walk-in-page_referenced.patch
mm-rmap-use-rmap_walk-in-page_mkclean.patch
mm-page_alloc-allow-__gfp_nofail-to-allocate-below-watermarks-after-reclaim.patch
mm-numa-serialise-parallel-get_user_page-against-thp-migration.patch
mm-numa-call-mmu-notifiers-on-thp-migration.patch
mm-clear-pmd_numa-before-invalidating.patch
mm-numa-do-not-clear-pmd-during-pte-update-scan.patch
mm-numa-do-not-clear-pte-for-pte_numa-update.patch
mm-numa-ensure-anon_vma-is-locked-to-prevent-parallel-thp-splits.patch
mm-numa-avoid-unnecessary-work-on-the-failure-path.patch
sched-numa-skip-inaccessible-vmas.patch
mm-numa-clear-numa-hinting-information-on-mprotect.patch
mm-numa-avoid-unnecessary-disruption-of-numa-hinting-during-migration.patch
mm-fix-tlb-flush-race-between-migration-and-change_protection_range.patch
mm-numa-defer-tlb-flush-for-thp-migration-as-long-as-possible.patch
mm-numa-make-numa-migrate-related-functions-static.patch
mm-numa-limit-scope-of-lock-for-numa-migrate-rate-limiting.patch
mm-numa-trace-tasks-that-fail-migration-due-to-rate-limiting.patch
mm-numa-do-not-automatically-migrate-ksm-pages.patch
sched-add-tracepoints-related-to-numa-task-migration.patch
linux-next.patch

