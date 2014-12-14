From: akpm@linux-foundation.org
Subject: [merged]
 memcg-dont-check-mm-in-__memcg_kmem_get_cachenewpage_charge.patch removed
 from -mm tree
Date: Sat, 13 Dec 2014 20:06:55 -0800
Message-ID: <548d0cdf.voqhS7AHOqt7ImHu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47521 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbaLNEGr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:06:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: don't check mm in __memcg_kmem_{get_cache,newpage_charge}
has been removed from the -mm tree.  Its filename was
     memcg-dont-check-mm-in-__memcg_kmem_get_cachenewpage_charge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: don't check mm in __memcg_kmem_{get_cache,newpage_charge}

We already assured the current task has mm in memcg_kmem_should_charge,
no need to double check.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-dont-check-mm-in-__memcg_kmem_get_cachenewpage_charge mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-dont-check-mm-in-__memcg_kmem_get_cachenewpage_charge
+++ a/mm/memcontrol.c
@@ -2856,7 +2856,7 @@ struct kmem_cache *__memcg_kmem_get_cach
 	VM_BUG_ON(!cachep->memcg_params);
 	VM_BUG_ON(!cachep->memcg_params->is_root_cache);
 
-	if (!current->mm || current->memcg_kmem_skip_account)
+	if (current->memcg_kmem_skip_account)
 		return cachep;
 
 	rcu_read_lock();
@@ -2942,7 +2942,7 @@ __memcg_kmem_newpage_charge(gfp_t gfp, s
 	 * allocations are extremely rare but can happen, for instance, for the
 	 * cache arrays. We bring this test here.
 	 */
-	if (!current->mm || current->memcg_kmem_skip_account)
+	if (current->memcg_kmem_skip_account)
 		return true;
 
 	memcg = get_mem_cgroup_from_mm(current->mm);
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
linux-next.patch

