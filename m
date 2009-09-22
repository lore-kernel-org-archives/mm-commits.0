From: akpm@linux-foundation.org
Subject: [merged] mm-update-alloc_flags-after-oom-killer-has-been-called.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:38:18 -0700
Message-ID: <200909222038.n8MKcITt001157@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45736 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752374AbZIVUiw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:38:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     mm: update alloc_flags after oom killer has been called
has been removed from the -mm tree.  Its filename was
     mm-update-alloc_flags-after-oom-killer-has-been-called.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1771,6 +1771,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 
 	wake_all_kswapd(order, zonelist, high_zoneidx);
 
+restart:
 	/*
 	 * OK, we're below the kswapd watermark and have kicked background
 	 * reclaim. Now things get more complex, so set up alloc_flags according
@@ -1778,7 +1779,6 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	 */
 	alloc_flags = gfp_to_alloc_flags(gfp_mask);
 
-restart:
 	/* This is the last chance, in general, before the goto nopage. */
 	page = get_page_from_freelist(gfp_mask, nodemask, order, zonelist,
 			high_zoneidx, alloc_flags & ~ALLOC_NO_WATERMARKS,
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
x86-default-pcibus-cpumask-to-all-cpus-if-it-lacks-affinity.patch
fs-proc-task_mmuc-v1-fix-clear_refs_write-input-sanity-check.patch
walk-system-ram-range-fix-2.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch

