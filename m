From: akpm@linux-foundation.org
Subject: + mm-revert-0def08e3-mm-mempolicyc-check-return-code-of-check_range-fix.patch added to -mm tree
Date: Thu, 20 Sep 2012 16:28:49 -0700
Message-ID: <20120920232850.58F97100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:35859 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932468Ab2ITX2w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Sep 2012 19:28:52 -0400
Received: by vcbfy27 with SMTP id fy27so378377vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 20 Sep 2012 16:28:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan@kernel.org, cl@linux.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, rientjes@google.com, segooon@gmail.com


The patch titled
     Subject: mm: enhance comment and bug check
has been added to the -mm tree.  Its filename is
     mm-revert-0def08e3-mm-mempolicyc-check-return-code-of-check_range-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -951,9 +951,11 @@ static int migrate_to_node(struct mm_str
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
linux-next.patch
mm-remove-__gfp_no_kswapd.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
mm-compaction-update-comment-in-try_to_compact_pages.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix.patch
mm-compaction-capture-a-suitable-high-order-page-immediately-when-it-is-made-available.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix-fix.patch
mm-fix-tracing-in-free_pcppages_bulk.patch
mm-fix-tracing-in-free_pcppages_bulk-fix.patch
cma-fix-counting-of-isolated-pages.patch
cma-count-free-cma-pages.patch
cma-count-free-cma-pages-fix.patch
cma-fix-watermark-checking.patch
mm-page_alloc-use-get_freepage_migratetype-instead-of-page_private.patch
mm-remain-migratetype-in-freed-page.patch
memory-hotplug-bug-fix-race-between-isolation-and-allocation.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failing.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-memblock-reduce-overhead-in-binary-search.patch
mm-memblock-use-existing-interface-to-set-nid.patch
mm-memblock-cleanup-early_node_map-related-comments.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix-2.patch
mm-compaction-check-lock-contention-first-before-taking-lock.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes.patch
memory-hotplug-dont-replace-lowmem-pages-with-highmem.patch
mm-compaction-move-fatal-signal-check-out-of-compact_checklock_irqsave.patch
mm-enable-config_compaction-by-default.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix.patch
mm-revert-0def08e3-mm-mempolicyc-check-return-code-of-check_range.patch
mm-revert-0def08e3-mm-mempolicyc-check-return-code-of-check_range-fix.patch
trace-events-kmem-dont-call-page_to_pfn-if-page-is-null.patch
memory-hotplug-fix-zone-stat-mismatch.patch

