From: akpm@linux-foundation.org
Subject: [merged] mm-swap-add-swap-readahead-hit-statistics.patch
 removed from -mm tree
Date: Thu, 07 Sep 2017 11:41:40 -0700
Message-ID: <20170907184140.ihxbPYNo5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57792 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755713AbdIGSll (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:41:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave.hansen@intel.com, fengguang.wu@intel.com, hannes@cmpxchg.org, hughd@google.com, minchan@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com, shli@kernel.org, tim.c.chen@intel.com, ying.huang@intel.com


The patch titled
     Subject: mm, swap: add swap readahead hit statistics
has been removed from the -mm tree.  Its filename was
     mm-swap-add-swap-readahead-hit-statistics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm, swap: add swap readahead hit statistics

Patch series "mm, swap: VMA based swap readahead", v4.

The swap readahead is an important mechanism to reduce the swap in
latency.  Although pure sequential memory access pattern isn't very
popular for anonymous memory, the space locality is still considered
valid.

In the original swap readahead implementation, the consecutive blocks in
swap device are readahead based on the global space locality estimation. 
But the consecutive blocks in swap device just reflect the order of page
reclaiming, don't necessarily reflect the access pattern in virtual memory
space.  And the different tasks in the system may have different access
patterns, which makes the global space locality estimation incorrect.

In this patchset, when page fault occurs, the virtual pages near the fault
address will be readahead instead of the swap slots near the fault swap
slot in swap device.  This avoid to readahead the unrelated swap slots. 
At the same time, the swap readahead is changed to work on per-VMA from
globally.  So that the different access patterns of the different VMAs
could be distinguished, and the different readahead policy could be
applied accordingly.  The original core readahead detection and scaling
algorithm is reused, because it is an effect algorithm to detect the space
locality.

In addition to the swap readahead changes, some new sysfs interface is
added to show the efficiency of the readahead algorithm and some other
swap statistics.

This new implementation will incur more small random read, on SSD, the
improved correctness of estimation and readahead target should beat the
potential increased overhead, this is also illustrated in the test results
below.  But on HDD, the overhead may beat the benefit, so the original
implementation will be used by default.

The test and result is as follow,

Common test condition
=====================

Test Machine: Xeon E5 v3 (2 sockets, 72 threads, 32G RAM)
Swap device: NVMe disk

Micro-benchmark with combined access pattern
============================================

vm-scalability, sequential swap test case, 4 processes to eat 50G
virtual memory space, repeat the sequential memory writing until 300
seconds.  The first round writing will trigger swap out, the following
rounds will trigger sequential swap in and out.

At the same time, run vm-scalability random swap test case in
background, 8 processes to eat 30G virtual memory space, repeat the
random memory write until 300 seconds.  This will trigger random
swap-in in the background.

This is a combined workload with sequential and random memory
accessing at the same time.  The result (for sequential workload) is
as follow,

			Base		Optimized
			----		---------
throughput		345413 KB/s	414029 KB/s (+19.9%)
latency.average		97.14 us	61.06 us (-37.1%)
latency.50th		2 us		1 us
latency.60th		2 us		1 us
latency.70th		98 us		2 us
latency.80th		160 us		2 us
latency.90th		260 us		217 us
latency.95th		346 us		369 us
latency.99th		1.34 ms		1.09 ms
ra_hit%			52.69%		99.98%

The original swap readahead algorithm is confused by the background random
access workload, so readahead hit rate is lower.  The VMA-base readahead
algorithm works much better.

Linpack
=======

The test memory size is bigger than RAM to trigger swapping.

			Base		Optimized
			----		---------
elapsed_time		393.49 s	329.88 s (-16.2%)
ra_hit%			86.21%		98.82%

The score of base and optimized kernel hasn't visible changes.  But the
elapsed time reduced and readahead hit rate improved, so the optimized
kernel runs better for startup and tear down stages.  And the absolute
value of readahead hit rate is high, shows that the space locality is
still valid in some practical workloads.


This patch (of 5):

The statistics for total readahead pages and total readahead hits are
recorded and exported via the following sysfs interface.

/sys/kernel/mm/swap/ra_hits
/sys/kernel/mm/swap/ra_total

With them, the efficiency of the swap readahead could be measured, so that
the swap readahead algorithm and parameters could be tuned accordingly.

[akpm@linux-foundation.org: don't display swap stats if CONFIG_SWAP=n]
Link: http://lkml.kernel.org/r/20170807054038.1843-2-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Tim Chen <tim.c.chen@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vm_event_item.h |    4 ++++
 mm/swap_state.c               |    9 +++++++--
 mm/vmstat.c                   |    4 ++++
 3 files changed, 15 insertions(+), 2 deletions(-)

diff -puN include/linux/vm_event_item.h~mm-swap-add-swap-readahead-hit-statistics include/linux/vm_event_item.h
--- a/include/linux/vm_event_item.h~mm-swap-add-swap-readahead-hit-statistics
+++ a/include/linux/vm_event_item.h
@@ -106,6 +106,10 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		VMACACHE_FIND_HITS,
 		VMACACHE_FULL_FLUSHES,
 #endif
+#ifdef CONFIG_SWAP
+		SWAP_RA,
+		SWAP_RA_HIT,
+#endif
 		NR_VM_EVENT_ITEMS
 };
 
diff -puN mm/swap_state.c~mm-swap-add-swap-readahead-hit-statistics mm/swap_state.c
--- a/mm/swap_state.c~mm-swap-add-swap-readahead-hit-statistics
+++ a/mm/swap_state.c
@@ -305,8 +305,10 @@ struct page * lookup_swap_cache(swp_entr
 
 	if (page && likely(!PageTransCompound(page))) {
 		INC_CACHE_INFO(find_success);
-		if (TestClearPageReadahead(page))
+		if (TestClearPageReadahead(page)) {
 			atomic_inc(&swapin_readahead_hits);
+			count_vm_event(SWAP_RA_HIT);
+		}
 	}
 
 	INC_CACHE_INFO(find_total);
@@ -516,8 +518,11 @@ struct page *swapin_readahead(swp_entry_
 						gfp_mask, vma, addr, false);
 		if (!page)
 			continue;
-		if (offset != entry_offset && likely(!PageTransCompound(page)))
+		if (offset != entry_offset &&
+		    likely(!PageTransCompound(page))) {
 			SetPageReadahead(page);
+			count_vm_event(SWAP_RA);
+		}
 		put_page(page);
 	}
 	blk_finish_plug(&plug);
diff -puN mm/vmstat.c~mm-swap-add-swap-readahead-hit-statistics mm/vmstat.c
--- a/mm/vmstat.c~mm-swap-add-swap-readahead-hit-statistics
+++ a/mm/vmstat.c
@@ -1098,6 +1098,10 @@ const char * const vmstat_text[] = {
 	"vmacache_find_hits",
 	"vmacache_full_flushes",
 #endif
+#ifdef CONFIG_SWAP
+	"swap_ra",
+	"swap_ra_hit",
+#endif
 #endif /* CONFIG_VM_EVENTS_COUNTERS */
 };
 #endif /* CONFIG_PROC_FS || CONFIG_SYSFS || CONFIG_NUMA */
_

Patches currently in -mm which might be from ying.huang@intel.com are


