From: akpm@linux-foundation.org
Subject: + memoryless-nodes-generic-management-of-nodemasks-for-various-purposes-fix.patch added to -mm tree
Date: Thu, 16 Aug 2007 13:32:20 -0700
Message-ID: <200708162032.l7GKWKRF005434@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53490 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755580AbXHPUck (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Aug 2007 16:32:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Lee.Schermerhorn@hp.com, clameter@sgi.com, lee.schermerhorn@hp.com, serge@hallyn.com


The patch titled
     Initialize N_*_MEMORY and N_CPU masks for non-NUMA config
has been added to the -mm tree.  Its filename is
     memoryless-nodes-generic-management-of-nodemasks-for-various-purposes-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

document-linux-memory-policy-v3.patch
memoryless-nodes-generic-management-of-nodemasks-for-various-purposes-fix.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
