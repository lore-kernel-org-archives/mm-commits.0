From: akpm@linux-foundation.org
Subject: - cpusets-update-mems-allowed-in-page-allocator.patch removed from -mm tree
Date: Thu, 13 Nov 2008 13:26:39 -0800
Message-ID: <200811132126.mADLQdDl027433@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55079 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752722AbYKMV1P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Nov 2008 16:27:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, cl@linux-foundation.org, mel@csn.ul.ie, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cpusets: update mems allowed in page allocator
has been removed from the -mm tree.  Its filename was
     cpusets-update-mems-allowed-in-page-allocator.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpusets: update mems allowed in page allocator
From: David Rientjes <rientjes@google.com>

If all allowable memory is unreclaimable, it is possible to loop forever
in the page allocator for ~__GFP_NORETRY allocations.

During this time, it is also possible for a task's cpuset to expand its
set of allowable nodes so that it now includes free memory.  The cached
copy of this set, current->mems_allowed, is stale, however, since there
has not been a subsequent call to cpuset_update_task_memory_state().

The cached copy of the set of allowable nodes is now updated in the page
allocator's slow path so the additional memory is available to
get_page_from_freelist().

[akpm@linux-foundation.org: add comment]
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Paul Menage <menage@google.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/page_alloc.c~cpusets-update-mems-allowed-in-page-allocator mm/page_alloc.c
--- a/mm/page_alloc.c~cpusets-update-mems-allowed-in-page-allocator
+++ a/mm/page_alloc.c
@@ -1561,6 +1561,10 @@ nofail_alloc:
 
 	/* We now go into synchronous reclaim */
 	cpuset_memory_pressure_bump();
+	/*
+	 * The task's cpuset might have expanded its set of allowable nodes
+	 */
+	cpuset_update_task_memory_state();
 	p->flags |= PF_MEMALLOC;
 	reclaim_state.reclaimed_slab = 0;
 	p->reclaim_state = &reclaim_state;
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
cpuset-update-top-cpusets-mems-after-adding-a-node.patch
oom-fix-zone_scan_mutex-name.patch
oom-print-triggering-tasks-cpuset-and-mems-allowed.patch

