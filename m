From: akpm@linux-foundation.org
Subject: [merged]
 memcg-also-test-for-skip-accounting-at-the-page-allocation-level.patch
 removed from -mm tree
Date: Tue, 09 Jul 2013 16:19:43 -0700
Message-ID: <51dc9a8f.gdPYBSi/uod8iuX0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38842 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928Ab3GIXTo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:19:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suze.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, glommer@openvz.org, glommer@gmail.com

Subject: [merged] memcg-also-test-for-skip-accounting-at-the-page-allocation-level.patch removed from -mm tree
To: glommer@gmail.com,glommer@openvz.org,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suze.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:19:43 -0700


The patch titled
     Subject: memcg: also test for skip accounting at the page allocation level
has been removed from the -mm tree.  Its filename was
     memcg-also-test-for-skip-accounting-at-the-page-allocation-level.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Glauber Costa <glommer@gmail.com>
Subject: memcg: also test for skip accounting at the page allocation level

The memory we used to hold the memcg arrays is currently accounted to the
current memcg.  But that creates a problem, because that memory can only
be freed after the last user is gone.  Our only way to know which is the
last user, is to hook up to freeing time, but the fact that we still have
some in flight kmallocs will prevent freeing to happen.  I believe
therefore to be just easier to account this memory as global overhead.


This patch (of 2):

Disabling accounting is only relevant for some specific memcg internal
allocations.  Therefore we would initially not have such check at
memcg_kmem_newpage_charge, since direct calls to the page allocator that
are marked with GFP_KMEMCG only happen outside memcg core.  We are mostly
concerned with cache allocations and by having this test at
memcg_kmem_get_cache we are already able to relay the allocation to the
root cache and bypass the memcg caches altogether.

There is one exception, though: the SLUB allocator does not create large
order caches, but rather service large kmallocs directly from the page
allocator.  Therefore, the following sequence, when backed by the SLUB
allocator:

	memcg_stop_kmem_account();
	kmalloc(<large_number>)
	memcg_resume_kmem_account();

would effectively ignore the fact that we should skip accounting, since it
will drive us directly to this function without passing through the cache
selector memcg_kmem_get_cache.  Such large allocations are extremely rare
but can happen, for instance, for the cache arrays.

This was never a problem in practice, because we weren't skipping
accounting for the cache arrays.  All the allocations we were skipping
were fairly small.  However, the fact that we were not skipping those
allocations are a problem and can prevent the memcgs from going away.  As
we fix that, we need to make sure that the fix will also work with the
SLUB allocator.

Signed-off-by: Glauber Costa <glommer@openvz.org>
Reported-by: Michal Hocko <mhocko@suze.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff -puN mm/memcontrol.c~memcg-also-test-for-skip-accounting-at-the-page-allocation-level mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-also-test-for-skip-accounting-at-the-page-allocation-level
+++ a/mm/memcontrol.c
@@ -3637,6 +3637,34 @@ __memcg_kmem_newpage_charge(gfp_t gfp, s
 	int ret;
 
 	*_memcg = NULL;
+
+	/*
+	 * Disabling accounting is only relevant for some specific memcg
+	 * internal allocations. Therefore we would initially not have such
+	 * check here, since direct calls to the page allocator that are marked
+	 * with GFP_KMEMCG only happen outside memcg core. We are mostly
+	 * concerned with cache allocations, and by having this test at
+	 * memcg_kmem_get_cache, we are already able to relay the allocation to
+	 * the root cache and bypass the memcg cache altogether.
+	 *
+	 * There is one exception, though: the SLUB allocator does not create
+	 * large order caches, but rather service large kmallocs directly from
+	 * the page allocator. Therefore, the following sequence when backed by
+	 * the SLUB allocator:
+	 *
+	 * 	memcg_stop_kmem_account();
+	 * 	kmalloc(<large_number>)
+	 * 	memcg_resume_kmem_account();
+	 *
+	 * would effectively ignore the fact that we should skip accounting,
+	 * since it will drive us directly to this function without passing
+	 * through the cache selector memcg_kmem_get_cache. Such large
+	 * allocations are extremely rare but can happen, for instance, for the
+	 * cache arrays. We bring this test here.
+	 */
+	if (!current->mm || current->memcg_kmem_skip_account)
+		return true;
+
 	memcg = try_get_mem_cgroup_from_mm(current->mm);
 
 	/*
_

Patches currently in -mm which might be from glommer@gmail.com are

origin.patch
inode-convert-inode-lru-list-to-generic-lru-list-code-inode-move-inode-to-a-different-list-inside-lock.patch
list_lru-per-node-list-infrastructure-fix.patch
list_lru-per-node-list-infrastructure-fix-broken-lru_retry-behaviour.patch
list_lru-remove-special-case-function-list_lru_dispose_all.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix-dquot-isolation-hang.patch
list_lru-dynamically-adjust-node-arrays-super-fix-for-destroy-lrus.patch

