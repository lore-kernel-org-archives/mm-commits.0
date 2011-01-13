From: akpm@linux-foundation.org
Subject: [folded] thp-pte-alloc-trans-splitting-fix-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 13 Jan 2011 15:31:08 -0800
Message-ID: <201101132331.p0DNV9Dw007184@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50613 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757320Ab1AMXbU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 18:31:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp-pte-alloc-trans-splitting-fix-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     thp-pte-alloc-trans-splitting-fix-checkpatch-fixes.patch

This patch was dropped because it was folded into thp-pte-alloc-trans-splitting.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp-pte-alloc-trans-splitting-fix-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: "foo * bar" should be "foo *bar"
#64: FILE: arch/sparc/mm/generic_32.c:53:
+		pte_t * pte = pte_alloc_map(mm, NULL, pmd, address);

ERROR: "foo * bar" should be "foo *bar"
#76: FILE: arch/sparc/mm/generic_64.c:95:
+		pte_t * pte = pte_alloc_map(mm, NULL, pmd, address);

total: 2 errors, 0 warnings, 56 lines checked

./patches/thp-pte-alloc-trans-splitting-fix.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/mm/generic_32.c |    2 +-
 arch/sparc/mm/generic_64.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/sparc/mm/generic_32.c~thp-pte-alloc-trans-splitting-fix-checkpatch-fixes arch/sparc/mm/generic_32.c
--- a/arch/sparc/mm/generic_32.c~thp-pte-alloc-trans-splitting-fix-checkpatch-fixes
+++ a/arch/sparc/mm/generic_32.c
@@ -50,7 +50,7 @@ static inline int io_remap_pmd_range(str
 		end = PGDIR_SIZE;
 	offset -= address;
 	do {
-		pte_t * pte = pte_alloc_map(mm, NULL, pmd, address);
+		pte_t *pte = pte_alloc_map(mm, NULL, pmd, address);
 		if (!pte)
 			return -ENOMEM;
 		io_remap_pte_range(mm, pte, address, end - address, address + offset, prot, space);
diff -puN arch/sparc/mm/generic_64.c~thp-pte-alloc-trans-splitting-fix-checkpatch-fixes arch/sparc/mm/generic_64.c
--- a/arch/sparc/mm/generic_64.c~thp-pte-alloc-trans-splitting-fix-checkpatch-fixes
+++ a/arch/sparc/mm/generic_64.c
@@ -92,7 +92,7 @@ static inline int io_remap_pmd_range(str
 		end = PGDIR_SIZE;
 	offset -= address;
 	do {
-		pte_t * pte = pte_alloc_map(mm, NULL, pmd, address);
+		pte_t *pte = pte_alloc_map(mm, NULL, pmd, address);
 		if (!pte)
 			return -ENOMEM;
 		io_remap_pte_range(mm, pte, address, end - address, address + offset, prot, space);
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

