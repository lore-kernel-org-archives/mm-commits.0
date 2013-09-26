From: akpm@linux-foundation.org
Subject: + mm-mempolicy-use-numa_no_node.patch added to -mm tree
Date: Thu, 26 Sep 2013 14:22:12 -0700
Message-ID: <5244a584.iozc7+rnLZisBz8P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33621 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab3IZVWM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Sep 2013 17:22:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, kosaki.motohiro@jp.fujitsu.com, wujianguo@huawei.com

Subject: + mm-mempolicy-use-numa_no_node.patch added to -mm tree
To: wujianguo@huawei.com,kosaki.motohiro@jp.fujitsu.com,rientjes@google.com
From: akpm@linux-foundation.org
Date: Thu, 26 Sep 2013 14:22:12 -0700


The patch titled
     Subject: mm/mempolicy: use NUMA_NO_NODE
has been added to the -mm tree.  Its filename is
     mm-mempolicy-use-numa_no_node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-use-numa_no_node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-use-numa_no_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1811,7 +1811,7 @@ static unsigned offset_il_node(struct me
 	unsigned nnodes = nodes_weight(pol->v.nodes);
 	unsigned target;
 	int c;
-	int nid = -1;
+	int nid = NUMA_NO_NODE;
 
 	if (!nnodes)
 		return numa_node_id();
@@ -1848,11 +1848,11 @@ static inline unsigned interleave_nid(st
 
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

x86-srat-use-numa_no_node.patch
mm-vmalloc-use-numa_no_node.patch
mm-huge_memoryc-fix-stale-comments-of-transparent_hugepage_flags.patch
mm-arch-use-numa_no_node.patch
mm-mempolicy-use-numa_no_node.patch
linux-next.patch

