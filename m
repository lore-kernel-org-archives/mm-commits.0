From: akpm@linux-foundation.org
Subject: + mm-default-to-node-zonelist-ordering-when-nodes-have-only-lowmem.patch added to -mm tree
Date: Wed, 31 Mar 2010 14:00:13 -0700
Message-ID: <201003312100.o2VL0Dtn008175@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45953 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753207Ab0CaVBQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Mar 2010 17:01:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     mm: default to node zonelist ordering when nodes have only lowmem
has been added to the -mm tree.  Its filename is
     mm-default-to-node-zonelist-ordering-when-nodes-have-only-lowmem.patch

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
Subject: mm: default to node zonelist ordering when nodes have only lowmem
From: David Rientjes <rientjes@google.com>

There are two types of zonelist ordering methodologies:

 - node order, preferring allocations on a node to stay local to and

 - zone order, preferring allocations come from a higher zone to avoid
   allocating in lowmem zones even though they may not be local.

The ordering technique used by the kernel is configurable on the command
line, but also has some logic to determine what the default should be.

This logic currently lacks knowledge of systems where a node may only have
lowmem.  For such systems, it is necessary to use node order so that
GFP_KERNEL allocations may be satisfied by nodes consisting of only
lowmem.

If zone order is used, GFP_KERNEL allocations to such nodes are actually
allocated on a node with local affinity that includes ZONE_NORMAL.

This change defaults to node zonelist ordering if any node lacks
ZONE_NORMAL.

To force zone order, append 'numa_zonelist_order=zone' to the kernel
command line.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-default-to-node-zonelist-ordering-when-nodes-have-only-lowmem mm/page_alloc.c
--- a/mm/page_alloc.c~mm-default-to-node-zonelist-ordering-when-nodes-have-only-lowmem
+++ a/mm/page_alloc.c
@@ -2613,7 +2613,7 @@ static int default_zonelist_order(void)
          * ZONE_DMA and ZONE_DMA32 can be very small area in the system.
 	 * If they are really small and used heavily, the system can fall
 	 * into OOM very easily.
-	 * This function detect ZONE_DMA/DMA32 size and confgigures zone order.
+	 * This function detect ZONE_DMA/DMA32 size and configures zone order.
 	 */
 	/* Is there ZONE_NORMAL ? (ex. ppc has only DMA zone..) */
 	low_kmem_size = 0;
@@ -2625,6 +2625,15 @@ static int default_zonelist_order(void)
 				if (zone_type < ZONE_NORMAL)
 					low_kmem_size += z->present_pages;
 				total_size += z->present_pages;
+			} else if (zone_type == ZONE_NORMAL) {
+				/*
+				 * If any node has only lowmem, then node order
+				 * is preferred to allow kernel allocations
+				 * locally; otherwise, they can easily infringe
+				 * on other nodes when there is an abundance of
+				 * lowmem available to allocate from.
+				 */
+				return ZONELIST_ORDER_NODE;
 			}
 		}
 	}
_

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
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
mempolicy-remove-case-mpol_interleave-from-policy_zonelist.patch
mempolicy-remove-redundant-check.patch
mempolicy-dont-call-mpol_set_nodemask-when-no_context.patch
mempolicy-lose-unnecessary-loop-variable-in-mpol_parse_str.patch
mempolicy-rename-policy_types-and-cleanup-initialization.patch
mempolicy-factor-mpol_shared_policy_init-return-paths.patch
mempolicy-document-cpuset-interaction-with-tmpfs-mpol-mount-option.patch
mm-default-to-node-zonelist-ordering-when-nodes-have-only-lowmem.patch
memcg-oom-wakeup-filter.patch
memcg-oom-wakeup-filter-update.patch
memcg-oom-notifier.patch
memcg-oom-notifier-update.patch
memcg-oom-kill-disable-and-oom-status.patch
memcg-oom-kill-disable-and-oom-status-update.patch

