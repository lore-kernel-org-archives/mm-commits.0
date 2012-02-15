From: akpm@linux-foundation.org
Subject: + prio_tree-introduce-prio_set_parent.patch added to -mm tree
Date: Tue, 14 Feb 2012 16:19:21 -0800
Message-ID: <20120215001921.D2D07A0245@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:40426 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761284Ab2BOATX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Feb 2012 19:19:23 -0500
Received: by mail-ee0-f74.google.com with SMTP id b15so18086eek.1
        for <mm-commits@vger.kernel.org>; Tue, 14 Feb 2012 16:19:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiaoguangrong@linux.vnet.ibm.com


The patch titled
     Subject: prio_tree: introduce prio_set_parent()
has been added to the -mm tree.  Its filename is
     prio_tree-introduce-prio_set_parent.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: prio_tree: introduce prio_set_parent()

Patches currently in -mm which might be from xiaoguangrong@linux.vnet.ibm.com are

hugetlbfs-fix-hugetlb_get_unmapped_area.patch
hugetlb-drop-prev_vma-in-hugetlb_get_unmapped_area_topdown.patch
hugetlb-try-to-search-again-if-it-is-really-needed.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
mm-do-not-reset-cached_hole_size-when-vma-is-unmapped.patch
mm-search-from-free_area_cache-for-the-bigger-size.patch
prio_tree-remove-unnecessary-code-in-prio_tree_replace.patch
prio_tree-cleanup-prio_tree_left-prio_tree_right.patch
prio_tree-simplify-prio_tree_expand.patch
prio_tree-introduce-prio_set_parent.patch

