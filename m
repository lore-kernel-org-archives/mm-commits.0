From: akpm@linux-foundation.org
Subject: [patch 067/126] rbtree: optimize root-check during
 rebalancing loop
Date: Fri, 08 Sep 2017 16:14:39 -0700
Message-ID: <20170908231439.Z4ZwHaZ0r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52756 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753026AbdIHXOl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:14:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@stgolabs.net, dbueso@suse.de, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Davidlohr Bueso <dave@stgolabs.net>
Subject: rbtree: optimize root-check during rebalancing loop

The only times the nil-parent (root node) condition is true is when the
node is the first in the tree, or after fixing rbtree rule #4 and the case
1 rebalancing made the node the root.  Such conditions do not apply most
of the time:

(i) The common case in an rbtree is to have more than a single node,
    so this is only true for the first rb_insert().

(ii) While there is a chance only one first rotation is needed, cases
    where the node's uncle is black (cases 2,3) are more common as we can
    have the following scenarios during the rotation looping:

    case1 only, case1+1, case2+3, case1+2+3, case3 only, etc.

This patch, therefore, adds an unlikely() optimization to this
conditional.  When profiling with CONFIG_PROFILE_ANNOTATED_BRANCHES, a
kernel build shows that the incorrect rate is less than 15%, and for
workloads that involve insert mostly trees overtime tend to have less than
2% incorrect rate.

Link: http://lkml.kernel.org/r/20170719014603.19029-3-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rbtree.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff -puN lib/rbtree.c~rbtree-optimize-root-check-during-rebalancing-loop lib/rbtree.c
--- a/lib/rbtree.c~rbtree-optimize-root-check-during-rebalancing-loop
+++ a/lib/rbtree.c
@@ -105,16 +105,25 @@ __rb_insert(struct rb_node *node, struct
 
 	while (true) {
 		/*
-		 * Loop invariant: node is red
-		 *
-		 * If there is a black parent, we are done.
-		 * Otherwise, take some corrective action as we don't
-		 * want a red root or two consecutive red nodes.
+		 * Loop invariant: node is red.
 		 */
-		if (!parent) {
+		if (unlikely(!parent)) {
+			/*
+			 * The inserted node is root. Either this is the
+			 * first node, or we recursed at Case 1 below and
+			 * are no longer violating 4).
+			 */
 			rb_set_parent_color(node, NULL, RB_BLACK);
 			break;
-		} else if (rb_is_black(parent))
+		}
+
+		/*
+		 * If there is a black parent, we are done.
+		 * Otherwise, take some corrective action as,
+		 * per 4), we don't want a red root or two
+		 * consecutive red nodes.
+		 */
+		if(rb_is_black(parent))
 			break;
 
 		gparent = rb_red_parent(parent);
_
