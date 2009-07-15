From: akpm@linux-foundation.org
Subject: + mm-update-alloc_flags-after-oom-killer-has-been-called.patch added to -mm tree
Date: Wed, 15 Jul 2009 13:38:43 -0700
Message-ID: <200907152038.n6FKch8k026306@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52804 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755539AbZGOUiz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Jul 2009 16:38:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, mel@csn.ul.ie


The patch titled
     mm: update alloc_flags after oom killer has been called
has been added to the -mm tree.  Its filename is
     mm-update-alloc_flags-after-oom-killer-has-been-called.patch

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
Subject: mm: update alloc_flags after oom killer has been called
From: David Rientjes <rientjes@google.com>

It is possible for the oom killer to select current as the task to kill. 
When this happens, alloc_flags needs to be updated accordingly to set
ALLOC_NO_WATERMARKS so the subsequent allocation attempt may use memory
reserves as the result of its thread having TIF_MEMDIE set if the
allocation is not __GFP_NOMEMALLOC.

Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-update-alloc_flags-after-oom-killer-has-been-called mm/page_alloc.c
--- a/mm/page_alloc.c~mm-update-alloc_flags-after-oom-killer-has-been-called
+++ a/mm/page_alloc.c
@@ -1781,6 +1781,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 
 	wake_all_kswapd(order, zonelist, high_zoneidx);
 
+restart:
 	/*
 	 * OK, we're below the kswapd watermark and have kicked background
 	 * reclaim. Now things get more complex, so set up alloc_flags according
@@ -1788,7 +1789,6 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	 */
 	alloc_flags = gfp_to_alloc_flags(gfp_mask);
 
-restart:
 	/* This is the last chance, in general, before the goto nopage. */
 	page = get_page_from_freelist(gfp_mask, nodemask, order, zonelist,
 			high_zoneidx, alloc_flags & ~ALLOC_NO_WATERMARKS,
_

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
page-allocator-ensure-that-processes-that-have-been-oom-killed-exit-the-page-allocator-resend.patch
page-allocator-ensure-that-processes-that-have-been-oom-killed-exit-the-page-allocator.patch
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

