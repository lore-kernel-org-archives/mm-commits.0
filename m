From: akpm@linux-foundation.org
Subject: [patch 097/108] mm/swapfile.c: sort swap entries before
 free
Date: Thu, 06 Jul 2017 15:40:31 -0700
Message-ID: <20170706224031.-0IcMRMUa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37044 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752867AbdGFWki (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:40:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hughd@google.com, minchan@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com, shli@kernel.org, tim.c.chen@intel.com, torvalds@linux-foundation.org, ying.huang@intel.com

From: Huang Ying <ying.huang@intel.com>
Subject: mm/swapfile.c: sort swap entries before free

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
device before freeing the swap entries.

With the patch, the memory (some swapped out) free time reduced 11.6%
(from 2.65s to 2.35s) in the vm-scalability swap-w-rand test case with 16
processes.  The test is done on a Xeon E5 v3 system.  The swap device used
is a RAM simulated PMEM (persistent memory) device.  To test swapping, the
test case creates 16 processes, which allocate and write to the anonymous
pages until the RAM and part of the swap device is used up, finally the
memory (some swapped out) is freed before exit.

[akpm@linux-foundation.org: tweak comment]
Link: http://lkml.kernel.org/r/20170525005916.25249-1-ying.huang@intel.com
Signed-off-by: Huang Ying <ying.huang@intel.com>
Acked-by: Tim Chen <tim.c.chen@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

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
@@ -1198,6 +1199,13 @@ void put_swap_page(struct page *page, sw
 		swapcache_free_cluster(entry);
 }
 
+static int swp_entry_cmp(const void *ent1, const void *ent2)
+{
+	const swp_entry_t *e1 = ent1, *e2 = ent2;
+
+	return (int)swp_type(*e1) - (int)swp_type(*e2);
+}
+
 void swapcache_free_entries(swp_entry_t *entries, int n)
 {
 	struct swap_info_struct *p, *prev;
@@ -1208,6 +1216,14 @@ void swapcache_free_entries(swp_entry_t
 
 	prev = NULL;
 	p = NULL;
+
+	/*
+	 * Sort swap entries by swap device, so each lock is only taken once.
+	 * nr_swapfiles isn't absolutely correct, but the overhead of sort() is
+	 * so low that it isn't necessary to optimize further.
+	 */
+	if (nr_swapfiles > 1)
+		sort(entries, n, sizeof(entries[0]), swp_entry_cmp, NULL);
 	for (i = 0; i < n; ++i) {
 		p = swap_info_get_cont(entries[i], prev);
 		if (p)
_
