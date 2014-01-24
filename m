From: akpm@linux-foundation.org
Subject: [merged]
 memcg-remove-unused-code-from-kmem_cache_destroy_work_func.patch removed
 from -mm tree
Date: Fri, 24 Jan 2014 10:59:45 -0800
Message-ID: <52e2b821.4/YuKxcQ6DeL2TGO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43374 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaAXS7p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 13:59:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, vdavydov@parallels.com

Subject: [merged] memcg-remove-unused-code-from-kmem_cache_destroy_work_func.patch removed from -mm tree
To: vdavydov@parallels.com,hannes@cmpxchg.org,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 10:59:45 -0800


The patch titled
     Subject: memcg: remove unused code from kmem_cache_destroy_work_func
has been removed from the -mm tree.  Its filename was
     memcg-remove-unused-code-from-kmem_cache_destroy_work_func.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: remove unused code from kmem_cache_destroy_work_func

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/memcontrol.c~memcg-remove-unused-code-from-kmem_cache_destroy_work_func mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-unused-code-from-kmem_cache_destroy_work_func
+++ a/mm/memcontrol.c
@@ -3359,11 +3359,9 @@ static void kmem_cache_destroy_work_func
 	 * So if we aren't down to zero, we'll just schedule a worker and try
 	 * again
 	 */
-	if (atomic_read(&cachep->memcg_params->nr_pages) != 0) {
+	if (atomic_read(&cachep->memcg_params->nr_pages) != 0)
 		kmem_cache_shrink(cachep);
-		if (atomic_read(&cachep->memcg_params->nr_pages) == 0)
-			return;
-	} else
+	else
 		kmem_cache_destroy(cachep);
 }
 
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch

