From: akpm@linux-foundation.org
Subject: + mm-swap-sort-swap-entries-before-free.patch added to -mm tree
Date: Thu, 25 May 2017 16:23:58 -0700
Message-ID: <5927678e.fYkEqhsy6BjD6upX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47996 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1165994AbdEYXX7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2017 19:23:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, hughd@google.com, minchan@kernel.org, riel@redhat.com, shli@kernel.org, tim.c.chen@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile.c: sort swap entries before free
has been added to the -mm tree.  Its filename is
     mm-swap-sort-swap-entries-before-free.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-sort-swap-entries-before-free.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-sort-swap-entries-before-free.patch

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

Link: http://lkml.kernel.org/r/20170525005916.25249-1-ying.huang@intel.com
Signed-off-by: Huang Ying <ying.huang@intel.com>
Acked-by: Tim Chen <tim.c.chen@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

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
@@ -1208,6 +1216,15 @@ void swapcache_free_entries(swp_entry_t
 
 	prev = NULL;
 	p = NULL;
+
+	/*
+	 * Sort swap entries by swap device, so each lock is only
+	 * taken once.  Although nr_swapfiles isn't absolute correct,
+	 * but the overhead of sort() is so low that it isn't
+	 * necessary to optimize further.
+	 */
+	if (nr_swapfiles > 1)
+		sort(entries, n, sizeof(entries[0]), swp_entry_cmp, NULL);
 	for (i = 0; i < n; ++i) {
 		p = swap_info_get_cont(entries[i], prev);
 		if (p)
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-thp-swap-delay-splitting-thp-during-swap-out.patch
mm-thp-swap-delay-splitting-thp-during-swap-out-fix.patch
mm-thp-swap-check-whether-thp-can-be-split-firstly.patch
mm-thp-swap-enable-thp-swap-optimization-only-if-has-compound-map.patch
mm-swap-sort-swap-entries-before-free.patch

