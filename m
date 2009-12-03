From: akpm@linux-foundation.org
Subject: + hugetlb-abort-a-hugepage-pool-resize-if-a-signal-is-pending.patch added to -mm tree
Date: Thu, 03 Dec 2009 14:09:11 -0800
Message-ID: <200912032209.nB3M9Bqs013886@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43732 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751605AbZLCWKB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Dec 2009 17:10:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, dave@linux.vnet.ibm.com


The patch titled
     hugetlb: abort a hugepage pool resize if a signal is pending
has been added to the -mm tree.  Its filename is
     hugetlb-abort-a-hugepage-pool-resize-if-a-signal-is-pending.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: abort a hugepage pool resize if a signal is pending
From: Mel Gorman <mel@csn.ul.ie>

If a user asks for a hugepage pool resize but specified a large number,
the machine can begin trashing.  In response, they might hit ctrl-c but
signals are ignored and the pool resize continues until it fails an
allocation.  This can take a considerable amount of time so this patch
aborts a pool resize if a signal is pending.

Suggested by Dave Hansen.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/hugetlb.c~hugetlb-abort-a-hugepage-pool-resize-if-a-signal-is-pending mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-abort-a-hugepage-pool-resize-if-a-signal-is-pending
+++ a/mm/hugetlb.c
@@ -1278,6 +1278,9 @@ static unsigned long set_max_huge_pages(
 		if (!ret)
 			goto out;
 
+		/* Bail for signals. Probably ctrl-c from user */
+		if (signal_pending(current))
+			goto out;
 	}
 
 	/*
_

Patches currently in -mm which might be from mel@csn.ul.ie are

linux-next.patch
mm-add-notifier-in-pageblock-isolation-for-balloon-drivers.patch
powerpc-make-the-cmm-memory-hotplug-aware.patch
powerpc-make-the-cmm-memory-hotplug-aware-update.patch
mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set.patch
nodemask-make-nodemask_alloc-more-general.patch
hugetlb-rework-hstate_next_node_-functions.patch
hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions.patch
hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions-fix.patch
hugetlb-factor-init_nodemask_of_node.patch
hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy.patch
hugetlb-add-generic-definition-of-numa_no_node.patch
hugetlb-add-per-node-hstate-attributes.patch
hugetlb-update-hugetlb-documentation-for-numa-controls.patch
hugetlb-use-only-nodes-with-memory-for-huge-pages.patch
mm-clear-node-in-n_high_memory-and-stop-kswapd-when-all-memory-is-offlined.patch
hugetlb-handle-memory-hot-plug-events.patch
hugetlb-offload-per-node-attribute-registrations.patch
mm-add-gfp-flags-for-nodemask_alloc-slab-allocations.patch
page-allocator-wait-on-both-sync-and-async-congestion-after-direct-reclaim.patch
vmscan-have-kswapd-sleep-for-a-short-interval-and-double-check-it-should-be-asleep.patch
vmscan-stop-kswapd-waiting-on-congestion-when-the-min-watermark-is-not-being-met-v2.patch
vmscan-have-kswapd-sleep-for-a-short-interval-and-double-check-it-should-be-asleep-fix-1.patch
vmscan-separate-scswap_cluster_max-and-scnr_max_reclaim.patch
vmscan-kill-hibernation-specific-reclaim-logic-and-unify-it.patch
vmscan-zone_reclaim-dont-use-insane-swap_cluster_max.patch
vmscan-kill-scswap_cluster_max.patch
vmscan-make-consistent-of-reclaim-bale-out-between-do_try_to_free_page-and-shrink_zone.patch
ksm-fix-mlockfreed-to-munlocked.patch
hugetlb-prevent-deadlock-in-__unmap_hugepage_range-when-alloc_huge_page-fails-2.patch
hugetlb-acquire-the-i_mmap_lock-before-walking-the-prio_tree-to-unmap-a-page-v2.patch
hugetlb-abort-a-hugepage-pool-resize-if-a-signal-is-pending.patch
add-debugging-aid-for-memory-initialisation-problems.patch

