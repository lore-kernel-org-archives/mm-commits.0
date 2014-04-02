From: akpm@linux-foundation.org
Subject: [merged]
 slub-fix-high-order-page-allocation-problem-with-__gfp_nofail.patch removed from -mm tree
Date: Wed, 02 Apr 2014 12:58:18 -0700
Message-ID: <533c6bda.9RzaV3IAsw62sjTG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49751 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932688AbaDBT6T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Apr 2014 15:58:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, rientjes@google.com, penberg@kernel.org, cl@linux.com, casteyde.christian@free.fr, iamjoonsoo.kim@lge.com

Subject: [merged] slub-fix-high-order-page-allocation-problem-with-__gfp_nofail.patch removed from -mm tree
To: iamjoonsoo.kim@lge.com,casteyde.christian@free.fr,cl@linux.com,penberg@kernel.org,rientjes@google.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 02 Apr 2014 12:58:18 -0700


The patch titled
     Subject: slub: fix high order page allocation problem with  __GFP_NOFAIL
has been removed from the -mm tree.  Its filename was
     slub-fix-high-order-page-allocation-problem-with-__gfp_nofail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: slub: fix high order page allocation problem with  __GFP_NOFAIL

SLUB already try to allocate high order page with clearing __GFP_NOFAIL. 
But, when allocating shadow page for kmemcheck, it missed clearing the
flag.  This trigger WARN_ON_ONCE() reported by Christian Casteyde.

https://bugzilla.kernel.org/show_bug.cgi?id=65991
https://lkml.org/lkml/2013/12/3/764

This patch fix this situation by using same allocation flag as original
allocation.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reported-by: Christian Casteyde <casteyde.christian@free.fr>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/slub.c~slub-fix-high-order-page-allocation-problem-with-__gfp_nofail mm/slub.c
--- a/mm/slub.c~slub-fix-high-order-page-allocation-problem-with-__gfp_nofail
+++ a/mm/slub.c
@@ -1348,11 +1348,12 @@ static struct page *allocate_slab(struct
 	page = alloc_slab_page(alloc_gfp, node, oo);
 	if (unlikely(!page)) {
 		oo = s->min;
+		alloc_gfp = flags;
 		/*
 		 * Allocation may have failed due to fragmentation.
 		 * Try a lower order alloc if possible
 		 */
-		page = alloc_slab_page(flags, node, oo);
+		page = alloc_slab_page(alloc_gfp, node, oo);
 
 		if (page)
 			stat(s, ORDER_FALLBACK);
@@ -1362,7 +1363,7 @@ static struct page *allocate_slab(struct
 		&& !(s->flags & (SLAB_NOTRACK | DEBUG_DEFAULT_FLAGS))) {
 		int pages = 1 << oo_order(oo);
 
-		kmemcheck_alloc_shadow(page, oo_order(oo), flags, node);
+		kmemcheck_alloc_shadow(page, oo_order(oo), alloc_gfp, node);
 
 		/*
 		 * Objects from caches that have a constructor don't get
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

kthread-ensure-locality-of-task_struct-allocations.patch
mm-hugetlb-unify-region-structure-handling.patch
mm-hugetlb-improve-cleanup-resv_map-parameters.patch
mm-hugetlb-fix-race-in-region-tracking.patch
mm-hugetlb-remove-resv_map_put.patch
mm-hugetlb-use-vma_resv_map-map-types.patch
mm-hugetlb-improve-page-fault-scalability.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-hugetlb-mark-some-bootstrap-functions-as-__init.patch
mm-compaction-avoid-isolating-pinned-pages.patch
mm-compaction-disallow-high-order-page-for-migration-target.patch
mm-compaction-do-not-call-suitable_migration_target-on-every-page.patch
mm-compaction-change-the-timing-to-check-to-drop-the-spinlock.patch
mm-compaction-check-pageblock-suitability-once-per-pageblock.patch
mm-compaction-clean-up-code-on-success-of-ballon-isolation.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-compaction-determine-isolation-mode-only-once.patch
mm-vmallocc-enhance-vm_map_ram-comment.patch
mm-vmallocc-enhance-vm_map_ram-comment-fix.patch
mm-try_to_unmap_cluster-should-lock_page-before-mlocking.patch
mm-hugetlb-fix-softlockup-when-a-large-number-of-hugepages-are-freed.patch
zram-support-req_discard.patch
zram-support-req_discard-v4.patch
zram-support-req_discard-v4-fix.patch
rtc-fixed-potential-race-condition.patch
rtc-fixed-potential-race-condition-checkpatch-fixes.patch
linux-next.patch
page-owners-correct-page-order-when-to-free-page.patch

