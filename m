From: akpm@linux-foundation.org
Subject: [folded] mm-page_allocc-simplify-calculation-of-combined-index-of-adjacent-buddy-lists-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 13 Jan 2011 15:36:21 -0800
Message-ID: <201101132336.p0DNaLHg007414@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50144 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757169Ab1AMXgZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 18:36:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, pullip.cho@samsung.com, mm-commits@vger.kernel.org


The patch titled
     mm-page_allocc-simplify-calculation-of-combined-index-of-adjacent-buddy-lists-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-simplify-calculation-of-combined-index-of-adjacent-buddy-lists-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-page_allocc-simplify-calculation-of-combined-index-of-adjacent-buddy-lists.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-page_allocc-simplify-calculation-of-combined-index-of-adjacent-buddy-lists-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: return is not a function, parentheses are not required
#40: FILE: mm/page_alloc.c:433:
+	return (page_idx ^ (1 << order));

total: 1 errors, 0 warnings, 57 lines checked

./patches/mm-page_allocc-simplify-calculation-of-combined-index-of-adjacent-buddy-lists.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: KyongHo Cho <pullip.cho@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_allocc-simplify-calculation-of-combined-index-of-adjacent-buddy-lists-checkpatch-fixes mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-simplify-calculation-of-combined-index-of-adjacent-buddy-lists-checkpatch-fixes
+++ a/mm/page_alloc.c
@@ -430,7 +430,7 @@ static inline void rmv_page_order(struct
 static inline unsigned long
 __find_buddy_index(unsigned long page_idx, unsigned int order)
 {
-	return (page_idx ^ (1 << order));
+	return page_idx ^ (1 << order);
 }
 
 /*
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
mm-page_allocc-simplify-calculation-of-combined-index-of-adjacent-buddy-lists-fix.patch
mm-dmapoolc-use-task_uninterruptible-in-dma_pool_alloc.patch
hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler-fix.patch
hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment-fix.patch
mm-fix-migration-hangs-on-anon_vma-lock-checkpatch-fixes.patch
mm-page_allocc-dont-cache-current-in-a-local.patch
mm-batch-activate_page-to-reduce-lock-contention-checkpatch-fixes.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch

