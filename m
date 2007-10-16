From: akpm@linux-foundation.org
Subject: - drain-per-cpu-lists-when-high-order-allocations-fail.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:34:36 -0700
Message-ID: <200710162034.l9GKYavq014956@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35825 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765841AbXJPViE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:38:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Drain per-cpu lists when high-order allocations fail
has been removed from the -mm tree.  Its filename was
     drain-per-cpu-lists-when-high-order-allocations-fail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Drain per-cpu lists when high-order allocations fail
From: Mel Gorman <mel@csn.ul.ie>

Per-cpu pages can accidentally cause fragmentation because they are free, but
pinned pages in an otherwise contiguous block.  When this patch is applied,
the per-cpu caches are drained after the direct-reclaim is entered if the
requested order is greater than 0.  It simply reuses the code used by suspend
and hotplug.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~drain-per-cpu-lists-when-high-order-allocations-fail mm/page_alloc.c
--- a/mm/page_alloc.c~drain-per-cpu-lists-when-high-order-allocations-fail
+++ a/mm/page_alloc.c
@@ -876,7 +876,9 @@ void mark_free_pages(struct zone *zone)
 	}
 	spin_unlock_irqrestore(&zone->lock, flags);
 }
+#endif /* CONFIG_PM */
 
+#if defined(CONFIG_HIBERNATION) || defined(CONFIG_PAGE_GROUP_BY_MOBILITY)
 /*
  * Spill all of this CPU's per-cpu pages back into the buddy allocator.
  */
@@ -888,7 +890,28 @@ void drain_local_pages(void)
 	__drain_pages(smp_processor_id());
 	local_irq_restore(flags);	
 }
-#endif /* CONFIG_HIBERNATION */
+
+void smp_drain_local_pages(void *arg)
+{
+	drain_local_pages();
+}
+
+/*
+ * Spill all the per-cpu pages from all CPUs back into the buddy allocator
+ */
+void drain_all_local_pages(void)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	__drain_pages(smp_processor_id());
+	local_irq_restore(flags);
+
+	smp_call_function(smp_drain_local_pages, NULL, 0, 1);
+}
+#else
+void drain_all_local_pages(void) {}
+#endif /* CONFIG_HIBERNATION || CONFIG_PAGE_GROUP_BY_MOBILITY */
 
 /*
  * Free a 0-order page
@@ -1480,6 +1503,9 @@ nofail_alloc:
 
 	cond_resched();
 
+	if (order != 0)
+		drain_all_local_pages();
+
 	if (likely(did_some_progress)) {
 		page = get_page_from_freelist(gfp_mask, order,
 						zonelist, alloc_flags);
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
ext2-reservations.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch
