From: akpm@linux-foundation.org
Subject: [merged]
 memcg-__mem_cgroup_free-remove-stale-disarm_static_keys-comment.patch
 removed from -mm tree
Date: Sat, 13 Dec 2014 20:06:53 -0800
Message-ID: <548d0cdd.TjhXD/OPM2bxD28e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47515 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbaLNEGp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:06:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: __mem_cgroup_free: remove stale disarm_static_keys comment
has been removed from the -mm tree.  Its filename was
     memcg-__mem_cgroup_free-remove-stale-disarm_static_keys-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: __mem_cgroup_free: remove stale disarm_static_keys comment

cpuset code stopped using cgroup_lock in favor of cpuset_mutex long ago.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   11 -----------
 1 file changed, 11 deletions(-)

diff -puN mm/memcontrol.c~memcg-__mem_cgroup_free-remove-stale-disarm_static_keys-comment mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-__mem_cgroup_free-remove-stale-disarm_static_keys-comment
+++ a/mm/memcontrol.c
@@ -4724,17 +4724,6 @@ static void __mem_cgroup_free(struct mem
 
 	free_percpu(memcg->stat);
 
-	/*
-	 * We need to make sure that (at least for now), the jump label
-	 * destruction code runs outside of the cgroup lock. This is because
-	 * get_online_cpus(), which is called from the static_branch update,
-	 * can't be called inside the cgroup_lock. cpusets are the ones
-	 * enforcing this dependency, so if they ever change, we might as well.
-	 *
-	 * schedule_work() will guarantee this happens. Be careful if you need
-	 * to move this code around, and make sure it is outside
-	 * the cgroup_lock.
-	 */
 	disarm_static_keys(memcg);
 	kfree(memcg);
 }
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
linux-next.patch

