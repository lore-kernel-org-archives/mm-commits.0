From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-swap-make-swap-cluster-size-same-of-thp-size-on-x86_64.patch removed
 from -mm tree
Date: Wed, 29 Mar 2017 13:59:19 -0700
Message-ID: <58dc2027.HX3H/OpspfDqxVzV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56396 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752832AbdC2U7V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Mar 2017 16:59:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, aarcange@redhat.com, akpm@linux-foundation.org, ebru.akagunduz@gmail.com, hannes@cmpxchg.org, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, minchan@kernel.org, riel@redhat.com, shli@kernel.org, tj@kernel.org, vdavydov@tarantool.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, swap: make swap cluster size same of THP size on x86_64
has been removed from the -mm tree.  Its filename was
     mm-swap-make-swap-cluster-size-same-of-thp-size-on-x86_64.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm, swap: make swap cluster size same of THP size on x86_64

Patch series "THP swap: Delay splitting THP during swapping out", v7.

Recently, the performance of the storage devices improved so fast that
we cannot saturate the disk bandwidth with single logical CPU when do
page swap out even on a high-end server machine.  Because the
performance of the storage device improved faster than that of single
logical CPU.  And it seems that the trend will not change in the near
future.  On the other hand, the THP becomes more and more popular
because of increased memory size.  So it becomes necessary to optimize
THP swap performance.

The advantages of the THP swap support include:

- Batch the swap operations for the THP to reduce lock
  acquiring/releasing, including allocating/freeing the swap space,
  adding/deleting to/from the swap cache, and writing/reading the swap
  space, etc.  This will help improve the performance of the THP swap.

- The THP swap space read/write will be 2M sequential IO.  It is
  particularly helpful for the swap read, which are usually 4k random
  IO.  This will improve the performance of the THP swap too.

- It will help the memory fragmentation, especially when the THP is
  heavily used by the applications.  The 2M continuous pages will be
  free up after THP swapping out.

- It will improve the THP utilization on the system with the swap
  turned on.  Because the speed for khugepaged to collapse the normal
  pages into the THP is quite slow.  After the THP is split during the
  swapping out, it will take quite long time for the normal pages to
  collapse back into the THP after being swapped in.  The high THP
  utilization helps the efficiency of the page based memory management
  too.

There are some concerns regarding THP swap in, mainly because possible
enlarged read/write IO size (for swap in/out) may put more overhead on
the storage device.  To deal with that, the THP swap in should be
turned on only when necessary.  For example, it can be selected via
"always/never/madvise" logic, to be turned on globally, turned off
globally, or turned on only for VMA with MADV_HUGEPAGE, etc.

This patchset is based on 03/17 head of mmotm/master.

This patchset is the first step for the THP swap support.  The plan is
to delay splitting THP step by step, finally avoid splitting THP
during the THP swapping out and swap out/in the THP as a whole.

As the first step, in this patchset, the splitting huge page is
delayed from almost the first step of swapping out to after allocating
the swap space for the THP and adding the THP into the swap cache.
This will reduce lock acquiring/releasing for the locks used for the
swap cache management.

With the patchset, the swap out throughput improves 14.9% (from about
3.77GB/s to about 4.34GB/s) in the vm-scalability swap-w-seq test case
with 8 processes.  The test is done on a Xeon E5 v3 system.  The swap
device used is a RAM simulated PMEM (persistent memory) device.  To
test the sequential swapping out, the test case creates 8 processes,
which sequentially allocate and write to the anonymous pages until the
RAM and part of the swap device is used up.

The detailed comparison result is as follow,

base             base+patchset
---------------- -------------------------- 
         %stddev     %change         %stddev
             \          |                \  
   7043990 ±  0%     +21.2%    8536807 ±  0%  vm-scalability.throughput
    109.94 ±  1%     -16.2%      92.09 ±  0%  vm-scalability.time.elapsed_time
   3957091 ±  0%     +14.9%    4547173 ±  0%  vmstat.swap.so
     31.46 ±  1%     -38.3%      19.42 ±  0%  perf-stat.cache-miss-rate%
      1.04 ±  1%     +22.2%       1.27 ±  0%  perf-stat.ipc
      9.33 ±  2%     -60.7%       3.67 ±  1%  perf-profile.calltrace.cycles-pp.add_to_swap.shrink_page_list.shrink_inactive_list.shrink_node_memcg.shrink_node



This patch (of 9):

In this patch, the size of the swap cluster is changed to that of the THP
(Transparent Huge Page) on x86_64 architecture (512).  This is for the THP
swap support on x86_64.  Where one swap cluster will be used to hold the
contents of each THP swapped out.  And some information of the swapped out
THP (such as compound map count) will be recorded in the swap_cluster_info
data structure.

For other architectures which want THP swap support,
ARCH_USES_THP_SWAP_CLUSTER need to be selected in the Kconfig file for the
architecture.

In effect, this will enlarge swap cluster size by 2 times on x86_64. 
Which may make it harder to find a free cluster when the swap space
becomes fragmented.  So that, this may reduce the continuous swap space
allocation and sequential write in theory.  The performance test in 0day
shows no regressions caused by this.

Link: http://lkml.kernel.org/r/20170328053209.25876-2-ying.huang@intel.com
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov@tarantool.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig |    1 +
 mm/Kconfig       |   13 +++++++++++++
 mm/swapfile.c    |    4 ++++
 3 files changed, 18 insertions(+)

diff -puN arch/x86/Kconfig~mm-swap-make-swap-cluster-size-same-of-thp-size-on-x86_64 arch/x86/Kconfig
--- a/arch/x86/Kconfig~mm-swap-make-swap-cluster-size-same-of-thp-size-on-x86_64
+++ a/arch/x86/Kconfig
@@ -175,6 +175,7 @@ config X86
 	select USER_STACKTRACE_SUPPORT
 	select VIRT_TO_BUS
 	select X86_FEATURE_NAMES		if PROC_FS
+	select ARCH_USES_THP_SWAP_CLUSTER	if X86_64
 
 config INSTRUCTION_DECODER
 	def_bool y
diff -puN mm/Kconfig~mm-swap-make-swap-cluster-size-same-of-thp-size-on-x86_64 mm/Kconfig
--- a/mm/Kconfig~mm-swap-make-swap-cluster-size-same-of-thp-size-on-x86_64
+++ a/mm/Kconfig
@@ -499,6 +499,19 @@ config FRONTSWAP
 
 	  If unsure, say Y to enable frontswap.
 
+config ARCH_USES_THP_SWAP_CLUSTER
+	bool
+	default n
+
+config THP_SWAP_CLUSTER
+	bool
+	depends on SWAP && TRANSPARENT_HUGEPAGE && ARCH_USES_THP_SWAP_CLUSTER
+	default y
+	help
+	  Use one swap cluster to hold the contents of the THP
+	  (Transparent Huge Page) swapped out.  The size of the swap
+	  cluster will be same as that of THP.
+
 config CMA
 	bool "Contiguous Memory Allocator"
 	depends on HAVE_MEMBLOCK && MMU
diff -puN mm/swapfile.c~mm-swap-make-swap-cluster-size-same-of-thp-size-on-x86_64 mm/swapfile.c
--- a/mm/swapfile.c~mm-swap-make-swap-cluster-size-same-of-thp-size-on-x86_64
+++ a/mm/swapfile.c
@@ -199,7 +199,11 @@ static void discard_swap_cluster(struct
 	}
 }
 
+#ifdef CONFIG_THP_SWAP_CLUSTER
+#define SWAPFILE_CLUSTER	HPAGE_PMD_NR
+#else
 #define SWAPFILE_CLUSTER	256
+#endif
 #define LATENCY_LIMIT		256
 
 static inline void cluster_set_flag(struct swap_cluster_info *info,
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-swap-fix-a-race-in-free_swap_and_cache.patch
mm-swap-fix-comment-in-__read_swap_cache_async.patch
mm-swap-improve-readability-via-make-spin_lock-unlock-balanced.patch
mm-swap-avoid-lock-swap_avail_lock-when-held-cluster-lock.patch
mm-memcg-support-to-charge-uncharge-multiple-swap-entries.patch
mm-thp-swap-add-swap-cluster-allocate-free-functions.patch
mm-thp-swap-add-get_huge_swap_page.patch
mm-thp-swap-support-to-clear-swap_has_cache-for-huge-page.patch
mm-thp-swap-support-to-add-delete-thp-to-from-swap-cache.patch
mm-thp-add-can_split_huge_page.patch
mm-thp-swap-support-to-split-thp-in-swap-cache.patch
mm-thp-swap-delay-splitting-thp-during-swap-out.patch

