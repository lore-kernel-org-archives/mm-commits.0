From: akpm@linux-foundation.org
Subject: [folded] mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch removed from -mm tree
Date: Thu, 13 Jan 2011 15:23:10 -0800
Message-ID: <201101132323.p0DNNAR6006769@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49139 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752480Ab1AMXXi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 18:23:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix
has been removed from the -mm tree.  Its filename was
     mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch

This patch was dropped because it was folded into mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix
From: Andrew Morton <akpm@linux-foundation.org>

readability tweak

Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmstat.c~mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix mm/vmstat.c
--- a/mm/vmstat.c~mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix
+++ a/mm/vmstat.c
@@ -199,7 +199,7 @@ void set_pgdat_percpu_threshold(pg_data_
 		if (!zone->percpu_drift_mark)
 			continue;
 
-		threshold = calculate_pressure(zone);
+		threshold = (*calculate_pressure)(zone);
 		for_each_online_cpu(cpu)
 			per_cpu_ptr(zone->pageset, cpu)->stat_threshold
 							= threshold;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds.patch
sync_inode_metadata-fix-comment.patch
fs-mpagec-consolidate-code-checkpatch-fixes.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-avoid-a-potential-deadlock-due-to-lock_page-during-direct-compaction-fix.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path-fix.patch
mlock-only-hold-mmap_sem-in-shared-mode-when-faulting-in-pages-fix.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix.patch
writeback-avoid-unnecessary-determine_dirtyable_memory-call-fix.patch
thp-pte-alloc-trans-splitting-fix-checkpatch-fixes.patch
thp-kvm-mmu-transparent-hugepage-support-bisection.patch
thp-khugepaged-make-khugepaged-aware-of-madvise-fix.patch
mm-migration-use-rcu_dereference_protected-when-dereferencing-the-radix-tree-slot-during-file-page-migration-fix.patch
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

