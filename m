From: akpm@linux-foundation.org
Subject: + mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration.patch added to -mm tree
Date: Tue, 01 Mar 2011 14:17:20 -0800
Message-ID: <201103012217.p21MHKRX002068@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754013Ab1CAWSH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Mar 2011 17:18:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, arthur.marsh@internode.on.net, cladisch@googlemail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com


The patch titled
     mm: compaction: minimise the time IRQs are disabled while isolating pages for migration
has been added to the -mm tree.  Its filename is
     mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: compaction: minimise the time IRQs are disabled while isolating pages for migration
From: Andrea Arcangeli <aarcange@redhat.com>

compaction_alloc() isolates pages for migration in isolate_migratepages. 
While it's scanning, IRQs are disabled on the mistaken assumption the
scanning should be short.  Tests show this to be true for the most part
but contention times on the LRU lock can be increased.  Before this patch,
the IRQ disabled times for a simple test looked like

Total sampled time IRQs off (not real total time): 5493
Event shrink_inactive_list..shrink_zone                  1596 us count 1
Event shrink_inactive_list..shrink_zone                  1530 us count 1
Event shrink_inactive_list..shrink_zone                   956 us count 1
Event shrink_inactive_list..shrink_zone                   541 us count 1
Event shrink_inactive_list..shrink_zone                   531 us count 1
Event split_huge_page..add_to_swap                        232 us count 1
Event save_args..call_softirq                              36 us count 1
Event save_args..call_softirq                              35 us count 2
Event __wake_up..__wake_up                                  1 us count 1

This patch reduces the worst-case IRQs-disabled latencies by releasing the
lock every SWAP_CLUSTER_MAX pages that are scanned and releasing the CPU if
necessary. The cost of this is that the processing performing compaction will
be slower but IRQs being disabled for too long a time has worse consequences
as the following report shows;

Total sampled time IRQs off (not real total time): 4367
Event shrink_inactive_list..shrink_zone                   881 us count 1
Event shrink_inactive_list..shrink_zone                   875 us count 1
Event shrink_inactive_list..shrink_zone                   868 us count 1
Event shrink_inactive_list..shrink_zone                   555 us count 1
Event split_huge_page..add_to_swap                        495 us count 1
Event compact_zone..compact_zone_order                    269 us count 1
Event split_huge_page..add_to_swap                        266 us count 1
Event shrink_inactive_list..shrink_zone                    85 us count 1
Event save_args..call_softirq                              36 us count 2
Event __wake_up..__wake_up                                  1 us count 1

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Arthur Marsh <arthur.marsh@internode.on.net>
Cc: Clemens Ladisch <cladisch@googlemail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff -puN mm/compaction.c~mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration mm/compaction.c
--- a/mm/compaction.c~mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration
+++ a/mm/compaction.c
@@ -279,9 +279,27 @@ static unsigned long isolate_migratepage
 	}
 
 	/* Time to isolate some pages for migration */
+	cond_resched();
 	spin_lock_irq(&zone->lru_lock);
 	for (; low_pfn < end_pfn; low_pfn++) {
 		struct page *page;
+		bool unlocked = false;
+
+		/* give a chance to irqs before checking need_resched() */
+		if (!((low_pfn+1) % SWAP_CLUSTER_MAX)) {
+			spin_unlock_irq(&zone->lru_lock);
+			unlocked = true;
+		}
+		if (need_resched() || spin_is_contended(&zone->lru_lock)) {
+			if (!unlocked)
+				spin_unlock_irq(&zone->lru_lock);
+			cond_resched();
+			spin_lock_irq(&zone->lru_lock);
+			if (fatal_signal_pending(current))
+				break;
+		} else if (unlocked)
+			spin_lock_irq(&zone->lru_lock);
+
 		if (!pfn_valid_within(low_pfn))
 			continue;
 		nr_scanned++;
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
x86-fix-pgd_lock-deadlock.patch
mm-compaction-check-migrate_pagess-return-value-instead-of-list_empty.patch
mm-deactivate-invalidated-pages.patch
memcg-move-memcg-reclaimable-page-into-tail-of-inactive-list.patch
mm-reclaim-invalidated-page-asap.patch
pagewalk-only-split-huge-pages-when-necessary.patch
smaps-break-out-smaps_pte_entry-from-smaps_pte_range.patch
smaps-pass-pte-size-argument-in-to-smaps_pte_entry.patch
smaps-teach-smaps_pte_range-about-thp-pmds.patch
smaps-have-smaps-show-transparent-huge-pages.patch
mm-vmscan-kswapd-should-not-free-an-excessive-number-of-pages-when-balancing-small-zones.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-free-pages.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration-fix.patch

