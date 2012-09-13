From: akpm@linux-foundation.org
Subject: + mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix-2.patch added to -mm tree
Date: Thu, 13 Sep 2012 13:55:26 -0700
Message-ID: <20120913205527.9EA6320004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:55284 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758798Ab2IMUza (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Sep 2012 16:55:30 -0400
Received: by weyr1 with SMTP id r1so216574wey.1
        for <mm-commits@vger.kernel.org>; Thu, 13 Sep 2012 13:55:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, aarcange@redhat.com, shli@fusionio.com


The patch titled
     Subject: mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix-2
has been added to the -mm tree.  Its filename is
     mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix-2

o Fix BUG_ON triggered due to pages left on cc.migratepages
o Make compact_zone_order() require non-NULL arg `contended'

[minchan@kernel.org: Putback pages isolated for migration if aborting]
[akpm@linux-foundation.org: compact_zone_order requires non-NULL arg contended]
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Shaohua Li <shli@fusionio.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/compaction.c~mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix-2 mm/compaction.c
--- a/mm/compaction.c~mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix-2
+++ a/mm/compaction.c
@@ -847,6 +847,8 @@ static int compact_zone(struct zone *zon
 		switch (isolate_migratepages(zone, cc)) {
 		case ISOLATE_ABORT:
 			ret = COMPACT_PARTIAL;
+			putback_lru_pages(&cc->migratepages);
+			cc->nr_migratepages = 0;
 			goto out;
 		case ISOLATE_NONE:
 			continue;
@@ -909,6 +911,10 @@ static unsigned long compact_zone_order(
 	INIT_LIST_HEAD(&cc.migratepages);
 
 	ret = compact_zone(zone, &cc);
+
+	VM_BUG_ON(!list_empty(&cc.freepages));
+	VM_BUG_ON(!list_empty(&cc.migratepages));
+
 	*contended = cc.contended;
 	return ret;
 }
_

Patches currently in -mm which might be from mgorman@suse.de are

slab-do-clearslabpfmemalloc-for-all-pages-of-slab.patch
slab-fix-starting-index-for-finding-another-object.patch
slub-consider-pfmemalloc_match-in-get_partial_node.patch
include-net-sockh-squelch-compiler-warning-in-sk_rmem_schedule.patch
mm-remove-__gfp_no_kswapd.patch
mm-compaction-update-comment-in-try_to_compact_pages.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix.patch
mm-compaction-capture-a-suitable-high-order-page-immediately-when-it-is-made-available.patch
revert-mm-mempolicy-let-vma_merge-and-vma_split-handle-vma-vm_policy-linkages.patch
mempolicy-remove-mempolicy-sharing.patch
mempolicy-fix-a-race-in-shared_policy_replace.patch
mempolicy-fix-refcount-leak-in-mpol_set_shared_policy.patch
mempolicy-fix-a-memory-corruption-by-refcount-imbalance-in-alloc_pages_vma.patch
mempolicy-fix-a-memory-corruption-by-refcount-imbalance-in-alloc_pages_vma-v2.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix.patch
mm-page_alloc-use-get_freepage_migratetype-instead-of-page_private.patch
mm-remain-migratetype-in-freed-page.patch
memory-hotplug-bug-fix-race-between-isolation-and-allocation.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failing.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix-2.patch
mm-compaction-check-lock-contention-first-before-taking-lock.patch
mm-compaction-move-fatal-signal-check-out-of-compact_checklock_irqsave.patch
mm-compaction-update-try_to_compact_pageskerneldoc-comment.patch

