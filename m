From: akpm@linux-foundation.org
Subject: + block-cfq-cache-rightmost-rb_node-fix.patch added to -mm tree
Date: Mon, 31 Jul 2017 14:29:08 -0700
Message-ID: <597fa124.PYi3bjFHZXWFTUzO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45250 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751046AbdGaV3I (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Jul 2017 17:29:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, mm-commits@vger.kernel.org


The patch titled
     Subject: block-cfq-cache-rightmost-rb_node-fix
has been added to the -mm tree.  Its filename is
     block-cfq-cache-rightmost-rb_node-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/block-cfq-cache-rightmost-rb_node-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/block-cfq-cache-rightmost-rb_node-fix.patch

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
Subject: block-cfq-cache-rightmost-rb_node-fix

Brain fart #1, please fold.

index 57ec45fd4590..4992e9acddad 100644
Link: http://lkml.kernel.org/r/20170731155955.GD21328@linux-80c1.suse

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/cfq-iosched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN block/cfq-iosched.c~block-cfq-cache-rightmost-rb_node-fix block/cfq-iosched.c
--- a/block/cfq-iosched.c~block-cfq-cache-rightmost-rb_node-fix
+++ a/block/cfq-iosched.c
@@ -1186,7 +1186,7 @@ static struct cfq_group *cfq_rb_first_gr
 static void cfq_rb_erase(struct rb_node *n, struct cfq_rb_root *root)
 {
 	if (root->rb_rightmost == n)
-		root->rb_rightmost = rb_next(n);
+		root->rb_rightmost = rb_prev(n);
 
 	rb_erase_cached(n, &root->rb);
 	RB_CLEAR_NODE(n);
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
mem-memcg-cache-rightmost-node-fix.patch
block-cfq-cache-rightmost-rb_node.patch
block-cfq-cache-rightmost-rb_node-fix.patch

