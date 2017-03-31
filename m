From: akpm@linux-foundation.org
Subject: [patch 04/11] mm: workingset: fix premature shadow node shrinking with cgroups
Date: Fri, 31 Mar 2017 15:11:52 -0700
Message-ID: <58ded428./SEfwFBSQwa3cvFH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41590 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933149AbdCaWLy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 31 Mar 2017 18:11:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@suse.com, stable@vger.kernel.org, vdavydov@tarantool.org

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: workingset: fix premature shadow node shrinking with cgroups

0a6b76dd23fa ("mm: workingset: make shadow node shrinker memcg aware")
enabled cgroup-awareness in the shadow node shrinker, but forgot to also
enable cgroup-awareness in the list_lru the shadow nodes sit on.

Consequently, all shadow nodes are sitting on a global (per-NUMA node)
list, while the shrinker applies the limits according to the amount of
cache in the cgroup its shrinking.  The result is excessive pressure on
the shadow nodes from cgroups that have very little cache.

Enable memcg-mode on the shadow node LRUs, such that per-cgroup limits are
applied to per-cgroup lists.

Fixes: 0a6b76dd23fa ("mm: workingset: make shadow node shrinker memcg aware")
Link: http://lkml.kernel.org/r/20170322005320.8165-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vladimir Davydov <vdavydov@tarantool.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>	[4.6+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/workingset.c~mm-workingset-fix-premature-shadow-node-shrinking-with-cgroups mm/workingset.c
--- a/mm/workingset.c~mm-workingset-fix-premature-shadow-node-shrinking-with-cgroups
+++ a/mm/workingset.c
@@ -532,7 +532,7 @@ static int __init workingset_init(void)
 	pr_info("workingset: timestamp_bits=%d max_order=%d bucket_order=%u\n",
 	       timestamp_bits, max_order, bucket_order);
 
-	ret = list_lru_init_key(&shadow_nodes, &shadow_nodes_key);
+	ret = __list_lru_init(&shadow_nodes, true, &shadow_nodes_key);
 	if (ret)
 		goto err;
 	ret = register_shrinker(&workingset_shadow_shrinker);
_
