From: akpm@linux-foundation.org
Subject: [merged] mm-avoid-endless-looping-for-oom-killed-tasks.patch removed from -mm tree
Date: Thu, 30 Jul 2009 13:34:54 -0700
Message-ID: <200907302034.n6UKYsRO007205@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39193 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751709AbZG3UfX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 16:35:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, hugh.dickins@tiscali.co.uk, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     mm: avoid endless looping for oom killed tasks
has been removed from the -mm tree.  Its filename was
     mm-avoid-endless-looping-for-oom-killed-tasks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: avoid endless looping for oom killed tasks
From: David Rientjes <rientjes@google.com>

If a task is oom killed and still cannot find memory when trying with
no watermarks, it's better to fail the allocation attempt than to loop
endlessly.  Direct reclaim has already failed and the oom killer will
be a no-op since current has yet to die, so there is no other
alternative for allocations that are not __GFP_NOFAIL.

Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/page_alloc.c~mm-avoid-endless-looping-for-oom-killed-tasks mm/page_alloc.c
--- a/mm/page_alloc.c~mm-avoid-endless-looping-for-oom-killed-tasks
+++ a/mm/page_alloc.c
@@ -1794,6 +1794,10 @@ rebalance:
 	if (p->flags & PF_MEMALLOC)
 		goto nopage;
 
+	/* Avoid allocations with no watermarks from looping endlessly */
+	if (test_thread_flag(TIF_MEMDIE) && !(gfp_mask & __GFP_NOFAIL))
+		goto nopage;
+
 	/* Try direct reclaim and then allocating */
 	page = __alloc_pages_direct_reclaim(gfp_mask, order,
 					zonelist, high_zoneidx,
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
mm-make-set_mempolicympol_interleav-n_high_memory-aware.patch
mm-make-set_mempolicympol_interleav-n_high_memory-aware-fix.patch
mm-remove-obsoleted-alloc_pages-cpuset-comment.patch
hugetlb-balance-freeing-of-huge-pages-across-nodes.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages-fix.patch
hugetlb-clean-up-and-update-huge-pages-documentation.patch
mm-oom-analysis-add-per-zone-statistics-to-show_free_areas.patch
mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch
mm-oom-analysis-show-kernel-stack-usage-in-proc-meminfo-and-oom-log-output.patch
mm-oom-analysis-add-shmem-vmstat.patch
mm-update-alloc_flags-after-oom-killer-has-been-called.patch
pagemap-clear_refs-modify-to-specify-anon-or-mapped-vma-clearing.patch
mm-introduce-proc-pid-oom_adj_child.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch

