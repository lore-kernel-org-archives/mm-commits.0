From: akpm@linux-foundation.org
Subject: [merged] prio_tree-cleanup-prio_tree_left-prio_tree_right.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:30:07 -0700
Message-ID: <20120326193007.51FC6A00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:54481 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab2CZTaI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:30:08 -0400
Received: by vbnl22 with SMTP id l22so508210vbn.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:30:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiaoguangrong@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: prio_tree: cleanup prio_tree_left()/prio_tree_right()
has been removed from the -mm tree.  Its filename was
     prio_tree-cleanup-prio_tree_left-prio_tree_right.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from xiaoguangrong@linux.vnet.ibm.com are

origin.patch
linux-next.patch

