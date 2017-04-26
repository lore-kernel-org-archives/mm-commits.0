From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-swap-sort-swap-entries-before-free.patch
 removed from -mm tree
Date: Wed, 26 Apr 2017 15:22:47 -0700
Message-ID: <59011db7.fheovz0qh0p1d2uf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59102 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031365AbdDZWWu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Apr 2017 18:22:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, dave.hansen@intel.com, hughd@google.com, mhocko@suse.com, minchan@kernel.org, riel@redhat.com, shli@kernel.org, tim.c.chen@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, swap: sort swap entries before free
has been removed from the -mm tree.  Its filename was
     mm-swap-sort-swap-entries-before-free.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm, swap: sort swap entries before free

To reduce the lock contention of swap_info_struct->lock when freeing swap
entry.  The freed swap entries will be collected in a per-CPU buffer
firstly, and be really freed later in batch.  During the batch freeing, if
the consecutive swap entries in the per-CPU buffer belongs to same swap
device, the swap_info_struct->lock needs to be acquired/released only
once, so that the lock contention could be reduced greatly.  But if there
are multiple swap devices, it is possible that the lock may be
unnecessarily released/acquired because the swap entries belong to the
same swap device are non-consecutive in the per-CPU buffer.

To solve the issue, the per-CPU buffer is sorted according to the swap
device before freeing the swap entries.  Test shows that the time spent by
swapcache_free_entries() could be reduced after the patch.

The patch was tested by measuring the run time of
swap_cache_free_entries() during the exit phase of an application which
uses much swap space.  The results show that the average run time of
swap_cache_free_entries() was reduced about 20% after applying the patch.

The average run time of swap_cache_free_entries() is reduced from about
~137us to ~111us.  The total samples of swap_cache_free_entries() is
about 200000, run on 16 CPUs, so the wall time is about 1.7s.  I will
revise the tests to get the total run time reduction.

I added memory freeing timing capability to vm-scalability test suite. 
The result shows the memory freeing time reduced from 2.64s to 2.31s
(about -12.5%).  The memory space to free is 96G (including swap).  The
machine has 144 CPU, 32G RAM, and 96G swap.  The process number is 16.

Link: http://lkml.kernel.org/r/20170407064901.25398-1-ying.huang@intel.com
Signed-off-by: Huang Ying <ying.huang@intel.com>
Acked-by: Tim Chen <tim.c.chen@intel.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN mm/swapfile.c~mm-swap-sort-swap-entries-before-free mm/swapfile.c
--- a/mm/swapfile.c~mm-swap-sort-swap-entries-before-free
+++ a/mm/swapfile.c
@@ -37,6 +37,7 @@
 #include <linux/swapfile.h>
 #include <linux/export.h>
 #include <linux/swap_slots.h>
+#include <linux/sort.h>
 
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
@@ -1065,6 +1066,13 @@ void swapcache_free(swp_entry_t entry)
 	}
 }
 
+static int swp_entry_cmp(const void *ent1, const void *ent2)
+{
+	const swp_entry_t *e1 = ent1, *e2 = ent2;
+
+	return (long)(swp_type(*e1) - swp_type(*e2));
+}
+
 void swapcache_free_entries(swp_entry_t *entries, int n)
 {
 	struct swap_info_struct *p, *prev;
@@ -1075,6 +1083,10 @@ void swapcache_free_entries(swp_entry_t
 
 	prev = NULL;
 	p = NULL;
+
+	/* Sort swap entries by swap device, so each lock is only taken once. */
+	if (nr_swapfiles > 1)
+		sort(entries, n, sizeof(entries[0]), swp_entry_cmp, NULL);
 	for (i = 0; i < n; ++i) {
 		p = swap_info_get_cont(entries[i], prev);
 		if (p)
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-swap-fix-a-race-in-free_swap_and_cache.patch
mm-swap-fix-comment-in-__read_swap_cache_async.patch
mm-swap-improve-readability-via-make-spin_lock-unlock-balanced.patch
mm-swap-avoid-lock-swap_avail_lock-when-held-cluster-lock.patch
mm-swap-remove-unused-function-prototype.patch
mm-swap-fix-swap-space-leak-in-error-path-of-swap_free_entries.patch
mm-swap-use-kvzalloc-to-allocate-some-swap-data-structure.patch

