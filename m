From: akpm@linux-foundation.org
Subject: [folded] writeback-avoid-unnecessary-determine_dirtyable_memory-call-fix.patch removed from -mm tree
Date: Thu, 13 Jan 2011 15:29:36 -0800
Message-ID: <201101132329.p0DNTaVl007111@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56520 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757142Ab1AMX3t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 18:29:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, fengguang.wu@intel.com, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     writeback-avoid-unnecessary-determine_dirtyable_memory-call-fix
has been removed from the -mm tree.  Its filename was
     writeback-avoid-unnecessary-determine_dirtyable_memory-call-fix.patch

This patch was dropped because it was folded into writeback-avoid-unnecessary-determine_dirtyable_memory-call.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: writeback-avoid-unnecessary-determine_dirtyable_memory-call-fix
From: Andrew Morton <akpm@linux-foundation.org>

mm/page-writeback.c: In function 'global_dirty_limits':
mm/page-writeback.c:393: warning: 'available_memory' may be used uninitialized in this function

older gcc isn't smart enough.

Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page-writeback.c~writeback-avoid-unnecessary-determine_dirtyable_memory-call-fix mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-avoid-unnecessary-determine_dirtyable_memory-call-fix
+++ a/mm/page-writeback.c
@@ -390,7 +390,7 @@ void global_dirty_limits(unsigned long *
 {
 	unsigned long background;
 	unsigned long dirty;
-	unsigned long available_memory;
+	unsigned long uninitialized_var(available_memory);
 	struct task_struct *tsk;
 
 	if (!vm_dirty_bytes || !dirty_background_bytes)
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

