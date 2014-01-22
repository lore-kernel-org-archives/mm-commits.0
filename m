From: akpm@linux-foundation.org
Subject: [merged] mm-numa-make-numa-migrate-related-functions-static.patch removed from -mm tree
Date: Wed, 22 Jan 2014 12:14:38 -0800
Message-ID: <52e026ae.EYhjcStCKpWIxB1d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54975 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804AbaAVUOi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:14:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, athorlton@sgi.com, mgorman@suse.de

Subject: [merged] mm-numa-make-numa-migrate-related-functions-static.patch removed from -mm tree
To: mgorman@suse.de,athorlton@sgi.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:14:38 -0800


The patch titled
     Subject: mm: numa: make NUMA-migrate related functions static
has been removed from the -mm tree.  Its filename was
     mm-numa-make-numa-migrate-related-functions-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: numa: make NUMA-migrate related functions static

numamigrate_update_ratelimit and numamigrate_isolate_page only have
callers in mm/migrate.c.  This patch makes them static.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Alex Thorlton <athorlton@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/migrate.c~mm-numa-make-numa-migrate-related-functions-static mm/migrate.c
--- a/mm/migrate.c~mm-numa-make-numa-migrate-related-functions-static
+++ a/mm/migrate.c
@@ -1599,7 +1599,8 @@ bool migrate_ratelimited(int node)
 }
 
 /* Returns true if the node is migrate rate-limited after the update */
-bool numamigrate_update_ratelimit(pg_data_t *pgdat, unsigned long nr_pages)
+static bool numamigrate_update_ratelimit(pg_data_t *pgdat,
+					unsigned long nr_pages)
 {
 	bool rate_limited = false;
 
@@ -1623,7 +1624,7 @@ bool numamigrate_update_ratelimit(pg_dat
 	return rate_limited;
 }
 
-int numamigrate_isolate_page(pg_data_t *pgdat, struct page *page)
+static int numamigrate_isolate_page(pg_data_t *pgdat, struct page *page)
 {
 	int page_lru;
 
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

