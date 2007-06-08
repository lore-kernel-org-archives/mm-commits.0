From: akpm@linux-foundation.org
Subject: + numa-mempolicy-dynamic-interleave-map-for-system-init.patch added to -mm tree
Date: Thu, 07 Jun 2007 18:01:12 -0700
Message-ID: <200706080101.l5811C5E014289@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54997 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936268AbXFHBB0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jun 2007 21:01:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lethal@linux-sh.org, ak@suse.de, clameter@sgi.com, hugh@veritas.com, lee.schermerhorn@hp.com


The patch titled
     numa: mempolicy: dynamic interleave map for system init
has been added to the -mm tree.  Its filename is
     numa-mempolicy-dynamic-interleave-map-for-system-init.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: numa: mempolicy: dynamic interleave map for system init
From: Paul Mundt <lethal@linux-sh.org>

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   31 ++++++++++++++++++++++++++++---
 1 files changed, 28 insertions(+), 3 deletions(-)

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

slab-fix-alien-cache-handling.patch
potential-parse-error-in-ifdef-part-3.patch
lots-of-architectures-enable-arbitary-speed-tty-support.patch
git-sh.patch
numa-mempolicy-dynamic-interleave-map-for-system-init.patch
pvr2fb-fix-pseudo_palette-array-overrun-and-typecast.patch
