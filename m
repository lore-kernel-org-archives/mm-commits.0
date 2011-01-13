From: akpm@linux-foundation.org
Subject: [folded] thp-kvm-mmu-transparent-hugepage-support-bisection.patch removed from -mm tree
Date: Thu, 13 Jan 2011 15:31:32 -0800
Message-ID: <201101132331.p0DNVWsv007210@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35856 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757142Ab1AMXbh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 18:31:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, avi@redhat.com, mtosatti@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp-kvm-mmu-transparent-hugepage-support-bisection
has been removed from the -mm tree.  Its filename was
     thp-kvm-mmu-transparent-hugepage-support-bisection.patch

This patch was dropped because it was folded into thp-kvm-mmu-transparent-hugepage-support.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp-kvm-mmu-transparent-hugepage-support-bisection
From: Andrew Morton <akpm@linux-foundation.org>

thp-kvm-mmu-transparent-hugepage-support.patch needs PageTransCompound().

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN include/linux/page-flags.h~thp-kvm-mmu-transparent-hugepage-support-bisection include/linux/page-flags.h
--- a/include/linux/page-flags.h~thp-kvm-mmu-transparent-hugepage-support-bisection
+++ a/include/linux/page-flags.h
@@ -409,6 +409,18 @@ static inline void ClearPageCompound(str
 
 #endif /* !PAGEFLAGS_EXTENDED */
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static inline int PageTransCompound(struct page *page)
+{
+	return PageCompound(page);
+}
+#else
+static inline int PageTransCompound(struct page *page)
+{
+	return 0;
+}
+#endif
+
 #ifdef CONFIG_MMU
 #define __PG_MLOCKED		(1 << PG_mlocked)
 #else
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

