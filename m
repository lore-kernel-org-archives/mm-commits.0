From: akpm@linux-foundation.org
Subject: [folded] mm-fix-migration-hangs-on-anon_vma-lock-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 13 Jan 2011 15:38:39 -0800
Message-ID: <201101132338.p0DNcdDT007537@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54117 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757120Ab1AMXjO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 18:39:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     mm-fix-migration-hangs-on-anon_vma-lock-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-fix-migration-hangs-on-anon_vma-lock-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-fix-migration-hangs-on-anon_vma-lock.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-fix-migration-hangs-on-anon_vma-lock-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: else should follow close brace '}'
#77: FILE: mm/migrate.c:716:
+		}
+		else if (PageSwapCache(page)) {

total: 1 errors, 0 warnings, 90 lines checked

./patches/mm-fix-migration-hangs-on-anon_vma-lock.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/migrate.c~mm-fix-migration-hangs-on-anon_vma-lock-checkpatch-fixes mm/migrate.c
--- a/mm/migrate.c~mm-fix-migration-hangs-on-anon_vma-lock-checkpatch-fixes
+++ a/mm/migrate.c
@@ -712,8 +712,7 @@ static int unmap_and_move(new_page_t get
 			 */
 			get_anon_vma(anon_vma);
 			page_unlock_anon_vma(anon_vma);
-		}
-		else if (PageSwapCache(page)) {
+		} else if (PageSwapCache(page)) {
 			/*
 			 * We cannot be sure that the anon_vma of an unmapped
 			 * swapcache page is safe to use because we don't
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
mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common.patch
brk-fix-min_brk-lower-bound-computation-for-compat_brk.patch
mm-page_allocc-simplify-calculation-of-combined-index-of-adjacent-buddy-lists.patch
mm-dmapoolc-use-task_uninterruptible-in-dma_pool_alloc.patch
hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler.patch
hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment.patch
mm-fix-migration-hangs-on-anon_vma-lock.patch
mm-page_allocc-dont-cache-current-in-a-local.patch
mm-batch-activate_page-to-reduce-lock-contention-checkpatch-fixes.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch

