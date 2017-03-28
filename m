From: akpm@linux-foundation.org
Subject: + mm-thp-swap-delay-splitting-thp-during-swap-out.patch added to
 -mm tree
Date: Tue, 28 Mar 2017 15:14:35 -0700
Message-ID: <58dae04b.y3v1xDgY4qLEXbS8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44262 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755865AbdC1WPH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2017 18:15:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, aarcange@redhat.com, ebru.akagunduz@gmail.com, hannes@cmpxchg.org, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, minchan@kernel.org, riel@redhat.com, shli@kernel.org, tj@kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, THP, swap: delay splitting THP during swap out
has been added to the -mm tree.  Its filename is
     mm-thp-swap-delay-splitting-thp-during-swap-out.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-swap-delay-splitting-thp-during-swap-out.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-swap-delay-splitting-thp-during-swap-out.patch

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
Subject: mm, THP, swap: delay splitting THP during swap out

In this patch, splitting huge page is delayed from almost the first step
of swapping out to after allocating the swap space for the THP
(Transparent Huge Page) and adding the THP into the swap cache.  This will
reduce lock acquiring/releasing for the locks used for the swap cache
management.

This is the first step for the THP swap support.  The plan is to delay
splitting the THP step by step and avoid splitting the THP finally.

The advantages of the THP swap support include:

- Batch the swap operations for the THP to reduce lock
  acquiring/releasing, including allocating/freeing the swap space,
  adding/deleting to/from the swap cache, and writing/reading the swap
  space, etc.  This will help to improve the THP swap performance.

- The THP swap space read/write will be 2M sequential IO.  It is
  particularly helpful for the swap read, which usually are 4k random
  IO.  This will help to improve the THP swap performance too.

- It will help the memory fragmentation, especially when the THP is
  heavily used by the applications.  The 2M continuous pages will be
  free up after the THP swapping out.

- It will improve the THP utilization on the system with the swap
  turned on.  Because the speed for khugepaged to collapse the normal
  pages into the THP is quite slow.  After the THP is split during the
  swapping out, it will take quite long time for the normal pages to
  collapse back into the THP after being swapped in.  The high THP
  utilization helps the efficiency of the page based memory management
  too.

There are some concerns regarding THP swap in, mainly because possible
enlarged read/write IO size (for swap in/out) may put more overhead on the
storage device.  To deal with that, the THP swap in should be turned on
only when necessary.  For example, it can be selected via
"always/never/madvise" logic, to be turned on globally, turned off
globally, or turned on only for VMA with MADV_HUGEPAGE, etc.

With the patchset, the swap out throughput improves 14.9% (from about
3.77GB/s to about 4.34GB/s) in the vm-scalability swap-w-seq test case
with 8 processes.  The test is done on a Xeon E5 v3 system.  The swap
device used is a RAM simulated PMEM (persistent memory) device.  To test
the sequential swapping out, the test case creates 8 processes, which
sequentially allocate and write to the anonymous pages until the RAM and
part of the swap device is used up.

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

Link: http://lkml.kernel.org/r/20170328053209.25876-10-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |   60 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 57 insertions(+), 3 deletions(-)

diff -puN mm/swap_state.c~mm-thp-swap-delay-splitting-thp-during-swap-out mm/swap_state.c
--- a/mm/swap_state.c~mm-thp-swap-delay-splitting-thp-during-swap-out
+++ a/mm/swap_state.c
@@ -19,6 +19,7 @@
 #include <linux/migrate.h>
 #include <linux/vmalloc.h>
 #include <linux/swap_slots.h>
+#include <linux/huge_mm.h>
 
 #include <asm/pgtable.h>
 
@@ -183,12 +184,53 @@ void __delete_from_swap_cache(struct pag
 	ADD_CACHE_INFO(del_total, nr);
 }
 
+#ifdef CONFIG_THP_SWAP_CLUSTER
+int add_to_swap_trans_huge(struct page *page, struct list_head *list)
+{
+	swp_entry_t entry;
+	int ret = 0;
+
+	/* cannot split, which may be needed during swap in, skip it */
+	if (!can_split_huge_page(page, NULL))
+		return -EBUSY;
+	/* fallback to split huge page firstly if no PMD map */
+	if (!compound_mapcount(page))
+		return 0;
+	entry = get_huge_swap_page();
+	if (!entry.val)
+		return 0;
+	if (mem_cgroup_try_charge_swap(page, entry, HPAGE_PMD_NR)) {
+		__swapcache_free(entry, true);
+		return -EOVERFLOW;
+	}
+	ret = add_to_swap_cache(page, entry,
+				__GFP_HIGH | __GFP_NOMEMALLOC|__GFP_NOWARN);
+	/* -ENOMEM radix-tree allocation failure */
+	if (ret) {
+		__swapcache_free(entry, true);
+		return 0;
+	}
+	ret = split_huge_page_to_list(page, list);
+	if (ret) {
+		delete_from_swap_cache(page);
+		return -EBUSY;
+	}
+	return 1;
+}
+#else
+static inline int add_to_swap_trans_huge(struct page *page,
+					 struct list_head *list)
+{
+	return 0;
+}
+#endif
+
 /**
  * add_to_swap - allocate swap space for a page
  * @page: page we want to move to swap
  *
  * Allocate swap space for the page and add the page to the
- * swap cache.  Caller needs to hold the page lock. 
+ * swap cache.  Caller needs to hold the page lock.
  */
 int add_to_swap(struct page *page, struct list_head *list)
 {
@@ -198,6 +240,18 @@ int add_to_swap(struct page *page, struc
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(!PageUptodate(page), page);
 
+	if (unlikely(PageTransHuge(page))) {
+		err = add_to_swap_trans_huge(page, list);
+		switch (err) {
+		case 1:
+			return 1;
+		case 0:
+			/* fallback to split firstly if return 0 */
+			break;
+		default:
+			return 0;
+		}
+	}
 	entry = get_swap_page();
 	if (!entry.val)
 		return 0;
@@ -315,7 +369,7 @@ struct page * lookup_swap_cache(swp_entr
 
 	page = find_get_page(swap_address_space(entry), swp_offset(entry));
 
-	if (page) {
+	if (page && likely(!PageTransCompound(page))) {
 		INC_CACHE_INFO(find_success);
 		if (TestClearPageReadahead(page))
 			atomic_inc(&swapin_readahead_hits);
@@ -526,7 +580,7 @@ struct page *swapin_readahead(swp_entry_
 						gfp_mask, vma, addr);
 		if (!page)
 			continue;
-		if (offset != entry_offset)
+		if (offset != entry_offset && likely(!PageTransCompound(page)))
 			SetPageReadahead(page);
 		put_page(page);
 	}
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-swap-fix-a-race-in-free_swap_and_cache.patch
mm-swap-fix-comment-in-__read_swap_cache_async.patch
mm-swap-improve-readability-via-make-spin_lock-unlock-balanced.patch
mm-swap-avoid-lock-swap_avail_lock-when-held-cluster-lock.patch
mm-swap-make-swap-cluster-size-same-of-thp-size-on-x86_64.patch
mm-memcg-support-to-charge-uncharge-multiple-swap-entries.patch
mm-thp-swap-add-swap-cluster-allocate-free-functions.patch
mm-thp-swap-add-get_huge_swap_page.patch
mm-thp-swap-support-to-clear-swap_has_cache-for-huge-page.patch
mm-thp-swap-support-to-add-delete-thp-to-from-swap-cache.patch
mm-thp-add-can_split_huge_page.patch
mm-thp-swap-support-to-split-thp-in-swap-cache.patch
mm-thp-swap-delay-splitting-thp-during-swap-out.patch

