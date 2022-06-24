Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60493C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jun 2022 19:08:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiFXTIK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Jun 2022 15:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbiFXTIK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2022 15:08:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44EDF27FDA
        for <mm-commits@vger.kernel.org>; Fri, 24 Jun 2022 12:08:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D23E36216F
        for <mm-commits@vger.kernel.org>; Fri, 24 Jun 2022 19:08:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 248F2C34114;
        Fri, 24 Jun 2022 19:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656097688;
        bh=8U6mVChdD92OwGho8Ev0jiTLODEnenG5E+v0W3PWow4=;
        h=Date:To:From:Subject:From;
        b=tZ0WTrkCHfHWLkqrPsouk/qK1hdjRN51/zA/6qfHY6ax18ZVdY9O1uQ6ftRhZU4fo
         fWQW/5lV1NI2LwIpRVoCvkdPSaJwrhyrzkxt3uN1OzW6RrISE+oqknLfWE4nq4pETc
         wJ0CXjJA7xegc8aMYTIG216zrM1qvHD20J0O0QjQ=
Date:   Fri, 24 Jun 2022 12:08:07 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, vbabka@suse.cz,
        nsaenzju@redhat.com, mtosatti@redhat.com, m.szyprowski@samsung.com,
        minchan@kernel.org, mhocko@kernel.org, hughd@google.com,
        mgorman@techsingularity.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-add-page-buddy_list-and-page-pcp_list.patch added to mm-unstable branch
Message-Id: <20220624190808.248F2C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: add page->buddy_list and page->pcp_list
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-add-page-buddy_list-and-page-pcp_list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-add-page-buddy_list-and-page-pcp_list.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: add page->buddy_list and page->pcp_list
Date: Fri, 24 Jun 2022 13:54:17 +0100

Patch series "Drain remote per-cpu directly", v5.

Some setups, notably NOHZ_FULL CPUs, may be running realtime or
latency-sensitive applications that cannot tolerate interference due to
per-cpu drain work queued by __drain_all_pages().  Introduce a new
mechanism to remotely drain the per-cpu lists.  It is made possible by
remotely locking 'struct per_cpu_pages' new per-cpu spinlocks.  This has
two advantages, the time to drain is more predictable and other unrelated
tasks are not interrupted.

This series has the same intent as Nicolas' series "mm/page_alloc: Remote
per-cpu lists drain support" -- avoid interference of a high priority task
due to a workqueue item draining per-cpu page lists.  While many workloads
can tolerate a brief interruption, it may cause a real-time task running
on a NOHZ_FULL CPU to miss a deadline and at minimum, the draining is
non-deterministic.

Currently an IRQ-safe local_lock protects the page allocator per-cpu
lists.  The local_lock on its own prevents migration and the IRQ disabling
protects from corruption due to an interrupt arriving while a page
allocation is in progress.

This series adjusts the locking.  A spinlock is added to struct
per_cpu_pages to protect the list contents while local_lock_irq is
ultimately replaced by just the spinlock in the final patch.  This allows
a remote CPU to safely.  Follow-on work should allow the spin_lock_irqsave
to be converted to spin_lock to avoid IRQs being disabled/enabled in most
cases.  The follow-on patch will be one kernel release later as it is
relatively high risk and it'll make bisections more clear if there are any
problems.

Patch 1 is a cosmetic patch to clarify when page->lru is storing buddy pages
	and when it is storing per-cpu pages.

Patch 2 shrinks per_cpu_pages to make room for a spin lock. Strictly speaking
	this is not necessary but it avoids per_cpu_pages consuming another
	cache line.

Patch 3 is a preparation patch to avoid code duplication.

Patch 4 is a minor correction.

Patch 5 uses a spin_lock to protect the per_cpu_pages contents while still
	relying on local_lock to prevent migration, stabilise the pcp
	lookup and prevent IRQ reentrancy.

Patch 6 remote drains per-cpu pages directly instead of using a workqueue.

Patch 7 uses a normal spinlock instead of local_lock for remote draining


This patch (of 7):

The page allocator uses page->lru for storing pages on either buddy or PCP
lists.  Create page->buddy_list and page->pcp_list as a union with
page->lru.  This is simply to clarify what type of list a page is on in
the page allocator.

No functional change intended.

[minchan@kernel.org: fix page lru fields in macros]
Link: https://lkml.kernel.org/r/20220624125423.6126-2-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Tested-by: Minchan Kim <minchan@kernel.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    5 +++++
 mm/page_alloc.c          |   24 ++++++++++++------------
 2 files changed, 17 insertions(+), 12 deletions(-)

--- a/include/linux/mm_types.h~mm-page_alloc-add-page-buddy_list-and-page-pcp_list
+++ a/include/linux/mm_types.h
@@ -88,6 +88,7 @@ struct page {
 			 */
 			union {
 				struct list_head lru;
+
 				/* Or, for the Unevictable "LRU list" slot */
 				struct {
 					/* Always even, to negate PageTail */
@@ -95,6 +96,10 @@ struct page {
 					/* Count page's or folio's mlocks */
 					unsigned int mlock_count;
 				};
+
+				/* Or, free page */
+				struct list_head buddy_list;
+				struct list_head pcp_list;
 			};
 			/* See page-flags.h for PAGE_MAPPING_FLAGS */
 			struct address_space *mapping;
--- a/mm/page_alloc.c~mm-page_alloc-add-page-buddy_list-and-page-pcp_list
+++ a/mm/page_alloc.c
@@ -793,7 +793,7 @@ static inline bool set_page_guard(struct
 		return false;
 
 	__SetPageGuard(page);
-	INIT_LIST_HEAD(&page->lru);
+	INIT_LIST_HEAD(&page->buddy_list);
 	set_page_private(page, order);
 	/* Guard pages are not available for any usage */
 	__mod_zone_freepage_state(zone, -(1 << order), migratetype);
@@ -936,7 +936,7 @@ static inline void add_to_free_list(stru
 {
 	struct free_area *area = &zone->free_area[order];
 
-	list_add(&page->lru, &area->free_list[migratetype]);
+	list_add(&page->buddy_list, &area->free_list[migratetype]);
 	area->nr_free++;
 }
 
@@ -946,7 +946,7 @@ static inline void add_to_free_list_tail
 {
 	struct free_area *area = &zone->free_area[order];
 
-	list_add_tail(&page->lru, &area->free_list[migratetype]);
+	list_add_tail(&page->buddy_list, &area->free_list[migratetype]);
 	area->nr_free++;
 }
 
@@ -960,7 +960,7 @@ static inline void move_to_free_list(str
 {
 	struct free_area *area = &zone->free_area[order];
 
-	list_move_tail(&page->lru, &area->free_list[migratetype]);
+	list_move_tail(&page->buddy_list, &area->free_list[migratetype]);
 }
 
 static inline void del_page_from_free_list(struct page *page, struct zone *zone,
@@ -970,7 +970,7 @@ static inline void del_page_from_free_li
 	if (page_reported(page))
 		__ClearPageReported(page);
 
-	list_del(&page->lru);
+	list_del(&page->buddy_list);
 	__ClearPageBuddy(page);
 	set_page_private(page, 0);
 	zone->free_area[order].nr_free--;
@@ -1508,11 +1508,11 @@ static void free_pcppages_bulk(struct zo
 		do {
 			int mt;
 
-			page = list_last_entry(list, struct page, lru);
+			page = list_last_entry(list, struct page, pcp_list);
 			mt = get_pcppage_migratetype(page);
 
 			/* must delete to avoid corrupting pcp list */
-			list_del(&page->lru);
+			list_del(&page->pcp_list);
 			count -= nr_pages;
 			pcp->count -= nr_pages;
 
@@ -3072,7 +3072,7 @@ static int rmqueue_bulk(struct zone *zon
 		 * for IO devices that can merge IO requests if the physical
 		 * pages are ordered properly.
 		 */
-		list_add_tail(&page->lru, list);
+		list_add_tail(&page->pcp_list, list);
 		allocated++;
 		if (is_migrate_cma(get_pcppage_migratetype(page)))
 			__mod_zone_page_state(zone, NR_FREE_CMA_PAGES,
@@ -3322,7 +3322,7 @@ void mark_free_pages(struct zone *zone)
 
 	for_each_migratetype_order(order, t) {
 		list_for_each_entry(page,
-				&zone->free_area[order].free_list[t], lru) {
+				&zone->free_area[order].free_list[t], buddy_list) {
 			unsigned long i;
 
 			pfn = page_to_pfn(page);
@@ -3411,7 +3411,7 @@ static void free_unref_page_commit(struc
 	__count_vm_event(PGFREE);
 	pcp = this_cpu_ptr(zone->per_cpu_pageset);
 	pindex = order_to_pindex(migratetype, order);
-	list_add(&page->lru, &pcp->lists[pindex]);
+	list_add(&page->pcp_list, &pcp->lists[pindex]);
 	pcp->count += 1 << order;
 
 	/*
@@ -3674,8 +3674,8 @@ struct page *__rmqueue_pcplist(struct zo
 				return NULL;
 		}
 
-		page = list_first_entry(list, struct page, lru);
-		list_del(&page->lru);
+		page = list_first_entry(list, struct page, pcp_list);
+		list_del(&page->pcp_list);
 		pcp->count -= 1 << order;
 	} while (check_new_pcp(page, order));
 
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-add-page-buddy_list-and-page-pcp_list.patch
mm-page_alloc-use-only-one-pcp-list-for-thp-sized-allocations.patch
mm-page_alloc-split-out-buddy-removal-code-from-rmqueue-into-separate-helper.patch
mm-page_alloc-remove-mistaken-page-==-null-check-in-rmqueue.patch
mm-page_alloc-protect-pcp-lists-with-a-spinlock.patch
mm-page_alloc-replace-local_lock-with-normal-spinlock.patch

