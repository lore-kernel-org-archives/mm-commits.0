From: akpm@linux-foundation.org
Subject: [merged]
 mm-unify-checks-in-alloc_pages_node-and-__alloc_pages_node.patch removed
 from -mm tree
Date: Wed, 09 Sep 2015 12:53:27 -0700
Message-ID: <55f08e37.MEqDgoTujONDg9q4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41047 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403AbbIITx2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:53:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, cl@linux.com, hannes@cmpxchg.org, mhocko@suse.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: unify checks in alloc_pages_node() and __alloc_pages_node()
has been removed from the -mm tree.  Its filename was
     mm-unify-checks-in-alloc_pages_node-and-__alloc_pages_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm: unify checks in alloc_pages_node() and __alloc_pages_node()

Perform the same debug checks in alloc_pages_node() as are done in
__alloc_pages_node(), by making the former function a wrapper of the
latter one.

In addition to better diagnostics in DEBUG_VM builds for situations which
have been already fatal (e.g.  out-of-bounds node id), there are two
visible changes for potential existing buggy callers of
alloc_pages_node():

- calling alloc_pages_node() with any negative nid (e.g. due to arithmetic
  overflow) was treated as passing NUMA_NO_NODE and fallback to local node was
  applied. This will now be fatal.
- calling alloc_pages_node() with an offline node will now be checked for
  DEBUG_VM builds. Since it's not fatal if the node has been previously online,
  and this patch may expose some existing buggy callers, change the VM_BUG_ON
  in __alloc_pages_node() to VM_WARN_ON.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/gfp.h~mm-unify-checks-in-alloc_pages_node-and-__alloc_pages_node include/linux/gfp.h
--- a/include/linux/gfp.h~mm-unify-checks-in-alloc_pages_node-and-__alloc_pages_node
+++ a/include/linux/gfp.h
@@ -310,23 +310,23 @@ __alloc_pages(gfp_t gfp_mask, unsigned i
 static inline struct page *
 __alloc_pages_node(int nid, gfp_t gfp_mask, unsigned int order)
 {
-	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES || !node_online(nid));
+	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
+	VM_WARN_ON(!node_online(nid));
 
 	return __alloc_pages(gfp_mask, order, node_zonelist(nid, gfp_mask));
 }
 
 /*
  * Allocate pages, preferring the node given as nid. When nid == NUMA_NO_NODE,
- * prefer the current CPU's node.
+ * prefer the current CPU's node. Otherwise node must be valid and online.
  */
 static inline struct page *alloc_pages_node(int nid, gfp_t gfp_mask,
 						unsigned int order)
 {
-	/* Unknown node is current node */
-	if (nid < 0)
+	if (nid == NUMA_NO_NODE)
 		nid = numa_node_id();
 
-	return __alloc_pages(gfp_mask, order, node_zonelist(nid, gfp_mask));
+	return __alloc_pages_node(nid, gfp_mask, order);
 }
 
 #ifdef CONFIG_NUMA
_

Patches currently in -mm which might be from vbabka@suse.cz are


