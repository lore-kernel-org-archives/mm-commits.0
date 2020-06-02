From: akpm@linux-foundation.org
Subject: [merged]
 swap-try-to-scan-more-free-slots-even-when-fragmented.patch removed from
 -mm tree
Date: Tue, 02 Jun 2020 14:40:25 -0700
Message-ID: <20200602214025.7_7xtF57z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727794AbgFBVk0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 17:40:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave.hansen@intel.com, hughd@google.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, tim.c.chen@linux.intel.com, ying.huang@intel.com


The patch titled
     Subject: swap: try to scan more free slots even when fragmented
has been removed from the -mm tree.  Its filename was
     swap-try-to-scan-more-free-slots-even-when-fragmented.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: swap: try to scan more free slots even when fragmented

Now, the scalability of swap code will drop much when the swap device
becomes fragmented, because the swap slots allocation batching stops
working.  To solve the problem, in this patch, we will try to scan a
little more swap slots with restricted effort to batch the swap slots
allocation even if the swap device is fragmented.  Test shows that the
benchmark score can increase up to 37.1% with the patch.  Details are as
follows.

The swap code has a per-cpu cache of swap slots.  These batch swap space
allocations to improve swap subsystem scaling.  In the following code
path,

  add_to_swap()
    get_swap_page()
      refill_swap_slots_cache()
        get_swap_pages()
	  scan_swap_map_slots()

scan_swap_map_slots() and get_swap_pages() can return multiple swap slots
for each call.  These slots will be cached in the per-CPU swap slots
cache, so that several following swap slot requests will be fulfilled
there to avoid the lock contention in the lower level swap space
allocation/freeing code path.

But this only works when there are free swap clusters.  If a swap device
becomes so fragmented that there's no free swap clusters,
scan_swap_map_slots() and get_swap_pages() will return only one swap slot
for each call in the above code path.  Effectively, this falls back to the
situation before the swap slots cache was introduced, the heavy lock
contention on the swap related locks kills the scalability.

Why does it work in this way?  Because the swap device could be large, and
the free swap slot scanning could be quite time consuming, to avoid taking
too much time to scanning free swap slots, the conservative method was
used.

In fact, this can be improved via scanning a little more free slots with
strictly restricted effort.  Which is implemented in this patch.  In
scan_swap_map_slots(), after the first free swap slot is gotten, we will
try to scan a little more, but only if we haven't scanned too many slots
(< LATENCY_LIMIT).  That is, the added scanning latency is strictly
restricted.

To test the patch, we have run 16-process pmbench memory benchmark on a
2-socket server machine with 48 cores.  Multiple ram disks are configured
as the swap devices.  The pmbench working-set size is much larger than the
available memory so that swapping is triggered.  The memory read/write
ratio is 80/20 and the accessing pattern is random, so the swap space
becomes highly fragmented during the test.  In the original
implementation, the lock contention on swap related locks is very heavy. 
The perf profiling data of the lock contention code path is as following,

_raw_spin_lock.get_swap_pages.get_swap_page.add_to_swap:             21.03
_raw_spin_lock_irq.shrink_inactive_list.shrink_lruvec.shrink_node:    1.92
_raw_spin_lock_irq.shrink_active_list.shrink_lruvec.shrink_node:      1.72
_raw_spin_lock.free_pcppages_bulk.drain_pages_zone.drain_pages:       0.69

While after applying this patch, it becomes,

_raw_spin_lock_irq.shrink_inactive_list.shrink_lruvec.shrink_node:    4.89
_raw_spin_lock_irq.shrink_active_list.shrink_lruvec.shrink_node:      3.85
_raw_spin_lock.free_pcppages_bulk.drain_pages_zone.drain_pages:       1.1
_raw_spin_lock_irqsave.pagevec_lru_move_fn.__lru_cache_add.do_swap_page: 0.88

That is, the lock contention on the swap locks is eliminated.

And the pmbench score increases 37.1%.  The swapin throughput increases
45.7% from 2.02 GB/s to 2.94 GB/s.  While the swapout throughput increases
45.3% from 2.04 GB/s to 2.97 GB/s.

Link: http://lkml.kernel.org/r/20200427030023.264780-1-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/mm/swapfile.c~swap-try-to-scan-more-free-slots-even-when-fragmented
+++ a/mm/swapfile.c
@@ -732,6 +732,7 @@ static int scan_swap_map_slots(struct sw
 	unsigned long last_in_cluster = 0;
 	int latency_ration = LATENCY_LIMIT;
 	int n_ret = 0;
+	bool scanned_many = false;
 
 	/*
 	 * We try to cluster swap pages by allocating them sequentially
@@ -863,6 +864,25 @@ checks:
 		goto checks;
 	}
 
+	/*
+	 * Even if there's no free clusters available (fragmented),
+	 * try to scan a little more quickly with lock held unless we
+	 * have scanned too many slots already.
+	 */
+	if (!scanned_many) {
+		unsigned long scan_limit;
+
+		if (offset < scan_base)
+			scan_limit = scan_base;
+		else
+			scan_limit = si->highest_bit;
+		for (; offset <= scan_limit && --latency_ration > 0;
+		     offset++) {
+			if (!si->swap_map[offset])
+				goto checks;
+		}
+	}
+
 done:
 	si->flags -= SWP_SCANNING;
 	return n_ret;
@@ -881,6 +901,7 @@ scan:
 		if (unlikely(--latency_ration < 0)) {
 			cond_resched();
 			latency_ration = LATENCY_LIMIT;
+			scanned_many = true;
 		}
 	}
 	offset = si->lowest_bit;
@@ -896,6 +917,7 @@ scan:
 		if (unlikely(--latency_ration < 0)) {
 			cond_resched();
 			latency_ration = LATENCY_LIMIT;
+			scanned_many = true;
 		}
 		offset++;
 	}
_

Patches currently in -mm which might be from ying.huang@intel.com are
