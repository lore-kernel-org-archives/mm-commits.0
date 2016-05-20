From: akpm@linux-foundation.org
Subject: [patch 056/117] mm/mempolicy.c:offset_il_node() document and
 clarify
Date: Thu, 19 May 2016 17:11:43 -0700
Message-ID: <573e563f.fkpIqN+6zKF8WOy9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46201 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755550AbcETALo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:11:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, js1304@gmail.com, lauraa@codeaurora.org, n-horiguchi@ah.jp.nec.com, qiuxishi@huawei.com, rientjes@google.com, vbabka@suse.cz

From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/mempolicy.c:offset_il_node() document and clarify

This code was pretty obscure and was relying upon obscure side-effects of
next_node(-1, ...) and was relying upon NUMA_NO_NODE being equal to -1.

Clean that all up and document the function's intent.

Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Laura Abbott <lauraa@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff -puN mm/mempolicy.c~mm-mempolicyc-offset_il_node-document-and-clarify mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicyc-offset_il_node-document-and-clarify
+++ a/mm/mempolicy.c
@@ -1758,23 +1758,25 @@ unsigned int mempolicy_slab_node(void)
 	}
 }
 
-/* Do static interleaving for a VMA with known offset. */
+/*
+ * Do static interleaving for a VMA with known offset @n.  Returns the n'th
+ * node in pol->v.nodes (starting from n=0), wrapping around if n exceeds the
+ * number of present nodes.
+ */
 static unsigned offset_il_node(struct mempolicy *pol,
-		struct vm_area_struct *vma, unsigned long off)
+			       struct vm_area_struct *vma, unsigned long n)
 {
 	unsigned nnodes = nodes_weight(pol->v.nodes);
 	unsigned target;
-	int c;
-	int nid = NUMA_NO_NODE;
+	int i;
+	int nid;
 
 	if (!nnodes)
 		return numa_node_id();
-	target = (unsigned int)off % nnodes;
-	c = 0;
-	do {
+	target = (unsigned int)n % nnodes;
+	nid = first_node(pol->v.nodes);
+	for (i = 0; i < target; i++)
 		nid = next_node(nid, pol->v.nodes);
-		c++;
-	} while (c <= target);
 	return nid;
 }
 
_
