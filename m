From: akpm@linux-foundation.org
Subject: - numa-mempolicy-dynamic-interleave-map-for-system-init.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:49:19 -0700
Message-ID: <200707162049.l6GKnJ7O001151@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34794 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757057AbXGPVga (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:36:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, ak@suse.de, clameter@sgi.com, hugh@veritas.com, lee.schermerhorn@hp.com, mm-commits@vger.kernel.org


The patch titled
     numa: mempolicy: dynamic interleave map for system init
has been removed from the -mm tree.  Its filename was
     numa-mempolicy-dynamic-interleave-map-for-system-init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: numa: mempolicy: dynamic interleave map for system init
From: Paul Mundt <lethal@linux-sh.org>

This converts the default system init memory policy to use a dynamically
created node map instead of defaulting to all online nodes.  Nodes of a
certain size (>= 16MB) are judged to be suitable for interleave, and are added
to the map.  If all nodes are smaller in size, the largest one is
automatically selected.

Without this, tiny nodes find themselves out of memory before we even make it
to userspace.  Systems with large nodes will notice no change.

Only the system init policy is effected by this change, the regular
MPOL_DEFAULT policy is still switched to later on in the boot process as
normal.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff -puN mm/mempolicy.c~numa-mempolicy-dynamic-interleave-map-for-system-init mm/mempolicy.c
--- a/mm/mempolicy.c~numa-mempolicy-dynamic-interleave-map-for-system-init
+++ a/mm/mempolicy.c
@@ -1597,6 +1597,10 @@ void mpol_free_shared_policy(struct shar
 /* assumes fs == KERNEL_DS */
 void __init numa_policy_init(void)
 {
+	nodemask_t interleave_nodes;
+	unsigned long largest = 0;
+	int nid, prefer = 0;
+
 	policy_cache = kmem_cache_create("numa_policy",
 					 sizeof(struct mempolicy),
 					 0, SLAB_PANIC, NULL, NULL);
@@ -1605,10 +1609,31 @@ void __init numa_policy_init(void)
 				     sizeof(struct sp_node),
 				     0, SLAB_PANIC, NULL, NULL);
 
-	/* Set interleaving policy for system init. This way not all
-	   the data structures allocated at system boot end up in node zero. */
+	/*
+	 * Set interleaving policy for system init. Interleaving is only
+	 * enabled across suitably sized nodes (default is >= 16MB), or
+	 * fall back to the largest node if they're all smaller.
+	 */
+	nodes_clear(interleave_nodes);
+	for_each_online_node(nid) {
+		unsigned long total_pages = node_present_pages(nid);
+
+		/* Preserve the largest node */
+		if (largest < total_pages) {
+			largest = total_pages;
+			prefer = nid;
+		}
+
+		/* Interleave this node? */
+		if ((total_pages << PAGE_SHIFT) >= (16 << 20))
+			node_set(nid, interleave_nodes);
+	}
+
+	/* All too small, use the largest */
+	if (unlikely(nodes_empty(interleave_nodes)))
+		node_set(prefer, interleave_nodes);
 
-	if (do_set_mempolicy(MPOL_INTERLEAVE, &node_online_map))
+	if (do_set_mempolicy(MPOL_INTERLEAVE, &interleave_nodes))
 		printk("numa_policy_init: interleaving failed\n");
 }
 
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
pvr2fb-fix-pseudo_palette-array-overrun-and-typecast.patch
fb-epson1355fb-kill-off-dead-sh-support.patch
