From: akpm@linux-foundation.org
Subject: [merged] mm-mempolicy-use-numa_no_node.patch removed from -mm
 tree
Date: Wed, 13 Nov 2013 12:38:28 -0800
Message-ID: <5283e344.E/lB23RmdIX0lgmx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42604 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab3KMUi2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:38:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, kosaki.motohiro@jp.fujitsu.com, wujianguo@huawei.com

Subject: [merged] mm-mempolicy-use-numa_no_node.patch removed from -mm tree
To: wujianguo@huawei.com,kosaki.motohiro@jp.fujitsu.com,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:38:28 -0800


The patch titled
     Subject: mm/mempolicy: use NUMA_NO_NODE
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-use-numa_no_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jianguo Wu <wujianguo@huawei.com>
Subject: mm/mempolicy: use NUMA_NO_NODE

Use more appropriate NUMA_NO_NODE instead of -1

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/mempolicy.c~mm-mempolicy-use-numa_no_node mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicy-use-numa_no_node
+++ a/mm/mempolicy.c
@@ -1125,7 +1125,7 @@ int do_migrate_pages(struct mm_struct *m
 	tmp = *from;
 	while (!nodes_empty(tmp)) {
 		int s,d;
-		int source = -1;
+		int source = NUMA_NO_NODE;
 		int dest = 0;
 
 		for_each_node_mask(s, tmp) {
@@ -1160,7 +1160,7 @@ int do_migrate_pages(struct mm_struct *m
 			if (!node_isset(dest, tmp))
 				break;
 		}
-		if (source == -1)
+		if (source == NUMA_NO_NODE)
 			break;
 
 		node_clear(source, tmp);
@@ -1835,7 +1835,7 @@ static unsigned offset_il_node(struct me
 	unsigned nnodes = nodes_weight(pol->v.nodes);
 	unsigned target;
 	int c;
-	int nid = -1;
+	int nid = NUMA_NO_NODE;
 
 	if (!nnodes)
 		return numa_node_id();
@@ -1872,11 +1872,11 @@ static inline unsigned interleave_nid(st
 
 /*
  * Return the bit number of a random bit set in the nodemask.
- * (returns -1 if nodemask is empty)
+ * (returns NUMA_NO_NODE if nodemask is empty)
  */
 int node_random(const nodemask_t *maskp)
 {
-	int w, bit = -1;
+	int w, bit = NUMA_NO_NODE;
 
 	w = nodes_weight(*maskp);
 	if (w)
_

Patches currently in -mm which might be from wujianguo@huawei.com are

origin.patch
x86-srat-use-numa_no_node.patch
linux-next.patch

