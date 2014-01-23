From: akpm@linux-foundation.org
Subject: [folded-merged]
 memcg-rework-memcg_update_kmem_limit-synchronization-fix.patch removed from -mm tree
Date: Thu, 23 Jan 2014 15:18:58 -0800
Message-ID: <52e1a362.t5/XRqjQd4iQTzKu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37182 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaAWXS7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jan 2014 18:18:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fengguang.wu@intel.com, vdavydov@parallels.com

Subject: [folded-merged] memcg-rework-memcg_update_kmem_limit-synchronization-fix.patch removed from -mm tree
To: vdavydov@parallels.com,fengguang.wu@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 23 Jan 2014 15:18:58 -0800


The patch titled
     Subject: memcg-rework-memcg_update_kmem_limit-synchronization-fix
has been removed from the -mm tree.  Its filename was
     memcg-rework-memcg_update_kmem_limit-synchronization-fix.patch

This patch was dropped because it was folded into memcg-rework-memcg_update_kmem_limit-synchronization.patch

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg-rework-memcg_update_kmem_limit-synchronization-fix

mm/memcontrol.c: In function 'mem_cgroup_css_online':
mm/memcontrol.c:5884:5: warning: 'ret' may be used uninitialized in this
function [-Wmaybe-uninitialized]

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-rework-memcg_update_kmem_limit-synchronization-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-rework-memcg_update_kmem_limit-synchronization-fix
+++ a/mm/memcontrol.c
@@ -5226,7 +5226,7 @@ static int memcg_update_kmem_limit(struc
 
 static int memcg_propagate_kmem(struct mem_cgroup *memcg)
 {
-	int ret;
+	int ret = 0;
 	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
 
 	if (!parent)
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
memcg-do-not-use-vmalloc-for-mem_cgroup-allocations.patch
slab-clean-up-kmem_cache_create_memcg-error-handling.patch
memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path.patch
memcg-slab-clean-up-memcg-cache-initialization-destruction.patch
memcg-slab-fix-barrier-usage-when-accessing-memcg_caches.patch
memcg-fix-possible-null-deref-while-traversing-memcg_slab_caches-list.patch
memcg-slab-fix-races-in-per-memcg-cache-creation-destruction.patch
memcg-get-rid-of-kmem_cache_dup.patch
slab-do-not-panic-if-we-fail-to-create-memcg-cache.patch
memcg-slab-rcu-protect-memcg_params-for-root-caches.patch
memcg-remove-kmem_accounted_activated-flag.patch
memcg-rework-memcg_update_kmem_limit-synchronization.patch
mm-vmscan-shrink-all-slab-objects-if-tight-on-memory.patch
mm-vmscan-call-numa-unaware-shrinkers-irrespective-of-nodemask.patch
memcg-remove-unused-code-from-kmem_cache_destroy_work_func.patch

