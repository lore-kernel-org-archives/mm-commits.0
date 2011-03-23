From: akpm@linux-foundation.org
Subject: [merged] oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-page-alloc-failure.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:33:57 -0700
Message-ID: <201103232037.p2NKbX9g028246@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52965 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933298Ab1CWUia (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:38:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     oom: suppress nodes that are not allowed from meminfo on page alloc failure
has been removed from the -mm tree.  Its filename was
     oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-page-alloc-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom: suppress nodes that are not allowed from meminfo on page alloc failure
From: David Rientjes <rientjes@google.com>

Displaying extremely verbose meminfo for all nodes on the system is
overkill for page allocation failures when the context restricts that
allocation to only a subset of nodes.  We don't particularly care about
the state of all nodes when some are not allowed in the current context,
they can have an abundance of memory but we can't allocate from that part
of memory.

This patch suppresses disallowed nodes from the meminfo dump on a page
allocation failure if the context requires it.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-page-alloc-failure mm/page_alloc.c
--- a/mm/page_alloc.c~oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-page-alloc-failure
+++ a/mm/page_alloc.c
@@ -2171,12 +2171,25 @@ rebalance:
 
 nopage:
 	if (!(gfp_mask & __GFP_NOWARN) && printk_ratelimit()) {
-		printk(KERN_WARNING "%s: page allocation failure."
-			" order:%d, mode:0x%x\n",
+		unsigned int filter = SHOW_MEM_FILTER_NODES;
+
+		/*
+		 * This documents exceptions given to allocations in certain
+		 * contexts that are allowed to allocate outside current's set
+		 * of allowed nodes.
+		 */
+		if (!(gfp_mask & __GFP_NOMEMALLOC))
+			if (test_thread_flag(TIF_MEMDIE) ||
+			    (current->flags & (PF_MEMALLOC | PF_EXITING)))
+				filter &= ~SHOW_MEM_FILTER_NODES;
+		if (in_interrupt() || !wait)
+			filter &= ~SHOW_MEM_FILTER_NODES;
+
+		pr_warning("%s: page allocation failure. order:%d, mode:0x%x\n",
 			current->comm, order, gfp_mask);
 		dump_stack();
 		if (!should_suppress_show_mem())
-			show_mem();
+			__show_mem(filter);
 	}
 	return page;
 got_pg:
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
jbd-remove-dependency-on-__gfp_nofail.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch
memcg-give-current-access-to-memory-reserves-if-its-trying-to-die.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-add-dirty-limiting-routines.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch
memcg-make-background-writeback-memcg-aware.patch
cpuset-remove-unneeded-nodemask_alloc-in-cpuset_sprintf_memlist.patch
cpuset-remove-unneeded-nodemask_alloc-in-cpuset_sprintf_memlist-v2.patch
cpuset-remove-unneeded-nodemask_alloc-in-cpuset_attch.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc-v2.patch
cpuset-hold-callback_mutex-in-cpuset_clone.patch
sysctl-add-some-missing-input-constraint-checks.patch

