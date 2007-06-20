From: akpm@linux-foundation.org
Subject: - gfph-gfp_thisnode-can-go-to-other-nodes-if-some-are-unpopulated.patch removed from -mm tree
Date: Tue, 19 Jun 2007 20:28:52 -0700
Message-ID: <200706200328.l5K3Srgt027094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43927 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758400AbXFTD3r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Jun 2007 23:29:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nacc@us.ibm.com, apw@shadowen.org, clameter@sgi.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     gfp.h: GFP_THISNODE can go to other nodes if some are unpopulated
has been removed from the -mm tree.  Its filename was
     gfph-gfp_thisnode-can-go-to-other-nodes-if-some-are-unpopulated.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: gfp.h: GFP_THISNODE can go to other nodes if some are unpopulated
From: Nishanth Aravamudan <nacc@us.ibm.com>

While testing my sysfs per-node hugepage allocator
(http://marc.info/?l=linux-mm&m=117935849517122&w=2), I found that an
alloc_pages_node(nid, GFP_THISNODE) request would sometimes return a struct
page such that page_to_nid(page) != nid.  This was because, on that
particular machine, nodes 0 and 1 are populated and nodes 2 and 3 are not. 
When a page is requested get_page_from_freelist() relies on
zonelist->zones[0]->zone_pgdat indicating when THISNODE stops.  But,
because, say, node 2 has no memory, the first zone_pgdat in the fallback
list points to a different node.  Add a comment indicating that THISNODE
may not return pages on THISNODE if the node is unpopulated.

Am working on testing Lee/Anton's patch to add a node_populated_mask and
use that in the hugepage allocator path.  But I think this may be a problem
anywhere THISNODE is used and memory is expected to come from the requested
node and nowhere else.

Reworked the comment based on feedback from Christoph Lameter.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Acked-by: Christoph Lameter <clameter@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN include/linux/gfp.h~gfph-gfp_thisnode-can-go-to-other-nodes-if-some-are-unpopulated include/linux/gfp.h
--- a/include/linux/gfp.h~gfph-gfp_thisnode-can-go-to-other-nodes-if-some-are-unpopulated
+++ a/include/linux/gfp.h
@@ -67,6 +67,12 @@ struct vm_area_struct;
 			 __GFP_HIGHMEM)
 
 #ifdef CONFIG_NUMA
+/*
+ * NOTE: GFP_THISNODE allocates from the first available pgdat (== node
+ * structure) from the zonelist of the requested node. The first pgdat
+ * may be the pgdat of another node if the requested node has no memory
+ * on its own.
+ */
 #define GFP_THISNODE	(__GFP_THISNODE | __GFP_NOWARN | __GFP_NORETRY)
 #else
 #define GFP_THISNODE	((__force gfp_t)0)
_

Patches currently in -mm which might be from nacc@us.ibm.com are

hugetlb-remove-unnecessary-nid-initialization.patch
gfph-gfp_thisnode-can-go-to-other-nodes-if-some-are-unpopulated.patch
add-populated_map-to-account-for-memoryless-nodes.patch
add-populated_map-to-account-for-memoryless-nodes-fix.patch
