From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-wake-up-all-pfmemalloc-throttled-processes-at-once.patch removed
 from -mm tree
Date: Thu, 12 Feb 2015 11:36:13 -0800
Message-ID: <54dd00ad.opkClOm/mEw0PGKI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57989 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbbBLTgO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:36:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, hannes@cmpxchg.org, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmscan: wake up all pfmemalloc-throttled processes at once
has been removed from the -mm tree.  Its filename was
     mm-vmscan-wake-up-all-pfmemalloc-throttled-processes-at-once.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, vmscan: wake up all pfmemalloc-throttled processes at once

Kswapd in balance_pgdate() currently uses wake_up() on processes waiting
in throttle_direct_reclaim(), which only wakes up a single process.  This
might leave processes waiting for longer than necessary, until the check
is reached in the next loop iteration.  Processes might also be left
waiting if zone was fully balanced in single iteration.  Note that the
comment in balance_pgdat() also says "Wake them", so waking up a single
process does not seem intentional.

Thus, replace wake_up() with wake_up_all().

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-vmscan-wake-up-all-pfmemalloc-throttled-processes-at-once mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-wake-up-all-pfmemalloc-throttled-processes-at-once
+++ a/mm/vmscan.c
@@ -3175,7 +3175,7 @@ static unsigned long balance_pgdat(pg_da
 		 */
 		if (waitqueue_active(&pgdat->pfmemalloc_wait) &&
 				pfmemalloc_watermark_ok(pgdat))
-			wake_up(&pgdat->pfmemalloc_wait);
+			wake_up_all(&pgdat->pfmemalloc_wait);
 
 		/*
 		 * Fragmentation may mean that the system cannot be rebalanced
_

Patches currently in -mm which might be from vbabka@suse.cz are

origin.patch
mm-compaction-fix-wrong-order-check-in-compact_finished.patch
mm-compaction-stop-the-isolation-when-we-isolate-enough-freepage.patch
mm-internalh-dont-split-printk-call-in-two.patch
mm-page_allocc-pull-out-init-code-from-build_all_zonelists.patch
mm-mm_initc-mark-mminit_verify_zonelist-as-__init.patch
mm-mm_initc-mark-mminit_loglevel-__meminitdata.patch
kernel-cpusetc-mark-cpuset_init_current_mems_allowed-as-__init.patch
mm-fix-negative-nr_isolated-counts.patch
zram-fix-umount-reset_store-mount-race-condition.patch

