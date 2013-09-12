From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-rearrange-watermark-checking-in-get_page_from_freelist.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:42:57 -0700
Message-ID: <52321941.zCYK55no9C7xMucp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58065 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab3ILTm6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:42:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zcalusic@bitsync.net, riel@redhat.com, paul.bollee@gmail.com, mgorman@suse.de, aarcange@redhat.com, hannes@cmpxchg.org

Subject: [merged] mm-page_alloc-rearrange-watermark-checking-in-get_page_from_freelist.patch removed from -mm tree
To: hannes@cmpxchg.org,aarcange@redhat.com,mgorman@suse.de,paul.bollee@gmail.com,riel@redhat.com,zcalusic@bitsync.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:42:57 -0700


The patch titled
     Subject: mm: page_alloc: rearrange watermark checking in get_page_from_freelist
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-rearrange-watermark-checking-in-get_page_from_freelist.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: rearrange watermark checking in get_page_from_freelist

Allocations that do not have to respect the watermarks are rare
high-priority events.  Reorder the code such that per-zone dirty limits
and future checks important only to regular page allocations are ignored
in these extraordinary situations.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Paul Bolle <paul.bollee@gmail.com>
Tested-by: Zlatko Calusic <zcalusic@bitsync.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-rearrange-watermark-checking-in-get_page_from_freelist mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-rearrange-watermark-checking-in-get_page_from_freelist
+++ a/mm/page_alloc.c
@@ -1889,12 +1889,17 @@ zonelist_scan:
 	 */
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 						high_zoneidx, nodemask) {
+		unsigned long mark;
+
 		if (IS_ENABLED(CONFIG_NUMA) && zlc_active &&
 			!zlc_zone_worth_trying(zonelist, z, allowednodes))
 				continue;
 		if ((alloc_flags & ALLOC_CPUSET) &&
 			!cpuset_zone_allowed_softwall(zone, gfp_mask))
 				continue;
+		BUILD_BUG_ON(ALLOC_NO_WATERMARKS < NR_WMARK);
+		if (alloc_flags & ALLOC_NO_WATERMARKS)
+			goto try_this_zone;
 		/*
 		 * When allocating a page cache page for writing, we
 		 * want to get it from a zone that is within its dirty
@@ -1925,16 +1930,11 @@ zonelist_scan:
 		    (gfp_mask & __GFP_WRITE) && !zone_dirty_ok(zone))
 			goto this_zone_full;
 
-		BUILD_BUG_ON(ALLOC_NO_WATERMARKS < NR_WMARK);
-		if (!(alloc_flags & ALLOC_NO_WATERMARKS)) {
-			unsigned long mark;
+		mark = zone->watermark[alloc_flags & ALLOC_WMARK_MASK];
+		if (!zone_watermark_ok(zone, order, mark,
+				       classzone_idx, alloc_flags)) {
 			int ret;
 
-			mark = zone->watermark[alloc_flags & ALLOC_WMARK_MASK];
-			if (zone_watermark_ok(zone, order, mark,
-				    classzone_idx, alloc_flags))
-				goto try_this_zone;
-
 			if (IS_ENABLED(CONFIG_NUMA) &&
 					!did_zlc_setup && nr_online_nodes > 1) {
 				/*
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
memcg-remove-redundant-code-in-mem_cgroup_force_empty_write.patch
memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch
memcg-get-rid-of-soft-limit-tree-infrastructure.patch
vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch
memcg-enhance-memcg-iterator-to-support-predicates.patch
memcg-enhance-memcg-iterator-to-support-predicates-fix.patch
memcg-track-children-in-soft-limit-excess-to-improve-soft-limit.patch
memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch
memcg-track-all-children-over-limit-in-the-root.patch
memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch
arch-mm-remove-obsolete-init-oom-protection.patch
arch-mm-do-not-invoke-oom-killer-on-kernel-fault-oom.patch
arch-mm-pass-userspace-fault-flag-to-generic-fault-handler.patch
x86-finish-user-fault-error-path-with-fatal-signal.patch
mm-memcg-enable-memcg-oom-killer-only-for-user-faults.patch
mm-memcg-rework-and-document-oom-waiting-and-wakeup.patch
mm-memcg-do-not-trap-chargers-with-full-callstack-on-oom.patch
memcg-remove-memcg_nr_file_mapped.patch
memcg-check-for-proper-lock-held-in-mem_cgroup_update_page_stat.patch
memcg-add-per-cgroup-writeback-pages-accounting.patch
memcg-document-cgroup-dirty-writeback-memory-statistics.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch

