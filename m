Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF45BC433EF
	for <mm-commits@archiver.kernel.org>; Sat,  9 Jul 2022 02:31:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbiGICbq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Jul 2022 22:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiGICbp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2022 22:31:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA20F7A517
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 19:31:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C86462558
        for <mm-commits@vger.kernel.org>; Sat,  9 Jul 2022 02:31:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C331CC341C8;
        Sat,  9 Jul 2022 02:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657333903;
        bh=iyboCq9lwnbZ3R0BVPylbSPkcY8QZeB5fiR2XW7GfdQ=;
        h=Date:To:From:Subject:From;
        b=aM8RK4KCxC+gvVGQTYprvtm+ENGsD+sa2euS7iioZhclJMzFfWYccIXSNXYfj6wEk
         v/jWysHj1F63vLooSdRdDHq16dnWWSp7oYj7kwQobG+spANKw/DCdBROT/v3DIG5VZ
         0kE61WSY/2ae/d7mrM6um3fzjaEcSjlGqQBD5NTs=
Date:   Fri, 08 Jul 2022 19:31:43 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mkoutny@suse.com, mhocko@kernel.org,
        longman@redhat.com, hannes@cmpxchg.org,
        duanxiongchun@bytedance.com, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-rename-unlock_page_lruvec_irq-_irqrestore-to-lruvec_unlock_irq-_irqrestore.patch removed from -mm tree
Message-Id: <20220709023143.C331CC341C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: rename unlock_page_lruvec{_irq, _irqrestore} to lruvec_unlock{_irq, _irqrestore}
has been removed from the -mm tree.  Its filename was
     mm-rename-unlock_page_lruvec_irq-_irqrestore-to-lruvec_unlock_irq-_irqrestore.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: rename unlock_page_lruvec{_irq, _irqrestore} to lruvec_unlock{_irq, _irqrestore}
Date: Tue, 21 Jun 2022 20:56:49 +0800

It is weird to use folio_lruvec_lock() variants and unlock_page_lruvec()
variants together, e.g.  locking folio and unlocking page.  So rename
unlock_page_lruvec{_irq, _irqrestore} to lruvec_unlock{_irq, _irqrestore}.

Link: https://lkml.kernel.org/r/20220621125658.64935-3-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   10 +++++-----
 mm/compaction.c            |   12 ++++++------
 mm/huge_memory.c           |    2 +-
 mm/mlock.c                 |    2 +-
 mm/swap.c                  |   14 +++++++-------
 mm/vmscan.c                |    4 ++--
 6 files changed, 22 insertions(+), 22 deletions(-)

--- a/include/linux/memcontrol.h~mm-rename-unlock_page_lruvec_irq-_irqrestore-to-lruvec_unlock_irq-_irqrestore
+++ a/include/linux/memcontrol.h
@@ -1579,17 +1579,17 @@ static inline struct lruvec *parent_lruv
 	return mem_cgroup_lruvec(memcg, lruvec_pgdat(lruvec));
 }
 
-static inline void unlock_page_lruvec(struct lruvec *lruvec)
+static inline void lruvec_unlock(struct lruvec *lruvec)
 {
 	spin_unlock(&lruvec->lru_lock);
 }
 
-static inline void unlock_page_lruvec_irq(struct lruvec *lruvec)
+static inline void lruvec_unlock_irq(struct lruvec *lruvec)
 {
 	spin_unlock_irq(&lruvec->lru_lock);
 }
 
-static inline void unlock_page_lruvec_irqrestore(struct lruvec *lruvec,
+static inline void lruvec_unlock_irqrestore(struct lruvec *lruvec,
 		unsigned long flags)
 {
 	spin_unlock_irqrestore(&lruvec->lru_lock, flags);
@@ -1611,7 +1611,7 @@ static inline struct lruvec *folio_lruve
 		if (folio_matches_lruvec(folio, locked_lruvec))
 			return locked_lruvec;
 
-		unlock_page_lruvec_irq(locked_lruvec);
+		lruvec_unlock_irq(locked_lruvec);
 	}
 
 	return folio_lruvec_lock_irq(folio);
@@ -1625,7 +1625,7 @@ static inline struct lruvec *folio_lruve
 		if (folio_matches_lruvec(folio, locked_lruvec))
 			return locked_lruvec;
 
-		unlock_page_lruvec_irqrestore(locked_lruvec, *flags);
+		lruvec_unlock_irqrestore(locked_lruvec, *flags);
 	}
 
 	return folio_lruvec_lock_irqsave(folio, flags);
--- a/mm/compaction.c~mm-rename-unlock_page_lruvec_irq-_irqrestore-to-lruvec_unlock_irq-_irqrestore
+++ a/mm/compaction.c
@@ -864,7 +864,7 @@ isolate_migratepages_block(struct compac
 		 */
 		if (!(low_pfn % COMPACT_CLUSTER_MAX)) {
 			if (locked) {
-				unlock_page_lruvec_irqrestore(locked, flags);
+				lruvec_unlock_irqrestore(locked, flags);
 				locked = NULL;
 			}
 
@@ -977,7 +977,7 @@ isolate_migratepages_block(struct compac
 			if (unlikely(__PageMovable(page)) &&
 					!PageIsolated(page)) {
 				if (locked) {
-					unlock_page_lruvec_irqrestore(locked, flags);
+					lruvec_unlock_irqrestore(locked, flags);
 					locked = NULL;
 				}
 
@@ -1060,7 +1060,7 @@ isolate_migratepages_block(struct compac
 		/* If we already hold the lock, we can skip some rechecking */
 		if (lruvec != locked) {
 			if (locked)
-				unlock_page_lruvec_irqrestore(locked, flags);
+				lruvec_unlock_irqrestore(locked, flags);
 
 			compact_lock_irqsave(&lruvec->lru_lock, &flags, cc);
 			locked = lruvec;
@@ -1119,7 +1119,7 @@ isolate_success_no_list:
 isolate_fail_put:
 		/* Avoid potential deadlock in freeing page under lru_lock */
 		if (locked) {
-			unlock_page_lruvec_irqrestore(locked, flags);
+			lruvec_unlock_irqrestore(locked, flags);
 			locked = NULL;
 		}
 		put_page(page);
@@ -1135,7 +1135,7 @@ isolate_fail:
 		 */
 		if (nr_isolated) {
 			if (locked) {
-				unlock_page_lruvec_irqrestore(locked, flags);
+				lruvec_unlock_irqrestore(locked, flags);
 				locked = NULL;
 			}
 			putback_movable_pages(&cc->migratepages);
@@ -1167,7 +1167,7 @@ isolate_fail:
 
 isolate_abort:
 	if (locked)
-		unlock_page_lruvec_irqrestore(locked, flags);
+		lruvec_unlock_irqrestore(locked, flags);
 	if (page) {
 		SetPageLRU(page);
 		put_page(page);
--- a/mm/huge_memory.c~mm-rename-unlock_page_lruvec_irq-_irqrestore-to-lruvec_unlock_irq-_irqrestore
+++ a/mm/huge_memory.c
@@ -2519,7 +2519,7 @@ static void __split_huge_page(struct pag
 	}
 
 	ClearPageCompound(head);
-	unlock_page_lruvec(lruvec);
+	lruvec_unlock(lruvec);
 	/* Caller disabled irqs, so they are still disabled here */
 
 	split_page_owner(head, nr);
--- a/mm/mlock.c~mm-rename-unlock_page_lruvec_irq-_irqrestore-to-lruvec_unlock_irq-_irqrestore
+++ a/mm/mlock.c
@@ -205,7 +205,7 @@ static void mlock_pagevec(struct pagevec
 	}
 
 	if (lruvec)
-		unlock_page_lruvec_irq(lruvec);
+		lruvec_unlock_irq(lruvec);
 	release_pages(pvec->pages, pvec->nr);
 	pagevec_reinit(pvec);
 }
--- a/mm/swap.c~mm-rename-unlock_page_lruvec_irq-_irqrestore-to-lruvec_unlock_irq-_irqrestore
+++ a/mm/swap.c
@@ -86,7 +86,7 @@ static void __page_cache_release(struct
 		lruvec = folio_lruvec_lock_irqsave(folio, &flags);
 		lruvec_del_folio(lruvec, folio);
 		__folio_clear_lru_flags(folio);
-		unlock_page_lruvec_irqrestore(lruvec, flags);
+		lruvec_unlock_irqrestore(lruvec, flags);
 	}
 	/* See comment on folio_test_mlocked in release_pages() */
 	if (unlikely(folio_test_mlocked(folio))) {
@@ -249,7 +249,7 @@ static void folio_batch_move_lru(struct
 	}
 
 	if (lruvec)
-		unlock_page_lruvec_irqrestore(lruvec, flags);
+		lruvec_unlock_irqrestore(lruvec, flags);
 	folios_put(fbatch->folios, folio_batch_count(fbatch));
 	folio_batch_init(fbatch);
 }
@@ -392,7 +392,7 @@ static void folio_activate(struct folio
 	if (folio_test_clear_lru(folio)) {
 		lruvec = folio_lruvec_lock_irq(folio);
 		folio_activate_fn(lruvec, folio);
-		unlock_page_lruvec_irq(lruvec);
+		lruvec_unlock_irq(lruvec);
 		folio_set_lru(folio);
 	}
 }
@@ -948,7 +948,7 @@ void release_pages(struct page **pages,
 		 * same lruvec. The lock is held only if lruvec != NULL.
 		 */
 		if (lruvec && ++lock_batch == SWAP_CLUSTER_MAX) {
-			unlock_page_lruvec_irqrestore(lruvec, flags);
+			lruvec_unlock_irqrestore(lruvec, flags);
 			lruvec = NULL;
 		}
 
@@ -957,7 +957,7 @@ void release_pages(struct page **pages,
 
 		if (folio_is_zone_device(folio)) {
 			if (lruvec) {
-				unlock_page_lruvec_irqrestore(lruvec, flags);
+				lruvec_unlock_irqrestore(lruvec, flags);
 				lruvec = NULL;
 			}
 			if (put_devmap_managed_page(&folio->page))
@@ -972,7 +972,7 @@ void release_pages(struct page **pages,
 
 		if (folio_test_large(folio)) {
 			if (lruvec) {
-				unlock_page_lruvec_irqrestore(lruvec, flags);
+				lruvec_unlock_irqrestore(lruvec, flags);
 				lruvec = NULL;
 			}
 			__folio_put_large(folio);
@@ -1006,7 +1006,7 @@ void release_pages(struct page **pages,
 		list_add(&folio->lru, &pages_to_free);
 	}
 	if (lruvec)
-		unlock_page_lruvec_irqrestore(lruvec, flags);
+		lruvec_unlock_irqrestore(lruvec, flags);
 
 	mem_cgroup_uncharge_list(&pages_to_free);
 	free_unref_page_list(&pages_to_free);
--- a/mm/vmscan.c~mm-rename-unlock_page_lruvec_irq-_irqrestore-to-lruvec_unlock_irq-_irqrestore
+++ a/mm/vmscan.c
@@ -2251,7 +2251,7 @@ int folio_isolate_lru(struct folio *foli
 		folio_get(folio);
 		lruvec = folio_lruvec_lock_irq(folio);
 		lruvec_del_folio(lruvec, folio);
-		unlock_page_lruvec_irq(lruvec);
+		lruvec_unlock_irq(lruvec);
 		ret = 0;
 	}
 
@@ -4880,7 +4880,7 @@ void check_move_unevictable_pages(struct
 	if (lruvec) {
 		__count_vm_events(UNEVICTABLE_PGRESCUED, pgrescued);
 		__count_vm_events(UNEVICTABLE_PGSCANNED, pgscanned);
-		unlock_page_lruvec_irq(lruvec);
+		lruvec_unlock_irq(lruvec);
 	} else if (pgscanned) {
 		count_vm_events(UNEVICTABLE_PGSCANNED, pgscanned);
 	}
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-fix-missing-wake-up-event-for-fsdax-pages.patch
mm-memcontrol-prepare-objcg-api-for-non-kmem-usage.patch
mm-memcontrol-make-lruvec-lock-safe-when-lru-pages-are-reparented.patch
mm-vmscan-rework-move_pages_to_lru.patch
mm-thp-make-split-queue-lock-safe-when-lru-pages-are-reparented.patch
mm-memcontrol-make-all-the-callers-of-foliopage_memcg-safe.patch
mm-memcontrol-introduce-memcg_reparent_ops.patch
mm-memcontrol-use-obj_cgroup-apis-to-charge-the-lru-pages.patch
mm-lru-add-vm_warn_on_once_folio-to-lru-maintenance-function.patch
mm-hugetlb_vmemmap-delete-hugetlb_optimize_vmemmap_enabled.patch
mm-hugetlb_vmemmap-optimize-vmemmap_optimize_mode-handling.patch
mm-hugetlb_vmemmap-introduce-the-name-hvo.patch
mm-hugetlb_vmemmap-move-vmemmap-code-related-to-hugetlb-to-hugetlb_vmemmapc.patch
mm-hugetlb_vmemmap-replace-early_param-with-core_param.patch
mm-hugetlb_vmemmap-improve-hugetlb_vmemmap-code-readability.patch
mm-hugetlb_vmemmap-move-code-comments-to-vmemmap_deduprst.patch
mm-hugetlb_vmemmap-use-ptrs_per_pte-instead-of-pmd_size-page_size.patch

