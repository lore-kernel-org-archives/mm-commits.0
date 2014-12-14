From: akpm@linux-foundation.org
Subject: [merged]
 memcg-only-check-memcg_kmem_skip_account-in-__memcg_kmem_get_cache.patch
 removed from -mm tree
Date: Sat, 13 Dec 2014 20:07:10 -0800
Message-ID: <548d0cee.DR2qHg1/KaBlBr2k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47555 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963AbaLNEHC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:07:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: only check memcg_kmem_skip_account in __memcg_kmem_get_cache
has been removed from the -mm tree.  Its filename was
     memcg-only-check-memcg_kmem_skip_account-in-__memcg_kmem_get_cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: only check memcg_kmem_skip_account in __memcg_kmem_get_cache

__memcg_kmem_get_cache can recurse if it calls kmalloc (which it does if
the cgroup's kmem cache doesn't exist), because kmalloc may call
__memcg_kmem_get_cache internally again.  To avoid the recursion, we use
the task_struct->memcg_kmem_skip_account flag.

However, there's no need checking the flag in memcg_kmem_newpage_charge,
because there's no way how this function could result in recursion, if
called from memcg_kmem_get_cache.  So let's remove the redundant code.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   28 ----------------------------
 1 file changed, 28 deletions(-)

diff -puN mm/memcontrol.c~memcg-only-check-memcg_kmem_skip_account-in-__memcg_kmem_get_cache mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-only-check-memcg_kmem_skip_account-in-__memcg_kmem_get_cache
+++ a/mm/memcontrol.c
@@ -2905,34 +2905,6 @@ __memcg_kmem_newpage_charge(gfp_t gfp, s
 
 	*_memcg = NULL;
 
-	/*
-	 * Disabling accounting is only relevant for some specific memcg
-	 * internal allocations. Therefore we would initially not have such
-	 * check here, since direct calls to the page allocator that are
-	 * accounted to kmemcg (alloc_kmem_pages and friends) only happen
-	 * outside memcg core. We are mostly concerned with cache allocations,
-	 * and by having this test at memcg_kmem_get_cache, we are already able
-	 * to relay the allocation to the root cache and bypass the memcg cache
-	 * altogether.
-	 *
-	 * There is one exception, though: the SLUB allocator does not create
-	 * large order caches, but rather service large kmallocs directly from
-	 * the page allocator. Therefore, the following sequence when backed by
-	 * the SLUB allocator:
-	 *
-	 *	memcg_stop_kmem_account();
-	 *	kmalloc(<large_number>)
-	 *	memcg_resume_kmem_account();
-	 *
-	 * would effectively ignore the fact that we should skip accounting,
-	 * since it will drive us directly to this function without passing
-	 * through the cache selector memcg_kmem_get_cache. Such large
-	 * allocations are extremely rare but can happen, for instance, for the
-	 * cache arrays. We bring this test here.
-	 */
-	if (current->memcg_kmem_skip_account)
-		return true;
