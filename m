From: akpm@linux-foundation.org
Subject: + rb_tree-reorganize-code-in-rb_erase-for-additional-changes.patch added to -mm tree
Date: Tue, 14 Apr 2009 16:41:19 -0700
Message-ID: <200904142341.n3ENfJec031269@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52745 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751630AbZDNXnW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 19:43:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wstrepp@gmx.de, a.p.zijlstra@chello.nl


The patch titled
     rb_tree: reorganize code in rb_erase() for additional changes
has been added to the -mm tree.  Its filename is
     rb_tree-reorganize-code-in-rb_erase-for-additional-changes.patch

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
Subject: rb_tree: reorganize code in rb_erase() for additional changes
From: "Wolfram Strepp" <wstrepp@gmx.de>

First, move some code around in order to make the next change more obvious.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Wolfram Strepp <wstrepp@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rbtree.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff -puN lib/rbtree.c~rb_tree-reorganize-code-in-rb_erase-for-additional-changes lib/rbtree.c
--- a/lib/rbtree.c~rb_tree-reorganize-code-in-rb_erase-for-additional-changes
+++ a/lib/rbtree.c
@@ -231,6 +231,16 @@ void rb_erase(struct rb_node *node, stru
 		node = node->rb_right;
 		while ((left = node->rb_left) != NULL)
 			node = left;
+
+		if (rb_parent(old))
+		{
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
@@ -247,15 +257,6 @@ void rb_erase(struct rb_node *node, stru
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
