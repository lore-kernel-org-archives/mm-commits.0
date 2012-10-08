From: akpm@linux-foundation.org
Subject: [folded-dropped] mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 08 Oct 2012 16:14:29 -0700
Message-ID: <20121008231430.A474B5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:39420 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab2JHXOd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Oct 2012 19:14:33 -0400
Received: by mail-ea0-f202.google.com with SMTP id q10so36218eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 08 Oct 2012 16:14:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes

ERROR: code indent should use tabs where possible
#73: FILE: mm/page_isolation.c:253:
+                             int **resultp)$

WARNING: please, no spaces at the start of a line
#73: FILE: mm/page_isolation.c:253:
+                             int **resultp)$

ERROR: code indent should use tabs where possible
#75: FILE: mm/page_isolation.c:255:
+        gfp_t gfp_mask = GFP_USER | __GFP_MOVABLE;$

WARNING: please, no spaces at the start of a line
#75: FILE: mm/page_isolation.c:255:
+        gfp_t gfp_mask = GFP_USER | __GFP_MOVABLE;$

ERROR: code indent should use tabs where possible
#77: FILE: mm/page_isolation.c:257:
+        if (PageHighMem(page))$

WARNING: please, no spaces at the start of a line
#77: FILE: mm/page_isolation.c:257:
+        if (PageHighMem(page))$

ERROR: code indent should use tabs where possible
#78: FILE: mm/page_isolation.c:258:
+                gfp_mask |= __GFP_HIGHMEM;$

WARNING: please, no spaces at the start of a line
#78: FILE: mm/page_isolation.c:258:
+                gfp_mask |= __GFP_HIGHMEM;$

ERROR: code indent should use tabs where possible
#80: FILE: mm/page_isolation.c:260:
+        return alloc_page(gfp_mask);$

WARNING: please, no spaces at the start of a line
#80: FILE: mm/page_isolation.c:260:
+        return alloc_page(gfp_mask);$

total: 5 errors, 5 warnings, 48 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/page_isolation.c~mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes mm/page_isolation.c
--- a/mm/page_isolation.c~mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes
+++ a/mm/page_isolation.c
@@ -257,12 +257,12 @@ int test_pages_isolated(unsigned long st
 }
 
 struct page *alloc_migrate_target(struct page *page, unsigned long private,
-                             int **resultp)
+				  int **resultp)
 {
-        gfp_t gfp_mask = GFP_USER | __GFP_MOVABLE;
+	gfp_t gfp_mask = GFP_USER | __GFP_MOVABLE;
 
-        if (PageHighMem(page))
-                gfp_mask |= __GFP_HIGHMEM;
+	if (PageHighMem(page))
+		gfp_mask |= __GFP_HIGHMEM;
 
-        return alloc_page(gfp_mask);
+	return alloc_page(gfp_mask);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host.patch
rbtree-performance-and-correctness-test.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration.patch
mm-fix-tracing-in-free_pcppages_bulk.patch
cma-count-free-cma-pages.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failing.patch
atomic-implement-generic-atomic_dec_if_positive.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc.patch
mm-fix-invalidate_complete_page2-lock-ordering.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock.patch
cma-migrate-mlocked-pages-fix.patch
mm-avoid-section-mismatch-warning-for-memblock_type_name-fix.patch
mm-document-pagehuge-somewhat.patch
mm-memcg-clean-up-mm_match_cgroup-signature-fix.patch
memory-hotplug-suppress-trying-to-free-nonexistent-resource-xxxxxxxxxxxxxxxx-yyyyyyyyyyyyyyyy-warning.patch
mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code-fix.patch

