From: akpm@linux-foundation.org
Subject: + prio_tree-cleanup-prio_tree_left-prio_tree_right.patch added to -mm tree
Date: Tue, 14 Feb 2012 16:19:17 -0800
Message-ID: <20120215001917.DDA28A0245@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:40426 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761103Ab2BOATU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Feb 2012 19:19:20 -0500
Received: by eekb15 with SMTP id b15so18086eek.1
        for <mm-commits@vger.kernel.org>; Tue, 14 Feb 2012 16:19:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiaoguangrong@linux.vnet.ibm.com


The patch titled
     Subject: prio_tree: cleanup prio_tree_left()/prio_tree_right()
has been added to the -mm tree.  Its filename is
     prio_tree-cleanup-prio_tree_left-prio_tree_right.patch

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
Subject: prio_tree: cleanup prio_tree_left()/prio_tree_right()

Introduce iter_walk_down()/iter_walk_up() to remove the common code
between prio_tree_left() and prio_tree_right().

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/prio_tree.c |   78 +++++++++++++++++++++-------------------------
 1 file changed, 37 insertions(+), 41 deletions(-)

diff -puN lib/prio_tree.c~prio_tree-cleanup-prio_tree_left-prio_tree_right lib/prio_tree.c
--- a/lib/prio_tree.c~prio_tree-cleanup-prio_tree_left-prio_tree_right
+++ a/lib/prio_tree.c
@@ -304,6 +304,40 @@ void prio_tree_remove(struct prio_tree_r
 		cur = prio_tree_replace(root, cur->parent, cur);
 }
 
+static void iter_walk_down(struct prio_tree_iter *iter)
+{
+	iter->mask >>= 1;
+	if (iter->mask) {
+		if (iter->size_level)
+			iter->size_level++;
+		return;
+	}
+
+	if (iter->size_level) {
+		BUG_ON(!prio_tree_left_empty(iter->cur));
+		BUG_ON(!prio_tree_right_empty(iter->cur));
+		iter->size_level++;
+		iter->mask = ULONG_MAX;
+	} else {
+		iter->size_level = 1;
+		iter->mask = 1UL << (BITS_PER_LONG - 1);
+	}
+}
+
+static void iter_walk_up(struct prio_tree_iter *iter)
+{
+	if (iter->mask == ULONG_MAX)
+		iter->mask = 1UL;
+	else if (iter->size_level == 1)
+		iter->mask = 1UL;
+	else
+		iter->mask <<= 1;
+	if (iter->size_level)
+		iter->size_level--;
+	if (!iter->size_level && (iter->value & iter->mask))
+		iter->value ^= iter->mask;
+}
+
 /*
  * Following functions help to enumerate all prio_tree_nodes in the tree that
  * overlap with the input interval X [radix_index, heap_index]. The enumeration
@@ -322,21 +356,7 @@ static struct prio_tree_node *prio_tree_
 
 	if (iter->r_index <= *h_index) {
 		iter->cur = iter->cur->left;
-		iter->mask >>= 1;
-		if (iter->mask) {
-			if (iter->size_level)
-				iter->size_level++;
-		} else {
-			if (iter->size_level) {
-				BUG_ON(!prio_tree_left_empty(iter->cur));
-				BUG_ON(!prio_tree_right_empty(iter->cur));
-				iter->size_level++;
-				iter->mask = ULONG_MAX;
-			} else {
-				iter->size_level = 1;
-				iter->mask = 1UL << (BITS_PER_LONG - 1);
-			}
-		}
+		iter_walk_down(iter);
 		return iter->cur;
 	}
 
@@ -363,22 +383,7 @@ static struct prio_tree_node *prio_tree_
 
 	if (iter->r_index <= *h_index) {
 		iter->cur = iter->cur->right;
-		iter->mask >>= 1;
-		iter->value = value;
-		if (iter->mask) {
-			if (iter->size_level)
-				iter->size_level++;
-		} else {
-			if (iter->size_level) {
-				BUG_ON(!prio_tree_left_empty(iter->cur));
-				BUG_ON(!prio_tree_right_empty(iter->cur));
-				iter->size_level++;
-				iter->mask = ULONG_MAX;
-			} else {
-				iter->size_level = 1;
-				iter->mask = 1UL << (BITS_PER_LONG - 1);
-			}
-		}
+		iter_walk_down(iter);
 		return iter->cur;
 	}
 
@@ -388,16 +393,7 @@ static struct prio_tree_node *prio_tree_
 static struct prio_tree_node *prio_tree_parent(struct prio_tree_iter *iter)
 {
 	iter->cur = iter->cur->parent;
-	if (iter->mask == ULONG_MAX)
-		iter->mask = 1UL;
-	else if (iter->size_level == 1)
-		iter->mask = 1UL;
-	else
-		iter->mask <<= 1;
-	if (iter->size_level)
-		iter->size_level--;
-	if (!iter->size_level && (iter->value & iter->mask))
-		iter->value ^= iter->mask;
+	iter_walk_up(iter);
 	return iter->cur;
 }
 
_
Subject: Subject: prio_tree: cleanup prio_tree_left()/prio_tree_right()

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

