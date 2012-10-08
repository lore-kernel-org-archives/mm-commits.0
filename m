From: akpm@linux-foundation.org
Subject: [folded-dropped] mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch removed from -mm tree
Date: Mon, 08 Oct 2012 15:59:01 -0700
Message-ID: <20121008225901.D1916100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:63714 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab2JHW7E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Oct 2012 18:59:04 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so537625qcq.1
        for <mm-commits@vger.kernel.org>; Mon, 08 Oct 2012 15:59:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@intel.com, hannes@cmpxchg.org, kosaki.motohiro@gmail.com, minchan@kernel.org, sanbai@taobao.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch

This patch was dropped because it was folded into mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix

grab better comment from the v3 patch

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Robin Dong <sanbai@taobao.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN mm/swap.c~mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix mm/swap.c
--- a/mm/swap.c~mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix
+++ a/mm/swap.c
@@ -447,8 +447,12 @@ void mark_page_accessed(struct page *pag
 EXPORT_SYMBOL(mark_page_accessed);
 
 /*
- * Check the pagevec space before adding a new page into it, to prevent
- * nonuniform page status in mark_page_accessed() after __lru_cache_add().
+ * Order of operations is important: flush the pagevec when it's already
+ * full, not when adding the last page, to make sure that last page is
+ * not added to the LRU directly when passed to this function. Because
+ * mark_page_accessed() (called after this when writing) only activates
+ * pages that are on the LRU, linear writes in subpage chunks would see
+ * every PAGEVEC_SIZE page activated, which is unexpected.
  */
 void __lru_cache_add(struct page *page, enum lru_list lru)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch
rbtree-performance-and-correctness-test-fix.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix-fix.patch
mm-fix-tracing-in-free_pcppages_bulk-fix.patch
cma-count-free-cma-pages-fix.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix.patch
atomic-implement-generic-atomic_dec_if_positive-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix-2.patch
mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible-fix-fix.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes.patch
mm-fix-invalidate_complete_page2-lock-ordering.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock.patch
cma-migrate-mlocked-pages-fix.patch
mm-avoid-section-mismatch-warning-for-memblock_type_name-fix.patch
mm-document-pagehuge-somewhat.patch
mm-memcg-clean-up-mm_match_cgroup-signature-fix.patch
memory-hotplug-suppress-trying-to-free-nonexistent-resource-xxxxxxxxxxxxxxxx-yyyyyyyyyyyyyyyy-warning.patch
mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code-fix.patch

