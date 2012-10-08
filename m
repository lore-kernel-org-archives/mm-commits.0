From: akpm@linux-foundation.org
Subject: [folded-dropped] mm-revert-0def08e3-mm-mempolicyc-check-return-code-of-check_range-fix.patch removed from -mm tree
Date: Mon, 08 Oct 2012 16:16:13 -0700
Message-ID: <20121008231614.32E3E5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:63069 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab2JHXQR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Oct 2012 19:16:17 -0400
Received: by mail-ee0-f74.google.com with SMTP id b57so293932eek.1
        for <mm-commits@vger.kernel.org>; Mon, 08 Oct 2012 16:16:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, cl@linux.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, rientjes@google.com, segooon@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: enhance comment and bug check
has been removed from the -mm tree.  Its filename was
     mm-revert-0def08e3-mm-mempolicyc-check-return-code-of-check_range-fix.patch

This patch was dropped because it was folded into mm-revert-0def08e3-mm-mempolicyc-check-return-code-of-check_range.patch

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: enhance comment and bug check

This patch updates comment and bug check.
It can be fold into [1].

[1] mm-revert-0def08e3-mm-mempolicyc-check-return-code-of-check_range.patch

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Vasiliy Kulikov <segooon@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/mempolicy.c~mm-revert-0def08e3-mm-mempolicyc-check-return-code-of-check_range-fix mm/mempolicy.c
--- a/mm/mempolicy.c~mm-revert-0def08e3-mm-mempolicyc-check-return-code-of-check_range-fix
+++ a/mm/mempolicy.c
@@ -988,9 +988,11 @@ static int migrate_to_node(struct mm_str
 	node_set(source, nmask);
 
 	/*
-	 * Collect migrate pages and it shoudn't be failed.
+	 * This does not "check" the range but isolates all pages that
+	 * need migration.  Between passing in the full user address
+	 * space range and MPOL_MF_DISCONTIG_OK, this call can not fail.
 	 */
-	VM_BUG_ON(flags & MPOL_MF_STRICT);
+	VM_BUG_ON(!(flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)));
 	check_range(mm, mm->mmap->vm_start, mm->task_size, &nmask,
 			flags | MPOL_MF_DISCONTIG_OK, &pagelist);
 
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
mm-remove-__gfp_no_kswapd.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer.patch
mm-compaction-update-comment-in-try_to_compact_pages.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch
mm-compaction-capture-a-suitable-high-order-page-immediately-when-it-is-made-available.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration.patch
mm-fix-tracing-in-free_pcppages_bulk.patch
cma-fix-counting-of-isolated-pages.patch
cma-count-free-cma-pages.patch
cma-fix-watermark-checking.patch
mm-page_alloc-use-get_freepage_migratetype-instead-of-page_private.patch
mm-remain-migratetype-in-freed-page.patch
memory-hotplug-bug-fix-race-between-isolation-and-allocation.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failing.patch
mm-memblock-use-existing-interface-to-set-nid.patch
mm-memblock-cleanup-early_node_map-related-comments.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-move-fatal-signal-check-out-of-compact_checklock_irqsave.patch
mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible.patch
mm-compaction-acquire-the-zone-lock-as-late-as-possible.patch
revert-mm-have-order-0-compaction-start-off-where-it-left.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc.patch
memory-hotplug-dont-replace-lowmem-pages-with-highmem.patch
mm-enable-config_compaction-by-default.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance.patch
mm-revert-0def08e3-mm-mempolicyc-check-return-code-of-check_range.patch
memory-hotplug-fix-zone-stat-mismatch.patch
cma-migrate-mlocked-pages.patch
cma-migrate-mlocked-pages-fix.patch
cma-decrease-ccnr_migratepages-after-reclaiming-pagelist.patch

