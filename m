From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-thp-avoid-excessive-compaction-latency-during-fault-fix.patch removed
 from -mm tree
Date: Wed, 04 Jun 2014 15:30:03 -0700
Message-ID: <538f9deb.Q45Ay5T1gQsClVZl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39143 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaFDWaE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2014 18:30:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, n-horiguchi@ah.jp.nec.com, mgorman@suse.de, hughd@google.com, gthelen@google.com, rientjes@google.com

Subject: [folded-merged] mm-thp-avoid-excessive-compaction-latency-during-fault-fix.patch removed from -mm tree
To: rientjes@google.com,gthelen@google.com,hughd@google.com,mgorman@suse.de,n-horiguchi@ah.jp.nec.com,vbabka@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 04 Jun 2014 15:30:03 -0700


The patch titled
     Subject: mm, thp: avoid excessive compaction latency during fault fix
has been removed from the -mm tree.  Its filename was
     mm-thp-avoid-excessive-compaction-latency-during-fault-fix.patch

This patch was dropped because it was folded into mm-thp-avoid-excessive-compaction-latency-during-fault.patch

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, thp: avoid excessive compaction latency during fault fix

mm-thp-avoid-excessive-compaction-latency-during-fault.patch excludes sync
compaction for all high order allocations other than thp.  What we really
want to do is suppress sync compaction for thp, but only during the page
fault path.

Orders greater than PAGE_ALLOC_COSTLY_ORDER aren't necessarily going to
loop again so this is the only way to exhaust our capabilities before
declaring that we can't allocate.

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Greg Thelen <gthelen@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff -puN mm/page_alloc.c~mm-thp-avoid-excessive-compaction-latency-during-fault-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-thp-avoid-excessive-compaction-latency-during-fault-fix
+++ a/mm/page_alloc.c
@@ -2576,16 +2576,13 @@ rebalance:
 	if (page)
 		goto got_pg;
 
-	if (gfp_mask & __GFP_NO_KSWAPD) {
-		/*
-		 * Khugepaged is allowed to try MIGRATE_SYNC_LIGHT, the latency
-		 * of this allocation isn't critical.  Everything else, however,
-		 * should only be allowed to do MIGRATE_ASYNC to avoid excessive
-		 * stalls during fault.
-		 */
-		if ((current->flags & (PF_KTHREAD | PF_KSWAPD)) == PF_KTHREAD)
-			migration_mode = MIGRATE_SYNC_LIGHT;
-	}
+	/*
+	 * It can become very expensive to allocate transparent hugepages at
+	 * fault, so use asynchronous memory compaction for THP unless it is
+	 * khugepaged trying to collapse.
+	 */
+	if (!(gfp_mask & __GFP_NO_KSWAPD) || (current->flags & PF_KTHREAD))
+		migration_mode = MIGRATE_SYNC_LIGHT;
 
 	/*
 	 * If compaction is deferred for high-order allocations, it is because
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
kthread-fix-return-value-of-kthread_create-upon-sigkill.patch
mm-slab-suppress-out-of-memory-warning-unless-debug-is-enabled.patch
mm-slub-fix-alloc_slowpath-stat.patch
mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control.patch
hugetlb-prep_compound_gigantic_page-drop-__init-marker.patch
hugetlb-add-hstate_is_gigantic.patch
hugetlb-update_and_free_page-dont-clear-pg_reserved-bit.patch
hugetlb-move-helpers-up-in-the-file.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch
mem-hotplug-implement-get-put_online_mems.patch
slab-get_online_mems-for-kmem_cache_createdestroyshrink.patch
mm-debug-make-bad_range-output-more-usable-and-readable.patch
memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch
mm-migration-add-destination-page-freeing-callback.patch
mm-compaction-return-failed-migration-target-pages-back-to-freelist.patch
mm-compaction-add-per-zone-migration-pfn-cache-for-async-compaction.patch
mm-compaction-embed-migration-mode-in-compact_control.patch
mm-thp-avoid-excessive-compaction-latency-during-fault.patch
mm-compaction-terminate-async-compaction-when-rescheduling.patch
mm-compaction-do-not-count-migratepages-when-unnecessary.patch
mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages.patch
mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages-fix.patch
slab-delete-cache-from-list-after-__kmem_cache_shutdown-succeeds.patch
mm-page_alloc-calculate-classzone_idx-once-from-the-zonelist-ref.patch
mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention-fix-2.patch
mm-memcg-periodically-schedule-when-emptying-page-list.patch
mm-zswap-numa-aware-allocation-for-zswap_dstmem.patch

