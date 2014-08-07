From: akpm@linux-foundation.org
Subject: [merged]
 mm-thp-restructure-thp-avoidance-of-light-synchronous-migration.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:06:19 -0700
Message-ID: <53e3dc3b.cEloVc2VwlSIlTv+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f202.google.com ([209.85.213.202]:46885 "EHLO
	mail-ig0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbaHGUGU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:06:20 -0400
Received: by mail-ig0-f202.google.com with SMTP id r2so880062igi.5
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:06:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, hannes@cmpxchg.org, mgorman@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, thp: restructure thp avoidance of light synchronous migration
has been removed from the -mm tree.  Its filename was
     mm-thp-restructure-thp-avoidance-of-light-synchronous-migration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, thp: restructure thp avoidance of light synchronous migration

__GFP_NO_KSWAPD, once the way to determine if an allocation was for thp or not,
has gained more users.  Their use is not necessarily wrong, they are trying to
do a memory allocation that can easily fail without disturbing kswapd, so the
bit has gained additional usecases.

This restructures the check to determine whether MIGRATE_SYNC_LIGHT should be
used for memory compaction in the page allocator.  Rather than testing solely
for __GFP_NO_KSWAPD, test for all bits that must be set for thp allocations.

This also moves the check to be done only after the page allocator is aborted
for deferred or contended memory compaction since setting migration_mode for
this case is pointless.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN mm/page_alloc.c~mm-thp-restructure-thp-avoidance-of-light-synchronous-migration mm/page_alloc.c
--- a/mm/page_alloc.c~mm-thp-restructure-thp-avoidance-of-light-synchronous-migration
+++ a/mm/page_alloc.c
@@ -2639,14 +2639,6 @@ rebalance:
 		goto got_pg;
 
 	/*
-	 * It can become very expensive to allocate transparent hugepages at
-	 * fault, so use asynchronous memory compaction for THP unless it is
-	 * khugepaged trying to collapse.
-	 */
-	if (!(gfp_mask & __GFP_NO_KSWAPD) || (current->flags & PF_KTHREAD))
-		migration_mode = MIGRATE_SYNC_LIGHT;
-
-	/*
 	 * If compaction is deferred for high-order allocations, it is because
 	 * sync compaction recently failed. In this is the case and the caller
 	 * requested a movable allocation that does not heavily disrupt the
@@ -2656,6 +2648,15 @@ rebalance:
 						(gfp_mask & __GFP_NO_KSWAPD))
 		goto nopage;
 
+	/*
+	 * It can become very expensive to allocate transparent hugepages at
+	 * fault, so use asynchronous memory compaction for THP unless it is
+	 * khugepaged trying to collapse.
+	 */
+	if ((gfp_mask & GFP_TRANSHUGE) != GFP_TRANSHUGE ||
+						(current->flags & PF_KTHREAD))
+		migration_mode = MIGRATE_SYNC_LIGHT;
+
 	/* Try direct reclaim and then allocating */
 	page = __alloc_pages_direct_reclaim(gfp_mask, order,
 					zonelist, high_zoneidx,
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function-v2.patch
mm-hugetlb-take-refcount-under-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-use-get_page_unless_zero-in-hugetlb_fault.patch
mm-hugetlb-add-migration-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud.patch
include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max.patch
mm-utilc-add-kstrimdup.patch
fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
fork-exec-cleanup-mm-initialization.patch
fork-reset-mm-pinned_vm.patch
fork-copy-mms-vm-usage-counters-under-mmap_sem.patch
linux-next.patch

