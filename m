From: akpm@linux-foundation.org
Subject: + oom-avoid-oom-killer-for-lowmem-allocations.patch added to -mm tree
Date: Mon, 22 Mar 2010 13:22:03 -0700
Message-ID: <201003222022.o2MKM3RB025237@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51284 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755888Ab0CVUWo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 16:22:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, npiggin@suse.de, riel@redhat.com


The patch titled
     oom: avoid oom killer for lowmem allocations
has been added to the -mm tree.  Its filename is
     oom-avoid-oom-killer-for-lowmem-allocations.patch

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
Subject: oom: avoid oom killer for lowmem allocations
From: David Rientjes <rientjes@google.com>

If memory has been depleted in lowmem zones even with the protection
afforded to it by /proc/sys/vm/lowmem_reserve_ratio, it is unlikely that
killing current users will help.  The memory is either reclaimable (or
migratable) already, in which case we should not invoke the oom killer at
all, or it is pinned by an application for I/O.  Killing such an
application may leave the hardware in an unspecified state and there is no
guarantee that it will be able to make a timely exit.

Lowmem allocations are now failed in oom conditions when __GFP_NOFAIL is
not used so that the task can perhaps recover or try again later.

Previously, the heuristic provided some protection for those tasks with
CAP_SYS_RAWIO, but this is no longer necessary since we will not be
killing tasks for the purposes of ISA allocations.

high_zoneidx is gfp_zone(gfp_flags), meaning that ZONE_NORMAL will be the
default for all allocations that are not __GFP_DMA, __GFP_DMA32,
__GFP_HIGHMEM, and __GFP_MOVABLE on kernels configured to support those
flags.  Testing for high_zoneidx being less than ZONE_NORMAL will only
return true for allocations that have either __GFP_DMA or __GFP_DMA32.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff -puN mm/page_alloc.c~oom-avoid-oom-killer-for-lowmem-allocations mm/page_alloc.c
--- a/mm/page_alloc.c~oom-avoid-oom-killer-for-lowmem-allocations
+++ a/mm/page_alloc.c
@@ -1675,6 +1675,9 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 		/* The OOM killer will not help higher order allocs */
 		if (order > PAGE_ALLOC_COSTLY_ORDER)
 			goto out;
+		/* The OOM killer does not needlessly kill tasks for lowmem */
+		if (high_zoneidx < ZONE_NORMAL)
+			goto out;
 		/*
 		 * GFP_THISNODE contains __GFP_NORETRY and we never hit this.
 		 * Sanity check for bare calls of __GFP_THISNODE, not real OOM.
@@ -1903,15 +1906,23 @@ rebalance:
 			if (page)
 				goto got_pg;
 
-			/*
-			 * The OOM killer does not trigger for high-order
-			 * ~__GFP_NOFAIL allocations so if no progress is being
-			 * made, there are no other options and retrying is
-			 * unlikely to help.
-			 */
-			if (order > PAGE_ALLOC_COSTLY_ORDER &&
-						!(gfp_mask & __GFP_NOFAIL))
-				goto nopage;
+			if (!(gfp_mask & __GFP_NOFAIL)) {
+				/*
+				 * The oom killer is not called for high-order
+				 * allocations that may fail, so if no progress
+				 * is being made, there are no other options and
+				 * retrying is unlikely to help.
+				 */
+				if (order > PAGE_ALLOC_COSTLY_ORDER)
+					goto nopage;
+				/*
+				 * The oom killer is not called for lowmem
+				 * allocations to prevent needlessly killing
+				 * innocent tasks.
+				 */
+				if (high_zoneidx < ZONE_NORMAL)
+					goto nopage;
+			}
 
 			goto restart;
 		}
_

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
cpuset-fix-the-problem-that-cpuset_mem_spread_node-returns-an-offline-node.patch
cpuset-alloc-nodemask_t-on-the-heap-rather-than-the-stack.patch
mempolicy-remove-redundant-code.patch
oom-filter-tasks-not-sharing-the-same-cpuset.patch
oom-sacrifice-child-with-highest-badness-score-for-parent.patch
oom-select-task-from-tasklist-for-mempolicy-ooms.patch
oom-remove-special-handling-for-pagefault-ooms.patch
oom-badness-heuristic-rewrite.patch
oom-deprecate-oom_adj-tunable.patch
oom-replace-sysctls-with-quick-mode.patch
oom-avoid-oom-killer-for-lowmem-allocations.patch
oom-remove-unnecessary-code-and-cleanup.patch
oom-default-to-killing-current-for-pagefault-ooms.patch
oom-avoid-race-for-oom-killed-tasks-detaching-mm-prior-to-exit.patch
memcg-oom-wakeup-filter.patch
memcg-oom-wakeup-filter-update.patch
memcg-oom-notifier.patch
memcg-oom-notifier-update.patch
memcg-oom-kill-disable-and-oom-status.patch
memcg-oom-kill-disable-and-oom-status-update.patch

