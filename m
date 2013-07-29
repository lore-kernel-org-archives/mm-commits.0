From: akpm@linux-foundation.org
Subject: + rbtree-add-postorder-iteration-functions.patch added to -mm
 tree
Date: Mon, 29 Jul 2013 15:43:55 -0700
Message-ID: <51f6f02b.N+rR3THf6I4QqURs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60485 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090Ab3G2Wn4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jul 2013 18:43:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, sjenning@linux.vnet.ibm.com, riel@redhat.com, David.Woodhouse@intel.com, cody@linux.vnet.ibm.com

Subject: + rbtree-add-postorder-iteration-functions.patch added to -mm tree
To: cody@linux.vnet.ibm.com,David.Woodhouse@intel.com,riel@redhat.com,sjenning@linux.vnet.ibm.com,walken@google.com
From: akpm@linux-foundation.org
Date: Mon, 29 Jul 2013 15:43:55 -0700


The patch titled
     Subject: rbtree: add postorder iteration functions
has been added to the -mm tree.  Its filename is
     rbtree-add-postorder-iteration-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rbtree-add-postorder-iteration-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rbtree-add-postorder-iteration-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: rbtree: add postorder iteration functions

Postorder iteration yields all of a node's children prior to yielding the
node itself, and this particular implementation also avoids examining the
leaf links in a node after that node has been yielded.

In what I expect will be its most common usage, postorder iteration allows
the deletion of every node in an rbtree without modifying the rbtree nodes
(no _requirement_ that they be nulled) while avoiding referencing child
nodes after they have been "deleted" (most commonly, freed).

I have only updated zswap to use this functionality at this point, but
numerous bits of code (most notably in the filesystem drivers) use a hand
rolled postorder iteration that NULLs child links as it traverses the
tree.  Each of those instances could be replaced with this common
implementation.

1 & 2 add rbtree postorder iteration functions.
3 adds testing of the iteration to the rbtree runtime tests
4 allows building the rbtree runtime tests as builtins
5 updates zswap.


This patch:

Add postorder iteration functions for rbtree.  These are useful for safely
freeing an entire rbtree without modifying the tree at all.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Reviewed-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: David Woodhouse <David.Woodhouse@intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rbtree.h |    4 +++
 lib/rbtree.c           |   40 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff -puN include/linux/rbtree.h~rbtree-add-postorder-iteration-functions include/linux/rbtree.h
--- a/include/linux/rbtree.h~rbtree-add-postorder-iteration-functions
+++ a/include/linux/rbtree.h
@@ -68,6 +68,10 @@ extern struct rb_node *rb_prev(const str
 extern struct rb_node *rb_first(const struct rb_root *);
 extern struct rb_node *rb_last(const struct rb_root *);
 
+/* Postorder iteration - always visit the parent after its children */
+extern struct rb_node *rb_first_postorder(const struct rb_root *);
+extern struct rb_node *rb_next_postorder(const struct rb_node *);
+
 /* Fast replacement of a single node without remove/rebalance/add/rebalance */
 extern void rb_replace_node(struct rb_node *victim, struct rb_node *new, 
 			    struct rb_root *root);
diff -puN lib/rbtree.c~rbtree-add-postorder-iteration-functions lib/rbtree.c
--- a/lib/rbtree.c~rbtree-add-postorder-iteration-functions
+++ a/lib/rbtree.c
@@ -518,3 +518,43 @@ void rb_replace_node(struct rb_node *vic
 	*new = *victim;
 }
 EXPORT_SYMBOL(rb_replace_node);
+
+static struct rb_node *rb_left_deepest_node(const struct rb_node *node)
+{
+	for (;;) {
+		if (node->rb_left)
+			node = node->rb_left;
+		else if (node->rb_right)
+			node = node->rb_right;
+		else
+			return (struct rb_node *)node;
+	}
+}
+
+struct rb_node *rb_next_postorder(const struct rb_node *node)
+{
+	const struct rb_node *parent;
+	if (!node)
+		return NULL;
+	parent = rb_parent(node);
+
+	/* If we're sitting on node, we've already seen our children */
+	if (parent && node == parent->rb_left && parent->rb_right) {
+		/* If we are the parent's left node, go to the parent's right
+		 * node then all the way down to the left */
+		return rb_left_deepest_node(parent->rb_right);
+	} else
+		/* Otherwise we are the parent's right node, and the parent
+		 * should be next */
+		return (struct rb_node *)parent;
+}
+EXPORT_SYMBOL(rb_next_postorder);
+
+struct rb_node *rb_first_postorder(const struct rb_root *root)
+{
+	if (!root->rb_node)
+		return NULL;
+
+	return rb_left_deepest_node(root->rb_node);
+}
+EXPORT_SYMBOL(rb_first_postorder);
_

Patches currently in -mm which might be from cody@linux.vnet.ibm.com are

mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug.patch
mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug-fix.patch
mm-fix-the-value-of-fallback_migratetype-in-alloc_extfrag-tracepoint.patch
rbtree-add-postorder-iteration-functions.patch
rbtree-add-rbtree_postorder_for_each_entry_safe-helper.patch
rbtree_test-add-test-for-postorder-iteration.patch
rbtree-allow-tests-to-run-as-builtin.patch
mm-zswap-use-postorder-iteration-when-destroying-rbtree.patch

