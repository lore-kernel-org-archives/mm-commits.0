From: akpm@linux-foundation.org
Subject: [merged]
 memcg-tcp_kmem-check-for-cg_proto-in-sock_update_memcg.patch removed from
 -mm tree
Date: Wed, 09 Sep 2015 12:45:52 -0700
Message-ID: <55f08c70.VXtUfiJ+KhGMMl+E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbbIITpx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:45:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, hannes@cmpxchg.org, tj@kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg, tcp_kmem: check for cg_proto in sock_update_memcg
has been removed from the -mm tree.  Its filename was
     memcg-tcp_kmem-check-for-cg_proto-in-sock_update_memcg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg, tcp_kmem: check for cg_proto in sock_update_memcg

sk_prot->proto_cgroup is allowed to return NULL but sock_update_memcg
doesn't check for NULL.  The function relies on the mem_cgroup_is_root
check because we shouldn't get NULL otherwise because mem_cgroup_from_task
will always return !NULL.

All other callers are checking for NULL and we can safely replace
mem_cgroup_is_root() check by cg_proto != NULL which will be more
straightforward (proto_cgroup returns NULL for the root memcg already).

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-tcp_kmem-check-for-cg_proto-in-sock_update_memcg mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-tcp_kmem-check-for-cg_proto-in-sock_update_memcg
+++ a/mm/memcontrol.c
@@ -315,8 +315,7 @@ void sock_update_memcg(struct sock *sk)
 		rcu_read_lock();
 		memcg = mem_cgroup_from_task(current);
 		cg_proto = sk->sk_prot->proto_cgroup(memcg);
-		if (!mem_cgroup_is_root(memcg) &&
-		    memcg_proto_active(cg_proto) &&
+		if (cg_proto && memcg_proto_active(cg_proto) &&
 		    css_tryget_online(&memcg->css)) {
 			sk->sk_cgrp = cg_proto;
 		}
_

Patches currently in -mm which might be from mhocko@suse.cz are


