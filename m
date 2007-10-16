From: akpm@linux-foundation.org
Subject: - mm-use-pagevec-to-rotate-reclaimable-page-fix-2.patch removed from -mm tree
Date: Mon, 15 Oct 2007 21:08:42 -0700
Message-ID: <200710160408.l9G48guC008009@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48790 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751493AbXJPEIt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 00:08:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, hifumi.hisashi@oss.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     mm-use-pagevec-to-rotate-reclaimable-page-fix-2
has been removed from the -mm tree.  Its filename was
     mm-use-pagevec-to-rotate-reclaimable-page-fix-2.patch

This patch was dropped because it was folded into mm-use-pagevec-to-rotate-reclaimable-page.patch

------------------------------------------------------
Subject: mm-use-pagevec-to-rotate-reclaimable-page-fix-2
From: Hugh Dickins <hugh@veritas.com>

rotate_reclaimable_page() is not necessarily called with IRQ disabled:
it must do so when calling the helpfully commented pagevec_move_tail().

Hmm, if pagevec_move_tail() is assuming IRQ disabled, why should it
bother with irqsave/irqrestore variants of spin_lock?  Because we like
to see them on lru_lock?  But vmscan.c already has one bare spin_lock().

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN mm/swap.c~mm-use-pagevec-to-rotate-reclaimable-page-fix-2 mm/swap.c
--- a/mm/swap.c~mm-use-pagevec-to-rotate-reclaimable-page-fix-2
+++ a/mm/swap.c
@@ -100,7 +100,6 @@ static void pagevec_move_tail(struct pag
 	int i;
 	int pgmoved = 0;
 	struct zone *zone = NULL;
-	unsigned long uninitialized_var(flags);
 
 	for (i = 0; i < pagevec_count(pvec); i++) {
 		struct page *page = pvec->pages[i];
@@ -108,9 +107,9 @@ static void pagevec_move_tail(struct pag
 
 		if (pagezone != zone) {
 			if (zone)
-				spin_unlock_irqrestore(&zone->lru_lock, flags);
+				spin_unlock(&zone->lru_lock);
 			zone = pagezone;
-			spin_lock_irqsave(&zone->lru_lock, flags);
+			spin_lock(&zone->lru_lock);
 		}
 		if (PageLRU(page) && !PageActive(page)) {
 			list_move_tail(&page->lru, &zone->inactive_list);
@@ -118,7 +117,7 @@ static void pagevec_move_tail(struct pag
 		}
 	}
 	if (zone)
-		spin_unlock_irqrestore(&zone->lru_lock, flags);
+		spin_unlock(&zone->lru_lock);
 	__count_vm_events(PGROTATED, pgmoved);
 	release_pages(pvec->pages, pvec->nr, pvec->cold);
 	pagevec_reinit(pvec);
@@ -148,6 +147,7 @@ void move_tail_pages()
 int rotate_reclaimable_page(struct page *page)
 {
 	struct pagevec *pvec;
+	unsigned long flags;
 
 	if (PageLocked(page))
 		return 1;
@@ -160,9 +160,11 @@ int rotate_reclaimable_page(struct page 
 
 	if (PageLRU(page) && !PageActive(page)) {
 		page_cache_get(page);
+		local_irq_save(flags);
 		pvec = &__get_cpu_var(rotate_pvecs);
 		if (!pagevec_add(pvec, page))
 			pagevec_move_tail(pvec);
+		local_irq_restore(flags);
 	}
 	if (!test_clear_page_writeback(page))
 		BUG();
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
mm-clarify-__add_to_swap_cache-locking.patch
radix-tree-use-indirect-bit.patch
mm-use-pagevec-to-rotate-reclaimable-page.patch
mm-use-pagevec-to-rotate-reclaimable-page-fix-2.patch
mm-use-pagevec-to-rotate-reclaimable-page-fix-bug-at-include-linux-mmh220.patch
mm-use-pagevec-to-rotate-reclaimable-page-kill-redundancy-in-rotate_reclaimable_page.patch
mm-use-pagevec-to-rotate-reclaimable-page-move_tail_pages-into-lru_add_drain.patch
introduce-write_begin-write_end-aops-important-fix.patch
reiserfs-convert-to-new-aops-fix.patch
hostfs-convert-to-new-aops-fix.patch
affs-convert-to-new-aops-fix.patch
flush-cache-before-installing-new-page-at-migraton.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix-update.patch
maps-pssproportional-set-size-accounting-in-smaps.patch
mm-shmemc-make-3-functions-static.patch
lib-percpu_counter_sub.patch
mm-per-device-dirty-threshold-fix.patch
ext2-reservations.patch
fix-for-ext2-reservation.patch
ext2-balloc-use-io_error-label.patch
memory-controller-memory-accounting-v7-fix-swapoff-breakage-however.patch
exportfs-add-fid-type.patch
exportfs-add-new-methods.patch
shmem-new-export-ops.patch
exportfs-remove-old-methods.patch
exportfs-make-struct-export_operations-const.patch
exportfs-update-documentation.patch
prio_tree-debugging-patch.patch
