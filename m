From: akpm@linux-foundation.org
Subject: + rbtree-optimize-root-check-during-rebalancing-loop.patch added
 to -mm tree
Date: Wed, 26 Jul 2017 14:14:03 -0700
Message-ID: <5979061b.ewBTk3K1R0z+BqcK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60112 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750996AbdGZVOE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jul 2017 17:14:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: rbtree: optimize root-check during rebalancing loop
has been added to the -mm tree.  Its filename is
     rbtree-optimize-root-check-during-rebalancing-loop.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rbtree-optimize-root-check-during-rebalancing-loop.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rbtree-optimize-root-check-during-rebalancing-loop.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Signed-off-by: Andrew Morton <>
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

Patches currently in -mm which might be from dave@stgolabs.net are

rbtree-cache-leftmost-node-internally.patch
rbtree-optimize-root-check-during-rebalancing-loop.patch
rbtree-add-some-additional-comments-for-rebalancing-cases.patch
lib-rbtree_testc-make-input-module-parameters.patch
lib-rbtree_testc-add-inorder-traversal-test.patch
lib-rbtree_testc-support-rb_root_cached.patch
sched-fair-replace-cfs_rq-rb_leftmost.patch
sched-deadline-replace-earliest-dl-and-rq-leftmost-caching.patch
locking-rtmutex-replace-top-waiter-and-pi_waiters-leftmost-caching.patch
block-cfq-replace-cfq_rb_root-leftmost-caching.patch
lib-interval_tree-fast-overlap-detection.patch
lib-interval-tree-correct-comment-wrt-generic-flavor.patch
procfs-use-faster-rb_first_cached.patch
fs-epoll-use-faster-rb_first_cached.patch
mem-memcg-cache-rightmost-node.patch
block-cfq-cache-rightmost-rb_node.patch

