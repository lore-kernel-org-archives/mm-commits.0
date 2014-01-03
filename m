From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-memcg_size-calculation.patch removed from -mm
 tree
Date: Fri, 03 Jan 2014 12:38:00 -0800
Message-ID: <52c71fa8.d/ZodbXiu9TKOo9B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50574 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826AbaACUiB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jan 2014 15:38:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, glommer@openvz.org, bsingharora@gmail.com, vdavydov@parallels.com

Subject: [merged] memcg-fix-memcg_size-calculation.patch removed from -mm tree
To: vdavydov@parallels.com,bsingharora@gmail.com,glommer@openvz.org,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 03 Jan 2014 12:38:00 -0800


The patch titled
     Subject: memcg: fix memcg_size() calculation
has been removed from the -mm tree.  Its filename was
     memcg-fix-memcg_size-calculation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: fix memcg_size() calculation

The mem_cgroup structure contains nr_node_ids pointers to
mem_cgroup_per_node objects, not the objects themselves.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@openvz.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-fix-memcg_size-calculation mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-memcg_size-calculation
+++ a/mm/memcontrol.c
@@ -338,7 +338,7 @@ struct mem_cgroup {
 static size_t memcg_size(void)
 {
 	return sizeof(struct mem_cgroup) +
-		nr_node_ids * sizeof(struct mem_cgroup_per_node);
+		nr_node_ids * sizeof(struct mem_cgroup_per_node *);
 }
 
 /* internal only representation about the status of kmem accounting. */
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
memcg-fix-kmem_account_flags-check-in-memcg_can_account_kmem.patch
memcg-make-memcg_update_cache_sizes-static.patch
memcg-do-not-use-vmalloc-for-mem_cgroup-allocations.patch
linux-next.patch

