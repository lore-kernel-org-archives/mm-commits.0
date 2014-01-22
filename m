From: akpm@linux-foundation.org
Subject: [merged]
 mm-numa-limit-scope-of-lock-for-numa-migrate-rate-limiting.patch removed
 from -mm tree
Date: Wed, 22 Jan 2014 12:14:40 -0800
Message-ID: <52e026b0.iKyKSOBLEr/djziZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54981 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804AbaAVUOk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:14:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, athorlton@sgi.com, mgorman@suse.de

Subject: [merged] mm-numa-limit-scope-of-lock-for-numa-migrate-rate-limiting.patch removed from -mm tree
To: mgorman@suse.de,athorlton@sgi.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:14:40 -0800


The patch titled
     Subject: mm: numa: limit scope of lock for NUMA migrate rate limiting
has been removed from the -mm tree.  Its filename was
     mm-numa-limit-scope-of-lock-for-numa-migrate-rate-limiting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1602,26 +1602,29 @@ bool migrate_ratelimited(int node)
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

origin.patch
mm-remove-bug_on-from-mlock_vma_page.patch
x86-mm-account-for-tlb-flushes-only-when-debugging.patch
x86-mm-clean-up-inconsistencies-when-flushing-tlb-ranges.patch
x86-mm-eliminate-redundant-page-table-walk-during-tlb-range-flushing.patch
x86-mm-change-tlb_flushall_shift-for-ivybridge.patch
mm-x86-revisit-tlb_flushall_shift-tuning-for-page-flushes-except-on-ivybridge.patch
mm-page_alloc-allow-__gfp_nofail-to-allocate-below-watermarks-after-reclaim.patch
mm-munlock-fix-potential-race-with-thp-page-split.patch
numa-add-a-sysctl-for-numa_balancing.patch
numa-add-a-sysctl-for-numa_balancing-fix.patch
mm-vmscan-shrink-all-slab-objects-if-tight-on-memory.patch
mm-vmscan-call-numa-unaware-shrinkers-irrespective-of-nodemask.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
mm-show-message-when-updating-min_free_kbytes-in-thp.patch
mm-improve-documentation-of-page_order-v2.patch
mm-improve-documentation-of-page_order-v2-fix.patch
linux-next.patch
mm-migratec-fix-setting-of-cpupid-on-page-migration-twice-against-normal-page.patch
zsmalloc-move-it-under-mm.patch
zram-promote-zram-from-staging.patch

