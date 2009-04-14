From: akpm@linux-foundation.org
Subject: + rb_tree-make-clear-distinction-between-two-different-cases-in-rb_erase.patch added to -mm tree
Date: Tue, 14 Apr 2009 16:41:49 -0700
Message-ID: <200904142341.n3ENfoBv031499@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752011AbZDNXnb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 19:43:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wstrepp@gmx.de, a.p.zijlstra@chello.nl


The patch titled
     rb_tree: make clear distinction between two different cases in rb_erase()
has been added to the -mm tree.  Its filename is
     rb_tree-make-clear-distinction-between-two-different-cases-in-rb_erase.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rb_tree: make clear distinction between two different cases in rb_erase()
From: "Wolfram Strepp" <wstrepp@gmx.de>

There are two cases when a node, having 2 childs, is erased:
'normal case': the successor is not the right-hand-child of the node to be erased
'special case': the successor is the right-hand child of the node to be erased

Here some ascii-art, with following symbols (referring to the code):
O: node to be deleted
N: the successor of O
P: parent of N
C: child of N
L: some other node

normal case:

               O                         N
              / \                       / \
             /   \                     /   \
            L     \                   L     \
           / \     P      ---->      / \     P
                  / \                       / \
                 /                         /
                N                         C
                 \                       / \
                  \
                   C
                  / \

special case:
              O|P                        N
              / \                       / \
             /   \                     /   \
            L     \                   L     \
           / \     N      ---->      /       C
                    \                       / \
                     \
                      C
                     / \

Notice that for the special case we don't have to reconnect C to N.

Signed-off-by: Wolfram Strepp <wstrepp@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rbtree.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN lib/rbtree.c~rb_tree-make-clear-distinction-between-two-different-cases-in-rb_erase lib/rbtree.c
--- a/lib/rbtree.c~rb_tree-make-clear-distinction-between-two-different-cases-in-rb_erase
+++ a/lib/rbtree.c
@@ -244,13 +244,13 @@ void rb_erase(struct rb_node *node, stru
 		parent = rb_parent(node);
 		color = rb_color(node);
 
-		if (child)
-			rb_set_parent(child, parent);
 		if (parent == old) {
-			parent->rb_right = child;
 			parent = node;
-		} else
+		} else {
+			if (child)
+				rb_set_parent(child, parent);
 			parent->rb_left = child;
+		}
 
 		node->rb_parent_color = old->rb_parent_color;
 		node->rb_right = old->rb_right;
_

Patches currently in -mm which might be from wstrepp@gmx.de are

rb_tree-reorganize-code-in-rb_erase-for-additional-changes.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
rb_tree-make-clear-distinction-between-two-different-cases-in-rb_erase.patch
rb_tree-remove-redundant-if-condition-in-rb_erase.patch

