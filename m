From: akpm@linux-foundation.org
Subject: + cpusets-update-mems-allowed-in-page-allocator.patch added to -mm tree
Date: Wed, 29 Oct 2008 23:48:21 -0700
Message-ID: <200810300648.m9U6mLvG004831@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38292 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752704AbYJ3Gse (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Oct 2008 02:48:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, cl@linux-foundation.org, mel@csn.ul.ie, menage@google.com


The patch titled
     cpusets: update mems allowed in page allocator
has been added to the -mm tree.  Its filename is
     cpusets-update-mems-allowed-in-page-allocator.patch

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

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Paul Menage <menage@google.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/page_alloc.c~cpusets-update-mems-allowed-in-page-allocator mm/page_alloc.c
--- a/mm/page_alloc.c~cpusets-update-mems-allowed-in-page-allocator
+++ a/mm/page_alloc.c
@@ -1561,6 +1561,7 @@ nofail_alloc:
 
 	/* We now go into synchronous reclaim */
 	cpuset_memory_pressure_bump();
+	cpuset_update_task_memory_state();
 	p->flags |= PF_MEMALLOC;
 	reclaim_state.reclaimed_slab = 0;
 	p->reclaim_state = &reclaim_state;
_

Patches currently in -mm which might be from rientjes@google.com are

oom-do-not-dump-task-state-for-non-thread-group-leaders.patch
vmemmap-warn-about-page_structs-with-remote-distance.patch
cpusets-update-mems-allowed-in-page-allocator.patch
oom-fix-zone_scan_mutex-name.patch
oom-print-triggering-tasks-cpuset-and-mems-allowed.patch

