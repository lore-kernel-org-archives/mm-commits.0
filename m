From: akpm@linux-foundation.org
Subject: + radix-tree-account-radix_tree_node-to-memory-cgroup.patch added to -mm tree
Date: Tue, 09 Feb 2016 13:18:11 -0800
Message-ID: <56ba5793.daFboSRN9BzwjMm5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49143 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077AbcBIVSM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Feb 2016 16:18:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: account radix_tree_node to memory cgroup
has been added to the -mm tree.  Its filename is
     radix-tree-account-radix_tree_node-to-memory-cgroup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-account-radix_tree_node-to-memory-cgroup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-account-radix_tree_node-to-memory-cgroup.patch

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
-
+	ret = kmem_cache_alloc(radix_tree_node_cachep,
+			       gfp_mask | __GFP_ACCOUNT);
+out:
 	BUG_ON(radix_tree_is_indirect_ptr(ret));
 	return ret;
 }
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

mm-vmscan-do-not-clear-shrinker_numa_aware-if-nr_node_ids-==-1.patch
mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix-2.patch
mm-memcontrol-do-not-bypass-slab-charge-if-memcg-is-offline.patch
mm-memcontrol-make-tree_statevents-fetch-all-stats.patch
mm-memcontrol-make-tree_statevents-fetch-all-stats-fix.patch
mm-memcontrol-report-slab-usage-in-cgroup2-memorystat.patch
mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat.patch
mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat-v2.patch
proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages-fix.patch
tools-vm-page-typesc-add-memory-cgroup-dumping-and-filtering-fix.patch
mm-memcontrol-enable-kmem-accounting-for-all-cgroups-in-the-legacy-hierarchy.patch
mm-vmscan-pass-root_mem_cgroup-instead-of-null-to-memcg-aware-shrinker.patch
mm-memcontrol-zap-memcg_kmem_online-helper.patch
radix-tree-account-radix_tree_node-to-memory-cgroup.patch
mm-workingset-size-shadow-nodes-lru-basing-on-file-cache-size.patch
mm-workingset-make-shadow-node-shrinker-memcg-aware.patch

