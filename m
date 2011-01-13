From: akpm@linux-foundation.org
Subject: [folded] mm-migration-use-rcu_dereference_protected-when-dereferencing-the-radix-tree-slot-during-file-page-migration-fix.patch removed from -mm tree
Date: Thu, 13 Jan 2011 15:34:57 -0800
Message-ID: <201101132334.p0DNYvY9007353@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757120Ab1AMXfC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 18:35:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     mm-migration-use-rcu_dereference_protected-when-dereferencing-the-radix-tree-slot-during-file-page-migration-fix
has been removed from the -mm tree.  Its filename was
     mm-migration-use-rcu_dereference_protected-when-dereferencing-the-radix-tree-slot-during-file-page-migration-fix.patch

This patch was dropped because it was folded into mm-migration-use-rcu_dereference_protected-when-dereferencing-the-radix-tree-slot-during-file-page-migration.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-migration-use-rcu_dereference_protected-when-dereferencing-the-radix-tree-slot-during-file-page-migration-fix
From: Andrew Morton <akpm@linux-foundation.org>

remove unneeded casts

Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/migrate.c~mm-migration-use-rcu_dereference_protected-when-dereferencing-the-radix-tree-slot-during-file-page-migration-fix mm/migrate.c
--- a/mm/migrate.c~mm-migration-use-rcu_dereference_protected-when-dereferencing-the-radix-tree-slot-during-file-page-migration-fix
+++ a/mm/migrate.c
@@ -248,7 +248,7 @@ static int migrate_page_move_mapping(str
 
 	expected_count = 2 + page_has_private(page);
 	if (page_count(page) != expected_count ||
-			(struct page *)radix_tree_deref_slot_protected(pslot, &mapping->tree_lock) != page) {
+		radix_tree_deref_slot_protected(pslot, &mapping->tree_lock) != page) {
 		spin_unlock_irq(&mapping->tree_lock);
 		return -EAGAIN;
 	}
@@ -320,7 +320,7 @@ int migrate_huge_page_move_mapping(struc
 
 	expected_count = 2 + page_has_private(page);
 	if (page_count(page) != expected_count ||
-	    (struct page *)radix_tree_deref_slot_protected(pslot, &mapping->tree_lock) != page) {
+		radix_tree_deref_slot_protected(pslot, &mapping->tree_lock) != page) {
 		spin_unlock_irq(&mapping->tree_lock);
 		return -EAGAIN;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds.patch
sync_inode_metadata-fix-comment.patch
fs-mpagec-consolidate-code.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time.patch
writeback-avoid-unnecessary-determine_dirtyable_memory-call.patch
thp-pte-alloc-trans-splitting.patch
thp-kvm-mmu-transparent-hugepage-support.patch
thp-khugepaged-make-khugepaged-aware-of-madvise.patch
mm-migration-use-rcu_dereference_protected-when-dereferencing-the-radix-tree-slot-during-file-page-migration.patch
mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common-fix.patch
brk-fix-min_brk-lower-bound-computation-for-compat_brk-fix.patch
mm-page_allocc-simplify-calculation-of-combined-index-of-adjacent-buddy-lists-checkpatch-fixes.patch
mm-page_allocc-simplify-calculation-of-combined-index-of-adjacent-buddy-lists-fix.patch
mm-dmapoolc-use-task_uninterruptible-in-dma_pool_alloc.patch
hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler-fix.patch
hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment-fix.patch
mm-fix-migration-hangs-on-anon_vma-lock-checkpatch-fixes.patch
mm-page_allocc-dont-cache-current-in-a-local.patch
mm-batch-activate_page-to-reduce-lock-contention-checkpatch-fixes.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch

