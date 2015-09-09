From: akpm@linux-foundation.org
Subject: [merged]
 mm-page-refine-the-calculation-of-highest-possible-node-id.patch removed
 from -mm tree
Date: Wed, 09 Sep 2015 12:43:41 -0700
Message-ID: <55f08bed.lmK2DLFNxqDmwThB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38848 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802AbbIITnm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:43:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weiyang@linux.vnet.ibm.com, rientjes@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: refine the calculation of highest possible node id
has been removed from the -mm tree.  Its filename was
     mm-page-refine-the-calculation-of-highest-possible-node-id.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <weiyang@linux.vnet.ibm.com>
Subject: mm/page_alloc.c: refine the calculation of highest possible node id

nr_node_ids records the highest possible node id, which is calculated by
scanning the bitmap node_states[N_POSSIBLE].  Current implementation scan
the bitmap from the beginning, which will scan the whole bitmap.

This patch reverses the order by scanning from the end with
find_last_bit().

Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/page_alloc.c~mm-page-refine-the-calculation-of-highest-possible-node-id mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page-refine-the-calculation-of-highest-possible-node-id
+++ a/mm/page_alloc.c
@@ -5478,11 +5478,9 @@ void __paginginit free_area_init_node(in
  */
 void __init setup_nr_node_ids(void)
 {
-	unsigned int node;
-	unsigned int highest = 0;
+	unsigned int highest;
 
-	for_each_node_mask(node, node_possible_map)
-		highest = node;
+	highest = find_last_bit(node_possible_map.bits, MAX_NUMNODES);
 	nr_node_ids = highest + 1;
 }
 #endif
_

Patches currently in -mm which might be from weiyang@linux.vnet.ibm.com are


