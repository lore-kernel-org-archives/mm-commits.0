From: akpm@linux-foundation.org
Subject: [merged] prio_tree-simplify-prio_tree_expand.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:30:09 -0700
Message-ID: <20120326193009.4C646A00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:38491 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753660Ab2CZTaL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Mar 2012 15:30:11 -0400
Received: by laai8 with SMTP id i8so288281laa.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:30:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiaoguangrong@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: prio_tree: simplify prio_tree_expand()
has been removed from the -mm tree.  Its filename was
     prio_tree-simplify-prio_tree_expand.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: prio_tree: simplify prio_tree_expand()

In current code, the deleted-node is recorded from first to last,
actually, we can directly attach these node on 'node' we will insert as
the left child, it can let the code more readable.

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/prio_tree.c |   38 ++++++++++++++------------------------
 1 file changed, 14 insertions(+), 24 deletions(-)

diff -puN lib/prio_tree.c~prio_tree-simplify-prio_tree_expand lib/prio_tree.c
--- a/lib/prio_tree.c~prio_tree-simplify-prio_tree_expand
+++ a/lib/prio_tree.c
@@ -94,43 +94,33 @@ static inline unsigned long prio_tree_ma
 static struct prio_tree_node *prio_tree_expand(struct prio_tree_root *root,
 		struct prio_tree_node *node, unsigned long max_heap_index)
 {
-	struct prio_tree_node *first = NULL, *prev, *last = NULL;
+	struct prio_tree_node *prev;
 
 	if (max_heap_index > prio_tree_maxindex(root->index_bits))
 		root->index_bits++;
 
+	prev = node;
+	INIT_PRIO_TREE_NODE(node);
+
 	while (max_heap_index > prio_tree_maxindex(root->index_bits)) {
+		struct prio_tree_node *tmp = root->prio_tree_node;
+
 		root->index_bits++;
 
 		if (prio_tree_empty(root))
 			continue;
 
-		if (first == NULL) {
-			first = root->prio_tree_node;
-			prio_tree_remove(root, root->prio_tree_node);
-			INIT_PRIO_TREE_NODE(first);
-			last = first;
-		} else {
-			prev = last;
-			last = root->prio_tree_node;
-			prio_tree_remove(root, root->prio_tree_node);
-			INIT_PRIO_TREE_NODE(last);
-			prev->left = last;
-			last->parent = prev;
-		}
-	}
-
-	INIT_PRIO_TREE_NODE(node);
+		prio_tree_remove(root, root->prio_tree_node);
+		INIT_PRIO_TREE_NODE(tmp);
 
-	if (first) {
-		node->left = first;
-		first->parent = node;
-	} else
-		last = node;
+		prev->left = tmp;
+		tmp->parent = prev;
+		prev = tmp;
+	}
 
 	if (!prio_tree_empty(root)) {
-		last->left = root->prio_tree_node;
-		last->left->parent = last;
+		prev->left = root->prio_tree_node;
+		prev->left->parent = prev;
 	}
 
 	root->prio_tree_node = node;
_

Patches currently in -mm which might be from xiaoguangrong@linux.vnet.ibm.com are

origin.patch
linux-next.patch

