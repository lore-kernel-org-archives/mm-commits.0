From: akpm@linux-foundation.org
Subject: - mm-use-pagevec-to-rotate-reclaimable-page-fix-bug-at-include-linux-mmh220.patch removed from -mm tree
Date: Mon, 15 Oct 2007 21:08:46 -0700
Message-ID: <200710160408.l9G48kAu008018@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48364 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752124AbXJPEJC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 00:09:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, hifumi.hisashi@oss.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     fix BUG at include/linux/mm.h:220!
has been removed from the -mm tree.  Its filename was
     mm-use-pagevec-to-rotate-reclaimable-page-fix-bug-at-include-linux-mmh220.patch

This patch was dropped because it was folded into mm-use-pagevec-to-rotate-reclaimable-page.patch

------------------------------------------------------
Subject: fix BUG at include/linux/mm.h:220!
From: Hugh Dickins <hugh@veritas.com>

a.k.a. mm-use-pagevec-to-rotate-reclaimable-page-fix-3.patch

put_page_testzero's VM_BUG_ON(atomic_read(&page->_count) == 0) fired
a couple of times while heavily swapping (on -rc7-mm1 and -rc8-mm1).

release_pages() has been using spin_lock_irq/spin_unlock_irq: but now
that it's being called by pagevec_move_tail() with interrupts disabled,
it must use spin_lock_irqsave/spin_unlock_irqrestore instead.

Aside from it being generally wrong to enable IRQs behind the caller's
back, here a pagevec might overflow, or (as I think must have happened
to cause those BUGs) release_pages() may be preempted to another cpu
while still acting on the pagevec of the cpu it started out with,
and that owning cpu also come in to drain it.  Hmm, no, one of the
BUGs was with preemption disabled: so I don't fully understand it.

Tested for 39 hours with rc8-mm1 on three 4cpu machines: no more BUGs.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN mm/swap.c~mm-use-pagevec-to-rotate-reclaimable-page-fix-bug-at-include-linux-mmh220 mm/swap.c
--- a/mm/swap.c~mm-use-pagevec-to-rotate-reclaimable-page-fix-bug-at-include-linux-mmh220
+++ a/mm/swap.c
@@ -296,6 +296,7 @@ void release_pages(struct page **pages, 
 	int i;
 	struct pagevec pages_to_free;
 	struct zone *zone = NULL;
+	unsigned long uninitialized_var(flags);
 
 	pagevec_init(&pages_to_free, cold);
 	for (i = 0; i < nr; i++) {
@@ -303,7 +304,7 @@ void release_pages(struct page **pages, 
 
 		if (unlikely(PageCompound(page))) {
 			if (zone) {
-				spin_unlock_irq(&zone->lru_lock);
+				spin_unlock_irqrestore(&zone->lru_lock, flags);
 				zone = NULL;
 			}
 			put_compound_page(page);
@@ -317,9 +318,10 @@ void release_pages(struct page **pages, 
 			struct zone *pagezone = page_zone(page);
 			if (pagezone != zone) {
 				if (zone)
-					spin_unlock_irq(&zone->lru_lock);
+					spin_unlock_irqrestore(&zone->lru_lock,
+									flags);
 				zone = pagezone;
-				spin_lock_irq(&zone->lru_lock);
+				spin_lock_irqsave(&zone->lru_lock, flags);
 			}
 			VM_BUG_ON(!PageLRU(page));
 			__ClearPageLRU(page);
@@ -328,7 +330,7 @@ void release_pages(struct page **pages, 
 
 		if (!pagevec_add(&pages_to_free, page)) {
 			if (zone) {
-				spin_unlock_irq(&zone->lru_lock);
+				spin_unlock_irqrestore(&zone->lru_lock, flags);
 				zone = NULL;
 			}
 			__pagevec_free(&pages_to_free);
@@ -336,7 +338,7 @@ void release_pages(struct page **pages, 
   		}
 	}
 	if (zone)
-		spin_unlock_irq(&zone->lru_lock);
+		spin_unlock_irqrestore(&zone->lru_lock, flags);
 
 	pagevec_free(&pages_to_free);
 }
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
mm-clarify-__add_to_swap_cache-locking.patch
radix-tree-use-indirect-bit.patch
mm-use-pagevec-to-rotate-reclaimable-page.patch
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
