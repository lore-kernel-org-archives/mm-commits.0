From: akpm@linux-foundation.org
Subject: [patch 068/126] rbtree: add some additional comments for
 rebalancing cases
Date: Fri, 08 Sep 2017 16:14:42 -0700
Message-ID: <20170908231442.stfk4POz5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52770 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753026AbdIHXOo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:14:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@stgolabs.net, dbueso@suse.de, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Davidlohr Bueso <dave@stgolabs.net>
Subject: rbtree: add some additional comments for rebalancing cases

While overall the code is very nicely commented, it might not be
immediately obvious from the diagrams what is going on.  Add a very brief
summary of each case.  Opposite cases where the node is the left child are
left untouched.

Link: http://lkml.kernel.org/r/20170719014603.19029-4-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rbtree.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN lib/rbtree.c~rbtree-add-some-additional-comments-for-rebalancing-cases lib/rbtree.c
--- a/lib/rbtree.c~rbtree-add-some-additional-comments-for-rebalancing-cases
+++ a/lib/rbtree.c
@@ -132,7 +132,7 @@ __rb_insert(struct rb_node *node, struct
 		if (parent != tmp) {	/* parent == gparent->rb_left */
 			if (tmp && rb_is_red(tmp)) {
 				/*
-				 * Case 1 - color flips
+				 * Case 1 - node's uncle is red (color flips).
 				 *
 				 *       G            g
 				 *      / \          / \
@@ -155,7 +155,8 @@ __rb_insert(struct rb_node *node, struct
 			tmp = parent->rb_right;
 			if (node == tmp) {
 				/*
-				 * Case 2 - left rotate at parent
+				 * Case 2 - node's uncle is black and node is
+				 * the parent's right child (left rotate at parent).
 				 *
 				 *      G             G
 				 *     / \           / \
@@ -179,7 +180,8 @@ __rb_insert(struct rb_node *node, struct
 			}
 
 			/*
-			 * Case 3 - right rotate at gparent
+			 * Case 3 - node's uncle is black and node is
+			 * the parent's left child (right rotate at gparent).
 			 *
 			 *        G           P
 			 *       / \         / \
_
