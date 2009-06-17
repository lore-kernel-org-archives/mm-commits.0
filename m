From: akpm@linux-foundation.org
Subject: [merged] rb_tree-remove-redundant-if-condition-in-rb_erase.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:38:47 -0700
Message-ID: <200906171838.n5HIclid004800@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57256 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756582AbZFQSji (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:39:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wstrepp@gmx.de, a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     rb_tree: remove redundant if()-condition in rb_erase()
has been removed from the -mm tree.  Its filename was
     rb_tree-remove-redundant-if-condition-in-rb_erase.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rb_tree: remove redundant if()-condition in rb_erase()
From: "Wolfram Strepp" <wstrepp@gmx.de>

Furthermore, notice that the initial checks:

	if (!node->rb_left)
		child = node->rb_right;
	else if (!node->rb_right)
		child = node->rb_left;
	else
	{
		...
	}
guarantee that old->rb_right is set in the final else branch, therefore
we can omit checking that again.

Signed-off-by: Wolfram Strepp <wstrepp@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rbtree.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN lib/rbtree.c~rb_tree-remove-redundant-if-condition-in-rb_erase lib/rbtree.c
--- a/lib/rbtree.c~rb_tree-remove-redundant-if-condition-in-rb_erase
+++ a/lib/rbtree.c
@@ -250,15 +250,15 @@ void rb_erase(struct rb_node *node, stru
 			if (child)
 				rb_set_parent(child, parent);
 			parent->rb_left = child;
+
+			node->rb_right = old->rb_right;
+			rb_set_parent(old->rb_right, node);
 		}
 
 		node->rb_parent_color = old->rb_parent_color;
-		node->rb_right = old->rb_right;
 		node->rb_left = old->rb_left;
