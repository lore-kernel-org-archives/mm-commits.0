From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-take-the-alloc_no_watermark-check-out-of-the-fast-path.patch
 removed from -mm tree
Date: Thu, 05 Jun 2014 12:52:29 -0700
Message-ID: <5390ca7d.VJBCmqGeGPJfYxm/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56380 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbaFETwa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:52:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, tytso@mit.edu, riel@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com, oleg@redhat.com, mhocko@suse.cz, jack@suse.cz, hughd@google.com, hannes@cmpxchg.org, dave.hansen@intel.com, mgorman@suse.de

Subject: [merged] mm-page_alloc-take-the-alloc_no_watermark-check-out-of-the-fast-path.patch removed from -mm tree
To: mgorman@suse.de,dave.hansen@intel.com,hannes@cmpxchg.org,hughd@google.com,jack@suse.cz,mhocko@suse.cz,oleg@redhat.com,paulmck@linux.vnet.ibm.com,peterz@infradead.org,riel@redhat.com,tytso@mit.edu,vbabka@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:52:29 -0700


The patch titled
     Subject: mm: page_alloc: take the ALLOC_NO_WATERMARK check out of the fast path
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-take-the-alloc_no_watermark-check-out-of-the-fast-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: page_alloc: take the ALLOC_NO_WATERMARK check out of the fast path

ALLOC_NO_WATERMARK is set in a few cases.  Always by kswapd, always for
__GFP_MEMALLOC, sometimes for swap-over-nfs, tasks etc.  Each of these
cases are relatively rare events but the ALLOC_NO_WATERMARK check is an
unlikely branch in the fast path.  This patch moves the check out of the
fast path and after it has been determined that the watermarks have not
been met.  This helps the common fast path at the cost of making the slow
path slower and hitting kswapd with a performance cost.  It's a reasonable
tradeoff.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jan Kara <jack@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-take-the-alloc_no_watermark-check-out-of-the-fast-path mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-take-the-alloc_no_watermark-check-out-of-the-fast-path
+++ a/mm/page_alloc.c
@@ -1937,9 +1937,6 @@ zonelist_scan:
 			(alloc_flags & ALLOC_CPUSET) &&
 			!cpuset_zone_allowed_softwall(zone, gfp_mask))
 				continue;
-		BUILD_BUG_ON(ALLOC_NO_WATERMARKS < NR_WMARK);
-		if (unlikely(alloc_flags & ALLOC_NO_WATERMARKS))
-			goto try_this_zone;
 		/*
 		 * Distribute pages in proportion to the individual
 		 * zone size to ensure fair page aging.  The zone a
@@ -1986,6 +1983,11 @@ zonelist_scan:
 				       classzone_idx, alloc_flags)) {
 			int ret;
 
+			/* Checked here to keep the fast path fast */
+			BUILD_BUG_ON(ALLOC_NO_WATERMARKS < NR_WMARK);
+			if (alloc_flags & ALLOC_NO_WATERMARKS)
+				goto try_this_zone;
+
 			if (IS_ENABLED(CONFIG_NUMA) &&
 					!did_zlc_setup && nr_online_nodes > 1) {
 				/*
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-v5.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
linux-next.patch

