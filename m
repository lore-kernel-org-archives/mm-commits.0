From: akpm@linux-foundation.org
Subject: +
 mm-thp-swap-support-to-clear-swap-cache-flag-for-thp-swapped-out.patch
 added to -mm tree
Date: Thu, 27 Jul 2017 16:36:29 -0700
Message-ID: <597a78fd.n0GP1yue4LjGkMkw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37582 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751735AbdG0Xgb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2017 19:36:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, aarcange@redhat.com, axboe@kernel.dk, dan.j.williams@intel.com, hannes@cmpxchg.org, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, minchan@kernel.org, riel@redhat.com, ross.zwisler@intel.com, shli@kernel.org, vishal.l.verma@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, THP, swap: support to clear swap cache flag for THP swapped out
has been added to the -mm tree.  Its filename is
     mm-thp-swap-support-to-clear-swap-cache-flag-for-thp-swapped-out.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-swap-support-to-clear-swap-cache-flag-for-thp-swapped-out.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-swap-support-to-clear-swap-cache-flag-for-thp-swapped-out.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm, THP, swap: support to clear swap cache flag for THP swapped out

This is the second step of THP (Transparent Huge Page) swap optimization. 
In the first step, the splitting huge page is delayed from almost the
first step of swapping out to after allocating the swap space for the THP
and adding the THP into the swap cache.  In the second step, the splitting
is delayed further to after the swapping out finished.  The plan is to
delay splitting THP step by step, finally avoid splitting THP for the THP
swapping out and swap out/in the THP as a whole.

In the patchset, more operations for the anonymous THP reclaiming, such as
TLB flushing, writing the THP to the swap device, removing the THP from
the swap cache are batched.  So that the performance of anonymous THP
swapping out are improved.

During the development, the following scenarios/code paths have been
checked,

- swap out/in
- swap off
- write protect page fault
- madvise_free
- process exit
- split huge page

With the patchset, the swap out throughput improves 42% (from about
5.81GB/s to about 8.25GB/s) in the vm-scalability swap-w-seq test case
with 16 processes.  At the same time, the IPI (reflect TLB flushing)
reduced about 78.9%.  The test is done on a Xeon E5 v3 system.  The
swap device used is a RAM simulated PMEM (persistent memory) device.
To test the sequential swapping out, the test case creates 8
processes, which sequentially allocate and write to the anonymous
pages until the RAM and part of the swap device is used up.

Below is the part of the cover letter for the first step patchset of
THP swap optimization which applies to all steps.

=========================

Recently, the performance of the storage devices improved so fast that we
cannot saturate the disk bandwidth with single logical CPU when do page
swap out even on a high-end server machine.  Because the performance of
the storage device improved faster than that of single logical CPU.  And
it seems that the trend will not change in the near future.  On the other
hand, the THP becomes more and more popular because of increased memory
size.  So it becomes necessary to optimize THP swap performance.

The advantages of the THP swap support include:

- Batch the swap operations for the THP to reduce TLB flushing and lock
  acquiring/releasing, including allocating/freeing the swap space,
  adding/deleting to/from the swap cache, and writing/reading the swap
  space, etc.  This will help improve the performance of the THP swap.

- The THP swap space read/write will be 2M sequential IO.  It is
  particularly helpful for the swap read, which are usually 4k random IO. 
  This will improve the performance of the THP swap too.

- It will help the memory fragmentation, especially when the THP is
  heavily used by the applications.  The 2M continuous pages will be free
  up after THP swapping out.

- It will improve the THP utilization on the system with the swap turned
  on.  Because the speed for khugepaged to collapse the normal pages into
  the THP is quite slow.  After the THP is split during the swapping out,
  it will take quite long time for the normal pages to collapse back into
  the THP after being swapped in.  The high THP utilization helps the
  efficiency of the page based memory management too.

There are some concerns regarding THP swap in, mainly because possible
enlarged read/write IO size (for swap in/out) may put more overhead on the
storage device.  To deal with that, the THP swap in should be turned on
only when necessary.  For example, it can be selected via
"always/never/madvise" logic, to be turned on globally, turned off
globally, or turned on only for VMA with MADV_HUGEPAGE, etc.


This patch (of 12):

Previously, swapcache_free_cluster() is used only in the error path of
shrink_page_list() to free the swap cluster just allocated if the THP
(Transparent Huge Page) is failed to be split.  In this patch, it is
enhanced to clear the swap cache flag (SWAP_HAS_CACHE) for the swap
cluster that holds the contents of THP swapped out.

This will be used in delaying splitting THP after swapping out support. 
Because there is no THP swapping in as a whole support yet, after clearing
the swap cache flag, the swap cluster backing the THP swapped out will be
split.  So that the swap slots in the swap cluster can be swapped in as
normal pages later.

Link: http://lkml.kernel.org/r/20170724051840.2309-2-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Ross Zwisler <ross.zwisler@intel.com> [for brd.c, zram_drv.c, pmem.c]
Cc: Vishal L Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff -puN mm/swapfile.c~mm-thp-swap-support-to-clear-swap-cache-flag-for-thp-swapped-out mm/swapfile.c
--- a/mm/swapfile.c~mm-thp-swap-support-to-clear-swap-cache-flag-for-thp-swapped-out
+++ a/mm/swapfile.c
@@ -1168,22 +1168,40 @@ static void swapcache_free_cluster(swp_e
 	struct swap_cluster_info *ci;
 	struct swap_info_struct *si;
 	unsigned char *map;
-	unsigned int i;
+	unsigned int i, free_entries = 0;
+	unsigned char val;
 
-	si = swap_info_get(entry);
+	si = _swap_info_get(entry);
 	if (!si)
 		return;
 
 	ci = lock_cluster(si, offset);
 	map = si->swap_map + offset;
 	for (i = 0; i < SWAPFILE_CLUSTER; i++) {
-		VM_BUG_ON(map[i] != SWAP_HAS_CACHE);
-		map[i] = 0;
+		val = map[i];
+		VM_BUG_ON(!(val & SWAP_HAS_CACHE));
+		if (val == SWAP_HAS_CACHE)
+			free_entries++;
+	}
+	if (!free_entries) {
+		for (i = 0; i < SWAPFILE_CLUSTER; i++)
+			map[i] &= ~SWAP_HAS_CACHE;
 	}
 	unlock_cluster(ci);
-	mem_cgroup_uncharge_swap(entry, SWAPFILE_CLUSTER);
-	swap_free_cluster(si, idx);
-	spin_unlock(&si->lock);
+	if (free_entries == SWAPFILE_CLUSTER) {
+		spin_lock(&si->lock);
+		ci = lock_cluster(si, offset);
+		memset(map, 0, SWAPFILE_CLUSTER);
+		unlock_cluster(ci);
+		mem_cgroup_uncharge_swap(entry, SWAPFILE_CLUSTER);
+		swap_free_cluster(si, idx);
+		spin_unlock(&si->lock);
+	} else if (free_entries) {
+		for (i = 0; i < SWAPFILE_CLUSTER; i++, entry.val++) {
+			if (!__swap_entry_free(si, entry, SWAP_HAS_CACHE))
+				free_swap_slot(entry);
+		}
+	}
 }
 #else
 static inline void swapcache_free_cluster(swp_entry_t entry)
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-thp-swap-support-to-clear-swap-cache-flag-for-thp-swapped-out.patch
mm-thp-swap-support-to-reclaim-swap-space-for-thp-swapped-out.patch
mm-thp-swap-make-reuse_swap_page-works-for-thp-swapped-out.patch
mm-thp-swap-dont-allocate-huge-cluster-for-file-backed-swap-device.patch
block-thp-make-block_device_operationsrw_page-support-thp.patch
test-code-to-write-thp-to-swap-device-as-a-whole.patch
mm-thp-swap-support-to-split-thp-for-thp-swapped-out.patch
memcg-thp-swap-support-move-mem-cgroup-charge-for-thp-swapped-out.patch
memcg-thp-swap-avoid-to-duplicated-charge-thp-in-swap-cache.patch
memcg-thp-swap-make-mem_cgroup_swapout-support-thp.patch
mm-thp-swap-delay-splitting-thp-after-swapped-out.patch
mm-thp-swap-add-thp-swapping-out-fallback-counting.patch

