From: akpm@linux-foundation.org
Subject: [merged] mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:37:00 -0700
Message-ID: <201103232040.p2NKeb2k028549@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60441 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933396Ab1CWUly (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:41:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, arthur.marsh@internode.on.net, cladisch@googlemail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, mm-commits@vger.


The patch titled
     mm: compaction: minimise the time IRQs are disabled while isolating pages for migration
has been removed from the -mm tree.  Its filename was
     mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: simplify with s/unlocked/locked/]
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
@@ -277,9 +277,27 @@ static unsigned long isolate_migratepage
 	}
 
 	/* Time to isolate some pages for migration */
+	cond_resched();
 	spin_lock_irq(&zone->lru_lock);
 	for (; low_pfn < end_pfn; low_pfn++) {
 		struct page *page;
+		bool locked = true;
+
+		/* give a chance to irqs before checking need_resched() */
+		if (!((low_pfn+1) % SWAP_CLUSTER_MAX)) {
+			spin_unlock_irq(&zone->lru_lock);
+			locked = false;
+		}
+		if (need_resched() || spin_is_contended(&zone->lru_lock)) {
+			if (locked)
+				spin_unlock_irq(&zone->lru_lock);
+			cond_resched();
+			spin_lock_irq(&zone->lru_lock);
+			if (fatal_signal_pending(current))
+				break;
+		} else if (!locked)
+			spin_lock_irq(&zone->lru_lock);
+
 		if (!pfn_valid_within(low_pfn))
 			continue;
 		nr_scanned++;
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix.patch
ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages-fix-fix-fix.patch
mm-add-vm-counters-for-transparent-hugepages.patch
memcg-use-native-word-page-statistics-counters-fix-event-counter-breakage-with-thp.patch

