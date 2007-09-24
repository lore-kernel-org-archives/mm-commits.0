From: akpm@linux-foundation.org
Subject: + mm-use-pagevec-to-rotate-reclaimable-page-fix-2.patch added to -mm tree
Date: Mon, 24 Sep 2007 09:52:40 -0700
Message-ID: <200709241652.l8OGqegb007683@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44724 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755110AbXIXQwu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Sep 2007 12:52:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, hifumi.hisashi@oss.ntt.co.jp


The patch titled
     mm-use-pagevec-to-rotate-reclaimable-page-fix-2
has been added to the -mm tree.  Its filename is
     mm-use-pagevec-to-rotate-reclaimable-page-fix-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -101,7 +101,6 @@ static void pagevec_move_tail(struct pag
 	int i;
 	int pgmoved = 0;
 	struct zone *zone = NULL;
-	unsigned long uninitialized_var(flags);
 
 	for (i = 0; i < pagevec_count(pvec); i++) {
 		struct page *page = pvec->pages[i];
@@ -109,9 +108,9 @@ static void pagevec_move_tail(struct pag
 
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
@@ -119,7 +118,7 @@ static void pagevec_move_tail(struct pag
 		}
 	}
 	if (zone)
-		spin_unlock_irqrestore(&zone->lru_lock, flags);
+		spin_unlock(&zone->lru_lock);
 	__count_vm_events(PGROTATED, pgmoved);
 	release_pages(pvec->pages, pvec->nr, pvec->cold);
 	pagevec_reinit(pvec);
@@ -149,6 +148,7 @@ void move_tail_pages()
 int rotate_reclaimable_page(struct page *page)
 {
 	struct pagevec *pvec;
+	unsigned long flags;
 
 	if (PageLocked(page))
 		return 1;
@@ -161,9 +161,11 @@ int rotate_reclaimable_page(struct page 
 
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

git-libata-all.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
mm-clarify-__add_to_swap_cache-locking.patch
mm-clarify-__add_to_swap_cache-locking-fix.patch
radix-tree-use-indirect-bit.patch
use-vm_read-write-exec-to-set-vm_page_prot.patch
mm-use-pagevec-to-rotate-reclaimable-page-fix-2.patch
introduce-write_begin-write_end-aops-important-fix.patch
reiserfs-convert-to-new-aops-fix.patch
hostfs-convert-to-new-aops-fix.patch
affs-convert-to-new-aops-fix.patch
flush-cache-before-installing-new-page-at-migraton.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix-update.patch
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
