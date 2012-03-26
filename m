From: akpm@linux-foundation.org
Subject: [merged] prio_tree-introduce-prio_set_parent.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:30:11 -0700
Message-ID: <20120326193011.4F3CEA00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:40916 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679Ab2CZTaN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:30:13 -0400
Received: by mail-lb0-f202.google.com with SMTP id gj3so288108lbb.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:30:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiaoguangrong@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: prio_tree: introduce prio_set_parent()
has been removed from the -mm tree.  Its filename was
     prio_tree-introduce-prio_set_parent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: prio_tree: introduce prio_set_parent()

Introduce prio_set_parent() to abstract the operation which is used to
attach the node to its parent.

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/prio_tree.c |   47 +++++++++++++++++++++-------------------------
 1 file changed, 22 insertions(+), 25 deletions(-)

diff -puN lib/prio_tree.c~prio_tree-introduce-prio_set_parent lib/prio_tree.c
--- a/lib/prio_tree.c~prio_tree-introduce-prio_set_parent
+++ a/lib/prio_tree.c
@@ -85,6 +85,17 @@ static inline unsigned long prio_tree_ma
 	return index_bits_to_maxindex[bits - 1];
 }
 
+static void prio_set_parent(struct prio_tree_node *parent,
+			    struct prio_tree_node *child, bool left)
+{
+	if (left)
+		parent->left = child;
+	else
+		parent->right = child;
+
+	child->parent = parent;
+}
+
 /*
  * Extend a priority search tree so that it can store a node with heap_index
  * max_heap_index. In the worst case, this algorithm takes O((log n)^2).
@@ -113,15 +124,12 @@ static struct prio_tree_node *prio_tree_
 		prio_tree_remove(root, root->prio_tree_node);
 		INIT_PRIO_TREE_NODE(tmp);
 
-		prev->left = tmp;
-		tmp->parent = prev;
+		prio_set_parent(prev, tmp, true);
 		prev = tmp;
 	}
 
-	if (!prio_tree_empty(root)) {
-		prev->left = root->prio_tree_node;
-		prev->left->parent = prev;
-	}
+	if (!prio_tree_empty(root))
+		prio_set_parent(prev, root->prio_tree_node, true);
 
 	root->prio_tree_node = node;
 	return node;
@@ -142,23 +150,14 @@ struct prio_tree_node *prio_tree_replace
 		 * and does not help much to improve performance (IMO).
 		 */
 		root->prio_tree_node = node;
-	} else {
-		node->parent = old->parent;
-		if (old->parent->left == old)
-			old->parent->left = node;
-		else
-			old->parent->right = node;
-	}
+	} else
+		prio_set_parent(old->parent, node, old->parent->left == old);
 
-	if (!prio_tree_left_empty(old)) {
-		node->left = old->left;
-		old->left->parent = node;
-	}
+	if (!prio_tree_left_empty(old))
+		prio_set_parent(node, old->left, true);
 
-	if (!prio_tree_right_empty(old)) {
-		node->right = old->right;
-		old->right->parent = node;
-	}
+	if (!prio_tree_right_empty(old))
+		prio_set_parent(node, old->right, false);
 
 	return old;
 }
@@ -218,16 +217,14 @@ struct prio_tree_node *prio_tree_insert(
 		if (index & mask) {
 			if (prio_tree_right_empty(cur)) {
 				INIT_PRIO_TREE_NODE(node);
-				cur->right = node;
-				node->parent = cur;
+				prio_set_parent(cur, node, false);
 				return res;
 			} else
 				cur = cur->right;
 		} else {
 			if (prio_tree_left_empty(cur)) {
 				INIT_PRIO_TREE_NODE(node);
-				cur->left = node;
-				node->parent = cur;
+				prio_set_parent(cur, node, true);
 				return res;
 			} else
 				cur = cur->left;
_

Patches currently in -mm which might be from xiaoguangrong@linux.vnet.ibm.com are

origin.patch
linux-next.patch

