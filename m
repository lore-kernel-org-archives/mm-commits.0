From: akpm@linux-foundation.org
Subject: [merged]
 radix-tree-account-radix_tree_node-to-memory-cgroup.patch removed from -mm
 tree
Date: Mon, 21 Mar 2016 11:38:55 -0700
Message-ID: <56f03fbf.fPoEAq0yBzBQFhsb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53460 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932302AbcCUT4Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: account radix_tree_node to memory cgroup
has been removed from the -mm tree.  Its filename was
     radix-tree-account-radix_tree_node-to-memory-cgroup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: radix-tree: account radix_tree_node to memory cgroup

Allocation of radix_tree_node objects can be easily triggered from
userspace, so we should account them to memory cgroup.  Besides, we need
them accounted for making shadow node shrinker per memcg (see
mm/workingset.c).

A tricky thing about accounting radix_tree_node objects is that they are
mostly allocated through radix_tree_preload(), so we can't just set
SLAB_ACCOUNT for radix_tree_node_cachep - that would likely result in a
lot of unrelated cgroups using objects from each other's caches.

One way to overcome this would be making radix tree preloads per memcg,
but that would probably look cumbersome and overcomplicated.

Instead, we make radix_tree_node_alloc() first try to allocate from the
cache with __GFP_ACCOUNT, no matter if the caller has preloaded or not,
and only if it fails fall back on using per cpu preloads.  This should
make most allocations accounted.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff -puN lib/radix-tree.c~radix-tree-account-radix_tree_node-to-memory-cgroup lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-account-radix_tree_node-to-memory-cgroup
+++ a/lib/radix-tree.c
@@ -192,6 +192,15 @@ radix_tree_node_alloc(struct radix_tree_
 		struct radix_tree_preload *rtp;
 
 		/*
+		 * Even if the caller has preloaded, try to allocate from the
+		 * cache first for the new node to get accounted.
+		 */
+		ret = kmem_cache_alloc(radix_tree_node_cachep,
+				       gfp_mask | __GFP_ACCOUNT | __GFP_NOWARN);
+		if (ret)
+			goto out;
+
+		/*
 		 * Provided the caller has preloaded here, we will always
 		 * succeed in getting a node here (and never reach
 		 * kmem_cache_alloc)
@@ -208,10 +217,11 @@ radix_tree_node_alloc(struct radix_tree_
 		 * for debugging.
 		 */
 		kmemleak_update_trace(ret);
+		goto out;
 	}
-	if (ret == NULL)
-		ret = kmem_cache_alloc(radix_tree_node_cachep, gfp_mask);
