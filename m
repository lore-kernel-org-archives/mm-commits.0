From: akpm@linux-foundation.org
Subject: [merged] memcg-use-css_get-in-sock_update_memcg.patch removed
 from -mm tree
Date: Tue, 09 Jul 2013 16:20:37 -0700
Message-ID: <51dc9ac5.EKW/UmBomL7caiGG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38949 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab3GIXUi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:20:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, hannes@cmpxchg.org, glommer@openvz.org, lizefan@huawei.com

Subject: [merged] memcg-use-css_get-in-sock_update_memcg.patch removed from -mm tree
To: lizefan@huawei.com,glommer@openvz.org,hannes@cmpxchg.org,hughd@google.com,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:20:37 -0700


The patch titled
     Subject: memcg: use css_get() in sock_update_memcg()
has been removed from the -mm tree.  Its filename was
     memcg-use-css_get-in-sock_update_memcg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Li Zefan <lizefan@huawei.com>
Subject: memcg: use css_get() in sock_update_memcg()

Use css_get/css_put instead of mem_cgroup_get/put.

Note, if at the same time someone is moving @current to a different cgroup
and removing the old cgroup, css_tryget() may return false, and
sock->sk_cgrp won't be initialized, which is fine.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Glauber Costa <glommer@openvz.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/memcontrol.c~memcg-use-css_get-in-sock_update_memcg mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-use-css_get-in-sock_update_memcg
+++ a/mm/memcontrol.c
@@ -551,15 +551,15 @@ void sock_update_memcg(struct sock *sk)
 		 */
 		if (sk->sk_cgrp) {
 			BUG_ON(mem_cgroup_is_root(sk->sk_cgrp->memcg));
-			mem_cgroup_get(sk->sk_cgrp->memcg);
+			css_get(&sk->sk_cgrp->memcg->css);
 			return;
 		}
 
 		rcu_read_lock();
 		memcg = mem_cgroup_from_task(current);
 		cg_proto = sk->sk_prot->proto_cgroup(memcg);
-		if (!mem_cgroup_is_root(memcg) && memcg_proto_active(cg_proto)) {
-			mem_cgroup_get(memcg);
+		if (!mem_cgroup_is_root(memcg) &&
+		    memcg_proto_active(cg_proto) && css_tryget(&memcg->css)) {
 			sk->sk_cgrp = cg_proto;
 		}
 		rcu_read_unlock();
@@ -573,7 +573,7 @@ void sock_release_memcg(struct sock *sk)
 		struct mem_cgroup *memcg;
 		WARN_ON(!sk->sk_cgrp->memcg);
 		memcg = sk->sk_cgrp->memcg;
-		mem_cgroup_put(memcg);
+		css_put(&sk->sk_cgrp->memcg->css);
 	}
 }
 
_

Patches currently in -mm which might be from lizefan@huawei.com are

origin.patch
linux-next.patch

