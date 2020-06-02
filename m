From: akpm@linux-foundation.org
Subject: [folded-merged]
 =?US-ASCII?Q?swap-reduce-lock-contention-on-swap-cache-from-swap-slots?=
 =?US-ASCII?Q?-allocation-v4.patch?= removed from -mm tree
Date: Mon, 01 Jun 2020 21:18:01 -0700
Message-ID: <20200602041801.SUpz_5bnJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbgFBESC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 00:18:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.m.jordan@oracle.com, hughd@google.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, tim.c.chen@linux.intel.com, ying.huang@intel.com


The patch titled
     Subject: swap-reduce-lock-contention-on-swap-cache-from-swap-slots-allocation-v4
has been removed from the -mm tree.  Its filename was
     swap-reduce-lock-contention-on-swap-cache-from-swap-slots-allocation-v4.patch

This patch was dropped because it was folded into swap-reduce-lock-contention-on-swap-cache-from-swap-slots-allocation.patch

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: swap-reduce-lock-contention-on-swap-cache-from-swap-slots-allocation-v4

- Fix wrong ALIGN() usage with ALIGN_DOWN().  Thanks Daniel's comments!

- Add some comments.  Thanks Daniel's comments!

Link: http://lkml.kernel.org/r/20200529010840.928819-1-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/swapfile.c~swap-reduce-lock-contention-on-swap-cache-from-swap-slots-allocation-v4
+++ a/mm/swapfile.c
@@ -613,7 +613,8 @@ new_cluster:
 		} else if (!cluster_list_empty(&si->discard_clusters)) {
 			/*
 			 * we don't have free cluster but have some clusters in
-			 * discarding, do discard now and reclaim them
+			 * discarding, do discard now and reclaim them, then
+			 * reread cluster_next_cpu since we dropped si->lock
 			 */
 			swap_do_scheduled_discard(si);
 			*scan_base = this_cpu_read(*si->cluster_next_cpu);
@@ -745,7 +746,7 @@ static void set_cluster_next(struct swap
 			return;
 		next = si->lowest_bit +
 			prandom_u32_max(si->highest_bit - si->lowest_bit + 1);
-		next = ALIGN(next, SWAP_ADDRESS_SPACE_PAGES);
+		next = ALIGN_DOWN(next, SWAP_ADDRESS_SPACE_PAGES);
 		next = max_t(unsigned int, next, si->lowest_bit);
 	}
 	this_cpu_write(*si->cluster_next_cpu, next);
_

Patches currently in -mm which might be from ying.huang@intel.com are

swap-try-to-scan-more-free-slots-even-when-fragmented.patch
mm-swap-use-prandom_u32_max.patch
swap-reduce-lock-contention-on-swap-cache-from-swap-slots-allocation.patch
proc-pid-smaps-add-pmd-migration-entry-parsing.patch
