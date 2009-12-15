From: akpm@linux-foundation.org
Subject: [merged] hugetlb-factor-init_nodemask_of_node.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:50:55 -0800
Message-ID: <200912152150.nBFLotIh014991@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59377 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761196AbZLOVwX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:52:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.schermerhorn@hp.com, agl@us.ibm.com, andi@firstfloor.org, apw@canonical.com, cl@linux-foundation.org, eric.whitney@hp.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, nacc@us.ib


The patch titled
     hugetlb: factor init_nodemask_of_node()
has been removed from the -mm tree.  Its filename was
     hugetlb-factor-init_nodemask_of_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: factor init_nodemask_of_node()
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

Factor init_nodemask_of_node() out of the nodemask_of_node() macro.

This will be used to populate the huge pages "nodes_allowed" nodemask for
a single node when basing nodes_allowed on a preferred/local mempolicy or
when a persistent huge page pool page count is modified via a per node
sysfs attribute.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Andi Kleen <andi@firstfloor.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Eric Whitney <eric.whitney@hp.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nodemask.h |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN include/linux/nodemask.h~hugetlb-factor-init_nodemask_of_node include/linux/nodemask.h
--- a/include/linux/nodemask.h~hugetlb-factor-init_nodemask_of_node
+++ a/include/linux/nodemask.h
@@ -245,14 +245,19 @@ static inline int __next_node(int n, con
 	return min_t(int,MAX_NUMNODES,find_next_bit(srcp->bits, MAX_NUMNODES, n+1));
 }
 
+static inline void init_nodemask_of_node(nodemask_t *mask, int node)
+{
+	nodes_clear(*mask);
+	node_set(node, *mask);
+}
+
 #define nodemask_of_node(node)						\
 ({									\
 	typeof(_unused_nodemask_arg_) m;				\
 	if (sizeof(m) == sizeof(unsigned long)) {			\
-		m.bits[0] = 1UL<<(node);				\
+		m.bits[0] = 1UL << (node);				\
 	} else {							\
-		nodes_clear(m);						\
-		node_set((node), m);					\
+		init_nodemask_of_node(&m, (node));			\
 	}								\
 	m;								\
 })
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

origin.patch

