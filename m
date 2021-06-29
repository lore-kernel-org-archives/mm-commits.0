Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E60FC11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:42:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07B5161D0C
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:42:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbhF2Co2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:44:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:36714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231893AbhF2Co2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:44:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2E66611AE;
        Tue, 29 Jun 2021 02:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934521;
        bh=zdkmbdAQUr/rJiiqjSsNQpt2fz85RB3OW/q7ILU23L0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=UD6jdv7lIcnCwaJFB8tGmuD9K4z2T+wUGgMkJ9bKZb6qCbrGeOBhoBvF5iaSYArzU
         N+6nHX0zJgWkA9kd1o6b5+eoxV7Ds4XPBnxP9cuQaF4j7eUx3lmkOkfKMelGRxGdom
         kPylrYChZIQl7Q6p4OGlXcqUCZvlSGjtnf/2D45s=
Date:   Mon, 28 Jun 2021 19:42:00 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        brouer@redhat.com, chuck.lever@oracle.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mhocko@kernel.org, mingo@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        tglx@linutronix.de, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 167/192] mm/page_alloc: avoid conflating IRQs
 disabled with zone->lock
Message-ID: <20210629024200.rqdilz6kY%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: avoid conflating IRQs disabled with zone->lock

Historically when freeing pages, free_one_page() assumed that callers had
IRQs disabled and the zone->lock could be acquired with spin_lock().  This
confuses the scope of what local_lock_irq is protecting and what
zone->lock is protecting in free_unref_page_list in particular.

This patch uses spin_lock_irqsave() for the zone->lock in free_one_page()
instead of relying on callers to have disabled IRQs. 
free_unref_page_commit() is changed to only deal with PCP pages protected
by the local lock.  free_unref_page_list() then first frees isolated pages
to the buddy lists with free_one_page() and frees the rest of the pages to
the PCP via free_unref_page_commit().  The end result is that
free_one_page() is no longer depending on side-effects of local_lock to be
correct.

Note that this may incur a performance penalty while memory hot-remove is
running but that is not a common operation.

[lkp@intel.com: Ensure CMA pages get addded to correct pcp list]
Link: https://lkml.kernel.org/r/20210512095458.30632-9-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   75 ++++++++++++++++++++++++++++++----------------
 1 file changed, 49 insertions(+), 26 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-avoid-conflating-irqs-disabled-with-zone-lock
+++ a/mm/page_alloc.c
@@ -1501,13 +1501,15 @@ static void free_one_page(struct zone *z
 				unsigned int order,
 				int migratetype, fpi_t fpi_flags)
 {
-	spin_lock(&zone->lock);
+	unsigned long flags;
+
+	spin_lock_irqsave(&zone->lock, flags);
 	if (unlikely(has_isolate_pageblock(zone) ||
 		is_migrate_isolate(migratetype))) {
 		migratetype = get_pfnblock_migratetype(page, pfn);
 	}
 	__free_one_page(page, pfn, zone, order, migratetype, fpi_flags);
-	spin_unlock(&zone->lock);
+	spin_unlock_irqrestore(&zone->lock, flags);
 }
 
 static void __meminit __init_single_page(struct page *page, unsigned long pfn,
@@ -3285,31 +3287,13 @@ static bool free_unref_page_prepare(stru
 	return true;
 }
 
-static void free_unref_page_commit(struct page *page, unsigned long pfn)
+static void free_unref_page_commit(struct page *page, unsigned long pfn,
+				   int migratetype)
 {
 	struct zone *zone = page_zone(page);
 	struct per_cpu_pages *pcp;
-	int migratetype;
 
-	migratetype = get_pcppage_migratetype(page);
 	__count_vm_event(PGFREE);
-
-	/*
-	 * We only track unmovable, reclaimable and movable on pcp lists.
-	 * Free ISOLATE pages back to the allocator because they are being
-	 * offlined but treat HIGHATOMIC as movable pages so we can get those
-	 * areas back if necessary. Otherwise, we may have to free
-	 * excessively into the page allocator
-	 */
-	if (migratetype >= MIGRATE_PCPTYPES) {
-		if (unlikely(is_migrate_isolate(migratetype))) {
-			free_one_page(zone, page, pfn, 0, migratetype,
-				      FPI_NONE);
-			return;
-		}
-		migratetype = MIGRATE_MOVABLE;
-	}
-
 	pcp = this_cpu_ptr(zone->per_cpu_pageset);
 	list_add(&page->lru, &pcp->lists[migratetype]);
 	pcp->count++;
@@ -3324,12 +3308,29 @@ void free_unref_page(struct page *page)
 {
 	unsigned long flags;
 	unsigned long pfn = page_to_pfn(page);
+	int migratetype;
 
 	if (!free_unref_page_prepare(page, pfn))
 		return;
 
+	/*
+	 * We only track unmovable, reclaimable and movable on pcp lists.
+	 * Place ISOLATE pages on the isolated list because they are being
+	 * offlined but treat HIGHATOMIC as movable pages so we can get those
+	 * areas back if necessary. Otherwise, we may have to free
+	 * excessively into the page allocator
+	 */
+	migratetype = get_pcppage_migratetype(page);
+	if (unlikely(migratetype >= MIGRATE_PCPTYPES)) {
+		if (unlikely(is_migrate_isolate(migratetype))) {
+			free_one_page(page_zone(page), page, pfn, 0, migratetype, FPI_NONE);
+			return;
+		}
+		migratetype = MIGRATE_MOVABLE;
+	}
+
 	local_lock_irqsave(&pagesets.lock, flags);
-	free_unref_page_commit(page, pfn);
+	free_unref_page_commit(page, pfn, migratetype);
 	local_unlock_irqrestore(&pagesets.lock, flags);
 }
 
@@ -3341,22 +3342,44 @@ void free_unref_page_list(struct list_he
 	struct page *page, *next;
 	unsigned long flags, pfn;
 	int batch_count = 0;
+	int migratetype;
 
 	/* Prepare pages for freeing */
 	list_for_each_entry_safe(page, next, list, lru) {
 		pfn = page_to_pfn(page);
 		if (!free_unref_page_prepare(page, pfn))
 			list_del(&page->lru);
+
+		/*
+		 * Free isolated pages directly to the allocator, see
+		 * comment in free_unref_page.
+		 */
+		migratetype = get_pcppage_migratetype(page);
+		if (unlikely(migratetype >= MIGRATE_PCPTYPES)) {
+			if (unlikely(is_migrate_isolate(migratetype))) {
+				list_del(&page->lru);
+				free_one_page(page_zone(page), page, pfn, 0,
+							migratetype, FPI_NONE);
+				continue;
+			}
+
+			/*
+			 * Non-isolated types over MIGRATE_PCPTYPES get added
+			 * to the MIGRATE_MOVABLE pcp list.
+			 */
+			set_pcppage_migratetype(page, MIGRATE_MOVABLE);
+		}
+
 		set_page_private(page, pfn);
 	}
 
 	local_lock_irqsave(&pagesets.lock, flags);
 	list_for_each_entry_safe(page, next, list, lru) {
-		unsigned long pfn = page_private(page);
-
+		pfn = page_private(page);
 		set_page_private(page, 0);
+		migratetype = get_pcppage_migratetype(page);
 		trace_mm_page_free_batched(page);
-		free_unref_page_commit(page, pfn);
+		free_unref_page_commit(page, pfn, migratetype);
 
 		/*
 		 * Guard against excessive IRQ disabled times when we get
_
