Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2B66C4321E
	for <mm-commits@archiver.kernel.org>; Wed, 16 Feb 2022 00:30:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245102AbiBPAay (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Feb 2022 19:30:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234692AbiBPAaa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Feb 2022 19:30:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB3DF70F8
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 16:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4EF6AB81C01
        for <mm-commits@vger.kernel.org>; Wed, 16 Feb 2022 00:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0582AC340EB;
        Wed, 16 Feb 2022 00:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644971416;
        bh=9qt+zbNbRwF/O/qgaFTG1yCvs0fpHtJ3ZXUBr+xagz8=;
        h=Date:To:From:Subject:From;
        b=jgLC4xsSpG4DjVa00LAAmHroZumqcD3HaxAzL3LslqYnY5XjTpaqYdQlhw8N/6XRx
         IUNrx/VTInAMIBcem0R+RbVHzaagpbm4HzV1+paESnQdlTzQMK0SFGej4u+hKr0EfB
         d1oWMlQE8HrPwpQulYjpwgBAaHGnNp6MBOJ0g7RM=
Date:   Tue, 15 Feb 2022 16:30:15 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        vbabka@suse.cz, surenb@google.com, shakeelb@google.com,
        riel@surriel.com, mhocko@suse.com, kirill@shutemov.name,
        hannes@cmpxchg.org, gthelen@google.com, david@redhat.com,
        apopple@nvidia.com, hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-munlock-replace-clear_page_mlock-by-final-clearance.patch added to -mm tree
Message-Id: <20220216003016.0582AC340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/munlock: replace clear_page_mlock() by final clearance
has been added to the -mm tree.  Its filename is
     mm-munlock-replace-clear_page_mlock-by-final-clearance.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-munlock-replace-clear_page_mlock-by-final-clearance.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-munlock-replace-clear_page_mlock-by-final-clearance.patch

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
Subject: mm/munlock: replace clear_page_mlock() by final clearance

Placing munlock_vma_page() at the end of page_remove_rmap() shifts most of
the munlocking to clear_page_mlock(), since PageMlocked is typically still
set when mapcount has fallen to 0.  That is not what we want: we want
/proc/vmstat's unevictable_pgs_cleared to remain as a useful check on the
integrity of of the mlock/munlock protocol - small numbers are not
surprising, but big numbers mean the protocol is not working.

That could be easily fixed by placing munlock_vma_page() at the start of
page_remove_rmap(); but later in the series we shall want to batch the
munlocking, and that too would tend to leave PageMlocked still set at the
point when it is checked.

So delete clear_page_mlock() now: leave it instead to release_pages() (and
__page_cache_release()) to do this backstop clearing of Mlocked, when page
refcount has fallen to 0.  If a pinned page occasionally gets counted as
Mlocked and Unevictable until it is unpinned, that's okay.

A slightly regrettable side-effect of this change is that, since
release_pages() and __page_cache_release() may be called at interrupt
time, those places which update NR_MLOCK with interrupts enabled had
better use mod_zone_page_state() than __mod_zone_page_state() (but holding
the lruvec lock always has interrupts disabled).

This change, forcing Mlocked off when refcount 0 instead of earlier when
mapcount 0, is not fundamental: it can be reversed if performance or
something else is found to suffer; but this is the easiest way to separate
the stats - let's not complicate that without good reason.

Link: https://lkml.kernel.org/r/ba15e6e-bdd5-7712-76b9-6278209e827a@google.com
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

 mm/internal.h |   12 ------------
 mm/mlock.c    |   30 ------------------------------
 mm/rmap.c     |    9 ---------
 mm/swap.c     |   32 ++++++++++++++++++++++++--------
 4 files changed, 24 insertions(+), 59 deletions(-)

--- a/mm/internal.h~mm-munlock-replace-clear_page_mlock-by-final-clearance
+++ a/mm/internal.h
@@ -425,17 +425,6 @@ static inline void munlock_vma_page(stru
 		munlock_page(page);
 }
 
-/*
- * Clear the page's PageMlocked().  This can be useful in a situation where
- * we want to unconditionally remove a page from the pagecache -- e.g.,
- * on truncation or freeing.
- *
- * It is legal to call this function for any page, mlocked or not.
- * If called for a page that is still mapped by mlocked vmas, all we do
- * is revert to lazy LRU behaviour -- semantics are not broken.
- */
-extern void clear_page_mlock(struct page *page);
-
 extern pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma);
 
 /*
@@ -509,7 +498,6 @@ static inline struct file *maybe_unlock_
 }
 #else /* !CONFIG_MMU */
 static inline void unmap_mapping_folio(struct folio *folio) { }
-static inline void clear_page_mlock(struct page *page) { }
 static inline void mlock_vma_page(struct page *page,
 			struct vm_area_struct *vma, bool compound) { }
 static inline void munlock_vma_page(struct page *page,
--- a/mm/mlock.c~mm-munlock-replace-clear_page_mlock-by-final-clearance
+++ a/mm/mlock.c
@@ -48,36 +48,6 @@ EXPORT_SYMBOL(can_do_mlock);
  * PageUnevictable is set to indicate the unevictable state.
  */
 
-/*
- *  LRU accounting for clear_page_mlock()
- */
-void clear_page_mlock(struct page *page)
-{
-	int nr_pages;
-
-	if (!TestClearPageMlocked(page))
-		return;
-
-	nr_pages = thp_nr_pages(page);
-	mod_zone_page_state(page_zone(page), NR_MLOCK, -nr_pages);
-	count_vm_events(UNEVICTABLE_PGCLEARED, nr_pages);
-	/*
-	 * The previous TestClearPageMlocked() corresponds to the smp_mb()
-	 * in __pagevec_lru_add_fn().
-	 *
-	 * See __pagevec_lru_add_fn for more explanation.
-	 */
-	if (!isolate_lru_page(page)) {
-		putback_lru_page(page);
-	} else {
-		/*
-		 * We lost the race. the page already moved to evictable list.
-		 */
-		if (PageUnevictable(page))
-			count_vm_events(UNEVICTABLE_PGSTRANDED, nr_pages);
-	}
-}
-
 /**
  * mlock_page - mlock a page
  * @page: page to be mlocked, either a normal page or a THP head.
--- a/mm/rmap.c~mm-munlock-replace-clear_page_mlock-by-final-clearance
+++ a/mm/rmap.c
@@ -1317,9 +1317,6 @@ static void page_remove_file_rmap(struct
 	 * pte lock(a spinlock) is held, which implies preemption disabled.
 	 */
 	__mod_lruvec_page_state(page, NR_FILE_MAPPED, -nr);
-
-	if (unlikely(PageMlocked(page)))
-		clear_page_mlock(page);
 }
 
 static void page_remove_anon_compound_rmap(struct page *page)
@@ -1359,9 +1356,6 @@ static void page_remove_anon_compound_rm
 		nr = thp_nr_pages(page);
 	}
 
-	if (unlikely(PageMlocked(page)))
-		clear_page_mlock(page);
-
 	if (nr)
 		__mod_lruvec_page_state(page, NR_ANON_MAPPED, -nr);
 }
@@ -1400,9 +1394,6 @@ void page_remove_rmap(struct page *page,
 	 */
 	__dec_lruvec_page_state(page, NR_ANON_MAPPED);
 
-	if (unlikely(PageMlocked(page)))
-		clear_page_mlock(page);
-
 	if (PageTransCompound(page))
 		deferred_split_huge_page(compound_head(page));
 
--- a/mm/swap.c~mm-munlock-replace-clear_page_mlock-by-final-clearance
+++ a/mm/swap.c
@@ -74,8 +74,8 @@ static DEFINE_PER_CPU(struct lru_pvecs,
 };
 
 /*
- * This path almost never happens for VM activity - pages are normally
- * freed via pagevecs.  But it gets used by networking.
+ * This path almost never happens for VM activity - pages are normally freed
+ * via pagevecs.  But it gets used by networking - and for compound pages.
  */
 static void __page_cache_release(struct page *page)
 {
@@ -89,6 +89,14 @@ static void __page_cache_release(struct
 		__clear_page_lru_flags(page);
 		unlock_page_lruvec_irqrestore(lruvec, flags);
 	}
+	/* See comment on PageMlocked in release_pages() */
+	if (unlikely(PageMlocked(page))) {
+		int nr_pages = thp_nr_pages(page);
+
+		__ClearPageMlocked(page);
+		mod_zone_page_state(page_zone(page), NR_MLOCK, -nr_pages);
+		count_vm_events(UNEVICTABLE_PGCLEARED, nr_pages);
+	}
 	__ClearPageWaiters(page);
 }
 
@@ -489,12 +497,8 @@ void lru_cache_add_inactive_or_unevictab
 	unevictable = (vma->vm_flags & (VM_LOCKED | VM_SPECIAL)) == VM_LOCKED;
 	if (unlikely(unevictable) && !TestSetPageMlocked(page)) {
 		int nr_pages = thp_nr_pages(page);
-		/*
-		 * We use the irq-unsafe __mod_zone_page_state because this
-		 * counter is not modified from interrupt context, and the pte
-		 * lock is held(spinlock), which implies preemption disabled.
-		 */
-		__mod_zone_page_state(page_zone(page), NR_MLOCK, nr_pages);
+
+		mod_zone_page_state(page_zone(page), NR_MLOCK, nr_pages);
 		count_vm_events(UNEVICTABLE_PGMLOCKED, nr_pages);
 	}
 	lru_cache_add(page);
@@ -969,6 +973,18 @@ void release_pages(struct page **pages,
 			__clear_page_lru_flags(page);
 		}
 
+		/*
+		 * In rare cases, when truncation or holepunching raced with
+		 * munlock after VM_LOCKED was cleared, Mlocked may still be
+		 * found set here.  This does not indicate a problem, unless
+		 * "unevictable_pgs_cleared" appears worryingly large.
+		 */
+		if (unlikely(PageMlocked(page))) {
+			__ClearPageMlocked(page);
+			dec_zone_page_state(page, NR_MLOCK);
+			count_vm_event(UNEVICTABLE_PGCLEARED);
+		}
+
 		__ClearPageWaiters(page);
 
 		list_add(&page->lru, &pages_to_free);
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

