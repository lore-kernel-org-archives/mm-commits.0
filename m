From: akpm@linux-foundation.org
Subject: + mm-compaction-move-fatal-signal-check-out-of-compact_checklock_irqsave.patch added to -mm tree
Date: Wed, 12 Sep 2012 15:00:56 -0700
Message-ID: <20120912220058.2E152100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:55624 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab2ILWBA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Sep 2012 18:01:00 -0400
Received: by yhl10 with SMTP id 10so250252yhl.1
        for <mm-commits@vger.kernel.org>; Wed, 12 Sep 2012 15:00:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, aarcange@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, minchan@kernel.org, riel@redhat.com, shli@kernel.org


The patch titled
     Subject: mm: compaction: move fatal signal check out of compact_checklock_irqsave
has been added to the -mm tree.  Its filename is
     mm-compaction-move-fatal-signal-check-out-of-compact_checklock_irqsave.patch

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
Subject: mm: compaction: move fatal signal check out of compact_checklock_irqsave

c67fe3752 ("mm: compaction: Abort async compaction if locks are contended
or taking too long") addressed a lock contention problem in compaction by
introducing compact_checklock_irqsave() that effecively aborting async
compaction in the event of compaction.

To preserve existing behaviour it also moved a fatal_signal_pending()
check into compact_checklock_irqsave() but that is very misleading.  It
"hides" the check within a locking function but has nothing to do with
locking as such.  It just happens to work in a desirable fashion.

This patch moves the fatal_signal_pending() check to
isolate_migratepages_range() where it belongs.  Arguably the same check
should also happen when isolating pages for freeing but it's overkill.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/compaction.c~mm-compaction-move-fatal-signal-check-out-of-compact_checklock_irqsave mm/compaction.c
--- a/mm/compaction.c~mm-compaction-move-fatal-signal-check-out-of-compact_checklock_irqsave
+++ a/mm/compaction.c
@@ -75,8 +75,6 @@ static bool compact_checklock_irqsave(sp
 		}
 
 		cond_resched();
-		if (fatal_signal_pending(current))
-			return false;
 	}
 
 	if (!locked)
@@ -364,7 +362,7 @@ isolate_migratepages_range(struct zone *
 		/* Check if it is ok to still hold the lock */
 		locked = compact_checklock_irqsave(&zone->lru_lock, &flags,
 								locked, cc);
-		if (!locked)
+		if (!locked || fatal_signal_pending(current))
 			break;
 
 		/*
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
mm-page_alloc-use-get_freepage_migratetype-instead-of-page_private.patch
mm-remain-migratetype-in-freed-page.patch
memory-hotplug-bug-fix-race-between-isolation-and-allocation.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failing.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch
mm-compaction-check-lock-contention-first-before-taking-lock.patch
mm-compaction-move-fatal-signal-check-out-of-compact_checklock_irqsave.patch

