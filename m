From: akpm@linux-foundation.org
Subject: - memoryless-nodes-generic-management-of-nodemasks-for-various-purposes-fix.patch removed from -mm tree
Date: Mon, 15 Oct 2007 21:25:58 -0700
Message-ID: <200710160425.l9G4Pwon008701@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43141 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751936AbXJPE0Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 00:26:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Lee.Schermerhorn@hp.com, clameter@sgi.com, lee.schermerhorn@hp.com, serge@hallyn.com, mm-commits@vger.kernel.org


The patch titled
     Initialize N_*_MEMORY and N_CPU masks for non-NUMA config
has been removed from the -mm tree.  Its filename was
     memoryless-nodes-generic-management-of-nodemasks-for-various-purposes-fix.patch

This patch was dropped because it was folded into memoryless-nodes-generic-management-of-nodemasks-for-various-purposes.patch

------------------------------------------------------
Subject: Initialize N_*_MEMORY and N_CPU masks for non-NUMA config
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

The N_*_MEMORY and N_CPU node state masks are not being initialized for
!NUMA because node_set_state() becomes a no-op for that config.  This
causes one to hit a BUG_ON() attempting to mount cpusets to partition cpus.
 Discovered and diagnosed by Serge Hallyn and Dhaval Giani.

Statically initialize the N_*_MEMORY and N_CPU node state masks for !NUMA
configurations.  This static initialization is required because the
node_set_state() function becomes a no-op for !NUMA.  Other generic code
assumes that these masks are set correctly.

Note that in NUMA configurations, these masks will be populated correctly,
so don't bother with static initialization.  No sense in making assumptions
that could be broken down the road, resulting in extra work for someone to
debug.  Unlikely, perhaps, but who needs the aggravation...

Tested on i386 !NUMA by Dhaval Giani.  Fixes cpuset BUG.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Christoph Lameter <clameter@sgi.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~memoryless-nodes-generic-management-of-nodemasks-for-various-purposes-fix mm/page_alloc.c
--- a/mm/page_alloc.c~memoryless-nodes-generic-management-of-nodemasks-for-various-purposes-fix
+++ a/mm/page_alloc.c
@@ -51,7 +51,14 @@
  */
 nodemask_t node_states[NR_NODE_STATES] __read_mostly = {
 	[N_POSSIBLE] = NODE_MASK_ALL,
-	[N_ONLINE] = { { [0] = 1UL } }
+	[N_ONLINE] = { { [0] = 1UL } },
+#ifndef CONFIG_NUMA
+	[N_NORMAL_MEMORY] = { { [0] = 1UL } },
+#ifdef CONFIG_HIGHMEM
+	[N_HIGH_MEMORY] = { { [0] = 1UL } },
+#endif
+	[N_CPU] = { { [0] = 1UL } },
+#endif	/* NUMA */
 };
 EXPORT_SYMBOL(node_states);
 
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

origin.patch
mem-policy-add-mpol_f_mems_allowed-get_mempolicy-flag.patch
memoryless-nodes-generic-management-of-nodemasks-for-various-purposes.patch
memoryless-nodes-generic-management-of-nodemasks-for-various-purposes-fix.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
update-n_high_memory-node-state-for-memory-hotadd.patch
memoryless-nodes-add-n_cpu-node-state-move-setup-of-n_cpu-node-state-mask.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix-2-3.patch
add-node-states-sysfs-class-attributes-v5.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix-2.patch
