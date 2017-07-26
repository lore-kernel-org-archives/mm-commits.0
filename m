From: akpm@linux-foundation.org
Subject: + mem-memcg-cache-rightmost-node.patch added to -mm tree
Date: Wed, 26 Jul 2017 14:15:03 -0700
Message-ID: <59790657.zt/5sCO1/g2VTBiM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60224 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751109AbdGZVPE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jul 2017 17:15:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mem/memcg: cache rightmost node
has been added to the -mm tree.  Its filename is
     mem-memcg-cache-rightmost-node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mem-memcg-cache-rightmost-node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mem-memcg-cache-rightmost-node.patch

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
Subject: mem/memcg: cache rightmost node

Such that we can optimize __mem_cgroup_largest_soft_limit_node().  The
only overhead is the extra footprint for the cached pointer, but this
should not be an issue for mem_cgroup_tree_per_node.

Link: http://lkml.kernel.org/r/20170719014603.19029-17-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff -puN mm/memcontrol.c~mem-memcg-cache-rightmost-node mm/memcontrol.c
--- a/mm/memcontrol.c~mem-memcg-cache-rightmost-node
+++ a/mm/memcontrol.c
@@ -119,6 +119,7 @@ static const char *const mem_cgroup_lru_
 
 struct mem_cgroup_tree_per_node {
 	struct rb_root rb_root;
+	struct rb_node *rb_rightmost;
 	spinlock_t lock;
 };
 
@@ -386,6 +387,7 @@ static void __mem_cgroup_insert_exceeded
 	struct rb_node **p = &mctz->rb_root.rb_node;
 	struct rb_node *parent = NULL;
 	struct mem_cgroup_per_node *mz_node;
+	bool rightmost = true;
 
 	if (mz->on_tree)
 		return;
@@ -397,8 +399,11 @@ static void __mem_cgroup_insert_exceeded
 		parent = *p;
 		mz_node = rb_entry(parent, struct mem_cgroup_per_node,
 					tree_node);
-		if (mz->usage_in_excess < mz_node->usage_in_excess)
+		if (mz->usage_in_excess < mz_node->usage_in_excess) {
 			p = &(*p)->rb_left;
+			rightmost = false;
+		}
+
 		/*
 		 * We can't avoid mem cgroups that are over their soft
 		 * limit by the same amount
@@ -406,6 +411,10 @@ static void __mem_cgroup_insert_exceeded
 		else if (mz->usage_in_excess >= mz_node->usage_in_excess)
 			p = &(*p)->rb_right;
 	}
+
+	if (rightmost)
+		mctz->rb_rightmost = &mz->tree_node;
+
 	rb_link_node(&mz->tree_node, parent, p);
 	rb_insert_color(&mz->tree_node, &mctz->rb_root);
 	mz->on_tree = true;
@@ -416,6 +425,10 @@ static void __mem_cgroup_remove_exceeded
 {
 	if (!mz->on_tree)
 		return;
+
+	if (&mz->tree_node == mctz->rb_rightmost)
+		mctz->rb_rightmost = rb_next(&mz->tree_node);
+
 	rb_erase(&mz->tree_node, &mctz->rb_root);
 	mz->on_tree = false;
 }
@@ -496,16 +509,15 @@ static void mem_cgroup_remove_from_trees
 static struct mem_cgroup_per_node *
 __mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_node *mctz)
 {
-	struct rb_node *rightmost = NULL;
 	struct mem_cgroup_per_node *mz;
 
 retry:
 	mz = NULL;
-	rightmost = rb_last(&mctz->rb_root);
-	if (!rightmost)
+	if (!mctz->rb_rightmost)
 		goto done;		/* Nothing to reclaim from */
 
-	mz = rb_entry(rightmost, struct mem_cgroup_per_node, tree_node);
+	mz = rb_entry(mctz->rb_rightmost,
+		      struct mem_cgroup_per_node, tree_node);
 	/*
 	 * Remove the node now but someone else can add it back,
 	 * we will to add it back at the end of reclaim to its correct
@@ -5855,6 +5867,7 @@ static int __init mem_cgroup_init(void)
 				    node_online(node) ? node : NUMA_NO_NODE);
 
 		rtpn->rb_root = RB_ROOT;
+		rtpn->rb_rightmost = NULL;
 		spin_lock_init(&rtpn->lock);
 		soft_limit_tree.rb_tree_per_node[node] = rtpn;
 	}
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

