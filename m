From: akpm@linux-foundation.org
Subject: + mm-avoid-endless-looping-for-oom-killed-tasks.patch added to -mm tree
Date: Wed, 22 Jul 2009 16:37:11 -0700
Message-ID: <200907222337.n6MNbBUM007485@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55304 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754680AbZGVXh7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Jul 2009 19:37:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, hugh.dickins@tiscali.co.uk, mel@csn.ul.ie


The patch titled
     mm: avoid endless looping for oom killed tasks
has been added to the -mm tree.  Its filename is
     mm-avoid-endless-looping-for-oom-killed-tasks.patch

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

mm-avoid-endless-looping-for-oom-killed-tasks.patch
linux-next.patch
mm-copy-over-oom_adj-value-at-fork-time.patch
mm-remove-obsoleted-alloc_pages-cpuset-comment.patch
hugetlb-balance-freeing-of-huge-pages-across-nodes.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages-fix.patch
hugetlb-clean-up-and-update-huge-pages-documentation.patch
mm-oom-analysis-add-per-zone-statistics-to-show_free_areas.patch
mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch
mm-oom-analysis-show-kernel-stack-usage-in-proc-meminfo-and-oom-log-output.patch
mm-oom-analysis-add-shmem-vmstat.patch
page-allocator-allow-too-high-order-warning-messages-to-be-suppressed-with-__gfp_nowarn.patch
mm-update-alloc_flags-after-oom-killer-has-been-called.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch

