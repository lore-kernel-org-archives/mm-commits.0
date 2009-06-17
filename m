From: akpm@linux-foundation.org
Subject: [merged] rb_tree-reorganize-code-in-rb_erase-for-additional-changes.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:38:43 -0700
Message-ID: <200906171838.n5HIchHn004793@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38047 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758970AbZFQSqA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:46:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wstrepp@gmx.de, a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     rb_tree: reorganize code in rb_erase() for additional changes
has been removed from the -mm tree.  Its filename was
     rb_tree-reorganize-code-in-rb_erase-for-additional-changes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rb_tree: reorganize code in rb_erase() for additional changes
From: "Wolfram Strepp" <wstrepp@gmx.de>

First, move some code around in order to make the next change more obvious.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Wolfram Strepp <wstrepp@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rbtree.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN lib/rbtree.c~rb_tree-reorganize-code-in-rb_erase-for-additional-changes lib/rbtree.c
--- a/lib/rbtree.c~rb_tree-reorganize-code-in-rb_erase-for-additional-changes
+++ a/lib/rbtree.c
@@ -231,6 +231,15 @@ void rb_erase(struct rb_node *node, stru
 		node = node->rb_right;
 		while ((left = node->rb_left) != NULL)
 			node = left;
+
+		if (rb_parent(old)) {
+			if (rb_parent(old)->rb_left == old)
+				rb_parent(old)->rb_left = node;
+			else
+				rb_parent(old)->rb_right = node;
+		} else
+			root->rb_node = node;
+
 		child = node->rb_right;
 		parent = rb_parent(node);
 		color = rb_color(node);
@@ -247,15 +256,6 @@ void rb_erase(struct rb_node *node, stru
 		node->rb_right = old->rb_right;
 		node->rb_left = old->rb_left;
 
-		if (rb_parent(old))
-		{
-			if (rb_parent(old)->rb_left == old)
-				rb_parent(old)->rb_left = node;
-			else
-				rb_parent(old)->rb_right = node;
-		} else
-			root->rb_node = node;
