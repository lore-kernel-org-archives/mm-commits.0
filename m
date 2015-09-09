From: akpm@linux-foundation.org
Subject: [merged] mm-use-numa_mem_id-in-alloc_pages_node.patch removed
 from -mm tree
Date: Wed, 09 Sep 2015 12:53:30 -0700
Message-ID: <55f08e3a.8HA5VWr1OIQa3tRv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41054 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390AbbIITxb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:53:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, cl@linux.com, mgorman@techsingularity.net, mhocko@suse.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use numa_mem_id() in alloc_pages_node()
has been removed from the -mm tree.  Its filename was
     mm-use-numa_mem_id-in-alloc_pages_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm: use numa_mem_id() in alloc_pages_node()

alloc_pages_node() might fail when called with NUMA_NO_NODE and
__GFP_THISNODE on a CPU belonging to a memoryless node.  To make the
local-node fallback more robust and prevent such situations, use
numa_mem_id(), which was introduced for similar scenarios in the slab
context.

Suggested-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/gfp.h~mm-use-numa_mem_id-in-alloc_pages_node include/linux/gfp.h
--- a/include/linux/gfp.h~mm-use-numa_mem_id-in-alloc_pages_node
+++ a/include/linux/gfp.h
@@ -318,13 +318,14 @@ __alloc_pages_node(int nid, gfp_t gfp_ma
 
 /*
  * Allocate pages, preferring the node given as nid. When nid == NUMA_NO_NODE,
- * prefer the current CPU's node. Otherwise node must be valid and online.
+ * prefer the current CPU's closest node. Otherwise node must be valid and
+ * online.
  */
 static inline struct page *alloc_pages_node(int nid, gfp_t gfp_mask,
 						unsigned int order)
 {
 	if (nid == NUMA_NO_NODE)
-		nid = numa_node_id();
+		nid = numa_mem_id();
 
 	return __alloc_pages_node(nid, gfp_mask, order);
 }
_

Patches currently in -mm which might be from vbabka@suse.cz are


