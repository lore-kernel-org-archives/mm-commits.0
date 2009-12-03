From: akpm@linux-foundation.org
Subject: + hugetlb-acquire-the-i_mmap_lock-before-walking-the-prio_tree-to-unmap-a-page-v2.patch added to -mm tree
Date: Wed, 02 Dec 2009 17:04:25 -0800
Message-ID: <200912030104.nB314PQS016800@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41021 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752854AbZLCBEx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2009 20:04:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, hugh.dickins@tiscali.co.uk


The patch titled
     hugetlb: acquire the i_mmap_lock before walking the prio_tree to unmap a page
has been added to the -mm tree.  Its filename is
     hugetlb-acquire-the-i_mmap_lock-before-walking-the-prio_tree-to-unmap-a-page-v2.patch

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
Subject: hugetlb: acquire the i_mmap_lock before walking the prio_tree to unmap a page
From: Mel Gorman <mel@csn.ul.ie>

When the owner of a mapping fails COW because a child process is holding a
reference, the children VMAs are walked and the page is unmapped.  The
i_mmap_lock is taken for the unmapping of the page but not the walking of
the prio_tree.  In theory, that tree could be changing if the lock is not
held.  This patch takes the i_mmap_lock properly for the duration of the
prio_tree walk.

[hugh.dickins@tiscali.co.uk: Spotted the problem in the first place]
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN mm/hugetlb.c~hugetlb-acquire-the-i_mmap_lock-before-walking-the-prio_tree-to-unmap-a-page-v2 mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-acquire-the-i_mmap_lock-before-walking-the-prio_tree-to-unmap-a-page-v2
+++ a/mm/hugetlb.c
@@ -2237,6 +2237,12 @@ static int unmap_ref_private(struct mm_s
 		+ (vma->vm_pgoff >> PAGE_SHIFT);
 	mapping = (struct address_space *)page_private(page);
 
+	/*
+	 * Take the mapping lock for the duration of the table walk. As
+	 * this mapping should be shared between all the VMAs,
+	 * __unmap_hugepage_range() is called as the lock is already held
+	 */
+	spin_lock(&mapping->i_mmap_lock);
 	vma_prio_tree_foreach(iter_vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
 		/* Do not unmap the current VMA */
 		if (iter_vma == vma)
@@ -2250,10 +2256,11 @@ static int unmap_ref_private(struct mm_s
 		 * from the time of fork. This would look like data corruption
 		 */
 		if (!is_vma_resv_set(iter_vma, HPAGE_RESV_OWNER))
-			unmap_hugepage_range(iter_vma,
+			__unmap_hugepage_range(iter_vma,
 				address, address + huge_page_size(h),
 				page);
 	}
+	spin_unlock(&mapping->i_mmap_lock);
 
 	return 1;
 }
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
add-debugging-aid-for-memory-initialisation-problems.patch

