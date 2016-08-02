From: akpm@linux-foundation.org
Subject: [patch 019/111] radix-tree: account nodes to memcg only if
 explicitly requested
Date: Tue, 02 Aug 2016 14:03:01 -0700
Message-ID: <57a10a85.93jpS7cZjtGHhnhs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33373 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526AbcHBV4t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 17:56:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@suse.com, stable@vger.kernel.org

From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: radix-tree: account nodes to memcg only if explicitly requested

Radix trees may be used not only for storing page cache pages, so
unconditionally accounting radix tree nodes to the current memory cgroup
is bad: if a radix tree node is used for storing data shared among
different cgroups we risk pinning dead memory cgroups forever. So let's
only account radix tree nodes if it was explicitly requested by passing
__GFP_ACCOUNT to INIT_RADIX_TREE. Currently, we only want to account
page cache entries, so mark mapping->page_tree so.

Fixes: 58e698af4c63 ("radix-tree: account radix_tree_node to memory cgroup")
Link: http://lkml.kernel.org/r/1470057188-7864-1-git-send-email-vdavydov@virtuozzo.com
Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>	[4.6+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c       |    2 +-
 lib/radix-tree.c |   14 ++++++++++----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff -puN fs/inode.c~radix-tree-account-nodes-to-memcg-only-if-explicitly-requested fs/inode.c
--- a/fs/inode.c~radix-tree-account-nodes-to-memcg-only-if-explicitly-requested
+++ a/fs/inode.c
@@ -345,7 +345,7 @@ EXPORT_SYMBOL(inc_nlink);
 void address_space_init_once(struct address_space *mapping)
 {
 	memset(mapping, 0, sizeof(*mapping));
-	INIT_RADIX_TREE(&mapping->page_tree, GFP_ATOMIC);
+	INIT_RADIX_TREE(&mapping->page_tree, GFP_ATOMIC | __GFP_ACCOUNT);
 	spin_lock_init(&mapping->tree_lock);
 	init_rwsem(&mapping->i_mmap_rwsem);
 	INIT_LIST_HEAD(&mapping->private_list);
diff -puN lib/radix-tree.c~radix-tree-account-nodes-to-memcg-only-if-explicitly-requested lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-account-nodes-to-memcg-only-if-explicitly-requested
+++ a/lib/radix-tree.c
@@ -277,10 +277,11 @@ radix_tree_node_alloc(struct radix_tree_
 
 		/*
 		 * Even if the caller has preloaded, try to allocate from the
-		 * cache first for the new node to get accounted.
+		 * cache first for the new node to get accounted to the memory
+		 * cgroup.
 		 */
 		ret = kmem_cache_alloc(radix_tree_node_cachep,
-				       gfp_mask | __GFP_ACCOUNT | __GFP_NOWARN);
+				       gfp_mask | __GFP_NOWARN);
 		if (ret)
 			goto out;
 
@@ -303,8 +304,7 @@ radix_tree_node_alloc(struct radix_tree_
 		kmemleak_update_trace(ret);
 		goto out;
 	}
-	ret = kmem_cache_alloc(radix_tree_node_cachep,
-			       gfp_mask | __GFP_ACCOUNT);
+	ret = kmem_cache_alloc(radix_tree_node_cachep, gfp_mask);
 out:
 	BUG_ON(radix_tree_is_internal_node(ret));
 	return ret;
@@ -351,6 +351,12 @@ static int __radix_tree_preload(gfp_t gf
 	struct radix_tree_node *node;
 	int ret = -ENOMEM;
 
+	/*
+	 * Nodes preloaded by one cgroup can be be used by another cgroup, so
+	 * they should never be accounted to any particular memory cgroup.
+	 */
+	gfp_mask &= ~__GFP_ACCOUNT;
+
 	preempt_disable();
 	rtp = this_cpu_ptr(&radix_tree_preloads);
 	while (rtp->nr < nr) {
_
