Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58CA8C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 16 Feb 2022 00:31:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238275AbiBPAbm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Feb 2022 19:31:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245109AbiBPAao (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Feb 2022 19:30:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D71F956A
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 16:30:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B68A36164C
        for <mm-commits@vger.kernel.org>; Wed, 16 Feb 2022 00:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 113F1C340EB;
        Wed, 16 Feb 2022 00:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644971419;
        bh=CS4i40lZ6cEE+q98OPExMHCCM1PHxPMR41I6YBBmj0Y=;
        h=Date:To:From:Subject:From;
        b=wmWUOBkTFsbMP31ri0GGRhC6glTg8pVrOVLvnZyqdEPhlqzQT384j6CBNfJAoa3yy
         wIEAblSt8tCFrAgr9UqEKsFFcAuTJwBAiybUW+Gcomki3br4j+IZvpFusyyBvXBewY
         9ovCCVX7+9X8hytnXXmhlsAT3WA6cxOhtpiJkZ20=
Date:   Tue, 15 Feb 2022 16:30:18 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        vbabka@suse.cz, surenb@google.com, shakeelb@google.com,
        riel@surriel.com, mhocko@suse.com, kirill@shutemov.name,
        hannes@cmpxchg.org, gthelen@google.com, david@redhat.com,
        apopple@nvidia.com, hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-munlock-maintain-page-mlock_count-while-unevictable.patch added to -mm tree
Message-Id: <20220216003019.113F1C340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/munlock: maintain page->mlock_count while unevictable
has been added to the -mm tree.  Its filename is
     mm-munlock-maintain-page-mlock_count-while-unevictable.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-munlock-maintain-page-mlock_count-while-unevictable.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-munlock-maintain-page-mlock_count-while-unevictable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/munlock: maintain page->mlock_count while unevictable

Previous patches have been preparatory: now implement page->mlock_count. 
The ordering of the "Unevictable LRU" is of no significance, and there is
no point holding unevictable pages on a list: place page->mlock_count to
overlay page->lru.prev (since page->lru.next is overlaid by compound_head,
which needs to be even so as not to satisfy PageTail - though 2 could be
added instead of 1 for each mlock, if that's ever an improvement).

But it's only safe to rely on or modify page->mlock_count while lruvec
lock is held and page is on unevictable "LRU" - we can save lots of edits
by continuing to pretend that there's an imaginary LRU here (there is an
unevictable count which still needs to be maintained, but not a list).

The mlock_count technique suffers from an unreliability much like with
page_mlock(): while someone else has the page off LRU, not much can be
done.  As before, err on the safe side (behave as if mlock_count 0), and
let try_to_unlock_one() move the page to unevictable if reclaim finds out
later on - a few misplaced pages don't matter, what we want to avoid is
imbalancing reclaim by flooding evictable lists with unevictable pages.

I am not a fan of "if (!isolate_lru_page(page)) putback_lru_page(page);":
if we have taken lruvec lock to get the page off its present list, then we
save everyone trouble (and however many extra atomic ops) by putting it on
its destination list immediately.

Link: https://lkml.kernel.org/r/cd14eda-5be0-b8b9-4273-cf28818cfef9@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |   11 ++++--
 include/linux/mm_types.h  |   19 +++++++++-
 mm/huge_memory.c          |    5 ++
 mm/memcontrol.c           |    3 -
 mm/mlock.c                |   66 ++++++++++++++++++++++++++++--------
 mm/mmzone.c               |    7 +++
 mm/swap.c                 |    1 
 7 files changed, 91 insertions(+), 21 deletions(-)

--- a/include/linux/mm_inline.h~mm-munlock-maintain-page-mlock_count-while-unevictable
+++ a/include/linux/mm_inline.h
@@ -99,7 +99,8 @@ void lruvec_add_folio(struct lruvec *lru
 
 	update_lru_size(lruvec, lru, folio_zonenum(folio),
 			folio_nr_pages(folio));
-	list_add(&folio->lru, &lruvec->lists[lru]);
+	if (lru != LRU_UNEVICTABLE)
+		list_add(&folio->lru, &lruvec->lists[lru]);
 }
 
 static __always_inline void add_page_to_lru_list(struct page *page,
@@ -115,6 +116,7 @@ void lruvec_add_folio_tail(struct lruvec
 
 	update_lru_size(lruvec, lru, folio_zonenum(folio),
 			folio_nr_pages(folio));
+	/* This is not expected to be used on LRU_UNEVICTABLE */
 	list_add_tail(&folio->lru, &lruvec->lists[lru]);
 }
 
@@ -127,8 +129,11 @@ static __always_inline void add_page_to_
 static __always_inline
 void lruvec_del_folio(struct lruvec *lruvec, struct folio *folio)
 {
-	list_del(&folio->lru);
-	update_lru_size(lruvec, folio_lru_list(folio), folio_zonenum(folio),
+	enum lru_list lru = folio_lru_list(folio);
+
+	if (lru != LRU_UNEVICTABLE)
+		list_del(&folio->lru);
+	update_lru_size(lruvec, lru, folio_zonenum(folio),
 			-folio_nr_pages(folio));
 }
 
--- a/include/linux/mm_types.h~mm-munlock-maintain-page-mlock_count-while-unevictable
+++ a/include/linux/mm_types.h
@@ -85,7 +85,16 @@ struct page {
 			 * lruvec->lru_lock.  Sometimes used as a generic list
 			 * by the page owner.
 			 */
-			struct list_head lru;
+			union {
+				struct list_head lru;
+				/* Or, for the Unevictable "LRU list" slot */
+				struct {
+					/* Always even, to negate PageTail */
+					void *__filler;
+					/* Count page's or folio's mlocks */
+					unsigned int mlock_count;
+				};
+			};
 			/* See page-flags.h for PAGE_MAPPING_FLAGS */
 			struct address_space *mapping;
 			pgoff_t index;		/* Our offset within mapping. */
@@ -241,7 +250,13 @@ struct folio {
 		struct {
 	/* public: */
 			unsigned long flags;
-			struct list_head lru;
+			union {
+				struct list_head lru;
+				struct {
+					void *__filler;
+					unsigned int mlock_count;
+				};
+			};
 			struct address_space *mapping;
 			pgoff_t index;
 			void *private;
--- a/mm/huge_memory.c~mm-munlock-maintain-page-mlock_count-while-unevictable
+++ a/mm/huge_memory.c
@@ -2290,8 +2290,11 @@ static void lru_add_page_tail(struct pag
 	} else {
 		/* head is still on lru (and we have it frozen) */
 		VM_WARN_ON(!PageLRU(head));
+		if (PageUnevictable(tail))
+			tail->mlock_count = 0;
+		else
+			list_add_tail(&tail->lru, &head->lru);
 		SetPageLRU(tail);
-		list_add_tail(&tail->lru, &head->lru);
 	}
 }
 
--- a/mm/memcontrol.c~mm-munlock-maintain-page-mlock_count-while-unevictable
+++ a/mm/memcontrol.c
@@ -1257,8 +1257,7 @@ struct lruvec *folio_lruvec_lock_irqsave
  * @nr_pages: positive when adding or negative when removing
  *
  * This function must be called under lru_lock, just before a page is added
- * to or just after a page is removed from an lru list (that ordering being
- * so as to allow it to check that lru_size 0 is consistent with list_empty).
+ * to or just after a page is removed from an lru list.
  */
 void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
 				int zid, int nr_pages)
--- a/mm/mlock.c~mm-munlock-maintain-page-mlock_count-while-unevictable
+++ a/mm/mlock.c
@@ -54,16 +54,35 @@ EXPORT_SYMBOL(can_do_mlock);
  */
 void mlock_page(struct page *page)
 {
+	struct lruvec *lruvec;
+	int nr_pages = thp_nr_pages(page);
+
 	VM_BUG_ON_PAGE(PageTail(page), page);
 
 	if (!TestSetPageMlocked(page)) {
-		int nr_pages = thp_nr_pages(page);
-
 		mod_zone_page_state(page_zone(page), NR_MLOCK, nr_pages);
-		count_vm_events(UNEVICTABLE_PGMLOCKED, nr_pages);
-		if (!isolate_lru_page(page))
-			putback_lru_page(page);
+		__count_vm_events(UNEVICTABLE_PGMLOCKED, nr_pages);
 	}
+
+	/* There is nothing more we can do while it's off LRU */
+	if (!TestClearPageLRU(page))
+		return;
+
+	lruvec = folio_lruvec_lock_irq(page_folio(page));
+	if (PageUnevictable(page)) {
+		page->mlock_count++;
+		goto out;
+	}
+
+	del_page_from_lru_list(page, lruvec);
+	ClearPageActive(page);
+	SetPageUnevictable(page);
+	page->mlock_count = 1;
+	add_page_to_lru_list(page, lruvec);
+	__count_vm_events(UNEVICTABLE_PGCULLED, nr_pages);
+out:
+	SetPageLRU(page);
+	unlock_page_lruvec_irq(lruvec);
 }
 
 /**
@@ -72,19 +91,40 @@ void mlock_page(struct page *page)
  */
 void munlock_page(struct page *page)
 {
+	struct lruvec *lruvec;
+	int nr_pages = thp_nr_pages(page);
+
 	VM_BUG_ON_PAGE(PageTail(page), page);
 
+	lock_page_memcg(page);
+	lruvec = folio_lruvec_lock_irq(page_folio(page));
+	if (PageLRU(page) && PageUnevictable(page)) {
+		/* Then mlock_count is maintained, but might undercount */
+		if (page->mlock_count)
+			page->mlock_count--;
+		if (page->mlock_count)
+			goto out;
+	}
+	/* else assume that was the last mlock: reclaim will fix it if not */
+
 	if (TestClearPageMlocked(page)) {
-		int nr_pages = thp_nr_pages(page);
+		__mod_zone_page_state(page_zone(page), NR_MLOCK, -nr_pages);
+		if (PageLRU(page) || !PageUnevictable(page))
+			__count_vm_events(UNEVICTABLE_PGMUNLOCKED, nr_pages);
+		else
+			__count_vm_events(UNEVICTABLE_PGSTRANDED, nr_pages);
+	}
 
-		mod_zone_page_state(page_zone(page), NR_MLOCK, -nr_pages);
-		if (!isolate_lru_page(page)) {
-			putback_lru_page(page);
-			count_vm_events(UNEVICTABLE_PGMUNLOCKED, nr_pages);
-		} else if (PageUnevictable(page)) {
-			count_vm_events(UNEVICTABLE_PGSTRANDED, nr_pages);
-		}
+	/* page_evictable() has to be checked *after* clearing Mlocked */
+	if (PageLRU(page) && PageUnevictable(page) && page_evictable(page)) {
+		del_page_from_lru_list(page, lruvec);
+		ClearPageUnevictable(page);
+		add_page_to_lru_list(page, lruvec);
+		__count_vm_events(UNEVICTABLE_PGRESCUED, nr_pages);
 	}
+out:
+	unlock_page_lruvec_irq(lruvec);
+	unlock_page_memcg(page);
 }
 
 /*
--- a/mm/mmzone.c~mm-munlock-maintain-page-mlock_count-while-unevictable
+++ a/mm/mmzone.c
@@ -81,6 +81,13 @@ void lruvec_init(struct lruvec *lruvec)
 
 	for_each_lru(lru)
 		INIT_LIST_HEAD(&lruvec->lists[lru]);
+	/*
+	 * The "Unevictable LRU" is imaginary: though its size is maintained,
+	 * it is never scanned, and unevictable pages are not threaded on it
+	 * (so that their lru fields can be reused to hold mlock_count).
+	 * Poison its list head, so that any operations on it would crash.
+	 */
+	list_del(&lruvec->lists[LRU_UNEVICTABLE]);
 }
 
 #if defined(CONFIG_NUMA_BALANCING) && !defined(LAST_CPUPID_NOT_IN_PAGE_FLAGS)
--- a/mm/swap.c~mm-munlock-maintain-page-mlock_count-while-unevictable
+++ a/mm/swap.c
@@ -1062,6 +1062,7 @@ static void __pagevec_lru_add_fn(struct
 	} else {
 		folio_clear_active(folio);
 		folio_set_unevictable(folio);
+		folio->mlock_count = !!folio_test_mlocked(folio);
 		if (!was_unevictable)
 			__count_vm_events(UNEVICTABLE_PGCULLED, nr_pages);
 	}
_

Patches currently in -mm which might be from hughd@google.com are

mm-munlock-delete-page_mlock-and-all-its-works.patch
mm-munlock-delete-foll_mlock-and-foll_populate.patch
mm-munlock-delete-munlock_vma_pages_all-allow-oomreap.patch
mm-munlock-rmap-call-mlock_vma_page-munlock_vma_page.patch
mm-munlock-replace-clear_page_mlock-by-final-clearance.patch
mm-munlock-maintain-page-mlock_count-while-unevictable.patch
mm-munlock-mlock_pte_range-when-mlocking-or-munlocking.patch
mm-migrate-__unmap_and_move-push-good-newpage-to-lru.patch
mm-munlock-delete-smp_mb-from-__pagevec_lru_add_fn.patch
mm-munlock-mlock_page-munlock_page-batch-by-pagevec.patch
mm-munlock-page-migration-needs-mlock-pagevec-drained.patch
mm-thp-collapse_file-do-try_to_unmapttu_batch_flush.patch
mm-thp-shrink_page_list-avoid-splitting-vm_locked-thp.patch

