From: akpm@linux-foundation.org
Subject: [merged] mm-fix-up-thp-spin_is_locked-bugs.patch removed from -mm tree
Date: Thu, 09 Feb 2012 12:21:15 -0800
Message-ID: <20120209202115.77718A016E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:35900 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757935Ab2BIUVQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2012 15:21:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aarcange@redhat.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix UP THP spin_is_locked BUGs
has been removed from the -mm tree.  Its filename was
     mm-fix-up-thp-spin_is_locked-bugs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: fix UP THP spin_is_locked BUGs

Fix CONFIG_TRANSPARENT_HUGEPAGE=y CONFIG_SMP=n CONFIG_DEBUG_VM=y
CONFIG_DEBUG_SPINLOCK=n kernel: spin_is_locked() is then always false, and
so triggers some BUGs in Transparent HugePage codepaths.

asm-generic/bug.h mentions this problem, and provides a WARN_ON_SMP(x);
but being too lazy to add VM_BUG_ON_SMP, BUG_ON_SMP, WARN_ON_SMP_ONCE,
VM_WARN_ON_SMP_ONCE, just test NR_CPUS != 1 in the existing VM_BUG_ONs.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 mm/swap.c        |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/huge_memory.c~mm-fix-up-thp-spin_is_locked-bugs mm/huge_memory.c
--- a/mm/huge_memory.c~mm-fix-up-thp-spin_is_locked-bugs
+++ a/mm/huge_memory.c
@@ -2083,7 +2083,7 @@ static void collect_mm_slot(struct mm_sl
 {
 	struct mm_struct *mm = mm_slot->mm;
 
-	VM_BUG_ON(!spin_is_locked(&khugepaged_mm_lock));
+	VM_BUG_ON(NR_CPUS != 1 && !spin_is_locked(&khugepaged_mm_lock));
 
 	if (khugepaged_test_exit(mm)) {
 		/* free mm_slot */
@@ -2113,7 +2113,7 @@ static unsigned int khugepaged_scan_mm_s
 	int progress = 0;
 
 	VM_BUG_ON(!pages);
-	VM_BUG_ON(!spin_is_locked(&khugepaged_mm_lock));
+	VM_BUG_ON(NR_CPUS != 1 && !spin_is_locked(&khugepaged_mm_lock));
 
 	if (khugepaged_scan.mm_slot)
 		mm_slot = khugepaged_scan.mm_slot;
diff -puN mm/swap.c~mm-fix-up-thp-spin_is_locked-bugs mm/swap.c
--- a/mm/swap.c~mm-fix-up-thp-spin_is_locked-bugs
+++ a/mm/swap.c
@@ -659,7 +659,7 @@ void lru_add_page_tail(struct zone* zone
 	VM_BUG_ON(!PageHead(page));
 	VM_BUG_ON(PageCompound(page_tail));
 	VM_BUG_ON(PageLRU(page_tail));
-	VM_BUG_ON(!spin_is_locked(&zone->lru_lock));
+	VM_BUG_ON(NR_CPUS != 1 && !spin_is_locked(&zone->lru_lock));
 
 	SetPageLRU(page_tail);
 
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
mm-add-rss-counters-consistency-check.patch
mm-vmscan-fix-misused-nr_reclaimed-in-shrink_mem_cgroup_zone.patch
make-swapin-readahead-skip-over-holes.patch
make-swapin-readahead-skip-over-holes-fix.patch
compact_pgdat-workaround-lockdep-warning-in-kswapd.patch
memcg-replace-mem_cont-by-mem_res_ctlr.patch
memcg-replace-mem-and-mem_cont-stragglers.patch
memcg-lru_size-instead-of-mem_cgroup_zstat.patch
memcg-enum-lru_list-lru.patch
memcg-remove-redundant-returns.patch
idr-make-idr_get_next-good-for-rcu_read_lock.patch
cgroup-revert-ss_id_lock-to-spinlock.patch
memcg-let-css_get_next-rely-upon-rcu_read_lock.patch
memcg-remove-pcg_cache-page_cgroup-flag.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
prio_tree-debugging-patch.patch

