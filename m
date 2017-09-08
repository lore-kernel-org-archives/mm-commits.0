From: akpm@linux-foundation.org
Subject: [patch 080/126] mem/memcg: cache rightmost node
Date: Fri, 08 Sep 2017 16:15:21 -0700
Message-ID: <20170908231521.q5T11QqF8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52988 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753026AbdIHXPX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:15:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@stgolabs.net, dbueso@suse.de, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, vdavydov.dev@gmail.com

From: Davidlohr Bueso <dave@stgolabs.net>
Subject: mem/memcg: cache rightmost node

Such that we can optimize __mem_cgroup_largest_soft_limit_node().  The
only overhead is the extra footprint for the cached pointer, but this
should not be an issue for mem_cgroup_tree_per_node.

[dave@stgolabs.net: brain fart #2]
  Link: http://lkml.kernel.org/r/20170731160114.GE21328@linux-80c1.suse
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
+		mctz->rb_rightmost = rb_prev(&mz->tree_node);
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
@@ -5945,6 +5957,7 @@ static int __init mem_cgroup_init(void)
 				    node_online(node) ? node : NUMA_NO_NODE);
 
 		rtpn->rb_root = RB_ROOT;
+		rtpn->rb_rightmost = NULL;
 		spin_lock_init(&rtpn->lock);
 		soft_limit_tree.rb_tree_per_node[node] = rtpn;
 	}
_
