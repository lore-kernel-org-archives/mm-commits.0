From: akpm@linux-foundation.org
Subject: [folded] mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common-fix.patch removed from -mm tree
Date: Thu, 13 Jan 2011 15:35:23 -0800
Message-ID: <201101132335.p0DNZNCD007371@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51428 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757169Ab1AMXf2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 18:35:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jj@chaosbits.net, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common-fix.patch

This patch was dropped because it was folded into mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common-fix
From: Andrew Morton <akpm@linux-foundation.org>

use NODEMASK_FREE, per Minchan Kim

Cc: Jesper Juhl <jj@chaosbits.net>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb.c~mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common-fix mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common-fix
+++ a/mm/hugetlb.c
@@ -1375,7 +1375,7 @@ static ssize_t nr_hugepages_store_common
 
 	err = strict_strtoul(buf, 10, &count);
 	if (err) {
-		kfree(nodes_allowed);
+		NODEMASK_FREE(nodes_allowed);
 		return 0;
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
mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common.patch
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

