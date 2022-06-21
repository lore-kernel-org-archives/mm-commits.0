Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 097E4C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 21 Jun 2022 20:07:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353078AbiFUUHA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Jun 2022 16:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245194AbiFUUG7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jun 2022 16:06:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B4622EF
        for <mm-commits@vger.kernel.org>; Tue, 21 Jun 2022 13:06:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCB986181A
        for <mm-commits@vger.kernel.org>; Tue, 21 Jun 2022 20:06:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 570E4C341D9;
        Tue, 21 Jun 2022 20:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655842017;
        bh=8b/pzvb2EsUlu5eKqVEixKYLqYPyhKoykO7ZRlT1VQ4=;
        h=Date:To:From:Subject:From;
        b=HRhUWszvVLkl/Fd6lnuKlbtJR12VLFvomCBuKdKCe4Nv3f76BB4wPL9wxDyv265f3
         S/xU32R4Oni938Taok0eQCW2zo4atiYv1DaTRGg6HrJrdoPzxk9J2/Ed7vl5vxhnX5
         8H5GP1NUUr3X3ljnNSl6blo9vpc+I7AX8DEE2bd8=
Date:   Tue, 21 Jun 2022 13:06:47 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mkoutny@suse.com, mhocko@kernel.org,
        longman@redhat.com, hannes@cmpxchg.org,
        duanxiongchun@bytedance.com, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rename-unlock_page_lruvec_irq-_irqrestore-to-lruvec_unlock_irq-_irqrestore.patch added to mm-unstable branch
Message-Id: <20220621200655.570E4C341D9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rename unlock_page_lruvec{_irq, _irqrestore} to lruvec_unlock{_irq, _irqrestore}
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rename-unlock_page_lruvec_irq-_irqrestore-to-lruvec_unlock_irq-_irqrestore.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rename-unlock_page_lruvec_irq-_irqrestore-to-lruvec_unlock_irq-_irqrestore.patch

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
@@ -2515,7 +2515,7 @@ static void __split_huge_page(struct pag
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
@@ -2257,7 +2257,7 @@ int folio_isolate_lru(struct folio *foli
 		folio_get(folio);
 		lruvec = folio_lruvec_lock_irq(folio);
 		lruvec_del_folio(lruvec, folio);
-		unlock_page_lruvec_irq(lruvec);
+		lruvec_unlock_irq(lruvec);
 		ret = 0;
 	}
 
@@ -4886,7 +4886,7 @@ void check_move_unevictable_pages(struct
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

mm-memory_hotplug-enumerate-all-supported-section-flags.patch
mm-memory_hotplug-make-hugetlb_optimize_vmemmap-compatible-with-memmap_on_memory.patch
mm-hugetlb-remove-minimum_order-variable.patch
mm-memcontrol-remove-dead-code-and-comments.patch
mm-rename-unlock_page_lruvec_irq-_irqrestore-to-lruvec_unlock_irq-_irqrestore.patch
mm-memcontrol-prepare-objcg-api-for-non-kmem-usage.patch
mm-memcontrol-make-lruvec-lock-safe-when-lru-pages-are-reparented.patch
mm-vmscan-rework-move_pages_to_lru.patch
mm-thp-make-split-queue-lock-safe-when-lru-pages-are-reparented.patch
mm-memcontrol-make-all-the-callers-of-foliopage_memcg-safe.patch
mm-memcontrol-introduce-memcg_reparent_ops.patch
mm-memcontrol-use-obj_cgroup-apis-to-charge-the-lru-pages.patch
mm-lru-add-vm_warn_on_once_folio-to-lru-maintenance-function.patch
mm-lru-use-lruvec-lock-to-serialize-memcg-changes.patch

