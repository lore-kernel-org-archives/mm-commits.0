From: akpm@linux-foundation.org
Subject: [obsolete]
 mm-page_alloc-re-enable-softirq-use-of-per-cpu-page-allocator.patch removed from -mm tree
Date: Tue, 18 Apr 2017 14:39:49 -0700
Message-ID: <58f687a5.a8S5A2jD6LICtAp5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38020 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752236AbdDRVju (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2017 17:39:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brouer@redhat.com, mgorman@techsingularity.net, pagupta@redhat.com, peterz@infradead.org, saeedm@mellanox.com, tariqt@mellanox.com, ttoukan.linux@gmail.com, willy@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: re-enable softirq use of per-cpu page allocator
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-re-enable-softirq-use-of-per-cpu-page-allocator.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: mm, page_alloc: re-enable softirq use of per-cpu page allocator

IRQ context were excluded from using the Per-Cpu-Pages (PCP) lists caching
of order-0 pages in commit 374ad05ab64d ("mm, page_alloc: only use per-cpu
allocator for irq-safe requests").

This unfortunately also included excluded SoftIRQ.  This hurt the
performance for the use-case of refilling DMA RX rings in softirq context.

This patch re-allow softirq context, which should be safe by disabling
BH/softirq, while accessing the list.  PCP-lists access from both hard-IRQ
and NMI context must not be allowed.  Peter Zijlstra says in_nmi() code
never access the page allocator, thus it should be sufficient to only test
for !in_irq().

One concern with this change is adding a BH (enable) scheduling point at
both PCP alloc and free.  If further concerns are highlighted by this
patch, the result will be to revert 374ad05ab64d and try again at a later
date to offset the irq enable/disable overhead.

Fixes: 374ad05ab64d ("mm, page_alloc: only use per-cpu allocator for irq-safe requests")
Link: http://lkml.kernel.org/r/20170410150821.vcjlz7ntabtfsumm@techsingularity.net
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reported-by: Tariq Toukan <tariqt@mellanox.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Pankaj Gupta <pagupta@redhat.com>
Cc: Tariq Toukan <ttoukan.linux@gmail.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-re-enable-softirq-use-of-per-cpu-page-allocator mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-re-enable-softirq-use-of-per-cpu-page-allocator
+++ a/mm/page_alloc.c
@@ -2351,9 +2351,9 @@ static void drain_local_pages_wq(struct
 	 * cpu which is allright but we also have to make sure to not move to
 	 * a different one.
 	 */
-	preempt_disable();
+	local_bh_disable();
 	drain_local_pages(NULL);
-	preempt_enable();
+	local_bh_enable();
 }
 
 /*
@@ -2488,7 +2488,11 @@ void free_hot_cold_page(struct page *pag
 	unsigned long pfn = page_to_pfn(page);
 	int migratetype;
 
-	if (in_interrupt()) {
+	/*
+	 * Exclude (hard) IRQ and NMI context from using the pcplists.
+	 * But allow softirq context, via disabling BH.
+	 */
+	if (in_irq() || irqs_disabled()) {
 		__free_pages_ok(page, 0);
 		return;
 	}
@@ -2498,7 +2502,7 @@ void free_hot_cold_page(struct page *pag
 
 	migratetype = get_pfnblock_migratetype(page, pfn);
 	set_pcppage_migratetype(page, migratetype);
-	preempt_disable();
+	local_bh_disable();
 
 	/*
 	 * We only track unmovable, reclaimable and movable on pcp lists.
@@ -2529,7 +2533,7 @@ void free_hot_cold_page(struct page *pag
 	}
 
 out:
-	preempt_enable();
+	local_bh_enable();
 }
 
 /*
@@ -2654,7 +2658,7 @@ static struct page *__rmqueue_pcplist(st
 {
 	struct page *page;
 
-	VM_BUG_ON(in_interrupt());
+	VM_BUG_ON(in_irq() || irqs_disabled());
 
 	do {
 		if (list_empty(list)) {
@@ -2687,7 +2691,7 @@ static struct page *rmqueue_pcplist(stru
 	bool cold = ((gfp_flags & __GFP_COLD) != 0);
 	struct page *page;
 
-	preempt_disable();
+	local_bh_disable();
 	pcp = &this_cpu_ptr(zone->pageset)->pcp;
 	list = &pcp->lists[migratetype];
 	page = __rmqueue_pcplist(zone,  migratetype, cold, pcp, list);
@@ -2695,7 +2699,7 @@ static struct page *rmqueue_pcplist(stru
 		__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
 		zone_statistics(preferred_zone, zone);
 	}
-	preempt_enable();
+	local_bh_enable();
 	return page;
 }
 
@@ -2711,7 +2715,11 @@ struct page *rmqueue(struct zone *prefer
 	unsigned long flags;
 	struct page *page;
 
-	if (likely(order == 0) && !in_interrupt()) {
+	/*
+	 * Exclude (hard) IRQ and NMI context from using the pcplists.
+	 * But allow softirq context, via disabling BH.
+	 */
+	if (likely(order == 0) && !(in_irq() || irqs_disabled()) ) {
 		page = rmqueue_pcplist(preferred_zone, zone, order,
 				gfp_flags, migratetype);
 		goto out;
_

Patches currently in -mm which might be from brouer@redhat.com are


