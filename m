From: akpm@linux-foundation.org
Subject: + rb_tree-remove-redundant-if-condition-in-rb_erase.patch added to -mm tree
Date: Tue, 14 Apr 2009 16:41:52 -0700
Message-ID: <200904142341.n3ENfq0C031502@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47726 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752011AbZDNXnl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 19:43:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wstrepp@gmx.de, a.p.zijlstra@chello.nl


The patch titled
     rb_tree: remove redundant if()-condition in rb_erase()
has been added to the -mm tree.  Its filename is
     rb_tree-remove-redundant-if-condition-in-rb_erase.patch

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
