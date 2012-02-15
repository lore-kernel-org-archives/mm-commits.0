From: akpm@linux-foundation.org
Subject: + prio_tree-simplify-prio_tree_expand.patch added to -mm tree
Date: Tue, 14 Feb 2012 16:19:19 -0800
Message-ID: <20120215001919.B739CA0245@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:37706 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761244Ab2BOATV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Feb 2012 19:19:21 -0500
Received: by mail-ey0-f202.google.com with SMTP id f13so14726eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 14 Feb 2012 16:19:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiaoguangrong@linux.vnet.ibm.com


The patch titled
     Subject: prio_tree: simplify prio_tree_expand()
has been added to the -mm tree.  Its filename is
     prio_tree-simplify-prio_tree_expand.patch

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
Subject: Subject: prio_tree: simplify prio_tree_expand()

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

