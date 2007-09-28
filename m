From: akpm@linux-foundation.org
Subject: + mm-use-pagevec-to-rotate-reclaimable-page-kill-redundancy-in-rotate_reclaimable_page.patch added to -mm tree
Date: Thu, 27 Sep 2007 17:10:59 -0700
Message-ID: <200709280011.l8S0AxHd002230@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41632 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759529AbXI1ALi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Sep 2007 20:11:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, hifumi.hisashi@oss.ntt.co.jp


The patch titled
     kill redundancy in rotate_reclaimable_page
has been added to the -mm tree.  Its filename is
     mm-use-pagevec-to-rotate-reclaimable-page-kill-redundancy-in-rotate_reclaimable_page.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kill redundancy in rotate_reclaimable_page
From: Hugh Dickins <hugh@veritas.com>

a.k.a. mm-use-pagevec-to-rotate-reclaimable-page-cleanup.patch

PageActive and PageLRU twice in a row: of course there used to be a
lock taken in between those tests; but now that pagevec_move_tail() is
making those tests under lock, there's no point to repeating them here.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN mm/swap.c~mm-use-pagevec-to-rotate-reclaimable-page-kill-redundancy-in-rotate_reclaimable_page mm/swap.c
--- a/mm/swap.c~mm-use-pagevec-to-rotate-reclaimable-page-kill-redundancy-in-rotate_reclaimable_page
+++ a/mm/swap.c
@@ -158,14 +158,13 @@ int rotate_reclaimable_page(struct page 
 	if (!PageLRU(page))
 		return 1;
 
-	if (PageLRU(page) && !PageActive(page)) {
-		page_cache_get(page);
-		local_irq_save(flags);
-		pvec = &__get_cpu_var(rotate_pvecs);
-		if (!pagevec_add(pvec, page))
-			pagevec_move_tail(pvec);
-		local_irq_restore(flags);
-	}
+	page_cache_get(page);
+	local_irq_save(flags);
+	pvec = &__get_cpu_var(lru_rotate_pvecs);
+	if (!pagevec_add(pvec, page))
+		pagevec_move_tail(pvec);
+	local_irq_restore(flags);
+
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
