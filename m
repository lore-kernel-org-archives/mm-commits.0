From: akpm@linux-foundation.org
Subject: + oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-page-alloc-failure.patch added to -mm tree
Date: Thu, 20 Jan 2011 16:28:17 -0800
Message-ID: <201101210028.p0L0SHHr011485@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59928 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753722Ab1AUA3S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Jan 2011 19:29:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     oom: suppress nodes that are not allowed from meminfo on page alloc failure
has been added to the -mm tree.  Its filename is
     oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-page-alloc-failure.patch

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
@@ -2161,12 +2161,25 @@ rebalance:
 
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
+			__show_mem();
 	}
 	return page;
 got_pg:
_

Patches currently in -mm which might be from rientjes@google.com are

kconfig-rename-config_embedded-to-config_expert.patch
x86-numa-add-error-handling-for-bad-cpu-to-node-mappings.patch
oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-oom-kill.patch
oom-suppress-show_mem-for-many-nodes-in-irq-context-on-page-alloc-failure.patch
oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-page-alloc-failure.patch
jbd-remove-dependency-on-__gfp_nofail.patch

