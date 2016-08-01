From: akpm@linux-foundation.org
Subject: +
 radix-tree-account-nodes-to-memcg-only-if-explicitly-requested.patch added
 to -mm tree
Date: Mon, 01 Aug 2016 14:20:22 -0700
Message-ID: <579fbd16.FWbSPU45IQkrdKG1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42837 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbcHAVUY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Aug 2016 17:20:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: account nodes to memcg only if explicitly requested
has been added to the -mm tree.  Its filename is
     radix-tree-account-nodes-to-memcg-only-if-explicitly-requested.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-account-nodes-to-memcg-only-if-explicitly-requested.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-account-nodes-to-memcg-only-if-explicitly-requested.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: radix-tree: account nodes to memcg only if explicitly requested

Radix trees may be used not only for storing page cache pages, so
unconditionally accounting radix tree nodes to the current memory cgroup
is bad: if a radix tree node is used for storing data shared among
different cgroups we risk pinning dead memory cgroups forever. So let's
only account radix tree nodes if it was explicitly requested by passing
__GFP_ACCOUNT to INIT_RADIX_TREE. Currently, we only want to account
page cache entries, so mark mapping->page_tree so.

Link: http://lkml.kernel.org/r/1470057188-7864-1-git-send-email-vdavydov@virtuozzo.com
Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
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

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

radix-tree-account-nodes-to-memcg-only-if-explicitly-requested.patch
mm-memcontrol-fix-swap-counter-leak-on-swapout-from-offline-cgroup.patch
mm-memcontrol-fix-memcg-id-ref-counter-on-swap-charge-move.patch
mm-memcontrol-add-sanity-checks-for-memcg-idref-on-get-put.patch

