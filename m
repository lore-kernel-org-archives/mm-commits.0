From: akpm@osdl.org
Subject: - __unmap_hugepage_range-add-comment.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:55:58 -0800
Message-ID: <200612072255.kB7Mtwg6029156@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50253 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163573AbWLGW4L (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:56:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kenneth.w.chen@intel.com, david@gibson.dropbear.id.au, hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     __unmap_hugepage_range(): add comment
has been removed from the -mm tree.  Its filename was
     __unmap_hugepage_range-add-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: __unmap_hugepage_range(): add comment
From: "Chen, Kenneth W" <kenneth.w.chen@intel.com>

Signed-off-by: Ken Chen <kenneth.w.chen@intel.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/hugetlb.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/hugetlb.c~__unmap_hugepage_range-add-comment mm/hugetlb.c
--- a/mm/hugetlb.c~__unmap_hugepage_range-add-comment
+++ a/mm/hugetlb.c
@@ -365,6 +365,11 @@ void __unmap_hugepage_range(struct vm_ar
 	pte_t pte;
 	struct page *page;
 	struct page *tmp;
+	/*
+	 * A page gathering list, protected by per file i_mmap_lock. The
+	 * lock is used to avoid list corruption from multiple unmapping
+	 * of the same page since we are using page->lru.
+	 */
 	LIST_HEAD(page_list);
 
 	WARN_ON(!is_vm_hugetlb_page(vma));
_

Patches currently in -mm which might be from kenneth.w.chen@intel.com are

origin.patch
optimize-o_direct-on-block-device-v3.patch
optimize-o_direct-on-block-device-v3-tweak.patch
sched-avoid-taking-rq-lock-in-wake_priority_sleeper.patch
sched-remove-staggering-of-load-balancing.patch
sched-disable-interrupts-for-locking-in-load_balance.patch
sched-extract-load-calculation-from-rebalance_tick.patch
sched-move-idle-status-calculation-into-rebalance_tick.patch
sched-use-softirq-for-load-balancing.patch
sched-call-tasklet-less-frequently.patch
sched-add-option-to-serialize-load-balancing.patch
sched-add-option-to-serialize-load-balancing-fix.patch
sched-improve-migration-accuracy.patch
sched-improve-migration-accuracy-tidy.patch
sched-remove-lb_stopbalance-counter.patch
sched-optimize-activate_task-for-rt-task.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch

