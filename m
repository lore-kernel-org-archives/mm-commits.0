From: akpm@linux-foundation.org
Subject: [folded-dropped] mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch removed from -mm tree
Date: Mon, 08 Oct 2012 16:10:31 -0700
Message-ID: <20121008231031.DC6A61E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:36025 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab2JHXKd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Oct 2012 19:10:33 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so539213vcb.1
        for <mm-commits@vger.kernel.org>; Mon, 08 Oct 2012 16:10:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, mgorman@suse.de, minchan@kernel.org, shli@fusionio.com, shli@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix
has been removed from the -mm tree.  Its filename was
     mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch

This patch was dropped because it was folded into mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix

make compact_zone_order() require non-NULL arg `contended'

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Shaohua Li <shli@fusionio.com>
Cc: Shaohua Li <shli@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/compaction.c~mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix mm/compaction.c
--- a/mm/compaction.c~mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix
+++ a/mm/compaction.c
@@ -909,8 +909,7 @@ static unsigned long compact_zone_order(
 	INIT_LIST_HEAD(&cc.migratepages);
 
 	ret = compact_zone(zone, &cc);
-	if (contended)
-		*contended = cc.contended;
+	*contended = cc.contended;
 	return ret;
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

